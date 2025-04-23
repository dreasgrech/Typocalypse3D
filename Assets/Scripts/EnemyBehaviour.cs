using System;
using System.Collections.Generic;
using System.Linq;
using Assets.Scripts;
using UnityEngine;
using System.Collections;

public enum EnemyStates
{
    Idle, 
    Walking,
    Attacking,
    Dead,
    Resting
}

public class EnemyBehaviour : StateMachine<EnemyStates>, IEnemy, IWeighable, ISniperPowerupClickable
{
	public AudioSource dyingAudio;
    public bool Dead { get { return CurrentState == EnemyStates.Dead; } }
    public string Text { get; set; }
    public Vector3 Position { get { return transform.position; } }
    public Vector3 WordPosition { get { return textManipulation.WordPosition; } }
    public Stack<string> WordsLeft { get { return textManipulation.WordsLeft; } }
    public EnemySettings Settings { get; private set; }
    public Light wordLight;
    public Light indicatorLight;
    public GameObject hudTextPrefab;
    public Color scoreFatalColor;
    public Color scoreWoundedColor;
    public float Weight { get { return Settings.Weight; } }

    public event EventHandler<EnemyRequestToDieEventArgs> OnRequestToDie;

    private float walkingSpeed;
    private const float enemyHeight = 1.250463f;
    private DyingAnimation dyingAnimation;
    private GlobalBloodSquirter bloodSquirter;
    private TextManipulation textManipulation;
    private GameObject model;
    private IWoundable woundableBehaviour;
    private HUDText scoreHUDText;
    private SkinnedMeshRenderer meshRenderer;
    private Material meshRendererMaterial;
    private Color originalMeshRendererMaterial;
    private EnemyAnimationHandler animationHandler;
    private JumpToPlayerAttack attack;

    private void Start()
    {
        gameObject.SetActive(true);
    }

    void AddScoreHUDText()
    {
        var root = GameObject.FindGameObjectWithTag("HUDText").transform;
		var hudText = NGUITools.AddChild(root.gameObject, hudTextPrefab);
        scoreHUDText = hudText.GetComponent<HUDText>();
		var uiFollowTarget = hudText.AddComponent<UIFollowTarget>();
        uiFollowTarget.gameCamera = GameSettings.GameCamera;
        uiFollowTarget.uiCamera = GameSettings.UICamera;
    }

    public void SetWords(IEnumerable<string> words)
    {
	    model = transform.Find("Model").gameObject;
        //attack = GetComponent<JumpToPlayerAttack>();
        meshRenderer = model.GetComponentInChildren<SkinnedMeshRenderer>();
        meshRendererMaterial = meshRenderer.material;
        originalMeshRendererMaterial = meshRendererMaterial.GetColor("_Color");
        animationHandler = model.GetComponent<EnemyAnimationHandler>();
	    Settings = model.GetComponent<EnemySettings>();
        var wordList = words.ToList();
	    textManipulation = GetComponent<TextManipulation>();
        textManipulation.SetWords(wordList);

        Text = wordList.First();

		// TODO: FindWithTag is costly; find another way to get reference to the player
        woundableBehaviour = model.GetComponent(typeof (IWoundable)) as IWoundable;

	    walkingSpeed = Settings.speed;

	    bloodSquirter = (GlobalBloodSquirter)FindObjectsOfType(typeof(GlobalBloodSquirter)).FirstOrDefault();

		dyingAnimation = model.GetComponent<DyingAnimation>();
		Messenger.instance.Listen("game", gameObject);

        AddScoreHUDText();

        // Start the words
        textManipulation.UseNextWord();
        scoreHUDText.GetComponent<UIFollowTarget>().target = textManipulation.currentWord.transform;

	    CurrentState = EnemyStates.Walking;
    }

    public void Obliterate()
    {
        // Remove the HUDText from the HUD
        Destroy(scoreHUDText.gameObject);

        // Self-obliterate
        Destroy(gameObject);
    }

    public void HighlightWord()
    {
        textManipulation.TurnToRed();
    }

    public void ShowScore(int score)
    {
        var color = textManipulation.WordsLeft.Count > 0 ?  scoreWoundedColor : scoreFatalColor;
        scoreHUDText.Add(String.Format("+{0}",  score), color, 0f);
    }

    /// <summary>
    /// Returns a boolean value indicating whether the given key will match our current string
    /// </summary>
    public bool WillKeyMatch(char key)
    {
        return textManipulation.WillKeyMatch(key);
    }

    public bool ShouldDieImmediately(EnemyDiedReason reason)
    {
        return reason == EnemyDiedReason.HitBySniper || reason == EnemyDiedReason.Landmine || reason == EnemyDiedReason.RapidFire || reason == EnemyDiedReason.C4Area;
    }

    private bool walking = true;
    public void StopWalking()
    {
        walking = false;
    }

