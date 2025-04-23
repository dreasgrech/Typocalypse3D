using System;
using Assets.Scripts;
using UnityEngine;
using System.Collections;

public class JumpToPlayerAttack : MonoBehaviour
{
    public event EventHandler<EventArgs> OnStartedAttacking;

    public Transform model;
    public Animation modelAnimation;
    public AnimationClip jumpingAnimation;
    public EnemyAnimationHandler modelAnimationHandler;

    private IEnemy enemy;
    private bool startedAttacking;

	// Use this for initialization
	void Start() {
        modelAnimation.AddClip(jumpingAnimation, jumpingAnimation.name);
	    enemy = transform.parent.GetCustomComponent<IEnemy>();
	}
	
	// Update is called once per frame
	void Update () {
            var distanceFromPlayer = Vector3.Distance(transform.position, GlobalVariables.Player.transform.position);
            if (distanceFromPlayer < 5)
            {
                if (startedAttacking)
                {
                    return;
                }

                StartCoroutine(Attack());
                startedAttacking = true;
            }
	}

    private IEnumerator Attack()
    {
        enemy.StopWalking();
        modelAnimation.CrossFade(jumpingAnimation.name);
        yield return new WaitForSeconds(4f);
        var zombie = (EnemyBehaviour) enemy;
        //model.position = model.position + model.forward*1f;
        modelAnimation.CrossFade(modelAnimationHandler.hitPlayer.name);
    }
}
