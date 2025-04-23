using System.Globalization;
using System.Text.RegularExpressions;
using Assets.Scripts;
using UnityEngine;
using System.Collections;
using System.Collections.Generic;
using System;
using System.IO;
using System.Linq;

public class Entrance {
	public Vector3 Left {get; set;}
	public Vector3 Right {get; set;}

	public Entrance(Vector3 left, Vector3 right) {
		Left = left;
		Right = right;
	}
}

public enum EnemyDiedReason
{
    PlayerTypedEnemyWord,
    PlayerTypedPowerupWord,
    Landmine,
    LandmineArea, // was in the range of an exploding landmine
    HitByPowerupCrate,
    HitBySniper,
    RapidFire,
    C4Area,
    PlayerDied
}

public enum LevelStates
{
    IncrementingWaveNumber,
    DoingWave,
    WaitingToClearRemainingEnemies,
    WaveStatistics, // The pause between each wave
    BossBattle,
    LevelStatistics,
}

public class CentralLogicScript : StateMachine<LevelStates>
{
    public float debugDifficulty;
    public int timeAllocatedToWaveSeconds;
    public int wavesBeforeBoss;
	public KeyManager keyManager;
    public HUDManager hudManager;
    public HeartbeatMonitor heartbeatMonitor;
	public UILabel scoreBoard;
	public UILabel waveNumberHUD;
	public UILabel currentWaveAccuracyHUD;
	public UILabel wpmHUD;
    public UIPanel PausedMenu;
    public UITexture waveCompletePanel;
    public MotionBlur motionBlur;
	public GameObject marker;
	public GameObject enemyModel;
    public Camera MainCamera;
    public Camera uiCamera;
    public AudioClip waveStartAudio;
    public AudioClip incorrectKeyPressAudio;
    //public GameObject boss;
    public KongregateAPI kongregateApi;
    public TiltShift tiltShiftEffect; // used for the depth of field
    public Transform enemyModelsHolder;
    public ScoreComboManager ScoreComboManager;
    public PowerupManager powerupManager;
    public PausedMenu pausedMenu;
    public LayerMask letterlayer;
    public WebOperations webOperations;
    public SecretManager secretManager;
    public Transform teapot;
    public NoiseEffect overlayNoise;
    public UIPanel controlsPanel;
    public UITexture controlsPausedHeader;
    public UIPanel pressStartToBeginPanel;
    public UIPanel commonOverlay;
    public BlurEffect blurEffect;
    public PowerupInstructionsPanel powerupInstructionsPanel;
    public GrayscaleEffect grayscaleEffect;
    public UILabel playerNameLabel;

    public UITexture powerupBoxes;

	private AudioManager audioManager;
	private GameObject spawnPoint;
    private float difficulty; // will contain the difficulty (1 - 100);
	private float enemySpawnInterval; // delay in seconds for enemy spawning
    private const float difficultyRange = 10;
    private List<string> originalDictionary;
    private List<string> words;
    private float wordDifficultyPercentage = 1;
    private int currentWave;
    public HashSet<IEnemy> EnemiesOnScreen { get; set; }
    private const float baseStressIncrement = 0.1f;
    private List<GameObject> enemyModels;
    private GameStatisticsLevel currentLevelStatistics;
    private bool wasBossReleased;
    private BossBehaviour bossBehaviour;
    private bool cameraLookingAtBoss;

    /*
	private static float yEntrance = 0;
	private static float zEntrance = -9.817513f;
	private List<Entrance> entrances = new List<Entrance>() {
		new Entrance(new Vector3(9.363613f, yEntrance, zEntrance), new Vector3(6.781803f, yEntrance, zEntrance)),
		new Entrance(new Vector3(0.5166297f, yEntrance, zEntrance), new Vector3(-1.697498f, yEntrance, zEntrance)),
		new Entrance(new Vector3(-7.60805f, yEntrance, zEntrance), new Vector3(-9.604151f, yEntrance, zEntrance))
	};
	*/

    public AnimationCurve teapotCurve;
    public UITexture playerAvatarTexture;

    private bool lastSpawnpointLeft;
    private Vector3 spawnpointLineCenter;
    private Vector3 spawnpointLinePointA;
    private Vector3 spawnpointLinePointB;

    private SBag<Vector3> leftHalfSpawnpoints;
    private SBag<Vector3> rightHalfSpawnpoints;

    private Vector3 GetNextEnemySpawnpoint()
    {
        lastSpawnpointLeft = !lastSpawnpointLeft;

        return lastSpawnpointLeft ? leftHalfSpawnpoints.GetElement() : rightHalfSpawnpoints.GetElement();
    }

