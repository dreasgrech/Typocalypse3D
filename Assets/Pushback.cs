using UnityEngine;
using System.Collections;

public class Pushback : MonoBehaviour {

	// Use this for initialization
	IEnumerator Start ()
	{
	    var bossAnimation = transform.parent.GetComponent<Animation>();
	    yield return new WaitForSeconds(1);
        bossAnimation.Stop();
	    rigidbody.isKinematic = false;
	    //Vector3 force = Vector3.forward*50000f;
        rigidbody.AddForce(Vector3.forward*5000);
        //rigidbody.AddExplosionForce(100000, Vector3.zero, 5);
        yield return new WaitForSeconds(0.2f);
        bossAnimation.CrossFade("Walk");
        //rigidbody.AddForceAtPosition(force, new Vector3(0, -50, 0));
	}
	
	// Update is called once per frame
	void Update () {
	
	}
}
