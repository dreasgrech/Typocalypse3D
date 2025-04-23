using System;
using UnityEngine;
using System.Collections;
using Random = UnityEngine.Random;

public class ThankYouForPlaying : MonoBehaviour
{
    private UILabel label;

	IEnumerator Start ()
	{
	    label = GetComponent<UILabel>();

	    while (true)
	    {
	        yield return StartCoroutine(InterMilan(Color.white, Color.blue));
	        yield return StartCoroutine(InterMilan(Color.blue, Color.yellow));
	        yield return StartCoroutine(InterMilan(Color.yellow, Color.red));
	        yield return StartCoroutine(InterMilan(Color.red, Color.green));
	    }
	}

    IEnumerator InterMilan(Color startColor, Color endColor)
    {
	        var time = Random.Range(0.1f, 0.3f);
            StartCoroutine(HomelessMethods.Interpolate(startColor, endColor, time, Color.Lerp, color =>
            {
                label.color = color;
            }));

	        yield return new WaitForSeconds(time);
    }
	
	// Update is called once per frame
	void Update ()
	{
	}
}
