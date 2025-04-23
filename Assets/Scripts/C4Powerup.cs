using System;
using System.Collections.Generic;
using System.Linq;
using UnityEngine;
using System.Collections;
using Random = UnityEngine.Random;

public class C4Powerup : SpecialPowerup
{
    public GameObject c4Prefab;
    public GameObject spawnPositions;
    public CentralLogicScript centralLogicScript;

    private SBag<Vector3> spawnpoints;
    private SBag<string> availableWords;

    public override PowerupType PowerType { get { return PowerupType.C4; } }
    public override PowerupType DoesntWorkWith { get { return 0; } }
    public override int MaxLevels { get { return 3; } }
    public override int NumberKeyActivation { get { return 4; } }
    public override bool CanActivate
    {
        get {
            {
                return c4sWordsOnScreen.Count < availableWords.TotalCount;
            } }
    }

    private List<C4Behaviour> c4sWordsOnScreen;
    private int maxC4sOnScreen;

    void Start()
    {
        c4sWordsOnScreen = new List<C4Behaviour>();

        var availablePositions = from Transform spawnpoint in spawnPositions.transform select spawnpoint.position;

        spawnpoints = new SBag<Vector3>(availablePositions);
        availableWords = new SBag<string>(new[] { "Alpha", "Bravo", "Charlie", "Delta", "Echo" });
        maxC4sOnScreen = availableWords.TotalCount;
    }

    /// <summary>
    /// Drop the C4 in the field.
    /// </summary>
    /// <returns></returns>
    public override IEnumerator Activate()
    {
        InvokePowerupActivatedEvent();

        var numberOfExplosives = GetNumberToSpawn();
        if (numberOfExplosives == 0)
        {
            throw new Exception();
        }

        var alreadyInUse = c4sWordsOnScreen.Select(c4OnScreen => c4OnScreen.TextManipulation.Text).ToArray();
        var wordForExplosion = availableWords.GetElement(alreadyInUse, (s, s1) => String.Equals(s, s1, StringComparison.OrdinalIgnoreCase));

        for (int i = 0; i < numberOfExplosives; i++)
        {
            var randomPointInArea = Random.insideUnitSphere*2;
            var randomSpawnPoint = spawnpoints.GetElement();

            // Calculate the exact position where we need to spawn the c4
            var spawnPosition = randomSpawnPoint + new Vector3(randomPointInArea.x, 5, randomPointInArea.y);
            var c4 = SpawnC4(spawnPosition);
            var textManipulation = c4.GetComponent<TextManipulation>();
            // TextManipulation.Text == null :<
            var cantUseWords = String.Join(", ", alreadyInUse);

            textManipulation.SetWords(new[] {wordForExplosion});
            textManipulation.UseNextWord();
            c4sWordsOnScreen.Add(c4.GetComponent<C4Behaviour>());
        }

        yield return StartCoroutine(Deactivate());
    }

    public override IEnumerator Deactivate()
    {
        InvokePowerupDeactivatedEvent();
        yield return null;
    }

    private GameObject SpawnC4(Vector3 position)
    {
        var c4 = (GameObject) Instantiate(c4Prefab, position, Quaternion.identity);
        c4.SetActive(true);
        var component = c4.GetComponent<C4Behaviour>();
        component.OnDetonated += (sender, args) => c4sWordsOnScreen.Remove(component);

        return c4;
    }

    private int GetNumberToSpawn()
    {
        var maxC4sForCurrentLevel = (new Func<int, int>(level =>
        {
            switch (level)
            {
                case 1: return 1;
                case 2: return 2;
                case 3: return 4;
            }

            return 4;
        }))(CurrentLevel);

        var maxDroppedNow = maxC4sOnScreen - c4sWordsOnScreen.Count; // how many C4s are we allowed to drop now
        return Math.Min(maxC4sForCurrentLevel, maxDroppedNow);

        /*
        if (maxC4sForCurrentLevel <= maxDroppedNow)
        {
            return maxC4sForCurrentLevel;
        }

        return maxDroppedNow;
        */
    }
}
