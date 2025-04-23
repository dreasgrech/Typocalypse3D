using System;
using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class GameStatisticsLevel
{
    /// <summary>
    /// Gets the current level number
    /// </summary>
    public int LevelNumber { get; private set; }

    /// <summary>
    /// Gets a collection of words succesfully typed in
    /// </summary>
    private List<string> WordsTyped { get; set; }

    /// <summary>
    /// Gets the total number of characters typed
    /// </summary>
    public int TotalKeysPressed { get; private set; }

    /// <summary>
    /// Gets the total number of correct characters typed
    /// </summary>
    public int TotalCorrectKeysPressed { get; private set; }

    /// <summary>
    /// Gets the total number of incorrect characters typed
    /// </summary>
    public int TotalIncorrectKeysPressed
    {
        get { return TotalKeysPressed - TotalCorrectKeysPressed; }
    }

    public int WordsPerMinute
    {
        get
        {
            if (EnemiesOnScreenTimeSeconds == 0)
            {
                return 0;
            }

            return Convert.ToInt32((60/EnemiesOnScreenTimeSeconds)*WordsTyped.Count);
        }
    }

    public int HighestWordsPerMinute { get; private set; }

    /// <summary>
    /// Gets the total time in seconds spent typing
    /// </summary>
    public float WavesTimerSeconds { get; private set; }

    public float EnemiesOnScreenTimeSeconds { get; private set; }

    public int HighestComboMultiplier { get; private set; }

    public int TotalEnemiesKilled { get; set; }

    public int WavesCompleted { get; set; }

    /// <summary>
    /// Gets the accuracy percentage
    /// </summary>
    public int Accuracy
    {
        get
        {
            if (TotalKeysPressed == 0)
            {
                // Only Chuck Norris can divide by zero.
                return 0;
            }

            var accuracy = Mathf.Floor(((float) TotalCorrectKeysPressed/TotalKeysPressed)*100f);
            return Convert.ToInt32(accuracy);
        }
    }

    private readonly Dictionary<char, int> keysPressed;

    public GameStatisticsLevel(int levelNumber)
    {
        WordsTyped = new List<string>();
        keysPressed = new Dictionary<char, int>();
        LevelNumber = levelNumber;
    }

    public void UpdateTimer(float deltaTime, bool enemiesOnScreen)
    {
        WavesTimerSeconds += deltaTime;
        if (enemiesOnScreen)
        {
            EnemiesOnScreenTimeSeconds += deltaTime;
        }
    }

    public void InputKey(char key, bool isCorrect)
    {
        AddKeyPressed(key);
        TotalKeysPressed++;
        if (isCorrect)
        {
            TotalCorrectKeysPressed++;
        }
    }

    public void AddCompletedWord(string word)
    {
        WordsTyped.Add(word);
        var wpmAfterWord = WordsPerMinute;

        // If the new WPM stat after recording the word is greater than our recorded highest WPM,
        // replace the recorded highest.
        if (wpmAfterWord > HighestWordsPerMinute)
        {
            HighestWordsPerMinute = wpmAfterWord;
        }
    }

    public void RecordCombo(int comboMultiplier)
    {
        if (comboMultiplier > HighestComboMultiplier)
        {
            HighestComboMultiplier = comboMultiplier;
        }
    }

    public int CalculateDifficultyBonus(int originalScore)
    {
        var normalizedDifficulty = GameSettings.Difficulty*0.01;
        var bonus = (int) (originalScore*0.75f*normalizedDifficulty);
        return bonus;
    }

    public int CalculateAccuracyBonus(int originalScore)
    {
        var normalizedAccuracy = GameStatistics.Instance.CurrentLevel.Accuracy*0.01;
        var bonus = (int) (originalScore*normalizedAccuracy*normalizedAccuracy);
        return bonus;
    }

    private void AddKeyPressed(char key)
    {
        if (keysPressed.ContainsKey(key))
        {
            keysPressed[key]++;
            return;
        }

        keysPressed.Add(key, 1);
    }

}

public class GameStatistics 
{
    /// <summary>
    /// Gets or sets the score for the current run.
    /// Needs to be reset after every run.
    /// </summary>
    public int Score { get; set; }

    public List<GameStatisticsLevel> Levels { get; private set; }
    public GameStatisticsLevel CurrentLevel { get; private set; }

    private static GameStatistics instance;
    public static GameStatistics Instance {
        get
        {
            return instance ?? (instance = new GameStatistics());
        }
    }

    private GameStatistics()
    {
        Reset();
    }

    public void AddLevel(GameStatisticsLevel level)
    {
        Levels.Add(level);
        CurrentLevel = level;
    }

    public void Reset()
    {
        Levels = new List<GameStatisticsLevel>();
        CurrentLevel = null;
        Score = 0;
    }
}
