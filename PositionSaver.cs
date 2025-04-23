using UnityEngine;

public class PositionSaver {
	public Vector3 position;
    public Quaternion rotation;

	public PositionSaver(Transform transform) {
		rotation = transform.rotation;
		position = transform.position;
	}

	public PositionSaver(Vector3 pos, Quaternion rot) {
		position = pos;
		rotation = rot;
	}

	public void ApplyOn(Transform transform) {
		transform.position = position;
		transform.rotation = rotation;
	}
}