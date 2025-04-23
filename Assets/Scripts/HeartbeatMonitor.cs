using System;
using UnityEngine;
using System.Collections;

public enum HBMStates
{
    Beating,
    Stopped
}

public class HeartbeatMonitor : StateMachine<HBMStates>
{
    public AudioClip beat;
    public UIPanel heartbeatPanel;
    public UIPanelSlider stressSlider;
    //private float shortInterval = 0.4f;

    void Awake()
    {
        TweenAlpha.Begin(heartbeatPanel.gameObject, 0f, 0);
    }

    public void StartBeating()
    {
        CurrentState = HBMStates.Beating;
    }

    public void StopBeating()
    {
        CurrentState = HBMStates.Stopped;
    }

    IEnumerator Beating_EnterState()
    {
        yield return new WaitForSeconds(1);
        while (true)
        {
            if (CurrentState != HBMStates.Beating)
            {
                break;
            }

            // Get the current stress (0-1)
            var currentStress = stressSlider.RealTimeValue;

            // Calculate the interval between the beats based on the current stress
            // TODO: The intervals between the beats is still not sounding natural enough
            float interval = HomelessMethods.Map(currentStress, 0, 1, 0.2537f, 0.20f);

            yield return StartCoroutine(PlayBeatPair(currentStress, interval));
        }
    }

    IEnumerator PlayBeatPair(float currentStress, float interval)
    {
         audio.PlayOneShot(beat);

         TweenAlpha.Begin(heartbeatPanel.gameObject, 0.1f, currentStress);

         // Wait for the interval of between the beats 
         yield return new WaitForSeconds(interval);
         TweenAlpha.Begin(heartbeatPanel.gameObject, 0.5f, 0);

         audio.PlayOneShot(beat);

         // Wait for the interval of between the beat pairs (longer interval)
         yield return new WaitForSeconds(interval * 2);
    }
}
