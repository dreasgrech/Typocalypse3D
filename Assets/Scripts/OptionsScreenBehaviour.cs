using System;
using System.Collections.Generic;
using UnityEngine;
using System.Collections;

public class OptionsScreenBehaviour : MonoBehaviour
{
    public UISlider globalVolumeUISlider;
    public UISlider brightnessUISlider;
    public UISlider graphicsUISlider;
    public UISlider graphicsUISlider2;

    public AntialiasingAsPostEffect antiAliasingPostEffect;
    public SSAOEffect ssaoEffect;

    public UILabel globalVolumeLabel;
    public UILabel brightnessLabel;
    public UILabel graphicsQualityLabel;

    public bool applyExpensiveChanges;

    private GameOptions options;

    private void Start()
    {
        var optionsObject = GameObject.FindGameObjectWithTag("options");
        
        if(optionsObject != null)
        {
            options = optionsObject.GetComponent<GameOptions>();
        } else
        {
            // Running the scene in the editor (so there was no gameobject from the main menu)
            // create a temp one.
            var tempOptionsObj = new GameObject();
            options = tempOptionsObj.AddComponent<GameOptions>();

            options.brightness = 0.5f;
            options.volume = 0.5f;
            options.graphics = 1f;
        }

        if (graphicsUISlider2 != null)
        {
            graphicsUISlider = graphicsUISlider2;
        }

        globalVolumeUISlider.sliderValue = options.volume;
        brightnessUISlider.sliderValue = options.brightness;
        graphicsUISlider.sliderValue = options.graphics;
    }

    /*
    private Dictionary<float,string> qualitySettings = new Dictionary<float, string>
                                                     {
                                                         {0, "Fastest"},
                                                         {2f, "Fast"},
                                                         {4f, "Simple"},
                                                         {6f, "Good"},
                                                         {8f, "Beautiful"},
                                                         {10f, "Fantastic"},
                                                     };
     */

    /* 
     * These "OnX" methods are called from the NGUI components
     */

    private void OnVolumeSliderChange(float volume)
    {
        options.volume = volume;
        AudioListener.volume = volume;
        globalVolumeLabel.text = Mathf.Floor(volume*100).ToString();
    }

    private void OnQualitySliderChange(float value)
    {
        options.graphics = value;

        var enableEffects = value >= 0.8f;
        if (antiAliasingPostEffect != null)
        {
            antiAliasingPostEffect.enabled = enableEffects;
        }

        if (ssaoEffect != null)
        {
            ssaoEffect.enabled = enableEffects;
        }

        var graphicsMapped = (int) HomelessMethods.Map(value, 0f, 1f, 0f, QualitySettings.names.Length - 1);
        QualitySettings.SetQualityLevel(graphicsMapped, applyExpensiveChanges);

        //var qualityName = MapGraphicsQuality(value);
        graphicsQualityLabel.text = QualitySettings.names[graphicsMapped];
    }

    private void OnBrightnessChange(float brightness)
    {
        options.brightness = brightness;
        brightness *= 0.5f;
        RenderSettings.ambientLight = new Color(brightness, brightness, brightness, 1f);
        
        brightnessLabel.text = Mathf.Floor(options.brightness*100).ToString();
    }
}
