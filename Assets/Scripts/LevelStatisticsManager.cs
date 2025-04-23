using System;
using System.Collections.Generic;
using System.Collections.ObjectModel;
using System.Globalization;
using System.Linq;
using UnityEngine;
using System.Collections;

public class LevelStatisticsManager : MonoBehaviour
{
    public ScoreComboManager ScoreComboManager;
    public WebOperations webOperations;

    public UIPanel commonOverlay;
    public UIPanel levelstatisticsPanel;
    public UITexture backgroundTexture;
    public UITexture statisticsLabelsTexture;
    public UITexture bonusLabelsTexture;
    public UILabel totalScoreLabel;

    public UILabel accuracyLabel;
    public UILabel totalKeysLabel;
    public UILabel wpmLabel;
    public UILabel highestComboLabel;
    public UILabel totalZombiesKilledLabel;
    public UILabel wavesCompletedLabel;

    public UILabel accuracyBonusLabel;
    public UILabel timeBonusLabel;
    public UILabel difficultyBonusLabel;

    public UIPanel pressSpaceToContinue;
    public KongregateAPI kongregateApi;

    public UIPanel enemyWordsPanel;
    public GrayscaleEffect grayscaleEffect;

    public UIPanel hudPanel;
    public UIPanel powerupBoxesPanel;

    private IEnumerable<StatisticLabel> statisticsLabels;
    private IEnumerable<BonusLabel> bonusLabels;

	// Use this for initialization
	IEnumerator Start ()
	{
        // Hide the 2 sets of labels
	    statisticsLabelsTexture.color = statisticsLabelsTexture.color.ChangeAlpha(0);
	    bonusLabelsTexture.color = bonusLabelsTexture.color.ChangeAlpha(0);

        // Hide the background texture
	    backgroundTexture.color = backgroundTexture.color.ChangeAlpha(0);

	    pressSpaceToContinue.alpha = 0;
	    totalScoreLabel.enabled = false;
	    totalScoreLabel.text = "0";

	    statisticsLabels = new[]
	                           {
                                   new StatisticLabel(highestComboLabel, "{0}", () => GameStatistics.Instance.CurrentLevel.HighestComboMultiplier),
                                   new StatisticLabel(totalZombiesKilledLabel, "{0}", () => GameStatistics.Instance.CurrentLevel.TotalEnemiesKilled),
                                   new StatisticLabel(wavesCompletedLabel, "{0}", () => GameStatistics.Instance.CurrentLevel.WavesCompleted),
	                               new StatisticLabel(accuracyLabel, "{0}%", () => GameStatistics.Instance.CurrentLevel.Accuracy), 
                                   new StatisticLabel(totalKeysLabel, "{0}", () => GameStatistics.Instance.CurrentLevel.TotalKeysPressed),
                                   new StatisticLabel(wpmLabel, "{0}", () => GameStatistics.Instance.CurrentLevel.WordsPerMinute),
	                           };

	    bonusLabels = new[]
	                  {
                          new BonusLabel(difficultyBonusLabel, score =>
                          {
                              return GameStatistics.Instance.CurrentLevel.CalculateDifficultyBonus(score);
                          }), 
                          /*
	                      new BonusLabel(timeBonusLabel, originalScore =>
	                      {
	                          // number of waves done * constant time of each wave
	                          var wavesTotalTime = (GameStatistics.Instance.CurrentLevel.WavesCompleted)*GameSettings.WaveTimeSeconds;
	                          Debug.Log("waves total time: " + wavesTotalTime);

	                          var timeRemaining = Math.Abs(wavesTotalTime - GameStatistics.Instance.CurrentLevel.WavesTimerSeconds);
	                          Debug.Log("time remaining: " + timeRemaining);

	                          var scoreIncrement = (timeRemaining/wavesTotalTime)*originalScore;

	                          return (int) scoreIncrement;
	                      }),
                          */
	                      new BonusLabel(accuracyBonusLabel, score =>
	                      {
	                          return GameStatistics.Instance.CurrentLevel.CalculateAccuracyBonus(score);
	                      }),
	                  };

        // Hide the statistics labels
	    foreach (var statisticsLabel in statisticsLabels)
	    {
	        var label = statisticsLabel.UILabel;
	        label.enabled = false;
	        label.text = String.Empty;
	    }

        // Hide the bonus labels
	    foreach (var bonusLabel in bonusLabels)
	    {
	        var label = bonusLabel.UiLabel;
	        label.enabled = false;
	        label.text = string.Empty;
	    }

	    while (!startedShowingScores)
	    {
	        yield return null;
	    }

        StartCoroutine(ShowPressSpace());

        // Wait until the return key is pressed before going back to the main menu
        while (!Input.GetKeyDown(KeyCode.Space))
        {
            yield return null;
        }

        Application.LoadLevel("StartMenu");

	}

