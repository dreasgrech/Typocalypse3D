using UnityEngine;
using System.Collections;

public class EnemyAnimationHandler : MonoBehaviour
{
    public AnimationClip defaultWalk;
    public AnimationClip hitPlayer;
    public AnimationClip winShowoff;

    // Use this for initialization
    void Awake()
    {
        animation.AddClip(defaultWalk, defaultWalk.name);
        animation.AddClip(hitPlayer, hitPlayer.name);
        animation.AddClip(winShowoff, winShowoff.name);
    }

    public void Walk()
    {
        animation.CrossFade(defaultWalk.name);
    }

    public void HitPlayer()
    {
		animation.CrossFadeQueued(hitPlayer.name, 0.3f, QueueMode.PlayNow);
    }

    public void WinShowoff()
    {
        animation.CrossFadeQueued(winShowoff.name, 0.3f, QueueMode.CompleteOthers);
    }
}
