using System;
using System.Collections.Generic;
using UnityEngine;
using System.Collections;

public class KongregateAPI : MonoBehaviour
{
    public static bool InEditor
    {
        get
        {
#if UNITY_EDITOR
            return true;
#endif
            return false;
        }
    }

    private Action<KongregateInitialUserInfo> ConnectedCallback { get; set; }
    private KongregateInitialUserInfo initialUserInfo;

    private void Start()
    {
        //DontDestroyOnLoad(this);
    }

    public void InitiateAPI(Action<KongregateInitialUserInfo> connectedCallback)
    {
        Debug.Log("Initiating Kongregate api");
        ConnectedCallback = connectedCallback;

        // Try to connect to Kongregate.
        // The gameObject.name parameter is used so SendMessage
        // will look for the OnKongregateAPILoaded method
        // on this same MonoBehaviour
        Application.ExternalEval(
            "if(typeof(kongregateUnitySupport) != 'undefined'){" +
            " kongregateUnitySupport.initAPI('" + gameObject.name + "', 'OnKongregateAPILoaded');" +
            "};"
            );

        /*
        // Register a sign in handler to let us know if the user signs in to Kongregate.
        Application.ExternalEval(
            "kongregate.services.addEventListener('login', function(){" +
            "   var services = kongregate.services;" +
            "   var params=[services.getUserId(), services.getUsername(), services.getGameAuthToken()].join('|');" +
            "   kongregateUnitySupport.getUnityObject().SendMessage('MyUnityObject', 'OnKongregateUserSignedIn', params);" +
            "});");
         */
    }

    public void SubmitStatistic(string statsticName, int value)
    {
        Application.ExternalCall("kongregate.stats.submit", statsticName, value);
    }

    public void QueryUserInfo(string username, Action<KongregateUserInfo> callback)
    {
        var userDetailsUrl = String.Format("/api/user_info.json?username={0}", username);
        StartCoroutine(FetchText(userDetailsUrl, s =>
                                                     {
                                                         var userDetails = DeserializeJSONObject(s);
                                                         callback(KongregateUserInfo.Parse(userDetails));
                                                     }));
    }

    public void DownloadTexture(string url, Action<Texture2D> callback)
    {
        StartCoroutine(FetchTexture(url, callback));
    }

    private Dictionary<string, object> DeserializeJSONObject(string jsonText)
    {
        return MiniJSON.Json.Deserialize(jsonText) as Dictionary<string,object>;
    }

    private IEnumerator FetchText(string url, Action<string> callback)
    {
        var www = new WWW(url);
        yield return www;
        callback(www.text);
    }

    private IEnumerator FetchTexture(string url, Action<Texture2D> callback)
    {
        var www = new WWW(url);
        yield return www;
        callback(www.texture);
    }

    private void OnKongregateAPILoaded(string userInfoString)
    {
        initialUserInfo = ParseUserInfoString(userInfoString);
        ConnectedCallback(initialUserInfo);
    }

    // Called when the Kongregate user signs in
    private void OnKongregateUserSignedIn(string userInfoString)
    {
        initialUserInfo = ParseUserInfoString(userInfoString);
        Debug.Log("User has signed in: " + initialUserInfo.Username);
        ConnectedCallback(initialUserInfo);
    }

    private KongregateInitialUserInfo ParseUserInfoString(string userInfoString)
    {
        // Kongregate returns a char delimited string
        // composed of userId|username|gameAuthToken
        // Here I just store them for easier access
        string[] parms = userInfoString.Split("|"[0]);

        var userId = Convert.ToInt32(parms[0]); // int
        var username = parms[1]; // string
        var gameAuthToken = parms[2]; // string

        return new KongregateInitialUserInfo(false, userId, username, gameAuthToken);
    }
}

public class KongregateUserInfo
{
    public int UserID { get; set; }    
    public string Username { get; set; }    
    public bool Private { get; set; }    
    public bool Success { get; set; }    
    public int Level { get; set; }    
    public int Points { get; set; }    
    public string AvatarUrl { get; set; }    
    public Texture2D AvatarTexture { get; set; }    
    public string ChatAvatarUrl { get; set; }    
    public bool Developer { get; set; }    
    public bool Moderator { get; set; }    
    public bool Admin { get; set; }    
    public string Gender { get; set; }    
    public int Age { get; set; }    

    public static KongregateUserInfo Parse(Dictionary<string, object> jsonDictionary)
    {
        try
        {
            var success = (bool)jsonDictionary["success"];
            if (!success)
            {
                return null;
            }

            

        var userVars = (Dictionary<string, object>) jsonDictionary["user_vars"];

        var entity = new KongregateUserInfo
                         {
                             UserID = Convert.ToInt32(jsonDictionary["user_id"]),
                             Username = userVars["username"].ToString(),
                             Private = (bool) jsonDictionary["private"],
                             Success = (bool) jsonDictionary["success"],
                             Level = Convert.ToInt32(userVars["level"]),
                             Points = Convert.ToInt32(userVars["points"]),
                             AvatarUrl = userVars["avatar_url"].ToString(),
                             ChatAvatarUrl = userVars["chat_avatar_url"].ToString(),
                             Developer = (bool) userVars["developer"],
                             Moderator = (bool) userVars["moderator"],
                             Admin = (bool) userVars["admin"],
                             Age = Convert.ToInt32(userVars["age"]),
                         };

        return entity;
        }
        catch (KeyNotFoundException ex)
        {
            Debug.LogError("Key not found: " + ex.Data);
            throw;
        }
    }
}

public class KongregateInitialUserInfo
{
    public bool IsGuest { get; set; }
    public int UserId { get; set; }
    public string Username { get; set; }
    public string GameAuthToken { get; set; }

    public KongregateInitialUserInfo(bool isGuest, int userID, string username, string gameAuthToken)
    {
        IsGuest = isGuest;
        UserId = userID;
        Username = username;
        GameAuthToken = gameAuthToken;
    }
}