    public Camera cityCamera;
    private IEnumerator Start()
    {
		GameObject spawnpointPositions = GameObject.FindGameObjectsWithTag("SpawnpointPositions")[0];
	    var pointA = spawnpointPositions.transform.Find("PointA");
		var pointB = spawnpointPositions.transform.Find("PointB");
        var totalWidth = (pointB.transform.position.x - pointA.transform.position.x);
        spawnpointLineCenter = new Vector3(pointA.transform.position.x + totalWidth/2, pointA.transform.position.y, pointA.transform.position.z);
        spawnpointLinePointA = pointA.transform.position;
        spawnpointLinePointB = pointB.transform.position;

        var segments = 10;
        float segmentWidth = totalWidth/segments;
        List<Vector3> leftSpawnPoints = new List<Vector3>(), rightSpawnPoints = new List<Vector3>();
        int keeper = 0;
        for (float i = spawnpointLinePointA.x; i < spawnpointLinePointA.x + totalWidth; i += segmentWidth)
        {
            if (keeper++ > 100)
            {
                break;
            }

            if (i < spawnpointLineCenter.x)
            {
                leftSpawnPoints.Add(new Vector3(i, pointA.transform.position.y, pointA.transform.position.z));
            }
            else
            {
                rightSpawnPoints.Add(new Vector3(i, pointA.transform.position.y, pointA.transform.position.z));
            }
        }

        leftHalfSpawnpoints = new SBag<Vector3>(leftSpawnPoints);
        rightHalfSpawnpoints = new SBag<Vector3>(rightSpawnPoints);

        /*
        var start = teapot.position.y;
        Debug.Log(teapotCurve.length);
        StartCoroutine(HomelessMethods.Interpolate(0f, 1f,5f, InterpolationMethods.Lerp, f =>
        {
            //var eval = teapotCurve.Evaluate(Time.realtimeSinceStartup);
            var eval = teapotCurve.Evaluate(f);
            var y = teapot.position.y;
            teapot.localPosition = teapot.position.ReplaceY(start + eval);
        }));
         */
        Time.timeScale = 1;
        GameStatistics.Instance.Reset();
        GameSettings.GameCamera = MainCamera;
        //GameSettings.GameCamera = cityCamera;
        GameSettings.UICamera = uiCamera;
        pausedMenu.CanWePause = true;
        waveCompletePanel.alpha = 0;

        scoreBoard.supportEncoding = true; // to enable per-letter coloring via [color] encodes
        UpdateScoreLabel(0f); // Set the initial score

//#if UNITY_EDITOR
        //var kongregateBrainObject = new GameObject();
        //var kongregateBrain = kongregateBrainObject.AddComponent<KongregateBrainAPI>();
        //kongregateBrain.UserInfo = new KongregateUserInfo();

//#else
        var kongregateBrain = FindObjectOfType(typeof (KongregateBrainAPI)) as KongregateBrainAPI;
//#endif

        if (kongregateBrain != null)
        {
            if (kongregateBrain.UserInfo != null)
            {
                Debug.Log("User info: " + kongregateBrain.UserInfo.Username);
            }
        }

        if (GlobalVariables.KongregateUserInfo != null)
        {
            playerNameLabel.text = GlobalVariables.KongregateUserInfo.Username;
             playerAvatarTexture.mainTexture = GlobalVariables.KongregateUserInfo.AvatarTexture;
        }

        //FlyingText.PrimeText("abcdefghijklmopqrstuvwxyz");

        secretManager.HandleSecrets();

        if (GameSettings.Difficulty == 0)
        {
            // We're working on this scene only, so no difficulty will be given to us by the menu
            GameSettings.Difficulty = debugDifficulty;
        }

        GlobalVariables.Player = GameObject.FindWithTag("Player").GetComponent<PlayerBehaviour>();

        GameSettings.WaveTimeSeconds = timeAllocatedToWaveSeconds;
        var levelSettings = GameObject.FindGameObjectWithTag("LevelSettings").GetComponent<LevelSettings>();
        currentLevelStatistics = new GameStatisticsLevel(levelSettings.levelIndex);
        GameStatistics.Instance.AddLevel(currentLevelStatistics);

        enemyModels = new List<GameObject>();
        foreach (Transform model in enemyModelsHolder)
        {
            enemyModels.Add(model.gameObject);
        }

        audioManager = (AudioManager) FindObjectOfType(typeof (AudioManager));
        EnemiesOnScreen = new HashSet<IEnemy>();

        difficulty = GameSettings.Difficulty;

        audioManager.PlayNormalMusic();

        spawnPoint = GameObject.FindWithTag("Spawnpoint");

        originalDictionary = ReadFile();
        words = originalDictionary.ToList();

        /*
        hudManager.StateChanged += (sender, args) =>
                                       {
                                           if (args.NewState == HUDState.ShowingStatisticsScreen)
                                           {
                                               CurrentState = LevelStates.LevelStatistics;
                                           }
                                       };
        */

        keyManager.AlphabeticalKeyPressed += KeyPressed;

        Messenger.instance.Listen("game", gameObject);

        ScoreComboManager.OnComboBroken += (sender, args) =>
        {
            if (CurrentState == LevelStates.LevelStatistics)
            {
                // You don't wan't to keep increasing the score after the player's dead
                return;
            }

            UpdateScore(args.TotalPointsForCombo);

            currentLevelStatistics.RecordCombo(args.TotalComboCount);
        };

        powerupManager.OnPowerupFirstActivation += (sender, args) =>
        {
            pausedMenu.CanWePause = false;
            StartCoroutine(powerupInstructionsPanel.ShowPanel(args.Powerup.PowerType, () =>
            {
                pausedMenu.CanWePause = true;
            }));
        };

        powerupManager.OnPowerupDestroyed += (sender, args) =>
                                                 {
                                                     // Wound the enemey
                                                     var enemy = args.EnemyHit;
                                                     KillEnemy(enemy, EnemyDiedReason.HitByPowerupCrate, Vector3.zero);
                                                 };
        /*
	    GameObject quitButton = PausedMenu.transform.Find("Quit").gameObject,
	               resumeGamebutton = PausedMenu.transform.Find("Resume").gameObject;

        UIEventListener.Get(resumeGamebutton).onClick += go =>
                                                       {
                                                           CurrentState = LevelStates.DoingWave;
                                                       };

	    UIEventListener.Get(quitButton).onClick += go =>
	                                                   {
	                                                       Time.timeScale = 1;
	                                                       Application.LoadLevel("StartMenu");
	                                                   };
        */

        enemySpawnInterval = HomelessMethods.Map(difficulty, 1f, 100f, 4f, 0.5f);


        //// Initiate HUD text
        currentWaveAccuracyHUD.text = String.Format("{0}%", currentLevelStatistics.Accuracy);

        pausedMenu.PausedMenuShown += (sender, args) =>
        {
            if (isShowingFirstControlsScreen)
            {
                controlsPausedHeader.alpha = 1;
                pressStartToBeginPanel.alpha = 0;
            } else
            {
                powerupBoxes.alpha = 0;
            }
        };

        pausedMenu.PausedMenuHidden += (sender, args) =>
        {
            if (isShowingFirstControlsScreen)
            {
                blurEffect.enabled = true;
                overlayNoise.enabled = true;
                pressStartToBeginPanel.alpha = 1;
                controlsPanel.alpha = 1;
                controlsPausedHeader.alpha = 0;
                commonOverlay.alpha = 1;
                grayscaleEffect.effectAmount = 1;
            }
        };

        // Lock cursor so that in Web mode when using the sniper (mouse), it won't exit the content area (unless the user presses escape)
        Screen.lockCursor = true;

        blurEffect.enabled = true;
        commonOverlay.alpha = 1;
        isShowingFirstControlsScreen = true;
        pressStartToBeginPanel.alpha = 1;
        controlsPanel.alpha = 1;
        controlsPausedHeader.alpha = 0;
        grayscaleEffect.effectAmount = 1;

        while (!Input.GetKeyDown(KeyCode.Space) || pausedMenu.IsPaused)
        {
            yield return null;
        }

        isShowingFirstControlsScreen = false;
        powerupBoxes.alpha = 0f;

        StartCoroutine(HomelessMethods.Interpolate(1f, 0f, 0.1f, InterpolationMethods.Lerp, f =>
        {
            controlsPanel.alpha = f;
            pressStartToBeginPanel.alpha = f;
            commonOverlay.alpha = f;
            grayscaleEffect.effectAmount = f;
        },() =>
        {
            controlsPausedHeader.alpha = 1;
            overlayNoise.enabled = false;
            blurEffect.enabled = false;
        }));

        // heartbeatMonitor.StartBeating();

        // Start the game!
        audio.PlayOneShot(waveStartAudio);
        CurrentState = LevelStates.IncrementingWaveNumber;

        StartCoroutine(powerupManager.StartDroppingPowerups());
    }

