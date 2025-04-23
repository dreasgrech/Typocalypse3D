
/// <summary>
/// Time Manager.
/// Time.deltaTime independent Time.timeScale Lerp.
/// Author: Fliperamma | Fabio Paes Pedro
/// </summary>
/// 

using UnityEngine;
using System.Collections;

public class TimeManager : MonoBehaviour
{
	public bool EditorMode = false;
	public float TimeManagerScale = 1f;
	public bool TimeManagerIsPaused = false;
	public bool TimeManagerWillPause = false;
	public bool TimeManagerIsFading = false;

	public static bool IsPaused = false;
	public static bool IsFading = false;
	static bool _willPause = false;
	static float _scale = 1f;
	static float _fadeToScaleDifference = 0f;
	static float _scaleToFade = 0f;
	static float _deltaTime = 0f;
	static float _lastTime = 0f;
	static bool _fadeToScaleIsGreater = false;
	static TimeManager instance;
	void Awake()
	{
		#if UNITY_ANDROID
			EditorMode = false;
		#endif
		#if UNITY_IPHONE
			EditorMode = false;
		#endif
		#if UNITY_EDITOR
      			EditorMode = true;
    		#endif


		instance = this;
		Scale = Time.timeScale;
		StartCoroutine("UpdateDeltaTime");
	}

	/// <summary>
	/// Delta Time independente da Time.timeScale
	/// </summary>
	/// <value>
	/// Delta Time
	/// </value>
	public static float DeltaTime
	{
		get{
			return _deltaTime;
		}
	}

	/// <summary>
	/// Getter e Setter para a escale (time.timeScale). Seta automaticamente a variável IsPaused caso a escala chegue a zero. 
	/// </summary>
	/// <value>
	/// a escala (Time.timeScale)
	/// </value>
	public static float Scale
	{
		get{
			return _scale;
		}
		set{
			_scale = value;
			_scale = _scale < 0f ? 0f : _scale;
			Time.timeScale = _scale;
			IsPaused = _scale == 0f;
			if(IsPaused)_willPause = false;
			instance.UpdateEditor();
		}
	}

	/// <summary>
	/// Pause toggle (Altera automaticamente a flag de IsPaused de true para false e vice versa
	/// </summary>
	/// <param name='interruptFade'>
	/// I
	/// </param>
	/// <param name='time'>
	/// Time.
	/// </param>
	/// <param name='playScale'>
	/// Play scale.
	/// </param>
	public static void TogglePause(float time = 0f, float playScale = -1)
	{
		StopStepper();
		// Se _willPause == true significa que já estava ocorrendo um Pause: abaixar flag _willPause e dar Play. 
		// Senao apenas dar o Toggle.
		_willPause = _willPause == true ? false : !IsPaused;
		if(_willPause){
			Pause (time);
		}else{
			Play (time, playScale);
		}
	}

	static void StopStepper()
	{
		instance.StopCoroutine("FadeStepper");
	}

	/// <summary>
	/// Pause o TimeManager
	/// </summary>
	/// <param name='time'>
	/// Tempo de fade até chegar no Time.timeScale = 0f (Gradativo).
	/// </param>
	public static void Pause(float time = 0f)
	{		
		if(time == 0f){
			instance.StopCoroutine("FadeStepper");
			Scale = 0f;
		}else{
			FadeTo(0f, time);
		}
	}

	/// <summary>
	/// Play TimeManager
	/// </summary>
	/// <param name='time'>
	/// Tempo de fade até chegar no Time.timeScale = scale (Gradativo).
	/// </param>
	/// <param name='scale'>
	/// Escala final para o Time.timeScale
	/// </param>
	public static void Play(float time = 0f, float scale = 1f)
	{
		if(time == 0f){
			instance.StopCoroutine("FadeStepper");
			Scale = scale;
		}else{
			FadeTo(scale, time);
		}
	}

	/// <summary>
	/// Time Scale Fade. Anima a Time.timeScale usando um deltaTime independente
	/// </summary>
	/// <param name='scale'>
	/// A escala do Time.timeScale de destino
	/// </param>
	/// <param name='time'>
	/// Quanto tempo para chegar até a escala de destino
	/// </param>
	public static void FadeTo(float scale, float time)
	{
		instance.StopCoroutine("FadeStepper");
		_scaleToFade = scale;
		_fadeToScaleDifference = scale-_scale;
		_fadeToScaleIsGreater = _fadeToScaleDifference > 0f;
		float scalePerFrame = _fadeToScaleDifference/time;
		instance.StartCoroutine("FadeStepper", scalePerFrame);
	}

	/// <summary>
	/// Co rotina para fazer o TimeScaleFade
	/// </summary>
	IEnumerator FadeStepper(float scalePerFrame)
	{
		bool achieved = false;
		float start = Time.realtimeSinceStartup;
		IsFading = true;
		while(achieved == false){
			Scale += scalePerFrame*_deltaTime;
			if(_fadeToScaleIsGreater){
				achieved = _scale >= _scaleToFade;
			}else{
				achieved = _scale <= _scaleToFade;
			}
			yield return 0;
		}
		Scale = _scaleToFade;
		IsFading = false;
		instance.UpdateEditor();
	}

	/// <summary>
	/// Looping usando co rotina para atualizar o meu deltaTime
	/// </summary>
	IEnumerator UpdateDeltaTime()
	{
		while(true){
			float timeSinceStartup = Time.realtimeSinceStartup;
			_deltaTime = timeSinceStartup-_lastTime;
			_lastTime = timeSinceStartup;
			yield return 0;
		}
	}

	/// <summary>
	/// Atualiza a visualizaçao no editor caso o EditorMode esteja habilitado.
	/// </summary>
	void UpdateEditor()
	{
		if(instance.EditorMode){
			instance.TimeManagerScale = _scale;
			instance.TimeManagerIsFading = IsFading;
			instance.TimeManagerIsPaused = IsPaused;
			instance.TimeManagerWillPause = _willPause;
		}
	}

}