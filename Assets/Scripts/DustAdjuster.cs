using UnityEngine;
using System.Collections;

public class DustAdjuster : MonoBehaviour {

	IEnumerator Start ()
	{
	    var emitter = GetComponent<ParticleEmitter>();
	    emitter.maxEnergy = 0;

	    do
	    {
	        var waitForNextWind = Random.Range(3, 9);
	        yield return new WaitForSeconds(waitForNextWind);

	        StartCoroutine(HomelessMethods.Interpolate(0f, 2f, 3, Mathf.Lerp, i => emitter.maxEnergy = i));
	        StartCoroutine(HomelessMethods.Interpolate(2f, 0f, 3, Mathf.Lerp, i => emitter.maxEnergy = i));
	    } while (true);
	}
}