    private bool isShowingFirstControlsScreen;

    public int CalculateEnemyDeadScore(int baseScore, EnemyDiedReason reason)
    {
        switch (reason)
        {
            case EnemyDiedReason.PlayerTypedEnemyWord: return baseScore;
            case EnemyDiedReason.PlayerTypedPowerupWord: return baseScore;
            case EnemyDiedReason.C4Area: return baseScore*4;
            case EnemyDiedReason.HitBySniper: return baseScore*2;
            case EnemyDiedReason.Landmine: return baseScore*3;
            case EnemyDiedReason.RapidFire: return baseScore*3;
            case EnemyDiedReason.LandmineArea: return baseScore*2;
            case EnemyDiedReason.HitByPowerupCrate: return 0;
            default:
                {
                    Debug.LogError("I don't know about this reason: " + reason);
                    return 0;
                }
        }
    }

    public void KillEnemy(IEnemy enemy, EnemyDiedReason reason, Vector3 hitWorldPosition)
    {
        var wasEnemyKilled = enemy.WordsLeft.Count == 0 || enemy.ShouldDieImmediately(reason);

        var bullets = 3;

        var wordsLeft = enemy.WordsLeft.Concat(new [] {enemy.Text}).ToList();
        CalculateAndShowScore(enemy, enemy.Settings.scorePerWord, reason, wasEnemyKilled ? wordsLeft : new List<string>{enemy.Text});

        // Tell the player to shoot the target
        if (reason == EnemyDiedReason.PlayerTypedEnemyWord || reason == EnemyDiedReason.RapidFire)
        {
            GlobalVariables.Player.Shoot(((MonoBehaviour) enemy).transform, bullets);

            // Record the word completed in the statistics since the player (not a powerup) hit the enemy
            currentLevelStatistics.AddCompletedWord(enemy.Text);
        }

        enemy.ApplyDamage(reason, bullets, hitWorldPosition);

        motionBlur.blurAmount -= 0.05f;

        if (wasEnemyKilled)
        {
            // Since an enemy was just killed, remove it from our collection of enemies on screen
            EnemiesOnScreen.Remove(enemy);

            currentLevelStatistics.TotalEnemiesKilled++;

            if (wasBossReleased)
            {
                //// The boss has been killed...!

                // Let the HUD show the level statistics screen
                hudManager.OnLevelComplete();

                // Show the level statistics screen
                CurrentState = LevelStates.LevelStatistics;
            }
        }
    }

