using System;
using UnityEngine;

public class EnemyRequestToDieEventArgs : EventArgs
{
    public EnemyDiedReason Reason { get; private set; }
    public Vector3 HitWorldPosition { get; set; }

    public EnemyRequestToDieEventArgs(EnemyDiedReason reason, Vector3 hitWorldPosition)
    {
        Reason = reason;
        HitWorldPosition = hitWorldPosition;
    }
}