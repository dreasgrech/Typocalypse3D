using System;
using System.Collections.Generic;
using System.Linq;
using UnityEngine;
using System.Collections;

public class ScoreComboManager : MonoBehaviour
{
    public float thresholdSeconds;
    public HUDText comboHudText;

    public event EventHandler<ComboBrokenEventArgs> OnComboBroken;
    public List<int> CurrentComboCount { get; private set; }
    public float LastCorrectWordTypedTime { get; private set; }

    private IEnumerator Start()
    {
        CurrentComboCount = new List<int>();
        yield return null;
    }

    public int RegisterWord(int scoreValue)
    {
        if (scoreValue == 0)
        {
            return 0;
        }

        LastCorrectWordTypedTime = Time.time;

        CurrentComboCount.Add(scoreValue);

        StartCoroutine(HomelessMethods.InvokeInSeconds(thresholdSeconds, last =>
                                                                       {
                                                                           if (LastCorrectWordTypedTime == last)
                                                                           {
                                                                               BreakCombo();
                                                                           }
                                                                       }, LastCorrectWordTypedTime));

        /*
        const float everyHowManyCombos = 3;
        var mod = CurrentComboCount.Count%everyHowManyCombos;
        if (mod == 0)
        {*/
        if (CurrentComboCount.Count > 1)
        {
            //comboHudText.Add(CurrentComboCount.Count, Color.red, thresholdSeconds, "{0}x");
            var value = CurrentComboCount.Count == 2 ? 2 : 1;
            comboHudText.Add(value, Color.red, thresholdSeconds, "{0}x");
        }
        //}

        return scoreValue*CurrentComboCount.Count;
    }

    public int CalculateCurrentComboScore(int inc = 1)
    {
        var sum = CurrentComboCount.Sum(c => c);
        return sum*(CurrentComboCount.Count + inc);
    }

    public void BreakCombo()
    {
        if (OnComboBroken != null)
        {
            OnComboBroken(this, new ComboBrokenEventArgs(CurrentComboCount.Count, CalculateCurrentComboScore()));
        }

        CurrentComboCount.Clear();
        comboHudText.ResetCounter();
    }
}

public class ComboBrokenEventArgs : EventArgs
{
    public int TotalComboCount { get; set; }
    public int TotalPointsForCombo { get; set; }

    public ComboBrokenEventArgs(int totalComboCount, int totalPointsForCombo)
    {
        TotalComboCount = totalComboCount;
        TotalPointsForCombo = totalPointsForCombo;
    }
}