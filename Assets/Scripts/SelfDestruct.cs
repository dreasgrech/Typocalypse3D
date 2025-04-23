using System;
using UnityEngine;

public class SelfDestruct : MonoBehaviour
{
    private void Start() {
        Invoke("DestroySelf", 2f);
    }

    private void DestroySelf() {
        Destroy(transform.gameObject);
    }
}