    private void Update()
    {
        if (CurrentState == LevelStates.DoingWave || CurrentState == LevelStates.WaitingToClearRemainingEnemies)
        {
            currentLevelStatistics.UpdateTimer(Time.deltaTime, EnemiesOnScreen.Count > 0);
        }

        wpmHUD.text = String.Format("{0} WPM", currentLevelStatistics.WordsPerMinute.ToString(CultureInfo.InvariantCulture));

        if (cameraLookingAtBoss)
        {
            if (bossBehaviour != null)
            {
                MainCamera.transform.LookAt(bossBehaviour.WordPosition);
            }
        }

        // If the left-mouse button is pressed and the game is not paused, we should lock the screen. 
        if (Input.GetMouseButtonDown(0) && !pausedMenu.IsPaused)
        {
            Screen.lockCursor = true;
        }

        // If the mouse is unlocked and the game is not paused, we should pause the game
        /*
        if (!Screen.lockCursor && !pausedMenu.IsPaused && !Application.isEditor)
        {
            pausedMenu.ShowMenu();
        }*/

        if (Input.GetAxisRaw("Whammy Bar") > 0.3 || Input.GetAxisRaw("Whammy Bar") < -0.3)
        {
            var whammy = Input.GetAxisRaw("Whammy Bar");
            whammy = HomelessMethods.Map(whammy, -1, 1, 1, 0);
            SetTimeScale(whammy);
        }

        if (Input.GetButtonDown("Guitar Green Button") || (Application.isEditor && Input.GetKeyDown(KeyCode.KeypadEnter)))
        {
            if (!pausedMenu.IsPaused && EnemiesOnScreen.Count > 0)
            {
                IEnemy closestEnemy = GetClosestEnemies(EnemiesOnScreen, 1).FirstOrDefault();

                if (closestEnemy != null)
                {
                    KillEnemy(closestEnemy, EnemyDiedReason.RapidFire, Vector3.zero);
                }
            }
        }
    }

    public IEnumerable<IEnemy> GetClosestEnemies(IEnumerable<IEnemy> enemies, int max)
    {
        var enemiesList = enemies.ToList();
        var enemiesDistances = enemiesList.ToDictionary(enemy => Vector3.Distance(GlobalVariables.Player.transform.position, enemy.Position));
        var sortedEnemiesDistances = new SortedList<float, IEnemy>(enemiesDistances);
        return sortedEnemiesDistances.Take(max).Select(enemy => enemy.Value);
    }

    /// <summary>
    /// The player has been killed
    /// </summary>
    /// <param name="message"></param>
	private void _PlayerDied(MessagePlayerDied message)
    {
        pausedMenu.CanWePause = false;

        audioManager.PitchOutSong();

        // Let the HUD show the level statistics screen
        hudManager.OnPlayerDied();

        if (wasBossReleased)
        {
            /*
            StartCoroutine(HomelessMethods.Interpolate(MainCamera.transform.position.y, -3.569896f, 1f,
                                                       InterpolationMethods.Lerp, f =>
                                                                                      {
                                                                                          var curr = MainCamera.transform.position;
                                                                                          MainCamera.transform.position = new Vector3(curr.x, f, curr.z);
                                                                                      }));
            */
            MainCamera.gameObject.AddComponent<Rigidbody>();

        } else
        {
            iTween.ShakePosition(MainCamera.transform.gameObject, new Hashtable
                                                                  {
                                                                      {"amount", new Vector3(0.6f, 0.5f, 0.0f)},
                                                                      {"time", 3},
                                                                      {"ignoretimescale", true}
                                                                  });

            //iTween.ShakePosition(MainCamera.transform.gameObject, new Vector3(0.6f, 0.5f, 0.0f), 3);
        }

        CurrentState = LevelStates.LevelStatistics;
	}

