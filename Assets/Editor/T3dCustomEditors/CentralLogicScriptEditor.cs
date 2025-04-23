using UnityEditor;
using UnityEngine;
using System.Collections;

//[CustomEditor(typeof (CentralLogicScript))]
public class CentralLogicScriptEditor : Editor
{
    private CentralLogicScript centralLogicScript;

    private void Awake()
    {
        centralLogicScript = (CentralLogicScript) target;
    }

    public override void OnInspectorGUI()
    {
        centralLogicScript.debugDifficulty = EditorGUILayout.Slider("Debug difficulty:", centralLogicScript.debugDifficulty, 1, 100);
    }

}