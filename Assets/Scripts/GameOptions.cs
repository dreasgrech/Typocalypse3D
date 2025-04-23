using UnityEngine;
using System.Collections;

public class GameOptions : MonoBehaviour
{
    public float startingGraphics;
    public float startingBrightness;
    public float startingVolume;

    [HideInInspector]
    public float brightness;

    [HideInInspector]
    public float volume;

    [HideInInspector]
    public float graphics;

    private static bool created;

    void Awake()
    {
        if (!created)
        {
            // this is the first instance - make it persist
            DontDestroyOnLoad(gameObject);
            created = true;

            graphics = startingGraphics;
            brightness = startingBrightness;
            volume = startingVolume;
        }
        else
        {
            // this must be a duplicate from a scene reload - DESTROY!
            Destroy(gameObject);
        }
    }
	// Use this for initialization
	void Start () {
	
	}
}
