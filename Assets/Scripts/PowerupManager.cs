using System;
using System.Collections.Generic;
using System.Linq;
using UnityEngine;
using System.Collections;

[Flags]
public enum PowerupType
{
    SlowTime = 1,
    Landmines = 2,
    Sniper = 4,
    RapidFire = 8,
    C4 = 16
}

public class PowerupManager : MonoBehaviour
{
    public event EventHandler<EnemyDestroyedPowerupEventArgs> OnPowerupDestroyed;
    public event EventHandler<PowerupFirstActivationEventsArgs> OnPowerupFirstActivation;

    public Transform rootPowerupsBehaviour;
    public GameObject cratePowerupPrefab;
    public GameObject powerupPredefinedLocationMarkersRoot;
	public KeyManager keyManager;
	public UIPanel hudPowerupsPanel;
    public UITexture noSecondaryWeaponAvailableTexture;
    public UITexture secondaryWeaponAvailableTexture;
    public UITexture assaultWeaponEquippedTexture;
    public UITexture assaultWeaponHolsteredTexture;
    public UILabel ammoLabel;
    public UITexture switchWeaponArrowsTexture;
    public int maxPowerupsOnScreen = 2;
    public int maxPowerupsPerWave = 10;

    private List<Vector3> PowerupPredefinedLocations { get; set; }
    private Dictionary<Vector3, CratePowerupBehaviour> ContainersOnScreen { get; set; }
    private Dictionary<PowerupType, BasePowerup> Powerups { get; set; }
    private Dictionary<PowerupType, SpecialPowerup> SpecialPowerups { get; set; }
    private Dictionary<PowerupType, WeaponPowerup> WeaponPowerups { get; set; }
    private PlayerBehaviour player;
    private Dictionary<PowerupType, BasePowerup> ActivatedPowerups { get; set; }
    private PowerupType activatedPowerupsOnce = 0;

    private int powerupsDroppedForWave;

    public bool CanPlayerType()
    {
        return ActivatedPowerups.All(powerup => powerup.Value.canPlayerTypeWhileActivated);
    }
 
    private IEnumerator Start()
    {
        ActivatedPowerups = new Dictionary<PowerupType, BasePowerup>();
        player = GameObject.FindWithTag("Player").GetComponent<PlayerBehaviour>();
        ContainersOnScreen = new Dictionary<Vector3, CratePowerupBehaviour>();

        // Hide the assault weapon holstered textured because the player starts with the assault weapon equipped
        assaultWeaponHolsteredTexture.enabled = false;

        secondaryWeaponAvailableTexture.enabled = false;
        noSecondaryWeaponAvailableTexture.enabled = true;

        Powerups = new Dictionary<PowerupType, BasePowerup>();
        SpecialPowerups = new Dictionary<PowerupType, SpecialPowerup>();
        WeaponPowerups = new Dictionary<PowerupType, WeaponPowerup>();

        foreach (Transform powerupTransform in rootPowerupsBehaviour)
        {
            var powerup = powerupTransform.GetComponent<BasePowerup>();
            var type = powerup.PowerType;

            Powerups.Add(type, powerup);

            var specialPowerup = powerup as SpecialPowerup;
            if (specialPowerup != null)
            {
                SpecialPowerups.Add(type, specialPowerup);
            }

            var weaponPowerup = powerup as WeaponPowerup;
            if (weaponPowerup != null)
            {
                WeaponPowerups.Add(type, weaponPowerup);
                weaponPowerup.OnAmmoOver += (sender, args) =>
                {
                    noSecondaryWeaponAvailableTexture.enabled = true;
                    secondaryWeaponAvailableTexture.enabled = false;
                    assaultWeaponEquippedTexture.enabled = true;
                    assaultWeaponHolsteredTexture.enabled = false;
                };
            }
        }

        // Order the powerups by the way they will appear on the HUD
        // powerups = powerups.OrderBy(powerup => powerup.NumberKeyActivation).ToList();

        PowerupPredefinedLocations = (from Transform usedPosition in powerupPredefinedLocationMarkersRoot.transform select usedPosition.position).ToList();

        Messenger.instance.Listen("game", gameObject);
        keyManager.NumberPressed += OnNumberPressed;

        foreach (var powerup in Powerups)
        {
            powerup.Value.PowerupActivated += (o, e) => ActivatedPowerups.Add(e.DeactivatedPowerup.PowerType, e.DeactivatedPowerup);
            powerup.Value.PowerupDeactivated += (o, e) => ActivatedPowerups.Remove(e.DeactivatedPowerup.PowerType);
        }

        yield return null;
    }

