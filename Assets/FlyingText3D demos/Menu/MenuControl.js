#pragma strict

var highlight : GameObject;
var rotateSpeed = 150.0;
var itemText = ["<color=#13b62a>Start", "<color=#235fb9>Options", "<color=#cb3125>Quit"];
var itemPositions = [Vector3(0, 4, 0), Vector3(0, 0, 0), Vector3(0, -4, 0)];
static var clicked = false;

function Start () {
	for (var i = 0; i < itemText.Length; i++) {
		// Create 3D text object
		var menuObject = FlyingText.GetObject (itemText[i]);
		menuObject.transform.position = itemPositions[i];
		
		// Create collider (we don't use a collider for the 3D text object because we don't want the collider to rotate)
		var cube = GameObject.CreatePrimitive (PrimitiveType.Cube);
		cube.transform.localScale = Vector3(7, 1.8, .1);
		cube.transform.position = itemPositions[i];
		cube.renderer.enabled = false;
		
		// Add the menu object script to the collider and assign values to the variables
		var menuScript = cube.AddComponent (MenuObject);
		menuScript.highlight = highlight;
		menuScript.rotateSpeed = rotateSpeed;
		menuScript.menuObject = menuObject.transform;
	}
}