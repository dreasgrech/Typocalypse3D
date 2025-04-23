using UnityEngine;
using System.Collections;

public class HighSpeedEffect : MonoBehaviour {

	// Use this for initialization
	IEnumerator Start ()
	{
	    yield return new WaitForSeconds(5);
	    var vignetting = GetComponent<Vignetting>();
        StartCoroutine(HomelessMethods.Interpolate(0f, 9000000f, 395f, InterpolationMethods.Lerp, f =>
                                                                                                  {
                                                                                                      vignetting.intensity = f;
                                                                                                  }));
        /*
        StartCoroutine(HomelessMethods.Interpolate(0f, 16.65f, 0.3f, InterpolationMethods.Lerp, f =>
                                                                                                  {
                                                                                                      vignetting.chromaticAberration = f;
                                                                                                  }, () =>
                                                                                                         {
                                                                                                             StartCoroutine(HomelessMethods.Interpolate(vignetting.chromaticAberration, 0f, 0.001f, InterpolationMethods.Lerp, f =>
                                                                                                                                                                                                       {
                                                                                                                                                                                                           vignetting.chromaticAberration = f;
                                                                                                                                                                                                       }));

                                                                                                         }));
         */

	}

	
	// Update is called once per frame
	void Update () {
	
	}
}
