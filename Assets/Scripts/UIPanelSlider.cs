using System;
using System.Collections.Generic;
using System.Linq;
using UnityEngine;
using System.Collections;

public enum SliderDirection
{
    BottomToTop,
    TopToBottom,
    LeftToRight
}

/// <summary>
/// Requires clipping on the UIPanel
/// </summary>
public class UIPanelSlider : MonoBehaviour
{
    public event EventHandler<SliderChangeEventArgs> OnSliderChange;

    public UIPanel panel;
    public float clipYFull;
    public float clipYEmpty;
    public float startPositionOneZero; // 0..1
    public SliderDirection Direction;

    /// <summary>
    /// Returns the current value.
    /// Returns a value between 0 and 1.
    /// </summary>
    public float CurrentValue
    {
        get
        {
            return HomelessMethods.Map(CurrentYPosition, clipYEmpty, clipYFull, 0, 1);
        }
    }

    /// <summary>
    /// Returns the real time value.  Everytime the caller wants to move the slider, this value
    /// is updated immediately.
    /// </summary>
    public float RealTimeValue { get; private set; }

    private readonly Queue<KeyValuePair<float, float>> queuedInterpolations = new Queue<KeyValuePair<float, float>>();
    private bool currentlyInterpolating;

    private float CurrentYPosition
    {
        get { return panel.clipRange.y; }
    }

    private float MapToPosition(float value)
    {
        return Mathf.Lerp(clipYEmpty, clipYFull, value);
    }

    private void Start()
    {
        // Set the slider to the starting position
        //JumpSlider(startPositionOneZero);
    }

    /// <summary>
    /// Moves by the provided amount in pixels from the current position
    /// </summary>
    public void MoveByDelta(float delta, bool fromStartingPosition = false)
    {
        var value = (fromStartingPosition ? clipYEmpty : CurrentYPosition) + delta;
        MoveSliderY(value);
    }

    /// <summary>
    /// Instead of interpolating, this method jumps to the position 
    /// </summary>
    /// <param name="value">0..1</param>
    public void JumpSlider(float value)
    {
       MoveSliderY(MapToPosition(value)); 
    }

    public void MoveSlider(float value, float time)
    {
        // We don't want to exceed the 0..1 range
        value = Mathf.Clamp(value, 0f, 1f);

        /*
        // If the value of this call is the same as the previous one, ignore this one
        if (queuedInterpolations.Count > 0 && queuedInterpolations.Last().Value == value)
        {
            return;
        }
        */
        //Debug.Log(String.Format("Moving from {0} to {1}", RealTimeValue, value));

        // Update the real time value every time the caller wants to move the slider
        RealTimeValue = value;

        StartInterpolating(value, time);
    }

    private void StartInterpolating(float value, float time)
    {
        // If we're currently interpolating, add this entry to the queue and return.
        if (currentlyInterpolating)
        {
            queuedInterpolations.Enqueue(new KeyValuePair<float, float>(value, time));
            return;
        }

        // Otherwise, start the interpolation!
        currentlyInterpolating = true;

        var newYPosition = MapToPosition(value);
        var lerpRoutine = HomelessMethods.Interpolate(CurrentYPosition, newYPosition, time, Mathf.Lerp, MoveSliderY, () =>
                                                                                                                         {
                                                                                                                             currentlyInterpolating = false;

                                                                                                                             // If there are more interpolations in the queue, start the next one now
                                                                                                                             if (queuedInterpolations.Count > 0)
                                                                                                                             {
                                                                                                                                 var next = queuedInterpolations.Dequeue();
                                                                                                                                 StartInterpolating(next.Key, next.Value);
                                                                                                                             }
                                                                                                                         });
        StartCoroutine(lerpRoutine);
        
    }

    /// <summary>
    /// Moves the slider along the x-axis
    /// </summary>
    /// <param name="yPosition">The new position</param>
    private void MoveSliderY(float yPosition)
    {
        // Clamp how much we can move so that we don't go beyond our boundaries
        yPosition = Mathf.Clamp(yPosition, clipYEmpty, clipYFull);

        var currentClipRange = panel.clipRange;

        var rangeToUse = (Direction == SliderDirection.LeftToRight ? new Vector4(yPosition, currentClipRange.y, currentClipRange.z, currentClipRange.w) : new Vector4(currentClipRange.x, yPosition, currentClipRange.z, currentClipRange.w));
        panel.clipRange = rangeToUse;

        if (OnSliderChange != null)
        {
            OnSliderChange(this, new SliderChangeEventArgs(CurrentValue));
        }
    }
}

public class SliderChangeEventArgs : EventArgs
{
    public float NewValue { get; set; }

    public SliderChangeEventArgs(float newValue)
    {
        NewValue = newValue;
    }
}
