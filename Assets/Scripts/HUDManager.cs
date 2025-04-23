using System;
using UnityEngine;
using System.Collections;

public enum HUDState
{
    Playing,
    Paused,
    LevelComplete,
    LevelStatistics,
    ShowingStatisticsScreen,
    PlayerDied,
}

public class HUDManager : StateMachine<HUDState>
{
    public UIPanel hudPanel;
    public UIPanel fadeOutPanel;
    public UIPanel levelStatisticsPanel;
    public GameObject statisticsStrip;

    private LevelStatisticsManager levelStatisticsManager;

	// Use this for initialization
	void Start () {
	    levelStatisticsManager = GetComponent<LevelStatisticsManager>();
	}

    IEnumerator Playing_EnterState()
    {
        // Show the on screen hud while playing
        hudPanel.gameObject.SetActive(true);

        yield return null;
    }
    
    IEnumerator LevelComplete_EnterState()
    {
        StartCoroutine(HomelessMethods.Interpolate(0f, 1f, 2f, InterpolationMethods.Lerp, alpha =>
                                                                                              {
                                                                                                  fadeOutPanel.alpha = alpha;
                                                                                              }, () =>
                                                                                                     {
                                                                                                         CurrentState = HUDState.LevelStatistics;
                                                                                                     }));
        yield return null;
    }

    IEnumerator PlayerDied_EnterState()
    {
        CurrentState = HUDState.LevelStatistics;

        yield return null;
    }

    IEnumerator LevelStatistics_EnterState()
    {
        // Wait some time before showing the level-specific background
        //yield return new WaitForSeconds(1);

        levelStatisticsManager.ShowScores();
        CurrentState = HUDState.ShowingStatisticsScreen;

        yield return null;
    }

    public void OnLevelComplete()
    {
        CurrentState = HUDState.LevelComplete;
    }

    public void OnPlayerDied()
    {
        CurrentState = HUDState.PlayerDied;
    }

    /*
    /// <summary>
    /// Drops the center strip in the level statistics screen
    /// </summary>
    private void DropStatisticsStrip(Action callback)
    {
        Vector3 currentPosition = statisticsStrip.transform.localPosition;
        StartCoroutine(HomelessMethods.Interpolate(currentPosition.y, 0, 0.2f, Mathf.SmoothStep,
                                                   y =>
                                                       {
                                                           //Debug.Log("Interpolationg: " + y);
                                                           if (y > 0)
                                                           {
                                                               statisticsStrip.transform.localPosition = statisticsStrip.transform.localPosition.ReplaceY(y);
                                                           }
                                                       }, callback));
    }
    */

}
