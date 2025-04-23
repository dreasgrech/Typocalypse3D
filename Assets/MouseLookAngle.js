#pragma strict

function Start () {

}

function Update () {
	var aimWorldP = Camera.main.ScreenToWorldPoint(Input.mousePosition);
	aimWorldP.z = transform.position.z;
	transform.LookAt(aimWorldP);
}