    /// <summary>
    /// Starting to walk, so we turn on the word
    /// </summary>
    /// <returns></returns>
    private IEnumerator Walking_EnterState()
    {
        model.animation.ChangeAnimationSpeed(Settings.defaultAnimationSpeed);
        animationHandler.Walk();

        transform.LookAt(GlobalVariables.Player.transform);
        //yield return new WaitForSeconds(1.9f);
        while (CurrentState == EnemyStates.Walking)
        {
            if (walking)
            {
                transform.position = Vector3.MoveTowards(transform.position, GlobalVariables.Player.transform.position, Time.deltaTime*walkingSpeed);

                var distanceFromPlayer = Vector3.Distance(transform.position, GlobalVariables.Player.transform.position);
                if (distanceFromPlayer < 1)
                {
                    CurrentState = EnemyStates.Attacking;
                }
            }

            yield return null;
        }
    }

    /// <summary>
    /// Attack the player
    /// </summary>
    /// <returns></returns>
    private IEnumerator Attacking_EnterState()
    {
		//ChangeAnimationSpeed(1);
		//model.animation.CrossFadeQueued("Zombie Hit", 0.3f, QueueMode.PlayNow);
        animationHandler.HitPlayer();
        yield return new WaitForSeconds(Settings.animationPlayerHitSeconds);

        // If we haven't been killed while doing the hit animation, kill the player!
        if (CurrentState == EnemyStates.Attacking)
        {
            new MessageEnemyStrike(this);

            animationHandler.WinShowoff();
            // model.animation.CrossFadeQueued("Zombie Win", 0.3f, QueueMode.CompleteOthers);
        }

        yield return null;
    }

    private IEnumerator Dead_EnterState()
    {
        // Destroy the box collider so that it won't interfere with anything else in the area
        Destroy(model.GetComponent<BoxCollider>());

        Destroy(wordLight);
        Destroy(indicatorLight);

        // Make the enemy "fade" into the ground in a couple of seconds
        yield return new WaitForSeconds(5);
        StartCoroutine(HomelessMethods.Interpolate(transform.position.y, transform.position.y - 5, 15, Mathf.Lerp, f =>
                                                                                                                      {
                                                                                                                          if (transform == null)
                                                                                                                          {
                                                                                                                              return;
                                                                                                                          }

                                                                                                                          transform.position = new Vector3(transform.position.x, f, transform.position.z);
                                                                                                                      }));
        // Destroy the enemy after some time fading to the ground
        yield return new WaitForSeconds(3);
        Obliterate();
    }

    IEnumerator Resting_EnterState()
    {
        StartCoroutine(HomelessMethods.InvokeInSeconds(woundableBehaviour.TimeForNextWordToAppearAfterWounded,
                                       () => textManipulation.UseNextWord()));
        yield return StartCoroutine(woundableBehaviour.DoWoundRoutine(model.animation));
        var modelPosition = model.transform.position;
        transform.position = model.transform.position;
        model.transform.position = modelPosition;

        CurrentState = EnemyStates.Walking;
    }

    public void ApplyDamage(EnemyDiedReason reason, int bulletsFired, Vector3 hitWorldPosition)
    {
        if (CurrentState ==  EnemyStates.Dead || CurrentState == EnemyStates.Resting)
        {
            return;
        }

        ChangeCelShadingEffect(Color.black);

        const float bloodStainRadius = 1f;
        if (hitWorldPosition != Vector3.zero)
        {
            bloodSquirter.Squirt(hitWorldPosition, 1, bloodStainRadius);
        }
        else
        {
            if (Settings.BloodPositions != null)
            {
                bloodSquirter.Squirt(Settings.GetRandomBloodPosition(), bulletsFired, bloodStainRadius);
            }
        }

        // Remove the word from on top the enemies' head
        textManipulation.DestroyWord(false);

        var wasEnemyInjured = textManipulation.WordsLeft.Count > 0;
        if (ShouldDieImmediately(reason))
        {
            // We do this so that if the enemy was hit by a sniper bullet or stepped on a landmine,
            // it should die immediately
            wasEnemyInjured = false;
        }

        if (wasEnemyInjured)
        {
            //// The enemy still has words left, so he's not dead yet

            // If this is an enemy which can be wounded, wound it now
            if (woundableBehaviour != null)
            {
                CurrentState = EnemyStates.Resting;
            } else
            {
                textManipulation.UseNextWord();
            }
        }
        else
        {
            //// This enemy doesn't have any words left, so he should die.

            if (reason == EnemyDiedReason.Landmine)
            {
                // make the model dissappear because of the explosion
                model.SetActive(false);
            } else
            {
                dyingAnimation.PlayAnimation(reason, 1f);
            }


            var randomPitch = InterpolationMethods.Lerp(0.7f, 1.2f, UnityEngine.Random.Range(0f, 1f));
            dyingAudio.pitch = randomPitch;
            dyingAudio.Play();

            CurrentState = EnemyStates.Dead;
        }
	}

    public void HitBySniperPowerup(Vector3 hitWorldPosition)
    {
        // TODO: central logic must know about this kill!
        //ApplyDamage(1);
        if (OnRequestToDie != null)
        {
            OnRequestToDie(this, new EnemyRequestToDieEventArgs(EnemyDiedReason.HitBySniper, hitWorldPosition));
        }
    }

    public void ChangeCelShadingEffect(Color outline, Color? inner = null)
    {
        meshRendererMaterial.SetColor("_OutlineColor", outline);
        meshRendererMaterial.SetColor("_Color", inner ?? originalMeshRendererMaterial);
    }
}