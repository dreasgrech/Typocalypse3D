using UnityEngine;


public class SpawnpointMovement : MonoBehaviour
{
    public int minSpeed = 50;
    public int maxSpeed = 100;

    private Transform pointA;
    private Transform pointB;

    private Vector3 to;
	private float currentSpeed;

	void Start () {
		GameObject spawnpointPositions = GameObject.FindGameObjectsWithTag("SpawnpointPositions")[0];
	    pointA = spawnpointPositions.transform.Find("PointA");
		pointB = spawnpointPositions.transform.Find("PointB");
		transform.position = pointA.position;
	}

	void Update () {
		if (transform.position == pointA.position) {
			to = pointB.position;
			currentSpeed = Random.Range(minSpeed, maxSpeed);
		} else if (transform.position == pointB.position) {
			to = pointA.position;
			currentSpeed = Random.Range(minSpeed, maxSpeed);
		}

		transform.position = Vector3.MoveTowards(transform.position, to, currentSpeed*Time.deltaTime);
	}
}
