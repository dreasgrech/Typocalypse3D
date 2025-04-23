using System;
using System.Collections.Generic;
using System.Linq;
using Assets.Scripts;
using UnityEngine;
using System.Collections;

public class WebPlayerStreamer : MonoBehaviour
{
    public static List<AssetBundle> bundles = new List<AssetBundle>();

    public event EventHandler<EventArgs> OnFirstLevelLoaded;
    public UIPanel loadingPanel;
    public UILabel loadingPercentageLabel;
    public bool debugMode;
    //public UITexture currentTipTexture;

    public UIPanel activeTipPanel;
    public UIPanel inactiveTipPanel;

    private Dictionary<string, T3DLevelInfo> downloadedLevels;

    ShuffleBag<LoadingTip> shuffleBag = new ShuffleBag<LoadingTip>();
    public void LoadLevel(string levelName)
    {
        loadingPanel.alpha = 1;
        if (debugMode)
        {
            Debug.Log("DEBUG MODE");
            Application.LoadLevel(levelName);
        }
        else
        {
            StartCoroutine(WaitForDownloadedLevel(levelName, info =>
            {
                // The level has finished downloading
                //Application.LoadLevel(info.SceneName);
                //Application.LoadLevel(levelName);
                Application.LoadLevel(levelName);
            }));
        }
    }

    IEnumerator ShowTips(IEnumerable<LoadingTip> tips)
    {
        var tipsList = tips.ToList();
        while (true)
        {
            if (loadingPanel.alpha == 0)
            {
                yield return null;
                continue;
            }

            var activeTexture = activeTipPanel.GetComponentInChildren<UITexture>();
            var activeTipLabel = activeTipPanel.GetComponentInChildren<UILabel>();
            var validTips = tipsList.Where(t => t.DownloadedTexture != null && activeTexture.mainTexture != t.DownloadedTexture).ToList();

            var inactiveTexture = inactiveTipPanel.GetComponentInChildren<UITexture>();
            var inactiveTipLabel = inactiveTipPanel.GetComponentInChildren<UILabel>();
            if (validTips.Count > 0)
            {
                var tip = validTips.ElementAt(UnityEngine.Random.Range(0, validTips.Count()));

                inactiveTexture.mainTexture = tip.DownloadedTexture;
                inactiveTipLabel.text = tip.Text;

                inactiveTipLabel.text = "";
                StartCoroutine(HomelessMethods.Interpolate(0f, 1f, 1f, InterpolationMethods.Lerp, f =>
                {
                    inactiveTipPanel.alpha = f;
                }, () =>
                {
                    activeTexture.mainTexture = tip.DownloadedTexture;
                    activeTipLabel.text = tip.Text;

                    activeTipPanel.alpha = 1f;

                    inactiveTexture.mainTexture = null;
                    inactiveTipPanel.alpha = 0f;
                }));

                yield return new WaitForSeconds(10f);
            }

            yield return null;


        }
    }

    private IEnumerator WaitForDownloadedLevel(string levelName, Action<T3DLevelInfo> callback)
    {
        while (!downloadedLevels.ContainsKey(levelName))
        {
            yield return new WaitForSeconds(1f);
        }

        callback(downloadedLevels[levelName]);
    }

    void OnQueryString(string value)
    {
        /*
        Debug.Log(value);
        var queryString = ParseQuerystring(value);
        foreach (var qValue in queryString)
        {
            Debug.Log(String.Format("{0} : {1}", qValue.Key, qValue.Value));
        }

        string queryStringLevel = null;
        if (queryString.ContainsKey("level"))
        {
            queryStringLevel = queryString["level"];
        }
        */ 
    }

    private Dictionary<string, string> ParseQuerystring(string queryStringText)
    {
        if (String.IsNullOrEmpty(queryStringText) || queryStringText.Length < 1)
        {
            return new Dictionary<string, string>();
        }

        // remove the ?
        queryStringText = queryStringText.Substring(1);

        var split = queryStringText.Split('&');
        return split.Select(s => s.Split('=')).ToDictionary(valuesSplit => valuesSplit[0], valuesSplit => valuesSplit[1]);
    }
        
    IEnumerator Start()
    {
        loadingPanel.alpha = 0;
        downloadedLevels = new Dictionary<string, T3DLevelInfo>();

        //Application.ExternalEval(String.Format("u.getUnity().SendMessage(\"{0}\", \"OnQueryString\", window.location.search);", gameObject.name));

        //StartCoroutine(FetchGameVersionDetails("http://dreasgrech.com/upload/t3d/level.unity3d", gameState =>
        // TODO: cache the level url so u dont download the details again
        StartCoroutine(FetchGameVersionDetails(String.Empty, gameState =>
        {
            StartCoroutine(ShowTips(gameState.Tips));
            StartDownloadingLoadingTipImages(gameState.Tips);

            StartDownloadingLevels(gameState.Levels);
        }));

        yield return null;
    }

    private void StartDownloadingLoadingTipImages(IEnumerable<LoadingTip> tips)
    {
        foreach(var tip in tips)
        {
            LoadingTip tip1 = tip;
            StartCoroutine(DownloadTexture(tip.ImageUrl, texture =>
            {
                tip1.DownloadedTexture = texture;
                //currentTipTexture.mainTexture = texture;
            }));
        }
    }
    