    public IEnumerator StartDroppingPowerups()
    {
        while (true)
        {
            if (powerupsDroppedForWave > maxPowerupsPerWave || ContainersOnScreen.Count >= maxPowerupsOnScreen)
            {
                yield return null;
                continue;
            }

            var intervalBeforeNext = UnityEngine.Random.Range(8, 10);
            yield return new WaitForSeconds(intervalBeforeNext);
            //yield return new WaitForSeconds(5);
            DropPowerupContainer();

            powerupsDroppedForWave++;
        }
    }

    public void ResetPowerupCounter()
    {
        powerupsDroppedForWave = 0;
    }

    public bool WillKeyMatchOnScreenPowerupContainers(char key)
    {
        return ContainersOnScreen.Values.Any(container => container.WillKeyMatch(key));
    }

    void RotateSwitchArrows()
    {
        var z = switchWeaponArrowsTexture.transform.rotation.z;
        var desPosition = z - 180;
        StartCoroutine(HomelessMethods.Interpolate(z, desPosition, 0.5f, InterpolationMethods.Lerp, f =>
        {
            var eulerAngles = switchWeaponArrowsTexture.transform.rotation.eulerAngles;
            switchWeaponArrowsTexture.transform.rotation = Quaternion.Euler(eulerAngles.x, eulerAngles.y, f);
        }, () =>
        {
            var eulerAngles = switchWeaponArrowsTexture.transform.rotation.eulerAngles;
            switchWeaponArrowsTexture.transform.rotation = Quaternion.Euler(eulerAngles.x, eulerAngles.y, desPosition);
        }));
    }

    private void Update()
    {
        if (Time.timeScale == 0)
        {
            // We don't want to do anything while the game is paused
            return;
        }

        if (Input.GetKeyDown(KeyCode.Tab))
        {
            OnTabPressed();
        }

        var equippedWeapon = WeaponPowerups.Values.FirstOrDefault(weapon => weapon.Equipped);
        var holsteredWeapon = WeaponPowerups.Values.FirstOrDefault(weapon => weapon.CurrentlyAvailable);
        if (equippedWeapon != null)
        {
            ammoLabel.text = equippedWeapon.Ammo.ToString();
        }
        else if (holsteredWeapon != null)
        {
            ammoLabel.text = holsteredWeapon.Ammo.ToString();
        } else
        {
            ammoLabel.text = "00";
        }
    }

    public void DeactivatePowerups()
    {
        foreach (var powerup in Powerups.Values)
        {
            StartCoroutine(powerup.Deactivate());
            powerup.ResetLevel();
        }
    }

    public void DropPowerupContainer()
    {
        // If there are no available positions on screen, don't drop a powerup
        var position = GetAvailablePosition();
        if (position == null)
        {
            return;
        }


        // If there are no distinct powerups left, don't drop a powerup.
        var behaviour = GetPowerupBasedOnWeight();
        if (behaviour == null)
        {
            return;
        }

        var powerup = CreatePowerupCrate(position.Value);
        var crateContainer = powerup.GetComponent<CratePowerupBehaviour>();
        crateContainer.OnEnemyDestroyedPowerup += OnEnemyDestroyedPowerup;

        crateContainer.SetWords(behaviour);

        ContainersOnScreen.Add(position.Value, crateContainer);
    }

