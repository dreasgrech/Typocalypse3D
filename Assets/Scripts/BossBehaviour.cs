using System.Collections.Generic;
using System.Linq;
using UnityEngine;
using System.Collections;

public enum BossStates
{
    WalkFromOutToEdge,
    TurnAndJump,
    StartComingTowards,
    ComingTowards,
    Resting,
    Dead,
    Attacking
}

public class BossBehaviour : StateMachine<BossStates>, IEnemy
{
    public Animation bossAnimation;
    public AudioClip hitAudio;

    public bool Dead { get { return CurrentState == BossStates.Dead; } }
    public string Text { get; set; }
    public Vector3 Position { get { return transform.position; } }
    public Vector3 WordPosition { get { return textManipulation.WordPosition; } }
    public Stack<string> WordsLeft { get { return textManipulation.WordsLeft; } }
    public EnemySettings Settings { get; private set; }
    public Rigidbody ragdollRigidbody;

    private TextManipulation textManipulation;
    private List<string> words;
    private int currentWordIndex;
    //private BloodSquirter bloodSquirter;
    private UIPanelSlider bossHealthSlider;

    public void SetWords(IEnumerable<string> wordTexts)
    {
        words = wordTexts.ToList();
        Settings = GetComponent<EnemySettings>();
	    //bloodSquirter = GetComponent<BloodSquirter>();

	    textManipulation = transform.GetComponent<TextManipulation>();
        textManipulation.SetWords(words);

	    bossHealthSlider = GameObject.FindWithTag("BossAvatar").GetComponent<UIPanelSlider>();
        ChangeAvatarOpacity(1);

        bossHealthSlider.MoveSlider(1, 3f);

	    CurrentState = BossStates.WalkFromOutToEdge;
    }

    public void Obliterate()
    {
        Destroy(gameObject);
    }

    public void HighlightWord()
    {
        throw new System.NotImplementedException();
    }

    public void StopWalking()
    {
        throw new System.NotImplementedException();
    }

    public void ShowScore(int score)
    {
        throw new System.NotImplementedException();
    }

    public bool WillKeyMatch(char key)
    {
        return textManipulation.WillKeyMatch(key);
    }

    public bool ShouldDieImmediately(EnemyDiedReason reason)
    {
        return false;
    }

    /// <summary>
    /// Called when a word was matched
    /// </summary>
    /// <param name="bulletsFired">The number of bullets that were fired</param>
    public void ApplyDamage(EnemyDiedReason reason, int bulletsFired, Vector3 hitWorldPosition)
    {
        // Squirt out some blood
        var bloodPosition = Settings.GetRandomBloodPosition();
        //bloodSquirter.Squirt(bloodPosition, 0);

        // Play the just-been-hit audio
        audio.PlayOneShot(hitAudio);

        // Increase the current word index since we now will want the next word to appear
        currentWordIndex++;

        // Decrease the health bar
        var newSliderValue = 1 - (float) currentWordIndex/words.Count;
        Debug.Log("Boss slider: " + newSliderValue);
        bossHealthSlider.MoveSlider(newSliderValue, 1f);

        var wasEnemyKilled = textManipulation.WordsLeft.Count == 0;
        // If all the words are done, then the boss is dead
        if (wasEnemyKilled)
        {
            CurrentState = BossStates.Dead;
            return;
        }

        // Otherwise, show the next word
        Text = words.ElementAt(currentWordIndex);
        textManipulation.UseNextWord();

        if ((currentWordIndex % 2) == 0)
        {
            //CurrentState = BossStates.Resting;
        }
    }

    IEnumerator Resting_EnterState()
    {
        iTween.Pause(gameObject);
        bossAnimation.CrossFade("Attack_Melee");
        bossAnimation.CrossFadeQueued("Idle");
        yield return new WaitForSeconds(2);
        CurrentState = BossStates.ComingTowards;
    }

    IEnumerator ComingTowards_EnterState()
    {
        bossAnimation.CrossFade("Walk");
        iTween.Resume(gameObject);
        yield return null;
    }

