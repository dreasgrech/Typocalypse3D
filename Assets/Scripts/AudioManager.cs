using UnityEngine;
using System;
using System.Collections;

public class AudioManager : MonoBehaviour
{
	public AudioClip normalMusic;
	public AudioClip oneAmbiance;

    private void Start()
    {
    }

    /// <summary>
    /// Adjusts the pitch of all the audiosources in the scene
    /// </summary>
    /// <param name="pitch"></param>
    /// <param name="clampAtZeroOne"></param>
    public void AdjustPitch(float pitch, bool clampAtZeroOne = false)
    {
        if (clampAtZeroOne)
        {
            pitch = Mathf.Clamp(pitch, 0, 1);
        }

        var allAudioSources = FindObjectsOfType(typeof (AudioSource));
        foreach (AudioSource audioSource in allAudioSources)
        {
            audioSource.pitch = pitch;
        }
    }

	public void PlayNormalMusic() {
        //audio.pitch = 0.83f;
        PlayAudioSource(audio, normalMusic);
	}

    public void PitchOutSong()
    {
        StartCoroutine(LerpOne(audio.pitch, 0.56f, 5f,
                               f =>
                                   {
                                       audio.pitch = f;
                                }));
    }

    private void PlayAudioSource(AudioSource audioSource, AudioClip audioClip)
    {
        audioSource.clip = audioClip;
        audioSource.Play();
    }

    IEnumerator LerpOne(float start, float end, float time, Action<float> step)
    {
        var i = 0.0f;
        var rate = 1.0/time;
        while (i < 1.0)
        {
            i += (float) (Time.deltaTime*rate);
            step(Mathf.Lerp(start, end, i));
            yield return null; 
        }
    }

	private IEnumerator FadeMusic(AudioSource source)
	{
		while(source.volume > .1F)
		{
			source.volume = Mathf.Lerp(source.volume,0F,Time.deltaTime);
			yield return null;
		}

		source.volume = 0;
		//perfect opportunity to insert an on complete hook here before the coroutine exits.
	}
}
