using UnityEngine;
using System.Collections;

public class ConstantInterpolation : MonoBehaviour
{

    private float angle = 1;
	// Use this for initialization
	void Start () {
	
	}
	
	// Update is called once per frame
	void Update ()
	{
        transform.Rotate(0, angle, 0);
	}
}
