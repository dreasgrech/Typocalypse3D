using System;
using UnityEngine;
using System.Collections;
using System.Collections.Generic;

public class WebOperations : MonoBehaviour
{
    private void Start() {}

    public WWW GET(string url)
    {

        WWW www = new WWW(url);
        StartCoroutine(WaitForRequest(www));
        return www;
    }

    public WWW POST(string url, Dictionary<string, object> post)
    {
        WWWForm form = new WWWForm();
        foreach (KeyValuePair<String, object> post_arg in post)
        {
            form.AddField(post_arg.Key, post_arg.Value.ToString());
        }
        WWW www = new WWW(url, form);

        StartCoroutine(WaitForRequest(www));
        return www;
    }

    private IEnumerator WaitForRequest(WWW www)
    {
        yield return www;

        // check for errors
        if (www.error != null)
        {
            Debug.Log("WWW Error: " + www.error);
        }
    }
}