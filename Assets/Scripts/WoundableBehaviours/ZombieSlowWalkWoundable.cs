using UnityEngine;
using System.Collections;

public class ZombieSlowWalkWoundable : MonoBehaviour, IWoundable
{
    public IEnumerator DoWoundRoutine(Animation modelAnimation)
    {
        var reactionAnimation = "Zombie Hit Reaction 1";
        var animationLength = modelAnimation[reactionAnimation].clip.length;

        modelAnimation.ChangeAnimationSpeed(2.19f);
        modelAnimation.CrossFade(reactionAnimation, 0.5f);
        yield return new WaitForSeconds(0.8f);
        modelAnimation.ChangeAnimationSpeed(1f);
    }

    public float TimeForNextWordToAppearAfterWounded { get { return 0.5f; } }
}
