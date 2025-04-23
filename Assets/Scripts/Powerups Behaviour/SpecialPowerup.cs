
using System;
using UnityEngine;

public abstract class WeaponPowerup : BasePowerup
{
    // powerActiveTexture for a WeaponPowerup is the image is shown
    // when the player has the weapon but it's not equipped

    public event EventHandler<EventArgs> OnAmmoOver;

    public UITexture equippedTexture;

    public int Ammo { get; set; }
    public bool Equipped { get; set; }

    /// <summary>
    /// True if the weapon can currently be equipped
    /// </summary>
    public bool CurrentlyAvailable { get; set; }

    protected abstract void IncreaseAmmo();

    void Awake()
    {
        FadeActiveTexture(0f, true);
        FadeTexture(equippedTexture, 0f, true);
    }

    public override void IncrementLevel()
    {
        base.IncrementLevel();
        IncreaseAmmo();
    }

    public void MakeAvailable()
    {
        CurrentlyAvailable = true;
        FadeActiveTexture(1f, true);
    }

    public void HolsterWeapon()
    {
        CurrentlyAvailable = true;
        Equipped = false;

       // Uneqip the weapon
       FadeTexture(equippedTexture, 0f, true);

       // Put the weapon back in the holster
       FadeActiveTexture(1f, true);

       StartCoroutine(Deactivate());
    }

    protected override void SetHUDLevel(int nextLevel)
    {
        // TODO: increase the ammo depending on the level
        FadeActiveTexture(1f, true);
    }

    protected void OnAmmoFinished()
    {
        OnAmmoOver(this, EventArgs.Empty);

        // Deactivates the effects of this weapons (like scope view for sniper etc...)
        StartCoroutine(Deactivate());

        // Discard the weapon
        Discard();
    }

    public void Equip()
    {
        // Do jack shit if we don't have any ammo
        /*
        if (Ammo == 0)
        {
            Debug.Log("We have no ammo, so we can't equip");
            return;
        }
        */

        CurrentlyAvailable = false;
        Equipped = true;

        FadeTexture(equippedTexture, 1f, true);
        FadeActiveTexture(0f, true);
        StartCoroutine(Activate());
    }

    public void Discard()
    {
        CurrentlyAvailable = false;
        Equipped = false;
        FadeTexture(equippedTexture, 0f, true);
        FadeActiveTexture(0f, true);
    }
}

public abstract class SpecialPowerup : BasePowerup
{
    public UIPanelSlider panelSlider;
    public abstract int NumberKeyActivation { get; }

    private const float step = 4.85f;

    void Awake()
    {
        FadeActiveTexture(0f, true);
    }

    /// <summary>
    /// Using 0 for the level will deactivate the powerup
    /// </summary>
    /// <param name="nextLevel"></param>
    protected override void SetHUDLevel(int nextLevel)
    {
        if (nextLevel > MaxLevels)
        {
            return;
        }
        
        if (nextLevel == 0)
        {
            // Deactivating powerup icon from HUD
            FadeActiveTexture(0f);
            panelSlider.JumpSlider(0);
            return;
        }

        if (CurrentLevel == 0)
        {
            FadeActiveTexture(1f);
        }

        var sliderValue = (float)nextLevel/MaxLevels;

        if (panelSlider != null)
        {
            panelSlider.MoveByDelta(step * nextLevel, true);
        }
    }
}