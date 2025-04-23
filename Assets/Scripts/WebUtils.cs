
using System.Collections.Generic;
using UnityEngine;

/// <summary>
/// http://forrst.com/posts/Unity_Web_Player_Utility_Functions-5jM
/// </summary>
public class WebUtils
{
    public static Dictionary<string, string> GetQueryParams()
    {
        string src = Application.srcValue;
        if (string.IsNullOrEmpty(src) || src.IndexOf("?") == -1 || src.IndexOf("?") == src.Length - 1)
        {
            return new Dictionary<string, string>();
        }

        src = src.Substring(src.IndexOf("?") + 1);
        return ParseQueryString(src);
    }

    public static Dictionary<string, string> ParseQueryString(string query)
    {
        Dictionary<string, string> urlParams = new Dictionary<string, string>();
        string[] paramList = query.Split('&');
        for (int i = 0; i < paramList.Length; i++)
        {
            string[] temp = paramList[i].Split('=');

            string key = WWW.UnEscapeURL(temp[0]);
            string val = WWW.UnEscapeURL(temp[1]);

            urlParams.Add(key, val);
        }

        return urlParams;
    }

    public static string QueryString(Dictionary<string, string> urlParams)
    {
        string parameters = "";
        bool first = true;

        foreach (KeyValuePair<string, string> kvp in urlParams)
        {
            parameters += (first ? "?" : "&") + WWW.EscapeURL(kvp.Key) + "=" + WWW.EscapeURL(kvp.Value);
            first = false;
        }

        return parameters;
    }

    public static string GetFilename()
    {
        string src = Application.srcValue;

        if (src.IndexOf("?") >= 0)
        {
            return src.Substring(0, src.IndexOf("?"));
        }

        return src;
    }

    public static string GetDomain()
    {
        if (Application.isEditor)
        {
            return "http://localhost:8080";
        }

        string url = Application.absoluteURL;
        string protocol = url.Substring(0, url.IndexOf("://") + 3);
        url = url.Substring(url.IndexOf("://") + 3);
        string domain = url.Substring(0, url.IndexOf("/"));
        return protocol + domain;
    }
}