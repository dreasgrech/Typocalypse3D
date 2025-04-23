// FlyingText3D 1.2.2
// ©2012 Starscene Software. All rights reserved. Redistribution without permission not allowed.

import UnityEditor.EditorGUILayout;
import UnityEngine.GUILayout;
import System.Collections.Generic;
import FlyingText3D;

@CustomEditor (FlyingText)
class FlyingTextInspector extends Editor {

	static var showFonts = true;
	static var showTextSettings = true;
	static var showGOsettings = true;
	static var text = "";
	static var position = Vector3.zero;
	static var ttfFile : Font;
	static var initialized = false;
	var t : FlyingText;
	
	function OnEnable () {
		t = target;
	}
	
	function OnInspectorGUI () {
		EditorGUIUtility.LookLikeControls (90);
				
		showFonts = Foldout (showFonts, "Font settings");
		if (showFonts) {
			var hasChanged = false;
			BeginVertical ("Box");
//			Label ("TTF files must be renamed to end with “.bytes”");
			if (Button ("+ Add Font")) {
				if (t.m_fontData == null) {
					t.m_fontData = new List.<FontData>();
				}
				t.m_fontData.Add (new FontData());
				EditorUtility.SetDirty (t);
			}
			if (t.m_fontData != null) {
				for (var i = 0; i < t.m_fontData.Count; i++) {
					BeginVertical ("Box");
					LabelField ("Name in font:", t.m_fontData[i].fontName);
					BeginHorizontal();
					BeginVertical();
					t.m_fontData[i].ttfFile = ObjectField ("Font #" + i, t.m_fontData[i].ttfFile, TextAsset, false);
					if (!hasChanged && GUI.changed) {
						t.m_fontData[i].fontName = TTFFontInfo.GetFontName (t.m_fontData[i].ttfFile.bytes);
						hasChanged = true;
					}
					EndVertical();
					if (Button ("X", Width(22), Height(16))) {
						t.m_fontData.RemoveAt (i);
						EditorUtility.SetDirty (target);
					}
					EndHorizontal();
					EndVertical();
				}
			}
			EndVertical();
		}

		EditorGUIUtility.LookLikeControls (125);
		
		showTextSettings = Foldout (showTextSettings, "Text settings");
		if (showTextSettings) {
			BeginVertical ("Box");
			BeginHorizontal();
			t.m_defaultFont = IntField ("Default Font", t.m_defaultFont, Width(148));
			if (t.m_fontData != null && t.m_fontData.Count != 0) {
				t.m_defaultFont = Mathf.Clamp (t.m_defaultFont, 0, t.m_fontData.Count-1);
				Label ("(" + t.m_fontData[t.m_defaultFont].fontName + ")");
			}
			else {
				t.m_defaultFont = 0;
			}
			EndHorizontal();
			t.m_defaultMaterial = ObjectField ("Default Material", t.m_defaultMaterial, Material, false);
			t.m_defaultColor = ColorField ("Default Color", t.m_defaultColor);
			t.m_defaultResolution = IntField ("Default Resolution", t.m_defaultResolution);
			if (t.m_defaultResolution < 1) {
				t.m_defaultResolution = 1;
			}
			t.m_defaultSize = FloatField ("Default Size", t.m_defaultSize);
			if (t.m_defaultSize < .001) {
				t.m_defaultSize = .001;
			}
			t.m_defaultDepth = FloatField ("Default Depth", t.m_defaultDepth);
			if (t.m_defaultDepth < 0.0) {
				t.m_defaultDepth = 0.0;
			}
			t.m_defaultLetterSpacing = FloatField ("Default Letter Spacing", t.m_defaultLetterSpacing);
			if (t.m_defaultLetterSpacing < 0.0) {
				t.m_defaultLetterSpacing = 0.0;
			}
			t.m_defaultLineSpacing = FloatField ("Default Line Spacing", t.m_defaultLineSpacing);
			t.m_defaultJustification = EnumPopup ("Default Justification", t.m_defaultJustification);
			t.m_includeBackface = Toggle ("Include Backface", t.m_includeBackface);
			t.m_texturePerLetter = Toggle ("Texture Per Letter", t.m_texturePerLetter);
			t.m_smoothingAngle = Slider ("Smoothing Angle", t.m_smoothingAngle, 0.0, 180.0);
			EndVertical();
		}
		
		showGOsettings = Foldout (showGOsettings, "GameObject settings");
		if (showGOsettings) {
			BeginVertical ("Box");
			t.m_anchor = EnumPopup ("Text Anchor", t.m_anchor);
			if (t.m_defaultDepth > 0.0) {
				t.m_zAnchor = EnumPopup ("Z Anchor", t.m_zAnchor);
			}
			t.m_colliderType = EnumPopup ("Collider Type", t.m_colliderType);
			t.m_addRigidbodies = Toggle ("Add rigidbodies", t.m_addRigidbodies);
			if (t.m_addRigidbodies) {
				t.m_physicsMaterial = ObjectField ("Physics Material", t.m_physicsMaterial, PhysicMaterial, false);
			}			
			EndVertical();
		}
		
		if (GUI.changed) {
			EditorUtility.SetDirty (target);
			initialized = false;
		}
		
		EditorGUIUtility.LookLikeControls (35);
		
		Label ("Create FlyingText3D object", EditorStyles.boldLabel);
		text = EditorGUILayout.TextField ("Text: ", text);
		position = Vector3Field ("Location: ", position);
		if (text == "" || !(t.m_fontData != null && t.m_fontData.Count != 0)) {
			GUI.enabled = false;
		}
		if (Button ("Create")) {
			if (!initialized) {
				FlyingText.instance.Initialize();
				initialized = true;
			}
			Undo.RegisterSceneUndo ("Create 3D Text Object");
			var textObject = FlyingText.GetObject (text);
			textObject.transform.position = position;
			var mesh = textObject.GetComponent(MeshFilter).sharedMesh;
			if (!System.IO.Directory.Exists (Application.dataPath + "/3DTextMeshes")) {
				AssetDatabase.CreateFolder ("Assets", "3DTextMeshes");
			}
			AssetDatabase.CreateAsset (mesh, AssetDatabase.GenerateUniqueAssetPath ("Assets/3DTextMeshes/" + mesh.name + ".asset"));
		}
		
		EditorGUIUtility.LookLikeControls (50);
		
		GUI.enabled = true;
		Label ("Convert .ttf to .bytes", EditorStyles.boldLabel);
		ttfFile = ObjectField ("TTF File:", ttfFile, Font, false);
		if (ttfFile == null) {
			GUI.enabled = false;
		}
		if (Button ("Convert")) {
			if (!System.IO.Directory.Exists (Application.dataPath + "/ConvertedFonts")) {
				AssetDatabase.CreateFolder ("Assets", "ConvertedFonts");
			}
			var file = AssetDatabase.GetAssetPath (ttfFile);
			if (file.EndsWith (".ttf")) {
				var bytes = System.IO.File.ReadAllBytes (file);
				var idx = file.LastIndexOf ("/");
				file = file.Substring (idx+1, file.Length-idx-1);
				var name = Application.dataPath + "/ConvertedFonts/" + file.Substring (0, file.Length-4) + ".bytes";
				System.IO.File.WriteAllBytes (name, bytes);
				AssetDatabase.Refresh();
			}
		}
	}
}