    public void ShowScores()
    {
        levelstatisticsPanel.enabled = true;
        levelstatisticsPanel.alpha = 1;

        StartCoroutine(HomelessMethods.Interpolate(1f, 0f, 3f, InterpolationMethods.Lerp, f =>
        {
            hudPanel.alpha = f;
            powerupBoxesPanel.alpha = f;
        }));

        StartCoroutine(HomelessMethods.Interpolate(0f, 1f, 3f, InterpolationMethods.Lerp, f =>
        {
            grayscaleEffect.effectAmount = f;
            commonOverlay.alpha = f;
            enemyWordsPanel.alpha = 1f - f;
        }));

        StartCoroutine(StartShowingScores());
    }

    private void UpdateScoreLabel(int value)
    {
        totalScoreLabel.text = value.ToString("#,##0");
    }

    private IEnumerator ShowPressSpace()
    {
        const float seconds = 2f;
        StartCoroutine(HomelessMethods.Interpolate(0f, 1f, seconds, InterpolationMethods.Lerp, f =>
        {
            pressSpaceToContinue.alpha = f;
        }));

        yield return null;
    }


    private bool startedShowingScores;
    private IEnumerator StartShowingScores()
    {
        const int bonusesIntervalSeconds = 2;
        var originalScore = GameStatistics.Instance.Score;
        var totalBonusesIncrement = bonusLabels.Sum(bonusLabel => bonusLabel.ScoreDeltaCalculator(originalScore));

        //Debug.Log("Total bonuses incs: " + totalBonusesIncrement);

        var totalScore = originalScore + totalBonusesIncrement;
        //Debug.Log("Total Score (including bonuses)" + totalScore);

        // Send the high score to kongregate
        //Debug.Log("Sending score to kongregate: " + totalScore);
        kongregateApi.SubmitStatistic("High Score", totalScore);

        StartCoroutine(HomelessMethods.Interpolate(0f, 1f, 3f, InterpolationMethods.Lerp, i => backgroundTexture.color = backgroundTexture.color.ChangeAlpha(i)));
        yield return new WaitForSeconds(3f);

        startedShowingScores = true;

	    statisticsLabelsTexture.color = statisticsLabelsTexture.color.ChangeAlpha(1);
        totalScoreLabel.enabled = true;
        UpdateScoreLabel(GameStatistics.Instance.Score);

        foreach (var statisticsLabel in statisticsLabels)
        {
            statisticsLabel.UILabel.enabled = true;
        }

        foreach (var statisticsLabel in statisticsLabels)
        {
            StatisticLabel label = statisticsLabel; // because of the coming closure
            var score = statisticsLabel.ScoreFetcher();
            if (score == 0)
            {
                    label.UILabel.text = String.Format("{0}", String.Format(label.Format, score));
                yield return new WaitForSeconds(0.3f);
            } else
            {
                StartCoroutine(HomelessMethods.Interpolate(0, score, 1f, InterpolationMethods.Lerp, i =>
                {
                    label.UILabel.text = String.Format("{0}", String.Format(label.Format, i));
                }));

                // Wait some seconds before showing the next score
                yield return new WaitForSeconds(1f);
            }
        }

        
        //// Bonuses
        StartCoroutine(HomelessMethods.Interpolate(originalScore, totalScore, bonusLabels.Count() * bonusesIntervalSeconds, InterpolationMethods.Lerp, UpdateScoreLabel));

        // Add the score increment to our current score
        GameStatistics.Instance.Score += totalBonusesIncrement;
	    bonusLabelsTexture.color = bonusLabelsTexture.color.ChangeAlpha(1);
        foreach (var bonusLabel in bonusLabels)
        {
            bonusLabel.UiLabel.enabled = true;

            // Calculate the score increment for this bonus
            var scoreIncrement = bonusLabel.ScoreDeltaCalculator(originalScore);
            if (scoreIncrement < 0)
            {
                scoreIncrement = 0;
            }

            //Debug.Log(String.Format("Score increment for {0}: {1}", bonusLabel.UiLabel.name, scoreIncrement)); // TODO: there's no comma in bebas for the size we use :<

            BonusLabel label = bonusLabel;
            if (scoreIncrement == 0)
            {
                label.UiLabel.text = String.Format("+{0}", scoreIncrement.ToString("#,##0"));
                yield return new WaitForSeconds(0.3f);
            }
            else
            {
                StartCoroutine(HomelessMethods.Interpolate(0, scoreIncrement, 1f, InterpolationMethods.Lerp, i =>
                {
                    label.UiLabel.text = String.Format("+{0}", i);
                }));

                yield return new WaitForSeconds(bonusesIntervalSeconds);
            }
        }

        SendRichardStatistics(totalScore);

        yield return new WaitForSeconds(0.5f);

    }

