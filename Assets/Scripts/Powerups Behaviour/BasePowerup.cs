using System;
using UnityEngine;
using System.Collections;

public abstract class BasePowerup : MonoBehaviour, IWeighable {

    public float weight;
    public int activatedInWaveNumber;
    public Texture2D hudTexture;
    public UITexture powerupActiveTexture;
    public Texture instructionsOverlayTexture;
    public int score;
    public string wordToUse;
    public Vector2 iconCenterPosition;
    public AudioClip collectAudio;
    public bool canPlayerTypeWhileActivated;

    public event EventHandler<PowerupDeactivatedEventArgs> PowerupDeactivated;
    public event EventHandler<PowerupDeactivatedEventArgs> PowerupActivated;

    public Texture2D HUDTexture { get { return hudTexture; } }
    public float Weight { get { return weight; } }

    public int CurrentLevel { get; set; }
    public int CurrentTotalCollectedLevels { get; set; }
    public bool Active { get; private set; }
    public abstract bool CanActivate { get; }
    public abstract PowerupType PowerType { get; }
    public abstract PowerupType DoesntWorkWith { get; }
    public abstract int MaxLevels { get; }

    public abstract IEnumerator Activate();
    public abstract IEnumerator Deactivate();

    protected void InvokePowerupDeactivatedEvent()
    {
        Active = false;
       if (PowerupDeactivated != null)
       {
           PowerupDeactivated(this, new PowerupDeactivatedEventArgs(this));
       }
    }

    protected void InvokePowerupActivatedEvent()
    {
        Active = true;
        if (PowerupActivated != null)
        {
            PowerupActivated(this, new PowerupDeactivatedEventArgs(this));
        }
    }

    public virtual void IncrementLevel()
    {
        var newLevel = Mathf.Clamp(CurrentLevel + 1, 1, MaxLevels);
        SetHUDLevel(newLevel);
        CurrentLevel = newLevel;
        CurrentTotalCollectedLevels++;
    }

    public void ResetLevel()
    {
        SetHUDLevel(0);
        CurrentLevel = 0;
        CurrentTotalCollectedLevels = 0;
    }

    protected abstract void SetHUDLevel(int nextLevel);

    protected void FadeActiveTexture(float alpha, bool instant = false)
    {
        FadeTexture(powerupActiveTexture, alpha, instant);
    }

    protected void FadeTexture(UITexture texture, float alpha, bool instant = false)
    {
        if (instant)
        {
            texture.color = texture.color.ChangeAlpha(alpha);
            return;
        }

        var color = texture.color;
        StartCoroutine(HomelessMethods.Interpolate(color.a, alpha, 0.2f, InterpolationMethods.Lerp, f =>
        {
            texture.color = texture.color.ChangeAlpha(f);
        }));
        
    }
}