    /// <summary>
    /// The player just finished typing a full word of an enemy
    /// </summary>
	private void _WordCompleted(MessageWordCompleted message)
    {
        if (message.WordType != WordType.Enemy)
        {
            return;
        }

        var enemy = (IEnemy) message.Entity;
        KillEnemy(enemy, EnemyDiedReason.PlayerTypedEnemyWord, Vector3.zero);
	}

    private void CalculateAndShowScore(IHUDTextEnabled entity, int baseScore, EnemyDiedReason reason, List<string> wordsLeft = null)
    {
        var calculatedScore = CalculateEnemyDeadScore(baseScore, reason);

        if (wordsLeft != null && wordsLeft.Count > 0)
        {
                var wordsRemainingScoreIncrease = wordsLeft.Sum(word => word.Length*10);
                calculatedScore += wordsRemainingScoreIncrease;
        }

        calculatedScore = ScoreComboManager.RegisterWord(calculatedScore);

        if (calculatedScore > 0)
        {
            entity.ShowScore(calculatedScore);
        }
    }

    private void _PowerupTyped(MessagePowerupTyped messagePowerupTyped)
    {
        currentLevelStatistics.AddCompletedWord(messagePowerupTyped.PowerupWord);
        if (messagePowerupTyped.ShouldPlayerShoot)
        {
            GlobalVariables.Player.Shoot(messagePowerupTyped.CratePowerup.crateCollider.transform, 1);
        }

        CalculateAndShowScore(messagePowerupTyped.CratePowerup, messagePowerupTyped.CratePowerup.PowerupBehaviour.score, EnemyDiedReason.PlayerTypedPowerupWord);
    }

    IEnumerator FluctuateTimescale(float fluctuatedTime, float fluctuateTo)
    {
            yield return StartCoroutine(InterpolateTimeScale(1f, fluctuateTo, 0.1f, 0f));
            yield return new WaitForSeconds(fluctuatedTime);
            yield return StartCoroutine(InterpolateTimeScale(fluctuateTo, 1f, 0.3f, 0f));
    }

    private void SetTimeScale(float timeScale)
    {
        audio.pitch = timeScale;
        GlobalVariables.Player.audio.pitch = timeScale;

        Time.timeScale = timeScale;
        audioManager.AdjustPitch(timeScale, true);
    }

    IEnumerator InterpolateTimeScale(float from, float to, float time, float initialDelay, Func<IEnumerator> callback = null)
    {
        yield return new WaitForSeconds(initialDelay);

        StartCoroutine(HomelessMethods.Interpolate(from, to, time, InterpolationMethods.Lerp, SetTimeScale, () =>
                                                                                                                {
                                                                                                                    if (callback != null)
                                                                                                                    {
                                                                                                                        StartCoroutine(callback());
                                                                                                                    }
                                                                                                                }));
    }

    private void KeyPressed(object sender, KeyPressedEventArgs keyPressedEventArgs)
    {
            var key = keyPressedEventArgs.Key;
            if (Time.timeScale == 0 || 
                (CurrentState != LevelStates.DoingWave) && 
                (CurrentState != LevelStates.WaitingToClearRemainingEnemies) && 
                (CurrentState != LevelStates.BossBattle) &&
                (CurrentState != LevelStates.WaveStatistics) &&
                (CurrentState != LevelStates.IncrementingWaveNumber)
                )
            {
                //Debug.Log("Not allowing key due to current state: " + CurrentState);
                return;
            }

        if (!powerupManager.CanPlayerType())
        {
            return;
        }

        /*
            if (enemiesOnScreen.Count < 1)
            {
                // We only want to record keystrokes while there are enemies on screen
                return;
            }
        */

            // Here I need to check whether any of the enemies have a match on the letter
            var enemyContainsKey = EnemiesOnScreen.Any(enemy => enemy.WillKeyMatch(key));
            var powerupContainersContainsKey = powerupManager.WillKeyMatchOnScreenPowerupContainers(key);

            var isKeyMatch = enemyContainsKey || powerupContainersContainsKey;
            if (!isKeyMatch)
            {
                // todo play bad sound
                audio.PlayOneShot(incorrectKeyPressAudio);

                //// This key is not a hit
                 motionBlur.blurAmount += 0.05f;

                // Break the current combo if we have one since the
                ScoreComboManager.BreakCombo();
            }
            else
            {
                // This key is a correct hit
            }

            // Add the pressed key to the statistics
            currentLevelStatistics.InputKey(key, isKeyMatch);

            currentWaveAccuracyHUD.text = String.Format("{0}%", currentLevelStatistics.Accuracy);

            new MessageKeyPressed(key.ToString(CultureInfo.InvariantCulture));
    }

