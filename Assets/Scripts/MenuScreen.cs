using System;
using UnityEngine;
using System.Collections;

public class MenuScreen : MonoBehaviour {

    private UIPanel panel;

    public void Awake()
    {
        panel = GetComponent<UIPanel>();
    }

    public void ShowScreen(bool instant = false)
    {
        if (instant)
        {
            panel.alpha = 1;
            return;
        }

        FadePanel(0, 1);
    }

    public void HideScreen(bool instant = false)
    {
        if (instant)
        {
            panel.alpha = 0;
            return;
        }

        FadePanel(1, 0);
    }

    private void FadePanel(float fromAlpha, float toAlpha)
    {
        var time = 0.2f;
        iTween.ValueTo(gameObject, iTween.Hash("from", fromAlpha, "to", toAlpha, "time", time, "onUpdate", (Action<object>) (value =>
        {
            panel.alpha = (float) value;
        }), "ignoretimescale", true));
    }
}