    private void StartDownloadingLevels(IEnumerable<T3DLevelInfo> levels)
    {
        var firstLevel = levels.First();
        Debug.Log("Downloading " + firstLevel.Url);
        StartCoroutine(DownloadAssetBundle(firstLevel.Url, 1, bundle =>
                                                            {
                                                                /*
                                                                if (bundle != null)
                                                                {
                                                                    bundle.Unload(true);
                                                                }
                                                                */

                                                                downloadedLevels.Add(firstLevel.SceneName, firstLevel);
                                                            }));
    }

    private IEnumerator DownloadTexture(string url, Action<Texture2D> callback)
    {
        var wwwFile = new WWW(url);
        yield return wwwFile;
        callback(wwwFile.texture);
    }

    private WWW download;

    private IEnumerator DownloadAssetBundle(string url, int version, Action<AssetBundle> callback)
    {
        foreach (var assetBundle in bundles)
        {
            if (assetBundle != null)
            {
                assetBundle.Unload(true);
            }
        }

        bundles.Clear();

        AssetBundle bundle;
        if (bundles.Count == 0)
        {
            /*
    #if UNITY_EDITOR
            download = new WWW(url); // I use this in the editor to avoid caching
    #else
            download = WWW.LoadFromCacheOrDownload(url, version);
    #endif
             * */

            download = WWW.LoadFromCacheOrDownload(url, version);

            //Debug.Log("Progress (start): " + download.progress);
            while (!download.isDone)
            {
                //Debug.Log("Progress (loop): " + download.progress);
                if (download.progress > 0)
                {
                    loadingPercentageLabel.text = Math.Ceiling(download.progress*100).ToString();
                }

                yield return null;
            }

            if (download.error != null)
            {
                Debug.LogError(download.error);
                throw new Exception("Failed to download: " + url);
            }

            // Call the assetBundle property to make the scene available to Application.LoadLevel
            bundle = download.assetBundle;

            bundles.Add(bundle);
            download.Dispose();
        } else
        {
            bundle = bundles.First();
        }

        callback(bundle);
    }

    private IEnumerator FetchGameVersionDetails(string levelFromQueryString, Action<T3DGameState> callback)
    {
        if (String.IsNullOrEmpty(GlobalVariables.T3DInfoTextFileContents))
        {
            var wwwFile = new WWW("http://dreasgrech.com/upload/t3d/t3d.txt?random=" + UnityEngine.Random.Range(10f, 10000f));
            yield return wwwFile;
             try
             {
                GlobalVariables.T3DInfoTextFileContents = wwwFile.text;
             } catch (Exception ex)
             {
                 Debug.Log("Failed to download: " + ex.Message + " " + ex.Message);
             }
        }
        
        if (String.IsNullOrEmpty(GlobalVariables.T3DInfoTextFileContents))
        {
            Debug.Log("We have a problem...");

        }

        var deserialized = (Dictionary<string, object>)MiniJSON.Json.Deserialize(GlobalVariables.T3DInfoTextFileContents);
        var levelsCollection = (List<object>)deserialized["levels"];
        var tipsCollection = (List<object>)deserialized["tips"];

        var levels = new List<T3DLevelInfo>();
        foreach (var level in levelsCollection)
        {
            var l = (Dictionary<string, object>) level;

            string levelName = l["name"].ToString(),
                   sceneName = l["sceneName"].ToString(),
                   url = l["o_url"].ToString(), // tinsiex l'o_url
                   dictionary = l["dictionary"].ToString();

            levels.Add(new T3DLevelInfo(levelName, sceneName, url, dictionary));
        }

        var tips = new List<LoadingTip>();

        foreach (var tip in tipsCollection)
        {
            var l = (Dictionary<string, object>) tip;
            tips.Add(new LoadingTip(l["text"].ToString(), l["image"].ToString()));
        }

        var firstLevel = levels.First();
        if (!String.IsNullOrEmpty(levelFromQueryString))
        {
            levels = new List<T3DLevelInfo>
                     {
                         new T3DLevelInfo(firstLevel.Name, firstLevel.SceneName, levelFromQueryString, firstLevel.Dictionary)
                     };
        }
        var state = new T3DGameState(levels, tips);
        callback(state);
    }
}

public class LoadingTip
{
    public string Text { get; private set; }
    public string ImageUrl { get; private set; }
    public Texture2D DownloadedTexture { get; set; }

    public LoadingTip(string text, string imageUrl)
    {
        Text = text;
        ImageUrl = imageUrl;
    }
}

public class T3DGameState
{
    public IEnumerable<T3DLevelInfo> Levels { get; set; }
    public IEnumerable<LoadingTip> Tips { get; private set; }
    
    public T3DGameState(IEnumerable<T3DLevelInfo> levels, IEnumerable<LoadingTip> tips)
    {
        Levels = levels;
        Tips = tips;
    }
}

public class T3DLevelInfo
{
    public string Name { get; private set; }
    public string SceneName { get; private set; }
    public string Url { get; private set; }
    public string Dictionary { get; private set; }

    public T3DLevelInfo(string name, string sceneName, string url, string dictionary)
    {
        Name = name;
        SceneName = sceneName;
        Url = url;
        Dictionary = dictionary;
    }
}