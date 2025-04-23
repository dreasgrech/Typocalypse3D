using System.Collections.Generic;
using UnityEngine;
using System.Collections;

public class LandminesPowerup : SpecialPowerup
{
    public GameObject landminePrefab;
    public GameObject landmineSpawnpointsRoot;
    public float spawnHeightY = 5;

    public override PowerupType PowerType { get { return PowerupType.Landmines; } }

    public override PowerupType DoesntWorkWith
    {
        get { return PowerupType.SlowTime | PowerupType.RapidFire; }
    }

    public override int MaxLevels { get { return 3; } }
    public override int NumberKeyActivation { get { return 2; } }
    public override bool CanActivate { get { return true; } }

    private List<Vector3> spawnpoints;
    private List<Vector3> level3SpawnPositions;

    // Use this for initialization
    void Start()
    {
        spawnpoints = new List<Vector3>();
        foreach (Transform spawnpoint in landmineSpawnpointsRoot.transform)
        {
            spawnpoints.Add(spawnpoint.position);
        }

        level3SpawnPositions = new List<Vector3>();
        foreach (Transform l3PositionTransform in transform)
        {
           level3SpawnPositions.Add(l3PositionTransform.position);
        }
    }

    public override IEnumerator Activate()
    {
        InvokePowerupActivatedEvent();

        var numberToSpawn = GetNumberToSpawn();
        for (int i = 0; i < numberToSpawn; i++)
        {
            var randomPointInArea = Random.insideUnitSphere*2;
            var randomSpawnPoint = spawnpoints.GetRandomElement();

            // Calculate the exact position where we need to spawn the landmine
            var spawnPosition = randomSpawnPoint + new Vector3(randomPointInArea.x, spawnHeightY, randomPointInArea.y);
            SpawnLandmine(spawnPosition);
        }

        yield return StartCoroutine(Deactivate());
    }

    public override IEnumerator Deactivate()
    {
        InvokePowerupDeactivatedEvent();
        yield return null;
    }

    private void SpawnLandmine(Vector3 position)
    {
            var landmine = (GameObject)Instantiate(landminePrefab, position, Quaternion.identity);
            landmine.SetActive(true);
    }

    private int GetNumberToSpawn()
    {
        switch (CurrentLevel)
        {
            case 1: return 1; 
            case 2: return 2;
            case 3: return 4;
        }

        return 5;
    }
}
