#pragma strict

public var explosion : GameObject;

function Start () {
	yield WaitForSeconds(1);
	Explode();
}

function Update () {

}

function Explode() {
	explosion.active = true;
	Instantiate(explosion, transform.position, transform.rotation);
	transform.rigidbody.AddTorque(Vector3.left * 50);

	transform.rigidbody.AddForce(Vector3.up * 350);
	transform.rigidbody.AddForce(new Vector3(-0.2, transform.position.y, transform.position.z) * 50);
}

function OnCollisionEnter(collision : Collision) {
	//Explode();
}
