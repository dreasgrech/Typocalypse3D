using UnityEngine;
using System.Collections;

public class ZombieRunnerWoundable : MonoBehaviour, IWoundable {

    public float TimeForNextWordToAppearAfterWounded { get { return 6.0f; } }

    public IEnumerator DoWoundRoutine(Animation modelAnimation)
    {
        modelAnimation.CrossFade("FallingDown");
        yield return new WaitForSeconds(4f); // The amount of time she stays on the ground
        var model = modelAnimation.gameObject.transform;

        model.position = model.position - model.forward * 1f;
        modelAnimation.ChangeAnimationSpeed(0.6f);
        modelAnimation.Play("standUp");
        yield return new WaitForSeconds(3f);
    }
}