    private void OnTabPressed()
    {
        if (player.CurrentState != PlayerStates.Playing)
        {
            return;
        }

        // If we have an equipped weapon powerup, we need to holster it
        var equippedWeapon = WeaponPowerups.Values.FirstOrDefault(weaponPowerup => weaponPowerup.Equipped);
        if (equippedWeapon != null)
        {
            StartRotatingWeaponSwitchArrows();
            
            equippedWeapon.HolsterWeapon();

            assaultWeaponHolsteredTexture.enabled = false;
            assaultWeaponEquippedTexture.enabled = true;
            return;
        }

        // If we're here, then we're switching from the default assault weapon to some other holstered weapon powerup
        var equippableWeapon = WeaponPowerups.Values.FirstOrDefault(weaponPowerup => weaponPowerup.CurrentlyAvailable);
        if (equippableWeapon == null)
        {
            // No weapon is currently available for equipping
            return;
        }
        
        if (!equippableWeapon.CanActivate)
        {
            return;
        }

        StopRotatingWeaponSwitchArrows();

        // Holster the assault weapon
        assaultWeaponHolsteredTexture.enabled = true;
        assaultWeaponEquippedTexture.enabled = false;

        // We have a weapon we can equip!
        equippableWeapon.Equip();
    }

    /// <summary>
    /// A number has been pressed from the keyboard
    /// </summary>
    private void OnNumberPressed(object sender, NumberKeyPressedEventArgs e)
    {
        if (Time.timeScale == 0)
        {
            // Ignore number presses while the game is paused
            return;
        }

        var number = e.Number;
        if (number == 0)
        {
            number = 10;
        }

        //// The special powerups are activated using the number keys
        var powerup = SpecialPowerups.Values.FirstOrDefault(p => p.NumberKeyActivation == number);
        if (powerup == null)
        {
            // There's no powerup mapped to this number
            return;
        }

        if (powerup.CurrentLevel == 0)
        {
            // The player doesn't have this powerup available
            return;
        }

        // The player has the powerup, so we need to activate it!
        ActivatePowerup(powerup);
    }

    private void StopRotatingWeaponSwitchArrows()
    {
        CancelInvoke("RotateSwitchArrows");
    }

    private void StartRotatingWeaponSwitchArrows()
    {
        StopRotatingWeaponSwitchArrows();
        InvokeRepeating("RotateSwitchArrows", 3f, 3);
    }

    /// <summary>
    /// Invoked when the player types the word for a powerup container
    /// </summary>
    /// <param name="messagePowerupTyped"></param>
    private void _PowerupTyped(MessagePowerupTyped messagePowerupTyped)
    {
        // If the powerup still has remaining words to be typed, use the next word now and dont destroy the powerup
        if (!messagePowerupTyped.WasPowerupDestroyed)
        {
            messagePowerupTyped.CratePowerup.UseNextWord();
            return;
        }

        var powerupBehaviour = messagePowerupTyped.CratePowerup.PowerupBehaviour;
        var powerup = Powerups[powerupBehaviour.PowerType];


        var weaponPowerup = powerup as WeaponPowerup;
        if (weaponPowerup != null)
        {
            StartRotatingWeaponSwitchArrows();

            // Hide the 'no weapon' texture and faded 'Tab'
            noSecondaryWeaponAvailableTexture.enabled = false;

            // Show the highlited 'Tab' texture
            secondaryWeaponAvailableTexture.enabled = true;

            foreach (var wp in WeaponPowerups.Values)
            {
                if (wp == weaponPowerup)
                {
                    wp.MakeAvailable();
                    continue;
                }

                wp.Discard();
            }
        }

        if ((activatedPowerupsOnce & powerup.PowerType) == 0)
        {
                if (OnPowerupFirstActivation != null)
                {
                    OnPowerupFirstActivation(this, new PowerupFirstActivationEventsArgs(powerup));
                }
        }

        activatedPowerupsOnce |= powerup.PowerType;
        audio.PlayOneShot(powerup.collectAudio);

        // TODO: the player needs to shoot before the crate explodes
        // Blow up the crate
        StartCoroutine(messagePowerupTyped.CratePowerup.Deactivate(PowerupContainerDestroyedReason.PlayerTypedWord, powerup.IncrementLevel));

        ContainersOnScreen.Remove(messagePowerupTyped.CratePowerup.transform.position);
    }

