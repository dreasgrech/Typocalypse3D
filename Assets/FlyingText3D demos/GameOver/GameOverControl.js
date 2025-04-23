#pragma strict

var explosion : GameObject;

function Start () {
	RenderSettings.fog = true;
	RenderSettings.fogColor = Camera.main.backgroundColor;
	RenderSettings.fogMode = FogMode.Linear;
	RenderSettings.fogEndDistance = 20.0;

	while (true) {
		var gameOverText = FlyingText.GetObjects ("GAME<br>OVER").transform;
		gameOverText.position.z = -6.5;
		var rigidbodies = gameOverText.GetComponentsInChildren.<Rigidbody>();
		for (var rb in rigidbodies) {
			rb.useGravity = false;
		}
		
		for (var i = 0.0; i < 1.0; i += Time.deltaTime) {
			gameOverText.position.y = Mathf.Lerp (5.0, -.05, i);
			yield;
		}
		CameraShake (Camera.main);
		
		yield WaitForSeconds(1.75);
		
		Instantiate (explosion, Vector3(0.0, 1.0, -6.3), Quaternion.identity);
		for (var rb in rigidbodies) {
			rb.useGravity = true;
			rb.AddExplosionForce (220.0, Vector3(0, 1, -6.5), 10.0, 9.0);
		}
		
		yield WaitForSeconds(5.0);
		Destroy (gameOverText.gameObject);
		yield WaitForSeconds(1.0);
	}
}

var startingShakeDistance = .4;
var decreasePercentage = .5;
var shakeSpeed = 40.0;
var numberOfShakes = 3;

function CameraShake (cam : Camera) {
	var originalPosition = cam.transform.localPosition.y;
	var shakeCounter = numberOfShakes;
	var shakeDistance = startingShakeDistance;
	var timer = 0.0;

	while (shakeCounter > 0) {
		cam.transform.localPosition.y = originalPosition + Mathf.Sin (timer) * shakeDistance;
		timer += Time.deltaTime * shakeSpeed;
		if (timer > Mathf.PI * 2.0) {
			timer = 0.0;
			shakeDistance *= decreasePercentage;
			shakeCounter--;
		}
		yield;
	}
	cam.transform.localPosition.y = originalPosition;
}