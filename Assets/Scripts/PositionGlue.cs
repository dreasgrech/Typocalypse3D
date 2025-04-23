using UnityEngine;
using System.Collections;

public class PositionGlue : MonoBehaviour
{

    private Vector3 initialPosition;
	// Use this for initialization
	void Start ()
	{
	    initialPosition = transform.position;

	}
	
	// Update is called once per frame
	void Update ()
	{
	    transform.position = initialPosition;
	}
}
