using System;
using UnityEngine;
using System.Collections;

public class PowerupBoxCollider : MonoBehaviour
{
    public CratePowerupBehaviour powerup;
    public event EventHandler<PowerupColliderHitEventArgs> OnColliderHit;

    private void OnCollisionEnter(Collision other)
    {
        // when an enemy is killed by a crate, he needs to be removed from central logic
        if (!other.gameObject.name.Contains("Terrain"))
        {
            if (other.transform.parent != null)
            {
                if (OnColliderHit != null)
                {
                    var enemy = other.transform.parent.GetCustomComponent<IEnemy>();
                    if (enemy != null)
                    {
                        OnColliderHit(this, new PowerupColliderHitEventArgs(enemy));
                    }
                }
            }
        }
    }
}