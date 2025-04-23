using System;
using UnityEngine;
using System.Collections;

public class GroundItemWatcher : MonoBehaviour
{
    public Animation modelAnimation;
    public AnimationClip jumpAnimation;
    public EnemyAnimationHandler enemyAnimationHandler;

    public event EventHandler<EventArgs> OnItemInSight;

    // Use this for initialization
    void Start () {
        modelAnimation.AddClip(jumpAnimation, jumpAnimation.name);
	}
	
	// Update is called once per frame
	void Update () {
	
	}

    void OnTriggerEnter(Collider other)
    {
        if (!other.name.Contains("Landmine"))
        {
            return;
        }

        modelAnimation.CrossFade(jumpAnimation.name);
        modelAnimation.CrossFadeQueued(enemyAnimationHandler.defaultWalk.name);

        Debug.Log("Something in the way: " + other.name);
    }
}