    IEnumerator LevelStatistics_EnterState()
    {
        powerupManager.DeactivatePowerups();
        //heartbeatMonitor.StopBeating();

        StopSpawningEnemies();

        yield return null;
    }

    IEnumerator DoingWave_EnterState()
    {
        InvokeRepeating("GenerateEnemy", 0.1f, enemySpawnInterval);

        if (timeAllocatedToWaveSeconds < 5)
        {
            throw new Exception("Increase the time of the wave.");
        }

        // Wait for that amount to let the wave happen
        yield return new WaitForSeconds(timeAllocatedToWaveSeconds);

        // Increase the timespan for the next wave so that the next wave is longer
        timeAllocatedToWaveSeconds++;

        // If we're still doing the wave
        if (CurrentState == LevelStates.DoingWave)
        {
            // Now we need to wait until all remaining eliminated are elimated
            CurrentState = LevelStates.WaitingToClearRemainingEnemies;
        }
    }

    IEnumerator WaitingToClearRemainingEnemies_EnterState()
    {
        StopSpawningEnemies();

        // While there are still enemies on screen, wait...
        while (EnemiesOnScreen.Count > 0)
        {
            yield return null;
        }

        //// All the enemies are cleared!
        StartCoroutine(HomelessMethods.Interpolate(0f, 1f, 0.5f, InterpolationMethods.Lerp, i =>
        {
            waveCompletePanel.alpha = i;
        }));

        yield return new WaitForSeconds(1.8f);

        // Play the audio signifying the new wave
        audio.PlayOneShot(waveStartAudio);

        // Show the wave statistics screen
        CurrentState = LevelStates.WaveStatistics;

        StartCoroutine(HomelessMethods.Interpolate(1f, 0f, 0.5f, InterpolationMethods.Lerp, i =>
        {
            waveCompletePanel.alpha = i;
        }));

        // Wait some time before transitioning to the Wave Statistics screen
        // yield return new WaitForSeconds(1);
    }

    IEnumerator WaveStatistics_EnterState()
    {
        // Record the completed wave
        currentLevelStatistics.WavesCompleted++;

        // Wait for the combo to break before submitting the scores, to make sure we submit the correct high score.
        StartCoroutine(HomelessMethods.InvokeInSeconds(1f, () =>
        {
            // Update the stats on Kongregate
            kongregateApi.SubmitStatistic("High Score", GameStatistics.Instance.Score);
            kongregateApi.SubmitStatistic("Highest Wave Reached", currentLevelStatistics.WavesCompleted);
            kongregateApi.SubmitStatistic("Total Waves Played", 1);
            kongregateApi.SubmitStatistic("WPM", currentLevelStatistics.WordsPerMinute);
        }));

        // For now, since I'm not showing any statistics, I'm just gonna wait for x seconds and then start the new wave
        yield return new WaitForSeconds(1.5f);
        CurrentState = LevelStates.IncrementingWaveNumber;
    }

    IEnumerator IncrementingWaveNumber_EnterState()
    {
        // Increment the current wave
        currentWave += 1;

        powerupManager.ResetPowerupCounter();

        // Set the wave number or BOSS text
        waveNumberHUD.text = currentWave.ToString("00");

        CurrentState = currentWave > wavesBeforeBoss ? LevelStates.BossBattle : LevelStates.DoingWave;

        yield return null;
    }

    IEnumerator BossBattle_EnterState()
    {
        /*
        wasBossReleased = true;

        StartCoroutine(HomelessMethods.Interpolate(tiltShiftEffect.focalPoint, 20f, 5f, InterpolationMethods.Lerp, f =>
                                                                                                                       {
                                                                                                                           tiltShiftEffect.focalPoint = f;
                                                                                                                       }));
            
        bossBehaviour = GenerateBoss();

	    iTween.MoveTo(MainCamera.gameObject, new Hashtable
	        {
	            {"path", iTweenPath.GetPath("BossCameraPath")},
	            {"movetopath", false},
	            {"easetype", iTween.EaseType.linear},
	            {"time", 2.0f},
	            //{"orienttopath", true},
	            {"looktime", 0.1f},
	            {"oncompletetarget", gameObject},
	            {"oncomplete", "OnCameraBossMoveComplete"},
	        });

        //MainCamera.transform.LookAt(bossBehaviour.transform);

        */
        yield return null;
    }

