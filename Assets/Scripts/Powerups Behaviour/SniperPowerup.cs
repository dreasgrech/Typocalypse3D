using System;
using System.Collections.Generic;
using System.Globalization;
using System.Linq;
using UnityEngine;
using System.Collections;

public class SniperPowerup : WeaponPowerup
{
    /*
     * TODO: The HUD must be hidden while in sniper mod
     * TODO: Blood should come out where you click on the enemy
     * TODO: Zoom levels using the camera's FOV (and sound)
     * TODO: Shooting a landmine makes it explode haha!
     */

    public Camera mainCamera;
    public Camera sniperCamera;
    public Transform mainCameraPowerupPosition;
    public UIPanel hudPanel;
    public AudioClip sniperScopeSwitchAudio;
    public UITexture sniperScopeTexture;
    public float maxZoomLevel = 2;
    public int ammoPerLevel = 2;
    public float reloadTimeSeconds = 0.5f;
    public UIPanel enemiesWordsHUD;
    public UIPanel enemiesScoresHUD;
    public GameObject player;
    public UILabel sniperAmmoLabel;
    public PowerupInstructionsPanel powerupInstructionsPanel;

    public override bool CanActivate
    {
        get { return !powerupInstructionsPanel.Active; }
    }

    public override PowerupType PowerType { get { return PowerupType.Sniper; } }

    public override PowerupType DoesntWorkWith
    {
        get { return PowerupType.RapidFire; }
    }

    public override int MaxLevels { get { return 3; } }

    public AnimationCurve recoil;

    private const float cameraNoZoomFOV = 60; // The default FOV
    private const float cameraFOVLevelIncease = 20; // The delta fov that's added when zooming
    private int currentCameraZoomLevel = 0;
    private bool activated;
    private bool areWeReloading;
    private MouseLook sniperCameraMouseLook;

    private IEnumerable<GameObject> playerObjects;

	// Use this for initialization
	void Start ()
	{
	    playerObjects = player.GetComponentsInChildren<SkinnedMeshRenderer>().Select(c => c.gameObject).Concat(player.GetComponentsInChildren<MeshRenderer>().Select(c => c.gameObject));
	    sniperCamera.enabled = false;
	    sniperScopeTexture.enabled = false;
        sniperAmmoLabel.enabled = false;
	    sniperCameraMouseLook = sniperCamera.GetComponent<MouseLook>();
	}
	
    List<ISniperPowerupClickable> lastTargetsOnScreen = new List<ISniperPowerupClickable>();
    List<ISniperPowerupClickable> currentTargetsOnScreen = new List<ISniperPowerupClickable>();

	void Update () {
        if (Time.timeScale == 0 || !activated)
        {
            return;
        }

        // Hide the enemy words on screen
        enemiesWordsHUD.alpha = 0;
        enemiesScoresHUD.alpha = 0;

	    currentTargetsOnScreen.Clear();
	    GetObjectsinSight((target, raycastHit) =>
	    {
	        currentTargetsOnScreen.Add(target);
	        target.ChangeCelShadingEffect(Color.red, Color.red);
	    });

        foreach (var lastTargetOnScreen in lastTargetsOnScreen)
        {
            if (!currentTargetsOnScreen.Contains(lastTargetOnScreen))
            {
                lastTargetOnScreen.ChangeCelShadingEffect(Color.black, null);
            }
        }

        lastTargetsOnScreen = new List<ISniperPowerupClickable>(currentTargetsOnScreen);

        if (Input.GetButtonDown("Fire1"))
        {
            if (Ammo == 0 || areWeReloading)
            {
                // We can't shoot if we're reloading or we don't have any ammo
                return;
            }

            Ammo--;
            audio.Play();

            //iTween.ShakePosition(sniperCamera.gameObject, new Vector3(0.3f, 0.3f, 0), 0.5f);
            /*
        var start = sniperCamera.transform.position.y;
        Debug.Log(recoil.length);
        StartCoroutine(HomelessMethods.Interpolate(0f, 1f,5f, InterpolationMethods.Lerp, f =>
        {
            //var eval = teapotCurve.Evaluate(Time.realtimeSinceStartup);
            var eval = recoil.Evaluate(f);
            var y = sniperCamera.transform.position.y;
            sniperCamera.transform.localPosition = sniperCamera.transform.position.ReplaceY(start + eval);
        }));
            */

            int totalKilledByShot = 0;
            GetObjectsinSight((target, raycastHit) =>
            {
                    var enemy = target as EnemyBehaviour;
                    if (enemy != null)
                    {
                        totalKilledByShot++;
                    }
                    
                    // We hit something!
                    target.HitBySniperPowerup(raycastHit.point);
            });


            var collateralText = GetCollateralText(totalKilledByShot);
            if (!String.IsNullOrEmpty(collateralText))
            {
                Debug.Log(collateralText);
            }

            if (Ammo == 0)
            {
                // Powerup over!
                OnAmmoFinished();
                return;
            }

            areWeReloading = true;
            Invoke("StopReloading", reloadTimeSeconds);
        }

	    var mouseScroll = Input.GetAxis("Mouse ScrollWheel"); // 0.1 -> upwards, -0.1 -> downwards
        if (mouseScroll != 0)
        {
            int newZoomLevel = Convert.ToInt32(Mathf.Clamp(currentCameraZoomLevel + (mouseScroll > 0 ? 1 : -1), 0, maxZoomLevel));
            SetZoomLevel(newZoomLevel, true);
        }
	}

