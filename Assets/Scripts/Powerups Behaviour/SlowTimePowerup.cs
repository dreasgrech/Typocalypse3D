using System;
using UnityEngine;
using System.Collections;

public class SlowTimePowerup : SpecialPowerup
{
    public override PowerupType PowerType { get { return PowerupType.SlowTime; } }

    public override PowerupType DoesntWorkWith
    {
        get { return PowerupType.RapidFire; }
    }

    public override int MaxLevels { get { return 3; } }
    public override int NumberKeyActivation { get { return 1; } }
    public override bool CanActivate { get { return !powerupInstructionsPanel.Active; } }

    /// <summary>
    /// The value to which the timescale will be dropped
    /// </summary>
    public float fluctuateTo = 0.5f;

    /// <summary>
    /// The time for which the powerup is active basically
    /// </summary>
    public float fluctuatedSeconds;

    public float startFluctuationSeconds = 0.3f;
    public float endFluctuationSeconds;
    public GrayscaleEffect grayscaleEffect;
    public MotionBlur motionBlur;
    public Vignetting vignetting;
    public PowerupInstructionsPanel powerupInstructionsPanel;
    public UIPanel clockPanel;

    private AudioManager audioManager;

    private void Start()
    {
        audioManager = (AudioManager) FindObjectOfType(typeof (AudioManager));
    }

    public override IEnumerator Activate()
    {
        InvokePowerupActivatedEvent();
        yield return StartCoroutine(FluctuateTime(fluctuateTo, GetFluctuatedTime(), startFluctuationSeconds, endFluctuationSeconds,() => StartCoroutine(Deactivate())));
    }

    public override IEnumerator Deactivate()
    {
        StopAllCoroutines();
        Time.timeScale = 1;
        audioManager.AdjustPitch(1f);
        InvokePowerupDeactivatedEvent();
        yield return null;
    }

    public void FadingIn(float value)
    {
        vignetting.chromaticAberration = value;
        grayscaleEffect.effectAmount = value;
        motionBlur.blurAmount = value;
    }

    public IEnumerator FluctuateTime(float fluctuateToAmount, float seconds, float timeToFluctuate, float timeToUnfluctuate, Action finishedCallback = null)
    {
        motionBlur.enabled = true;

        // Fade in the clock
        var clockMaxAlpha = 0.5f;
        iTween.ValueTo(gameObject, iTween.Hash("from", 0f, "to", clockMaxAlpha, "time", 0.3f, "onUpdate", (Action<object>) (t =>
        {
            clockPanel.alpha = (float) t;
        }), "onComplete", (Action<object>) (t2 =>
        {
            Debug.Log("Fading out the clock");

            // Fade out the clock
            iTween.ValueTo(gameObject, iTween.Hash("from", clockMaxAlpha, "to", 0f, "time", 3f, "onUpdate", (Action<object>) (t3 =>
            {
                clockPanel.alpha = (float) t3;
            }), "ignoretimescale", true));
        }), "ignoretimescale", true));

        iTween.ValueTo(gameObject, iTween.Hash("from", 0f, "to", 1f, "time", timeToFluctuate, "onUpdate", "FadingIn", "ignoretimescale", true));
	    StartCoroutine(HomelessMethods.Interpolate(1f, fluctuateToAmount, timeToFluctuate, InterpolationMethods.Lerp, d =>
	                                                                                             {
	                                                                                                 Time.timeScale = d;
                                                                                                     audioManager.AdjustPitch(d, true);
	                                                                                             }));
	    //yield return new WaitForSeconds((fluctuatedSeconds * fluctuateToAmount) * (CurrentLevel * 0.8f));
        audio.Play();
        var slowtimeEndTime = Time.realtimeSinceStartup + seconds;
        while(Time.realtimeSinceStartup < slowtimeEndTime)
        {
            yield return 0;
        }

	    //yield return new WaitForSeconds(seconds);
        //iTween.ValueTo(gameObject, iTween.Hash("from", 1f, "to", 0f, "time", timeToUnfluctuate, "onUpdate", "FadingIn", "ignoretimescale", true));
        iTween.ValueTo(gameObject, iTween.Hash("from", 1f, "to", 0f, "time", timeToUnfluctuate, "onUpdate", (Action<object>) (t =>
        {
            var current = (float) t;
            grayscaleEffect.effectAmount = current;
            vignetting.chromaticAberration = current;
            motionBlur.blurAmount = current;
        }), "ignoretimescale", true));
	    StartCoroutine(HomelessMethods.Interpolate(fluctuateToAmount, 1f, timeToUnfluctuate, InterpolationMethods.Lerp, d =>
	                                                                                             {
	                                                                                                 Time.timeScale = d;
                                                                                                     audioManager.AdjustPitch(d, true);
	                                                                                             }, finishedCallback));
        
    }

    private float GetFluctuatedTime()
    {
        const float max = 7f;
        switch (CurrentLevel)
        {
            case 1: return 2f;
            case 2: return 4f;
            case 3: return max;
        }

        return max;
    }
}
