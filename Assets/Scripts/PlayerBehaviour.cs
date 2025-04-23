using UnityEngine;
using System;
using System.Collections;

public enum PlayerStates
{
    Playing,
    Dying
}

public class PlayerBehaviour : StateMachine<PlayerStates> {
    public int maxBulletsToFire = 20;
    public GameObject muzzleFlash;

    public AudioClip machineGunFire;
    public DyingAnimation dyingAnimation;
    public GameObject gun;

    private AudioManager audioManager;

	private void Start()
	{
	    audioManager = (AudioManager)FindObjectOfType(typeof (AudioManager));
        Messenger.instance.Listen("game", gameObject);
        dyingAnimation = transform.GetComponent<DyingAnimation>();

	    CurrentState = PlayerStates.Playing;
	}

    IEnumerator Player_EnterState()
    {
        ApplyIdleAnimation();
        yield return null;
    }
    
    public void Shoot(Transform target, int bulletsToFire)
    {
        StartCoroutine(FireAtTarget(target, bulletsToFire));
    }

    IEnumerator Dying_EnterState()
    {
        gun.AddComponent<Rigidbody>();
        gun.AddComponent<BoxCollider>();

        dyingAnimation.PlayAnimation(EnemyDiedReason.PlayerDied, 1f);
        new MessagePlayerDied();

        yield return null;
    }


    private IEnumerator FireAtTarget(Transform target, int bulletsToFire)
    {
		// Look at the enemy before we start shooting
		transform.LookAt(target.position);

        // Show the firing animation
		animation.CrossFade("Firing");

		// play the machine gun noise
        var randomPitch = InterpolationMethods.Lerp(0.9f, 1.1f, UnityEngine.Random.Range(0f, 1f));
        audio.pitch = randomPitch;
        audio.Play();//PlayOneShot(machineGunFire);

        // show the muzzle flash
        muzzleFlash.SetActive(true);

        yield return new WaitForSeconds(0.5f);

        // Stop showing the muzzle flash
		muzzleFlash.SetActive(false);

        ApplyIdleAnimation();
    }

    private void ApplyIdleAnimation()
    {
        // Switch the animation to idle
		animation.CrossFade("Shooting Idle");
    }

    private void _EnemyStrike(MessageEnemyStrike message)
    {
        if (CurrentState == PlayerStates.Dying)
        {
            // we're already dead
            return;
        }

        CurrentState = PlayerStates.Dying;
    }
}
