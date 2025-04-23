using System;
using System.Linq;
using UnityEngine;
using System.Collections;

public class BodyPartsExplosion : MonoBehaviour
{
    private GlobalBloodSquirter bloodSquirter;
    private bool ran = false;
	// Use this for initialization
	void Awake ()
	{
        IterateParts(part => part.gameObject.SetActive(false));
	}

    public void GoBoom(Vector3 worldPosition)
    {
        if (ran)
        {
            return;
        }

	    bloodSquirter = (GlobalBloodSquirter)FindObjectsOfType(typeof(GlobalBloodSquirter)).First();

        ran = true;
        transform.position = worldPosition;
        IterateParts(part => part.gameObject.SetActive(true));
        bloodSquirter.Squirt(transform.position, 100, 2f);

	    var explositionPosition = transform.position;
	    var explosionForce = UnityEngine.Random.Range(800f, 1200f);
        IterateParts(parts =>
        {
	        var rigidBody = parts.GetComponent<Rigidbody>();
            if (rigidBody != null)
            {
                rigidBody.AddExplosionForce(explosionForce, explositionPosition, 0f, 0.0f);//, ForceMode.Impulse);
                StartCoroutine(HomelessMethods.InvokeInSeconds(7f, () => Destroy(rigidBody.gameObject)));
            }
        });

        StartCoroutine(SelfDestruct(7f));
    }

    private IEnumerator SelfDestruct(float seconds)
    {
        yield return new WaitForSeconds(seconds);
        Destroy(gameObject);
    }

    void IterateParts(Action<Transform> callback)
    {
        foreach (Transform part in transform)
        {
            callback(part);
        }
    }
}
