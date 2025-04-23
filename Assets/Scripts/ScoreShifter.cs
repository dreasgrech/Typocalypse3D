using UnityEngine;
using System.Collections;

public class ScoreShifter : MonoBehaviour
{
    public UILabel scoreLabel;
    public string startingScore;

    private const float numberWidth = 0.05f;

    // Use this for initialization
	IEnumerator Start ()
	{
	    scoreLabel.text = startingScore;
	    yield return new WaitForSeconds(2);
	    ShiftLeft();
	}

    private void ShiftLeft()
    {
        StartCoroutine(HomelessMethods.Interpolate(transform.position.x, transform.position.x - numberWidth, 0.5f, Mathf.Lerp, x =>
                                                                                                                      {
                                                                                                                          transform.position = new Vector3(x, transform.position.y, transform.position.z);
                                                                                                                      }));
    }
	
	// Update is called once per frame
	void Update () {
	
	}
}
