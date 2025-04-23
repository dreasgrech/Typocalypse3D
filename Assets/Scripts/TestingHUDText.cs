using UnityEngine;
using System.Collections;

public class TestingHUDText : MonoBehaviour
{
    private HUDText hudText;
	// Use this for initialization
	IEnumerator Start ()
	{
	    hudText = GetComponent<HUDText>();
	    int counter = 0;
        while (true)
        {
            hudText.Add(counter++, Color.red, 1f);
            yield return new WaitForSeconds(0.9f);
        }
	}
	
	// Update is called once per frame
	void Update () {
	}
}
