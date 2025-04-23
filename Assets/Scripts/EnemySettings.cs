using System.Collections.Generic;
using System.Linq;
using UnityEngine;
using System.Collections;

public class EnemySettings : MonoBehaviour, IWeighable
{
    public int maximumNumberOfWords;
    public float speed;
    public float defaultAnimationSpeed;
    public int scorePerWord;
    public bool activated;
    public GameObject bloodPositionsRoot;
    public Transform scorePosition;
    public float weight;
    public int appearsInWaveNumber;

    public float Weight { get { return weight; } }

    /// <summary>
    /// The time it takes (in seconds) for the enemy's hand to hit the player
    /// </summary>
    public float animationPlayerHitSeconds;

    [HideInInspector]
    public List<Vector3> BloodPositions { get; private set; }

    private void Start()
    {
        BloodPositions = ExtractBloodPositions(bloodPositionsRoot);
    }

    public Vector3 GetRandomBloodPosition()
    {
        var positions = ExtractBloodPositions(bloodPositionsRoot);
        var index = Random.Range(0, positions.Count - 1);

        return positions.ElementAt(index);
    }

    private static List<Vector3> ExtractBloodPositions(GameObject root)
    {
        if (root == null)
        {
            return null;
        }

        var positions = new List<Vector3>();
        foreach (Transform bloodPosition in root.transform)
        {
            positions.Add(bloodPosition.position);
        }

        return positions;
    }
}
