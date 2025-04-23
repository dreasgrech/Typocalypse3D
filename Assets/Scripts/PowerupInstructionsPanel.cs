using System;
using System.Collections.Generic;
using System.Linq;
using UnityEngine;
using System.Collections;

public class PowerupInstructionsPanel : MonoBehaviour
{
    public bool Active { get; private set; }
    public UITexture titleTexture;
    public UITexture instructionsTexture;
    public Transform rootPowerupsBehaviour;

    public Texture powerupUnlockedTexture;
    public Texture weaponUnlockedTexture;
    public AudioManager audioManager;
    public GrayscaleEffect grayscaleEffect;
    public UIPanel enemiesWords;
    public UIPanel mainHUDPanel;
    public UIPanel powerupsHUDPanel;
    public UITexture powerupBoxesTexture;
    public SlowTimePowerup slowtimePowerup;

    private Dictionary<PowerupType, BasePowerup> powerups;
    private UIPanel panel;
    private bool activatedAtLeastOnePowerup = false;

    private void Start()
    {
        panel = GetComponent<UIPanel>();
        panel.alpha = 0;
        powerups = (from Transform powerupBehaviour in rootPowerupsBehaviour select powerupBehaviour.GetComponent<BasePowerup>()).ToDictionary(powerup => powerup.PowerType, powerup => powerup);
    }

    public IEnumerator ShowPanel(PowerupType powerupType, Action callback = null)
    {
        while (slowtimePowerup.Active)
        {
            yield return null;
        }

        Active = true;

        var powerup = powerups[powerupType];
        instructionsTexture.mainTexture = powerup.instructionsOverlayTexture;
        titleTexture.mainTexture = powerup is WeaponPowerup ? weaponUnlockedTexture : powerupUnlockedTexture;

        var time = 1f;
        grayscaleEffect.enabled = true;
        iTween.ValueTo(gameObject, iTween.Hash("from", 0f, "to", 1f, "time", time, "onUpdate", "FadingIn", "ignoretimescale", true));
        iTween.ValueTo(gameObject, iTween.Hash("from", 1f, "to", 0f, "time", time, "onUpdate", "FadingOut", "ignoretimescale", true));
        if (powerupType == PowerupType.Sniper)
        {
            iTween.ValueTo(gameObject, iTween.Hash("from", 1f, "to", 0f, "time", time, "onUpdate", (Action<object>) (value =>
            {
                powerupsHUDPanel.alpha = (float) value;
            }), "ignoretimescale", true));
        }
        iTween.ValueTo(gameObject, iTween.Hash("from", 1f, "to", 0f, "time", time, "onUpdate", "FadingOut", "ignoretimescale", true));

        while (!Input.GetKeyDown(KeyCode.Space))
        {
            yield return null;
        }

        if (!activatedAtLeastOnePowerup && powerupType != PowerupType.Sniper)
        {
            iTween.ValueTo(gameObject, iTween.Hash("from", 0f, "to", 1f, "time", time, "onUpdate", (Action<object>) (value =>
            {
                powerupBoxesTexture.alpha = (float) value;
            }), "ignoretimescale", true));

            activatedAtLeastOnePowerup = true;
        }

        iTween.ValueTo(gameObject, iTween.Hash("from", 0f, "to", 1f, "time", time, "onUpdate", "FadingOut", "ignoretimescale", true));
        iTween.ValueTo(gameObject, iTween.Hash("from", 1f, "to", 0f, "time", time, "onUpdate", "FadingIn", "ignoretimescale", true));
        if (powerupType == PowerupType.Sniper)
        {
            iTween.ValueTo(gameObject, iTween.Hash("from", 0f, "to", 1f, "time", time, "onUpdate", (Action<object>) (value =>
            {
                powerupsHUDPanel.alpha = (float) value;
            }), "ignoretimescale", true));
        }

        yield return new WaitForSeconds(1);
        Active = false;

        if (callback != null)
        {
            callback();
        }
    }

    void FadingOut(float value)
    {
        enemiesWords.alpha = value;
        Time.timeScale = value;
        audioManager.AdjustPitch(value);
        mainHUDPanel.alpha = value;
    }

    void FadingIn(float value)
    {
        panel.alpha = value;
        grayscaleEffect.effectAmount = value;
    }
}