    private void ActivatePowerup(BasePowerup powerup)
    {
        var powerupToStart = powerup.PowerType;
        var allowedToActivate = true;

        foreach (var activatedPowerup in ActivatedPowerups.Values)
        {
            allowedToActivate = (activatedPowerup.DoesntWorkWith & powerupToStart) != powerupToStart;
            if (!allowedToActivate)
            {
                break;
            }
        }

        allowedToActivate = allowedToActivate && powerup.CanActivate;

        if (!allowedToActivate)
        {
            return;
        }


        // Activate the powerup!
        StartCoroutine(powerup.Activate());

        // Set the powerup's level to 0
        powerup.ResetLevel();
    }

    private Vector3? GetAvailablePosition()
    {
        if (ContainersOnScreen.Count == PowerupPredefinedLocations.Count)
        {
            // no space
            return null;
        }

        PowerupPredefinedLocations.Shuffle();
        for (int locationIndex = 0; locationIndex < PowerupPredefinedLocations.Count; locationIndex++)
        {
            var location = PowerupPredefinedLocations[locationIndex];
            if (!ContainersOnScreen.ContainsKey(location))
            {
                return location;
            }
        }

        throw new Exception("Something's wrong...");
    }

    private void OnEnemyDestroyedPowerup(object sender, EnemyDestroyedPowerupEventArgs e)
    {
        if (OnPowerupDestroyed != null)
        {
            ContainersOnScreen.Remove(e.CratePowerupBehaviour.transform.position);
            OnPowerupDestroyed(this, e);
        }
    }

    private GameObject CreatePowerupCrate(Vector3 position)
    {
        var powerup = (GameObject)Instantiate(cratePowerupPrefab, position, cratePowerupPrefab.transform.rotation);

        return powerup;
    }

    private BasePowerup GetPowerupBasedOnWeight()
    {
        var currentWave = GameStatistics.Instance.CurrentLevel.WavesCompleted + 1;

        // First filter the powerups based on the wave they are activated
        List<BasePowerup> availablePowerups = Powerups.Values.Where(powerup => powerup.activatedInWaveNumber <= currentWave).ToList();

        // Next get the ones which are currently available
        availablePowerups = availablePowerups.Where(p => ContainersOnScreen.All(c => c.Value.PowerupBehaviour.wordToUse != p.wordToUse)).ToList();

        // Check if we have a powerup that's new for the current wave.
        var newPowerupForThisWave = availablePowerups.FirstOrDefault(powerup => currentWave == powerup.activatedInWaveNumber);
        if (newPowerupForThisWave != null)
        {
            // We found a powerup which is introduced in this wave.
            // Now we check if it has already been activated
            //Debug.Log((activatedPowerupsOnce & newPowerupForThisWave.PowerType));
            if ((activatedPowerupsOnce & newPowerupForThisWave.PowerType) != newPowerupForThisWave.PowerType)
            {
                // This new powerup hasn't get been activated, so use this one.
                availablePowerups = new List<BasePowerup> {newPowerupForThisWave};
            }
        }

        if (availablePowerups.Count == 0)
        {
            return null;
        }

        return availablePowerups.Select(powerup => (IWeighable)powerup).GetRandomWeightedElement<BasePowerup>();
    }
}
