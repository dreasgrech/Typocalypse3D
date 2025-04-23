using System.Linq;
using UnityEngine;

[RequireComponent (typeof (Animation))]
public class DyingAnimation : MonoBehaviour {
    public AnimationClip[] assaultRifleDeathAnimations;
    public AnimationClip[] sniperRifleDeathAnimations;

	// Use this for initialization
	private void Start (){
	    foreach ( var animationClip in assaultRifleDeathAnimations.Concat(sniperRifleDeathAnimations))
	    {
            animation.AddClip(animationClip, animationClip.name);
	    }
	}
	
    /// <summary>
    /// Plays a random dying animation
    /// </summary>
    /// <param name="animationSpeed">0..1</param>
	public void PlayAnimation(EnemyDiedReason reason, float animationSpeed) {
        // Adjust the speed of the animation
        animation.ChangeAnimationSpeed(animationSpeed);

		var randomDyingAnimation = GetAnimation(reason);
		animation.CrossFade(randomDyingAnimation.name, 0.2f);
	}

    private AnimationClip GetAnimation(EnemyDiedReason reason)
    {
        if (reason == EnemyDiedReason.HitBySniper)
        {
            return sniperRifleDeathAnimations.GetRandomElement();
        }

        return assaultRifleDeathAnimations.GetRandomElement();

    }
}