    private void SendRichardStatistics(int totalScore)
    {
        try
        {
            var formattedDate = String.Format("{0:d/M/yyyy HH:mm:ss}", DateTime.UtcNow);
            var editor = Application.isEditor ? "EDITOR" : "ONLINE";
            var currentComboScore = ScoreComboManager.CalculateCurrentComboScore(2);

            var currentLevelStatistics = GameStatistics.Instance.CurrentLevel;
            var activatedSecrets = String.Join(", ", GameSettings.ActivatedSecrets.Select(s => s.ToString()).ToArray());
            //Debug.Log("Activated secrets: " + activatedSecrets);
            webOperations.POST("http://typocalypse3d-thebasement.rhcloud.com/player_sessions", new Dictionary<string, object>()
                                                                                               {
                                                                                                   {"player_alias", String.Format("{0}-{1}", editor, Guid.NewGuid())},
                                                                                                   {"total_score", totalScore},
                                                                                                   {"accuracy", currentLevelStatistics.Accuracy},
                                                                                                   {"total_keys_pressed", currentLevelStatistics.TotalKeysPressed},
                                                                                                   {"words_per_minute", currentLevelStatistics.WordsPerMinute},
                                                                                                   {"highest_combo", currentLevelStatistics.HighestComboMultiplier},
                                                                                                   {"total_zombies_killed", currentLevelStatistics.TotalEnemiesKilled},
                                                                                                   {"waves_completed", currentLevelStatistics.WavesCompleted},
                                                                                                   {"session_date", formattedDate},
                                                                                                   {"difficulty", GameSettings.Difficulty},
                                                                                                   {"secrets_used", activatedSecrets},
                                                                                               });
        } catch(Exception)
        {
            Debug.Log("Failed to log");
        }
    }
}

public class BonusLabel
{
    public UILabel UiLabel { get; set; }
    public Func<int, int> ScoreDeltaCalculator { get; set; }

    public BonusLabel(UILabel uiLabel, Func<int, int> scoreDeltaCalculator)
    {
        UiLabel = uiLabel;
        ScoreDeltaCalculator = scoreDeltaCalculator;
    }
}

public class StatisticLabel
{
    public UILabel UILabel { get; set; }
    public string Format { get; set; }
    public Func<int> ScoreFetcher { get; set; }

    public StatisticLabel(UILabel uiLabel, string format, Func<int> scoreFetcher)
    {
        UILabel = uiLabel;
        Format = format;
        ScoreFetcher = scoreFetcher;
    }
}