    IEnumerator OnCameraBossMoveComplete()
    {
        // MainCamera.transform.LookAt(bossBehaviour.WordPosition);
        //var cameraLookRotation = Quaternion.LookRotation(MainCamera.transform.position, bossBehaviour.WordPosition).eulerAngles;
        /*
        var currentRotation = MainCamera.transform.eulerAngles;
        Debug.Log("Current rotation: " + currentRotation);
        var cameraLookRotation = Quaternion.LookRotation(bossBehaviour.WordPosition, MainCamera.transform.position).eulerAngles;
        //cameraLookRotation.x = 0;
        cameraLookRotation.z = 0;
        StartCoroutine(HomelessMethods.Interpolate(transform.rotation, Quaternion.Euler(cameraLookRotation), 1f, Quaternion.Slerp,quaternion =>
                                                                                                                                        {
                                                                                                                                            MainCamera.transform.rotation = quaternion;
                                                                                                                                        },() =>
                                                                                                                                              {
                                                                                                                                                  cameraLookingAtBoss = true;
                                                                                                                                              }));
        */

        yield return new WaitForSeconds(10f);
        cameraLookingAtBoss = true;
        yield return null;
    }

    private void IncreaseWordDifficulty() {
        if (GameSettings.IsSecretActivated(SecretCode.WTF))
        {
            wordDifficultyPercentage = 100;
        } else
        {
            wordDifficultyPercentage += 0.3f;
        }

        wordDifficultyPercentage = Mathf.Clamp(wordDifficultyPercentage, 1, 100);
    }

    private string FormatScore(int score, string leadingZerosRGBColor, int totalDigits)
    {
        var scoreString = score.ToString(CultureInfo.InvariantCulture);
        var zeros = totalDigits - scoreString.Length;
        if (score == 0)
        {
            scoreString = String.Empty;
            zeros++;
        }

        return String.Format("[{0}]{1}[-]{2}", leadingZerosRGBColor, new string('0', zeros <= 0 ? 0 : zeros), scoreString);
    }

    private void UpdateScoreLabel(float score)
    {
        var scoreString = FormatScore((int) score, "7b787b", 10);
        scoreBoard.supportEncoding = true;
        scoreBoard.text = scoreString;
    }

    // Increments the current score by the given increment
	private void UpdateScore(int increment)
	{
	    var previousScore = GameStatistics.Instance.Score;
        StartCoroutine(HomelessMethods.Interpolate(previousScore, (float)previousScore + increment, 0.5f, Mathf.SmoothStep, i => UpdateScoreLabel(Mathf.Floor(i))));
		GameStatistics.Instance.Score += increment;
	}

    private readonly List<Vector3> spawnpoints = new List<Vector3>();
    private void OnDrawGizmos()
    {
        Gizmos.DrawCube(spawnpointLineCenter, Vector3.one*5);
        Gizmos.DrawCube(spawnpointLinePointA, Vector3.one*5);
        Gizmos.DrawCube(spawnpointLinePointB, Vector3.one*5);
        /*
            foreach (var spawnpoint in spawnpoints)
            {
                    Gizmos.DrawSphere(spawnpoint, 5);
            }
         */
    }

    public IEnumerable<string> GenerateWords(int numberOfWords)
    {
        for (int i = 0; i < numberOfWords; i++)
        {
            var randomWordIndex = GetDifficultyWordIndex(wordDifficultyPercentage);

            string word;
            if (words.Count < 1 || randomWordIndex < 0)
            {
                wordDifficultyPercentage = 0;
                randomWordIndex = 0;

                if (originalDictionary.Count < 100)
                {
                    words = originalDictionary.ToList();
                } else
                {
                    var bottomWordsPercentage = 0.01f;
                    int wordsToTake = (int) Math.Ceiling(words.Count*bottomWordsPercentage), wordsToSkip = words.Count - wordsToTake;
                    words = words.Count < 100 ? words.ToList() : words.Skip(wordsToSkip).Take(wordsToTake).ToList();
                }
            } 

            word = words.ElementAt(randomWordIndex);
            words.RemoveAt(randomWordIndex);

            yield return word;
        }
    }

