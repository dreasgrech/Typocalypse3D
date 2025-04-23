using UnityEngine;
using System.Collections;

public class ZombieWomanCrawlerWounded : MonoBehaviour, IWoundable {

    public float TimeForNextWordToAppearAfterWounded { get { return 0.2f; }}

    public IEnumerator DoWoundRoutine(Animation modelAnimation)
    {
        yield return new WaitForSeconds(0.5f);
    }
}
