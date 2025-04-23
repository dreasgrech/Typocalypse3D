using UnityEditor;
using UnityEngine;
using System.Collections;

public class AssetBundlePackager : MonoBehaviour {
    [MenuItem("Build/Build Island Scene (AssetBundle)")]
    static void DoSomething()
    {
        //BuildPipeline.BuildStreamedSceneAssetBundle(new[] {@"Assets/AssetBundleScene.unity"}, "Streamed-AssetBundleScene.unity3d", BuildTarget.WebPlayer);
        BuildPipeline.BuildStreamedSceneAssetBundle(new[] { @"Assets/Scenes/Levels/Two_original.unity" }, @"C:\Typocalypse 3D Builds\Web\Streamed-IslandLevel.unity3d", BuildTarget.WebPlayer);
    }
}
