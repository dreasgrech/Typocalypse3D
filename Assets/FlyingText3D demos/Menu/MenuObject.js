#pragma strict

var highlight : GameObject;
var rotateSpeed : float;
var menuObject : Transform;

function OnMouseOver () {
	// Activate highlight and rotate the text object
	if (MenuControl.clicked) return;
	menuObject.Rotate (Vector3.right * Time.deltaTime * rotateSpeed);
#if UNITY_3_4 || UNITY_3_5
	highlight.active = true;
#else
	highlight.SetActive(true);
#endif
	highlight.transform.position.y = transform.position.y;
}

function OnMouseExit () {
	// Deactivate highlight and reset rotation
	if (MenuControl.clicked) return;
#if UNITY_3_4 || UNITY_3_5
	highlight.active = false;
#else
	highlight.SetActive(false);
#endif
	menuObject.eulerAngles = Vector3.zero;
}

function OnMouseDown () {
	if (MenuControl.clicked) return;
	MenuControl.clicked = true;
#if UNITY_3_4 || UNITY_3_5
	highlight.active = false;
#else
	highlight.SetActive(false);
#endif
	menuObject.eulerAngles = Vector3.zero;
	
	// Move object toward camera and change color
	var startPos = transform.position;
	var endPos = Vector3(0, -2, -16);
	var endColor = Camera.main.backgroundColor;
	for (var i = 0.0; i <= 1.0; i += Time.deltaTime * 2.0) {
		menuObject.transform.position = Vector3.Lerp (startPos, endPos, i);
		menuObject.renderer.material.color = Color.Lerp (Color.white, endColor, i);
		yield;
	}
	
	// Reset back to start after a bit
	yield WaitForSeconds (1.5);
	menuObject.transform.position = startPos;
	menuObject.renderer.material.color = Color.white;
	MenuControl.clicked = false;
}