    /// <summary>
    /// Currently also increases word difficulty with each spawn
    /// </summary>
	private void GenerateEnemy()
    {
        IncreaseWordDifficulty();
		//var entrance = entrances[UnityEngine.Random.Range(0, entrances.Count)];
		//var somewhereInEntranceX = UnityEngine.Random.Range(entrance.Left.x, entrance.Right.x);

        //var spawnPosition = spawnPoint.transform.position;
        var spawnPosition = GetNextEnemySpawnpoint();

        spawnpoints.Add(spawnPosition);
        /*
        var ray = new Ray(spawnPosition + Vector3.up * 2.7f, player.transform.position - spawnPosition);
        var distance = Vector3.Distance(spawnPosition, player.transform.position);

        RaycastHit hit;
        var rayHit = Physics.Raycast(ray, out hit, distance, letterlayer.value);
        Debug.DrawLine(ray.origin, ray.origin + (ray.direction * distance), Color.red, 200);

        var colliders = Physics.OverlapSphere(spawnPosition, 3f, letterlayer.value);
        //Debug.Log("Colliders: " + colliders.Length);
        if (colliders.Length > 0)
        {
            Debug.Log("Returning because too close");
            return;
        }

        //var rayHit = Physics.SphereCast(ray, 10f, out hit, 10, letterlayer.value);
        if (rayHit)
        {
            //Debug.Log("Hit: " + hit.transform.gameObject.name);
            return;
        }
        */

        //Debug.DrawRay(spawnPosition, player.transform.position - spawnPosition, Color.red, 10);
        // Instantiate the enemy
		var root = (GameObject)Instantiate(enemyModel, spawnPosition, Quaternion.identity);
        root.SetActive(true);
        var enemyBehaviour = root.GetComponent<EnemyBehaviour>();
        enemyBehaviour.OnRequestToDie += enemyBehaviour_OnRequestToDie;
        var model =(GameObject)Instantiate(GetRandomEnemyModel(enemyBehaviour), spawnPosition, Quaternion.identity);
        model.transform.parent = root.transform;
        model.name = "Model";
        var enemySettings = model.GetComponent<EnemySettings>();

        // Generate a random number based on the model's maximum allowed words.
        var numberOfWordsForEnemy = UnityEngine.Random.Range(1, enemySettings.maximumNumberOfWords + 1); // The Range() integer overload's max parameter is exclusive -_-

        // Generate the number of words we'll use for the enemy
        var wordsForEnemy = GenerateWords(numberOfWordsForEnemy).ToList();
        
        // Set the words on the enemy
        enemyBehaviour.SetWords(wordsForEnemy);
        root.name = String.Format("Enemy: {0}", wordsForEnemy.FirstOrDefault());

        // Add the enemy to our collection of enemies on screen
	    EnemiesOnScreen.Add(enemyBehaviour);
    }

    void enemyBehaviour_OnRequestToDie(object sender, EnemyRequestToDieEventArgs e)
    {
        KillEnemy((IEnemy)sender, e.Reason, e.HitWorldPosition);
    }

    /*
    private BossBehaviour GenerateBoss()
    {
        var bossesWords = new List<string>();
        var totalBossWords = HomelessMethods.Map(difficulty, 1, 100, 5, 15);
        for (int i = 0; i < totalBossWords; i++)
        {
            var wordIndex = GetDifficultyWordIndex(wordDifficultyPercentage += 2);
            var wordText = words.ElementAt(wordIndex);
            bossesWords.Add(wordText);
        }

        var bossInstance = (GameObject)Instantiate(boss, new Vector3(-41.82707f, -3.313119f, 48.19384f), Quaternion.identity);
        bossInstance.SetActive(true);
        var enemy = bossInstance.GetComponent<BossBehaviour>();
        enemy.SetWords(bossesWords);

	    EnemiesOnScreen.Add(enemy);

        return enemy;
    }
    */

    /// <summary>
    /// Returns a random model based on the model's weight
    /// </summary>
    private GameObject GetRandomEnemyModel(EnemyBehaviour behaviour)
    {
        // enemybehaviour is not needed in here...

        // Filter the models to only allow the ones which are activated
        var enabledModels = enemyModels.Where(enemy =>
        {
            var settings = enemy.GetComponent<EnemySettings>();

            return settings.activated && settings.appearsInWaveNumber <= currentWave;
        }).ToList();

        // Get a random model based on their weight
        var randomModel = enabledModels.Select(m => m.GetComponent<EnemySettings>()).Cast<IWeighable>().GetRandomWeightedElement<EnemySettings>();
        return randomModel.gameObject;
    }

	/// Gets an index based on the difficulty
	private int GetDifficultyWordIndex(float difficultyPercentage) {
		var wordIndex = Math.Floor((difficultyPercentage / 100) * (words.Count - 1));
		var randomWordIndex = UnityEngine.Random.Range((float)(wordIndex - difficultyRange), (float)(wordIndex + difficultyRange));
        var clamped = Mathf.Clamp(randomWordIndex, 0f, words.Count - 1);
	    return (int) clamped;
	}

    private void StopSpawningEnemies()
    {
        // Now we've past the time of the wave, so stop spawning enemies
        CancelInvoke("GenerateEnemy");
    }

    /// <summary>
    /// Returns and returns the collection of words 
    /// </summary>
	private List<string> ReadFile() {
        string dictionary = String.Format("Dictionaries/{0}", GameSettings.IsSecretActivated(SecretCode.LOL) ? "rofl" : "dict");
        // string dictionary = String.Format("Dictionaries/{0}", "rofl");
        var loaded =  (TextAsset)Resources.Load(dictionary);
        var lines =loaded.text.Split('\n').Where(line => !String.IsNullOrEmpty(line)).Select(s => TrimNonAscii(s.Trim())).OrderBy(s => s.Length).ToList();
        if (GameSettings.IsSecretActivated(SecretCode.PLess))
        {
            lines.RemoveAll(s => s.Contains("p"));
        }

        return lines.ToList();
	}

    public static string TrimNonAscii( string value)
    {
        string pattern = "[^ -~]*";
        Regex reg_exp = new Regex(pattern);
        return reg_exp.Replace(value, "");
    }
}
