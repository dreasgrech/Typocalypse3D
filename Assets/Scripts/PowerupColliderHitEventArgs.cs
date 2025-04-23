using System;

public class PowerupColliderHitEventArgs : EventArgs
{
    public IEnemy EnemyHit { get; private set; }

    public PowerupColliderHitEventArgs(IEnemy enemyHit)
    {
        EnemyHit = enemyHit;
    }
}