    private void GetObjectsinSight(Action<ISniperPowerupClickable, RaycastHit> callback)
    {
        var cam = sniperCamera.transform;
        var hit = Physics.RaycastAll(cam.position, cam.forward); // raycast all so that the sniper rips through everything
        foreach (var raycastHit in hit)
        {
            var hitSomething = GetComponentUpwards<ISniperPowerupClickable>(raycastHit.transform);
            if (hitSomething != null)
            {
                callback(hitSomething, raycastHit);
            }
        }
    }

    private string GetCollateralText(int killed)
    {
        if (killed <= 1)
        {
            return null;
        }

        string combo = null;
        if (killed >= 4)
        {
            combo = "Multi";
        }
        else if(killed == 2)
        {
            combo = "Double";
        }
        else if(killed == 3)
        {
            combo = "Triple";
        }

        return String.Format("{0} Collateral Shot", combo);
    }

    private void SetZoomLevel(int zoomLevel, bool makeClickSound)
    {
        if (zoomLevel != currentCameraZoomLevel)
        {
            if (makeClickSound)
            {
                audio.PlayOneShot(sniperScopeSwitchAudio);
            }

            currentCameraZoomLevel = zoomLevel;
            sniperCamera.fieldOfView = cameraNoZoomFOV - (currentCameraZoomLevel*cameraFOVLevelIncease);
        }
    }

    private void StopReloading()
    {
        areWeReloading = false;
    }

    private T GetComponentUpwards<T>(Transform currentTransform) where T : class
    {
        var component = currentTransform.GetCustomComponent<T>();
        if (component != null)
        {
            return component;
        }

        if (currentTransform.parent != null)
        {
            return GetComponentUpwards<T>(currentTransform.parent);
        }

        return null;
    }

    public override IEnumerator Activate()
    {
        InvokePowerupActivatedEvent();

        sniperCameraMouseLook.Reset();
        activated = true;

        SetZoomLevel(0, false);

        sniperAmmoLabel.text = Ammo.ToString(CultureInfo.InvariantCulture);
        sniperAmmoLabel.enabled = true;
        ShowHidePlayer(false);
        sniperScopeTexture.enabled = true;
        mainCamera.enabled = false;
        sniperCamera.transform.rotation = Quaternion.identity;
        sniperCamera.enabled = true;
        hudPanel.enabled = false;

        // Lock the cursor in game
        Screen.lockCursor = true;

        yield return null;
    }

    public override IEnumerator Deactivate()
    {
        if (Ammo == 0)
        {
            yield return new WaitForSeconds(0.4f);
        }

        activated = false;

        // Show the enemy words on screen
        enemiesWordsHUD.alpha = 1;
        enemiesScoresHUD.alpha = 1;
        hudPanel.enabled = true;

        ShowHidePlayer(true);
        sniperAmmoLabel.enabled = false;
        mainCamera.enabled = true;
        sniperCamera.enabled = false;
        sniperScopeTexture.enabled = false;

        foreach (var lastTargetOnScreen in lastTargetsOnScreen)
        {
            lastTargetOnScreen.ChangeCelShadingEffect(Color.black, null);
        }

        InvokePowerupDeactivatedEvent();
        yield return null;
    }

    protected override void IncreaseAmmo()
    {
        Ammo += ammoPerLevel;
    }

    private void ShowHidePlayer(bool show)
    {
	    foreach (var playerObject in playerObjects)
	    {
	        playerObject.SetActive(show);
	    }
    }
}
