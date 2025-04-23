using System.Collections.Generic;
using System.Linq;
using UnityEngine;
using System.Collections;

public class RapidFirePowerup : SpecialPowerup
{
    public override bool CanActivate { get { return true; } }

    public override PowerupType PowerType { get { return PowerupType.RapidFire; } }

    public override PowerupType DoesntWorkWith
    {
        get { return PowerupType.SlowTime | PowerupType.Sniper; }
    }

    public override int MaxLevels { get { return 3; } }
    public override int NumberKeyActivation { get { return 3; } }

    public CentralLogicScript centralLogicScript;
    public MotionBlur mainCameraMotionBlur;
    public SlowTimePowerup slowTimePowerup;

    private PlayerBehaviour player;

    // Use this for initialization
    void Start()
    {
        player = GameObject.FindWithTag("Player").GetComponent<PlayerBehaviour>();
        mainCameraMotionBlur.enabled = false;
    }

    public override IEnumerator Activate()
    {
        InvokePowerupActivatedEvent();

        mainCameraMotionBlur.blurAmount = 0.6f;
        mainCameraMotionBlur.enabled = true;
        var enemiesOnScreen = centralLogicScript.EnemiesOnScreen;
        var closestEnemies = GetClosestEnemies(enemiesOnScreen, GetNumberToKill()).ToList();

        StartCoroutine(slowTimePowerup.FluctuateTime(0.8f, 0.5f * closestEnemies.Count, 0.1f, 0.2f));

        closestEnemies.ForEach(enemy =>
        {
            enemy.HighlightWord();
            ((ISniperPowerupClickable)(enemy)).ChangeCelShadingEffect(Color.black, Color.red);
        });

        foreach (var closestEnemy in closestEnemies)
        {
            centralLogicScript.KillEnemy(closestEnemy, EnemyDiedReason.RapidFire, Vector3.zero);
            yield return new WaitForSeconds(0.5f);
        }

        mainCameraMotionBlur.enabled = false;

        StartCoroutine(Deactivate());
    }

    public override IEnumerator Deactivate()
    {
        mainCameraMotionBlur.enabled = false;

        InvokePowerupDeactivatedEvent();
        yield return null;
    }

    public IEnumerable<IEnemy> GetClosestEnemies(IEnumerable<IEnemy> enemies, int max)
    {
        var enemiesList = enemies.ToList();
        var enemiesDistances = enemiesList.ToDictionary(enemy => Vector3.Distance(player.transform.position, enemy.Position));
        var sortedEnemiesDistances = new SortedList<float, IEnemy>(enemiesDistances);
        return sortedEnemiesDistances.Take(max).Select(enemy => enemy.Value);
    }

    private int GetNumberToKill()
    {
        switch (CurrentLevel)
        {
            case 1: return 1;
            case 2: return 3;
            case 3: return 5;
        }

        return 5;
    }
}