    IEnumerator Dead_EnterState()
    {
        // Remove the last word
        textManipulation.DestroyWord(false);

        // Stop the path movement
        iTween.Pause(gameObject);

        // Stop the animation to enable the ragdoll!
        bossAnimation.Stop();

        // Let the bodies hit the ground!
        ragdollRigidbody.isKinematic = false;
        ragdollRigidbody.AddForce(new Vector3(500f, 200f));

        yield return null;
    }

    IEnumerator StartComingTowards_EnterState()
    {
        yield return new WaitForSeconds(1);


        // Start the walking animation
        bossAnimation.CrossFade("Walk");

        // Start showing the words
        Text = words.ElementAt(currentWordIndex);
        textManipulation.UseNextWord();

        // Start walking along the path
	    iTween.MoveTo(gameObject, new Hashtable
	        {
	            {"path", iTweenPath.GetPath("BossPath2")},
	            {"movetopath", false},
	            {"easetype", iTween.EaseType.linear},
	            {"speed", 3.5f},
	            {"orienttopath", true},
	            {"looktime", 0.1f},
	            {"oncompletetarget", gameObject},
	            {"oncomplete", "OnComingTowardsComplete"},
	        });

        yield return null;
    }

    private void ChangeAvatarOpacity(float alpha)
    {
        var outerPanel = bossHealthSlider.GetComponent<UIPanel>();
	    var innerPanel = bossHealthSlider.GetComponentsInChildren<UIPanel>().Skip(1).First();
        Debug.Log(innerPanel);

        StartCoroutine(HomelessMethods.Interpolate(outerPanel.alpha, alpha, 0.5f, Mathf.Lerp, f =>
                                                                                                  {
                                                                                                      outerPanel.alpha = f;
                                                                                                      innerPanel.alpha = f;
                                                                                                  }));
    }

    private IEnumerator Attacking_EnterState()
    {
		bossAnimation.CrossFadeQueued("Attack_Melee", 0.3f, QueueMode.PlayNow);
        yield return new WaitForSeconds(Settings.animationPlayerHitSeconds);

        // If we haven't been killed while doing the hit animation, kill the player!
        if (CurrentState == BossStates.Attacking)
        {
            Debug.Log("Hitting player");
            new MessageEnemyStrike(this);
            bossAnimation.CrossFadeQueued("Idle", 0.3f, QueueMode.CompleteOthers);
        }
    }

    /// <summary>
    /// When the boss arrives at the destination, it starts attacking!
    /// </summary>
    private void OnComingTowardsComplete()
    {
        CurrentState = BossStates.Attacking;
    }

    IEnumerator WalkFromOutToEdge_EnterState()
    {
	    iTween.MoveTo(gameObject, new Hashtable
	        {
	            {"path", iTweenPath.GetPath("BossPath1")},
	            {"movetopath", false},
	            {"easetype", iTween.EaseType.linear},
	            {"speed", 4},
	            //{"speed", 8},
	            {"orienttopath", true},
	            {"looktime", 0.1f},
	            {"oncompletetarget", gameObject},
	            {"oncomplete", "OnWalkFromOutToEdgePathComplete"},
	        });

        yield return null;
        //yield return StartCoroutine(StopMovement());
    }

    IEnumerator TurnAndJump_EnterState()
    {
        bossAnimation.CrossFade("Idle");
        yield return new WaitForSeconds(0.5f);
        bossAnimation.CrossFade("Turn_Left");
        yield return new WaitForSeconds(1);
        bossAnimation.CrossFade("Turn_Right");
        yield return new WaitForSeconds(1);
        bossAnimation.CrossFade("Idle");
        CurrentState = BossStates.StartComingTowards;
    }

    private void OnWalkFromOutToEdgePathComplete()
    {
        CurrentState = BossStates.TurnAndJump;
    }

    IEnumerator StopMovement()
    {
        yield return new WaitForSeconds(3);
        iTween.Pause(gameObject);
        Hit();
        yield return new WaitForSeconds(2);
        Hit();
        yield return new WaitForSeconds(1);
        bossAnimation.CrossFade("Run");
        iTween.Resume(gameObject);
    }

    private void Hit()
    {
        //bossAnimation.CrossFade("Attack_Melee");
        //bossAnimation.CrossFadeQueued("Idle");
    }
}
