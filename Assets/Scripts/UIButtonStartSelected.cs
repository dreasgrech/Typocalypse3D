using UnityEngine;
using System.Collections;

public class UIButtonStartSelected : MonoBehaviour {

	// Use this for initialization
	void Start () {
        StartCoroutine(HomelessMethods.InvokeInSeconds(0.1f, () => {UICamera.selectedObject = gameObject; }));
	}
	
	// Update is called once per frame
	void Update () {
	
	}
}
