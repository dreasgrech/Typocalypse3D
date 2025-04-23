Shader "Toon Shader Desktop/Trasparent/TSD Cutout detail bump" 
{
    Properties 
    {
		_Color ("H = Color, S = Saturation, V = matcap contribution, A = unity lights contribution ", Color) = (0.5,0.5,0.5,0.5)
       	_Shade ("Shading Texture", 2D) = "grey" {}
       	_MainTex ("Detail Texture", 2D) = "grey"  {}
		_BumpMap ("Bumpmap", 2D) = "bump" {}
		_Cutoff ("Alpha cutoff", Range(0,1)) = 0.5
    }
    
   SubShader 
   {
      Tags {"Queue"="AlphaTest" "IgnoreProjector"="True" "RenderType"="TransparentCutout"}
	  Cull Off	
	  LOD 200
      	
	Pass {
		Name "FORWARD"
		Tags { "LightMode" = "ForwardBase" }
		ColorMask RGB
Program "vp" {
// Vertex combos: 12
//   opengl - ALU: 17 to 77
//   d3d9 - ALU: 18 to 80
//   d3d11 - ALU: 9 to 40, TEX: 0 to 0, FLOW: 1 to 1
//   d3d11_9x - ALU: 9 to 37, TEX: 0 to 0, FLOW: 1 to 1
SubProgram "opengl " {
Keywords { "DIRECTIONAL" "LIGHTMAP_OFF" "DIRLIGHTMAP_OFF" "SHADOWS_OFF" }
Bind "vertex" Vertex
Bind "tangent" ATTR14
Bind "normal" Normal
Bind "texcoord" TexCoord0
Vector 17 [_WorldSpaceLightPos0]
Vector 18 [unity_SHAr]
Vector 19 [unity_SHAg]
Vector 20 [unity_SHAb]
Vector 21 [unity_SHBr]
Vector 22 [unity_SHBg]
Vector 23 [unity_SHBb]
Vector 24 [unity_SHC]
Matrix 9 [_Object2World]
Matrix 13 [_World2Object]
Vector 25 [unity_Scale]
Vector 26 [_MainTex_ST]
Vector 27 [_BumpMap_ST]
"!!ARBvp1.0
# 41 ALU
PARAM c[28] = { { 1 },
		state.matrix.mvp,
		state.matrix.modelview[0].invtrans,
		program.local[9..27] };
TEMP R0;
TEMP R1;
TEMP R2;
TEMP R3;
MUL R1.xyz, vertex.normal, c[25].w;
DP3 R2.w, R1, c[10];
DP3 R0.x, R1, c[9];
DP3 R0.z, R1, c[11];
MOV R0.y, R2.w;
MUL R1, R0.xyzz, R0.yzzx;
MOV R0.w, c[0].x;
DP4 R2.z, R0, c[20];
DP4 R2.y, R0, c[19];
DP4 R2.x, R0, c[18];
MUL R0.y, R2.w, R2.w;
DP4 R3.z, R1, c[23];
DP4 R3.y, R1, c[22];
DP4 R3.x, R1, c[21];
MOV R1.xyz, vertex.attrib[14];
ADD R3.xyz, R2, R3;
MAD R0.x, R0, R0, -R0.y;
MUL R2.xyz, R0.x, c[24];
MUL R0.xyz, vertex.normal.zxyw, R1.yzxw;
MAD R0.xyz, vertex.normal.yzxw, R1.zxyw, -R0;
MUL R0.xyz, R0, vertex.attrib[14].w;
ADD result.texcoord[4].xyz, R3, R2;
MOV R1, c[17];
DP4 R2.z, R1, c[15];
DP4 R2.x, R1, c[13];
DP4 R2.y, R1, c[14];
DP3 result.texcoord[3].y, R0, R2;
DP3 result.texcoord[1].y, R0, c[5];
DP3 result.texcoord[2].y, R0, c[6];
DP3 result.texcoord[3].z, vertex.normal, R2;
DP3 result.texcoord[3].x, vertex.attrib[14], R2;
MAD result.texcoord[0].zw, vertex.texcoord[0].xyxy, c[27].xyxy, c[27];
MAD result.texcoord[0].xy, vertex.texcoord[0], c[26], c[26].zwzw;
DP4 result.position.w, vertex.position, c[4];
DP4 result.position.z, vertex.position, c[3];
DP4 result.position.y, vertex.position, c[2];
DP4 result.position.x, vertex.position, c[1];
DP3 result.texcoord[1].z, vertex.normal, c[5];
DP3 result.texcoord[1].x, vertex.attrib[14], c[5];
DP3 result.texcoord[2].z, vertex.normal, c[6];
DP3 result.texcoord[2].x, vertex.attrib[14], c[6];
END
# 41 instructions, 4 R-regs
"
}

SubProgram "d3d9 " {
Keywords { "DIRECTIONAL" "LIGHTMAP_OFF" "DIRLIGHTMAP_OFF" "SHADOWS_OFF" }
Bind "vertex" Vertex
Bind "tangent" TexCoord2
Bind "normal" Normal
Bind "texcoord" TexCoord0
Matrix 0 [glstate_matrix_mvp]
Matrix 4 [glstate_matrix_invtrans_modelview0]
Vector 16 [_WorldSpaceLightPos0]
Vector 17 [unity_SHAr]
Vector 18 [unity_SHAg]
Vector 19 [unity_SHAb]
Vector 20 [unity_SHBr]
Vector 21 [unity_SHBg]
Vector 22 [unity_SHBb]
Vector 23 [unity_SHC]
Matrix 8 [_Object2World]
Matrix 12 [_World2Object]
Vector 24 [unity_Scale]
Vector 25 [_MainTex_ST]
Vector 26 [_BumpMap_ST]
"vs_2_0
; 44 ALU
def c27, 1.00000000, 0, 0, 0
dcl_position0 v0
dcl_tangent0 v1
dcl_normal0 v2
dcl_texcoord0 v3
mul r1.xyz, v2, c24.w
dp3 r2.w, r1, c9
dp3 r0.x, r1, c8
dp3 r0.z, r1, c10
mov r0.y, r2.w
mul r1, r0.xyzz, r0.yzzx
mov r0.w, c27.x
dp4 r2.z, r0, c19
dp4 r2.y, r0, c18
dp4 r2.x, r0, c17
mul r0.y, r2.w, r2.w
dp4 r3.z, r1, c22
dp4 r3.y, r1, c21
dp4 r3.x, r1, c20
mad r0.x, r0, r0, -r0.y
mul r1.xyz, r0.x, c23
add r2.xyz, r2, r3
mov r0.xyz, v1
add oT4.xyz, r2, r1
mul r1.xyz, v2.zxyw, r0.yzxw
mov r0.xyz, v1
mad r1.xyz, v2.yzxw, r0.zxyw, -r1
mul r2.xyz, r1, v1.w
mov r0, c14
dp4 r3.z, c16, r0
mov r1, c12
mov r0, c13
dp4 r3.x, c16, r1
dp4 r3.y, c16, r0
dp3 oT3.y, r2, r3
dp3 oT1.y, r2, c4
dp3 oT2.y, r2, c5
dp3 oT3.z, v2, r3
dp3 oT3.x, v1, r3
mad oT0.zw, v3.xyxy, c26.xyxy, c26
mad oT0.xy, v3, c25, c25.zwzw
dp4 oPos.w, v0, c3
dp4 oPos.z, v0, c2
dp4 oPos.y, v0, c1
dp4 oPos.x, v0, c0
dp3 oT1.z, v2, c4
dp3 oT1.x, v1, c4
dp3 oT2.z, v2, c5
dp3 oT2.x, v1, c5
"
}

SubProgram "d3d11 " {
Keywords { "DIRECTIONAL" "LIGHTMAP_OFF" "DIRLIGHTMAP_OFF" "SHADOWS_OFF" }
Bind "vertex" Vertex
Bind "tangent" TexCoord2
Bind "normal" Normal
Bind "texcoord" TexCoord0
Bind "color" Color
ConstBuffer "$Globals" 112 // 96 used size, 7 vars
Vector 64 [_MainTex_ST] 4
Vector 80 [_BumpMap_ST] 4
ConstBuffer "UnityLighting" 400 // 400 used size, 16 vars
Vector 0 [_WorldSpaceLightPos0] 4
Vector 288 [unity_SHAr] 4
Vector 304 [unity_SHAg] 4
Vector 320 [unity_SHAb] 4
Vector 336 [unity_SHBr] 4
Vector 352 [unity_SHBg] 4
Vector 368 [unity_SHBb] 4
Vector 384 [unity_SHC] 4
ConstBuffer "UnityPerDraw" 336 // 336 used size, 6 vars
Matrix 0 [glstate_matrix_mvp] 4
Matrix 128 [glstate_matrix_invtrans_modelview0] 4
Matrix 192 [_Object2World] 4
Matrix 256 [_World2Object] 4
Vector 320 [unity_Scale] 4
BindCB "$Globals" 0
BindCB "UnityLighting" 1
BindCB "UnityPerDraw" 2
// 45 instructions, 4 temp regs, 0 temp arrays:
// ALU 24 float, 0 int, 0 uint
// TEX 0 (0 load, 0 comp, 0 bias, 0 grad)
// FLOW 1 static, 0 dynamic
"vs_4_0
eefiecedgdolnokdhpfbdbnhfifpcgcolanpbiodabaaaaaaaaaiaaaaadaaaaaa
cmaaaaaapeaaaaaakmabaaaaejfdeheomaaaaaaaagaaaaaaaiaaaaaajiaaaaaa
aaaaaaaaaaaaaaaaadaaaaaaaaaaaaaaapapaaaakbaaaaaaaaaaaaaaaaaaaaaa
adaaaaaaabaaaaaaapapaaaakjaaaaaaaaaaaaaaaaaaaaaaadaaaaaaacaaaaaa
ahahaaaalaaaaaaaaaaaaaaaaaaaaaaaadaaaaaaadaaaaaaapadaaaalaaaaaaa
abaaaaaaaaaaaaaaadaaaaaaaeaaaaaaapaaaaaaljaaaaaaaaaaaaaaaaaaaaaa
adaaaaaaafaaaaaaapaaaaaafaepfdejfeejepeoaafeebeoehefeofeaaeoepfc
enebemaafeeffiedepepfceeaaedepemepfcaaklepfdeheolaaaaaaaagaaaaaa
aiaaaaaajiaaaaaaaaaaaaaaabaaaaaaadaaaaaaaaaaaaaaapaaaaaakeaaaaaa
aaaaaaaaaaaaaaaaadaaaaaaabaaaaaaapaaaaaakeaaaaaaabaaaaaaaaaaaaaa
adaaaaaaacaaaaaaahaiaaaakeaaaaaaacaaaaaaaaaaaaaaadaaaaaaadaaaaaa
ahaiaaaakeaaaaaaadaaaaaaaaaaaaaaadaaaaaaaeaaaaaaahaiaaaakeaaaaaa
aeaaaaaaaaaaaaaaadaaaaaaafaaaaaaahaiaaaafdfgfpfaepfdejfeejepeoaa
feeffiedepepfceeaaklklklfdeieefcemagaaaaeaaaabaajdabaaaafjaaaaae
egiocaaaaaaaaaaaagaaaaaafjaaaaaeegiocaaaabaaaaaabjaaaaaafjaaaaae
egiocaaaacaaaaaabfaaaaaafpaaaaadpcbabaaaaaaaaaaafpaaaaadpcbabaaa
abaaaaaafpaaaaadhcbabaaaacaaaaaafpaaaaaddcbabaaaadaaaaaaghaaaaae
pccabaaaaaaaaaaaabaaaaaagfaaaaadpccabaaaabaaaaaagfaaaaadhccabaaa
acaaaaaagfaaaaadhccabaaaadaaaaaagfaaaaadhccabaaaaeaaaaaagfaaaaad
hccabaaaafaaaaaagiaaaaacaeaaaaaadiaaaaaipcaabaaaaaaaaaaafgbfbaaa
aaaaaaaaegiocaaaacaaaaaaabaaaaaadcaaaaakpcaabaaaaaaaaaaaegiocaaa
acaaaaaaaaaaaaaaagbabaaaaaaaaaaaegaobaaaaaaaaaaadcaaaaakpcaabaaa
aaaaaaaaegiocaaaacaaaaaaacaaaaaakgbkbaaaaaaaaaaaegaobaaaaaaaaaaa
dcaaaaakpccabaaaaaaaaaaaegiocaaaacaaaaaaadaaaaaapgbpbaaaaaaaaaaa
egaobaaaaaaaaaaadcaaaaaldccabaaaabaaaaaaegbabaaaadaaaaaaegiacaaa
aaaaaaaaaeaaaaaaogikcaaaaaaaaaaaaeaaaaaadcaaaaalmccabaaaabaaaaaa
agbebaaaadaaaaaaagiecaaaaaaaaaaaafaaaaaakgiocaaaaaaaaaaaafaaaaaa
diaaaaahhcaabaaaaaaaaaaajgbebaaaabaaaaaacgbjbaaaacaaaaaadcaaaaak
hcaabaaaaaaaaaaajgbebaaaacaaaaaacgbjbaaaabaaaaaaegacbaiaebaaaaaa
aaaaaaaadiaaaaahhcaabaaaaaaaaaaaegacbaaaaaaaaaaapgbpbaaaabaaaaaa
dgaaaaagbcaabaaaabaaaaaaakiacaaaacaaaaaaaiaaaaaadgaaaaagccaabaaa
abaaaaaaakiacaaaacaaaaaaajaaaaaadgaaaaagecaabaaaabaaaaaaakiacaaa
acaaaaaaakaaaaaabaaaaaahcccabaaaacaaaaaaegacbaaaaaaaaaaaegacbaaa
abaaaaaabaaaaaahbccabaaaacaaaaaaegbcbaaaabaaaaaaegacbaaaabaaaaaa
baaaaaaheccabaaaacaaaaaaegbcbaaaacaaaaaaegacbaaaabaaaaaadgaaaaag
bcaabaaaabaaaaaabkiacaaaacaaaaaaaiaaaaaadgaaaaagccaabaaaabaaaaaa
bkiacaaaacaaaaaaajaaaaaadgaaaaagecaabaaaabaaaaaabkiacaaaacaaaaaa
akaaaaaabaaaaaahcccabaaaadaaaaaaegacbaaaaaaaaaaaegacbaaaabaaaaaa
baaaaaahbccabaaaadaaaaaaegbcbaaaabaaaaaaegacbaaaabaaaaaabaaaaaah
eccabaaaadaaaaaaegbcbaaaacaaaaaaegacbaaaabaaaaaadiaaaaajhcaabaaa
abaaaaaafgifcaaaabaaaaaaaaaaaaaaegiccaaaacaaaaaabbaaaaaadcaaaaal
hcaabaaaabaaaaaaegiccaaaacaaaaaabaaaaaaaagiacaaaabaaaaaaaaaaaaaa
egacbaaaabaaaaaadcaaaaalhcaabaaaabaaaaaaegiccaaaacaaaaaabcaaaaaa
kgikcaaaabaaaaaaaaaaaaaaegacbaaaabaaaaaadcaaaaalhcaabaaaabaaaaaa
egiccaaaacaaaaaabdaaaaaapgipcaaaabaaaaaaaaaaaaaaegacbaaaabaaaaaa
baaaaaahcccabaaaaeaaaaaaegacbaaaaaaaaaaaegacbaaaabaaaaaabaaaaaah
bccabaaaaeaaaaaaegbcbaaaabaaaaaaegacbaaaabaaaaaabaaaaaaheccabaaa
aeaaaaaaegbcbaaaacaaaaaaegacbaaaabaaaaaadiaaaaaihcaabaaaaaaaaaaa
egbcbaaaacaaaaaapgipcaaaacaaaaaabeaaaaaadiaaaaaihcaabaaaabaaaaaa
fgafbaaaaaaaaaaaegiccaaaacaaaaaaanaaaaaadcaaaaaklcaabaaaaaaaaaaa
egiicaaaacaaaaaaamaaaaaaagaabaaaaaaaaaaaegaibaaaabaaaaaadcaaaaak
hcaabaaaaaaaaaaaegiccaaaacaaaaaaaoaaaaaakgakbaaaaaaaaaaaegadbaaa
aaaaaaaadgaaaaaficaabaaaaaaaaaaaabeaaaaaaaaaiadpbbaaaaaibcaabaaa
abaaaaaaegiocaaaabaaaaaabcaaaaaaegaobaaaaaaaaaaabbaaaaaiccaabaaa
abaaaaaaegiocaaaabaaaaaabdaaaaaaegaobaaaaaaaaaaabbaaaaaiecaabaaa
abaaaaaaegiocaaaabaaaaaabeaaaaaaegaobaaaaaaaaaaadiaaaaahpcaabaaa
acaaaaaajgacbaaaaaaaaaaaegakbaaaaaaaaaaabbaaaaaibcaabaaaadaaaaaa
egiocaaaabaaaaaabfaaaaaaegaobaaaacaaaaaabbaaaaaiccaabaaaadaaaaaa
egiocaaaabaaaaaabgaaaaaaegaobaaaacaaaaaabbaaaaaiecaabaaaadaaaaaa
egiocaaaabaaaaaabhaaaaaaegaobaaaacaaaaaaaaaaaaahhcaabaaaabaaaaaa
egacbaaaabaaaaaaegacbaaaadaaaaaadiaaaaahccaabaaaaaaaaaaabkaabaaa
aaaaaaaabkaabaaaaaaaaaaadcaaaaakbcaabaaaaaaaaaaaakaabaaaaaaaaaaa
akaabaaaaaaaaaaabkaabaiaebaaaaaaaaaaaaaadcaaaaakhccabaaaafaaaaaa
egiccaaaabaaaaaabiaaaaaaagaabaaaaaaaaaaaegacbaaaabaaaaaadoaaaaab
"
}

SubProgram "gles " {
Keywords { "DIRECTIONAL" "LIGHTMAP_OFF" "DIRLIGHTMAP_OFF" "SHADOWS_OFF" }
"!!GLES
#define SHADER_API_GLES 1
#define tex2D texture2D


#ifdef VERTEX
#define gl_ModelViewProjectionMatrix glstate_matrix_mvp
uniform mat4 glstate_matrix_mvp;
#define gl_ModelViewMatrixInverseTranspose glstate_matrix_invtrans_modelview0
uniform mat4 glstate_matrix_invtrans_modelview0;
#define gl_ModelViewMatrix glstate_matrix_modelview0
uniform mat4 glstate_matrix_modelview0;

varying lowp vec3 xlv_TEXCOORD4;
varying lowp vec3 xlv_TEXCOORD3;
varying highp vec3 xlv_TEXCOORD2;
varying highp vec3 xlv_TEXCOORD1;
varying highp vec4 xlv_TEXCOORD0;
uniform highp vec4 _BumpMap_ST;
uniform highp vec4 _MainTex_ST;
uniform highp vec4 unity_Scale;
uniform highp mat4 _World2Object;
uniform highp mat4 _Object2World;


uniform highp vec4 unity_SHC;
uniform highp vec4 unity_SHBb;
uniform highp vec4 unity_SHBg;
uniform highp vec4 unity_SHBr;
uniform highp vec4 unity_SHAb;
uniform highp vec4 unity_SHAg;
uniform highp vec4 unity_SHAr;
uniform lowp vec4 _WorldSpaceLightPos0;
attribute vec4 _glesTANGENT;
attribute vec4 _glesMultiTexCoord0;
attribute vec3 _glesNormal;
attribute vec4 _glesVertex;
void main ()
{
  vec4 tmpvar_1;
  tmpvar_1.xyz = normalize(_glesTANGENT.xyz);
  tmpvar_1.w = _glesTANGENT.w;
  vec3 tmpvar_2;
  tmpvar_2 = normalize(_glesNormal);
  highp vec3 shlight_3;
  highp vec4 tmpvar_4;
  lowp vec3 tmpvar_5;
  lowp vec3 tmpvar_6;
  highp vec3 tmpvar_7;
  highp vec3 tmpvar_8;
  tmpvar_7 = tmpvar_1.xyz;
  tmpvar_8 = (((tmpvar_2.yzx * tmpvar_1.zxy) - (tmpvar_2.zxy * tmpvar_1.yzx)) * _glesTANGENT.w);
  highp mat3 tmpvar_9;
  tmpvar_9[0].x = tmpvar_7.x;
  tmpvar_9[0].y = tmpvar_8.x;
  tmpvar_9[0].z = tmpvar_2.x;
  tmpvar_9[1].x = tmpvar_7.y;
  tmpvar_9[1].y = tmpvar_8.y;
  tmpvar_9[1].z = tmpvar_2.y;
  tmpvar_9[2].x = tmpvar_7.z;
  tmpvar_9[2].y = tmpvar_8.z;
  tmpvar_9[2].z = tmpvar_2.z;
  vec4 v_10;
  v_10.x = gl_ModelViewMatrixInverseTranspose[0].x;
  v_10.y = gl_ModelViewMatrixInverseTranspose[1].x;
  v_10.z = gl_ModelViewMatrixInverseTranspose[2].x;
  v_10.w = gl_ModelViewMatrixInverseTranspose[3].x;
  vec4 v_11;
  v_11.x = gl_ModelViewMatrixInverseTranspose[0].y;
  v_11.y = gl_ModelViewMatrixInverseTranspose[1].y;
  v_11.z = gl_ModelViewMatrixInverseTranspose[2].y;
  v_11.w = gl_ModelViewMatrixInverseTranspose[3].y;
  tmpvar_4.xy = ((_glesMultiTexCoord0.xy * _MainTex_ST.xy) + _MainTex_ST.zw);
  tmpvar_4.zw = ((_glesMultiTexCoord0.xy * _BumpMap_ST.xy) + _BumpMap_ST.zw);
  mat3 tmpvar_12;
  tmpvar_12[0] = _Object2World[0].xyz;
  tmpvar_12[1] = _Object2World[1].xyz;
  tmpvar_12[2] = _Object2World[2].xyz;
  highp vec3 tmpvar_13;
  highp vec3 tmpvar_14;
  tmpvar_13 = tmpvar_1.xyz;
  tmpvar_14 = (((tmpvar_2.yzx * tmpvar_1.zxy) - (tmpvar_2.zxy * tmpvar_1.yzx)) * _glesTANGENT.w);
  highp mat3 tmpvar_15;
  tmpvar_15[0].x = tmpvar_13.x;
  tmpvar_15[0].y = tmpvar_14.x;
  tmpvar_15[0].z = tmpvar_2.x;
  tmpvar_15[1].x = tmpvar_13.y;
  tmpvar_15[1].y = tmpvar_14.y;
  tmpvar_15[1].z = tmpvar_2.y;
  tmpvar_15[2].x = tmpvar_13.z;
  tmpvar_15[2].y = tmpvar_14.z;
  tmpvar_15[2].z = tmpvar_2.z;
  highp vec3 tmpvar_16;
  tmpvar_16 = (tmpvar_15 * (_World2Object * _WorldSpaceLightPos0).xyz);
  tmpvar_5 = tmpvar_16;
  highp vec4 tmpvar_17;
  tmpvar_17.w = 1.0;
  tmpvar_17.xyz = (tmpvar_12 * (tmpvar_2 * unity_Scale.w));
  mediump vec3 tmpvar_18;
  mediump vec4 normal_19;
  normal_19 = tmpvar_17;
  highp float vC_20;
  mediump vec3 x3_21;
  mediump vec3 x2_22;
  mediump vec3 x1_23;
  highp float tmpvar_24;
  tmpvar_24 = dot (unity_SHAr, normal_19);
  x1_23.x = tmpvar_24;
  highp float tmpvar_25;
  tmpvar_25 = dot (unity_SHAg, normal_19);
  x1_23.y = tmpvar_25;
  highp float tmpvar_26;
  tmpvar_26 = dot (unity_SHAb, normal_19);
  x1_23.z = tmpvar_26;
  mediump vec4 tmpvar_27;
  tmpvar_27 = (normal_19.xyzz * normal_19.yzzx);
  highp float tmpvar_28;
  tmpvar_28 = dot (unity_SHBr, tmpvar_27);
  x2_22.x = tmpvar_28;
  highp float tmpvar_29;
  tmpvar_29 = dot (unity_SHBg, tmpvar_27);
  x2_22.y = tmpvar_29;
  highp float tmpvar_30;
  tmpvar_30 = dot (unity_SHBb, tmpvar_27);
  x2_22.z = tmpvar_30;
  mediump float tmpvar_31;
  tmpvar_31 = ((normal_19.x * normal_19.x) - (normal_19.y * normal_19.y));
  vC_20 = tmpvar_31;
  highp vec3 tmpvar_32;
  tmpvar_32 = (unity_SHC.xyz * vC_20);
  x3_21 = tmpvar_32;
  tmpvar_18 = ((x1_23 + x2_22) + x3_21);
  shlight_3 = tmpvar_18;
  tmpvar_6 = shlight_3;
  gl_Position = (gl_ModelViewProjectionMatrix * _glesVertex);
  xlv_TEXCOORD0 = tmpvar_4;
  xlv_TEXCOORD1 = (tmpvar_9 * v_10.xyz);
  xlv_TEXCOORD2 = (tmpvar_9 * v_11.xyz);
  xlv_TEXCOORD3 = tmpvar_5;
  xlv_TEXCOORD4 = tmpvar_6;
}



#endif
#ifdef FRAGMENT

varying lowp vec3 xlv_TEXCOORD4;
varying lowp vec3 xlv_TEXCOORD3;
varying highp vec3 xlv_TEXCOORD2;
varying highp vec3 xlv_TEXCOORD1;
varying highp vec4 xlv_TEXCOORD0;
uniform lowp float _Cutoff;
uniform sampler2D _Shade;
uniform sampler2D _BumpMap;
uniform sampler2D _MainTex;
uniform lowp vec4 _Color;
uniform lowp vec4 _LightColor0;
void main ()
{
  lowp vec4 c_1;
  lowp vec3 tmpvar_2;
  highp vec3 matcap_3;
  lowp vec3 tmpvar_4;
  tmpvar_4 = ((texture2D (_BumpMap, xlv_TEXCOORD0.zw).xyz * 2.0) - 1.0);
  lowp vec3 tmpvar_5;
  tmpvar_5 = (texture2D (_MainTex, xlv_TEXCOORD0.xy).xyz * _Color.w);
  highp vec2 tmpvar_6;
  tmpvar_6.x = dot (xlv_TEXCOORD1, tmpvar_4);
  tmpvar_6.y = dot (xlv_TEXCOORD2, tmpvar_4);
  highp vec2 P_7;
  P_7 = ((tmpvar_6 * 0.5) + 0.5);
  lowp vec3 tmpvar_8;
  tmpvar_8 = texture2D (_Shade, P_7).xyz;
  matcap_3 = tmpvar_8;
  lowp vec4 tmpvar_9;
  tmpvar_9 = texture2D (_MainTex, xlv_TEXCOORD0.xy);
  highp vec3 tmpvar_10;
  tmpvar_10 = (((matcap_3 * tmpvar_9.xyz) * _Color.xyz) * 3.0);
  tmpvar_2 = tmpvar_10;
  lowp vec4 tmpvar_11;
  tmpvar_11 = texture2D (_MainTex, xlv_TEXCOORD0.xy);
  lowp float tmpvar_12;
  tmpvar_12 = tmpvar_11.w;
  lowp float x_13;
  x_13 = (tmpvar_11.w - _Cutoff);
  if ((x_13 < 0.0)) {
    discard;
  };
  lowp vec4 c_14;
  c_14.xyz = ((tmpvar_5 * _LightColor0.xyz) * (max (0.0, dot (tmpvar_4, xlv_TEXCOORD3)) * 2.0));
  c_14.w = tmpvar_12;
  c_1.w = c_14.w;
  c_1.xyz = (c_14.xyz + (tmpvar_5 * xlv_TEXCOORD4));
  c_1.xyz = (c_1.xyz + tmpvar_2);
  c_1.w = tmpvar_12;
  gl_FragData[0] = c_1;
}



#endif"
}

SubProgram "glesdesktop " {
Keywords { "DIRECTIONAL" "LIGHTMAP_OFF" "DIRLIGHTMAP_OFF" "SHADOWS_OFF" }
"!!GLES
#define SHADER_API_GLES 1
#define tex2D texture2D


#ifdef VERTEX
#define gl_ModelViewProjectionMatrix glstate_matrix_mvp
uniform mat4 glstate_matrix_mvp;
#define gl_ModelViewMatrixInverseTranspose glstate_matrix_invtrans_modelview0
uniform mat4 glstate_matrix_invtrans_modelview0;
#define gl_ModelViewMatrix glstate_matrix_modelview0
uniform mat4 glstate_matrix_modelview0;

varying lowp vec3 xlv_TEXCOORD4;
varying lowp vec3 xlv_TEXCOORD3;
varying highp vec3 xlv_TEXCOORD2;
varying highp vec3 xlv_TEXCOORD1;
varying highp vec4 xlv_TEXCOORD0;
uniform highp vec4 _BumpMap_ST;
uniform highp vec4 _MainTex_ST;
uniform highp vec4 unity_Scale;
uniform highp mat4 _World2Object;
uniform highp mat4 _Object2World;


uniform highp vec4 unity_SHC;
uniform highp vec4 unity_SHBb;
uniform highp vec4 unity_SHBg;
uniform highp vec4 unity_SHBr;
uniform highp vec4 unity_SHAb;
uniform highp vec4 unity_SHAg;
uniform highp vec4 unity_SHAr;
uniform lowp vec4 _WorldSpaceLightPos0;
attribute vec4 _glesTANGENT;
attribute vec4 _glesMultiTexCoord0;
attribute vec3 _glesNormal;
attribute vec4 _glesVertex;
void main ()
{
  vec4 tmpvar_1;
  tmpvar_1.xyz = normalize(_glesTANGENT.xyz);
  tmpvar_1.w = _glesTANGENT.w;
  vec3 tmpvar_2;
  tmpvar_2 = normalize(_glesNormal);
  highp vec3 shlight_3;
  highp vec4 tmpvar_4;
  lowp vec3 tmpvar_5;
  lowp vec3 tmpvar_6;
  highp vec3 tmpvar_7;
  highp vec3 tmpvar_8;
  tmpvar_7 = tmpvar_1.xyz;
  tmpvar_8 = (((tmpvar_2.yzx * tmpvar_1.zxy) - (tmpvar_2.zxy * tmpvar_1.yzx)) * _glesTANGENT.w);
  highp mat3 tmpvar_9;
  tmpvar_9[0].x = tmpvar_7.x;
  tmpvar_9[0].y = tmpvar_8.x;
  tmpvar_9[0].z = tmpvar_2.x;
  tmpvar_9[1].x = tmpvar_7.y;
  tmpvar_9[1].y = tmpvar_8.y;
  tmpvar_9[1].z = tmpvar_2.y;
  tmpvar_9[2].x = tmpvar_7.z;
  tmpvar_9[2].y = tmpvar_8.z;
  tmpvar_9[2].z = tmpvar_2.z;
  vec4 v_10;
  v_10.x = gl_ModelViewMatrixInverseTranspose[0].x;
  v_10.y = gl_ModelViewMatrixInverseTranspose[1].x;
  v_10.z = gl_ModelViewMatrixInverseTranspose[2].x;
  v_10.w = gl_ModelViewMatrixInverseTranspose[3].x;
  vec4 v_11;
  v_11.x = gl_ModelViewMatrixInverseTranspose[0].y;
  v_11.y = gl_ModelViewMatrixInverseTranspose[1].y;
  v_11.z = gl_ModelViewMatrixInverseTranspose[2].y;
  v_11.w = gl_ModelViewMatrixInverseTranspose[3].y;
  tmpvar_4.xy = ((_glesMultiTexCoord0.xy * _MainTex_ST.xy) + _MainTex_ST.zw);
  tmpvar_4.zw = ((_glesMultiTexCoord0.xy * _BumpMap_ST.xy) + _BumpMap_ST.zw);
  mat3 tmpvar_12;
  tmpvar_12[0] = _Object2World[0].xyz;
  tmpvar_12[1] = _Object2World[1].xyz;
  tmpvar_12[2] = _Object2World[2].xyz;
  highp vec3 tmpvar_13;
  highp vec3 tmpvar_14;
  tmpvar_13 = tmpvar_1.xyz;
  tmpvar_14 = (((tmpvar_2.yzx * tmpvar_1.zxy) - (tmpvar_2.zxy * tmpvar_1.yzx)) * _glesTANGENT.w);
  highp mat3 tmpvar_15;
  tmpvar_15[0].x = tmpvar_13.x;
  tmpvar_15[0].y = tmpvar_14.x;
  tmpvar_15[0].z = tmpvar_2.x;
  tmpvar_15[1].x = tmpvar_13.y;
  tmpvar_15[1].y = tmpvar_14.y;
  tmpvar_15[1].z = tmpvar_2.y;
  tmpvar_15[2].x = tmpvar_13.z;
  tmpvar_15[2].y = tmpvar_14.z;
  tmpvar_15[2].z = tmpvar_2.z;
  highp vec3 tmpvar_16;
  tmpvar_16 = (tmpvar_15 * (_World2Object * _WorldSpaceLightPos0).xyz);
  tmpvar_5 = tmpvar_16;
  highp vec4 tmpvar_17;
  tmpvar_17.w = 1.0;
  tmpvar_17.xyz = (tmpvar_12 * (tmpvar_2 * unity_Scale.w));
  mediump vec3 tmpvar_18;
  mediump vec4 normal_19;
  normal_19 = tmpvar_17;
  highp float vC_20;
  mediump vec3 x3_21;
  mediump vec3 x2_22;
  mediump vec3 x1_23;
  highp float tmpvar_24;
  tmpvar_24 = dot (unity_SHAr, normal_19);
  x1_23.x = tmpvar_24;
  highp float tmpvar_25;
  tmpvar_25 = dot (unity_SHAg, normal_19);
  x1_23.y = tmpvar_25;
  highp float tmpvar_26;
  tmpvar_26 = dot (unity_SHAb, normal_19);
  x1_23.z = tmpvar_26;
  mediump vec4 tmpvar_27;
  tmpvar_27 = (normal_19.xyzz * normal_19.yzzx);
  highp float tmpvar_28;
  tmpvar_28 = dot (unity_SHBr, tmpvar_27);
  x2_22.x = tmpvar_28;
  highp float tmpvar_29;
  tmpvar_29 = dot (unity_SHBg, tmpvar_27);
  x2_22.y = tmpvar_29;
  highp float tmpvar_30;
  tmpvar_30 = dot (unity_SHBb, tmpvar_27);
  x2_22.z = tmpvar_30;
  mediump float tmpvar_31;
  tmpvar_31 = ((normal_19.x * normal_19.x) - (normal_19.y * normal_19.y));
  vC_20 = tmpvar_31;
  highp vec3 tmpvar_32;
  tmpvar_32 = (unity_SHC.xyz * vC_20);
  x3_21 = tmpvar_32;
  tmpvar_18 = ((x1_23 + x2_22) + x3_21);
  shlight_3 = tmpvar_18;
  tmpvar_6 = shlight_3;
  gl_Position = (gl_ModelViewProjectionMatrix * _glesVertex);
  xlv_TEXCOORD0 = tmpvar_4;
  xlv_TEXCOORD1 = (tmpvar_9 * v_10.xyz);
  xlv_TEXCOORD2 = (tmpvar_9 * v_11.xyz);
  xlv_TEXCOORD3 = tmpvar_5;
  xlv_TEXCOORD4 = tmpvar_6;
}



#endif
#ifdef FRAGMENT

varying lowp vec3 xlv_TEXCOORD4;
varying lowp vec3 xlv_TEXCOORD3;
varying highp vec3 xlv_TEXCOORD2;
varying highp vec3 xlv_TEXCOORD1;
varying highp vec4 xlv_TEXCOORD0;
uniform lowp float _Cutoff;
uniform sampler2D _Shade;
uniform sampler2D _BumpMap;
uniform sampler2D _MainTex;
uniform lowp vec4 _Color;
uniform lowp vec4 _LightColor0;
void main ()
{
  lowp vec4 c_1;
  lowp vec3 tmpvar_2;
  highp vec3 matcap_3;
  lowp vec3 normal_4;
  normal_4.xy = ((texture2D (_BumpMap, xlv_TEXCOORD0.zw).wy * 2.0) - 1.0);
  normal_4.z = sqrt(((1.0 - (normal_4.x * normal_4.x)) - (normal_4.y * normal_4.y)));
  lowp vec3 tmpvar_5;
  tmpvar_5 = (texture2D (_MainTex, xlv_TEXCOORD0.xy).xyz * _Color.w);
  highp vec2 tmpvar_6;
  tmpvar_6.x = dot (xlv_TEXCOORD1, normal_4);
  tmpvar_6.y = dot (xlv_TEXCOORD2, normal_4);
  highp vec2 P_7;
  P_7 = ((tmpvar_6 * 0.5) + 0.5);
  lowp vec3 tmpvar_8;
  tmpvar_8 = texture2D (_Shade, P_7).xyz;
  matcap_3 = tmpvar_8;
  lowp vec4 tmpvar_9;
  tmpvar_9 = texture2D (_MainTex, xlv_TEXCOORD0.xy);
  highp vec3 tmpvar_10;
  tmpvar_10 = (((matcap_3 * tmpvar_9.xyz) * _Color.xyz) * 3.0);
  tmpvar_2 = tmpvar_10;
  lowp vec4 tmpvar_11;
  tmpvar_11 = texture2D (_MainTex, xlv_TEXCOORD0.xy);
  lowp float tmpvar_12;
  tmpvar_12 = tmpvar_11.w;
  lowp float x_13;
  x_13 = (tmpvar_11.w - _Cutoff);
  if ((x_13 < 0.0)) {
    discard;
  };
  lowp vec4 c_14;
  c_14.xyz = ((tmpvar_5 * _LightColor0.xyz) * (max (0.0, dot (normal_4, xlv_TEXCOORD3)) * 2.0));
  c_14.w = tmpvar_12;
  c_1.w = c_14.w;
  c_1.xyz = (c_14.xyz + (tmpvar_5 * xlv_TEXCOORD4));
  c_1.xyz = (c_1.xyz + tmpvar_2);
  c_1.w = tmpvar_12;
  gl_FragData[0] = c_1;
}



#endif"
}

SubProgram "flash " {
Keywords { "DIRECTIONAL" "LIGHTMAP_OFF" "DIRLIGHTMAP_OFF" "SHADOWS_OFF" }
Bind "vertex" Vertex
Bind "tangent" TexCoord2
Bind "normal" Normal
Bind "texcoord" TexCoord0
Matrix 0 [glstate_matrix_mvp]
Matrix 4 [glstate_matrix_invtrans_modelview0]
Vector 16 [_WorldSpaceLightPos0]
Vector 17 [unity_SHAr]
Vector 18 [unity_SHAg]
Vector 19 [unity_SHAb]
Vector 20 [unity_SHBr]
Vector 21 [unity_SHBg]
Vector 22 [unity_SHBb]
Vector 23 [unity_SHC]
Matrix 8 [_Object2World]
Matrix 12 [_World2Object]
Vector 24 [unity_Scale]
Vector 25 [_MainTex_ST]
Vector 26 [_BumpMap_ST]
"agal_vs
c27 1.0 0.0 0.0 0.0
[bc]
adaaaaaaabaaahacabaaaaoeaaaaaaaabiaaaappabaaaaaa mul r1.xyz, a1, c24.w
bcaaaaaaacaaaiacabaaaakeacaaaaaaajaaaaoeabaaaaaa dp3 r2.w, r1.xyzz, c9
bcaaaaaaaaaaabacabaaaakeacaaaaaaaiaaaaoeabaaaaaa dp3 r0.x, r1.xyzz, c8
bcaaaaaaaaaaaeacabaaaakeacaaaaaaakaaaaoeabaaaaaa dp3 r0.z, r1.xyzz, c10
aaaaaaaaaaaaacacacaaaappacaaaaaaaaaaaaaaaaaaaaaa mov r0.y, r2.w
adaaaaaaabaaapacaaaaaakeacaaaaaaaaaaaacjacaaaaaa mul r1, r0.xyzz, r0.yzzx
aaaaaaaaaaaaaiacblaaaaaaabaaaaaaaaaaaaaaaaaaaaaa mov r0.w, c27.x
bdaaaaaaacaaaeacaaaaaaoeacaaaaaabdaaaaoeabaaaaaa dp4 r2.z, r0, c19
bdaaaaaaacaaacacaaaaaaoeacaaaaaabcaaaaoeabaaaaaa dp4 r2.y, r0, c18
bdaaaaaaacaaabacaaaaaaoeacaaaaaabbaaaaoeabaaaaaa dp4 r2.x, r0, c17
adaaaaaaaaaaacacacaaaappacaaaaaaacaaaappacaaaaaa mul r0.y, r2.w, r2.w
bdaaaaaaadaaaeacabaaaaoeacaaaaaabgaaaaoeabaaaaaa dp4 r3.z, r1, c22
bdaaaaaaadaaacacabaaaaoeacaaaaaabfaaaaoeabaaaaaa dp4 r3.y, r1, c21
bdaaaaaaadaaabacabaaaaoeacaaaaaabeaaaaoeabaaaaaa dp4 r3.x, r1, c20
adaaaaaaadaaaiacaaaaaaaaacaaaaaaaaaaaaaaacaaaaaa mul r3.w, r0.x, r0.x
acaaaaaaaaaaabacadaaaappacaaaaaaaaaaaaffacaaaaaa sub r0.x, r3.w, r0.y
adaaaaaaabaaahacaaaaaaaaacaaaaaabhaaaaoeabaaaaaa mul r1.xyz, r0.x, c23
abaaaaaaacaaahacacaaaakeacaaaaaaadaaaakeacaaaaaa add r2.xyz, r2.xyzz, r3.xyzz
aaaaaaaaaaaaahacafaaaaoeaaaaaaaaaaaaaaaaaaaaaaaa mov r0.xyz, a5
abaaaaaaaeaaahaeacaaaakeacaaaaaaabaaaakeacaaaaaa add v4.xyz, r2.xyzz, r1.xyzz
adaaaaaaabaaahacabaaaancaaaaaaaaaaaaaaajacaaaaaa mul r1.xyz, a1.zxyw, r0.yzxx
aaaaaaaaaaaaahacafaaaaoeaaaaaaaaaaaaaaaaaaaaaaaa mov r0.xyz, a5
adaaaaaaaeaaahacabaaaamjaaaaaaaaaaaaaafcacaaaaaa mul r4.xyz, a1.yzxw, r0.zxyy
acaaaaaaabaaahacaeaaaakeacaaaaaaabaaaakeacaaaaaa sub r1.xyz, r4.xyzz, r1.xyzz
adaaaaaaacaaahacabaaaakeacaaaaaaafaaaappaaaaaaaa mul r2.xyz, r1.xyzz, a5.w
aaaaaaaaaaaaapacaoaaaaoeabaaaaaaaaaaaaaaaaaaaaaa mov r0, c14
bdaaaaaaadaaaeacbaaaaaoeabaaaaaaaaaaaaoeacaaaaaa dp4 r3.z, c16, r0
aaaaaaaaabaaapacamaaaaoeabaaaaaaaaaaaaaaaaaaaaaa mov r1, c12
aaaaaaaaaaaaapacanaaaaoeabaaaaaaaaaaaaaaaaaaaaaa mov r0, c13
bdaaaaaaadaaabacbaaaaaoeabaaaaaaabaaaaoeacaaaaaa dp4 r3.x, c16, r1
bdaaaaaaadaaacacbaaaaaoeabaaaaaaaaaaaaoeacaaaaaa dp4 r3.y, c16, r0
bcaaaaaaadaaacaeacaaaakeacaaaaaaadaaaakeacaaaaaa dp3 v3.y, r2.xyzz, r3.xyzz
bcaaaaaaabaaacaeacaaaakeacaaaaaaaeaaaaoeabaaaaaa dp3 v1.y, r2.xyzz, c4
bcaaaaaaacaaacaeacaaaakeacaaaaaaafaaaaoeabaaaaaa dp3 v2.y, r2.xyzz, c5
bcaaaaaaadaaaeaeabaaaaoeaaaaaaaaadaaaakeacaaaaaa dp3 v3.z, a1, r3.xyzz
bcaaaaaaadaaabaeafaaaaoeaaaaaaaaadaaaakeacaaaaaa dp3 v3.x, a5, r3.xyzz
adaaaaaaaeaaamacadaaaaeeaaaaaaaabkaaaaeeabaaaaaa mul r4.zw, a3.xyxy, c26.xyxy
abaaaaaaaaaaamaeaeaaaaopacaaaaaabkaaaaoeabaaaaaa add v0.zw, r4.wwzw, c26
adaaaaaaaeaaadacadaaaaoeaaaaaaaabjaaaaoeabaaaaaa mul r4.xy, a3, c25
abaaaaaaaaaaadaeaeaaaafeacaaaaaabjaaaaooabaaaaaa add v0.xy, r4.xyyy, c25.zwzw
bdaaaaaaaaaaaiadaaaaaaoeaaaaaaaaadaaaaoeabaaaaaa dp4 o0.w, a0, c3
bdaaaaaaaaaaaeadaaaaaaoeaaaaaaaaacaaaaoeabaaaaaa dp4 o0.z, a0, c2
bdaaaaaaaaaaacadaaaaaaoeaaaaaaaaabaaaaoeabaaaaaa dp4 o0.y, a0, c1
bdaaaaaaaaaaabadaaaaaaoeaaaaaaaaaaaaaaoeabaaaaaa dp4 o0.x, a0, c0
bcaaaaaaabaaaeaeabaaaaoeaaaaaaaaaeaaaaoeabaaaaaa dp3 v1.z, a1, c4
bcaaaaaaabaaabaeafaaaaoeaaaaaaaaaeaaaaoeabaaaaaa dp3 v1.x, a5, c4
bcaaaaaaacaaaeaeabaaaaoeaaaaaaaaafaaaaoeabaaaaaa dp3 v2.z, a1, c5
bcaaaaaaacaaabaeafaaaaoeaaaaaaaaafaaaaoeabaaaaaa dp3 v2.x, a5, c5
aaaaaaaaabaaaiaeaaaaaaoeabaaaaaaaaaaaaaaaaaaaaaa mov v1.w, c0
aaaaaaaaacaaaiaeaaaaaaoeabaaaaaaaaaaaaaaaaaaaaaa mov v2.w, c0
aaaaaaaaadaaaiaeaaaaaaoeabaaaaaaaaaaaaaaaaaaaaaa mov v3.w, c0
aaaaaaaaaeaaaiaeaaaaaaoeabaaaaaaaaaaaaaaaaaaaaaa mov v4.w, c0
"
}

SubProgram "d3d11_9x " {
Keywords { "DIRECTIONAL" "LIGHTMAP_OFF" "DIRLIGHTMAP_OFF" "SHADOWS_OFF" }
Bind "vertex" Vertex
Bind "tangent" TexCoord2
Bind "normal" Normal
Bind "texcoord" TexCoord0
Bind "color" Color
ConstBuffer "$Globals" 112 // 96 used size, 7 vars
Vector 64 [_MainTex_ST] 4
Vector 80 [_BumpMap_ST] 4
ConstBuffer "UnityLighting" 400 // 400 used size, 16 vars
Vector 0 [_WorldSpaceLightPos0] 4
Vector 288 [unity_SHAr] 4
Vector 304 [unity_SHAg] 4
Vector 320 [unity_SHAb] 4
Vector 336 [unity_SHBr] 4
Vector 352 [unity_SHBg] 4
Vector 368 [unity_SHBb] 4
Vector 384 [unity_SHC] 4
ConstBuffer "UnityPerDraw" 336 // 336 used size, 6 vars
Matrix 0 [glstate_matrix_mvp] 4
Matrix 128 [glstate_matrix_invtrans_modelview0] 4
Matrix 192 [_Object2World] 4
Matrix 256 [_World2Object] 4
Vector 320 [unity_Scale] 4
BindCB "$Globals" 0
BindCB "UnityLighting" 1
BindCB "UnityPerDraw" 2
// 45 instructions, 4 temp regs, 0 temp arrays:
// ALU 24 float, 0 int, 0 uint
// TEX 0 (0 load, 0 comp, 0 bias, 0 grad)
// FLOW 1 static, 0 dynamic
"vs_4_0_level_9_3
eefiecedkeheambngmgooeefflmlphbpiccmoblfabaaaaaaoialaaaaaeaaaaaa
daaaaaaabeaeaaaagiakaaaadaalaaaaebgpgodjnmadaaaanmadaaaaaaacpopp
gaadaaaahmaaaaaaahaaceaaaaaahiaaaaaahiaaaaaaceaaabaahiaaaaaaaeaa
acaaabaaaaaaaaaaabaaaaaaabaaadaaaaaaaaaaabaabcaaahaaaeaaaaaaaaaa
acaaaaaaaeaaalaaaaaaaaaaacaaaiaaadaaapaaaaaaaaaaacaaamaaadaabcaa
aaaaaaaaacaabaaaafaabfaaaaaaaaaaaaaaaaaaabacpoppfbaaaaafbkaaapka
aaaaiadpaaaaaaaaaaaaaaaaaaaaaaaabpaaaaacafaaaaiaaaaaapjabpaaaaac
afaaabiaabaaapjabpaaaaacafaaaciaacaaapjabpaaaaacafaaadiaadaaapja
abaaaaacaaaaabiaapaaaakaabaaaaacaaaaaciabaaaaakaabaaaaacaaaaaeia
bbaaaakaaiaaaaadabaaaboaabaaoejaaaaaoeiaabaaaaacabaaahiaacaaoeja
afaaaaadacaaahiaabaanciaabaamjjaaeaaaaaeabaaahiaabaamjiaabaancja
acaaoeibafaaaaadabaaahiaabaaoeiaabaappjaaiaaaaadabaaacoaabaaoeia
aaaaoeiaaiaaaaadabaaaeoaacaaoejaaaaaoeiaabaaaaacaaaaabiaapaaffka
abaaaaacaaaaaciabaaaffkaabaaaaacaaaaaeiabbaaffkaaiaaaaadacaaaboa
abaaoejaaaaaoeiaaiaaaaadacaaacoaabaaoeiaaaaaoeiaaiaaaaadacaaaeoa
acaaoejaaaaaoeiaaeaaaaaeaaaaadoaadaaoejaabaaoekaabaaookaaeaaaaae
aaaaamoaadaaeejaacaaeekaacaaoekaabaaaaacaaaaapiaadaaoekaafaaaaad
acaaahiaaaaaffiabgaaoekaaeaaaaaeacaaahiabfaaoekaaaaaaaiaacaaoeia
aeaaaaaeaaaaahiabhaaoekaaaaakkiaacaaoeiaaeaaaaaeaaaaahiabiaaoeka
aaaappiaaaaaoeiaaiaaaaadadaaaboaabaaoejaaaaaoeiaaiaaaaadadaaacoa
abaaoeiaaaaaoeiaaiaaaaadadaaaeoaacaaoejaaaaaoeiaafaaaaadaaaaahia
acaaoejabjaappkaafaaaaadabaaahiaaaaaffiabdaaoekaaeaaaaaeaaaaalia
bcaakekaaaaaaaiaabaakeiaaeaaaaaeaaaaahiabeaaoekaaaaakkiaaaaapeia
abaaaaacaaaaaiiabkaaaakaajaaaaadabaaabiaaeaaoekaaaaaoeiaajaaaaad
abaaaciaafaaoekaaaaaoeiaajaaaaadabaaaeiaagaaoekaaaaaoeiaafaaaaad
acaaapiaaaaacjiaaaaakeiaajaaaaadadaaabiaahaaoekaacaaoeiaajaaaaad
adaaaciaaiaaoekaacaaoeiaajaaaaadadaaaeiaajaaoekaacaaoeiaacaaaaad
abaaahiaabaaoeiaadaaoeiaafaaaaadaaaaaciaaaaaffiaaaaaffiaaeaaaaae
aaaaabiaaaaaaaiaaaaaaaiaaaaaffibaeaaaaaeaeaaahoaakaaoekaaaaaaaia
abaaoeiaafaaaaadaaaaapiaaaaaffjaamaaoekaaeaaaaaeaaaaapiaalaaoeka
aaaaaajaaaaaoeiaaeaaaaaeaaaaapiaanaaoekaaaaakkjaaaaaoeiaaeaaaaae
aaaaapiaaoaaoekaaaaappjaaaaaoeiaaeaaaaaeaaaaadmaaaaappiaaaaaoeka
aaaaoeiaabaaaaacaaaaammaaaaaoeiappppaaaafdeieefcemagaaaaeaaaabaa
jdabaaaafjaaaaaeegiocaaaaaaaaaaaagaaaaaafjaaaaaeegiocaaaabaaaaaa
bjaaaaaafjaaaaaeegiocaaaacaaaaaabfaaaaaafpaaaaadpcbabaaaaaaaaaaa
fpaaaaadpcbabaaaabaaaaaafpaaaaadhcbabaaaacaaaaaafpaaaaaddcbabaaa
adaaaaaaghaaaaaepccabaaaaaaaaaaaabaaaaaagfaaaaadpccabaaaabaaaaaa
gfaaaaadhccabaaaacaaaaaagfaaaaadhccabaaaadaaaaaagfaaaaadhccabaaa
aeaaaaaagfaaaaadhccabaaaafaaaaaagiaaaaacaeaaaaaadiaaaaaipcaabaaa
aaaaaaaafgbfbaaaaaaaaaaaegiocaaaacaaaaaaabaaaaaadcaaaaakpcaabaaa
aaaaaaaaegiocaaaacaaaaaaaaaaaaaaagbabaaaaaaaaaaaegaobaaaaaaaaaaa
dcaaaaakpcaabaaaaaaaaaaaegiocaaaacaaaaaaacaaaaaakgbkbaaaaaaaaaaa
egaobaaaaaaaaaaadcaaaaakpccabaaaaaaaaaaaegiocaaaacaaaaaaadaaaaaa
pgbpbaaaaaaaaaaaegaobaaaaaaaaaaadcaaaaaldccabaaaabaaaaaaegbabaaa
adaaaaaaegiacaaaaaaaaaaaaeaaaaaaogikcaaaaaaaaaaaaeaaaaaadcaaaaal
mccabaaaabaaaaaaagbebaaaadaaaaaaagiecaaaaaaaaaaaafaaaaaakgiocaaa
aaaaaaaaafaaaaaadiaaaaahhcaabaaaaaaaaaaajgbebaaaabaaaaaacgbjbaaa
acaaaaaadcaaaaakhcaabaaaaaaaaaaajgbebaaaacaaaaaacgbjbaaaabaaaaaa
egacbaiaebaaaaaaaaaaaaaadiaaaaahhcaabaaaaaaaaaaaegacbaaaaaaaaaaa
pgbpbaaaabaaaaaadgaaaaagbcaabaaaabaaaaaaakiacaaaacaaaaaaaiaaaaaa
dgaaaaagccaabaaaabaaaaaaakiacaaaacaaaaaaajaaaaaadgaaaaagecaabaaa
abaaaaaaakiacaaaacaaaaaaakaaaaaabaaaaaahcccabaaaacaaaaaaegacbaaa
aaaaaaaaegacbaaaabaaaaaabaaaaaahbccabaaaacaaaaaaegbcbaaaabaaaaaa
egacbaaaabaaaaaabaaaaaaheccabaaaacaaaaaaegbcbaaaacaaaaaaegacbaaa
abaaaaaadgaaaaagbcaabaaaabaaaaaabkiacaaaacaaaaaaaiaaaaaadgaaaaag
ccaabaaaabaaaaaabkiacaaaacaaaaaaajaaaaaadgaaaaagecaabaaaabaaaaaa
bkiacaaaacaaaaaaakaaaaaabaaaaaahcccabaaaadaaaaaaegacbaaaaaaaaaaa
egacbaaaabaaaaaabaaaaaahbccabaaaadaaaaaaegbcbaaaabaaaaaaegacbaaa
abaaaaaabaaaaaaheccabaaaadaaaaaaegbcbaaaacaaaaaaegacbaaaabaaaaaa
diaaaaajhcaabaaaabaaaaaafgifcaaaabaaaaaaaaaaaaaaegiccaaaacaaaaaa
bbaaaaaadcaaaaalhcaabaaaabaaaaaaegiccaaaacaaaaaabaaaaaaaagiacaaa
abaaaaaaaaaaaaaaegacbaaaabaaaaaadcaaaaalhcaabaaaabaaaaaaegiccaaa
acaaaaaabcaaaaaakgikcaaaabaaaaaaaaaaaaaaegacbaaaabaaaaaadcaaaaal
hcaabaaaabaaaaaaegiccaaaacaaaaaabdaaaaaapgipcaaaabaaaaaaaaaaaaaa
egacbaaaabaaaaaabaaaaaahcccabaaaaeaaaaaaegacbaaaaaaaaaaaegacbaaa
abaaaaaabaaaaaahbccabaaaaeaaaaaaegbcbaaaabaaaaaaegacbaaaabaaaaaa
baaaaaaheccabaaaaeaaaaaaegbcbaaaacaaaaaaegacbaaaabaaaaaadiaaaaai
hcaabaaaaaaaaaaaegbcbaaaacaaaaaapgipcaaaacaaaaaabeaaaaaadiaaaaai
hcaabaaaabaaaaaafgafbaaaaaaaaaaaegiccaaaacaaaaaaanaaaaaadcaaaaak
lcaabaaaaaaaaaaaegiicaaaacaaaaaaamaaaaaaagaabaaaaaaaaaaaegaibaaa
abaaaaaadcaaaaakhcaabaaaaaaaaaaaegiccaaaacaaaaaaaoaaaaaakgakbaaa
aaaaaaaaegadbaaaaaaaaaaadgaaaaaficaabaaaaaaaaaaaabeaaaaaaaaaiadp
bbaaaaaibcaabaaaabaaaaaaegiocaaaabaaaaaabcaaaaaaegaobaaaaaaaaaaa
bbaaaaaiccaabaaaabaaaaaaegiocaaaabaaaaaabdaaaaaaegaobaaaaaaaaaaa
bbaaaaaiecaabaaaabaaaaaaegiocaaaabaaaaaabeaaaaaaegaobaaaaaaaaaaa
diaaaaahpcaabaaaacaaaaaajgacbaaaaaaaaaaaegakbaaaaaaaaaaabbaaaaai
bcaabaaaadaaaaaaegiocaaaabaaaaaabfaaaaaaegaobaaaacaaaaaabbaaaaai
ccaabaaaadaaaaaaegiocaaaabaaaaaabgaaaaaaegaobaaaacaaaaaabbaaaaai
ecaabaaaadaaaaaaegiocaaaabaaaaaabhaaaaaaegaobaaaacaaaaaaaaaaaaah
hcaabaaaabaaaaaaegacbaaaabaaaaaaegacbaaaadaaaaaadiaaaaahccaabaaa
aaaaaaaabkaabaaaaaaaaaaabkaabaaaaaaaaaaadcaaaaakbcaabaaaaaaaaaaa
akaabaaaaaaaaaaaakaabaaaaaaaaaaabkaabaiaebaaaaaaaaaaaaaadcaaaaak
hccabaaaafaaaaaaegiccaaaabaaaaaabiaaaaaaagaabaaaaaaaaaaaegacbaaa
abaaaaaadoaaaaabejfdeheomaaaaaaaagaaaaaaaiaaaaaajiaaaaaaaaaaaaaa
aaaaaaaaadaaaaaaaaaaaaaaapapaaaakbaaaaaaaaaaaaaaaaaaaaaaadaaaaaa
abaaaaaaapapaaaakjaaaaaaaaaaaaaaaaaaaaaaadaaaaaaacaaaaaaahahaaaa
laaaaaaaaaaaaaaaaaaaaaaaadaaaaaaadaaaaaaapadaaaalaaaaaaaabaaaaaa
aaaaaaaaadaaaaaaaeaaaaaaapaaaaaaljaaaaaaaaaaaaaaaaaaaaaaadaaaaaa
afaaaaaaapaaaaaafaepfdejfeejepeoaafeebeoehefeofeaaeoepfcenebemaa
feeffiedepepfceeaaedepemepfcaaklepfdeheolaaaaaaaagaaaaaaaiaaaaaa
jiaaaaaaaaaaaaaaabaaaaaaadaaaaaaaaaaaaaaapaaaaaakeaaaaaaaaaaaaaa
aaaaaaaaadaaaaaaabaaaaaaapaaaaaakeaaaaaaabaaaaaaaaaaaaaaadaaaaaa
acaaaaaaahaiaaaakeaaaaaaacaaaaaaaaaaaaaaadaaaaaaadaaaaaaahaiaaaa
keaaaaaaadaaaaaaaaaaaaaaadaaaaaaaeaaaaaaahaiaaaakeaaaaaaaeaaaaaa
aaaaaaaaadaaaaaaafaaaaaaahaiaaaafdfgfpfaepfdejfeejepeoaafeeffied
epepfceeaaklklkl"
}

SubProgram "opengl " {
Keywords { "DIRECTIONAL" "LIGHTMAP_ON" "DIRLIGHTMAP_OFF" "SHADOWS_OFF" }
Bind "vertex" Vertex
Bind "tangent" ATTR14
Bind "normal" Normal
Bind "texcoord" TexCoord0
Bind "texcoord1" TexCoord1
Vector 18 [unity_LightmapST]
Vector 19 [_MainTex_ST]
Vector 20 [_BumpMap_ST]
"!!ARBvp1.0
# 17 ALU
PARAM c[21] = { program.local[0],
		state.matrix.mvp,
		state.matrix.modelview[0].invtrans,
		program.local[9..20] };
TEMP R0;
TEMP R1;
MOV R0.xyz, vertex.attrib[14];
MUL R1.xyz, vertex.normal.zxyw, R0.yzxw;
MAD R0.xyz, vertex.normal.yzxw, R0.zxyw, -R1;
MUL R0.xyz, R0, vertex.attrib[14].w;
DP3 result.texcoord[1].y, R0, c[5];
DP3 result.texcoord[2].y, R0, c[6];
MAD result.texcoord[0].zw, vertex.texcoord[0].xyxy, c[20].xyxy, c[20];
MAD result.texcoord[0].xy, vertex.texcoord[0], c[19], c[19].zwzw;
MAD result.texcoord[3].xy, vertex.texcoord[1], c[18], c[18].zwzw;
DP4 result.position.w, vertex.position, c[4];
DP4 result.position.z, vertex.position, c[3];
DP4 result.position.y, vertex.position, c[2];
DP4 result.position.x, vertex.position, c[1];
DP3 result.texcoord[1].z, vertex.normal, c[5];
DP3 result.texcoord[1].x, vertex.attrib[14], c[5];
DP3 result.texcoord[2].z, vertex.normal, c[6];
DP3 result.texcoord[2].x, vertex.attrib[14], c[6];
END
# 17 instructions, 2 R-regs
"
}

SubProgram "d3d9 " {
Keywords { "DIRECTIONAL" "LIGHTMAP_ON" "DIRLIGHTMAP_OFF" "SHADOWS_OFF" }
Bind "vertex" Vertex
Bind "tangent" TexCoord2
Bind "normal" Normal
Bind "texcoord" TexCoord0
Bind "texcoord1" TexCoord1
Matrix 0 [glstate_matrix_mvp]
Matrix 4 [glstate_matrix_invtrans_modelview0]
Vector 16 [unity_LightmapST]
Vector 17 [_MainTex_ST]
Vector 18 [_BumpMap_ST]
"vs_2_0
; 18 ALU
dcl_position0 v0
dcl_tangent0 v1
dcl_normal0 v2
dcl_texcoord0 v3
dcl_texcoord1 v4
mov r0.xyz, v1
mul r1.xyz, v2.zxyw, r0.yzxw
mov r0.xyz, v1
mad r0.xyz, v2.yzxw, r0.zxyw, -r1
mul r0.xyz, r0, v1.w
dp3 oT1.y, r0, c4
dp3 oT2.y, r0, c5
mad oT0.zw, v3.xyxy, c18.xyxy, c18
mad oT0.xy, v3, c17, c17.zwzw
mad oT3.xy, v4, c16, c16.zwzw
dp4 oPos.w, v0, c3
dp4 oPos.z, v0, c2
dp4 oPos.y, v0, c1
dp4 oPos.x, v0, c0
dp3 oT1.z, v2, c4
dp3 oT1.x, v1, c4
dp3 oT2.z, v2, c5
dp3 oT2.x, v1, c5
"
}

SubProgram "d3d11 " {
Keywords { "DIRECTIONAL" "LIGHTMAP_ON" "DIRLIGHTMAP_OFF" "SHADOWS_OFF" }
Bind "vertex" Vertex
Bind "tangent" TexCoord2
Bind "normal" Normal
Bind "texcoord" TexCoord0
Bind "texcoord1" TexCoord1
Bind "color" Color
ConstBuffer "$Globals" 128 // 112 used size, 8 vars
Vector 64 [unity_LightmapST] 4
Vector 80 [_MainTex_ST] 4
Vector 96 [_BumpMap_ST] 4
ConstBuffer "UnityPerDraw" 336 // 192 used size, 6 vars
Matrix 0 [glstate_matrix_mvp] 4
Matrix 128 [glstate_matrix_invtrans_modelview0] 4
BindCB "$Globals" 0
BindCB "UnityPerDraw" 1
// 23 instructions, 2 temp regs, 0 temp arrays:
// ALU 9 float, 0 int, 0 uint
// TEX 0 (0 load, 0 comp, 0 bias, 0 grad)
// FLOW 1 static, 0 dynamic
"vs_4_0
eefiecedjcmhbpgolefibdolpombohepcodhbiejabaaaaaaaaafaaaaadaaaaaa
cmaaaaaapeaaaaaajeabaaaaejfdeheomaaaaaaaagaaaaaaaiaaaaaajiaaaaaa
aaaaaaaaaaaaaaaaadaaaaaaaaaaaaaaapapaaaakbaaaaaaaaaaaaaaaaaaaaaa
adaaaaaaabaaaaaaapapaaaakjaaaaaaaaaaaaaaaaaaaaaaadaaaaaaacaaaaaa
ahahaaaalaaaaaaaaaaaaaaaaaaaaaaaadaaaaaaadaaaaaaapadaaaalaaaaaaa
abaaaaaaaaaaaaaaadaaaaaaaeaaaaaaapadaaaaljaaaaaaaaaaaaaaaaaaaaaa
adaaaaaaafaaaaaaapaaaaaafaepfdejfeejepeoaafeebeoehefeofeaaeoepfc
enebemaafeeffiedepepfceeaaedepemepfcaaklepfdeheojiaaaaaaafaaaaaa
aiaaaaaaiaaaaaaaaaaaaaaaabaaaaaaadaaaaaaaaaaaaaaapaaaaaaimaaaaaa
aaaaaaaaaaaaaaaaadaaaaaaabaaaaaaapaaaaaaimaaaaaaabaaaaaaaaaaaaaa
adaaaaaaacaaaaaaahaiaaaaimaaaaaaacaaaaaaaaaaaaaaadaaaaaaadaaaaaa
ahaiaaaaimaaaaaaadaaaaaaaaaaaaaaadaaaaaaaeaaaaaaadamaaaafdfgfpfa
epfdejfeejepeoaafeeffiedepepfceeaaklklklfdeieefcgeadaaaaeaaaabaa
njaaaaaafjaaaaaeegiocaaaaaaaaaaaahaaaaaafjaaaaaeegiocaaaabaaaaaa
alaaaaaafpaaaaadpcbabaaaaaaaaaaafpaaaaadpcbabaaaabaaaaaafpaaaaad
hcbabaaaacaaaaaafpaaaaaddcbabaaaadaaaaaafpaaaaaddcbabaaaaeaaaaaa
ghaaaaaepccabaaaaaaaaaaaabaaaaaagfaaaaadpccabaaaabaaaaaagfaaaaad
hccabaaaacaaaaaagfaaaaadhccabaaaadaaaaaagfaaaaaddccabaaaaeaaaaaa
giaaaaacacaaaaaadiaaaaaipcaabaaaaaaaaaaafgbfbaaaaaaaaaaaegiocaaa
abaaaaaaabaaaaaadcaaaaakpcaabaaaaaaaaaaaegiocaaaabaaaaaaaaaaaaaa
agbabaaaaaaaaaaaegaobaaaaaaaaaaadcaaaaakpcaabaaaaaaaaaaaegiocaaa
abaaaaaaacaaaaaakgbkbaaaaaaaaaaaegaobaaaaaaaaaaadcaaaaakpccabaaa
aaaaaaaaegiocaaaabaaaaaaadaaaaaapgbpbaaaaaaaaaaaegaobaaaaaaaaaaa
dcaaaaaldccabaaaabaaaaaaegbabaaaadaaaaaaegiacaaaaaaaaaaaafaaaaaa
ogikcaaaaaaaaaaaafaaaaaadcaaaaalmccabaaaabaaaaaaagbebaaaadaaaaaa
agiecaaaaaaaaaaaagaaaaaakgiocaaaaaaaaaaaagaaaaaadiaaaaahhcaabaaa
aaaaaaaajgbebaaaabaaaaaacgbjbaaaacaaaaaadcaaaaakhcaabaaaaaaaaaaa
jgbebaaaacaaaaaacgbjbaaaabaaaaaaegacbaiaebaaaaaaaaaaaaaadiaaaaah
hcaabaaaaaaaaaaaegacbaaaaaaaaaaapgbpbaaaabaaaaaadgaaaaagbcaabaaa
abaaaaaaakiacaaaabaaaaaaaiaaaaaadgaaaaagccaabaaaabaaaaaaakiacaaa
abaaaaaaajaaaaaadgaaaaagecaabaaaabaaaaaaakiacaaaabaaaaaaakaaaaaa
baaaaaahcccabaaaacaaaaaaegacbaaaaaaaaaaaegacbaaaabaaaaaabaaaaaah
bccabaaaacaaaaaaegbcbaaaabaaaaaaegacbaaaabaaaaaabaaaaaaheccabaaa
acaaaaaaegbcbaaaacaaaaaaegacbaaaabaaaaaadgaaaaagbcaabaaaabaaaaaa
bkiacaaaabaaaaaaaiaaaaaadgaaaaagccaabaaaabaaaaaabkiacaaaabaaaaaa
ajaaaaaadgaaaaagecaabaaaabaaaaaabkiacaaaabaaaaaaakaaaaaabaaaaaah
cccabaaaadaaaaaaegacbaaaaaaaaaaaegacbaaaabaaaaaabaaaaaahbccabaaa
adaaaaaaegbcbaaaabaaaaaaegacbaaaabaaaaaabaaaaaaheccabaaaadaaaaaa
egbcbaaaacaaaaaaegacbaaaabaaaaaadcaaaaaldccabaaaaeaaaaaaegbabaaa
aeaaaaaaegiacaaaaaaaaaaaaeaaaaaaogikcaaaaaaaaaaaaeaaaaaadoaaaaab
"
}

SubProgram "gles " {
Keywords { "DIRECTIONAL" "LIGHTMAP_ON" "DIRLIGHTMAP_OFF" "SHADOWS_OFF" }
"!!GLES
#define SHADER_API_GLES 1
#define tex2D texture2D


#ifdef VERTEX
#define gl_ModelViewProjectionMatrix glstate_matrix_mvp
uniform mat4 glstate_matrix_mvp;
#define gl_ModelViewMatrixInverseTranspose glstate_matrix_invtrans_modelview0
uniform mat4 glstate_matrix_invtrans_modelview0;
#define gl_ModelViewMatrix glstate_matrix_modelview0
uniform mat4 glstate_matrix_modelview0;

varying highp vec2 xlv_TEXCOORD3;
varying highp vec3 xlv_TEXCOORD2;
varying highp vec3 xlv_TEXCOORD1;
varying highp vec4 xlv_TEXCOORD0;
uniform highp vec4 _BumpMap_ST;
uniform highp vec4 _MainTex_ST;
uniform highp vec4 unity_LightmapST;


attribute vec4 _glesTANGENT;
attribute vec4 _glesMultiTexCoord1;
attribute vec4 _glesMultiTexCoord0;
attribute vec3 _glesNormal;
attribute vec4 _glesVertex;
void main ()
{
  vec4 tmpvar_1;
  tmpvar_1.xyz = normalize(_glesTANGENT.xyz);
  tmpvar_1.w = _glesTANGENT.w;
  vec3 tmpvar_2;
  tmpvar_2 = normalize(_glesNormal);
  highp vec4 tmpvar_3;
  highp vec3 tmpvar_4;
  highp vec3 tmpvar_5;
  tmpvar_4 = tmpvar_1.xyz;
  tmpvar_5 = (((tmpvar_2.yzx * tmpvar_1.zxy) - (tmpvar_2.zxy * tmpvar_1.yzx)) * _glesTANGENT.w);
  highp mat3 tmpvar_6;
  tmpvar_6[0].x = tmpvar_4.x;
  tmpvar_6[0].y = tmpvar_5.x;
  tmpvar_6[0].z = tmpvar_2.x;
  tmpvar_6[1].x = tmpvar_4.y;
  tmpvar_6[1].y = tmpvar_5.y;
  tmpvar_6[1].z = tmpvar_2.y;
  tmpvar_6[2].x = tmpvar_4.z;
  tmpvar_6[2].y = tmpvar_5.z;
  tmpvar_6[2].z = tmpvar_2.z;
  vec4 v_7;
  v_7.x = gl_ModelViewMatrixInverseTranspose[0].x;
  v_7.y = gl_ModelViewMatrixInverseTranspose[1].x;
  v_7.z = gl_ModelViewMatrixInverseTranspose[2].x;
  v_7.w = gl_ModelViewMatrixInverseTranspose[3].x;
  vec4 v_8;
  v_8.x = gl_ModelViewMatrixInverseTranspose[0].y;
  v_8.y = gl_ModelViewMatrixInverseTranspose[1].y;
  v_8.z = gl_ModelViewMatrixInverseTranspose[2].y;
  v_8.w = gl_ModelViewMatrixInverseTranspose[3].y;
  tmpvar_3.xy = ((_glesMultiTexCoord0.xy * _MainTex_ST.xy) + _MainTex_ST.zw);
  tmpvar_3.zw = ((_glesMultiTexCoord0.xy * _BumpMap_ST.xy) + _BumpMap_ST.zw);
  gl_Position = (gl_ModelViewProjectionMatrix * _glesVertex);
  xlv_TEXCOORD0 = tmpvar_3;
  xlv_TEXCOORD1 = (tmpvar_6 * v_7.xyz);
  xlv_TEXCOORD2 = (tmpvar_6 * v_8.xyz);
  xlv_TEXCOORD3 = ((_glesMultiTexCoord1.xy * unity_LightmapST.xy) + unity_LightmapST.zw);
}



#endif
#ifdef FRAGMENT

varying highp vec2 xlv_TEXCOORD3;
varying highp vec3 xlv_TEXCOORD2;
varying highp vec3 xlv_TEXCOORD1;
varying highp vec4 xlv_TEXCOORD0;
uniform lowp float _Cutoff;
uniform sampler2D unity_Lightmap;
uniform sampler2D _Shade;
uniform sampler2D _BumpMap;
uniform sampler2D _MainTex;
uniform lowp vec4 _Color;
void main ()
{
  lowp vec4 c_1;
  lowp vec3 tmpvar_2;
  highp vec3 matcap_3;
  lowp vec3 tmpvar_4;
  tmpvar_4 = ((texture2D (_BumpMap, xlv_TEXCOORD0.zw).xyz * 2.0) - 1.0);
  highp vec2 tmpvar_5;
  tmpvar_5.x = dot (xlv_TEXCOORD1, tmpvar_4);
  tmpvar_5.y = dot (xlv_TEXCOORD2, tmpvar_4);
  highp vec2 P_6;
  P_6 = ((tmpvar_5 * 0.5) + 0.5);
  lowp vec3 tmpvar_7;
  tmpvar_7 = texture2D (_Shade, P_6).xyz;
  matcap_3 = tmpvar_7;
  lowp vec4 tmpvar_8;
  tmpvar_8 = texture2D (_MainTex, xlv_TEXCOORD0.xy);
  highp vec3 tmpvar_9;
  tmpvar_9 = (((matcap_3 * tmpvar_8.xyz) * _Color.xyz) * 3.0);
  tmpvar_2 = tmpvar_9;
  lowp vec4 tmpvar_10;
  tmpvar_10 = texture2D (_MainTex, xlv_TEXCOORD0.xy);
  lowp float tmpvar_11;
  tmpvar_11 = tmpvar_10.w;
  lowp float x_12;
  x_12 = (tmpvar_10.w - _Cutoff);
  if ((x_12 < 0.0)) {
    discard;
  };
  c_1.xyz = ((texture2D (_MainTex, xlv_TEXCOORD0.xy).xyz * _Color.w) * (2.0 * texture2D (unity_Lightmap, xlv_TEXCOORD3).xyz));
  c_1.w = tmpvar_11;
  c_1.xyz = (c_1.xyz + tmpvar_2);
  c_1.w = tmpvar_11;
  gl_FragData[0] = c_1;
}



#endif"
}

SubProgram "glesdesktop " {
Keywords { "DIRECTIONAL" "LIGHTMAP_ON" "DIRLIGHTMAP_OFF" "SHADOWS_OFF" }
"!!GLES
#define SHADER_API_GLES 1
#define tex2D texture2D


#ifdef VERTEX
#define gl_ModelViewProjectionMatrix glstate_matrix_mvp
uniform mat4 glstate_matrix_mvp;
#define gl_ModelViewMatrixInverseTranspose glstate_matrix_invtrans_modelview0
uniform mat4 glstate_matrix_invtrans_modelview0;
#define gl_ModelViewMatrix glstate_matrix_modelview0
uniform mat4 glstate_matrix_modelview0;

varying highp vec2 xlv_TEXCOORD3;
varying highp vec3 xlv_TEXCOORD2;
varying highp vec3 xlv_TEXCOORD1;
varying highp vec4 xlv_TEXCOORD0;
uniform highp vec4 _BumpMap_ST;
uniform highp vec4 _MainTex_ST;
uniform highp vec4 unity_LightmapST;


attribute vec4 _glesTANGENT;
attribute vec4 _glesMultiTexCoord1;
attribute vec4 _glesMultiTexCoord0;
attribute vec3 _glesNormal;
attribute vec4 _glesVertex;
void main ()
{
  vec4 tmpvar_1;
  tmpvar_1.xyz = normalize(_glesTANGENT.xyz);
  tmpvar_1.w = _glesTANGENT.w;
  vec3 tmpvar_2;
  tmpvar_2 = normalize(_glesNormal);
  highp vec4 tmpvar_3;
  highp vec3 tmpvar_4;
  highp vec3 tmpvar_5;
  tmpvar_4 = tmpvar_1.xyz;
  tmpvar_5 = (((tmpvar_2.yzx * tmpvar_1.zxy) - (tmpvar_2.zxy * tmpvar_1.yzx)) * _glesTANGENT.w);
  highp mat3 tmpvar_6;
  tmpvar_6[0].x = tmpvar_4.x;
  tmpvar_6[0].y = tmpvar_5.x;
  tmpvar_6[0].z = tmpvar_2.x;
  tmpvar_6[1].x = tmpvar_4.y;
  tmpvar_6[1].y = tmpvar_5.y;
  tmpvar_6[1].z = tmpvar_2.y;
  tmpvar_6[2].x = tmpvar_4.z;
  tmpvar_6[2].y = tmpvar_5.z;
  tmpvar_6[2].z = tmpvar_2.z;
  vec4 v_7;
  v_7.x = gl_ModelViewMatrixInverseTranspose[0].x;
  v_7.y = gl_ModelViewMatrixInverseTranspose[1].x;
  v_7.z = gl_ModelViewMatrixInverseTranspose[2].x;
  v_7.w = gl_ModelViewMatrixInverseTranspose[3].x;
  vec4 v_8;
  v_8.x = gl_ModelViewMatrixInverseTranspose[0].y;
  v_8.y = gl_ModelViewMatrixInverseTranspose[1].y;
  v_8.z = gl_ModelViewMatrixInverseTranspose[2].y;
  v_8.w = gl_ModelViewMatrixInverseTranspose[3].y;
  tmpvar_3.xy = ((_glesMultiTexCoord0.xy * _MainTex_ST.xy) + _MainTex_ST.zw);
  tmpvar_3.zw = ((_glesMultiTexCoord0.xy * _BumpMap_ST.xy) + _BumpMap_ST.zw);
  gl_Position = (gl_ModelViewProjectionMatrix * _glesVertex);
  xlv_TEXCOORD0 = tmpvar_3;
  xlv_TEXCOORD1 = (tmpvar_6 * v_7.xyz);
  xlv_TEXCOORD2 = (tmpvar_6 * v_8.xyz);
  xlv_TEXCOORD3 = ((_glesMultiTexCoord1.xy * unity_LightmapST.xy) + unity_LightmapST.zw);
}



#endif
#ifdef FRAGMENT

varying highp vec2 xlv_TEXCOORD3;
varying highp vec3 xlv_TEXCOORD2;
varying highp vec3 xlv_TEXCOORD1;
varying highp vec4 xlv_TEXCOORD0;
uniform lowp float _Cutoff;
uniform sampler2D unity_Lightmap;
uniform sampler2D _Shade;
uniform sampler2D _BumpMap;
uniform sampler2D _MainTex;
uniform lowp vec4 _Color;
void main ()
{
  lowp vec4 c_1;
  lowp vec3 tmpvar_2;
  highp vec3 matcap_3;
  lowp vec3 normal_4;
  normal_4.xy = ((texture2D (_BumpMap, xlv_TEXCOORD0.zw).wy * 2.0) - 1.0);
  normal_4.z = sqrt(((1.0 - (normal_4.x * normal_4.x)) - (normal_4.y * normal_4.y)));
  highp vec2 tmpvar_5;
  tmpvar_5.x = dot (xlv_TEXCOORD1, normal_4);
  tmpvar_5.y = dot (xlv_TEXCOORD2, normal_4);
  highp vec2 P_6;
  P_6 = ((tmpvar_5 * 0.5) + 0.5);
  lowp vec3 tmpvar_7;
  tmpvar_7 = texture2D (_Shade, P_6).xyz;
  matcap_3 = tmpvar_7;
  lowp vec4 tmpvar_8;
  tmpvar_8 = texture2D (_MainTex, xlv_TEXCOORD0.xy);
  highp vec3 tmpvar_9;
  tmpvar_9 = (((matcap_3 * tmpvar_8.xyz) * _Color.xyz) * 3.0);
  tmpvar_2 = tmpvar_9;
  lowp vec4 tmpvar_10;
  tmpvar_10 = texture2D (_MainTex, xlv_TEXCOORD0.xy);
  lowp float tmpvar_11;
  tmpvar_11 = tmpvar_10.w;
  lowp float x_12;
  x_12 = (tmpvar_10.w - _Cutoff);
  if ((x_12 < 0.0)) {
    discard;
  };
  lowp vec4 tmpvar_13;
  tmpvar_13 = texture2D (unity_Lightmap, xlv_TEXCOORD3);
  c_1.xyz = ((texture2D (_MainTex, xlv_TEXCOORD0.xy).xyz * _Color.w) * ((8.0 * tmpvar_13.w) * tmpvar_13.xyz));
  c_1.w = tmpvar_11;
  c_1.xyz = (c_1.xyz + tmpvar_2);
  c_1.w = tmpvar_11;
  gl_FragData[0] = c_1;
}



#endif"
}

SubProgram "flash " {
Keywords { "DIRECTIONAL" "LIGHTMAP_ON" "DIRLIGHTMAP_OFF" "SHADOWS_OFF" }
Bind "vertex" Vertex
Bind "tangent" TexCoord2
Bind "normal" Normal
Bind "texcoord" TexCoord0
Bind "texcoord1" TexCoord1
Matrix 0 [glstate_matrix_mvp]
Matrix 4 [glstate_matrix_invtrans_modelview0]
Vector 16 [unity_LightmapST]
Vector 17 [_MainTex_ST]
Vector 18 [_BumpMap_ST]
"agal_vs
[bc]
aaaaaaaaaaaaahacafaaaaoeaaaaaaaaaaaaaaaaaaaaaaaa mov r0.xyz, a5
adaaaaaaabaaahacabaaaancaaaaaaaaaaaaaaajacaaaaaa mul r1.xyz, a1.zxyw, r0.yzxx
aaaaaaaaaaaaahacafaaaaoeaaaaaaaaaaaaaaaaaaaaaaaa mov r0.xyz, a5
adaaaaaaacaaahacabaaaamjaaaaaaaaaaaaaafcacaaaaaa mul r2.xyz, a1.yzxw, r0.zxyy
acaaaaaaaaaaahacacaaaakeacaaaaaaabaaaakeacaaaaaa sub r0.xyz, r2.xyzz, r1.xyzz
adaaaaaaaaaaahacaaaaaakeacaaaaaaafaaaappaaaaaaaa mul r0.xyz, r0.xyzz, a5.w
bcaaaaaaabaaacaeaaaaaakeacaaaaaaaeaaaaoeabaaaaaa dp3 v1.y, r0.xyzz, c4
bcaaaaaaacaaacaeaaaaaakeacaaaaaaafaaaaoeabaaaaaa dp3 v2.y, r0.xyzz, c5
adaaaaaaacaaamacadaaaaeeaaaaaaaabcaaaaeeabaaaaaa mul r2.zw, a3.xyxy, c18.xyxy
abaaaaaaaaaaamaeacaaaaopacaaaaaabcaaaaoeabaaaaaa add v0.zw, r2.wwzw, c18
adaaaaaaacaaadacadaaaaoeaaaaaaaabbaaaaoeabaaaaaa mul r2.xy, a3, c17
abaaaaaaaaaaadaeacaaaafeacaaaaaabbaaaaooabaaaaaa add v0.xy, r2.xyyy, c17.zwzw
adaaaaaaacaaadacaeaaaaoeaaaaaaaabaaaaaoeabaaaaaa mul r2.xy, a4, c16
abaaaaaaadaaadaeacaaaafeacaaaaaabaaaaaooabaaaaaa add v3.xy, r2.xyyy, c16.zwzw
bdaaaaaaaaaaaiadaaaaaaoeaaaaaaaaadaaaaoeabaaaaaa dp4 o0.w, a0, c3
bdaaaaaaaaaaaeadaaaaaaoeaaaaaaaaacaaaaoeabaaaaaa dp4 o0.z, a0, c2
bdaaaaaaaaaaacadaaaaaaoeaaaaaaaaabaaaaoeabaaaaaa dp4 o0.y, a0, c1
bdaaaaaaaaaaabadaaaaaaoeaaaaaaaaaaaaaaoeabaaaaaa dp4 o0.x, a0, c0
bcaaaaaaabaaaeaeabaaaaoeaaaaaaaaaeaaaaoeabaaaaaa dp3 v1.z, a1, c4
bcaaaaaaabaaabaeafaaaaoeaaaaaaaaaeaaaaoeabaaaaaa dp3 v1.x, a5, c4
bcaaaaaaacaaaeaeabaaaaoeaaaaaaaaafaaaaoeabaaaaaa dp3 v2.z, a1, c5
bcaaaaaaacaaabaeafaaaaoeaaaaaaaaafaaaaoeabaaaaaa dp3 v2.x, a5, c5
aaaaaaaaabaaaiaeaaaaaaoeabaaaaaaaaaaaaaaaaaaaaaa mov v1.w, c0
aaaaaaaaacaaaiaeaaaaaaoeabaaaaaaaaaaaaaaaaaaaaaa mov v2.w, c0
aaaaaaaaadaaamaeaaaaaaoeabaaaaaaaaaaaaaaaaaaaaaa mov v3.zw, c0
"
}

SubProgram "d3d11_9x " {
Keywords { "DIRECTIONAL" "LIGHTMAP_ON" "DIRLIGHTMAP_OFF" "SHADOWS_OFF" }
Bind "vertex" Vertex
Bind "tangent" TexCoord2
Bind "normal" Normal
Bind "texcoord" TexCoord0
Bind "texcoord1" TexCoord1
Bind "color" Color
ConstBuffer "$Globals" 128 // 112 used size, 8 vars
Vector 64 [unity_LightmapST] 4
Vector 80 [_MainTex_ST] 4
Vector 96 [_BumpMap_ST] 4
ConstBuffer "UnityPerDraw" 336 // 192 used size, 6 vars
Matrix 0 [glstate_matrix_mvp] 4
Matrix 128 [glstate_matrix_invtrans_modelview0] 4
BindCB "$Globals" 0
BindCB "UnityPerDraw" 1
// 23 instructions, 2 temp regs, 0 temp arrays:
// ALU 9 float, 0 int, 0 uint
// TEX 0 (0 load, 0 comp, 0 bias, 0 grad)
// FLOW 1 static, 0 dynamic
"vs_4_0_level_9_3
eefiecedckkidooepkjagehkchljchpbmdojjchlabaaaaaacmahaaaaaeaaaaaa
daaaaaaafiacaaaameafaaaaimagaaaaebgpgodjcaacaaaacaacaaaaaaacpopp
neabaaaaemaaaaaaadaaceaaaaaaeiaaaaaaeiaaaaaaceaaabaaeiaaaaaaaeaa
adaaabaaaaaaaaaaabaaaaaaaeaaaeaaaaaaaaaaabaaaiaaadaaaiaaaaaaaaaa
aaaaaaaaabacpoppbpaaaaacafaaaaiaaaaaapjabpaaaaacafaaabiaabaaapja
bpaaaaacafaaaciaacaaapjabpaaaaacafaaadiaadaaapjabpaaaaacafaaaeia
aeaaapjaabaaaaacaaaaabiaaiaaaakaabaaaaacaaaaaciaajaaaakaabaaaaac
aaaaaeiaakaaaakaaiaaaaadabaaaboaabaaoejaaaaaoeiaabaaaaacabaaahia
abaaoejaafaaaaadacaaahiaabaamjiaacaancjaaeaaaaaeabaaahiaacaamjja
abaanciaacaaoeibafaaaaadabaaahiaabaaoeiaabaappjaaiaaaaadabaaacoa
abaaoeiaaaaaoeiaaiaaaaadabaaaeoaacaaoejaaaaaoeiaabaaaaacaaaaabia
aiaaffkaabaaaaacaaaaaciaajaaffkaabaaaaacaaaaaeiaakaaffkaaiaaaaad
acaaaboaabaaoejaaaaaoeiaaiaaaaadacaaacoaabaaoeiaaaaaoeiaaiaaaaad
acaaaeoaacaaoejaaaaaoeiaaeaaaaaeaaaaadoaadaaoejaacaaoekaacaaooka
aeaaaaaeaaaaamoaadaaeejaadaaeekaadaaoekaaeaaaaaeadaaadoaaeaaoeja
abaaoekaabaaookaafaaaaadaaaaapiaaaaaffjaafaaoekaaeaaaaaeaaaaapia
aeaaoekaaaaaaajaaaaaoeiaaeaaaaaeaaaaapiaagaaoekaaaaakkjaaaaaoeia
aeaaaaaeaaaaapiaahaaoekaaaaappjaaaaaoeiaaeaaaaaeaaaaadmaaaaappia
aaaaoekaaaaaoeiaabaaaaacaaaaammaaaaaoeiappppaaaafdeieefcgeadaaaa
eaaaabaanjaaaaaafjaaaaaeegiocaaaaaaaaaaaahaaaaaafjaaaaaeegiocaaa
abaaaaaaalaaaaaafpaaaaadpcbabaaaaaaaaaaafpaaaaadpcbabaaaabaaaaaa
fpaaaaadhcbabaaaacaaaaaafpaaaaaddcbabaaaadaaaaaafpaaaaaddcbabaaa
aeaaaaaaghaaaaaepccabaaaaaaaaaaaabaaaaaagfaaaaadpccabaaaabaaaaaa
gfaaaaadhccabaaaacaaaaaagfaaaaadhccabaaaadaaaaaagfaaaaaddccabaaa
aeaaaaaagiaaaaacacaaaaaadiaaaaaipcaabaaaaaaaaaaafgbfbaaaaaaaaaaa
egiocaaaabaaaaaaabaaaaaadcaaaaakpcaabaaaaaaaaaaaegiocaaaabaaaaaa
aaaaaaaaagbabaaaaaaaaaaaegaobaaaaaaaaaaadcaaaaakpcaabaaaaaaaaaaa
egiocaaaabaaaaaaacaaaaaakgbkbaaaaaaaaaaaegaobaaaaaaaaaaadcaaaaak
pccabaaaaaaaaaaaegiocaaaabaaaaaaadaaaaaapgbpbaaaaaaaaaaaegaobaaa
aaaaaaaadcaaaaaldccabaaaabaaaaaaegbabaaaadaaaaaaegiacaaaaaaaaaaa
afaaaaaaogikcaaaaaaaaaaaafaaaaaadcaaaaalmccabaaaabaaaaaaagbebaaa
adaaaaaaagiecaaaaaaaaaaaagaaaaaakgiocaaaaaaaaaaaagaaaaaadiaaaaah
hcaabaaaaaaaaaaajgbebaaaabaaaaaacgbjbaaaacaaaaaadcaaaaakhcaabaaa
aaaaaaaajgbebaaaacaaaaaacgbjbaaaabaaaaaaegacbaiaebaaaaaaaaaaaaaa
diaaaaahhcaabaaaaaaaaaaaegacbaaaaaaaaaaapgbpbaaaabaaaaaadgaaaaag
bcaabaaaabaaaaaaakiacaaaabaaaaaaaiaaaaaadgaaaaagccaabaaaabaaaaaa
akiacaaaabaaaaaaajaaaaaadgaaaaagecaabaaaabaaaaaaakiacaaaabaaaaaa
akaaaaaabaaaaaahcccabaaaacaaaaaaegacbaaaaaaaaaaaegacbaaaabaaaaaa
baaaaaahbccabaaaacaaaaaaegbcbaaaabaaaaaaegacbaaaabaaaaaabaaaaaah
eccabaaaacaaaaaaegbcbaaaacaaaaaaegacbaaaabaaaaaadgaaaaagbcaabaaa
abaaaaaabkiacaaaabaaaaaaaiaaaaaadgaaaaagccaabaaaabaaaaaabkiacaaa
abaaaaaaajaaaaaadgaaaaagecaabaaaabaaaaaabkiacaaaabaaaaaaakaaaaaa
baaaaaahcccabaaaadaaaaaaegacbaaaaaaaaaaaegacbaaaabaaaaaabaaaaaah
bccabaaaadaaaaaaegbcbaaaabaaaaaaegacbaaaabaaaaaabaaaaaaheccabaaa
adaaaaaaegbcbaaaacaaaaaaegacbaaaabaaaaaadcaaaaaldccabaaaaeaaaaaa
egbabaaaaeaaaaaaegiacaaaaaaaaaaaaeaaaaaaogikcaaaaaaaaaaaaeaaaaaa
doaaaaabejfdeheomaaaaaaaagaaaaaaaiaaaaaajiaaaaaaaaaaaaaaaaaaaaaa
adaaaaaaaaaaaaaaapapaaaakbaaaaaaaaaaaaaaaaaaaaaaadaaaaaaabaaaaaa
apapaaaakjaaaaaaaaaaaaaaaaaaaaaaadaaaaaaacaaaaaaahahaaaalaaaaaaa
aaaaaaaaaaaaaaaaadaaaaaaadaaaaaaapadaaaalaaaaaaaabaaaaaaaaaaaaaa
adaaaaaaaeaaaaaaapadaaaaljaaaaaaaaaaaaaaaaaaaaaaadaaaaaaafaaaaaa
apaaaaaafaepfdejfeejepeoaafeebeoehefeofeaaeoepfcenebemaafeeffied
epepfceeaaedepemepfcaaklepfdeheojiaaaaaaafaaaaaaaiaaaaaaiaaaaaaa
aaaaaaaaabaaaaaaadaaaaaaaaaaaaaaapaaaaaaimaaaaaaaaaaaaaaaaaaaaaa
adaaaaaaabaaaaaaapaaaaaaimaaaaaaabaaaaaaaaaaaaaaadaaaaaaacaaaaaa
ahaiaaaaimaaaaaaacaaaaaaaaaaaaaaadaaaaaaadaaaaaaahaiaaaaimaaaaaa
adaaaaaaaaaaaaaaadaaaaaaaeaaaaaaadamaaaafdfgfpfaepfdejfeejepeoaa
feeffiedepepfceeaaklklkl"
}

SubProgram "opengl " {
Keywords { "DIRECTIONAL" "LIGHTMAP_ON" "DIRLIGHTMAP_ON" "SHADOWS_OFF" }
Bind "vertex" Vertex
Bind "tangent" ATTR14
Bind "normal" Normal
Bind "texcoord" TexCoord0
Bind "texcoord1" TexCoord1
Vector 18 [unity_LightmapST]
Vector 19 [_MainTex_ST]
Vector 20 [_BumpMap_ST]
"!!ARBvp1.0
# 17 ALU
PARAM c[21] = { program.local[0],
		state.matrix.mvp,
		state.matrix.modelview[0].invtrans,
		program.local[9..20] };
TEMP R0;
TEMP R1;
MOV R0.xyz, vertex.attrib[14];
MUL R1.xyz, vertex.normal.zxyw, R0.yzxw;
MAD R0.xyz, vertex.normal.yzxw, R0.zxyw, -R1;
MUL R0.xyz, R0, vertex.attrib[14].w;
DP3 result.texcoord[1].y, R0, c[5];
DP3 result.texcoord[2].y, R0, c[6];
MAD result.texcoord[0].zw, vertex.texcoord[0].xyxy, c[20].xyxy, c[20];
MAD result.texcoord[0].xy, vertex.texcoord[0], c[19], c[19].zwzw;
MAD result.texcoord[3].xy, vertex.texcoord[1], c[18], c[18].zwzw;
DP4 result.position.w, vertex.position, c[4];
DP4 result.position.z, vertex.position, c[3];
DP4 result.position.y, vertex.position, c[2];
DP4 result.position.x, vertex.position, c[1];
DP3 result.texcoord[1].z, vertex.normal, c[5];
DP3 result.texcoord[1].x, vertex.attrib[14], c[5];
DP3 result.texcoord[2].z, vertex.normal, c[6];
DP3 result.texcoord[2].x, vertex.attrib[14], c[6];
END
# 17 instructions, 2 R-regs
"
}

SubProgram "d3d9 " {
Keywords { "DIRECTIONAL" "LIGHTMAP_ON" "DIRLIGHTMAP_ON" "SHADOWS_OFF" }
Bind "vertex" Vertex
Bind "tangent" TexCoord2
Bind "normal" Normal
Bind "texcoord" TexCoord0
Bind "texcoord1" TexCoord1
Matrix 0 [glstate_matrix_mvp]
Matrix 4 [glstate_matrix_invtrans_modelview0]
Vector 16 [unity_LightmapST]
Vector 17 [_MainTex_ST]
Vector 18 [_BumpMap_ST]
"vs_2_0
; 18 ALU
dcl_position0 v0
dcl_tangent0 v1
dcl_normal0 v2
dcl_texcoord0 v3
dcl_texcoord1 v4
mov r0.xyz, v1
mul r1.xyz, v2.zxyw, r0.yzxw
mov r0.xyz, v1
mad r0.xyz, v2.yzxw, r0.zxyw, -r1
mul r0.xyz, r0, v1.w
dp3 oT1.y, r0, c4
dp3 oT2.y, r0, c5
mad oT0.zw, v3.xyxy, c18.xyxy, c18
mad oT0.xy, v3, c17, c17.zwzw
mad oT3.xy, v4, c16, c16.zwzw
dp4 oPos.w, v0, c3
dp4 oPos.z, v0, c2
dp4 oPos.y, v0, c1
dp4 oPos.x, v0, c0
dp3 oT1.z, v2, c4
dp3 oT1.x, v1, c4
dp3 oT2.z, v2, c5
dp3 oT2.x, v1, c5
"
}

SubProgram "d3d11 " {
Keywords { "DIRECTIONAL" "LIGHTMAP_ON" "DIRLIGHTMAP_ON" "SHADOWS_OFF" }
Bind "vertex" Vertex
Bind "tangent" TexCoord2
Bind "normal" Normal
Bind "texcoord" TexCoord0
Bind "texcoord1" TexCoord1
Bind "color" Color
ConstBuffer "$Globals" 128 // 112 used size, 8 vars
Vector 64 [unity_LightmapST] 4
Vector 80 [_MainTex_ST] 4
Vector 96 [_BumpMap_ST] 4
ConstBuffer "UnityPerDraw" 336 // 192 used size, 6 vars
Matrix 0 [glstate_matrix_mvp] 4
Matrix 128 [glstate_matrix_invtrans_modelview0] 4
BindCB "$Globals" 0
BindCB "UnityPerDraw" 1
// 23 instructions, 2 temp regs, 0 temp arrays:
// ALU 9 float, 0 int, 0 uint
// TEX 0 (0 load, 0 comp, 0 bias, 0 grad)
// FLOW 1 static, 0 dynamic
"vs_4_0
eefiecedjcmhbpgolefibdolpombohepcodhbiejabaaaaaaaaafaaaaadaaaaaa
cmaaaaaapeaaaaaajeabaaaaejfdeheomaaaaaaaagaaaaaaaiaaaaaajiaaaaaa
aaaaaaaaaaaaaaaaadaaaaaaaaaaaaaaapapaaaakbaaaaaaaaaaaaaaaaaaaaaa
adaaaaaaabaaaaaaapapaaaakjaaaaaaaaaaaaaaaaaaaaaaadaaaaaaacaaaaaa
ahahaaaalaaaaaaaaaaaaaaaaaaaaaaaadaaaaaaadaaaaaaapadaaaalaaaaaaa
abaaaaaaaaaaaaaaadaaaaaaaeaaaaaaapadaaaaljaaaaaaaaaaaaaaaaaaaaaa
adaaaaaaafaaaaaaapaaaaaafaepfdejfeejepeoaafeebeoehefeofeaaeoepfc
enebemaafeeffiedepepfceeaaedepemepfcaaklepfdeheojiaaaaaaafaaaaaa
aiaaaaaaiaaaaaaaaaaaaaaaabaaaaaaadaaaaaaaaaaaaaaapaaaaaaimaaaaaa
aaaaaaaaaaaaaaaaadaaaaaaabaaaaaaapaaaaaaimaaaaaaabaaaaaaaaaaaaaa
adaaaaaaacaaaaaaahaiaaaaimaaaaaaacaaaaaaaaaaaaaaadaaaaaaadaaaaaa
ahaiaaaaimaaaaaaadaaaaaaaaaaaaaaadaaaaaaaeaaaaaaadamaaaafdfgfpfa
epfdejfeejepeoaafeeffiedepepfceeaaklklklfdeieefcgeadaaaaeaaaabaa
njaaaaaafjaaaaaeegiocaaaaaaaaaaaahaaaaaafjaaaaaeegiocaaaabaaaaaa
alaaaaaafpaaaaadpcbabaaaaaaaaaaafpaaaaadpcbabaaaabaaaaaafpaaaaad
hcbabaaaacaaaaaafpaaaaaddcbabaaaadaaaaaafpaaaaaddcbabaaaaeaaaaaa
ghaaaaaepccabaaaaaaaaaaaabaaaaaagfaaaaadpccabaaaabaaaaaagfaaaaad
hccabaaaacaaaaaagfaaaaadhccabaaaadaaaaaagfaaaaaddccabaaaaeaaaaaa
giaaaaacacaaaaaadiaaaaaipcaabaaaaaaaaaaafgbfbaaaaaaaaaaaegiocaaa
abaaaaaaabaaaaaadcaaaaakpcaabaaaaaaaaaaaegiocaaaabaaaaaaaaaaaaaa
agbabaaaaaaaaaaaegaobaaaaaaaaaaadcaaaaakpcaabaaaaaaaaaaaegiocaaa
abaaaaaaacaaaaaakgbkbaaaaaaaaaaaegaobaaaaaaaaaaadcaaaaakpccabaaa
aaaaaaaaegiocaaaabaaaaaaadaaaaaapgbpbaaaaaaaaaaaegaobaaaaaaaaaaa
dcaaaaaldccabaaaabaaaaaaegbabaaaadaaaaaaegiacaaaaaaaaaaaafaaaaaa
ogikcaaaaaaaaaaaafaaaaaadcaaaaalmccabaaaabaaaaaaagbebaaaadaaaaaa
agiecaaaaaaaaaaaagaaaaaakgiocaaaaaaaaaaaagaaaaaadiaaaaahhcaabaaa
aaaaaaaajgbebaaaabaaaaaacgbjbaaaacaaaaaadcaaaaakhcaabaaaaaaaaaaa
jgbebaaaacaaaaaacgbjbaaaabaaaaaaegacbaiaebaaaaaaaaaaaaaadiaaaaah
hcaabaaaaaaaaaaaegacbaaaaaaaaaaapgbpbaaaabaaaaaadgaaaaagbcaabaaa
abaaaaaaakiacaaaabaaaaaaaiaaaaaadgaaaaagccaabaaaabaaaaaaakiacaaa
abaaaaaaajaaaaaadgaaaaagecaabaaaabaaaaaaakiacaaaabaaaaaaakaaaaaa
baaaaaahcccabaaaacaaaaaaegacbaaaaaaaaaaaegacbaaaabaaaaaabaaaaaah
bccabaaaacaaaaaaegbcbaaaabaaaaaaegacbaaaabaaaaaabaaaaaaheccabaaa
acaaaaaaegbcbaaaacaaaaaaegacbaaaabaaaaaadgaaaaagbcaabaaaabaaaaaa
bkiacaaaabaaaaaaaiaaaaaadgaaaaagccaabaaaabaaaaaabkiacaaaabaaaaaa
ajaaaaaadgaaaaagecaabaaaabaaaaaabkiacaaaabaaaaaaakaaaaaabaaaaaah
cccabaaaadaaaaaaegacbaaaaaaaaaaaegacbaaaabaaaaaabaaaaaahbccabaaa
adaaaaaaegbcbaaaabaaaaaaegacbaaaabaaaaaabaaaaaaheccabaaaadaaaaaa
egbcbaaaacaaaaaaegacbaaaabaaaaaadcaaaaaldccabaaaaeaaaaaaegbabaaa
aeaaaaaaegiacaaaaaaaaaaaaeaaaaaaogikcaaaaaaaaaaaaeaaaaaadoaaaaab
"
}

SubProgram "gles " {
Keywords { "DIRECTIONAL" "LIGHTMAP_ON" "DIRLIGHTMAP_ON" "SHADOWS_OFF" }
"!!GLES
#define SHADER_API_GLES 1
#define tex2D texture2D


#ifdef VERTEX
#define gl_ModelViewProjectionMatrix glstate_matrix_mvp
uniform mat4 glstate_matrix_mvp;
#define gl_ModelViewMatrixInverseTranspose glstate_matrix_invtrans_modelview0
uniform mat4 glstate_matrix_invtrans_modelview0;
#define gl_ModelViewMatrix glstate_matrix_modelview0
uniform mat4 glstate_matrix_modelview0;

varying highp vec2 xlv_TEXCOORD3;
varying highp vec3 xlv_TEXCOORD2;
varying highp vec3 xlv_TEXCOORD1;
varying highp vec4 xlv_TEXCOORD0;
uniform highp vec4 _BumpMap_ST;
uniform highp vec4 _MainTex_ST;
uniform highp vec4 unity_LightmapST;


attribute vec4 _glesTANGENT;
attribute vec4 _glesMultiTexCoord1;
attribute vec4 _glesMultiTexCoord0;
attribute vec3 _glesNormal;
attribute vec4 _glesVertex;
void main ()
{
  vec4 tmpvar_1;
  tmpvar_1.xyz = normalize(_glesTANGENT.xyz);
  tmpvar_1.w = _glesTANGENT.w;
  vec3 tmpvar_2;
  tmpvar_2 = normalize(_glesNormal);
  highp vec4 tmpvar_3;
  highp vec3 tmpvar_4;
  highp vec3 tmpvar_5;
  tmpvar_4 = tmpvar_1.xyz;
  tmpvar_5 = (((tmpvar_2.yzx * tmpvar_1.zxy) - (tmpvar_2.zxy * tmpvar_1.yzx)) * _glesTANGENT.w);
  highp mat3 tmpvar_6;
  tmpvar_6[0].x = tmpvar_4.x;
  tmpvar_6[0].y = tmpvar_5.x;
  tmpvar_6[0].z = tmpvar_2.x;
  tmpvar_6[1].x = tmpvar_4.y;
  tmpvar_6[1].y = tmpvar_5.y;
  tmpvar_6[1].z = tmpvar_2.y;
  tmpvar_6[2].x = tmpvar_4.z;
  tmpvar_6[2].y = tmpvar_5.z;
  tmpvar_6[2].z = tmpvar_2.z;
  vec4 v_7;
  v_7.x = gl_ModelViewMatrixInverseTranspose[0].x;
  v_7.y = gl_ModelViewMatrixInverseTranspose[1].x;
  v_7.z = gl_ModelViewMatrixInverseTranspose[2].x;
  v_7.w = gl_ModelViewMatrixInverseTranspose[3].x;
  vec4 v_8;
  v_8.x = gl_ModelViewMatrixInverseTranspose[0].y;
  v_8.y = gl_ModelViewMatrixInverseTranspose[1].y;
  v_8.z = gl_ModelViewMatrixInverseTranspose[2].y;
  v_8.w = gl_ModelViewMatrixInverseTranspose[3].y;
  tmpvar_3.xy = ((_glesMultiTexCoord0.xy * _MainTex_ST.xy) + _MainTex_ST.zw);
  tmpvar_3.zw = ((_glesMultiTexCoord0.xy * _BumpMap_ST.xy) + _BumpMap_ST.zw);
  gl_Position = (gl_ModelViewProjectionMatrix * _glesVertex);
  xlv_TEXCOORD0 = tmpvar_3;
  xlv_TEXCOORD1 = (tmpvar_6 * v_7.xyz);
  xlv_TEXCOORD2 = (tmpvar_6 * v_8.xyz);
  xlv_TEXCOORD3 = ((_glesMultiTexCoord1.xy * unity_LightmapST.xy) + unity_LightmapST.zw);
}



#endif
#ifdef FRAGMENT

varying highp vec2 xlv_TEXCOORD3;
varying highp vec3 xlv_TEXCOORD2;
varying highp vec3 xlv_TEXCOORD1;
varying highp vec4 xlv_TEXCOORD0;
uniform lowp float _Cutoff;
uniform sampler2D unity_LightmapInd;
uniform sampler2D unity_Lightmap;
uniform sampler2D _Shade;
uniform sampler2D _BumpMap;
uniform sampler2D _MainTex;
uniform lowp vec4 _Color;
void main ()
{
  lowp vec4 c_1;
  lowp vec3 tmpvar_2;
  highp vec3 matcap_3;
  lowp vec3 tmpvar_4;
  tmpvar_4 = ((texture2D (_BumpMap, xlv_TEXCOORD0.zw).xyz * 2.0) - 1.0);
  lowp vec3 tmpvar_5;
  tmpvar_5 = (texture2D (_MainTex, xlv_TEXCOORD0.xy).xyz * _Color.w);
  highp vec2 tmpvar_6;
  tmpvar_6.x = dot (xlv_TEXCOORD1, tmpvar_4);
  tmpvar_6.y = dot (xlv_TEXCOORD2, tmpvar_4);
  highp vec2 P_7;
  P_7 = ((tmpvar_6 * 0.5) + 0.5);
  lowp vec3 tmpvar_8;
  tmpvar_8 = texture2D (_Shade, P_7).xyz;
  matcap_3 = tmpvar_8;
  lowp vec4 tmpvar_9;
  tmpvar_9 = texture2D (_MainTex, xlv_TEXCOORD0.xy);
  highp vec3 tmpvar_10;
  tmpvar_10 = (((matcap_3 * tmpvar_9.xyz) * _Color.xyz) * 3.0);
  tmpvar_2 = tmpvar_10;
  lowp vec4 tmpvar_11;
  tmpvar_11 = texture2D (_MainTex, xlv_TEXCOORD0.xy);
  lowp float tmpvar_12;
  tmpvar_12 = tmpvar_11.w;
  lowp float x_13;
  x_13 = (tmpvar_11.w - _Cutoff);
  if ((x_13 < 0.0)) {
    discard;
  };
  mat3 tmpvar_14;
  tmpvar_14[0].x = 0.816497;
  tmpvar_14[0].y = -0.408248;
  tmpvar_14[0].z = -0.408248;
  tmpvar_14[1].x = 0.0;
  tmpvar_14[1].y = 0.707107;
  tmpvar_14[1].z = -0.707107;
  tmpvar_14[2].x = 0.57735;
  tmpvar_14[2].y = 0.57735;
  tmpvar_14[2].z = 0.57735;
  mediump vec3 normal_15;
  normal_15 = tmpvar_4;
  mediump vec3 scalePerBasisVector_16;
  mediump vec3 lm_17;
  lowp vec3 tmpvar_18;
  tmpvar_18 = (2.0 * texture2D (unity_Lightmap, xlv_TEXCOORD3).xyz);
  lm_17 = tmpvar_18;
  lowp vec3 tmpvar_19;
  tmpvar_19 = (2.0 * texture2D (unity_LightmapInd, xlv_TEXCOORD3).xyz);
  scalePerBasisVector_16 = tmpvar_19;
  lm_17 = (lm_17 * dot (clamp ((tmpvar_14 * normal_15), 0.0, 1.0), scalePerBasisVector_16));
  mediump vec3 tmpvar_20;
  tmpvar_20 = (tmpvar_5 * lm_17);
  c_1.xyz = tmpvar_20;
  c_1.w = tmpvar_12;
  c_1.xyz = (c_1.xyz + tmpvar_2);
  c_1.w = tmpvar_12;
  gl_FragData[0] = c_1;
}



#endif"
}

SubProgram "glesdesktop " {
Keywords { "DIRECTIONAL" "LIGHTMAP_ON" "DIRLIGHTMAP_ON" "SHADOWS_OFF" }
"!!GLES
#define SHADER_API_GLES 1
#define tex2D texture2D


#ifdef VERTEX
#define gl_ModelViewProjectionMatrix glstate_matrix_mvp
uniform mat4 glstate_matrix_mvp;
#define gl_ModelViewMatrixInverseTranspose glstate_matrix_invtrans_modelview0
uniform mat4 glstate_matrix_invtrans_modelview0;
#define gl_ModelViewMatrix glstate_matrix_modelview0
uniform mat4 glstate_matrix_modelview0;

varying highp vec2 xlv_TEXCOORD3;
varying highp vec3 xlv_TEXCOORD2;
varying highp vec3 xlv_TEXCOORD1;
varying highp vec4 xlv_TEXCOORD0;
uniform highp vec4 _BumpMap_ST;
uniform highp vec4 _MainTex_ST;
uniform highp vec4 unity_LightmapST;


attribute vec4 _glesTANGENT;
attribute vec4 _glesMultiTexCoord1;
attribute vec4 _glesMultiTexCoord0;
attribute vec3 _glesNormal;
attribute vec4 _glesVertex;
void main ()
{
  vec4 tmpvar_1;
  tmpvar_1.xyz = normalize(_glesTANGENT.xyz);
  tmpvar_1.w = _glesTANGENT.w;
  vec3 tmpvar_2;
  tmpvar_2 = normalize(_glesNormal);
  highp vec4 tmpvar_3;
  highp vec3 tmpvar_4;
  highp vec3 tmpvar_5;
  tmpvar_4 = tmpvar_1.xyz;
  tmpvar_5 = (((tmpvar_2.yzx * tmpvar_1.zxy) - (tmpvar_2.zxy * tmpvar_1.yzx)) * _glesTANGENT.w);
  highp mat3 tmpvar_6;
  tmpvar_6[0].x = tmpvar_4.x;
  tmpvar_6[0].y = tmpvar_5.x;
  tmpvar_6[0].z = tmpvar_2.x;
  tmpvar_6[1].x = tmpvar_4.y;
  tmpvar_6[1].y = tmpvar_5.y;
  tmpvar_6[1].z = tmpvar_2.y;
  tmpvar_6[2].x = tmpvar_4.z;
  tmpvar_6[2].y = tmpvar_5.z;
  tmpvar_6[2].z = tmpvar_2.z;
  vec4 v_7;
  v_7.x = gl_ModelViewMatrixInverseTranspose[0].x;
  v_7.y = gl_ModelViewMatrixInverseTranspose[1].x;
  v_7.z = gl_ModelViewMatrixInverseTranspose[2].x;
  v_7.w = gl_ModelViewMatrixInverseTranspose[3].x;
  vec4 v_8;
  v_8.x = gl_ModelViewMatrixInverseTranspose[0].y;
  v_8.y = gl_ModelViewMatrixInverseTranspose[1].y;
  v_8.z = gl_ModelViewMatrixInverseTranspose[2].y;
  v_8.w = gl_ModelViewMatrixInverseTranspose[3].y;
  tmpvar_3.xy = ((_glesMultiTexCoord0.xy * _MainTex_ST.xy) + _MainTex_ST.zw);
  tmpvar_3.zw = ((_glesMultiTexCoord0.xy * _BumpMap_ST.xy) + _BumpMap_ST.zw);
  gl_Position = (gl_ModelViewProjectionMatrix * _glesVertex);
  xlv_TEXCOORD0 = tmpvar_3;
  xlv_TEXCOORD1 = (tmpvar_6 * v_7.xyz);
  xlv_TEXCOORD2 = (tmpvar_6 * v_8.xyz);
  xlv_TEXCOORD3 = ((_glesMultiTexCoord1.xy * unity_LightmapST.xy) + unity_LightmapST.zw);
}



#endif
#ifdef FRAGMENT

varying highp vec2 xlv_TEXCOORD3;
varying highp vec3 xlv_TEXCOORD2;
varying highp vec3 xlv_TEXCOORD1;
varying highp vec4 xlv_TEXCOORD0;
uniform lowp float _Cutoff;
uniform sampler2D unity_LightmapInd;
uniform sampler2D unity_Lightmap;
uniform sampler2D _Shade;
uniform sampler2D _BumpMap;
uniform sampler2D _MainTex;
uniform lowp vec4 _Color;
void main ()
{
  lowp vec4 c_1;
  lowp vec3 tmpvar_2;
  highp vec3 matcap_3;
  lowp vec3 normal_4;
  normal_4.xy = ((texture2D (_BumpMap, xlv_TEXCOORD0.zw).wy * 2.0) - 1.0);
  normal_4.z = sqrt(((1.0 - (normal_4.x * normal_4.x)) - (normal_4.y * normal_4.y)));
  lowp vec3 tmpvar_5;
  tmpvar_5 = (texture2D (_MainTex, xlv_TEXCOORD0.xy).xyz * _Color.w);
  highp vec2 tmpvar_6;
  tmpvar_6.x = dot (xlv_TEXCOORD1, normal_4);
  tmpvar_6.y = dot (xlv_TEXCOORD2, normal_4);
  highp vec2 P_7;
  P_7 = ((tmpvar_6 * 0.5) + 0.5);
  lowp vec3 tmpvar_8;
  tmpvar_8 = texture2D (_Shade, P_7).xyz;
  matcap_3 = tmpvar_8;
  lowp vec4 tmpvar_9;
  tmpvar_9 = texture2D (_MainTex, xlv_TEXCOORD0.xy);
  highp vec3 tmpvar_10;
  tmpvar_10 = (((matcap_3 * tmpvar_9.xyz) * _Color.xyz) * 3.0);
  tmpvar_2 = tmpvar_10;
  lowp vec4 tmpvar_11;
  tmpvar_11 = texture2D (_MainTex, xlv_TEXCOORD0.xy);
  lowp float tmpvar_12;
  tmpvar_12 = tmpvar_11.w;
  lowp float x_13;
  x_13 = (tmpvar_11.w - _Cutoff);
  if ((x_13 < 0.0)) {
    discard;
  };
  lowp vec4 tmpvar_14;
  tmpvar_14 = texture2D (unity_Lightmap, xlv_TEXCOORD3);
  lowp vec4 tmpvar_15;
  tmpvar_15 = texture2D (unity_LightmapInd, xlv_TEXCOORD3);
  mat3 tmpvar_16;
  tmpvar_16[0].x = 0.816497;
  tmpvar_16[0].y = -0.408248;
  tmpvar_16[0].z = -0.408248;
  tmpvar_16[1].x = 0.0;
  tmpvar_16[1].y = 0.707107;
  tmpvar_16[1].z = -0.707107;
  tmpvar_16[2].x = 0.57735;
  tmpvar_16[2].y = 0.57735;
  tmpvar_16[2].z = 0.57735;
  mediump vec3 normal_17;
  normal_17 = normal_4;
  mediump vec3 scalePerBasisVector_18;
  mediump vec3 lm_19;
  lowp vec3 tmpvar_20;
  tmpvar_20 = ((8.0 * tmpvar_14.w) * tmpvar_14.xyz);
  lm_19 = tmpvar_20;
  lowp vec3 tmpvar_21;
  tmpvar_21 = ((8.0 * tmpvar_15.w) * tmpvar_15.xyz);
  scalePerBasisVector_18 = tmpvar_21;
  lm_19 = (lm_19 * dot (clamp ((tmpvar_16 * normal_17), 0.0, 1.0), scalePerBasisVector_18));
  mediump vec3 tmpvar_22;
  tmpvar_22 = (tmpvar_5 * lm_19);
  c_1.xyz = tmpvar_22;
  c_1.w = tmpvar_12;
  c_1.xyz = (c_1.xyz + tmpvar_2);
  c_1.w = tmpvar_12;
  gl_FragData[0] = c_1;
}



#endif"
}

SubProgram "flash " {
Keywords { "DIRECTIONAL" "LIGHTMAP_ON" "DIRLIGHTMAP_ON" "SHADOWS_OFF" }
Bind "vertex" Vertex
Bind "tangent" TexCoord2
Bind "normal" Normal
Bind "texcoord" TexCoord0
Bind "texcoord1" TexCoord1
Matrix 0 [glstate_matrix_mvp]
Matrix 4 [glstate_matrix_invtrans_modelview0]
Vector 16 [unity_LightmapST]
Vector 17 [_MainTex_ST]
Vector 18 [_BumpMap_ST]
"agal_vs
[bc]
aaaaaaaaaaaaahacafaaaaoeaaaaaaaaaaaaaaaaaaaaaaaa mov r0.xyz, a5
adaaaaaaabaaahacabaaaancaaaaaaaaaaaaaaajacaaaaaa mul r1.xyz, a1.zxyw, r0.yzxx
aaaaaaaaaaaaahacafaaaaoeaaaaaaaaaaaaaaaaaaaaaaaa mov r0.xyz, a5
adaaaaaaacaaahacabaaaamjaaaaaaaaaaaaaafcacaaaaaa mul r2.xyz, a1.yzxw, r0.zxyy
acaaaaaaaaaaahacacaaaakeacaaaaaaabaaaakeacaaaaaa sub r0.xyz, r2.xyzz, r1.xyzz
adaaaaaaaaaaahacaaaaaakeacaaaaaaafaaaappaaaaaaaa mul r0.xyz, r0.xyzz, a5.w
bcaaaaaaabaaacaeaaaaaakeacaaaaaaaeaaaaoeabaaaaaa dp3 v1.y, r0.xyzz, c4
bcaaaaaaacaaacaeaaaaaakeacaaaaaaafaaaaoeabaaaaaa dp3 v2.y, r0.xyzz, c5
adaaaaaaacaaamacadaaaaeeaaaaaaaabcaaaaeeabaaaaaa mul r2.zw, a3.xyxy, c18.xyxy
abaaaaaaaaaaamaeacaaaaopacaaaaaabcaaaaoeabaaaaaa add v0.zw, r2.wwzw, c18
adaaaaaaacaaadacadaaaaoeaaaaaaaabbaaaaoeabaaaaaa mul r2.xy, a3, c17
abaaaaaaaaaaadaeacaaaafeacaaaaaabbaaaaooabaaaaaa add v0.xy, r2.xyyy, c17.zwzw
adaaaaaaacaaadacaeaaaaoeaaaaaaaabaaaaaoeabaaaaaa mul r2.xy, a4, c16
abaaaaaaadaaadaeacaaaafeacaaaaaabaaaaaooabaaaaaa add v3.xy, r2.xyyy, c16.zwzw
bdaaaaaaaaaaaiadaaaaaaoeaaaaaaaaadaaaaoeabaaaaaa dp4 o0.w, a0, c3
bdaaaaaaaaaaaeadaaaaaaoeaaaaaaaaacaaaaoeabaaaaaa dp4 o0.z, a0, c2
bdaaaaaaaaaaacadaaaaaaoeaaaaaaaaabaaaaoeabaaaaaa dp4 o0.y, a0, c1
bdaaaaaaaaaaabadaaaaaaoeaaaaaaaaaaaaaaoeabaaaaaa dp4 o0.x, a0, c0
bcaaaaaaabaaaeaeabaaaaoeaaaaaaaaaeaaaaoeabaaaaaa dp3 v1.z, a1, c4
bcaaaaaaabaaabaeafaaaaoeaaaaaaaaaeaaaaoeabaaaaaa dp3 v1.x, a5, c4
bcaaaaaaacaaaeaeabaaaaoeaaaaaaaaafaaaaoeabaaaaaa dp3 v2.z, a1, c5
bcaaaaaaacaaabaeafaaaaoeaaaaaaaaafaaaaoeabaaaaaa dp3 v2.x, a5, c5
aaaaaaaaabaaaiaeaaaaaaoeabaaaaaaaaaaaaaaaaaaaaaa mov v1.w, c0
aaaaaaaaacaaaiaeaaaaaaoeabaaaaaaaaaaaaaaaaaaaaaa mov v2.w, c0
aaaaaaaaadaaamaeaaaaaaoeabaaaaaaaaaaaaaaaaaaaaaa mov v3.zw, c0
"
}

SubProgram "d3d11_9x " {
Keywords { "DIRECTIONAL" "LIGHTMAP_ON" "DIRLIGHTMAP_ON" "SHADOWS_OFF" }
Bind "vertex" Vertex
Bind "tangent" TexCoord2
Bind "normal" Normal
Bind "texcoord" TexCoord0
Bind "texcoord1" TexCoord1
Bind "color" Color
ConstBuffer "$Globals" 128 // 112 used size, 8 vars
Vector 64 [unity_LightmapST] 4
Vector 80 [_MainTex_ST] 4
Vector 96 [_BumpMap_ST] 4
ConstBuffer "UnityPerDraw" 336 // 192 used size, 6 vars
Matrix 0 [glstate_matrix_mvp] 4
Matrix 128 [glstate_matrix_invtrans_modelview0] 4
BindCB "$Globals" 0
BindCB "UnityPerDraw" 1
// 23 instructions, 2 temp regs, 0 temp arrays:
// ALU 9 float, 0 int, 0 uint
// TEX 0 (0 load, 0 comp, 0 bias, 0 grad)
// FLOW 1 static, 0 dynamic
"vs_4_0_level_9_3
eefiecedckkidooepkjagehkchljchpbmdojjchlabaaaaaacmahaaaaaeaaaaaa
daaaaaaafiacaaaameafaaaaimagaaaaebgpgodjcaacaaaacaacaaaaaaacpopp
neabaaaaemaaaaaaadaaceaaaaaaeiaaaaaaeiaaaaaaceaaabaaeiaaaaaaaeaa
adaaabaaaaaaaaaaabaaaaaaaeaaaeaaaaaaaaaaabaaaiaaadaaaiaaaaaaaaaa
aaaaaaaaabacpoppbpaaaaacafaaaaiaaaaaapjabpaaaaacafaaabiaabaaapja
bpaaaaacafaaaciaacaaapjabpaaaaacafaaadiaadaaapjabpaaaaacafaaaeia
aeaaapjaabaaaaacaaaaabiaaiaaaakaabaaaaacaaaaaciaajaaaakaabaaaaac
aaaaaeiaakaaaakaaiaaaaadabaaaboaabaaoejaaaaaoeiaabaaaaacabaaahia
abaaoejaafaaaaadacaaahiaabaamjiaacaancjaaeaaaaaeabaaahiaacaamjja
abaanciaacaaoeibafaaaaadabaaahiaabaaoeiaabaappjaaiaaaaadabaaacoa
abaaoeiaaaaaoeiaaiaaaaadabaaaeoaacaaoejaaaaaoeiaabaaaaacaaaaabia
aiaaffkaabaaaaacaaaaaciaajaaffkaabaaaaacaaaaaeiaakaaffkaaiaaaaad
acaaaboaabaaoejaaaaaoeiaaiaaaaadacaaacoaabaaoeiaaaaaoeiaaiaaaaad
acaaaeoaacaaoejaaaaaoeiaaeaaaaaeaaaaadoaadaaoejaacaaoekaacaaooka
aeaaaaaeaaaaamoaadaaeejaadaaeekaadaaoekaaeaaaaaeadaaadoaaeaaoeja
abaaoekaabaaookaafaaaaadaaaaapiaaaaaffjaafaaoekaaeaaaaaeaaaaapia
aeaaoekaaaaaaajaaaaaoeiaaeaaaaaeaaaaapiaagaaoekaaaaakkjaaaaaoeia
aeaaaaaeaaaaapiaahaaoekaaaaappjaaaaaoeiaaeaaaaaeaaaaadmaaaaappia
aaaaoekaaaaaoeiaabaaaaacaaaaammaaaaaoeiappppaaaafdeieefcgeadaaaa
eaaaabaanjaaaaaafjaaaaaeegiocaaaaaaaaaaaahaaaaaafjaaaaaeegiocaaa
abaaaaaaalaaaaaafpaaaaadpcbabaaaaaaaaaaafpaaaaadpcbabaaaabaaaaaa
fpaaaaadhcbabaaaacaaaaaafpaaaaaddcbabaaaadaaaaaafpaaaaaddcbabaaa
aeaaaaaaghaaaaaepccabaaaaaaaaaaaabaaaaaagfaaaaadpccabaaaabaaaaaa
gfaaaaadhccabaaaacaaaaaagfaaaaadhccabaaaadaaaaaagfaaaaaddccabaaa
aeaaaaaagiaaaaacacaaaaaadiaaaaaipcaabaaaaaaaaaaafgbfbaaaaaaaaaaa
egiocaaaabaaaaaaabaaaaaadcaaaaakpcaabaaaaaaaaaaaegiocaaaabaaaaaa
aaaaaaaaagbabaaaaaaaaaaaegaobaaaaaaaaaaadcaaaaakpcaabaaaaaaaaaaa
egiocaaaabaaaaaaacaaaaaakgbkbaaaaaaaaaaaegaobaaaaaaaaaaadcaaaaak
pccabaaaaaaaaaaaegiocaaaabaaaaaaadaaaaaapgbpbaaaaaaaaaaaegaobaaa
aaaaaaaadcaaaaaldccabaaaabaaaaaaegbabaaaadaaaaaaegiacaaaaaaaaaaa
afaaaaaaogikcaaaaaaaaaaaafaaaaaadcaaaaalmccabaaaabaaaaaaagbebaaa
adaaaaaaagiecaaaaaaaaaaaagaaaaaakgiocaaaaaaaaaaaagaaaaaadiaaaaah
hcaabaaaaaaaaaaajgbebaaaabaaaaaacgbjbaaaacaaaaaadcaaaaakhcaabaaa
aaaaaaaajgbebaaaacaaaaaacgbjbaaaabaaaaaaegacbaiaebaaaaaaaaaaaaaa
diaaaaahhcaabaaaaaaaaaaaegacbaaaaaaaaaaapgbpbaaaabaaaaaadgaaaaag
bcaabaaaabaaaaaaakiacaaaabaaaaaaaiaaaaaadgaaaaagccaabaaaabaaaaaa
akiacaaaabaaaaaaajaaaaaadgaaaaagecaabaaaabaaaaaaakiacaaaabaaaaaa
akaaaaaabaaaaaahcccabaaaacaaaaaaegacbaaaaaaaaaaaegacbaaaabaaaaaa
baaaaaahbccabaaaacaaaaaaegbcbaaaabaaaaaaegacbaaaabaaaaaabaaaaaah
eccabaaaacaaaaaaegbcbaaaacaaaaaaegacbaaaabaaaaaadgaaaaagbcaabaaa
abaaaaaabkiacaaaabaaaaaaaiaaaaaadgaaaaagccaabaaaabaaaaaabkiacaaa
abaaaaaaajaaaaaadgaaaaagecaabaaaabaaaaaabkiacaaaabaaaaaaakaaaaaa
baaaaaahcccabaaaadaaaaaaegacbaaaaaaaaaaaegacbaaaabaaaaaabaaaaaah
bccabaaaadaaaaaaegbcbaaaabaaaaaaegacbaaaabaaaaaabaaaaaaheccabaaa
adaaaaaaegbcbaaaacaaaaaaegacbaaaabaaaaaadcaaaaaldccabaaaaeaaaaaa
egbabaaaaeaaaaaaegiacaaaaaaaaaaaaeaaaaaaogikcaaaaaaaaaaaaeaaaaaa
doaaaaabejfdeheomaaaaaaaagaaaaaaaiaaaaaajiaaaaaaaaaaaaaaaaaaaaaa
adaaaaaaaaaaaaaaapapaaaakbaaaaaaaaaaaaaaaaaaaaaaadaaaaaaabaaaaaa
apapaaaakjaaaaaaaaaaaaaaaaaaaaaaadaaaaaaacaaaaaaahahaaaalaaaaaaa
aaaaaaaaaaaaaaaaadaaaaaaadaaaaaaapadaaaalaaaaaaaabaaaaaaaaaaaaaa
adaaaaaaaeaaaaaaapadaaaaljaaaaaaaaaaaaaaaaaaaaaaadaaaaaaafaaaaaa
apaaaaaafaepfdejfeejepeoaafeebeoehefeofeaaeoepfcenebemaafeeffied
epepfceeaaedepemepfcaaklepfdeheojiaaaaaaafaaaaaaaiaaaaaaiaaaaaaa
aaaaaaaaabaaaaaaadaaaaaaaaaaaaaaapaaaaaaimaaaaaaaaaaaaaaaaaaaaaa
adaaaaaaabaaaaaaapaaaaaaimaaaaaaabaaaaaaaaaaaaaaadaaaaaaacaaaaaa
ahaiaaaaimaaaaaaacaaaaaaaaaaaaaaadaaaaaaadaaaaaaahaiaaaaimaaaaaa
adaaaaaaaaaaaaaaadaaaaaaaeaaaaaaadamaaaafdfgfpfaepfdejfeejepeoaa
feeffiedepepfceeaaklklkl"
}

SubProgram "opengl " {
Keywords { "DIRECTIONAL" "LIGHTMAP_OFF" "DIRLIGHTMAP_OFF" "SHADOWS_SCREEN" }
Bind "vertex" Vertex
Bind "tangent" ATTR14
Bind "normal" Normal
Bind "texcoord" TexCoord0
Vector 17 [_ProjectionParams]
Vector 18 [_WorldSpaceLightPos0]
Vector 19 [unity_SHAr]
Vector 20 [unity_SHAg]
Vector 21 [unity_SHAb]
Vector 22 [unity_SHBr]
Vector 23 [unity_SHBg]
Vector 24 [unity_SHBb]
Vector 25 [unity_SHC]
Matrix 9 [_Object2World]
Matrix 13 [_World2Object]
Vector 26 [unity_Scale]
Vector 27 [_MainTex_ST]
Vector 28 [_BumpMap_ST]
"!!ARBvp1.0
# 46 ALU
PARAM c[29] = { { 1, 0.5 },
		state.matrix.mvp,
		state.matrix.modelview[0].invtrans,
		program.local[9..28] };
TEMP R0;
TEMP R1;
TEMP R2;
TEMP R3;
MUL R1.xyz, vertex.normal, c[26].w;
DP3 R2.w, R1, c[10];
DP3 R0.x, R1, c[9];
DP3 R0.z, R1, c[11];
MOV R0.y, R2.w;
MUL R1, R0.xyzz, R0.yzzx;
MOV R0.w, c[0].x;
DP4 R2.z, R0, c[21];
DP4 R2.y, R0, c[20];
DP4 R2.x, R0, c[19];
MUL R0.y, R2.w, R2.w;
DP4 R3.z, R1, c[24];
DP4 R3.y, R1, c[23];
DP4 R3.x, R1, c[22];
MOV R1.xyz, vertex.attrib[14];
DP4 R0.w, vertex.position, c[4];
ADD R3.xyz, R2, R3;
MAD R0.x, R0, R0, -R0.y;
MUL R2.xyz, R0.x, c[25];
MUL R0.xyz, vertex.normal.zxyw, R1.yzxw;
MAD R0.xyz, vertex.normal.yzxw, R1.zxyw, -R0;
MUL R0.xyz, R0, vertex.attrib[14].w;
MOV R1, c[18];
ADD result.texcoord[4].xyz, R3, R2;
DP4 R2.z, R1, c[15];
DP4 R2.x, R1, c[13];
DP4 R2.y, R1, c[14];
DP3 result.texcoord[3].y, R0, R2;
DP3 result.texcoord[1].y, R0, c[5];
DP3 result.texcoord[2].y, R0, c[6];
DP4 R0.z, vertex.position, c[3];
DP4 R0.x, vertex.position, c[1];
DP4 R0.y, vertex.position, c[2];
MUL R1.xyz, R0.xyww, c[0].y;
MUL R1.y, R1, c[17].x;
DP3 result.texcoord[3].z, vertex.normal, R2;
DP3 result.texcoord[3].x, vertex.attrib[14], R2;
ADD result.texcoord[5].xy, R1, R1.z;
MOV result.position, R0;
MOV result.texcoord[5].zw, R0;
MAD result.texcoord[0].zw, vertex.texcoord[0].xyxy, c[28].xyxy, c[28];
MAD result.texcoord[0].xy, vertex.texcoord[0], c[27], c[27].zwzw;
DP3 result.texcoord[1].z, vertex.normal, c[5];
DP3 result.texcoord[1].x, vertex.attrib[14], c[5];
DP3 result.texcoord[2].z, vertex.normal, c[6];
DP3 result.texcoord[2].x, vertex.attrib[14], c[6];
END
# 46 instructions, 4 R-regs
"
}

SubProgram "d3d9 " {
Keywords { "DIRECTIONAL" "LIGHTMAP_OFF" "DIRLIGHTMAP_OFF" "SHADOWS_SCREEN" }
Bind "vertex" Vertex
Bind "tangent" TexCoord2
Bind "normal" Normal
Bind "texcoord" TexCoord0
Matrix 0 [glstate_matrix_mvp]
Matrix 4 [glstate_matrix_invtrans_modelview0]
Vector 16 [_ProjectionParams]
Vector 17 [_ScreenParams]
Vector 18 [_WorldSpaceLightPos0]
Vector 19 [unity_SHAr]
Vector 20 [unity_SHAg]
Vector 21 [unity_SHAb]
Vector 22 [unity_SHBr]
Vector 23 [unity_SHBg]
Vector 24 [unity_SHBb]
Vector 25 [unity_SHC]
Matrix 8 [_Object2World]
Matrix 12 [_World2Object]
Vector 26 [unity_Scale]
Vector 27 [_MainTex_ST]
Vector 28 [_BumpMap_ST]
"vs_2_0
; 49 ALU
def c29, 1.00000000, 0.50000000, 0, 0
dcl_position0 v0
dcl_tangent0 v1
dcl_normal0 v2
dcl_texcoord0 v3
mul r1.xyz, v2, c26.w
dp3 r2.w, r1, c9
dp3 r0.x, r1, c8
dp3 r0.z, r1, c10
mov r0.y, r2.w
mul r1, r0.xyzz, r0.yzzx
mov r0.w, c29.x
dp4 r2.z, r0, c21
dp4 r2.y, r0, c20
dp4 r2.x, r0, c19
mul r0.y, r2.w, r2.w
dp4 r3.z, r1, c24
dp4 r3.y, r1, c23
dp4 r3.x, r1, c22
mad r0.x, r0, r0, -r0.y
mul r1.xyz, r0.x, c25
add r2.xyz, r2, r3
mov r0.xyz, v1
add oT4.xyz, r2, r1
mul r1.xyz, v2.zxyw, r0.yzxw
mov r0.xyz, v1
mad r1.xyz, v2.yzxw, r0.zxyw, -r1
mul r2.xyz, r1, v1.w
mov r0, c14
dp4 r3.z, c18, r0
mov r0, c13
dp4 r3.y, c18, r0
mov r1, c12
dp4 r3.x, c18, r1
dp4 r0.w, v0, c3
dp4 r0.z, v0, c2
dp4 r0.x, v0, c0
dp4 r0.y, v0, c1
mul r1.xyz, r0.xyww, c29.y
mul r1.y, r1, c16.x
dp3 oT3.y, r2, r3
dp3 oT1.y, r2, c4
dp3 oT2.y, r2, c5
dp3 oT3.z, v2, r3
dp3 oT3.x, v1, r3
mad oT5.xy, r1.z, c17.zwzw, r1
mov oPos, r0
mov oT5.zw, r0
mad oT0.zw, v3.xyxy, c28.xyxy, c28
mad oT0.xy, v3, c27, c27.zwzw
dp3 oT1.z, v2, c4
dp3 oT1.x, v1, c4
dp3 oT2.z, v2, c5
dp3 oT2.x, v1, c5
"
}

SubProgram "d3d11 " {
Keywords { "DIRECTIONAL" "LIGHTMAP_OFF" "DIRLIGHTMAP_OFF" "SHADOWS_SCREEN" }
Bind "vertex" Vertex
Bind "tangent" TexCoord2
Bind "normal" Normal
Bind "texcoord" TexCoord0
Bind "color" Color
ConstBuffer "$Globals" 176 // 160 used size, 8 vars
Vector 128 [_MainTex_ST] 4
Vector 144 [_BumpMap_ST] 4
ConstBuffer "UnityPerCamera" 128 // 96 used size, 8 vars
Vector 80 [_ProjectionParams] 4
ConstBuffer "UnityLighting" 400 // 400 used size, 16 vars
Vector 0 [_WorldSpaceLightPos0] 4
Vector 288 [unity_SHAr] 4
Vector 304 [unity_SHAg] 4
Vector 320 [unity_SHAb] 4
Vector 336 [unity_SHBr] 4
Vector 352 [unity_SHBg] 4
Vector 368 [unity_SHBb] 4
Vector 384 [unity_SHC] 4
ConstBuffer "UnityPerDraw" 336 // 336 used size, 6 vars
Matrix 0 [glstate_matrix_mvp] 4
Matrix 128 [glstate_matrix_invtrans_modelview0] 4
Matrix 192 [_Object2World] 4
Matrix 256 [_World2Object] 4
Vector 320 [unity_Scale] 4
BindCB "$Globals" 0
BindCB "UnityPerCamera" 1
BindCB "UnityLighting" 2
BindCB "UnityPerDraw" 3
// 50 instructions, 5 temp regs, 0 temp arrays:
// ALU 27 float, 0 int, 0 uint
// TEX 0 (0 load, 0 comp, 0 bias, 0 grad)
// FLOW 1 static, 0 dynamic
"vs_4_0
eefiecedanhhakomikpdmpdjpdckpnebdagdhnpmabaaaaaamaaiaaaaadaaaaaa
cmaaaaaapeaaaaaameabaaaaejfdeheomaaaaaaaagaaaaaaaiaaaaaajiaaaaaa
aaaaaaaaaaaaaaaaadaaaaaaaaaaaaaaapapaaaakbaaaaaaaaaaaaaaaaaaaaaa
adaaaaaaabaaaaaaapapaaaakjaaaaaaaaaaaaaaaaaaaaaaadaaaaaaacaaaaaa
ahahaaaalaaaaaaaaaaaaaaaaaaaaaaaadaaaaaaadaaaaaaapadaaaalaaaaaaa
abaaaaaaaaaaaaaaadaaaaaaaeaaaaaaapaaaaaaljaaaaaaaaaaaaaaaaaaaaaa
adaaaaaaafaaaaaaapaaaaaafaepfdejfeejepeoaafeebeoehefeofeaaeoepfc
enebemaafeeffiedepepfceeaaedepemepfcaaklepfdeheomiaaaaaaahaaaaaa
aiaaaaaalaaaaaaaaaaaaaaaabaaaaaaadaaaaaaaaaaaaaaapaaaaaalmaaaaaa
aaaaaaaaaaaaaaaaadaaaaaaabaaaaaaapaaaaaalmaaaaaaabaaaaaaaaaaaaaa
adaaaaaaacaaaaaaahaiaaaalmaaaaaaacaaaaaaaaaaaaaaadaaaaaaadaaaaaa
ahaiaaaalmaaaaaaadaaaaaaaaaaaaaaadaaaaaaaeaaaaaaahaiaaaalmaaaaaa
aeaaaaaaaaaaaaaaadaaaaaaafaaaaaaahaiaaaalmaaaaaaafaaaaaaaaaaaaaa
adaaaaaaagaaaaaaapaaaaaafdfgfpfaepfdejfeejepeoaafeeffiedepepfcee
aaklklklfdeieefcpeagaaaaeaaaabaalnabaaaafjaaaaaeegiocaaaaaaaaaaa
akaaaaaafjaaaaaeegiocaaaabaaaaaaagaaaaaafjaaaaaeegiocaaaacaaaaaa
bjaaaaaafjaaaaaeegiocaaaadaaaaaabfaaaaaafpaaaaadpcbabaaaaaaaaaaa
fpaaaaadpcbabaaaabaaaaaafpaaaaadhcbabaaaacaaaaaafpaaaaaddcbabaaa
adaaaaaaghaaaaaepccabaaaaaaaaaaaabaaaaaagfaaaaadpccabaaaabaaaaaa
gfaaaaadhccabaaaacaaaaaagfaaaaadhccabaaaadaaaaaagfaaaaadhccabaaa
aeaaaaaagfaaaaadhccabaaaafaaaaaagfaaaaadpccabaaaagaaaaaagiaaaaac
afaaaaaadiaaaaaipcaabaaaaaaaaaaafgbfbaaaaaaaaaaaegiocaaaadaaaaaa
abaaaaaadcaaaaakpcaabaaaaaaaaaaaegiocaaaadaaaaaaaaaaaaaaagbabaaa
aaaaaaaaegaobaaaaaaaaaaadcaaaaakpcaabaaaaaaaaaaaegiocaaaadaaaaaa
acaaaaaakgbkbaaaaaaaaaaaegaobaaaaaaaaaaadcaaaaakpcaabaaaaaaaaaaa
egiocaaaadaaaaaaadaaaaaapgbpbaaaaaaaaaaaegaobaaaaaaaaaaadgaaaaaf
pccabaaaaaaaaaaaegaobaaaaaaaaaaadcaaaaaldccabaaaabaaaaaaegbabaaa
adaaaaaaegiacaaaaaaaaaaaaiaaaaaaogikcaaaaaaaaaaaaiaaaaaadcaaaaal
mccabaaaabaaaaaaagbebaaaadaaaaaaagiecaaaaaaaaaaaajaaaaaakgiocaaa
aaaaaaaaajaaaaaadiaaaaahhcaabaaaabaaaaaajgbebaaaabaaaaaacgbjbaaa
acaaaaaadcaaaaakhcaabaaaabaaaaaajgbebaaaacaaaaaacgbjbaaaabaaaaaa
egacbaiaebaaaaaaabaaaaaadiaaaaahhcaabaaaabaaaaaaegacbaaaabaaaaaa
pgbpbaaaabaaaaaadgaaaaagbcaabaaaacaaaaaaakiacaaaadaaaaaaaiaaaaaa
dgaaaaagccaabaaaacaaaaaaakiacaaaadaaaaaaajaaaaaadgaaaaagecaabaaa
acaaaaaaakiacaaaadaaaaaaakaaaaaabaaaaaahcccabaaaacaaaaaaegacbaaa
abaaaaaaegacbaaaacaaaaaabaaaaaahbccabaaaacaaaaaaegbcbaaaabaaaaaa
egacbaaaacaaaaaabaaaaaaheccabaaaacaaaaaaegbcbaaaacaaaaaaegacbaaa
acaaaaaadgaaaaagbcaabaaaacaaaaaabkiacaaaadaaaaaaaiaaaaaadgaaaaag
ccaabaaaacaaaaaabkiacaaaadaaaaaaajaaaaaadgaaaaagecaabaaaacaaaaaa
bkiacaaaadaaaaaaakaaaaaabaaaaaahcccabaaaadaaaaaaegacbaaaabaaaaaa
egacbaaaacaaaaaabaaaaaahbccabaaaadaaaaaaegbcbaaaabaaaaaaegacbaaa
acaaaaaabaaaaaaheccabaaaadaaaaaaegbcbaaaacaaaaaaegacbaaaacaaaaaa
diaaaaajhcaabaaaacaaaaaafgifcaaaacaaaaaaaaaaaaaaegiccaaaadaaaaaa
bbaaaaaadcaaaaalhcaabaaaacaaaaaaegiccaaaadaaaaaabaaaaaaaagiacaaa
acaaaaaaaaaaaaaaegacbaaaacaaaaaadcaaaaalhcaabaaaacaaaaaaegiccaaa
adaaaaaabcaaaaaakgikcaaaacaaaaaaaaaaaaaaegacbaaaacaaaaaadcaaaaal
hcaabaaaacaaaaaaegiccaaaadaaaaaabdaaaaaapgipcaaaacaaaaaaaaaaaaaa
egacbaaaacaaaaaabaaaaaahcccabaaaaeaaaaaaegacbaaaabaaaaaaegacbaaa
acaaaaaabaaaaaahbccabaaaaeaaaaaaegbcbaaaabaaaaaaegacbaaaacaaaaaa
baaaaaaheccabaaaaeaaaaaaegbcbaaaacaaaaaaegacbaaaacaaaaaadiaaaaai
hcaabaaaabaaaaaaegbcbaaaacaaaaaapgipcaaaadaaaaaabeaaaaaadiaaaaai
hcaabaaaacaaaaaafgafbaaaabaaaaaaegiccaaaadaaaaaaanaaaaaadcaaaaak
lcaabaaaabaaaaaaegiicaaaadaaaaaaamaaaaaaagaabaaaabaaaaaaegaibaaa
acaaaaaadcaaaaakhcaabaaaabaaaaaaegiccaaaadaaaaaaaoaaaaaakgakbaaa
abaaaaaaegadbaaaabaaaaaadgaaaaaficaabaaaabaaaaaaabeaaaaaaaaaiadp
bbaaaaaibcaabaaaacaaaaaaegiocaaaacaaaaaabcaaaaaaegaobaaaabaaaaaa
bbaaaaaiccaabaaaacaaaaaaegiocaaaacaaaaaabdaaaaaaegaobaaaabaaaaaa
bbaaaaaiecaabaaaacaaaaaaegiocaaaacaaaaaabeaaaaaaegaobaaaabaaaaaa
diaaaaahpcaabaaaadaaaaaajgacbaaaabaaaaaaegakbaaaabaaaaaabbaaaaai
bcaabaaaaeaaaaaaegiocaaaacaaaaaabfaaaaaaegaobaaaadaaaaaabbaaaaai
ccaabaaaaeaaaaaaegiocaaaacaaaaaabgaaaaaaegaobaaaadaaaaaabbaaaaai
ecaabaaaaeaaaaaaegiocaaaacaaaaaabhaaaaaaegaobaaaadaaaaaaaaaaaaah
hcaabaaaacaaaaaaegacbaaaacaaaaaaegacbaaaaeaaaaaadiaaaaahccaabaaa
abaaaaaabkaabaaaabaaaaaabkaabaaaabaaaaaadcaaaaakbcaabaaaabaaaaaa
akaabaaaabaaaaaaakaabaaaabaaaaaabkaabaiaebaaaaaaabaaaaaadcaaaaak
hccabaaaafaaaaaaegiccaaaacaaaaaabiaaaaaaagaabaaaabaaaaaaegacbaaa
acaaaaaadiaaaaaiccaabaaaaaaaaaaabkaabaaaaaaaaaaaakiacaaaabaaaaaa
afaaaaaadiaaaaakncaabaaaabaaaaaaagahbaaaaaaaaaaaaceaaaaaaaaaaadp
aaaaaaaaaaaaaadpaaaaaadpdgaaaaafmccabaaaagaaaaaakgaobaaaaaaaaaaa
aaaaaaahdccabaaaagaaaaaakgakbaaaabaaaaaamgaabaaaabaaaaaadoaaaaab
"
}

SubProgram "gles " {
Keywords { "DIRECTIONAL" "LIGHTMAP_OFF" "DIRLIGHTMAP_OFF" "SHADOWS_SCREEN" }
"!!GLES
#define SHADER_API_GLES 1
#define tex2D texture2D


#ifdef VERTEX
#define gl_ModelViewProjectionMatrix glstate_matrix_mvp
uniform mat4 glstate_matrix_mvp;
#define gl_ModelViewMatrixInverseTranspose glstate_matrix_invtrans_modelview0
uniform mat4 glstate_matrix_invtrans_modelview0;
#define gl_ModelViewMatrix glstate_matrix_modelview0
uniform mat4 glstate_matrix_modelview0;

varying highp vec4 xlv_TEXCOORD5;
varying lowp vec3 xlv_TEXCOORD4;
varying lowp vec3 xlv_TEXCOORD3;
varying highp vec3 xlv_TEXCOORD2;
varying highp vec3 xlv_TEXCOORD1;
varying highp vec4 xlv_TEXCOORD0;
uniform highp vec4 _BumpMap_ST;
uniform highp vec4 _MainTex_ST;
uniform highp vec4 unity_Scale;
uniform highp mat4 _World2Object;
uniform highp mat4 _Object2World;


uniform highp mat4 unity_World2Shadow[4];
uniform highp vec4 unity_SHC;
uniform highp vec4 unity_SHBb;
uniform highp vec4 unity_SHBg;
uniform highp vec4 unity_SHBr;
uniform highp vec4 unity_SHAb;
uniform highp vec4 unity_SHAg;
uniform highp vec4 unity_SHAr;
uniform lowp vec4 _WorldSpaceLightPos0;
attribute vec4 _glesTANGENT;
attribute vec4 _glesMultiTexCoord0;
attribute vec3 _glesNormal;
attribute vec4 _glesVertex;
void main ()
{
  vec4 tmpvar_1;
  tmpvar_1.xyz = normalize(_glesTANGENT.xyz);
  tmpvar_1.w = _glesTANGENT.w;
  vec3 tmpvar_2;
  tmpvar_2 = normalize(_glesNormal);
  highp vec3 shlight_3;
  highp vec4 tmpvar_4;
  lowp vec3 tmpvar_5;
  lowp vec3 tmpvar_6;
  highp vec3 tmpvar_7;
  highp vec3 tmpvar_8;
  tmpvar_7 = tmpvar_1.xyz;
  tmpvar_8 = (((tmpvar_2.yzx * tmpvar_1.zxy) - (tmpvar_2.zxy * tmpvar_1.yzx)) * _glesTANGENT.w);
  highp mat3 tmpvar_9;
  tmpvar_9[0].x = tmpvar_7.x;
  tmpvar_9[0].y = tmpvar_8.x;
  tmpvar_9[0].z = tmpvar_2.x;
  tmpvar_9[1].x = tmpvar_7.y;
  tmpvar_9[1].y = tmpvar_8.y;
  tmpvar_9[1].z = tmpvar_2.y;
  tmpvar_9[2].x = tmpvar_7.z;
  tmpvar_9[2].y = tmpvar_8.z;
  tmpvar_9[2].z = tmpvar_2.z;
  vec4 v_10;
  v_10.x = gl_ModelViewMatrixInverseTranspose[0].x;
  v_10.y = gl_ModelViewMatrixInverseTranspose[1].x;
  v_10.z = gl_ModelViewMatrixInverseTranspose[2].x;
  v_10.w = gl_ModelViewMatrixInverseTranspose[3].x;
  vec4 v_11;
  v_11.x = gl_ModelViewMatrixInverseTranspose[0].y;
  v_11.y = gl_ModelViewMatrixInverseTranspose[1].y;
  v_11.z = gl_ModelViewMatrixInverseTranspose[2].y;
  v_11.w = gl_ModelViewMatrixInverseTranspose[3].y;
  tmpvar_4.xy = ((_glesMultiTexCoord0.xy * _MainTex_ST.xy) + _MainTex_ST.zw);
  tmpvar_4.zw = ((_glesMultiTexCoord0.xy * _BumpMap_ST.xy) + _BumpMap_ST.zw);
  mat3 tmpvar_12;
  tmpvar_12[0] = _Object2World[0].xyz;
  tmpvar_12[1] = _Object2World[1].xyz;
  tmpvar_12[2] = _Object2World[2].xyz;
  highp vec3 tmpvar_13;
  highp vec3 tmpvar_14;
  tmpvar_13 = tmpvar_1.xyz;
  tmpvar_14 = (((tmpvar_2.yzx * tmpvar_1.zxy) - (tmpvar_2.zxy * tmpvar_1.yzx)) * _glesTANGENT.w);
  highp mat3 tmpvar_15;
  tmpvar_15[0].x = tmpvar_13.x;
  tmpvar_15[0].y = tmpvar_14.x;
  tmpvar_15[0].z = tmpvar_2.x;
  tmpvar_15[1].x = tmpvar_13.y;
  tmpvar_15[1].y = tmpvar_14.y;
  tmpvar_15[1].z = tmpvar_2.y;
  tmpvar_15[2].x = tmpvar_13.z;
  tmpvar_15[2].y = tmpvar_14.z;
  tmpvar_15[2].z = tmpvar_2.z;
  highp vec3 tmpvar_16;
  tmpvar_16 = (tmpvar_15 * (_World2Object * _WorldSpaceLightPos0).xyz);
  tmpvar_5 = tmpvar_16;
  highp vec4 tmpvar_17;
  tmpvar_17.w = 1.0;
  tmpvar_17.xyz = (tmpvar_12 * (tmpvar_2 * unity_Scale.w));
  mediump vec3 tmpvar_18;
  mediump vec4 normal_19;
  normal_19 = tmpvar_17;
  highp float vC_20;
  mediump vec3 x3_21;
  mediump vec3 x2_22;
  mediump vec3 x1_23;
  highp float tmpvar_24;
  tmpvar_24 = dot (unity_SHAr, normal_19);
  x1_23.x = tmpvar_24;
  highp float tmpvar_25;
  tmpvar_25 = dot (unity_SHAg, normal_19);
  x1_23.y = tmpvar_25;
  highp float tmpvar_26;
  tmpvar_26 = dot (unity_SHAb, normal_19);
  x1_23.z = tmpvar_26;
  mediump vec4 tmpvar_27;
  tmpvar_27 = (normal_19.xyzz * normal_19.yzzx);
  highp float tmpvar_28;
  tmpvar_28 = dot (unity_SHBr, tmpvar_27);
  x2_22.x = tmpvar_28;
  highp float tmpvar_29;
  tmpvar_29 = dot (unity_SHBg, tmpvar_27);
  x2_22.y = tmpvar_29;
  highp float tmpvar_30;
  tmpvar_30 = dot (unity_SHBb, tmpvar_27);
  x2_22.z = tmpvar_30;
  mediump float tmpvar_31;
  tmpvar_31 = ((normal_19.x * normal_19.x) - (normal_19.y * normal_19.y));
  vC_20 = tmpvar_31;
  highp vec3 tmpvar_32;
  tmpvar_32 = (unity_SHC.xyz * vC_20);
  x3_21 = tmpvar_32;
  tmpvar_18 = ((x1_23 + x2_22) + x3_21);
  shlight_3 = tmpvar_18;
  tmpvar_6 = shlight_3;
  gl_Position = (gl_ModelViewProjectionMatrix * _glesVertex);
  xlv_TEXCOORD0 = tmpvar_4;
  xlv_TEXCOORD1 = (tmpvar_9 * v_10.xyz);
  xlv_TEXCOORD2 = (tmpvar_9 * v_11.xyz);
  xlv_TEXCOORD3 = tmpvar_5;
  xlv_TEXCOORD4 = tmpvar_6;
  xlv_TEXCOORD5 = (unity_World2Shadow[0] * (_Object2World * _glesVertex));
}



#endif
#ifdef FRAGMENT

varying highp vec4 xlv_TEXCOORD5;
varying lowp vec3 xlv_TEXCOORD4;
varying lowp vec3 xlv_TEXCOORD3;
varying highp vec3 xlv_TEXCOORD2;
varying highp vec3 xlv_TEXCOORD1;
varying highp vec4 xlv_TEXCOORD0;
uniform lowp float _Cutoff;
uniform sampler2D _Shade;
uniform sampler2D _BumpMap;
uniform sampler2D _MainTex;
uniform lowp vec4 _Color;
uniform sampler2D _ShadowMapTexture;
uniform lowp vec4 _LightColor0;
uniform highp vec4 _LightShadowData;
void main ()
{
  lowp vec4 c_1;
  lowp vec3 tmpvar_2;
  highp vec3 matcap_3;
  lowp vec3 tmpvar_4;
  tmpvar_4 = ((texture2D (_BumpMap, xlv_TEXCOORD0.zw).xyz * 2.0) - 1.0);
  lowp vec3 tmpvar_5;
  tmpvar_5 = (texture2D (_MainTex, xlv_TEXCOORD0.xy).xyz * _Color.w);
  highp vec2 tmpvar_6;
  tmpvar_6.x = dot (xlv_TEXCOORD1, tmpvar_4);
  tmpvar_6.y = dot (xlv_TEXCOORD2, tmpvar_4);
  highp vec2 P_7;
  P_7 = ((tmpvar_6 * 0.5) + 0.5);
  lowp vec3 tmpvar_8;
  tmpvar_8 = texture2D (_Shade, P_7).xyz;
  matcap_3 = tmpvar_8;
  lowp vec4 tmpvar_9;
  tmpvar_9 = texture2D (_MainTex, xlv_TEXCOORD0.xy);
  highp vec3 tmpvar_10;
  tmpvar_10 = (((matcap_3 * tmpvar_9.xyz) * _Color.xyz) * 3.0);
  tmpvar_2 = tmpvar_10;
  lowp vec4 tmpvar_11;
  tmpvar_11 = texture2D (_MainTex, xlv_TEXCOORD0.xy);
  lowp float tmpvar_12;
  tmpvar_12 = tmpvar_11.w;
  lowp float x_13;
  x_13 = (tmpvar_11.w - _Cutoff);
  if ((x_13 < 0.0)) {
    discard;
  };
  lowp float tmpvar_14;
  mediump float lightShadowDataX_15;
  highp float dist_16;
  lowp float tmpvar_17;
  tmpvar_17 = texture2DProj (_ShadowMapTexture, xlv_TEXCOORD5).x;
  dist_16 = tmpvar_17;
  highp float tmpvar_18;
  tmpvar_18 = _LightShadowData.x;
  lightShadowDataX_15 = tmpvar_18;
  highp float tmpvar_19;
  tmpvar_19 = max (float((dist_16 > (xlv_TEXCOORD5.z / xlv_TEXCOORD5.w))), lightShadowDataX_15);
  tmpvar_14 = tmpvar_19;
  lowp vec4 c_20;
  c_20.xyz = ((tmpvar_5 * _LightColor0.xyz) * ((max (0.0, dot (tmpvar_4, xlv_TEXCOORD3)) * tmpvar_14) * 2.0));
  c_20.w = tmpvar_12;
  c_1.w = c_20.w;
  c_1.xyz = (c_20.xyz + (tmpvar_5 * xlv_TEXCOORD4));
  c_1.xyz = (c_1.xyz + tmpvar_2);
  c_1.w = tmpvar_12;
  gl_FragData[0] = c_1;
}



#endif"
}

SubProgram "glesdesktop " {
Keywords { "DIRECTIONAL" "LIGHTMAP_OFF" "DIRLIGHTMAP_OFF" "SHADOWS_SCREEN" }
"!!GLES
#define SHADER_API_GLES 1
#define tex2D texture2D


#ifdef VERTEX
#define gl_ModelViewProjectionMatrix glstate_matrix_mvp
uniform mat4 glstate_matrix_mvp;
#define gl_ModelViewMatrixInverseTranspose glstate_matrix_invtrans_modelview0
uniform mat4 glstate_matrix_invtrans_modelview0;
#define gl_ModelViewMatrix glstate_matrix_modelview0
uniform mat4 glstate_matrix_modelview0;

varying highp vec4 xlv_TEXCOORD5;
varying lowp vec3 xlv_TEXCOORD4;
varying lowp vec3 xlv_TEXCOORD3;
varying highp vec3 xlv_TEXCOORD2;
varying highp vec3 xlv_TEXCOORD1;
varying highp vec4 xlv_TEXCOORD0;
uniform highp vec4 _BumpMap_ST;
uniform highp vec4 _MainTex_ST;
uniform highp vec4 unity_Scale;
uniform highp mat4 _World2Object;
uniform highp mat4 _Object2World;


uniform highp vec4 unity_SHC;
uniform highp vec4 unity_SHBb;
uniform highp vec4 unity_SHBg;
uniform highp vec4 unity_SHBr;
uniform highp vec4 unity_SHAb;
uniform highp vec4 unity_SHAg;
uniform highp vec4 unity_SHAr;
uniform lowp vec4 _WorldSpaceLightPos0;
uniform highp vec4 _ProjectionParams;
attribute vec4 _glesTANGENT;
attribute vec4 _glesMultiTexCoord0;
attribute vec3 _glesNormal;
attribute vec4 _glesVertex;
void main ()
{
  vec4 tmpvar_1;
  tmpvar_1.xyz = normalize(_glesTANGENT.xyz);
  tmpvar_1.w = _glesTANGENT.w;
  vec3 tmpvar_2;
  tmpvar_2 = normalize(_glesNormal);
  highp vec3 shlight_3;
  highp vec4 tmpvar_4;
  lowp vec3 tmpvar_5;
  lowp vec3 tmpvar_6;
  highp vec3 tmpvar_7;
  highp vec3 tmpvar_8;
  tmpvar_7 = tmpvar_1.xyz;
  tmpvar_8 = (((tmpvar_2.yzx * tmpvar_1.zxy) - (tmpvar_2.zxy * tmpvar_1.yzx)) * _glesTANGENT.w);
  highp mat3 tmpvar_9;
  tmpvar_9[0].x = tmpvar_7.x;
  tmpvar_9[0].y = tmpvar_8.x;
  tmpvar_9[0].z = tmpvar_2.x;
  tmpvar_9[1].x = tmpvar_7.y;
  tmpvar_9[1].y = tmpvar_8.y;
  tmpvar_9[1].z = tmpvar_2.y;
  tmpvar_9[2].x = tmpvar_7.z;
  tmpvar_9[2].y = tmpvar_8.z;
  tmpvar_9[2].z = tmpvar_2.z;
  vec4 v_10;
  v_10.x = gl_ModelViewMatrixInverseTranspose[0].x;
  v_10.y = gl_ModelViewMatrixInverseTranspose[1].x;
  v_10.z = gl_ModelViewMatrixInverseTranspose[2].x;
  v_10.w = gl_ModelViewMatrixInverseTranspose[3].x;
  vec4 v_11;
  v_11.x = gl_ModelViewMatrixInverseTranspose[0].y;
  v_11.y = gl_ModelViewMatrixInverseTranspose[1].y;
  v_11.z = gl_ModelViewMatrixInverseTranspose[2].y;
  v_11.w = gl_ModelViewMatrixInverseTranspose[3].y;
  highp vec4 tmpvar_12;
  tmpvar_12 = (gl_ModelViewProjectionMatrix * _glesVertex);
  tmpvar_4.xy = ((_glesMultiTexCoord0.xy * _MainTex_ST.xy) + _MainTex_ST.zw);
  tmpvar_4.zw = ((_glesMultiTexCoord0.xy * _BumpMap_ST.xy) + _BumpMap_ST.zw);
  mat3 tmpvar_13;
  tmpvar_13[0] = _Object2World[0].xyz;
  tmpvar_13[1] = _Object2World[1].xyz;
  tmpvar_13[2] = _Object2World[2].xyz;
  highp vec3 tmpvar_14;
  highp vec3 tmpvar_15;
  tmpvar_14 = tmpvar_1.xyz;
  tmpvar_15 = (((tmpvar_2.yzx * tmpvar_1.zxy) - (tmpvar_2.zxy * tmpvar_1.yzx)) * _glesTANGENT.w);
  highp mat3 tmpvar_16;
  tmpvar_16[0].x = tmpvar_14.x;
  tmpvar_16[0].y = tmpvar_15.x;
  tmpvar_16[0].z = tmpvar_2.x;
  tmpvar_16[1].x = tmpvar_14.y;
  tmpvar_16[1].y = tmpvar_15.y;
  tmpvar_16[1].z = tmpvar_2.y;
  tmpvar_16[2].x = tmpvar_14.z;
  tmpvar_16[2].y = tmpvar_15.z;
  tmpvar_16[2].z = tmpvar_2.z;
  highp vec3 tmpvar_17;
  tmpvar_17 = (tmpvar_16 * (_World2Object * _WorldSpaceLightPos0).xyz);
  tmpvar_5 = tmpvar_17;
  highp vec4 tmpvar_18;
  tmpvar_18.w = 1.0;
  tmpvar_18.xyz = (tmpvar_13 * (tmpvar_2 * unity_Scale.w));
  mediump vec3 tmpvar_19;
  mediump vec4 normal_20;
  normal_20 = tmpvar_18;
  highp float vC_21;
  mediump vec3 x3_22;
  mediump vec3 x2_23;
  mediump vec3 x1_24;
  highp float tmpvar_25;
  tmpvar_25 = dot (unity_SHAr, normal_20);
  x1_24.x = tmpvar_25;
  highp float tmpvar_26;
  tmpvar_26 = dot (unity_SHAg, normal_20);
  x1_24.y = tmpvar_26;
  highp float tmpvar_27;
  tmpvar_27 = dot (unity_SHAb, normal_20);
  x1_24.z = tmpvar_27;
  mediump vec4 tmpvar_28;
  tmpvar_28 = (normal_20.xyzz * normal_20.yzzx);
  highp float tmpvar_29;
  tmpvar_29 = dot (unity_SHBr, tmpvar_28);
  x2_23.x = tmpvar_29;
  highp float tmpvar_30;
  tmpvar_30 = dot (unity_SHBg, tmpvar_28);
  x2_23.y = tmpvar_30;
  highp float tmpvar_31;
  tmpvar_31 = dot (unity_SHBb, tmpvar_28);
  x2_23.z = tmpvar_31;
  mediump float tmpvar_32;
  tmpvar_32 = ((normal_20.x * normal_20.x) - (normal_20.y * normal_20.y));
  vC_21 = tmpvar_32;
  highp vec3 tmpvar_33;
  tmpvar_33 = (unity_SHC.xyz * vC_21);
  x3_22 = tmpvar_33;
  tmpvar_19 = ((x1_24 + x2_23) + x3_22);
  shlight_3 = tmpvar_19;
  tmpvar_6 = shlight_3;
  highp vec4 o_34;
  highp vec4 tmpvar_35;
  tmpvar_35 = (tmpvar_12 * 0.5);
  highp vec2 tmpvar_36;
  tmpvar_36.x = tmpvar_35.x;
  tmpvar_36.y = (tmpvar_35.y * _ProjectionParams.x);
  o_34.xy = (tmpvar_36 + tmpvar_35.w);
  o_34.zw = tmpvar_12.zw;
  gl_Position = tmpvar_12;
  xlv_TEXCOORD0 = tmpvar_4;
  xlv_TEXCOORD1 = (tmpvar_9 * v_10.xyz);
  xlv_TEXCOORD2 = (tmpvar_9 * v_11.xyz);
  xlv_TEXCOORD3 = tmpvar_5;
  xlv_TEXCOORD4 = tmpvar_6;
  xlv_TEXCOORD5 = o_34;
}



#endif
#ifdef FRAGMENT

varying highp vec4 xlv_TEXCOORD5;
varying lowp vec3 xlv_TEXCOORD4;
varying lowp vec3 xlv_TEXCOORD3;
varying highp vec3 xlv_TEXCOORD2;
varying highp vec3 xlv_TEXCOORD1;
varying highp vec4 xlv_TEXCOORD0;
uniform lowp float _Cutoff;
uniform sampler2D _Shade;
uniform sampler2D _BumpMap;
uniform sampler2D _MainTex;
uniform lowp vec4 _Color;
uniform sampler2D _ShadowMapTexture;
uniform lowp vec4 _LightColor0;
void main ()
{
  lowp vec4 c_1;
  lowp vec3 tmpvar_2;
  highp vec3 matcap_3;
  lowp vec3 normal_4;
  normal_4.xy = ((texture2D (_BumpMap, xlv_TEXCOORD0.zw).wy * 2.0) - 1.0);
  normal_4.z = sqrt(((1.0 - (normal_4.x * normal_4.x)) - (normal_4.y * normal_4.y)));
  lowp vec3 tmpvar_5;
  tmpvar_5 = (texture2D (_MainTex, xlv_TEXCOORD0.xy).xyz * _Color.w);
  highp vec2 tmpvar_6;
  tmpvar_6.x = dot (xlv_TEXCOORD1, normal_4);
  tmpvar_6.y = dot (xlv_TEXCOORD2, normal_4);
  highp vec2 P_7;
  P_7 = ((tmpvar_6 * 0.5) + 0.5);
  lowp vec3 tmpvar_8;
  tmpvar_8 = texture2D (_Shade, P_7).xyz;
  matcap_3 = tmpvar_8;
  lowp vec4 tmpvar_9;
  tmpvar_9 = texture2D (_MainTex, xlv_TEXCOORD0.xy);
  highp vec3 tmpvar_10;
  tmpvar_10 = (((matcap_3 * tmpvar_9.xyz) * _Color.xyz) * 3.0);
  tmpvar_2 = tmpvar_10;
  lowp vec4 tmpvar_11;
  tmpvar_11 = texture2D (_MainTex, xlv_TEXCOORD0.xy);
  lowp float tmpvar_12;
  tmpvar_12 = tmpvar_11.w;
  lowp float x_13;
  x_13 = (tmpvar_11.w - _Cutoff);
  if ((x_13 < 0.0)) {
    discard;
  };
  lowp vec4 c_14;
  c_14.xyz = ((tmpvar_5 * _LightColor0.xyz) * ((max (0.0, dot (normal_4, xlv_TEXCOORD3)) * texture2DProj (_ShadowMapTexture, xlv_TEXCOORD5).x) * 2.0));
  c_14.w = tmpvar_12;
  c_1.w = c_14.w;
  c_1.xyz = (c_14.xyz + (tmpvar_5 * xlv_TEXCOORD4));
  c_1.xyz = (c_1.xyz + tmpvar_2);
  c_1.w = tmpvar_12;
  gl_FragData[0] = c_1;
}



#endif"
}

SubProgram "flash " {
Keywords { "DIRECTIONAL" "LIGHTMAP_OFF" "DIRLIGHTMAP_OFF" "SHADOWS_SCREEN" }
Bind "vertex" Vertex
Bind "tangent" TexCoord2
Bind "normal" Normal
Bind "texcoord" TexCoord0
Matrix 0 [glstate_matrix_mvp]
Matrix 4 [glstate_matrix_invtrans_modelview0]
Vector 16 [_ProjectionParams]
Vector 17 [_WorldSpaceLightPos0]
Vector 18 [unity_SHAr]
Vector 19 [unity_SHAg]
Vector 20 [unity_SHAb]
Vector 21 [unity_SHBr]
Vector 22 [unity_SHBg]
Vector 23 [unity_SHBb]
Vector 24 [unity_SHC]
Matrix 8 [_Object2World]
Matrix 12 [_World2Object]
Vector 25 [unity_Scale]
Vector 26 [unity_NPOTScale]
Vector 27 [_MainTex_ST]
Vector 28 [_BumpMap_ST]
"agal_vs
c29 1.0 0.5 0.0 0.0
[bc]
adaaaaaaabaaahacabaaaaoeaaaaaaaabjaaaappabaaaaaa mul r1.xyz, a1, c25.w
bcaaaaaaacaaaiacabaaaakeacaaaaaaajaaaaoeabaaaaaa dp3 r2.w, r1.xyzz, c9
bcaaaaaaaaaaabacabaaaakeacaaaaaaaiaaaaoeabaaaaaa dp3 r0.x, r1.xyzz, c8
bcaaaaaaaaaaaeacabaaaakeacaaaaaaakaaaaoeabaaaaaa dp3 r0.z, r1.xyzz, c10
aaaaaaaaaaaaacacacaaaappacaaaaaaaaaaaaaaaaaaaaaa mov r0.y, r2.w
adaaaaaaabaaapacaaaaaakeacaaaaaaaaaaaacjacaaaaaa mul r1, r0.xyzz, r0.yzzx
aaaaaaaaaaaaaiacbnaaaaaaabaaaaaaaaaaaaaaaaaaaaaa mov r0.w, c29.x
bdaaaaaaacaaaeacaaaaaaoeacaaaaaabeaaaaoeabaaaaaa dp4 r2.z, r0, c20
bdaaaaaaacaaacacaaaaaaoeacaaaaaabdaaaaoeabaaaaaa dp4 r2.y, r0, c19
bdaaaaaaacaaabacaaaaaaoeacaaaaaabcaaaaoeabaaaaaa dp4 r2.x, r0, c18
adaaaaaaaaaaacacacaaaappacaaaaaaacaaaappacaaaaaa mul r0.y, r2.w, r2.w
bdaaaaaaadaaaeacabaaaaoeacaaaaaabhaaaaoeabaaaaaa dp4 r3.z, r1, c23
bdaaaaaaadaaacacabaaaaoeacaaaaaabgaaaaoeabaaaaaa dp4 r3.y, r1, c22
bdaaaaaaadaaabacabaaaaoeacaaaaaabfaaaaoeabaaaaaa dp4 r3.x, r1, c21
adaaaaaaadaaaiacaaaaaaaaacaaaaaaaaaaaaaaacaaaaaa mul r3.w, r0.x, r0.x
acaaaaaaaaaaabacadaaaappacaaaaaaaaaaaaffacaaaaaa sub r0.x, r3.w, r0.y
adaaaaaaabaaahacaaaaaaaaacaaaaaabiaaaaoeabaaaaaa mul r1.xyz, r0.x, c24
abaaaaaaacaaahacacaaaakeacaaaaaaadaaaakeacaaaaaa add r2.xyz, r2.xyzz, r3.xyzz
aaaaaaaaaaaaahacafaaaaoeaaaaaaaaaaaaaaaaaaaaaaaa mov r0.xyz, a5
abaaaaaaaeaaahaeacaaaakeacaaaaaaabaaaakeacaaaaaa add v4.xyz, r2.xyzz, r1.xyzz
adaaaaaaabaaahacabaaaancaaaaaaaaaaaaaaajacaaaaaa mul r1.xyz, a1.zxyw, r0.yzxx
aaaaaaaaaaaaahacafaaaaoeaaaaaaaaaaaaaaaaaaaaaaaa mov r0.xyz, a5
adaaaaaaaeaaahacabaaaamjaaaaaaaaaaaaaafcacaaaaaa mul r4.xyz, a1.yzxw, r0.zxyy
acaaaaaaabaaahacaeaaaakeacaaaaaaabaaaakeacaaaaaa sub r1.xyz, r4.xyzz, r1.xyzz
adaaaaaaacaaahacabaaaakeacaaaaaaafaaaappaaaaaaaa mul r2.xyz, r1.xyzz, a5.w
aaaaaaaaaaaaapacaoaaaaoeabaaaaaaaaaaaaaaaaaaaaaa mov r0, c14
bdaaaaaaadaaaeacbbaaaaoeabaaaaaaaaaaaaoeacaaaaaa dp4 r3.z, c17, r0
aaaaaaaaaaaaapacanaaaaoeabaaaaaaaaaaaaaaaaaaaaaa mov r0, c13
bdaaaaaaadaaacacbbaaaaoeabaaaaaaaaaaaaoeacaaaaaa dp4 r3.y, c17, r0
aaaaaaaaabaaapacamaaaaoeabaaaaaaaaaaaaaaaaaaaaaa mov r1, c12
bdaaaaaaadaaabacbbaaaaoeabaaaaaaabaaaaoeacaaaaaa dp4 r3.x, c17, r1
bdaaaaaaaaaaaiacaaaaaaoeaaaaaaaaadaaaaoeabaaaaaa dp4 r0.w, a0, c3
bdaaaaaaaaaaaeacaaaaaaoeaaaaaaaaacaaaaoeabaaaaaa dp4 r0.z, a0, c2
bdaaaaaaaaaaabacaaaaaaoeaaaaaaaaaaaaaaoeabaaaaaa dp4 r0.x, a0, c0
bdaaaaaaaaaaacacaaaaaaoeaaaaaaaaabaaaaoeabaaaaaa dp4 r0.y, a0, c1
adaaaaaaabaaahacaaaaaapeacaaaaaabnaaaaffabaaaaaa mul r1.xyz, r0.xyww, c29.y
adaaaaaaabaaacacabaaaaffacaaaaaabaaaaaaaabaaaaaa mul r1.y, r1.y, c16.x
abaaaaaaabaaadacabaaaafeacaaaaaaabaaaakkacaaaaaa add r1.xy, r1.xyyy, r1.z
bcaaaaaaadaaacaeacaaaakeacaaaaaaadaaaakeacaaaaaa dp3 v3.y, r2.xyzz, r3.xyzz
bcaaaaaaabaaacaeacaaaakeacaaaaaaaeaaaaoeabaaaaaa dp3 v1.y, r2.xyzz, c4
bcaaaaaaacaaacaeacaaaakeacaaaaaaafaaaaoeabaaaaaa dp3 v2.y, r2.xyzz, c5
bcaaaaaaadaaaeaeabaaaaoeaaaaaaaaadaaaakeacaaaaaa dp3 v3.z, a1, r3.xyzz
bcaaaaaaadaaabaeafaaaaoeaaaaaaaaadaaaakeacaaaaaa dp3 v3.x, a5, r3.xyzz
adaaaaaaafaaadaeabaaaafeacaaaaaabkaaaaoeabaaaaaa mul v5.xy, r1.xyyy, c26
aaaaaaaaaaaaapadaaaaaaoeacaaaaaaaaaaaaaaaaaaaaaa mov o0, r0
aaaaaaaaafaaamaeaaaaaaopacaaaaaaaaaaaaaaaaaaaaaa mov v5.zw, r0.wwzw
adaaaaaaaeaaamacadaaaaeeaaaaaaaabmaaaaeeabaaaaaa mul r4.zw, a3.xyxy, c28.xyxy
abaaaaaaaaaaamaeaeaaaaopacaaaaaabmaaaaoeabaaaaaa add v0.zw, r4.wwzw, c28
adaaaaaaaeaaadacadaaaaoeaaaaaaaablaaaaoeabaaaaaa mul r4.xy, a3, c27
abaaaaaaaaaaadaeaeaaaafeacaaaaaablaaaaooabaaaaaa add v0.xy, r4.xyyy, c27.zwzw
bcaaaaaaabaaaeaeabaaaaoeaaaaaaaaaeaaaaoeabaaaaaa dp3 v1.z, a1, c4
bcaaaaaaabaaabaeafaaaaoeaaaaaaaaaeaaaaoeabaaaaaa dp3 v1.x, a5, c4
bcaaaaaaacaaaeaeabaaaaoeaaaaaaaaafaaaaoeabaaaaaa dp3 v2.z, a1, c5
bcaaaaaaacaaabaeafaaaaoeaaaaaaaaafaaaaoeabaaaaaa dp3 v2.x, a5, c5
aaaaaaaaabaaaiaeaaaaaaoeabaaaaaaaaaaaaaaaaaaaaaa mov v1.w, c0
aaaaaaaaacaaaiaeaaaaaaoeabaaaaaaaaaaaaaaaaaaaaaa mov v2.w, c0
aaaaaaaaadaaaiaeaaaaaaoeabaaaaaaaaaaaaaaaaaaaaaa mov v3.w, c0
aaaaaaaaaeaaaiaeaaaaaaoeabaaaaaaaaaaaaaaaaaaaaaa mov v4.w, c0
"
}

SubProgram "opengl " {
Keywords { "DIRECTIONAL" "LIGHTMAP_ON" "DIRLIGHTMAP_OFF" "SHADOWS_SCREEN" }
Bind "vertex" Vertex
Bind "tangent" ATTR14
Bind "normal" Normal
Bind "texcoord" TexCoord0
Bind "texcoord1" TexCoord1
Vector 17 [_ProjectionParams]
Vector 19 [unity_LightmapST]
Vector 20 [_MainTex_ST]
Vector 21 [_BumpMap_ST]
"!!ARBvp1.0
# 22 ALU
PARAM c[22] = { { 0.5 },
		state.matrix.mvp,
		state.matrix.modelview[0].invtrans,
		program.local[9..21] };
TEMP R0;
TEMP R1;
TEMP R2;
MOV R0.xyz, vertex.attrib[14];
MUL R1.xyz, vertex.normal.zxyw, R0.yzxw;
MAD R0.xyz, vertex.normal.yzxw, R0.zxyw, -R1;
MUL R2.xyz, R0, vertex.attrib[14].w;
DP4 R0.w, vertex.position, c[4];
DP4 R0.z, vertex.position, c[3];
DP4 R0.x, vertex.position, c[1];
DP4 R0.y, vertex.position, c[2];
MUL R1.xyz, R0.xyww, c[0].x;
MUL R1.y, R1, c[17].x;
DP3 result.texcoord[1].y, R2, c[5];
DP3 result.texcoord[2].y, R2, c[6];
ADD result.texcoord[4].xy, R1, R1.z;
MOV result.position, R0;
MOV result.texcoord[4].zw, R0;
MAD result.texcoord[0].zw, vertex.texcoord[0].xyxy, c[21].xyxy, c[21];
MAD result.texcoord[0].xy, vertex.texcoord[0], c[20], c[20].zwzw;
MAD result.texcoord[3].xy, vertex.texcoord[1], c[19], c[19].zwzw;
DP3 result.texcoord[1].z, vertex.normal, c[5];
DP3 result.texcoord[1].x, vertex.attrib[14], c[5];
DP3 result.texcoord[2].z, vertex.normal, c[6];
DP3 result.texcoord[2].x, vertex.attrib[14], c[6];
END
# 22 instructions, 3 R-regs
"
}

SubProgram "d3d9 " {
Keywords { "DIRECTIONAL" "LIGHTMAP_ON" "DIRLIGHTMAP_OFF" "SHADOWS_SCREEN" }
Bind "vertex" Vertex
Bind "tangent" TexCoord2
Bind "normal" Normal
Bind "texcoord" TexCoord0
Bind "texcoord1" TexCoord1
Matrix 0 [glstate_matrix_mvp]
Matrix 4 [glstate_matrix_invtrans_modelview0]
Vector 16 [_ProjectionParams]
Vector 17 [_ScreenParams]
Vector 18 [unity_LightmapST]
Vector 19 [_MainTex_ST]
Vector 20 [_BumpMap_ST]
"vs_2_0
; 23 ALU
def c21, 0.50000000, 0, 0, 0
dcl_position0 v0
dcl_tangent0 v1
dcl_normal0 v2
dcl_texcoord0 v3
dcl_texcoord1 v4
mov r0.xyz, v1
mul r1.xyz, v2.zxyw, r0.yzxw
mov r0.xyz, v1
mad r0.xyz, v2.yzxw, r0.zxyw, -r1
mul r2.xyz, r0, v1.w
dp4 r0.w, v0, c3
dp4 r0.z, v0, c2
dp4 r0.x, v0, c0
dp4 r0.y, v0, c1
mul r1.xyz, r0.xyww, c21.x
mul r1.y, r1, c16.x
dp3 oT1.y, r2, c4
dp3 oT2.y, r2, c5
mad oT4.xy, r1.z, c17.zwzw, r1
mov oPos, r0
mov oT4.zw, r0
mad oT0.zw, v3.xyxy, c20.xyxy, c20
mad oT0.xy, v3, c19, c19.zwzw
mad oT3.xy, v4, c18, c18.zwzw
dp3 oT1.z, v2, c4
dp3 oT1.x, v1, c4
dp3 oT2.z, v2, c5
dp3 oT2.x, v1, c5
"
}

SubProgram "d3d11 " {
Keywords { "DIRECTIONAL" "LIGHTMAP_ON" "DIRLIGHTMAP_OFF" "SHADOWS_SCREEN" }
Bind "vertex" Vertex
Bind "tangent" TexCoord2
Bind "normal" Normal
Bind "texcoord" TexCoord0
Bind "texcoord1" TexCoord1
Bind "color" Color
ConstBuffer "$Globals" 192 // 176 used size, 9 vars
Vector 128 [unity_LightmapST] 4
Vector 144 [_MainTex_ST] 4
Vector 160 [_BumpMap_ST] 4
ConstBuffer "UnityPerCamera" 128 // 96 used size, 8 vars
Vector 80 [_ProjectionParams] 4
ConstBuffer "UnityPerDraw" 336 // 192 used size, 6 vars
Matrix 0 [glstate_matrix_mvp] 4
Matrix 128 [glstate_matrix_invtrans_modelview0] 4
BindCB "$Globals" 0
BindCB "UnityPerCamera" 1
BindCB "UnityPerDraw" 2
// 28 instructions, 3 temp regs, 0 temp arrays:
// ALU 12 float, 0 int, 0 uint
// TEX 0 (0 load, 0 comp, 0 bias, 0 grad)
// FLOW 1 static, 0 dynamic
"vs_4_0
eefiecedkdeofdkdlalemlflglhhfhfoodggeajkabaaaaaamaafaaaaadaaaaaa
cmaaaaaapeaaaaaakmabaaaaejfdeheomaaaaaaaagaaaaaaaiaaaaaajiaaaaaa
aaaaaaaaaaaaaaaaadaaaaaaaaaaaaaaapapaaaakbaaaaaaaaaaaaaaaaaaaaaa
adaaaaaaabaaaaaaapapaaaakjaaaaaaaaaaaaaaaaaaaaaaadaaaaaaacaaaaaa
ahahaaaalaaaaaaaaaaaaaaaaaaaaaaaadaaaaaaadaaaaaaapadaaaalaaaaaaa
abaaaaaaaaaaaaaaadaaaaaaaeaaaaaaapadaaaaljaaaaaaaaaaaaaaaaaaaaaa
adaaaaaaafaaaaaaapaaaaaafaepfdejfeejepeoaafeebeoehefeofeaaeoepfc
enebemaafeeffiedepepfceeaaedepemepfcaaklepfdeheolaaaaaaaagaaaaaa
aiaaaaaajiaaaaaaaaaaaaaaabaaaaaaadaaaaaaaaaaaaaaapaaaaaakeaaaaaa
aaaaaaaaaaaaaaaaadaaaaaaabaaaaaaapaaaaaakeaaaaaaabaaaaaaaaaaaaaa
adaaaaaaacaaaaaaahaiaaaakeaaaaaaacaaaaaaaaaaaaaaadaaaaaaadaaaaaa
ahaiaaaakeaaaaaaadaaaaaaaaaaaaaaadaaaaaaaeaaaaaaadamaaaakeaaaaaa
aeaaaaaaaaaaaaaaadaaaaaaafaaaaaaapaaaaaafdfgfpfaepfdejfeejepeoaa
feeffiedepepfceeaaklklklfdeieefcamaeaaaaeaaaabaaadabaaaafjaaaaae
egiocaaaaaaaaaaaalaaaaaafjaaaaaeegiocaaaabaaaaaaagaaaaaafjaaaaae
egiocaaaacaaaaaaalaaaaaafpaaaaadpcbabaaaaaaaaaaafpaaaaadpcbabaaa
abaaaaaafpaaaaadhcbabaaaacaaaaaafpaaaaaddcbabaaaadaaaaaafpaaaaad
dcbabaaaaeaaaaaaghaaaaaepccabaaaaaaaaaaaabaaaaaagfaaaaadpccabaaa
abaaaaaagfaaaaadhccabaaaacaaaaaagfaaaaadhccabaaaadaaaaaagfaaaaad
dccabaaaaeaaaaaagfaaaaadpccabaaaafaaaaaagiaaaaacadaaaaaadiaaaaai
pcaabaaaaaaaaaaafgbfbaaaaaaaaaaaegiocaaaacaaaaaaabaaaaaadcaaaaak
pcaabaaaaaaaaaaaegiocaaaacaaaaaaaaaaaaaaagbabaaaaaaaaaaaegaobaaa
aaaaaaaadcaaaaakpcaabaaaaaaaaaaaegiocaaaacaaaaaaacaaaaaakgbkbaaa
aaaaaaaaegaobaaaaaaaaaaadcaaaaakpcaabaaaaaaaaaaaegiocaaaacaaaaaa
adaaaaaapgbpbaaaaaaaaaaaegaobaaaaaaaaaaadgaaaaafpccabaaaaaaaaaaa
egaobaaaaaaaaaaadcaaaaaldccabaaaabaaaaaaegbabaaaadaaaaaaegiacaaa
aaaaaaaaajaaaaaaogikcaaaaaaaaaaaajaaaaaadcaaaaalmccabaaaabaaaaaa
agbebaaaadaaaaaaagiecaaaaaaaaaaaakaaaaaakgiocaaaaaaaaaaaakaaaaaa
diaaaaahhcaabaaaabaaaaaajgbebaaaabaaaaaacgbjbaaaacaaaaaadcaaaaak
hcaabaaaabaaaaaajgbebaaaacaaaaaacgbjbaaaabaaaaaaegacbaiaebaaaaaa
abaaaaaadiaaaaahhcaabaaaabaaaaaaegacbaaaabaaaaaapgbpbaaaabaaaaaa
dgaaaaagbcaabaaaacaaaaaaakiacaaaacaaaaaaaiaaaaaadgaaaaagccaabaaa
acaaaaaaakiacaaaacaaaaaaajaaaaaadgaaaaagecaabaaaacaaaaaaakiacaaa
acaaaaaaakaaaaaabaaaaaahcccabaaaacaaaaaaegacbaaaabaaaaaaegacbaaa
acaaaaaabaaaaaahbccabaaaacaaaaaaegbcbaaaabaaaaaaegacbaaaacaaaaaa
baaaaaaheccabaaaacaaaaaaegbcbaaaacaaaaaaegacbaaaacaaaaaadgaaaaag
bcaabaaaacaaaaaabkiacaaaacaaaaaaaiaaaaaadgaaaaagccaabaaaacaaaaaa
bkiacaaaacaaaaaaajaaaaaadgaaaaagecaabaaaacaaaaaabkiacaaaacaaaaaa
akaaaaaabaaaaaahcccabaaaadaaaaaaegacbaaaabaaaaaaegacbaaaacaaaaaa
baaaaaahbccabaaaadaaaaaaegbcbaaaabaaaaaaegacbaaaacaaaaaabaaaaaah
eccabaaaadaaaaaaegbcbaaaacaaaaaaegacbaaaacaaaaaadcaaaaaldccabaaa
aeaaaaaaegbabaaaaeaaaaaaegiacaaaaaaaaaaaaiaaaaaaogikcaaaaaaaaaaa
aiaaaaaadiaaaaaiccaabaaaaaaaaaaabkaabaaaaaaaaaaaakiacaaaabaaaaaa
afaaaaaadiaaaaakncaabaaaabaaaaaaagahbaaaaaaaaaaaaceaaaaaaaaaaadp
aaaaaaaaaaaaaadpaaaaaadpdgaaaaafmccabaaaafaaaaaakgaobaaaaaaaaaaa
aaaaaaahdccabaaaafaaaaaakgakbaaaabaaaaaamgaabaaaabaaaaaadoaaaaab
"
}

SubProgram "gles " {
Keywords { "DIRECTIONAL" "LIGHTMAP_ON" "DIRLIGHTMAP_OFF" "SHADOWS_SCREEN" }
"!!GLES
#define SHADER_API_GLES 1
#define tex2D texture2D


#ifdef VERTEX
#define gl_ModelViewProjectionMatrix glstate_matrix_mvp
uniform mat4 glstate_matrix_mvp;
#define gl_ModelViewMatrixInverseTranspose glstate_matrix_invtrans_modelview0
uniform mat4 glstate_matrix_invtrans_modelview0;
#define gl_ModelViewMatrix glstate_matrix_modelview0
uniform mat4 glstate_matrix_modelview0;

varying highp vec4 xlv_TEXCOORD4;
varying highp vec2 xlv_TEXCOORD3;
varying highp vec3 xlv_TEXCOORD2;
varying highp vec3 xlv_TEXCOORD1;
varying highp vec4 xlv_TEXCOORD0;
uniform highp vec4 _BumpMap_ST;
uniform highp vec4 _MainTex_ST;
uniform highp vec4 unity_LightmapST;
uniform highp mat4 _Object2World;


uniform highp mat4 unity_World2Shadow[4];
attribute vec4 _glesTANGENT;
attribute vec4 _glesMultiTexCoord1;
attribute vec4 _glesMultiTexCoord0;
attribute vec3 _glesNormal;
attribute vec4 _glesVertex;
void main ()
{
  vec4 tmpvar_1;
  tmpvar_1.xyz = normalize(_glesTANGENT.xyz);
  tmpvar_1.w = _glesTANGENT.w;
  vec3 tmpvar_2;
  tmpvar_2 = normalize(_glesNormal);
  highp vec4 tmpvar_3;
  highp vec3 tmpvar_4;
  highp vec3 tmpvar_5;
  tmpvar_4 = tmpvar_1.xyz;
  tmpvar_5 = (((tmpvar_2.yzx * tmpvar_1.zxy) - (tmpvar_2.zxy * tmpvar_1.yzx)) * _glesTANGENT.w);
  highp mat3 tmpvar_6;
  tmpvar_6[0].x = tmpvar_4.x;
  tmpvar_6[0].y = tmpvar_5.x;
  tmpvar_6[0].z = tmpvar_2.x;
  tmpvar_6[1].x = tmpvar_4.y;
  tmpvar_6[1].y = tmpvar_5.y;
  tmpvar_6[1].z = tmpvar_2.y;
  tmpvar_6[2].x = tmpvar_4.z;
  tmpvar_6[2].y = tmpvar_5.z;
  tmpvar_6[2].z = tmpvar_2.z;
  vec4 v_7;
  v_7.x = gl_ModelViewMatrixInverseTranspose[0].x;
  v_7.y = gl_ModelViewMatrixInverseTranspose[1].x;
  v_7.z = gl_ModelViewMatrixInverseTranspose[2].x;
  v_7.w = gl_ModelViewMatrixInverseTranspose[3].x;
  vec4 v_8;
  v_8.x = gl_ModelViewMatrixInverseTranspose[0].y;
  v_8.y = gl_ModelViewMatrixInverseTranspose[1].y;
  v_8.z = gl_ModelViewMatrixInverseTranspose[2].y;
  v_8.w = gl_ModelViewMatrixInverseTranspose[3].y;
  tmpvar_3.xy = ((_glesMultiTexCoord0.xy * _MainTex_ST.xy) + _MainTex_ST.zw);
  tmpvar_3.zw = ((_glesMultiTexCoord0.xy * _BumpMap_ST.xy) + _BumpMap_ST.zw);
  gl_Position = (gl_ModelViewProjectionMatrix * _glesVertex);
  xlv_TEXCOORD0 = tmpvar_3;
  xlv_TEXCOORD1 = (tmpvar_6 * v_7.xyz);
  xlv_TEXCOORD2 = (tmpvar_6 * v_8.xyz);
  xlv_TEXCOORD3 = ((_glesMultiTexCoord1.xy * unity_LightmapST.xy) + unity_LightmapST.zw);
  xlv_TEXCOORD4 = (unity_World2Shadow[0] * (_Object2World * _glesVertex));
}



#endif
#ifdef FRAGMENT

varying highp vec4 xlv_TEXCOORD4;
varying highp vec2 xlv_TEXCOORD3;
varying highp vec3 xlv_TEXCOORD2;
varying highp vec3 xlv_TEXCOORD1;
varying highp vec4 xlv_TEXCOORD0;
uniform lowp float _Cutoff;
uniform sampler2D unity_Lightmap;
uniform sampler2D _Shade;
uniform sampler2D _BumpMap;
uniform sampler2D _MainTex;
uniform lowp vec4 _Color;
uniform sampler2D _ShadowMapTexture;
uniform highp vec4 _LightShadowData;
void main ()
{
  lowp vec4 c_1;
  lowp vec3 tmpvar_2;
  highp vec3 matcap_3;
  lowp vec3 tmpvar_4;
  tmpvar_4 = ((texture2D (_BumpMap, xlv_TEXCOORD0.zw).xyz * 2.0) - 1.0);
  highp vec2 tmpvar_5;
  tmpvar_5.x = dot (xlv_TEXCOORD1, tmpvar_4);
  tmpvar_5.y = dot (xlv_TEXCOORD2, tmpvar_4);
  highp vec2 P_6;
  P_6 = ((tmpvar_5 * 0.5) + 0.5);
  lowp vec3 tmpvar_7;
  tmpvar_7 = texture2D (_Shade, P_6).xyz;
  matcap_3 = tmpvar_7;
  lowp vec4 tmpvar_8;
  tmpvar_8 = texture2D (_MainTex, xlv_TEXCOORD0.xy);
  highp vec3 tmpvar_9;
  tmpvar_9 = (((matcap_3 * tmpvar_8.xyz) * _Color.xyz) * 3.0);
  tmpvar_2 = tmpvar_9;
  lowp vec4 tmpvar_10;
  tmpvar_10 = texture2D (_MainTex, xlv_TEXCOORD0.xy);
  lowp float tmpvar_11;
  tmpvar_11 = tmpvar_10.w;
  lowp float x_12;
  x_12 = (tmpvar_10.w - _Cutoff);
  if ((x_12 < 0.0)) {
    discard;
  };
  lowp float tmpvar_13;
  mediump float lightShadowDataX_14;
  highp float dist_15;
  lowp float tmpvar_16;
  tmpvar_16 = texture2DProj (_ShadowMapTexture, xlv_TEXCOORD4).x;
  dist_15 = tmpvar_16;
  highp float tmpvar_17;
  tmpvar_17 = _LightShadowData.x;
  lightShadowDataX_14 = tmpvar_17;
  highp float tmpvar_18;
  tmpvar_18 = max (float((dist_15 > (xlv_TEXCOORD4.z / xlv_TEXCOORD4.w))), lightShadowDataX_14);
  tmpvar_13 = tmpvar_18;
  c_1.xyz = ((texture2D (_MainTex, xlv_TEXCOORD0.xy).xyz * _Color.w) * min ((2.0 * texture2D (unity_Lightmap, xlv_TEXCOORD3).xyz), vec3((tmpvar_13 * 2.0))));
  c_1.w = tmpvar_11;
  c_1.xyz = (c_1.xyz + tmpvar_2);
  c_1.w = tmpvar_11;
  gl_FragData[0] = c_1;
}



#endif"
}

SubProgram "glesdesktop " {
Keywords { "DIRECTIONAL" "LIGHTMAP_ON" "DIRLIGHTMAP_OFF" "SHADOWS_SCREEN" }
"!!GLES
#define SHADER_API_GLES 1
#define tex2D texture2D


#ifdef VERTEX
#define gl_ModelViewProjectionMatrix glstate_matrix_mvp
uniform mat4 glstate_matrix_mvp;
#define gl_ModelViewMatrixInverseTranspose glstate_matrix_invtrans_modelview0
uniform mat4 glstate_matrix_invtrans_modelview0;
#define gl_ModelViewMatrix glstate_matrix_modelview0
uniform mat4 glstate_matrix_modelview0;

varying highp vec4 xlv_TEXCOORD4;
varying highp vec2 xlv_TEXCOORD3;
varying highp vec3 xlv_TEXCOORD2;
varying highp vec3 xlv_TEXCOORD1;
varying highp vec4 xlv_TEXCOORD0;
uniform highp vec4 _BumpMap_ST;
uniform highp vec4 _MainTex_ST;
uniform highp vec4 unity_LightmapST;


uniform highp vec4 _ProjectionParams;
attribute vec4 _glesTANGENT;
attribute vec4 _glesMultiTexCoord1;
attribute vec4 _glesMultiTexCoord0;
attribute vec3 _glesNormal;
attribute vec4 _glesVertex;
void main ()
{
  vec4 tmpvar_1;
  tmpvar_1.xyz = normalize(_glesTANGENT.xyz);
  tmpvar_1.w = _glesTANGENT.w;
  vec3 tmpvar_2;
  tmpvar_2 = normalize(_glesNormal);
  highp vec4 tmpvar_3;
  highp vec3 tmpvar_4;
  highp vec3 tmpvar_5;
  tmpvar_4 = tmpvar_1.xyz;
  tmpvar_5 = (((tmpvar_2.yzx * tmpvar_1.zxy) - (tmpvar_2.zxy * tmpvar_1.yzx)) * _glesTANGENT.w);
  highp mat3 tmpvar_6;
  tmpvar_6[0].x = tmpvar_4.x;
  tmpvar_6[0].y = tmpvar_5.x;
  tmpvar_6[0].z = tmpvar_2.x;
  tmpvar_6[1].x = tmpvar_4.y;
  tmpvar_6[1].y = tmpvar_5.y;
  tmpvar_6[1].z = tmpvar_2.y;
  tmpvar_6[2].x = tmpvar_4.z;
  tmpvar_6[2].y = tmpvar_5.z;
  tmpvar_6[2].z = tmpvar_2.z;
  vec4 v_7;
  v_7.x = gl_ModelViewMatrixInverseTranspose[0].x;
  v_7.y = gl_ModelViewMatrixInverseTranspose[1].x;
  v_7.z = gl_ModelViewMatrixInverseTranspose[2].x;
  v_7.w = gl_ModelViewMatrixInverseTranspose[3].x;
  vec4 v_8;
  v_8.x = gl_ModelViewMatrixInverseTranspose[0].y;
  v_8.y = gl_ModelViewMatrixInverseTranspose[1].y;
  v_8.z = gl_ModelViewMatrixInverseTranspose[2].y;
  v_8.w = gl_ModelViewMatrixInverseTranspose[3].y;
  highp vec4 tmpvar_9;
  tmpvar_9 = (gl_ModelViewProjectionMatrix * _glesVertex);
  tmpvar_3.xy = ((_glesMultiTexCoord0.xy * _MainTex_ST.xy) + _MainTex_ST.zw);
  tmpvar_3.zw = ((_glesMultiTexCoord0.xy * _BumpMap_ST.xy) + _BumpMap_ST.zw);
  highp vec4 o_10;
  highp vec4 tmpvar_11;
  tmpvar_11 = (tmpvar_9 * 0.5);
  highp vec2 tmpvar_12;
  tmpvar_12.x = tmpvar_11.x;
  tmpvar_12.y = (tmpvar_11.y * _ProjectionParams.x);
  o_10.xy = (tmpvar_12 + tmpvar_11.w);
  o_10.zw = tmpvar_9.zw;
  gl_Position = tmpvar_9;
  xlv_TEXCOORD0 = tmpvar_3;
  xlv_TEXCOORD1 = (tmpvar_6 * v_7.xyz);
  xlv_TEXCOORD2 = (tmpvar_6 * v_8.xyz);
  xlv_TEXCOORD3 = ((_glesMultiTexCoord1.xy * unity_LightmapST.xy) + unity_LightmapST.zw);
  xlv_TEXCOORD4 = o_10;
}



#endif
#ifdef FRAGMENT

varying highp vec4 xlv_TEXCOORD4;
varying highp vec2 xlv_TEXCOORD3;
varying highp vec3 xlv_TEXCOORD2;
varying highp vec3 xlv_TEXCOORD1;
varying highp vec4 xlv_TEXCOORD0;
uniform lowp float _Cutoff;
uniform sampler2D unity_Lightmap;
uniform sampler2D _Shade;
uniform sampler2D _BumpMap;
uniform sampler2D _MainTex;
uniform lowp vec4 _Color;
uniform sampler2D _ShadowMapTexture;
void main ()
{
  lowp vec4 c_1;
  lowp vec3 tmpvar_2;
  highp vec3 matcap_3;
  lowp vec3 normal_4;
  normal_4.xy = ((texture2D (_BumpMap, xlv_TEXCOORD0.zw).wy * 2.0) - 1.0);
  normal_4.z = sqrt(((1.0 - (normal_4.x * normal_4.x)) - (normal_4.y * normal_4.y)));
  highp vec2 tmpvar_5;
  tmpvar_5.x = dot (xlv_TEXCOORD1, normal_4);
  tmpvar_5.y = dot (xlv_TEXCOORD2, normal_4);
  highp vec2 P_6;
  P_6 = ((tmpvar_5 * 0.5) + 0.5);
  lowp vec3 tmpvar_7;
  tmpvar_7 = texture2D (_Shade, P_6).xyz;
  matcap_3 = tmpvar_7;
  lowp vec4 tmpvar_8;
  tmpvar_8 = texture2D (_MainTex, xlv_TEXCOORD0.xy);
  highp vec3 tmpvar_9;
  tmpvar_9 = (((matcap_3 * tmpvar_8.xyz) * _Color.xyz) * 3.0);
  tmpvar_2 = tmpvar_9;
  lowp vec4 tmpvar_10;
  tmpvar_10 = texture2D (_MainTex, xlv_TEXCOORD0.xy);
  lowp float tmpvar_11;
  tmpvar_11 = tmpvar_10.w;
  lowp float x_12;
  x_12 = (tmpvar_10.w - _Cutoff);
  if ((x_12 < 0.0)) {
    discard;
  };
  lowp vec4 tmpvar_13;
  tmpvar_13 = texture2DProj (_ShadowMapTexture, xlv_TEXCOORD4);
  lowp vec4 tmpvar_14;
  tmpvar_14 = texture2D (unity_Lightmap, xlv_TEXCOORD3);
  lowp vec3 tmpvar_15;
  tmpvar_15 = ((8.0 * tmpvar_14.w) * tmpvar_14.xyz);
  c_1.xyz = ((texture2D (_MainTex, xlv_TEXCOORD0.xy).xyz * _Color.w) * max (min (tmpvar_15, ((tmpvar_13.x * 2.0) * tmpvar_14.xyz)), (tmpvar_15 * tmpvar_13.x)));
  c_1.w = tmpvar_11;
  c_1.xyz = (c_1.xyz + tmpvar_2);
  c_1.w = tmpvar_11;
  gl_FragData[0] = c_1;
}



#endif"
}

SubProgram "flash " {
Keywords { "DIRECTIONAL" "LIGHTMAP_ON" "DIRLIGHTMAP_OFF" "SHADOWS_SCREEN" }
Bind "vertex" Vertex
Bind "tangent" TexCoord2
Bind "normal" Normal
Bind "texcoord" TexCoord0
Bind "texcoord1" TexCoord1
Matrix 0 [glstate_matrix_mvp]
Matrix 4 [glstate_matrix_invtrans_modelview0]
Vector 16 [_ProjectionParams]
Vector 17 [unity_NPOTScale]
Vector 18 [unity_LightmapST]
Vector 19 [_MainTex_ST]
Vector 20 [_BumpMap_ST]
"agal_vs
c21 0.5 0.0 0.0 0.0
[bc]
aaaaaaaaaaaaahacafaaaaoeaaaaaaaaaaaaaaaaaaaaaaaa mov r0.xyz, a5
adaaaaaaabaaahacabaaaancaaaaaaaaaaaaaaajacaaaaaa mul r1.xyz, a1.zxyw, r0.yzxx
aaaaaaaaaaaaahacafaaaaoeaaaaaaaaaaaaaaaaaaaaaaaa mov r0.xyz, a5
adaaaaaaacaaahacabaaaamjaaaaaaaaaaaaaafcacaaaaaa mul r2.xyz, a1.yzxw, r0.zxyy
acaaaaaaaaaaahacacaaaakeacaaaaaaabaaaakeacaaaaaa sub r0.xyz, r2.xyzz, r1.xyzz
adaaaaaaabaaahacaaaaaakeacaaaaaaafaaaappaaaaaaaa mul r1.xyz, r0.xyzz, a5.w
bdaaaaaaaaaaaiacaaaaaaoeaaaaaaaaadaaaaoeabaaaaaa dp4 r0.w, a0, c3
bdaaaaaaaaaaaeacaaaaaaoeaaaaaaaaacaaaaoeabaaaaaa dp4 r0.z, a0, c2
bcaaaaaaabaaacaeabaaaakeacaaaaaaaeaaaaoeabaaaaaa dp3 v1.y, r1.xyzz, c4
bdaaaaaaaaaaabacaaaaaaoeaaaaaaaaaaaaaaoeabaaaaaa dp4 r0.x, a0, c0
bdaaaaaaaaaaacacaaaaaaoeaaaaaaaaabaaaaoeabaaaaaa dp4 r0.y, a0, c1
adaaaaaaacaaahacaaaaaapeacaaaaaabfaaaaaaabaaaaaa mul r2.xyz, r0.xyww, c21.x
bcaaaaaaacaaacaeabaaaakeacaaaaaaafaaaaoeabaaaaaa dp3 v2.y, r1.xyzz, c5
adaaaaaaabaaacacacaaaaffacaaaaaabaaaaaaaabaaaaaa mul r1.y, r2.y, c16.x
aaaaaaaaabaaabacacaaaaaaacaaaaaaaaaaaaaaaaaaaaaa mov r1.x, r2.x
abaaaaaaabaaadacabaaaafeacaaaaaaacaaaakkacaaaaaa add r1.xy, r1.xyyy, r2.z
adaaaaaaaeaaadaeabaaaafeacaaaaaabbaaaaoeabaaaaaa mul v4.xy, r1.xyyy, c17
aaaaaaaaaaaaapadaaaaaaoeacaaaaaaaaaaaaaaaaaaaaaa mov o0, r0
aaaaaaaaaeaaamaeaaaaaaopacaaaaaaaaaaaaaaaaaaaaaa mov v4.zw, r0.wwzw
adaaaaaaaaaaamacadaaaaeeaaaaaaaabeaaaaeeabaaaaaa mul r0.zw, a3.xyxy, c20.xyxy
abaaaaaaaaaaamaeaaaaaaopacaaaaaabeaaaaoeabaaaaaa add v0.zw, r0.wwzw, c20
adaaaaaaaaaaadacadaaaaoeaaaaaaaabdaaaaoeabaaaaaa mul r0.xy, a3, c19
abaaaaaaaaaaadaeaaaaaafeacaaaaaabdaaaaooabaaaaaa add v0.xy, r0.xyyy, c19.zwzw
adaaaaaaaaaaadacaeaaaaoeaaaaaaaabcaaaaoeabaaaaaa mul r0.xy, a4, c18
abaaaaaaadaaadaeaaaaaafeacaaaaaabcaaaaooabaaaaaa add v3.xy, r0.xyyy, c18.zwzw
bcaaaaaaabaaaeaeabaaaaoeaaaaaaaaaeaaaaoeabaaaaaa dp3 v1.z, a1, c4
bcaaaaaaabaaabaeafaaaaoeaaaaaaaaaeaaaaoeabaaaaaa dp3 v1.x, a5, c4
bcaaaaaaacaaaeaeabaaaaoeaaaaaaaaafaaaaoeabaaaaaa dp3 v2.z, a1, c5
bcaaaaaaacaaabaeafaaaaoeaaaaaaaaafaaaaoeabaaaaaa dp3 v2.x, a5, c5
aaaaaaaaabaaaiaeaaaaaaoeabaaaaaaaaaaaaaaaaaaaaaa mov v1.w, c0
aaaaaaaaacaaaiaeaaaaaaoeabaaaaaaaaaaaaaaaaaaaaaa mov v2.w, c0
aaaaaaaaadaaamaeaaaaaaoeabaaaaaaaaaaaaaaaaaaaaaa mov v3.zw, c0
"
}

SubProgram "opengl " {
Keywords { "DIRECTIONAL" "LIGHTMAP_ON" "DIRLIGHTMAP_ON" "SHADOWS_SCREEN" }
Bind "vertex" Vertex
Bind "tangent" ATTR14
Bind "normal" Normal
Bind "texcoord" TexCoord0
Bind "texcoord1" TexCoord1
Vector 17 [_ProjectionParams]
Vector 19 [unity_LightmapST]
Vector 20 [_MainTex_ST]
Vector 21 [_BumpMap_ST]
"!!ARBvp1.0
# 22 ALU
PARAM c[22] = { { 0.5 },
		state.matrix.mvp,
		state.matrix.modelview[0].invtrans,
		program.local[9..21] };
TEMP R0;
TEMP R1;
TEMP R2;
MOV R0.xyz, vertex.attrib[14];
MUL R1.xyz, vertex.normal.zxyw, R0.yzxw;
MAD R0.xyz, vertex.normal.yzxw, R0.zxyw, -R1;
MUL R2.xyz, R0, vertex.attrib[14].w;
DP4 R0.w, vertex.position, c[4];
DP4 R0.z, vertex.position, c[3];
DP4 R0.x, vertex.position, c[1];
DP4 R0.y, vertex.position, c[2];
MUL R1.xyz, R0.xyww, c[0].x;
MUL R1.y, R1, c[17].x;
DP3 result.texcoord[1].y, R2, c[5];
DP3 result.texcoord[2].y, R2, c[6];
ADD result.texcoord[4].xy, R1, R1.z;
MOV result.position, R0;
MOV result.texcoord[4].zw, R0;
MAD result.texcoord[0].zw, vertex.texcoord[0].xyxy, c[21].xyxy, c[21];
MAD result.texcoord[0].xy, vertex.texcoord[0], c[20], c[20].zwzw;
MAD result.texcoord[3].xy, vertex.texcoord[1], c[19], c[19].zwzw;
DP3 result.texcoord[1].z, vertex.normal, c[5];
DP3 result.texcoord[1].x, vertex.attrib[14], c[5];
DP3 result.texcoord[2].z, vertex.normal, c[6];
DP3 result.texcoord[2].x, vertex.attrib[14], c[6];
END
# 22 instructions, 3 R-regs
"
}

SubProgram "d3d9 " {
Keywords { "DIRECTIONAL" "LIGHTMAP_ON" "DIRLIGHTMAP_ON" "SHADOWS_SCREEN" }
Bind "vertex" Vertex
Bind "tangent" TexCoord2
Bind "normal" Normal
Bind "texcoord" TexCoord0
Bind "texcoord1" TexCoord1
Matrix 0 [glstate_matrix_mvp]
Matrix 4 [glstate_matrix_invtrans_modelview0]
Vector 16 [_ProjectionParams]
Vector 17 [_ScreenParams]
Vector 18 [unity_LightmapST]
Vector 19 [_MainTex_ST]
Vector 20 [_BumpMap_ST]
"vs_2_0
; 23 ALU
def c21, 0.50000000, 0, 0, 0
dcl_position0 v0
dcl_tangent0 v1
dcl_normal0 v2
dcl_texcoord0 v3
dcl_texcoord1 v4
mov r0.xyz, v1
mul r1.xyz, v2.zxyw, r0.yzxw
mov r0.xyz, v1
mad r0.xyz, v2.yzxw, r0.zxyw, -r1
mul r2.xyz, r0, v1.w
dp4 r0.w, v0, c3
dp4 r0.z, v0, c2
dp4 r0.x, v0, c0
dp4 r0.y, v0, c1
mul r1.xyz, r0.xyww, c21.x
mul r1.y, r1, c16.x
dp3 oT1.y, r2, c4
dp3 oT2.y, r2, c5
mad oT4.xy, r1.z, c17.zwzw, r1
mov oPos, r0
mov oT4.zw, r0
mad oT0.zw, v3.xyxy, c20.xyxy, c20
mad oT0.xy, v3, c19, c19.zwzw
mad oT3.xy, v4, c18, c18.zwzw
dp3 oT1.z, v2, c4
dp3 oT1.x, v1, c4
dp3 oT2.z, v2, c5
dp3 oT2.x, v1, c5
"
}

SubProgram "d3d11 " {
Keywords { "DIRECTIONAL" "LIGHTMAP_ON" "DIRLIGHTMAP_ON" "SHADOWS_SCREEN" }
Bind "vertex" Vertex
Bind "tangent" TexCoord2
Bind "normal" Normal
Bind "texcoord" TexCoord0
Bind "texcoord1" TexCoord1
Bind "color" Color
ConstBuffer "$Globals" 192 // 176 used size, 9 vars
Vector 128 [unity_LightmapST] 4
Vector 144 [_MainTex_ST] 4
Vector 160 [_BumpMap_ST] 4
ConstBuffer "UnityPerCamera" 128 // 96 used size, 8 vars
Vector 80 [_ProjectionParams] 4
ConstBuffer "UnityPerDraw" 336 // 192 used size, 6 vars
Matrix 0 [glstate_matrix_mvp] 4
Matrix 128 [glstate_matrix_invtrans_modelview0] 4
BindCB "$Globals" 0
BindCB "UnityPerCamera" 1
BindCB "UnityPerDraw" 2
// 28 instructions, 3 temp regs, 0 temp arrays:
// ALU 12 float, 0 int, 0 uint
// TEX 0 (0 load, 0 comp, 0 bias, 0 grad)
// FLOW 1 static, 0 dynamic
"vs_4_0
eefiecedkdeofdkdlalemlflglhhfhfoodggeajkabaaaaaamaafaaaaadaaaaaa
cmaaaaaapeaaaaaakmabaaaaejfdeheomaaaaaaaagaaaaaaaiaaaaaajiaaaaaa
aaaaaaaaaaaaaaaaadaaaaaaaaaaaaaaapapaaaakbaaaaaaaaaaaaaaaaaaaaaa
adaaaaaaabaaaaaaapapaaaakjaaaaaaaaaaaaaaaaaaaaaaadaaaaaaacaaaaaa
ahahaaaalaaaaaaaaaaaaaaaaaaaaaaaadaaaaaaadaaaaaaapadaaaalaaaaaaa
abaaaaaaaaaaaaaaadaaaaaaaeaaaaaaapadaaaaljaaaaaaaaaaaaaaaaaaaaaa
adaaaaaaafaaaaaaapaaaaaafaepfdejfeejepeoaafeebeoehefeofeaaeoepfc
enebemaafeeffiedepepfceeaaedepemepfcaaklepfdeheolaaaaaaaagaaaaaa
aiaaaaaajiaaaaaaaaaaaaaaabaaaaaaadaaaaaaaaaaaaaaapaaaaaakeaaaaaa
aaaaaaaaaaaaaaaaadaaaaaaabaaaaaaapaaaaaakeaaaaaaabaaaaaaaaaaaaaa
adaaaaaaacaaaaaaahaiaaaakeaaaaaaacaaaaaaaaaaaaaaadaaaaaaadaaaaaa
ahaiaaaakeaaaaaaadaaaaaaaaaaaaaaadaaaaaaaeaaaaaaadamaaaakeaaaaaa
aeaaaaaaaaaaaaaaadaaaaaaafaaaaaaapaaaaaafdfgfpfaepfdejfeejepeoaa
feeffiedepepfceeaaklklklfdeieefcamaeaaaaeaaaabaaadabaaaafjaaaaae
egiocaaaaaaaaaaaalaaaaaafjaaaaaeegiocaaaabaaaaaaagaaaaaafjaaaaae
egiocaaaacaaaaaaalaaaaaafpaaaaadpcbabaaaaaaaaaaafpaaaaadpcbabaaa
abaaaaaafpaaaaadhcbabaaaacaaaaaafpaaaaaddcbabaaaadaaaaaafpaaaaad
dcbabaaaaeaaaaaaghaaaaaepccabaaaaaaaaaaaabaaaaaagfaaaaadpccabaaa
abaaaaaagfaaaaadhccabaaaacaaaaaagfaaaaadhccabaaaadaaaaaagfaaaaad
dccabaaaaeaaaaaagfaaaaadpccabaaaafaaaaaagiaaaaacadaaaaaadiaaaaai
pcaabaaaaaaaaaaafgbfbaaaaaaaaaaaegiocaaaacaaaaaaabaaaaaadcaaaaak
pcaabaaaaaaaaaaaegiocaaaacaaaaaaaaaaaaaaagbabaaaaaaaaaaaegaobaaa
aaaaaaaadcaaaaakpcaabaaaaaaaaaaaegiocaaaacaaaaaaacaaaaaakgbkbaaa
aaaaaaaaegaobaaaaaaaaaaadcaaaaakpcaabaaaaaaaaaaaegiocaaaacaaaaaa
adaaaaaapgbpbaaaaaaaaaaaegaobaaaaaaaaaaadgaaaaafpccabaaaaaaaaaaa
egaobaaaaaaaaaaadcaaaaaldccabaaaabaaaaaaegbabaaaadaaaaaaegiacaaa
aaaaaaaaajaaaaaaogikcaaaaaaaaaaaajaaaaaadcaaaaalmccabaaaabaaaaaa
agbebaaaadaaaaaaagiecaaaaaaaaaaaakaaaaaakgiocaaaaaaaaaaaakaaaaaa
diaaaaahhcaabaaaabaaaaaajgbebaaaabaaaaaacgbjbaaaacaaaaaadcaaaaak
hcaabaaaabaaaaaajgbebaaaacaaaaaacgbjbaaaabaaaaaaegacbaiaebaaaaaa
abaaaaaadiaaaaahhcaabaaaabaaaaaaegacbaaaabaaaaaapgbpbaaaabaaaaaa
dgaaaaagbcaabaaaacaaaaaaakiacaaaacaaaaaaaiaaaaaadgaaaaagccaabaaa
acaaaaaaakiacaaaacaaaaaaajaaaaaadgaaaaagecaabaaaacaaaaaaakiacaaa
acaaaaaaakaaaaaabaaaaaahcccabaaaacaaaaaaegacbaaaabaaaaaaegacbaaa
acaaaaaabaaaaaahbccabaaaacaaaaaaegbcbaaaabaaaaaaegacbaaaacaaaaaa
baaaaaaheccabaaaacaaaaaaegbcbaaaacaaaaaaegacbaaaacaaaaaadgaaaaag
bcaabaaaacaaaaaabkiacaaaacaaaaaaaiaaaaaadgaaaaagccaabaaaacaaaaaa
bkiacaaaacaaaaaaajaaaaaadgaaaaagecaabaaaacaaaaaabkiacaaaacaaaaaa
akaaaaaabaaaaaahcccabaaaadaaaaaaegacbaaaabaaaaaaegacbaaaacaaaaaa
baaaaaahbccabaaaadaaaaaaegbcbaaaabaaaaaaegacbaaaacaaaaaabaaaaaah
eccabaaaadaaaaaaegbcbaaaacaaaaaaegacbaaaacaaaaaadcaaaaaldccabaaa
aeaaaaaaegbabaaaaeaaaaaaegiacaaaaaaaaaaaaiaaaaaaogikcaaaaaaaaaaa
aiaaaaaadiaaaaaiccaabaaaaaaaaaaabkaabaaaaaaaaaaaakiacaaaabaaaaaa
afaaaaaadiaaaaakncaabaaaabaaaaaaagahbaaaaaaaaaaaaceaaaaaaaaaaadp
aaaaaaaaaaaaaadpaaaaaadpdgaaaaafmccabaaaafaaaaaakgaobaaaaaaaaaaa
aaaaaaahdccabaaaafaaaaaakgakbaaaabaaaaaamgaabaaaabaaaaaadoaaaaab
"
}

SubProgram "gles " {
Keywords { "DIRECTIONAL" "LIGHTMAP_ON" "DIRLIGHTMAP_ON" "SHADOWS_SCREEN" }
"!!GLES
#define SHADER_API_GLES 1
#define tex2D texture2D


#ifdef VERTEX
#define gl_ModelViewProjectionMatrix glstate_matrix_mvp
uniform mat4 glstate_matrix_mvp;
#define gl_ModelViewMatrixInverseTranspose glstate_matrix_invtrans_modelview0
uniform mat4 glstate_matrix_invtrans_modelview0;
#define gl_ModelViewMatrix glstate_matrix_modelview0
uniform mat4 glstate_matrix_modelview0;

varying highp vec4 xlv_TEXCOORD4;
varying highp vec2 xlv_TEXCOORD3;
varying highp vec3 xlv_TEXCOORD2;
varying highp vec3 xlv_TEXCOORD1;
varying highp vec4 xlv_TEXCOORD0;
uniform highp vec4 _BumpMap_ST;
uniform highp vec4 _MainTex_ST;
uniform highp vec4 unity_LightmapST;
uniform highp mat4 _Object2World;


uniform highp mat4 unity_World2Shadow[4];
attribute vec4 _glesTANGENT;
attribute vec4 _glesMultiTexCoord1;
attribute vec4 _glesMultiTexCoord0;
attribute vec3 _glesNormal;
attribute vec4 _glesVertex;
void main ()
{
  vec4 tmpvar_1;
  tmpvar_1.xyz = normalize(_glesTANGENT.xyz);
  tmpvar_1.w = _glesTANGENT.w;
  vec3 tmpvar_2;
  tmpvar_2 = normalize(_glesNormal);
  highp vec4 tmpvar_3;
  highp vec3 tmpvar_4;
  highp vec3 tmpvar_5;
  tmpvar_4 = tmpvar_1.xyz;
  tmpvar_5 = (((tmpvar_2.yzx * tmpvar_1.zxy) - (tmpvar_2.zxy * tmpvar_1.yzx)) * _glesTANGENT.w);
  highp mat3 tmpvar_6;
  tmpvar_6[0].x = tmpvar_4.x;
  tmpvar_6[0].y = tmpvar_5.x;
  tmpvar_6[0].z = tmpvar_2.x;
  tmpvar_6[1].x = tmpvar_4.y;
  tmpvar_6[1].y = tmpvar_5.y;
  tmpvar_6[1].z = tmpvar_2.y;
  tmpvar_6[2].x = tmpvar_4.z;
  tmpvar_6[2].y = tmpvar_5.z;
  tmpvar_6[2].z = tmpvar_2.z;
  vec4 v_7;
  v_7.x = gl_ModelViewMatrixInverseTranspose[0].x;
  v_7.y = gl_ModelViewMatrixInverseTranspose[1].x;
  v_7.z = gl_ModelViewMatrixInverseTranspose[2].x;
  v_7.w = gl_ModelViewMatrixInverseTranspose[3].x;
  vec4 v_8;
  v_8.x = gl_ModelViewMatrixInverseTranspose[0].y;
  v_8.y = gl_ModelViewMatrixInverseTranspose[1].y;
  v_8.z = gl_ModelViewMatrixInverseTranspose[2].y;
  v_8.w = gl_ModelViewMatrixInverseTranspose[3].y;
  tmpvar_3.xy = ((_glesMultiTexCoord0.xy * _MainTex_ST.xy) + _MainTex_ST.zw);
  tmpvar_3.zw = ((_glesMultiTexCoord0.xy * _BumpMap_ST.xy) + _BumpMap_ST.zw);
  gl_Position = (gl_ModelViewProjectionMatrix * _glesVertex);
  xlv_TEXCOORD0 = tmpvar_3;
  xlv_TEXCOORD1 = (tmpvar_6 * v_7.xyz);
  xlv_TEXCOORD2 = (tmpvar_6 * v_8.xyz);
  xlv_TEXCOORD3 = ((_glesMultiTexCoord1.xy * unity_LightmapST.xy) + unity_LightmapST.zw);
  xlv_TEXCOORD4 = (unity_World2Shadow[0] * (_Object2World * _glesVertex));
}



#endif
#ifdef FRAGMENT

varying highp vec4 xlv_TEXCOORD4;
varying highp vec2 xlv_TEXCOORD3;
varying highp vec3 xlv_TEXCOORD2;
varying highp vec3 xlv_TEXCOORD1;
varying highp vec4 xlv_TEXCOORD0;
uniform lowp float _Cutoff;
uniform sampler2D unity_LightmapInd;
uniform sampler2D unity_Lightmap;
uniform sampler2D _Shade;
uniform sampler2D _BumpMap;
uniform sampler2D _MainTex;
uniform lowp vec4 _Color;
uniform sampler2D _ShadowMapTexture;
uniform highp vec4 _LightShadowData;
void main ()
{
  lowp vec4 c_1;
  lowp vec3 tmpvar_2;
  highp vec3 matcap_3;
  lowp vec3 tmpvar_4;
  tmpvar_4 = ((texture2D (_BumpMap, xlv_TEXCOORD0.zw).xyz * 2.0) - 1.0);
  lowp vec3 tmpvar_5;
  tmpvar_5 = (texture2D (_MainTex, xlv_TEXCOORD0.xy).xyz * _Color.w);
  highp vec2 tmpvar_6;
  tmpvar_6.x = dot (xlv_TEXCOORD1, tmpvar_4);
  tmpvar_6.y = dot (xlv_TEXCOORD2, tmpvar_4);
  highp vec2 P_7;
  P_7 = ((tmpvar_6 * 0.5) + 0.5);
  lowp vec3 tmpvar_8;
  tmpvar_8 = texture2D (_Shade, P_7).xyz;
  matcap_3 = tmpvar_8;
  lowp vec4 tmpvar_9;
  tmpvar_9 = texture2D (_MainTex, xlv_TEXCOORD0.xy);
  highp vec3 tmpvar_10;
  tmpvar_10 = (((matcap_3 * tmpvar_9.xyz) * _Color.xyz) * 3.0);
  tmpvar_2 = tmpvar_10;
  lowp vec4 tmpvar_11;
  tmpvar_11 = texture2D (_MainTex, xlv_TEXCOORD0.xy);
  lowp float tmpvar_12;
  tmpvar_12 = tmpvar_11.w;
  lowp float x_13;
  x_13 = (tmpvar_11.w - _Cutoff);
  if ((x_13 < 0.0)) {
    discard;
  };
  lowp float tmpvar_14;
  mediump float lightShadowDataX_15;
  highp float dist_16;
  lowp float tmpvar_17;
  tmpvar_17 = texture2DProj (_ShadowMapTexture, xlv_TEXCOORD4).x;
  dist_16 = tmpvar_17;
  highp float tmpvar_18;
  tmpvar_18 = _LightShadowData.x;
  lightShadowDataX_15 = tmpvar_18;
  highp float tmpvar_19;
  tmpvar_19 = max (float((dist_16 > (xlv_TEXCOORD4.z / xlv_TEXCOORD4.w))), lightShadowDataX_15);
  tmpvar_14 = tmpvar_19;
  mat3 tmpvar_20;
  tmpvar_20[0].x = 0.816497;
  tmpvar_20[0].y = -0.408248;
  tmpvar_20[0].z = -0.408248;
  tmpvar_20[1].x = 0.0;
  tmpvar_20[1].y = 0.707107;
  tmpvar_20[1].z = -0.707107;
  tmpvar_20[2].x = 0.57735;
  tmpvar_20[2].y = 0.57735;
  tmpvar_20[2].z = 0.57735;
  mediump vec3 normal_21;
  normal_21 = tmpvar_4;
  mediump vec3 scalePerBasisVector_22;
  mediump vec3 lm_23;
  lowp vec3 tmpvar_24;
  tmpvar_24 = (2.0 * texture2D (unity_Lightmap, xlv_TEXCOORD3).xyz);
  lm_23 = tmpvar_24;
  lowp vec3 tmpvar_25;
  tmpvar_25 = (2.0 * texture2D (unity_LightmapInd, xlv_TEXCOORD3).xyz);
  scalePerBasisVector_22 = tmpvar_25;
  lm_23 = (lm_23 * dot (clamp ((tmpvar_20 * normal_21), 0.0, 1.0), scalePerBasisVector_22));
  lowp vec3 tmpvar_26;
  tmpvar_26 = vec3((tmpvar_14 * 2.0));
  mediump vec3 tmpvar_27;
  tmpvar_27 = (tmpvar_5 * min (lm_23, tmpvar_26));
  c_1.xyz = tmpvar_27;
  c_1.w = tmpvar_12;
  c_1.xyz = (c_1.xyz + tmpvar_2);
  c_1.w = tmpvar_12;
  gl_FragData[0] = c_1;
}



#endif"
}

SubProgram "glesdesktop " {
Keywords { "DIRECTIONAL" "LIGHTMAP_ON" "DIRLIGHTMAP_ON" "SHADOWS_SCREEN" }
"!!GLES
#define SHADER_API_GLES 1
#define tex2D texture2D


#ifdef VERTEX
#define gl_ModelViewProjectionMatrix glstate_matrix_mvp
uniform mat4 glstate_matrix_mvp;
#define gl_ModelViewMatrixInverseTranspose glstate_matrix_invtrans_modelview0
uniform mat4 glstate_matrix_invtrans_modelview0;
#define gl_ModelViewMatrix glstate_matrix_modelview0
uniform mat4 glstate_matrix_modelview0;

varying highp vec4 xlv_TEXCOORD4;
varying highp vec2 xlv_TEXCOORD3;
varying highp vec3 xlv_TEXCOORD2;
varying highp vec3 xlv_TEXCOORD1;
varying highp vec4 xlv_TEXCOORD0;
uniform highp vec4 _BumpMap_ST;
uniform highp vec4 _MainTex_ST;
uniform highp vec4 unity_LightmapST;


uniform highp vec4 _ProjectionParams;
attribute vec4 _glesTANGENT;
attribute vec4 _glesMultiTexCoord1;
attribute vec4 _glesMultiTexCoord0;
attribute vec3 _glesNormal;
attribute vec4 _glesVertex;
void main ()
{
  vec4 tmpvar_1;
  tmpvar_1.xyz = normalize(_glesTANGENT.xyz);
  tmpvar_1.w = _glesTANGENT.w;
  vec3 tmpvar_2;
  tmpvar_2 = normalize(_glesNormal);
  highp vec4 tmpvar_3;
  highp vec3 tmpvar_4;
  highp vec3 tmpvar_5;
  tmpvar_4 = tmpvar_1.xyz;
  tmpvar_5 = (((tmpvar_2.yzx * tmpvar_1.zxy) - (tmpvar_2.zxy * tmpvar_1.yzx)) * _glesTANGENT.w);
  highp mat3 tmpvar_6;
  tmpvar_6[0].x = tmpvar_4.x;
  tmpvar_6[0].y = tmpvar_5.x;
  tmpvar_6[0].z = tmpvar_2.x;
  tmpvar_6[1].x = tmpvar_4.y;
  tmpvar_6[1].y = tmpvar_5.y;
  tmpvar_6[1].z = tmpvar_2.y;
  tmpvar_6[2].x = tmpvar_4.z;
  tmpvar_6[2].y = tmpvar_5.z;
  tmpvar_6[2].z = tmpvar_2.z;
  vec4 v_7;
  v_7.x = gl_ModelViewMatrixInverseTranspose[0].x;
  v_7.y = gl_ModelViewMatrixInverseTranspose[1].x;
  v_7.z = gl_ModelViewMatrixInverseTranspose[2].x;
  v_7.w = gl_ModelViewMatrixInverseTranspose[3].x;
  vec4 v_8;
  v_8.x = gl_ModelViewMatrixInverseTranspose[0].y;
  v_8.y = gl_ModelViewMatrixInverseTranspose[1].y;
  v_8.z = gl_ModelViewMatrixInverseTranspose[2].y;
  v_8.w = gl_ModelViewMatrixInverseTranspose[3].y;
  highp vec4 tmpvar_9;
  tmpvar_9 = (gl_ModelViewProjectionMatrix * _glesVertex);
  tmpvar_3.xy = ((_glesMultiTexCoord0.xy * _MainTex_ST.xy) + _MainTex_ST.zw);
  tmpvar_3.zw = ((_glesMultiTexCoord0.xy * _BumpMap_ST.xy) + _BumpMap_ST.zw);
  highp vec4 o_10;
  highp vec4 tmpvar_11;
  tmpvar_11 = (tmpvar_9 * 0.5);
  highp vec2 tmpvar_12;
  tmpvar_12.x = tmpvar_11.x;
  tmpvar_12.y = (tmpvar_11.y * _ProjectionParams.x);
  o_10.xy = (tmpvar_12 + tmpvar_11.w);
  o_10.zw = tmpvar_9.zw;
  gl_Position = tmpvar_9;
  xlv_TEXCOORD0 = tmpvar_3;
  xlv_TEXCOORD1 = (tmpvar_6 * v_7.xyz);
  xlv_TEXCOORD2 = (tmpvar_6 * v_8.xyz);
  xlv_TEXCOORD3 = ((_glesMultiTexCoord1.xy * unity_LightmapST.xy) + unity_LightmapST.zw);
  xlv_TEXCOORD4 = o_10;
}



#endif
#ifdef FRAGMENT

varying highp vec4 xlv_TEXCOORD4;
varying highp vec2 xlv_TEXCOORD3;
varying highp vec3 xlv_TEXCOORD2;
varying highp vec3 xlv_TEXCOORD1;
varying highp vec4 xlv_TEXCOORD0;
uniform lowp float _Cutoff;
uniform sampler2D unity_LightmapInd;
uniform sampler2D unity_Lightmap;
uniform sampler2D _Shade;
uniform sampler2D _BumpMap;
uniform sampler2D _MainTex;
uniform lowp vec4 _Color;
uniform sampler2D _ShadowMapTexture;
void main ()
{
  lowp vec4 c_1;
  lowp vec3 tmpvar_2;
  highp vec3 matcap_3;
  lowp vec3 normal_4;
  normal_4.xy = ((texture2D (_BumpMap, xlv_TEXCOORD0.zw).wy * 2.0) - 1.0);
  normal_4.z = sqrt(((1.0 - (normal_4.x * normal_4.x)) - (normal_4.y * normal_4.y)));
  lowp vec3 tmpvar_5;
  tmpvar_5 = (texture2D (_MainTex, xlv_TEXCOORD0.xy).xyz * _Color.w);
  highp vec2 tmpvar_6;
  tmpvar_6.x = dot (xlv_TEXCOORD1, normal_4);
  tmpvar_6.y = dot (xlv_TEXCOORD2, normal_4);
  highp vec2 P_7;
  P_7 = ((tmpvar_6 * 0.5) + 0.5);
  lowp vec3 tmpvar_8;
  tmpvar_8 = texture2D (_Shade, P_7).xyz;
  matcap_3 = tmpvar_8;
  lowp vec4 tmpvar_9;
  tmpvar_9 = texture2D (_MainTex, xlv_TEXCOORD0.xy);
  highp vec3 tmpvar_10;
  tmpvar_10 = (((matcap_3 * tmpvar_9.xyz) * _Color.xyz) * 3.0);
  tmpvar_2 = tmpvar_10;
  lowp vec4 tmpvar_11;
  tmpvar_11 = texture2D (_MainTex, xlv_TEXCOORD0.xy);
  lowp float tmpvar_12;
  tmpvar_12 = tmpvar_11.w;
  lowp float x_13;
  x_13 = (tmpvar_11.w - _Cutoff);
  if ((x_13 < 0.0)) {
    discard;
  };
  lowp vec4 tmpvar_14;
  tmpvar_14 = texture2DProj (_ShadowMapTexture, xlv_TEXCOORD4);
  lowp vec4 tmpvar_15;
  tmpvar_15 = texture2D (unity_Lightmap, xlv_TEXCOORD3);
  lowp vec4 tmpvar_16;
  tmpvar_16 = texture2D (unity_LightmapInd, xlv_TEXCOORD3);
  mat3 tmpvar_17;
  tmpvar_17[0].x = 0.816497;
  tmpvar_17[0].y = -0.408248;
  tmpvar_17[0].z = -0.408248;
  tmpvar_17[1].x = 0.0;
  tmpvar_17[1].y = 0.707107;
  tmpvar_17[1].z = -0.707107;
  tmpvar_17[2].x = 0.57735;
  tmpvar_17[2].y = 0.57735;
  tmpvar_17[2].z = 0.57735;
  mediump vec3 normal_18;
  normal_18 = normal_4;
  mediump vec3 scalePerBasisVector_19;
  mediump vec3 lm_20;
  lowp vec3 tmpvar_21;
  tmpvar_21 = ((8.0 * tmpvar_15.w) * tmpvar_15.xyz);
  lm_20 = tmpvar_21;
  lowp vec3 tmpvar_22;
  tmpvar_22 = ((8.0 * tmpvar_16.w) * tmpvar_16.xyz);
  scalePerBasisVector_19 = tmpvar_22;
  lm_20 = (lm_20 * dot (clamp ((tmpvar_17 * normal_18), 0.0, 1.0), scalePerBasisVector_19));
  lowp vec3 arg1_23;
  arg1_23 = ((tmpvar_14.x * 2.0) * tmpvar_15.xyz);
  mediump vec3 tmpvar_24;
  tmpvar_24 = (tmpvar_5 * max (min (lm_20, arg1_23), (lm_20 * tmpvar_14.x)));
  c_1.xyz = tmpvar_24;
  c_1.w = tmpvar_12;
  c_1.xyz = (c_1.xyz + tmpvar_2);
  c_1.w = tmpvar_12;
  gl_FragData[0] = c_1;
}



#endif"
}

SubProgram "flash " {
Keywords { "DIRECTIONAL" "LIGHTMAP_ON" "DIRLIGHTMAP_ON" "SHADOWS_SCREEN" }
Bind "vertex" Vertex
Bind "tangent" TexCoord2
Bind "normal" Normal
Bind "texcoord" TexCoord0
Bind "texcoord1" TexCoord1
Matrix 0 [glstate_matrix_mvp]
Matrix 4 [glstate_matrix_invtrans_modelview0]
Vector 16 [_ProjectionParams]
Vector 17 [unity_NPOTScale]
Vector 18 [unity_LightmapST]
Vector 19 [_MainTex_ST]
Vector 20 [_BumpMap_ST]
"agal_vs
c21 0.5 0.0 0.0 0.0
[bc]
aaaaaaaaaaaaahacafaaaaoeaaaaaaaaaaaaaaaaaaaaaaaa mov r0.xyz, a5
adaaaaaaabaaahacabaaaancaaaaaaaaaaaaaaajacaaaaaa mul r1.xyz, a1.zxyw, r0.yzxx
aaaaaaaaaaaaahacafaaaaoeaaaaaaaaaaaaaaaaaaaaaaaa mov r0.xyz, a5
adaaaaaaacaaahacabaaaamjaaaaaaaaaaaaaafcacaaaaaa mul r2.xyz, a1.yzxw, r0.zxyy
acaaaaaaaaaaahacacaaaakeacaaaaaaabaaaakeacaaaaaa sub r0.xyz, r2.xyzz, r1.xyzz
adaaaaaaabaaahacaaaaaakeacaaaaaaafaaaappaaaaaaaa mul r1.xyz, r0.xyzz, a5.w
bdaaaaaaaaaaaiacaaaaaaoeaaaaaaaaadaaaaoeabaaaaaa dp4 r0.w, a0, c3
bdaaaaaaaaaaaeacaaaaaaoeaaaaaaaaacaaaaoeabaaaaaa dp4 r0.z, a0, c2
bcaaaaaaabaaacaeabaaaakeacaaaaaaaeaaaaoeabaaaaaa dp3 v1.y, r1.xyzz, c4
bdaaaaaaaaaaabacaaaaaaoeaaaaaaaaaaaaaaoeabaaaaaa dp4 r0.x, a0, c0
bdaaaaaaaaaaacacaaaaaaoeaaaaaaaaabaaaaoeabaaaaaa dp4 r0.y, a0, c1
adaaaaaaacaaahacaaaaaapeacaaaaaabfaaaaaaabaaaaaa mul r2.xyz, r0.xyww, c21.x
bcaaaaaaacaaacaeabaaaakeacaaaaaaafaaaaoeabaaaaaa dp3 v2.y, r1.xyzz, c5
adaaaaaaabaaacacacaaaaffacaaaaaabaaaaaaaabaaaaaa mul r1.y, r2.y, c16.x
aaaaaaaaabaaabacacaaaaaaacaaaaaaaaaaaaaaaaaaaaaa mov r1.x, r2.x
abaaaaaaabaaadacabaaaafeacaaaaaaacaaaakkacaaaaaa add r1.xy, r1.xyyy, r2.z
adaaaaaaaeaaadaeabaaaafeacaaaaaabbaaaaoeabaaaaaa mul v4.xy, r1.xyyy, c17
aaaaaaaaaaaaapadaaaaaaoeacaaaaaaaaaaaaaaaaaaaaaa mov o0, r0
aaaaaaaaaeaaamaeaaaaaaopacaaaaaaaaaaaaaaaaaaaaaa mov v4.zw, r0.wwzw
adaaaaaaaaaaamacadaaaaeeaaaaaaaabeaaaaeeabaaaaaa mul r0.zw, a3.xyxy, c20.xyxy
abaaaaaaaaaaamaeaaaaaaopacaaaaaabeaaaaoeabaaaaaa add v0.zw, r0.wwzw, c20
adaaaaaaaaaaadacadaaaaoeaaaaaaaabdaaaaoeabaaaaaa mul r0.xy, a3, c19
abaaaaaaaaaaadaeaaaaaafeacaaaaaabdaaaaooabaaaaaa add v0.xy, r0.xyyy, c19.zwzw
adaaaaaaaaaaadacaeaaaaoeaaaaaaaabcaaaaoeabaaaaaa mul r0.xy, a4, c18
abaaaaaaadaaadaeaaaaaafeacaaaaaabcaaaaooabaaaaaa add v3.xy, r0.xyyy, c18.zwzw
bcaaaaaaabaaaeaeabaaaaoeaaaaaaaaaeaaaaoeabaaaaaa dp3 v1.z, a1, c4
bcaaaaaaabaaabaeafaaaaoeaaaaaaaaaeaaaaoeabaaaaaa dp3 v1.x, a5, c4
bcaaaaaaacaaaeaeabaaaaoeaaaaaaaaafaaaaoeabaaaaaa dp3 v2.z, a1, c5
bcaaaaaaacaaabaeafaaaaoeaaaaaaaaafaaaaoeabaaaaaa dp3 v2.x, a5, c5
aaaaaaaaabaaaiaeaaaaaaoeabaaaaaaaaaaaaaaaaaaaaaa mov v1.w, c0
aaaaaaaaacaaaiaeaaaaaaoeabaaaaaaaaaaaaaaaaaaaaaa mov v2.w, c0
aaaaaaaaadaaamaeaaaaaaoeabaaaaaaaaaaaaaaaaaaaaaa mov v3.zw, c0
"
}

SubProgram "opengl " {
Keywords { "DIRECTIONAL" "LIGHTMAP_OFF" "DIRLIGHTMAP_OFF" "SHADOWS_OFF" "VERTEXLIGHT_ON" }
Bind "vertex" Vertex
Bind "tangent" ATTR14
Bind "normal" Normal
Bind "texcoord" TexCoord0
Vector 17 [_WorldSpaceLightPos0]
Vector 18 [unity_4LightPosX0]
Vector 19 [unity_4LightPosY0]
Vector 20 [unity_4LightPosZ0]
Vector 21 [unity_4LightAtten0]
Vector 22 [unity_LightColor0]
Vector 23 [unity_LightColor1]
Vector 24 [unity_LightColor2]
Vector 25 [unity_LightColor3]
Vector 26 [unity_SHAr]
Vector 27 [unity_SHAg]
Vector 28 [unity_SHAb]
Vector 29 [unity_SHBr]
Vector 30 [unity_SHBg]
Vector 31 [unity_SHBb]
Vector 32 [unity_SHC]
Matrix 9 [_Object2World]
Matrix 13 [_World2Object]
Vector 33 [unity_Scale]
Vector 34 [_MainTex_ST]
Vector 35 [_BumpMap_ST]
"!!ARBvp1.0
# 72 ALU
PARAM c[36] = { { 1, 0 },
		state.matrix.mvp,
		state.matrix.modelview[0].invtrans,
		program.local[9..35] };
TEMP R0;
TEMP R1;
TEMP R2;
TEMP R3;
TEMP R4;
MUL R3.xyz, vertex.normal, c[33].w;
DP4 R0.x, vertex.position, c[10];
ADD R1, -R0.x, c[19];
DP3 R3.w, R3, c[10];
DP3 R4.x, R3, c[9];
DP3 R3.x, R3, c[11];
MUL R2, R3.w, R1;
DP4 R0.x, vertex.position, c[9];
ADD R0, -R0.x, c[18];
MUL R1, R1, R1;
MOV R4.z, R3.x;
MAD R2, R4.x, R0, R2;
MOV R4.w, c[0].x;
DP4 R4.y, vertex.position, c[11];
MAD R1, R0, R0, R1;
ADD R0, -R4.y, c[20];
MAD R1, R0, R0, R1;
MAD R0, R3.x, R0, R2;
MUL R2, R1, c[21];
MOV R4.y, R3.w;
RSQ R1.x, R1.x;
RSQ R1.y, R1.y;
RSQ R1.w, R1.w;
RSQ R1.z, R1.z;
MUL R0, R0, R1;
ADD R1, R2, c[0].x;
RCP R1.x, R1.x;
RCP R1.y, R1.y;
RCP R1.w, R1.w;
RCP R1.z, R1.z;
MAX R0, R0, c[0].y;
MUL R0, R0, R1;
MUL R1.xyz, R0.y, c[23];
MAD R1.xyz, R0.x, c[22], R1;
MAD R0.xyz, R0.z, c[24], R1;
MAD R1.xyz, R0.w, c[25], R0;
MUL R0, R4.xyzz, R4.yzzx;
DP4 R3.z, R0, c[31];
DP4 R3.y, R0, c[30];
DP4 R3.x, R0, c[29];
MUL R1.w, R3, R3;
MAD R0.x, R4, R4, -R1.w;
DP4 R2.z, R4, c[28];
DP4 R2.y, R4, c[27];
DP4 R2.x, R4, c[26];
ADD R2.xyz, R2, R3;
MUL R3.xyz, R0.x, c[32];
ADD R3.xyz, R2, R3;
MOV R0.xyz, vertex.attrib[14];
MUL R2.xyz, vertex.normal.zxyw, R0.yzxw;
MAD R0.xyz, vertex.normal.yzxw, R0.zxyw, -R2;
MUL R0.xyz, R0, vertex.attrib[14].w;
ADD result.texcoord[4].xyz, R3, R1;
MOV R1, c[17];
DP4 R2.z, R1, c[15];
DP4 R2.x, R1, c[13];
DP4 R2.y, R1, c[14];
DP3 result.texcoord[3].y, R0, R2;
DP3 result.texcoord[1].y, R0, c[5];
DP3 result.texcoord[2].y, R0, c[6];
DP3 result.texcoord[3].z, vertex.normal, R2;
DP3 result.texcoord[3].x, vertex.attrib[14], R2;
MAD result.texcoord[0].zw, vertex.texcoord[0].xyxy, c[35].xyxy, c[35];
MAD result.texcoord[0].xy, vertex.texcoord[0], c[34], c[34].zwzw;
DP4 result.position.w, vertex.position, c[4];
DP4 result.position.z, vertex.position, c[3];
DP4 result.position.y, vertex.position, c[2];
DP4 result.position.x, vertex.position, c[1];
DP3 result.texcoord[1].z, vertex.normal, c[5];
DP3 result.texcoord[1].x, vertex.attrib[14], c[5];
DP3 result.texcoord[2].z, vertex.normal, c[6];
DP3 result.texcoord[2].x, vertex.attrib[14], c[6];
END
# 72 instructions, 5 R-regs
"
}

SubProgram "d3d9 " {
Keywords { "DIRECTIONAL" "LIGHTMAP_OFF" "DIRLIGHTMAP_OFF" "SHADOWS_OFF" "VERTEXLIGHT_ON" }
Bind "vertex" Vertex
Bind "tangent" TexCoord2
Bind "normal" Normal
Bind "texcoord" TexCoord0
Matrix 0 [glstate_matrix_mvp]
Matrix 4 [glstate_matrix_invtrans_modelview0]
Vector 16 [_WorldSpaceLightPos0]
Vector 17 [unity_4LightPosX0]
Vector 18 [unity_4LightPosY0]
Vector 19 [unity_4LightPosZ0]
Vector 20 [unity_4LightAtten0]
Vector 21 [unity_LightColor0]
Vector 22 [unity_LightColor1]
Vector 23 [unity_LightColor2]
Vector 24 [unity_LightColor3]
Vector 25 [unity_SHAr]
Vector 26 [unity_SHAg]
Vector 27 [unity_SHAb]
Vector 28 [unity_SHBr]
Vector 29 [unity_SHBg]
Vector 30 [unity_SHBb]
Vector 31 [unity_SHC]
Matrix 8 [_Object2World]
Matrix 12 [_World2Object]
Vector 32 [unity_Scale]
Vector 33 [_MainTex_ST]
Vector 34 [_BumpMap_ST]
"vs_2_0
; 75 ALU
def c35, 1.00000000, 0.00000000, 0, 0
dcl_position0 v0
dcl_tangent0 v1
dcl_normal0 v2
dcl_texcoord0 v3
mul r3.xyz, v2, c32.w
dp4 r0.x, v0, c9
add r1, -r0.x, c18
dp3 r3.w, r3, c9
dp3 r4.x, r3, c8
dp3 r3.x, r3, c10
mul r2, r3.w, r1
dp4 r0.x, v0, c8
add r0, -r0.x, c17
mul r1, r1, r1
mov r4.z, r3.x
mad r2, r4.x, r0, r2
mov r4.w, c35.x
dp4 r4.y, v0, c10
mad r1, r0, r0, r1
add r0, -r4.y, c19
mad r1, r0, r0, r1
mad r0, r3.x, r0, r2
mul r2, r1, c20
mov r4.y, r3.w
rsq r1.x, r1.x
rsq r1.y, r1.y
rsq r1.w, r1.w
rsq r1.z, r1.z
mul r0, r0, r1
add r1, r2, c35.x
rcp r1.x, r1.x
rcp r1.y, r1.y
rcp r1.w, r1.w
rcp r1.z, r1.z
max r0, r0, c35.y
mul r0, r0, r1
mul r1.xyz, r0.y, c22
mad r1.xyz, r0.x, c21, r1
mad r0.xyz, r0.z, c23, r1
mad r1.xyz, r0.w, c24, r0
mul r0, r4.xyzz, r4.yzzx
mul r1.w, r3, r3
dp4 r3.z, r0, c30
dp4 r3.y, r0, c29
dp4 r3.x, r0, c28
mad r1.w, r4.x, r4.x, -r1
mul r0.xyz, r1.w, c31
dp4 r2.z, r4, c27
dp4 r2.y, r4, c26
dp4 r2.x, r4, c25
add r2.xyz, r2, r3
add r2.xyz, r2, r0
mov r0.xyz, v1
add oT4.xyz, r2, r1
mul r1.xyz, v2.zxyw, r0.yzxw
mov r0.xyz, v1
mad r1.xyz, v2.yzxw, r0.zxyw, -r1
mul r2.xyz, r1, v1.w
mov r0, c14
dp4 r3.z, c16, r0
mov r1, c12
mov r0, c13
dp4 r3.x, c16, r1
dp4 r3.y, c16, r0
dp3 oT3.y, r2, r3
dp3 oT1.y, r2, c4
dp3 oT2.y, r2, c5
dp3 oT3.z, v2, r3
dp3 oT3.x, v1, r3
mad oT0.zw, v3.xyxy, c34.xyxy, c34
mad oT0.xy, v3, c33, c33.zwzw
dp4 oPos.w, v0, c3
dp4 oPos.z, v0, c2
dp4 oPos.y, v0, c1
dp4 oPos.x, v0, c0
dp3 oT1.z, v2, c4
dp3 oT1.x, v1, c4
dp3 oT2.z, v2, c5
dp3 oT2.x, v1, c5
"
}

SubProgram "d3d11 " {
Keywords { "DIRECTIONAL" "LIGHTMAP_OFF" "DIRLIGHTMAP_OFF" "SHADOWS_OFF" "VERTEXLIGHT_ON" }
Bind "vertex" Vertex
Bind "tangent" TexCoord2
Bind "normal" Normal
Bind "texcoord" TexCoord0
Bind "color" Color
ConstBuffer "$Globals" 112 // 96 used size, 7 vars
Vector 64 [_MainTex_ST] 4
Vector 80 [_BumpMap_ST] 4
ConstBuffer "UnityLighting" 400 // 400 used size, 16 vars
Vector 0 [_WorldSpaceLightPos0] 4
Vector 32 [unity_4LightPosX0] 4
Vector 48 [unity_4LightPosY0] 4
Vector 64 [unity_4LightPosZ0] 4
Vector 80 [unity_4LightAtten0] 4
Vector 96 [unity_LightColor0] 4
Vector 112 [unity_LightColor1] 4
Vector 128 [unity_LightColor2] 4
Vector 144 [unity_LightColor3] 4
Vector 288 [unity_SHAr] 4
Vector 304 [unity_SHAg] 4
Vector 320 [unity_SHAb] 4
Vector 336 [unity_SHBr] 4
Vector 352 [unity_SHBg] 4
Vector 368 [unity_SHBb] 4
Vector 384 [unity_SHC] 4
ConstBuffer "UnityPerDraw" 336 // 336 used size, 6 vars
Matrix 0 [glstate_matrix_mvp] 4
Matrix 128 [glstate_matrix_invtrans_modelview0] 4
Matrix 192 [_Object2World] 4
Matrix 256 [_World2Object] 4
Vector 320 [unity_Scale] 4
BindCB "$Globals" 0
BindCB "UnityLighting" 1
BindCB "UnityPerDraw" 2
// 69 instructions, 6 temp regs, 0 temp arrays:
// ALU 37 float, 0 int, 0 uint
// TEX 0 (0 load, 0 comp, 0 bias, 0 grad)
// FLOW 1 static, 0 dynamic
"vs_4_0
eefiecedppbakidmfibbnciajeaajalgejafaimbabaaaaaafaalaaaaadaaaaaa
cmaaaaaapeaaaaaakmabaaaaejfdeheomaaaaaaaagaaaaaaaiaaaaaajiaaaaaa
aaaaaaaaaaaaaaaaadaaaaaaaaaaaaaaapapaaaakbaaaaaaaaaaaaaaaaaaaaaa
adaaaaaaabaaaaaaapapaaaakjaaaaaaaaaaaaaaaaaaaaaaadaaaaaaacaaaaaa
ahahaaaalaaaaaaaaaaaaaaaaaaaaaaaadaaaaaaadaaaaaaapadaaaalaaaaaaa
abaaaaaaaaaaaaaaadaaaaaaaeaaaaaaapaaaaaaljaaaaaaaaaaaaaaaaaaaaaa
adaaaaaaafaaaaaaapaaaaaafaepfdejfeejepeoaafeebeoehefeofeaaeoepfc
enebemaafeeffiedepepfceeaaedepemepfcaaklepfdeheolaaaaaaaagaaaaaa
aiaaaaaajiaaaaaaaaaaaaaaabaaaaaaadaaaaaaaaaaaaaaapaaaaaakeaaaaaa
aaaaaaaaaaaaaaaaadaaaaaaabaaaaaaapaaaaaakeaaaaaaabaaaaaaaaaaaaaa
adaaaaaaacaaaaaaahaiaaaakeaaaaaaacaaaaaaaaaaaaaaadaaaaaaadaaaaaa
ahaiaaaakeaaaaaaadaaaaaaaaaaaaaaadaaaaaaaeaaaaaaahaiaaaakeaaaaaa
aeaaaaaaaaaaaaaaadaaaaaaafaaaaaaahaiaaaafdfgfpfaepfdejfeejepeoaa
feeffiedepepfceeaaklklklfdeieefcjmajaaaaeaaaabaaghacaaaafjaaaaae
egiocaaaaaaaaaaaagaaaaaafjaaaaaeegiocaaaabaaaaaabjaaaaaafjaaaaae
egiocaaaacaaaaaabfaaaaaafpaaaaadpcbabaaaaaaaaaaafpaaaaadpcbabaaa
abaaaaaafpaaaaadhcbabaaaacaaaaaafpaaaaaddcbabaaaadaaaaaaghaaaaae
pccabaaaaaaaaaaaabaaaaaagfaaaaadpccabaaaabaaaaaagfaaaaadhccabaaa
acaaaaaagfaaaaadhccabaaaadaaaaaagfaaaaadhccabaaaaeaaaaaagfaaaaad
hccabaaaafaaaaaagiaaaaacagaaaaaadiaaaaaipcaabaaaaaaaaaaafgbfbaaa
aaaaaaaaegiocaaaacaaaaaaabaaaaaadcaaaaakpcaabaaaaaaaaaaaegiocaaa
acaaaaaaaaaaaaaaagbabaaaaaaaaaaaegaobaaaaaaaaaaadcaaaaakpcaabaaa
aaaaaaaaegiocaaaacaaaaaaacaaaaaakgbkbaaaaaaaaaaaegaobaaaaaaaaaaa
dcaaaaakpccabaaaaaaaaaaaegiocaaaacaaaaaaadaaaaaapgbpbaaaaaaaaaaa
egaobaaaaaaaaaaadcaaaaaldccabaaaabaaaaaaegbabaaaadaaaaaaegiacaaa
aaaaaaaaaeaaaaaaogikcaaaaaaaaaaaaeaaaaaadcaaaaalmccabaaaabaaaaaa
agbebaaaadaaaaaaagiecaaaaaaaaaaaafaaaaaakgiocaaaaaaaaaaaafaaaaaa
diaaaaahhcaabaaaaaaaaaaajgbebaaaabaaaaaacgbjbaaaacaaaaaadcaaaaak
hcaabaaaaaaaaaaajgbebaaaacaaaaaacgbjbaaaabaaaaaaegacbaiaebaaaaaa
aaaaaaaadiaaaaahhcaabaaaaaaaaaaaegacbaaaaaaaaaaapgbpbaaaabaaaaaa
dgaaaaagbcaabaaaabaaaaaaakiacaaaacaaaaaaaiaaaaaadgaaaaagccaabaaa
abaaaaaaakiacaaaacaaaaaaajaaaaaadgaaaaagecaabaaaabaaaaaaakiacaaa
acaaaaaaakaaaaaabaaaaaahcccabaaaacaaaaaaegacbaaaaaaaaaaaegacbaaa
abaaaaaabaaaaaahbccabaaaacaaaaaaegbcbaaaabaaaaaaegacbaaaabaaaaaa
baaaaaaheccabaaaacaaaaaaegbcbaaaacaaaaaaegacbaaaabaaaaaadgaaaaag
bcaabaaaabaaaaaabkiacaaaacaaaaaaaiaaaaaadgaaaaagccaabaaaabaaaaaa
bkiacaaaacaaaaaaajaaaaaadgaaaaagecaabaaaabaaaaaabkiacaaaacaaaaaa
akaaaaaabaaaaaahcccabaaaadaaaaaaegacbaaaaaaaaaaaegacbaaaabaaaaaa
baaaaaahbccabaaaadaaaaaaegbcbaaaabaaaaaaegacbaaaabaaaaaabaaaaaah
eccabaaaadaaaaaaegbcbaaaacaaaaaaegacbaaaabaaaaaadiaaaaajhcaabaaa
abaaaaaafgifcaaaabaaaaaaaaaaaaaaegiccaaaacaaaaaabbaaaaaadcaaaaal
hcaabaaaabaaaaaaegiccaaaacaaaaaabaaaaaaaagiacaaaabaaaaaaaaaaaaaa
egacbaaaabaaaaaadcaaaaalhcaabaaaabaaaaaaegiccaaaacaaaaaabcaaaaaa
kgikcaaaabaaaaaaaaaaaaaaegacbaaaabaaaaaadcaaaaalhcaabaaaabaaaaaa
egiccaaaacaaaaaabdaaaaaapgipcaaaabaaaaaaaaaaaaaaegacbaaaabaaaaaa
baaaaaahcccabaaaaeaaaaaaegacbaaaaaaaaaaaegacbaaaabaaaaaabaaaaaah
bccabaaaaeaaaaaaegbcbaaaabaaaaaaegacbaaaabaaaaaabaaaaaaheccabaaa
aeaaaaaaegbcbaaaacaaaaaaegacbaaaabaaaaaadgaaaaaficaabaaaaaaaaaaa
abeaaaaaaaaaiadpdiaaaaaihcaabaaaabaaaaaaegbcbaaaacaaaaaapgipcaaa
acaaaaaabeaaaaaadiaaaaaihcaabaaaacaaaaaafgafbaaaabaaaaaaegiccaaa
acaaaaaaanaaaaaadcaaaaaklcaabaaaabaaaaaaegiicaaaacaaaaaaamaaaaaa
agaabaaaabaaaaaaegaibaaaacaaaaaadcaaaaakhcaabaaaaaaaaaaaegiccaaa
acaaaaaaaoaaaaaakgakbaaaabaaaaaaegadbaaaabaaaaaabbaaaaaibcaabaaa
abaaaaaaegiocaaaabaaaaaabcaaaaaaegaobaaaaaaaaaaabbaaaaaiccaabaaa
abaaaaaaegiocaaaabaaaaaabdaaaaaaegaobaaaaaaaaaaabbaaaaaiecaabaaa
abaaaaaaegiocaaaabaaaaaabeaaaaaaegaobaaaaaaaaaaadiaaaaahpcaabaaa
acaaaaaajgacbaaaaaaaaaaaegakbaaaaaaaaaaabbaaaaaibcaabaaaadaaaaaa
egiocaaaabaaaaaabfaaaaaaegaobaaaacaaaaaabbaaaaaiccaabaaaadaaaaaa
egiocaaaabaaaaaabgaaaaaaegaobaaaacaaaaaabbaaaaaiecaabaaaadaaaaaa
egiocaaaabaaaaaabhaaaaaaegaobaaaacaaaaaaaaaaaaahhcaabaaaabaaaaaa
egacbaaaabaaaaaaegacbaaaadaaaaaadiaaaaahicaabaaaaaaaaaaabkaabaaa
aaaaaaaabkaabaaaaaaaaaaadcaaaaakicaabaaaaaaaaaaaakaabaaaaaaaaaaa
akaabaaaaaaaaaaadkaabaiaebaaaaaaaaaaaaaadcaaaaakhcaabaaaabaaaaaa
egiccaaaabaaaaaabiaaaaaapgapbaaaaaaaaaaaegacbaaaabaaaaaadiaaaaai
hcaabaaaacaaaaaafgbfbaaaaaaaaaaaegiccaaaacaaaaaaanaaaaaadcaaaaak
hcaabaaaacaaaaaaegiccaaaacaaaaaaamaaaaaaagbabaaaaaaaaaaaegacbaaa
acaaaaaadcaaaaakhcaabaaaacaaaaaaegiccaaaacaaaaaaaoaaaaaakgbkbaaa
aaaaaaaaegacbaaaacaaaaaadcaaaaakhcaabaaaacaaaaaaegiccaaaacaaaaaa
apaaaaaapgbpbaaaaaaaaaaaegacbaaaacaaaaaaaaaaaaajpcaabaaaadaaaaaa
fgafbaiaebaaaaaaacaaaaaaegiocaaaabaaaaaaadaaaaaadiaaaaahpcaabaaa
aeaaaaaafgafbaaaaaaaaaaaegaobaaaadaaaaaadiaaaaahpcaabaaaadaaaaaa
egaobaaaadaaaaaaegaobaaaadaaaaaaaaaaaaajpcaabaaaafaaaaaaagaabaia
ebaaaaaaacaaaaaaegiocaaaabaaaaaaacaaaaaaaaaaaaajpcaabaaaacaaaaaa
kgakbaiaebaaaaaaacaaaaaaegiocaaaabaaaaaaaeaaaaaadcaaaaajpcaabaaa
aeaaaaaaegaobaaaafaaaaaaagaabaaaaaaaaaaaegaobaaaaeaaaaaadcaaaaaj
pcaabaaaaaaaaaaaegaobaaaacaaaaaakgakbaaaaaaaaaaaegaobaaaaeaaaaaa
dcaaaaajpcaabaaaadaaaaaaegaobaaaafaaaaaaegaobaaaafaaaaaaegaobaaa
adaaaaaadcaaaaajpcaabaaaacaaaaaaegaobaaaacaaaaaaegaobaaaacaaaaaa
egaobaaaadaaaaaaeeaaaaafpcaabaaaadaaaaaaegaobaaaacaaaaaadcaaaaan
pcaabaaaacaaaaaaegaobaaaacaaaaaaegiocaaaabaaaaaaafaaaaaaaceaaaaa
aaaaiadpaaaaiadpaaaaiadpaaaaiadpaoaaaaakpcaabaaaacaaaaaaaceaaaaa
aaaaiadpaaaaiadpaaaaiadpaaaaiadpegaobaaaacaaaaaadiaaaaahpcaabaaa
aaaaaaaaegaobaaaaaaaaaaaegaobaaaadaaaaaadeaaaaakpcaabaaaaaaaaaaa
egaobaaaaaaaaaaaaceaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaadiaaaaah
pcaabaaaaaaaaaaaegaobaaaacaaaaaaegaobaaaaaaaaaaadiaaaaaihcaabaaa
acaaaaaafgafbaaaaaaaaaaaegiccaaaabaaaaaaahaaaaaadcaaaaakhcaabaaa
acaaaaaaegiccaaaabaaaaaaagaaaaaaagaabaaaaaaaaaaaegacbaaaacaaaaaa
dcaaaaakhcaabaaaaaaaaaaaegiccaaaabaaaaaaaiaaaaaakgakbaaaaaaaaaaa
egacbaaaacaaaaaadcaaaaakhcaabaaaaaaaaaaaegiccaaaabaaaaaaajaaaaaa
pgapbaaaaaaaaaaaegacbaaaaaaaaaaaaaaaaaahhccabaaaafaaaaaaegacbaaa
aaaaaaaaegacbaaaabaaaaaadoaaaaab"
}

SubProgram "gles " {
Keywords { "DIRECTIONAL" "LIGHTMAP_OFF" "DIRLIGHTMAP_OFF" "SHADOWS_OFF" "VERTEXLIGHT_ON" }
"!!GLES
#define SHADER_API_GLES 1
#define tex2D texture2D


#ifdef VERTEX
#define gl_ModelViewProjectionMatrix glstate_matrix_mvp
uniform mat4 glstate_matrix_mvp;
#define gl_ModelViewMatrixInverseTranspose glstate_matrix_invtrans_modelview0
uniform mat4 glstate_matrix_invtrans_modelview0;
#define gl_ModelViewMatrix glstate_matrix_modelview0
uniform mat4 glstate_matrix_modelview0;

varying lowp vec3 xlv_TEXCOORD4;
varying lowp vec3 xlv_TEXCOORD3;
varying highp vec3 xlv_TEXCOORD2;
varying highp vec3 xlv_TEXCOORD1;
varying highp vec4 xlv_TEXCOORD0;
uniform highp vec4 _BumpMap_ST;
uniform highp vec4 _MainTex_ST;
uniform highp vec4 unity_Scale;
uniform highp mat4 _World2Object;
uniform highp mat4 _Object2World;


uniform highp vec4 unity_SHC;
uniform highp vec4 unity_SHBb;
uniform highp vec4 unity_SHBg;
uniform highp vec4 unity_SHBr;
uniform highp vec4 unity_SHAb;
uniform highp vec4 unity_SHAg;
uniform highp vec4 unity_SHAr;
uniform highp vec4 unity_LightColor[4];
uniform highp vec4 unity_4LightAtten0;
uniform highp vec4 unity_4LightPosZ0;
uniform highp vec4 unity_4LightPosY0;
uniform highp vec4 unity_4LightPosX0;
uniform lowp vec4 _WorldSpaceLightPos0;
attribute vec4 _glesTANGENT;
attribute vec4 _glesMultiTexCoord0;
attribute vec3 _glesNormal;
attribute vec4 _glesVertex;
void main ()
{
  vec4 tmpvar_1;
  tmpvar_1.xyz = normalize(_glesTANGENT.xyz);
  tmpvar_1.w = _glesTANGENT.w;
  vec3 tmpvar_2;
  tmpvar_2 = normalize(_glesNormal);
  highp vec3 shlight_3;
  highp vec4 tmpvar_4;
  lowp vec3 tmpvar_5;
  lowp vec3 tmpvar_6;
  highp vec3 tmpvar_7;
  highp vec3 tmpvar_8;
  tmpvar_7 = tmpvar_1.xyz;
  tmpvar_8 = (((tmpvar_2.yzx * tmpvar_1.zxy) - (tmpvar_2.zxy * tmpvar_1.yzx)) * _glesTANGENT.w);
  highp mat3 tmpvar_9;
  tmpvar_9[0].x = tmpvar_7.x;
  tmpvar_9[0].y = tmpvar_8.x;
  tmpvar_9[0].z = tmpvar_2.x;
  tmpvar_9[1].x = tmpvar_7.y;
  tmpvar_9[1].y = tmpvar_8.y;
  tmpvar_9[1].z = tmpvar_2.y;
  tmpvar_9[2].x = tmpvar_7.z;
  tmpvar_9[2].y = tmpvar_8.z;
  tmpvar_9[2].z = tmpvar_2.z;
  vec4 v_10;
  v_10.x = gl_ModelViewMatrixInverseTranspose[0].x;
  v_10.y = gl_ModelViewMatrixInverseTranspose[1].x;
  v_10.z = gl_ModelViewMatrixInverseTranspose[2].x;
  v_10.w = gl_ModelViewMatrixInverseTranspose[3].x;
  vec4 v_11;
  v_11.x = gl_ModelViewMatrixInverseTranspose[0].y;
  v_11.y = gl_ModelViewMatrixInverseTranspose[1].y;
  v_11.z = gl_ModelViewMatrixInverseTranspose[2].y;
  v_11.w = gl_ModelViewMatrixInverseTranspose[3].y;
  tmpvar_4.xy = ((_glesMultiTexCoord0.xy * _MainTex_ST.xy) + _MainTex_ST.zw);
  tmpvar_4.zw = ((_glesMultiTexCoord0.xy * _BumpMap_ST.xy) + _BumpMap_ST.zw);
  mat3 tmpvar_12;
  tmpvar_12[0] = _Object2World[0].xyz;
  tmpvar_12[1] = _Object2World[1].xyz;
  tmpvar_12[2] = _Object2World[2].xyz;
  highp vec3 tmpvar_13;
  tmpvar_13 = (tmpvar_12 * (tmpvar_2 * unity_Scale.w));
  highp vec3 tmpvar_14;
  highp vec3 tmpvar_15;
  tmpvar_14 = tmpvar_1.xyz;
  tmpvar_15 = (((tmpvar_2.yzx * tmpvar_1.zxy) - (tmpvar_2.zxy * tmpvar_1.yzx)) * _glesTANGENT.w);
  highp mat3 tmpvar_16;
  tmpvar_16[0].x = tmpvar_14.x;
  tmpvar_16[0].y = tmpvar_15.x;
  tmpvar_16[0].z = tmpvar_2.x;
  tmpvar_16[1].x = tmpvar_14.y;
  tmpvar_16[1].y = tmpvar_15.y;
  tmpvar_16[1].z = tmpvar_2.y;
  tmpvar_16[2].x = tmpvar_14.z;
  tmpvar_16[2].y = tmpvar_15.z;
  tmpvar_16[2].z = tmpvar_2.z;
  highp vec3 tmpvar_17;
  tmpvar_17 = (tmpvar_16 * (_World2Object * _WorldSpaceLightPos0).xyz);
  tmpvar_5 = tmpvar_17;
  highp vec4 tmpvar_18;
  tmpvar_18.w = 1.0;
  tmpvar_18.xyz = tmpvar_13;
  mediump vec3 tmpvar_19;
  mediump vec4 normal_20;
  normal_20 = tmpvar_18;
  highp float vC_21;
  mediump vec3 x3_22;
  mediump vec3 x2_23;
  mediump vec3 x1_24;
  highp float tmpvar_25;
  tmpvar_25 = dot (unity_SHAr, normal_20);
  x1_24.x = tmpvar_25;
  highp float tmpvar_26;
  tmpvar_26 = dot (unity_SHAg, normal_20);
  x1_24.y = tmpvar_26;
  highp float tmpvar_27;
  tmpvar_27 = dot (unity_SHAb, normal_20);
  x1_24.z = tmpvar_27;
  mediump vec4 tmpvar_28;
  tmpvar_28 = (normal_20.xyzz * normal_20.yzzx);
  highp float tmpvar_29;
  tmpvar_29 = dot (unity_SHBr, tmpvar_28);
  x2_23.x = tmpvar_29;
  highp float tmpvar_30;
  tmpvar_30 = dot (unity_SHBg, tmpvar_28);
  x2_23.y = tmpvar_30;
  highp float tmpvar_31;
  tmpvar_31 = dot (unity_SHBb, tmpvar_28);
  x2_23.z = tmpvar_31;
  mediump float tmpvar_32;
  tmpvar_32 = ((normal_20.x * normal_20.x) - (normal_20.y * normal_20.y));
  vC_21 = tmpvar_32;
  highp vec3 tmpvar_33;
  tmpvar_33 = (unity_SHC.xyz * vC_21);
  x3_22 = tmpvar_33;
  tmpvar_19 = ((x1_24 + x2_23) + x3_22);
  shlight_3 = tmpvar_19;
  tmpvar_6 = shlight_3;
  highp vec3 tmpvar_34;
  tmpvar_34 = (_Object2World * _glesVertex).xyz;
  highp vec4 tmpvar_35;
  tmpvar_35 = (unity_4LightPosX0 - tmpvar_34.x);
  highp vec4 tmpvar_36;
  tmpvar_36 = (unity_4LightPosY0 - tmpvar_34.y);
  highp vec4 tmpvar_37;
  tmpvar_37 = (unity_4LightPosZ0 - tmpvar_34.z);
  highp vec4 tmpvar_38;
  tmpvar_38 = (((tmpvar_35 * tmpvar_35) + (tmpvar_36 * tmpvar_36)) + (tmpvar_37 * tmpvar_37));
  highp vec4 tmpvar_39;
  tmpvar_39 = (max (vec4(0.0, 0.0, 0.0, 0.0), ((((tmpvar_35 * tmpvar_13.x) + (tmpvar_36 * tmpvar_13.y)) + (tmpvar_37 * tmpvar_13.z)) * inversesqrt(tmpvar_38))) * (1.0/((1.0 + (tmpvar_38 * unity_4LightAtten0)))));
  highp vec3 tmpvar_40;
  tmpvar_40 = (tmpvar_6 + ((((unity_LightColor[0].xyz * tmpvar_39.x) + (unity_LightColor[1].xyz * tmpvar_39.y)) + (unity_LightColor[2].xyz * tmpvar_39.z)) + (unity_LightColor[3].xyz * tmpvar_39.w)));
  tmpvar_6 = tmpvar_40;
  gl_Position = (gl_ModelViewProjectionMatrix * _glesVertex);
  xlv_TEXCOORD0 = tmpvar_4;
  xlv_TEXCOORD1 = (tmpvar_9 * v_10.xyz);
  xlv_TEXCOORD2 = (tmpvar_9 * v_11.xyz);
  xlv_TEXCOORD3 = tmpvar_5;
  xlv_TEXCOORD4 = tmpvar_6;
}



#endif
#ifdef FRAGMENT

varying lowp vec3 xlv_TEXCOORD4;
varying lowp vec3 xlv_TEXCOORD3;
varying highp vec3 xlv_TEXCOORD2;
varying highp vec3 xlv_TEXCOORD1;
varying highp vec4 xlv_TEXCOORD0;
uniform lowp float _Cutoff;
uniform sampler2D _Shade;
uniform sampler2D _BumpMap;
uniform sampler2D _MainTex;
uniform lowp vec4 _Color;
uniform lowp vec4 _LightColor0;
void main ()
{
  lowp vec4 c_1;
  lowp vec3 tmpvar_2;
  highp vec3 matcap_3;
  lowp vec3 tmpvar_4;
  tmpvar_4 = ((texture2D (_BumpMap, xlv_TEXCOORD0.zw).xyz * 2.0) - 1.0);
  lowp vec3 tmpvar_5;
  tmpvar_5 = (texture2D (_MainTex, xlv_TEXCOORD0.xy).xyz * _Color.w);
  highp vec2 tmpvar_6;
  tmpvar_6.x = dot (xlv_TEXCOORD1, tmpvar_4);
  tmpvar_6.y = dot (xlv_TEXCOORD2, tmpvar_4);
  highp vec2 P_7;
  P_7 = ((tmpvar_6 * 0.5) + 0.5);
  lowp vec3 tmpvar_8;
  tmpvar_8 = texture2D (_Shade, P_7).xyz;
  matcap_3 = tmpvar_8;
  lowp vec4 tmpvar_9;
  tmpvar_9 = texture2D (_MainTex, xlv_TEXCOORD0.xy);
  highp vec3 tmpvar_10;
  tmpvar_10 = (((matcap_3 * tmpvar_9.xyz) * _Color.xyz) * 3.0);
  tmpvar_2 = tmpvar_10;
  lowp vec4 tmpvar_11;
  tmpvar_11 = texture2D (_MainTex, xlv_TEXCOORD0.xy);
  lowp float tmpvar_12;
  tmpvar_12 = tmpvar_11.w;
  lowp float x_13;
  x_13 = (tmpvar_11.w - _Cutoff);
  if ((x_13 < 0.0)) {
    discard;
  };
  lowp vec4 c_14;
  c_14.xyz = ((tmpvar_5 * _LightColor0.xyz) * (max (0.0, dot (tmpvar_4, xlv_TEXCOORD3)) * 2.0));
  c_14.w = tmpvar_12;
  c_1.w = c_14.w;
  c_1.xyz = (c_14.xyz + (tmpvar_5 * xlv_TEXCOORD4));
  c_1.xyz = (c_1.xyz + tmpvar_2);
  c_1.w = tmpvar_12;
  gl_FragData[0] = c_1;
}



#endif"
}

SubProgram "glesdesktop " {
Keywords { "DIRECTIONAL" "LIGHTMAP_OFF" "DIRLIGHTMAP_OFF" "SHADOWS_OFF" "VERTEXLIGHT_ON" }
"!!GLES
#define SHADER_API_GLES 1
#define tex2D texture2D


#ifdef VERTEX
#define gl_ModelViewProjectionMatrix glstate_matrix_mvp
uniform mat4 glstate_matrix_mvp;
#define gl_ModelViewMatrixInverseTranspose glstate_matrix_invtrans_modelview0
uniform mat4 glstate_matrix_invtrans_modelview0;
#define gl_ModelViewMatrix glstate_matrix_modelview0
uniform mat4 glstate_matrix_modelview0;

varying lowp vec3 xlv_TEXCOORD4;
varying lowp vec3 xlv_TEXCOORD3;
varying highp vec3 xlv_TEXCOORD2;
varying highp vec3 xlv_TEXCOORD1;
varying highp vec4 xlv_TEXCOORD0;
uniform highp vec4 _BumpMap_ST;
uniform highp vec4 _MainTex_ST;
uniform highp vec4 unity_Scale;
uniform highp mat4 _World2Object;
uniform highp mat4 _Object2World;


uniform highp vec4 unity_SHC;
uniform highp vec4 unity_SHBb;
uniform highp vec4 unity_SHBg;
uniform highp vec4 unity_SHBr;
uniform highp vec4 unity_SHAb;
uniform highp vec4 unity_SHAg;
uniform highp vec4 unity_SHAr;
uniform highp vec4 unity_LightColor[4];
uniform highp vec4 unity_4LightAtten0;
uniform highp vec4 unity_4LightPosZ0;
uniform highp vec4 unity_4LightPosY0;
uniform highp vec4 unity_4LightPosX0;
uniform lowp vec4 _WorldSpaceLightPos0;
attribute vec4 _glesTANGENT;
attribute vec4 _glesMultiTexCoord0;
attribute vec3 _glesNormal;
attribute vec4 _glesVertex;
void main ()
{
  vec4 tmpvar_1;
  tmpvar_1.xyz = normalize(_glesTANGENT.xyz);
  tmpvar_1.w = _glesTANGENT.w;
  vec3 tmpvar_2;
  tmpvar_2 = normalize(_glesNormal);
  highp vec3 shlight_3;
  highp vec4 tmpvar_4;
  lowp vec3 tmpvar_5;
  lowp vec3 tmpvar_6;
  highp vec3 tmpvar_7;
  highp vec3 tmpvar_8;
  tmpvar_7 = tmpvar_1.xyz;
  tmpvar_8 = (((tmpvar_2.yzx * tmpvar_1.zxy) - (tmpvar_2.zxy * tmpvar_1.yzx)) * _glesTANGENT.w);
  highp mat3 tmpvar_9;
  tmpvar_9[0].x = tmpvar_7.x;
  tmpvar_9[0].y = tmpvar_8.x;
  tmpvar_9[0].z = tmpvar_2.x;
  tmpvar_9[1].x = tmpvar_7.y;
  tmpvar_9[1].y = tmpvar_8.y;
  tmpvar_9[1].z = tmpvar_2.y;
  tmpvar_9[2].x = tmpvar_7.z;
  tmpvar_9[2].y = tmpvar_8.z;
  tmpvar_9[2].z = tmpvar_2.z;
  vec4 v_10;
  v_10.x = gl_ModelViewMatrixInverseTranspose[0].x;
  v_10.y = gl_ModelViewMatrixInverseTranspose[1].x;
  v_10.z = gl_ModelViewMatrixInverseTranspose[2].x;
  v_10.w = gl_ModelViewMatrixInverseTranspose[3].x;
  vec4 v_11;
  v_11.x = gl_ModelViewMatrixInverseTranspose[0].y;
  v_11.y = gl_ModelViewMatrixInverseTranspose[1].y;
  v_11.z = gl_ModelViewMatrixInverseTranspose[2].y;
  v_11.w = gl_ModelViewMatrixInverseTranspose[3].y;
  tmpvar_4.xy = ((_glesMultiTexCoord0.xy * _MainTex_ST.xy) + _MainTex_ST.zw);
  tmpvar_4.zw = ((_glesMultiTexCoord0.xy * _BumpMap_ST.xy) + _BumpMap_ST.zw);
  mat3 tmpvar_12;
  tmpvar_12[0] = _Object2World[0].xyz;
  tmpvar_12[1] = _Object2World[1].xyz;
  tmpvar_12[2] = _Object2World[2].xyz;
  highp vec3 tmpvar_13;
  tmpvar_13 = (tmpvar_12 * (tmpvar_2 * unity_Scale.w));
  highp vec3 tmpvar_14;
  highp vec3 tmpvar_15;
  tmpvar_14 = tmpvar_1.xyz;
  tmpvar_15 = (((tmpvar_2.yzx * tmpvar_1.zxy) - (tmpvar_2.zxy * tmpvar_1.yzx)) * _glesTANGENT.w);
  highp mat3 tmpvar_16;
  tmpvar_16[0].x = tmpvar_14.x;
  tmpvar_16[0].y = tmpvar_15.x;
  tmpvar_16[0].z = tmpvar_2.x;
  tmpvar_16[1].x = tmpvar_14.y;
  tmpvar_16[1].y = tmpvar_15.y;
  tmpvar_16[1].z = tmpvar_2.y;
  tmpvar_16[2].x = tmpvar_14.z;
  tmpvar_16[2].y = tmpvar_15.z;
  tmpvar_16[2].z = tmpvar_2.z;
  highp vec3 tmpvar_17;
  tmpvar_17 = (tmpvar_16 * (_World2Object * _WorldSpaceLightPos0).xyz);
  tmpvar_5 = tmpvar_17;
  highp vec4 tmpvar_18;
  tmpvar_18.w = 1.0;
  tmpvar_18.xyz = tmpvar_13;
  mediump vec3 tmpvar_19;
  mediump vec4 normal_20;
  normal_20 = tmpvar_18;
  highp float vC_21;
  mediump vec3 x3_22;
  mediump vec3 x2_23;
  mediump vec3 x1_24;
  highp float tmpvar_25;
  tmpvar_25 = dot (unity_SHAr, normal_20);
  x1_24.x = tmpvar_25;
  highp float tmpvar_26;
  tmpvar_26 = dot (unity_SHAg, normal_20);
  x1_24.y = tmpvar_26;
  highp float tmpvar_27;
  tmpvar_27 = dot (unity_SHAb, normal_20);
  x1_24.z = tmpvar_27;
  mediump vec4 tmpvar_28;
  tmpvar_28 = (normal_20.xyzz * normal_20.yzzx);
  highp float tmpvar_29;
  tmpvar_29 = dot (unity_SHBr, tmpvar_28);
  x2_23.x = tmpvar_29;
  highp float tmpvar_30;
  tmpvar_30 = dot (unity_SHBg, tmpvar_28);
  x2_23.y = tmpvar_30;
  highp float tmpvar_31;
  tmpvar_31 = dot (unity_SHBb, tmpvar_28);
  x2_23.z = tmpvar_31;
  mediump float tmpvar_32;
  tmpvar_32 = ((normal_20.x * normal_20.x) - (normal_20.y * normal_20.y));
  vC_21 = tmpvar_32;
  highp vec3 tmpvar_33;
  tmpvar_33 = (unity_SHC.xyz * vC_21);
  x3_22 = tmpvar_33;
  tmpvar_19 = ((x1_24 + x2_23) + x3_22);
  shlight_3 = tmpvar_19;
  tmpvar_6 = shlight_3;
  highp vec3 tmpvar_34;
  tmpvar_34 = (_Object2World * _glesVertex).xyz;
  highp vec4 tmpvar_35;
  tmpvar_35 = (unity_4LightPosX0 - tmpvar_34.x);
  highp vec4 tmpvar_36;
  tmpvar_36 = (unity_4LightPosY0 - tmpvar_34.y);
  highp vec4 tmpvar_37;
  tmpvar_37 = (unity_4LightPosZ0 - tmpvar_34.z);
  highp vec4 tmpvar_38;
  tmpvar_38 = (((tmpvar_35 * tmpvar_35) + (tmpvar_36 * tmpvar_36)) + (tmpvar_37 * tmpvar_37));
  highp vec4 tmpvar_39;
  tmpvar_39 = (max (vec4(0.0, 0.0, 0.0, 0.0), ((((tmpvar_35 * tmpvar_13.x) + (tmpvar_36 * tmpvar_13.y)) + (tmpvar_37 * tmpvar_13.z)) * inversesqrt(tmpvar_38))) * (1.0/((1.0 + (tmpvar_38 * unity_4LightAtten0)))));
  highp vec3 tmpvar_40;
  tmpvar_40 = (tmpvar_6 + ((((unity_LightColor[0].xyz * tmpvar_39.x) + (unity_LightColor[1].xyz * tmpvar_39.y)) + (unity_LightColor[2].xyz * tmpvar_39.z)) + (unity_LightColor[3].xyz * tmpvar_39.w)));
  tmpvar_6 = tmpvar_40;
  gl_Position = (gl_ModelViewProjectionMatrix * _glesVertex);
  xlv_TEXCOORD0 = tmpvar_4;
  xlv_TEXCOORD1 = (tmpvar_9 * v_10.xyz);
  xlv_TEXCOORD2 = (tmpvar_9 * v_11.xyz);
  xlv_TEXCOORD3 = tmpvar_5;
  xlv_TEXCOORD4 = tmpvar_6;
}



#endif
#ifdef FRAGMENT

varying lowp vec3 xlv_TEXCOORD4;
varying lowp vec3 xlv_TEXCOORD3;
varying highp vec3 xlv_TEXCOORD2;
varying highp vec3 xlv_TEXCOORD1;
varying highp vec4 xlv_TEXCOORD0;
uniform lowp float _Cutoff;
uniform sampler2D _Shade;
uniform sampler2D _BumpMap;
uniform sampler2D _MainTex;
uniform lowp vec4 _Color;
uniform lowp vec4 _LightColor0;
void main ()
{
  lowp vec4 c_1;
  lowp vec3 tmpvar_2;
  highp vec3 matcap_3;
  lowp vec3 normal_4;
  normal_4.xy = ((texture2D (_BumpMap, xlv_TEXCOORD0.zw).wy * 2.0) - 1.0);
  normal_4.z = sqrt(((1.0 - (normal_4.x * normal_4.x)) - (normal_4.y * normal_4.y)));
  lowp vec3 tmpvar_5;
  tmpvar_5 = (texture2D (_MainTex, xlv_TEXCOORD0.xy).xyz * _Color.w);
  highp vec2 tmpvar_6;
  tmpvar_6.x = dot (xlv_TEXCOORD1, normal_4);
  tmpvar_6.y = dot (xlv_TEXCOORD2, normal_4);
  highp vec2 P_7;
  P_7 = ((tmpvar_6 * 0.5) + 0.5);
  lowp vec3 tmpvar_8;
  tmpvar_8 = texture2D (_Shade, P_7).xyz;
  matcap_3 = tmpvar_8;
  lowp vec4 tmpvar_9;
  tmpvar_9 = texture2D (_MainTex, xlv_TEXCOORD0.xy);
  highp vec3 tmpvar_10;
  tmpvar_10 = (((matcap_3 * tmpvar_9.xyz) * _Color.xyz) * 3.0);
  tmpvar_2 = tmpvar_10;
  lowp vec4 tmpvar_11;
  tmpvar_11 = texture2D (_MainTex, xlv_TEXCOORD0.xy);
  lowp float tmpvar_12;
  tmpvar_12 = tmpvar_11.w;
  lowp float x_13;
  x_13 = (tmpvar_11.w - _Cutoff);
  if ((x_13 < 0.0)) {
    discard;
  };
  lowp vec4 c_14;
  c_14.xyz = ((tmpvar_5 * _LightColor0.xyz) * (max (0.0, dot (normal_4, xlv_TEXCOORD3)) * 2.0));
  c_14.w = tmpvar_12;
  c_1.w = c_14.w;
  c_1.xyz = (c_14.xyz + (tmpvar_5 * xlv_TEXCOORD4));
  c_1.xyz = (c_1.xyz + tmpvar_2);
  c_1.w = tmpvar_12;
  gl_FragData[0] = c_1;
}



#endif"
}

SubProgram "flash " {
Keywords { "DIRECTIONAL" "LIGHTMAP_OFF" "DIRLIGHTMAP_OFF" "SHADOWS_OFF" "VERTEXLIGHT_ON" }
Bind "vertex" Vertex
Bind "tangent" TexCoord2
Bind "normal" Normal
Bind "texcoord" TexCoord0
Matrix 0 [glstate_matrix_mvp]
Matrix 4 [glstate_matrix_invtrans_modelview0]
Vector 16 [_WorldSpaceLightPos0]
Vector 17 [unity_4LightPosX0]
Vector 18 [unity_4LightPosY0]
Vector 19 [unity_4LightPosZ0]
Vector 20 [unity_4LightAtten0]
Vector 21 [unity_LightColor0]
Vector 22 [unity_LightColor1]
Vector 23 [unity_LightColor2]
Vector 24 [unity_LightColor3]
Vector 25 [unity_SHAr]
Vector 26 [unity_SHAg]
Vector 27 [unity_SHAb]
Vector 28 [unity_SHBr]
Vector 29 [unity_SHBg]
Vector 30 [unity_SHBb]
Vector 31 [unity_SHC]
Matrix 8 [_Object2World]
Matrix 12 [_World2Object]
Vector 32 [unity_Scale]
Vector 33 [_MainTex_ST]
Vector 34 [_BumpMap_ST]
"agal_vs
c35 1.0 0.0 0.0 0.0
[bc]
adaaaaaaadaaahacabaaaaoeaaaaaaaacaaaaappabaaaaaa mul r3.xyz, a1, c32.w
bdaaaaaaaaaaabacaaaaaaoeaaaaaaaaajaaaaoeabaaaaaa dp4 r0.x, a0, c9
bfaaaaaaabaaabacaaaaaaaaacaaaaaaaaaaaaaaaaaaaaaa neg r1.x, r0.x
abaaaaaaabaaapacabaaaaaaacaaaaaabcaaaaoeabaaaaaa add r1, r1.x, c18
bcaaaaaaadaaaiacadaaaakeacaaaaaaajaaaaoeabaaaaaa dp3 r3.w, r3.xyzz, c9
bcaaaaaaaeaaabacadaaaakeacaaaaaaaiaaaaoeabaaaaaa dp3 r4.x, r3.xyzz, c8
bcaaaaaaadaaabacadaaaakeacaaaaaaakaaaaoeabaaaaaa dp3 r3.x, r3.xyzz, c10
adaaaaaaacaaapacadaaaappacaaaaaaabaaaaoeacaaaaaa mul r2, r3.w, r1
bdaaaaaaaaaaabacaaaaaaoeaaaaaaaaaiaaaaoeabaaaaaa dp4 r0.x, a0, c8
bfaaaaaaaaaaabacaaaaaaaaacaaaaaaaaaaaaaaaaaaaaaa neg r0.x, r0.x
abaaaaaaaaaaapacaaaaaaaaacaaaaaabbaaaaoeabaaaaaa add r0, r0.x, c17
adaaaaaaabaaapacabaaaaoeacaaaaaaabaaaaoeacaaaaaa mul r1, r1, r1
aaaaaaaaaeaaaeacadaaaaaaacaaaaaaaaaaaaaaaaaaaaaa mov r4.z, r3.x
adaaaaaaafaaapacaeaaaaaaacaaaaaaaaaaaaoeacaaaaaa mul r5, r4.x, r0
abaaaaaaacaaapacafaaaaoeacaaaaaaacaaaaoeacaaaaaa add r2, r5, r2
aaaaaaaaaeaaaiaccdaaaaaaabaaaaaaaaaaaaaaaaaaaaaa mov r4.w, c35.x
bdaaaaaaaeaaacacaaaaaaoeaaaaaaaaakaaaaoeabaaaaaa dp4 r4.y, a0, c10
adaaaaaaafaaapacaaaaaaoeacaaaaaaaaaaaaoeacaaaaaa mul r5, r0, r0
abaaaaaaabaaapacafaaaaoeacaaaaaaabaaaaoeacaaaaaa add r1, r5, r1
bfaaaaaaaaaaacacaeaaaaffacaaaaaaaaaaaaaaaaaaaaaa neg r0.y, r4.y
abaaaaaaaaaaapacaaaaaaffacaaaaaabdaaaaoeabaaaaaa add r0, r0.y, c19
adaaaaaaafaaapacaaaaaaoeacaaaaaaaaaaaaoeacaaaaaa mul r5, r0, r0
abaaaaaaabaaapacafaaaaoeacaaaaaaabaaaaoeacaaaaaa add r1, r5, r1
adaaaaaaaaaaapacadaaaaaaacaaaaaaaaaaaaoeacaaaaaa mul r0, r3.x, r0
abaaaaaaaaaaapacaaaaaaoeacaaaaaaacaaaaoeacaaaaaa add r0, r0, r2
adaaaaaaacaaapacabaaaaoeacaaaaaabeaaaaoeabaaaaaa mul r2, r1, c20
aaaaaaaaaeaaacacadaaaappacaaaaaaaaaaaaaaaaaaaaaa mov r4.y, r3.w
akaaaaaaabaaabacabaaaaaaacaaaaaaaaaaaaaaaaaaaaaa rsq r1.x, r1.x
akaaaaaaabaaacacabaaaaffacaaaaaaaaaaaaaaaaaaaaaa rsq r1.y, r1.y
akaaaaaaabaaaiacabaaaappacaaaaaaaaaaaaaaaaaaaaaa rsq r1.w, r1.w
akaaaaaaabaaaeacabaaaakkacaaaaaaaaaaaaaaaaaaaaaa rsq r1.z, r1.z
adaaaaaaaaaaapacaaaaaaoeacaaaaaaabaaaaoeacaaaaaa mul r0, r0, r1
abaaaaaaabaaapacacaaaaoeacaaaaaacdaaaaaaabaaaaaa add r1, r2, c35.x
afaaaaaaabaaabacabaaaaaaacaaaaaaaaaaaaaaaaaaaaaa rcp r1.x, r1.x
afaaaaaaabaaacacabaaaaffacaaaaaaaaaaaaaaaaaaaaaa rcp r1.y, r1.y
afaaaaaaabaaaiacabaaaappacaaaaaaaaaaaaaaaaaaaaaa rcp r1.w, r1.w
afaaaaaaabaaaeacabaaaakkacaaaaaaaaaaaaaaaaaaaaaa rcp r1.z, r1.z
ahaaaaaaaaaaapacaaaaaaoeacaaaaaacdaaaaffabaaaaaa max r0, r0, c35.y
adaaaaaaaaaaapacaaaaaaoeacaaaaaaabaaaaoeacaaaaaa mul r0, r0, r1
adaaaaaaabaaahacaaaaaaffacaaaaaabgaaaaoeabaaaaaa mul r1.xyz, r0.y, c22
adaaaaaaafaaahacaaaaaaaaacaaaaaabfaaaaoeabaaaaaa mul r5.xyz, r0.x, c21
abaaaaaaabaaahacafaaaakeacaaaaaaabaaaakeacaaaaaa add r1.xyz, r5.xyzz, r1.xyzz
adaaaaaaaaaaahacaaaaaakkacaaaaaabhaaaaoeabaaaaaa mul r0.xyz, r0.z, c23
abaaaaaaaaaaahacaaaaaakeacaaaaaaabaaaakeacaaaaaa add r0.xyz, r0.xyzz, r1.xyzz
adaaaaaaabaaahacaaaaaappacaaaaaabiaaaaoeabaaaaaa mul r1.xyz, r0.w, c24
abaaaaaaabaaahacabaaaakeacaaaaaaaaaaaakeacaaaaaa add r1.xyz, r1.xyzz, r0.xyzz
adaaaaaaaaaaapacaeaaaakeacaaaaaaaeaaaacjacaaaaaa mul r0, r4.xyzz, r4.yzzx
adaaaaaaabaaaiacadaaaappacaaaaaaadaaaappacaaaaaa mul r1.w, r3.w, r3.w
bdaaaaaaadaaaeacaaaaaaoeacaaaaaaboaaaaoeabaaaaaa dp4 r3.z, r0, c30
bdaaaaaaadaaacacaaaaaaoeacaaaaaabnaaaaoeabaaaaaa dp4 r3.y, r0, c29
bdaaaaaaadaaabacaaaaaaoeacaaaaaabmaaaaoeabaaaaaa dp4 r3.x, r0, c28
adaaaaaaafaaaiacaeaaaaaaacaaaaaaaeaaaaaaacaaaaaa mul r5.w, r4.x, r4.x
acaaaaaaabaaaiacafaaaappacaaaaaaabaaaappacaaaaaa sub r1.w, r5.w, r1.w
adaaaaaaaaaaahacabaaaappacaaaaaabpaaaaoeabaaaaaa mul r0.xyz, r1.w, c31
bdaaaaaaacaaaeacaeaaaaoeacaaaaaablaaaaoeabaaaaaa dp4 r2.z, r4, c27
bdaaaaaaacaaacacaeaaaaoeacaaaaaabkaaaaoeabaaaaaa dp4 r2.y, r4, c26
bdaaaaaaacaaabacaeaaaaoeacaaaaaabjaaaaoeabaaaaaa dp4 r2.x, r4, c25
abaaaaaaacaaahacacaaaakeacaaaaaaadaaaakeacaaaaaa add r2.xyz, r2.xyzz, r3.xyzz
abaaaaaaacaaahacacaaaakeacaaaaaaaaaaaakeacaaaaaa add r2.xyz, r2.xyzz, r0.xyzz
aaaaaaaaaaaaahacafaaaaoeaaaaaaaaaaaaaaaaaaaaaaaa mov r0.xyz, a5
abaaaaaaaeaaahaeacaaaakeacaaaaaaabaaaakeacaaaaaa add v4.xyz, r2.xyzz, r1.xyzz
adaaaaaaabaaahacabaaaancaaaaaaaaaaaaaaajacaaaaaa mul r1.xyz, a1.zxyw, r0.yzxx
aaaaaaaaaaaaahacafaaaaoeaaaaaaaaaaaaaaaaaaaaaaaa mov r0.xyz, a5
adaaaaaaafaaahacabaaaamjaaaaaaaaaaaaaafcacaaaaaa mul r5.xyz, a1.yzxw, r0.zxyy
acaaaaaaabaaahacafaaaakeacaaaaaaabaaaakeacaaaaaa sub r1.xyz, r5.xyzz, r1.xyzz
adaaaaaaacaaahacabaaaakeacaaaaaaafaaaappaaaaaaaa mul r2.xyz, r1.xyzz, a5.w
aaaaaaaaaaaaapacaoaaaaoeabaaaaaaaaaaaaaaaaaaaaaa mov r0, c14
bdaaaaaaadaaaeacbaaaaaoeabaaaaaaaaaaaaoeacaaaaaa dp4 r3.z, c16, r0
aaaaaaaaabaaapacamaaaaoeabaaaaaaaaaaaaaaaaaaaaaa mov r1, c12
aaaaaaaaaaaaapacanaaaaoeabaaaaaaaaaaaaaaaaaaaaaa mov r0, c13
bdaaaaaaadaaabacbaaaaaoeabaaaaaaabaaaaoeacaaaaaa dp4 r3.x, c16, r1
bdaaaaaaadaaacacbaaaaaoeabaaaaaaaaaaaaoeacaaaaaa dp4 r3.y, c16, r0
bcaaaaaaadaaacaeacaaaakeacaaaaaaadaaaakeacaaaaaa dp3 v3.y, r2.xyzz, r3.xyzz
bcaaaaaaabaaacaeacaaaakeacaaaaaaaeaaaaoeabaaaaaa dp3 v1.y, r2.xyzz, c4
bcaaaaaaacaaacaeacaaaakeacaaaaaaafaaaaoeabaaaaaa dp3 v2.y, r2.xyzz, c5
bcaaaaaaadaaaeaeabaaaaoeaaaaaaaaadaaaakeacaaaaaa dp3 v3.z, a1, r3.xyzz
bcaaaaaaadaaabaeafaaaaoeaaaaaaaaadaaaakeacaaaaaa dp3 v3.x, a5, r3.xyzz
adaaaaaaafaaamacadaaaaeeaaaaaaaaccaaaaeeabaaaaaa mul r5.zw, a3.xyxy, c34.xyxy
abaaaaaaaaaaamaeafaaaaopacaaaaaaccaaaaoeabaaaaaa add v0.zw, r5.wwzw, c34
adaaaaaaafaaadacadaaaaoeaaaaaaaacbaaaaoeabaaaaaa mul r5.xy, a3, c33
abaaaaaaaaaaadaeafaaaafeacaaaaaacbaaaaooabaaaaaa add v0.xy, r5.xyyy, c33.zwzw
bdaaaaaaaaaaaiadaaaaaaoeaaaaaaaaadaaaaoeabaaaaaa dp4 o0.w, a0, c3
bdaaaaaaaaaaaeadaaaaaaoeaaaaaaaaacaaaaoeabaaaaaa dp4 o0.z, a0, c2
bdaaaaaaaaaaacadaaaaaaoeaaaaaaaaabaaaaoeabaaaaaa dp4 o0.y, a0, c1
bdaaaaaaaaaaabadaaaaaaoeaaaaaaaaaaaaaaoeabaaaaaa dp4 o0.x, a0, c0
bcaaaaaaabaaaeaeabaaaaoeaaaaaaaaaeaaaaoeabaaaaaa dp3 v1.z, a1, c4
bcaaaaaaabaaabaeafaaaaoeaaaaaaaaaeaaaaoeabaaaaaa dp3 v1.x, a5, c4
bcaaaaaaacaaaeaeabaaaaoeaaaaaaaaafaaaaoeabaaaaaa dp3 v2.z, a1, c5
bcaaaaaaacaaabaeafaaaaoeaaaaaaaaafaaaaoeabaaaaaa dp3 v2.x, a5, c5
aaaaaaaaabaaaiaeaaaaaaoeabaaaaaaaaaaaaaaaaaaaaaa mov v1.w, c0
aaaaaaaaacaaaiaeaaaaaaoeabaaaaaaaaaaaaaaaaaaaaaa mov v2.w, c0
aaaaaaaaadaaaiaeaaaaaaoeabaaaaaaaaaaaaaaaaaaaaaa mov v3.w, c0
aaaaaaaaaeaaaiaeaaaaaaoeabaaaaaaaaaaaaaaaaaaaaaa mov v4.w, c0
"
}

SubProgram "d3d11_9x " {
Keywords { "DIRECTIONAL" "LIGHTMAP_OFF" "DIRLIGHTMAP_OFF" "SHADOWS_OFF" "VERTEXLIGHT_ON" }
Bind "vertex" Vertex
Bind "tangent" TexCoord2
Bind "normal" Normal
Bind "texcoord" TexCoord0
Bind "color" Color
ConstBuffer "$Globals" 112 // 96 used size, 7 vars
Vector 64 [_MainTex_ST] 4
Vector 80 [_BumpMap_ST] 4
ConstBuffer "UnityLighting" 400 // 400 used size, 16 vars
Vector 0 [_WorldSpaceLightPos0] 4
Vector 32 [unity_4LightPosX0] 4
Vector 48 [unity_4LightPosY0] 4
Vector 64 [unity_4LightPosZ0] 4
Vector 80 [unity_4LightAtten0] 4
Vector 96 [unity_LightColor0] 4
Vector 112 [unity_LightColor1] 4
Vector 128 [unity_LightColor2] 4
Vector 144 [unity_LightColor3] 4
Vector 288 [unity_SHAr] 4
Vector 304 [unity_SHAg] 4
Vector 320 [unity_SHAb] 4
Vector 336 [unity_SHBr] 4
Vector 352 [unity_SHBg] 4
Vector 368 [unity_SHBb] 4
Vector 384 [unity_SHC] 4
ConstBuffer "UnityPerDraw" 336 // 336 used size, 6 vars
Matrix 0 [glstate_matrix_mvp] 4
Matrix 128 [glstate_matrix_invtrans_modelview0] 4
Matrix 192 [_Object2World] 4
Matrix 256 [_World2Object] 4
Vector 320 [unity_Scale] 4
BindCB "$Globals" 0
BindCB "UnityLighting" 1
BindCB "UnityPerDraw" 2
// 69 instructions, 6 temp regs, 0 temp arrays:
// ALU 37 float, 0 int, 0 uint
// TEX 0 (0 load, 0 comp, 0 bias, 0 grad)
// FLOW 1 static, 0 dynamic
"vs_4_0_level_9_3
eefiecedcnkafmbbapbbpebagihdigllboifhadbabaaaaaadabbaaaaaeaaaaaa
daaaaaaaamagaaaalaapaaaahibaaaaaebgpgodjneafaaaaneafaaaaaaacpopp
fiafaaaahmaaaaaaahaaceaaaaaahiaaaaaahiaaaaaaceaaabaahiaaaaaaaeaa
acaaabaaaaaaaaaaabaaaaaaabaaadaaaaaaaaaaabaaacaaaiaaaeaaaaaaaaaa
abaabcaaahaaamaaaaaaaaaaacaaaaaaaeaabdaaaaaaaaaaacaaaiaaadaabhaa
aaaaaaaaacaaamaaajaabkaaaaaaaaaaaaaaaaaaabacpoppfbaaaaafcdaaapka
aaaaiadpaaaaaaaaaaaaaaaaaaaaaaaabpaaaaacafaaaaiaaaaaapjabpaaaaac
afaaabiaabaaapjabpaaaaacafaaaciaacaaapjabpaaaaacafaaadiaadaaapja
abaaaaacaaaaabiabhaaaakaabaaaaacaaaaaciabiaaaakaabaaaaacaaaaaeia
bjaaaakaaiaaaaadabaaaboaabaaoejaaaaaoeiaabaaaaacabaaahiaacaaoeja
afaaaaadacaaahiaabaanciaabaamjjaaeaaaaaeabaaahiaabaamjiaabaancja
acaaoeibafaaaaadabaaahiaabaaoeiaabaappjaaiaaaaadabaaacoaabaaoeia
aaaaoeiaaiaaaaadabaaaeoaacaaoejaaaaaoeiaabaaaaacaaaaabiabhaaffka
abaaaaacaaaaaciabiaaffkaabaaaaacaaaaaeiabjaaffkaaiaaaaadacaaaboa
abaaoejaaaaaoeiaaiaaaaadacaaacoaabaaoeiaaaaaoeiaaiaaaaadacaaaeoa
acaaoejaaaaaoeiaaeaaaaaeaaaaadoaadaaoejaabaaoekaabaaookaaeaaaaae
aaaaamoaadaaeejaacaaeekaacaaoekaabaaaaacaaaaapiaadaaoekaafaaaaad
acaaahiaaaaaffiabpaaoekaaeaaaaaeacaaahiaboaaoekaaaaaaaiaacaaoeia
aeaaaaaeaaaaahiacaaaoekaaaaakkiaacaaoeiaaeaaaaaeaaaaahiacbaaoeka
aaaappiaaaaaoeiaaiaaaaadadaaaboaabaaoejaaaaaoeiaaiaaaaadadaaacoa
abaaoeiaaaaaoeiaaiaaaaadadaaaeoaacaaoejaaaaaoeiaafaaaaadaaaaahia
aaaaffjablaaoekaaeaaaaaeaaaaahiabkaaoekaaaaaaajaaaaaoeiaaeaaaaae
aaaaahiabmaaoekaaaaakkjaaaaaoeiaaeaaaaaeaaaaahiabnaaoekaaaaappja
aaaaoeiaacaaaaadabaaapiaaaaakkibagaaoekaacaaaaadacaaapiaaaaaaaib
aeaaoekaacaaaaadaaaaapiaaaaaffibafaaoekaafaaaaadadaaahiaacaaoeja
ccaappkaafaaaaadaeaaahiaadaaffiablaaoekaaeaaaaaeadaaaliabkaakeka
adaaaaiaaeaakeiaaeaaaaaeadaaahiabmaaoekaadaakkiaadaapeiaafaaaaad
aeaaapiaaaaaoeiaadaaffiaafaaaaadaaaaapiaaaaaoeiaaaaaoeiaaeaaaaae
aaaaapiaacaaoeiaacaaoeiaaaaaoeiaaeaaaaaeacaaapiaacaaoeiaadaaaaia
aeaaoeiaaeaaaaaeacaaapiaabaaoeiaadaakkiaacaaoeiaaeaaaaaeaaaaapia
abaaoeiaabaaoeiaaaaaoeiaahaaaaacabaaabiaaaaaaaiaahaaaaacabaaacia
aaaaffiaahaaaaacabaaaeiaaaaakkiaahaaaaacabaaaiiaaaaappiaabaaaaac
aeaaabiacdaaaakaaeaaaaaeaaaaapiaaaaaoeiaahaaoekaaeaaaaiaafaaaaad
abaaapiaabaaoeiaacaaoeiaalaaaaadabaaapiaabaaoeiacdaaffkaagaaaaac
acaaabiaaaaaaaiaagaaaaacacaaaciaaaaaffiaagaaaaacacaaaeiaaaaakkia
agaaaaacacaaaiiaaaaappiaafaaaaadaaaaapiaabaaoeiaacaaoeiaafaaaaad
abaaahiaaaaaffiaajaaoekaaeaaaaaeabaaahiaaiaaoekaaaaaaaiaabaaoeia
aeaaaaaeaaaaahiaakaaoekaaaaakkiaabaaoeiaaeaaaaaeaaaaahiaalaaoeka
aaaappiaaaaaoeiaabaaaaacadaaaiiacdaaaakaajaaaaadabaaabiaamaaoeka
adaaoeiaajaaaaadabaaaciaanaaoekaadaaoeiaajaaaaadabaaaeiaaoaaoeka
adaaoeiaafaaaaadacaaapiaadaacjiaadaakeiaajaaaaadaeaaabiaapaaoeka
acaaoeiaajaaaaadaeaaaciabaaaoekaacaaoeiaajaaaaadaeaaaeiabbaaoeka
acaaoeiaacaaaaadabaaahiaabaaoeiaaeaaoeiaafaaaaadaaaaaiiaadaaffia
adaaffiaaeaaaaaeaaaaaiiaadaaaaiaadaaaaiaaaaappibaeaaaaaeabaaahia
bcaaoekaaaaappiaabaaoeiaacaaaaadaeaaahoaaaaaoeiaabaaoeiaafaaaaad
aaaaapiaaaaaffjabeaaoekaaeaaaaaeaaaaapiabdaaoekaaaaaaajaaaaaoeia
aeaaaaaeaaaaapiabfaaoekaaaaakkjaaaaaoeiaaeaaaaaeaaaaapiabgaaoeka
aaaappjaaaaaoeiaaeaaaaaeaaaaadmaaaaappiaaaaaoekaaaaaoeiaabaaaaac
aaaaammaaaaaoeiappppaaaafdeieefcjmajaaaaeaaaabaaghacaaaafjaaaaae
egiocaaaaaaaaaaaagaaaaaafjaaaaaeegiocaaaabaaaaaabjaaaaaafjaaaaae
egiocaaaacaaaaaabfaaaaaafpaaaaadpcbabaaaaaaaaaaafpaaaaadpcbabaaa
abaaaaaafpaaaaadhcbabaaaacaaaaaafpaaaaaddcbabaaaadaaaaaaghaaaaae
pccabaaaaaaaaaaaabaaaaaagfaaaaadpccabaaaabaaaaaagfaaaaadhccabaaa
acaaaaaagfaaaaadhccabaaaadaaaaaagfaaaaadhccabaaaaeaaaaaagfaaaaad
hccabaaaafaaaaaagiaaaaacagaaaaaadiaaaaaipcaabaaaaaaaaaaafgbfbaaa
aaaaaaaaegiocaaaacaaaaaaabaaaaaadcaaaaakpcaabaaaaaaaaaaaegiocaaa
acaaaaaaaaaaaaaaagbabaaaaaaaaaaaegaobaaaaaaaaaaadcaaaaakpcaabaaa
aaaaaaaaegiocaaaacaaaaaaacaaaaaakgbkbaaaaaaaaaaaegaobaaaaaaaaaaa
dcaaaaakpccabaaaaaaaaaaaegiocaaaacaaaaaaadaaaaaapgbpbaaaaaaaaaaa
egaobaaaaaaaaaaadcaaaaaldccabaaaabaaaaaaegbabaaaadaaaaaaegiacaaa
aaaaaaaaaeaaaaaaogikcaaaaaaaaaaaaeaaaaaadcaaaaalmccabaaaabaaaaaa
agbebaaaadaaaaaaagiecaaaaaaaaaaaafaaaaaakgiocaaaaaaaaaaaafaaaaaa
diaaaaahhcaabaaaaaaaaaaajgbebaaaabaaaaaacgbjbaaaacaaaaaadcaaaaak
hcaabaaaaaaaaaaajgbebaaaacaaaaaacgbjbaaaabaaaaaaegacbaiaebaaaaaa
aaaaaaaadiaaaaahhcaabaaaaaaaaaaaegacbaaaaaaaaaaapgbpbaaaabaaaaaa
dgaaaaagbcaabaaaabaaaaaaakiacaaaacaaaaaaaiaaaaaadgaaaaagccaabaaa
abaaaaaaakiacaaaacaaaaaaajaaaaaadgaaaaagecaabaaaabaaaaaaakiacaaa
acaaaaaaakaaaaaabaaaaaahcccabaaaacaaaaaaegacbaaaaaaaaaaaegacbaaa
abaaaaaabaaaaaahbccabaaaacaaaaaaegbcbaaaabaaaaaaegacbaaaabaaaaaa
baaaaaaheccabaaaacaaaaaaegbcbaaaacaaaaaaegacbaaaabaaaaaadgaaaaag
bcaabaaaabaaaaaabkiacaaaacaaaaaaaiaaaaaadgaaaaagccaabaaaabaaaaaa
bkiacaaaacaaaaaaajaaaaaadgaaaaagecaabaaaabaaaaaabkiacaaaacaaaaaa
akaaaaaabaaaaaahcccabaaaadaaaaaaegacbaaaaaaaaaaaegacbaaaabaaaaaa
baaaaaahbccabaaaadaaaaaaegbcbaaaabaaaaaaegacbaaaabaaaaaabaaaaaah
eccabaaaadaaaaaaegbcbaaaacaaaaaaegacbaaaabaaaaaadiaaaaajhcaabaaa
abaaaaaafgifcaaaabaaaaaaaaaaaaaaegiccaaaacaaaaaabbaaaaaadcaaaaal
hcaabaaaabaaaaaaegiccaaaacaaaaaabaaaaaaaagiacaaaabaaaaaaaaaaaaaa
egacbaaaabaaaaaadcaaaaalhcaabaaaabaaaaaaegiccaaaacaaaaaabcaaaaaa
kgikcaaaabaaaaaaaaaaaaaaegacbaaaabaaaaaadcaaaaalhcaabaaaabaaaaaa
egiccaaaacaaaaaabdaaaaaapgipcaaaabaaaaaaaaaaaaaaegacbaaaabaaaaaa
baaaaaahcccabaaaaeaaaaaaegacbaaaaaaaaaaaegacbaaaabaaaaaabaaaaaah
bccabaaaaeaaaaaaegbcbaaaabaaaaaaegacbaaaabaaaaaabaaaaaaheccabaaa
aeaaaaaaegbcbaaaacaaaaaaegacbaaaabaaaaaadgaaaaaficaabaaaaaaaaaaa
abeaaaaaaaaaiadpdiaaaaaihcaabaaaabaaaaaaegbcbaaaacaaaaaapgipcaaa
acaaaaaabeaaaaaadiaaaaaihcaabaaaacaaaaaafgafbaaaabaaaaaaegiccaaa
acaaaaaaanaaaaaadcaaaaaklcaabaaaabaaaaaaegiicaaaacaaaaaaamaaaaaa
agaabaaaabaaaaaaegaibaaaacaaaaaadcaaaaakhcaabaaaaaaaaaaaegiccaaa
acaaaaaaaoaaaaaakgakbaaaabaaaaaaegadbaaaabaaaaaabbaaaaaibcaabaaa
abaaaaaaegiocaaaabaaaaaabcaaaaaaegaobaaaaaaaaaaabbaaaaaiccaabaaa
abaaaaaaegiocaaaabaaaaaabdaaaaaaegaobaaaaaaaaaaabbaaaaaiecaabaaa
abaaaaaaegiocaaaabaaaaaabeaaaaaaegaobaaaaaaaaaaadiaaaaahpcaabaaa
acaaaaaajgacbaaaaaaaaaaaegakbaaaaaaaaaaabbaaaaaibcaabaaaadaaaaaa
egiocaaaabaaaaaabfaaaaaaegaobaaaacaaaaaabbaaaaaiccaabaaaadaaaaaa
egiocaaaabaaaaaabgaaaaaaegaobaaaacaaaaaabbaaaaaiecaabaaaadaaaaaa
egiocaaaabaaaaaabhaaaaaaegaobaaaacaaaaaaaaaaaaahhcaabaaaabaaaaaa
egacbaaaabaaaaaaegacbaaaadaaaaaadiaaaaahicaabaaaaaaaaaaabkaabaaa
aaaaaaaabkaabaaaaaaaaaaadcaaaaakicaabaaaaaaaaaaaakaabaaaaaaaaaaa
akaabaaaaaaaaaaadkaabaiaebaaaaaaaaaaaaaadcaaaaakhcaabaaaabaaaaaa
egiccaaaabaaaaaabiaaaaaapgapbaaaaaaaaaaaegacbaaaabaaaaaadiaaaaai
hcaabaaaacaaaaaafgbfbaaaaaaaaaaaegiccaaaacaaaaaaanaaaaaadcaaaaak
hcaabaaaacaaaaaaegiccaaaacaaaaaaamaaaaaaagbabaaaaaaaaaaaegacbaaa
acaaaaaadcaaaaakhcaabaaaacaaaaaaegiccaaaacaaaaaaaoaaaaaakgbkbaaa
aaaaaaaaegacbaaaacaaaaaadcaaaaakhcaabaaaacaaaaaaegiccaaaacaaaaaa
apaaaaaapgbpbaaaaaaaaaaaegacbaaaacaaaaaaaaaaaaajpcaabaaaadaaaaaa
fgafbaiaebaaaaaaacaaaaaaegiocaaaabaaaaaaadaaaaaadiaaaaahpcaabaaa
aeaaaaaafgafbaaaaaaaaaaaegaobaaaadaaaaaadiaaaaahpcaabaaaadaaaaaa
egaobaaaadaaaaaaegaobaaaadaaaaaaaaaaaaajpcaabaaaafaaaaaaagaabaia
ebaaaaaaacaaaaaaegiocaaaabaaaaaaacaaaaaaaaaaaaajpcaabaaaacaaaaaa
kgakbaiaebaaaaaaacaaaaaaegiocaaaabaaaaaaaeaaaaaadcaaaaajpcaabaaa
aeaaaaaaegaobaaaafaaaaaaagaabaaaaaaaaaaaegaobaaaaeaaaaaadcaaaaaj
pcaabaaaaaaaaaaaegaobaaaacaaaaaakgakbaaaaaaaaaaaegaobaaaaeaaaaaa
dcaaaaajpcaabaaaadaaaaaaegaobaaaafaaaaaaegaobaaaafaaaaaaegaobaaa
adaaaaaadcaaaaajpcaabaaaacaaaaaaegaobaaaacaaaaaaegaobaaaacaaaaaa
egaobaaaadaaaaaaeeaaaaafpcaabaaaadaaaaaaegaobaaaacaaaaaadcaaaaan
pcaabaaaacaaaaaaegaobaaaacaaaaaaegiocaaaabaaaaaaafaaaaaaaceaaaaa
aaaaiadpaaaaiadpaaaaiadpaaaaiadpaoaaaaakpcaabaaaacaaaaaaaceaaaaa
aaaaiadpaaaaiadpaaaaiadpaaaaiadpegaobaaaacaaaaaadiaaaaahpcaabaaa
aaaaaaaaegaobaaaaaaaaaaaegaobaaaadaaaaaadeaaaaakpcaabaaaaaaaaaaa
egaobaaaaaaaaaaaaceaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaadiaaaaah
pcaabaaaaaaaaaaaegaobaaaacaaaaaaegaobaaaaaaaaaaadiaaaaaihcaabaaa
acaaaaaafgafbaaaaaaaaaaaegiccaaaabaaaaaaahaaaaaadcaaaaakhcaabaaa
acaaaaaaegiccaaaabaaaaaaagaaaaaaagaabaaaaaaaaaaaegacbaaaacaaaaaa
dcaaaaakhcaabaaaaaaaaaaaegiccaaaabaaaaaaaiaaaaaakgakbaaaaaaaaaaa
egacbaaaacaaaaaadcaaaaakhcaabaaaaaaaaaaaegiccaaaabaaaaaaajaaaaaa
pgapbaaaaaaaaaaaegacbaaaaaaaaaaaaaaaaaahhccabaaaafaaaaaaegacbaaa
aaaaaaaaegacbaaaabaaaaaadoaaaaabejfdeheomaaaaaaaagaaaaaaaiaaaaaa
jiaaaaaaaaaaaaaaaaaaaaaaadaaaaaaaaaaaaaaapapaaaakbaaaaaaaaaaaaaa
aaaaaaaaadaaaaaaabaaaaaaapapaaaakjaaaaaaaaaaaaaaaaaaaaaaadaaaaaa
acaaaaaaahahaaaalaaaaaaaaaaaaaaaaaaaaaaaadaaaaaaadaaaaaaapadaaaa
laaaaaaaabaaaaaaaaaaaaaaadaaaaaaaeaaaaaaapaaaaaaljaaaaaaaaaaaaaa
aaaaaaaaadaaaaaaafaaaaaaapaaaaaafaepfdejfeejepeoaafeebeoehefeofe
aaeoepfcenebemaafeeffiedepepfceeaaedepemepfcaaklepfdeheolaaaaaaa
agaaaaaaaiaaaaaajiaaaaaaaaaaaaaaabaaaaaaadaaaaaaaaaaaaaaapaaaaaa
keaaaaaaaaaaaaaaaaaaaaaaadaaaaaaabaaaaaaapaaaaaakeaaaaaaabaaaaaa
aaaaaaaaadaaaaaaacaaaaaaahaiaaaakeaaaaaaacaaaaaaaaaaaaaaadaaaaaa
adaaaaaaahaiaaaakeaaaaaaadaaaaaaaaaaaaaaadaaaaaaaeaaaaaaahaiaaaa
keaaaaaaaeaaaaaaaaaaaaaaadaaaaaaafaaaaaaahaiaaaafdfgfpfaepfdejfe
ejepeoaafeeffiedepepfceeaaklklkl"
}

SubProgram "opengl " {
Keywords { "DIRECTIONAL" "LIGHTMAP_OFF" "DIRLIGHTMAP_OFF" "SHADOWS_SCREEN" "VERTEXLIGHT_ON" }
Bind "vertex" Vertex
Bind "tangent" ATTR14
Bind "normal" Normal
Bind "texcoord" TexCoord0
Vector 17 [_ProjectionParams]
Vector 18 [_WorldSpaceLightPos0]
Vector 19 [unity_4LightPosX0]
Vector 20 [unity_4LightPosY0]
Vector 21 [unity_4LightPosZ0]
Vector 22 [unity_4LightAtten0]
Vector 23 [unity_LightColor0]
Vector 24 [unity_LightColor1]
Vector 25 [unity_LightColor2]
Vector 26 [unity_LightColor3]
Vector 27 [unity_SHAr]
Vector 28 [unity_SHAg]
Vector 29 [unity_SHAb]
Vector 30 [unity_SHBr]
Vector 31 [unity_SHBg]
Vector 32 [unity_SHBb]
Vector 33 [unity_SHC]
Matrix 9 [_Object2World]
Matrix 13 [_World2Object]
Vector 34 [unity_Scale]
Vector 35 [_MainTex_ST]
Vector 36 [_BumpMap_ST]
"!!ARBvp1.0
# 77 ALU
PARAM c[37] = { { 1, 0, 0.5 },
		state.matrix.mvp,
		state.matrix.modelview[0].invtrans,
		program.local[9..36] };
TEMP R0;
TEMP R1;
TEMP R2;
TEMP R3;
TEMP R4;
MUL R3.xyz, vertex.normal, c[34].w;
DP4 R0.x, vertex.position, c[10];
ADD R1, -R0.x, c[20];
DP3 R3.w, R3, c[10];
DP3 R4.x, R3, c[9];
DP3 R3.x, R3, c[11];
MUL R2, R3.w, R1;
DP4 R0.x, vertex.position, c[9];
ADD R0, -R0.x, c[19];
MUL R1, R1, R1;
MOV R4.z, R3.x;
MAD R2, R4.x, R0, R2;
MOV R4.w, c[0].x;
DP4 R4.y, vertex.position, c[11];
MAD R1, R0, R0, R1;
ADD R0, -R4.y, c[21];
MAD R1, R0, R0, R1;
MAD R0, R3.x, R0, R2;
MUL R2, R1, c[22];
MOV R4.y, R3.w;
RSQ R1.x, R1.x;
RSQ R1.y, R1.y;
RSQ R1.w, R1.w;
RSQ R1.z, R1.z;
MUL R0, R0, R1;
ADD R1, R2, c[0].x;
RCP R1.x, R1.x;
RCP R1.y, R1.y;
RCP R1.w, R1.w;
RCP R1.z, R1.z;
MAX R0, R0, c[0].y;
MUL R0, R0, R1;
MUL R1.xyz, R0.y, c[24];
MAD R1.xyz, R0.x, c[23], R1;
MAD R0.xyz, R0.z, c[25], R1;
MAD R1.xyz, R0.w, c[26], R0;
MUL R0, R4.xyzz, R4.yzzx;
DP4 R3.z, R0, c[32];
DP4 R3.y, R0, c[31];
DP4 R3.x, R0, c[30];
MUL R1.w, R3, R3;
MAD R0.x, R4, R4, -R1.w;
DP4 R0.w, vertex.position, c[4];
DP4 R2.z, R4, c[29];
DP4 R2.y, R4, c[28];
DP4 R2.x, R4, c[27];
ADD R2.xyz, R2, R3;
MUL R3.xyz, R0.x, c[33];
ADD R3.xyz, R2, R3;
MOV R0.xyz, vertex.attrib[14];
MUL R2.xyz, vertex.normal.zxyw, R0.yzxw;
MAD R0.xyz, vertex.normal.yzxw, R0.zxyw, -R2;
MUL R0.xyz, R0, vertex.attrib[14].w;
ADD result.texcoord[4].xyz, R3, R1;
MOV R1, c[18];
DP4 R2.z, R1, c[15];
DP4 R2.x, R1, c[13];
DP4 R2.y, R1, c[14];
DP3 result.texcoord[3].y, R0, R2;
DP3 result.texcoord[1].y, R0, c[5];
DP3 result.texcoord[2].y, R0, c[6];
DP4 R0.z, vertex.position, c[3];
DP4 R0.x, vertex.position, c[1];
DP4 R0.y, vertex.position, c[2];
MUL R1.xyz, R0.xyww, c[0].z;
MUL R1.y, R1, c[17].x;
DP3 result.texcoord[3].z, vertex.normal, R2;
DP3 result.texcoord[3].x, vertex.attrib[14], R2;
ADD result.texcoord[5].xy, R1, R1.z;
MOV result.position, R0;
MOV result.texcoord[5].zw, R0;
MAD result.texcoord[0].zw, vertex.texcoord[0].xyxy, c[36].xyxy, c[36];
MAD result.texcoord[0].xy, vertex.texcoord[0], c[35], c[35].zwzw;
DP3 result.texcoord[1].z, vertex.normal, c[5];
DP3 result.texcoord[1].x, vertex.attrib[14], c[5];
DP3 result.texcoord[2].z, vertex.normal, c[6];
DP3 result.texcoord[2].x, vertex.attrib[14], c[6];
END
# 77 instructions, 5 R-regs
"
}

SubProgram "d3d9 " {
Keywords { "DIRECTIONAL" "LIGHTMAP_OFF" "DIRLIGHTMAP_OFF" "SHADOWS_SCREEN" "VERTEXLIGHT_ON" }
Bind "vertex" Vertex
Bind "tangent" TexCoord2
Bind "normal" Normal
Bind "texcoord" TexCoord0
Matrix 0 [glstate_matrix_mvp]
Matrix 4 [glstate_matrix_invtrans_modelview0]
Vector 16 [_ProjectionParams]
Vector 17 [_ScreenParams]
Vector 18 [_WorldSpaceLightPos0]
Vector 19 [unity_4LightPosX0]
Vector 20 [unity_4LightPosY0]
Vector 21 [unity_4LightPosZ0]
Vector 22 [unity_4LightAtten0]
Vector 23 [unity_LightColor0]
Vector 24 [unity_LightColor1]
Vector 25 [unity_LightColor2]
Vector 26 [unity_LightColor3]
Vector 27 [unity_SHAr]
Vector 28 [unity_SHAg]
Vector 29 [unity_SHAb]
Vector 30 [unity_SHBr]
Vector 31 [unity_SHBg]
Vector 32 [unity_SHBb]
Vector 33 [unity_SHC]
Matrix 8 [_Object2World]
Matrix 12 [_World2Object]
Vector 34 [unity_Scale]
Vector 35 [_MainTex_ST]
Vector 36 [_BumpMap_ST]
"vs_2_0
; 80 ALU
def c37, 1.00000000, 0.00000000, 0.50000000, 0
dcl_position0 v0
dcl_tangent0 v1
dcl_normal0 v2
dcl_texcoord0 v3
mul r3.xyz, v2, c34.w
dp4 r0.x, v0, c9
add r1, -r0.x, c20
dp3 r3.w, r3, c9
dp3 r4.x, r3, c8
dp3 r3.x, r3, c10
mul r2, r3.w, r1
dp4 r0.x, v0, c8
add r0, -r0.x, c19
mul r1, r1, r1
mov r4.z, r3.x
mad r2, r4.x, r0, r2
mov r4.w, c37.x
dp4 r4.y, v0, c10
mad r1, r0, r0, r1
add r0, -r4.y, c21
mad r1, r0, r0, r1
mad r0, r3.x, r0, r2
mul r2, r1, c22
mov r4.y, r3.w
rsq r1.x, r1.x
rsq r1.y, r1.y
rsq r1.w, r1.w
rsq r1.z, r1.z
mul r0, r0, r1
add r1, r2, c37.x
rcp r1.x, r1.x
rcp r1.y, r1.y
rcp r1.w, r1.w
rcp r1.z, r1.z
max r0, r0, c37.y
mul r0, r0, r1
mul r1.xyz, r0.y, c24
mad r1.xyz, r0.x, c23, r1
mad r0.xyz, r0.z, c25, r1
mad r1.xyz, r0.w, c26, r0
mul r0, r4.xyzz, r4.yzzx
mul r1.w, r3, r3
dp4 r3.z, r0, c32
dp4 r3.y, r0, c31
dp4 r3.x, r0, c30
mad r1.w, r4.x, r4.x, -r1
mul r0.xyz, r1.w, c33
dp4 r2.z, r4, c29
dp4 r2.y, r4, c28
dp4 r2.x, r4, c27
add r2.xyz, r2, r3
add r2.xyz, r2, r0
mov r0.xyz, v1
add oT4.xyz, r2, r1
mul r1.xyz, v2.zxyw, r0.yzxw
mov r0.xyz, v1
mad r1.xyz, v2.yzxw, r0.zxyw, -r1
mul r2.xyz, r1, v1.w
mov r0, c14
dp4 r3.z, c18, r0
mov r0, c13
dp4 r3.y, c18, r0
mov r1, c12
dp4 r3.x, c18, r1
dp4 r0.w, v0, c3
dp4 r0.z, v0, c2
dp4 r0.x, v0, c0
dp4 r0.y, v0, c1
mul r1.xyz, r0.xyww, c37.z
mul r1.y, r1, c16.x
dp3 oT3.y, r2, r3
dp3 oT1.y, r2, c4
dp3 oT2.y, r2, c5
dp3 oT3.z, v2, r3
dp3 oT3.x, v1, r3
mad oT5.xy, r1.z, c17.zwzw, r1
mov oPos, r0
mov oT5.zw, r0
mad oT0.zw, v3.xyxy, c36.xyxy, c36
mad oT0.xy, v3, c35, c35.zwzw
dp3 oT1.z, v2, c4
dp3 oT1.x, v1, c4
dp3 oT2.z, v2, c5
dp3 oT2.x, v1, c5
"
}

SubProgram "d3d11 " {
Keywords { "DIRECTIONAL" "LIGHTMAP_OFF" "DIRLIGHTMAP_OFF" "SHADOWS_SCREEN" "VERTEXLIGHT_ON" }
Bind "vertex" Vertex
Bind "tangent" TexCoord2
Bind "normal" Normal
Bind "texcoord" TexCoord0
Bind "color" Color
ConstBuffer "$Globals" 176 // 160 used size, 8 vars
Vector 128 [_MainTex_ST] 4
Vector 144 [_BumpMap_ST] 4
ConstBuffer "UnityPerCamera" 128 // 96 used size, 8 vars
Vector 80 [_ProjectionParams] 4
ConstBuffer "UnityLighting" 400 // 400 used size, 16 vars
Vector 0 [_WorldSpaceLightPos0] 4
Vector 32 [unity_4LightPosX0] 4
Vector 48 [unity_4LightPosY0] 4
Vector 64 [unity_4LightPosZ0] 4
Vector 80 [unity_4LightAtten0] 4
Vector 96 [unity_LightColor0] 4
Vector 112 [unity_LightColor1] 4
Vector 128 [unity_LightColor2] 4
Vector 144 [unity_LightColor3] 4
Vector 288 [unity_SHAr] 4
Vector 304 [unity_SHAg] 4
Vector 320 [unity_SHAb] 4
Vector 336 [unity_SHBr] 4
Vector 352 [unity_SHBg] 4
Vector 368 [unity_SHBb] 4
Vector 384 [unity_SHC] 4
ConstBuffer "UnityPerDraw" 336 // 336 used size, 6 vars
Matrix 0 [glstate_matrix_mvp] 4
Matrix 128 [glstate_matrix_invtrans_modelview0] 4
Matrix 192 [_Object2World] 4
Matrix 256 [_World2Object] 4
Vector 320 [unity_Scale] 4
BindCB "$Globals" 0
BindCB "UnityPerCamera" 1
BindCB "UnityLighting" 2
BindCB "UnityPerDraw" 3
// 74 instructions, 7 temp regs, 0 temp arrays:
// ALU 40 float, 0 int, 0 uint
// TEX 0 (0 load, 0 comp, 0 bias, 0 grad)
// FLOW 1 static, 0 dynamic
"vs_4_0
eefiecedopbaommeglompjlijbkmahdaaodeaefdabaaaaaabaamaaaaadaaaaaa
cmaaaaaapeaaaaaameabaaaaejfdeheomaaaaaaaagaaaaaaaiaaaaaajiaaaaaa
aaaaaaaaaaaaaaaaadaaaaaaaaaaaaaaapapaaaakbaaaaaaaaaaaaaaaaaaaaaa
adaaaaaaabaaaaaaapapaaaakjaaaaaaaaaaaaaaaaaaaaaaadaaaaaaacaaaaaa
ahahaaaalaaaaaaaaaaaaaaaaaaaaaaaadaaaaaaadaaaaaaapadaaaalaaaaaaa
abaaaaaaaaaaaaaaadaaaaaaaeaaaaaaapaaaaaaljaaaaaaaaaaaaaaaaaaaaaa
adaaaaaaafaaaaaaapaaaaaafaepfdejfeejepeoaafeebeoehefeofeaaeoepfc
enebemaafeeffiedepepfceeaaedepemepfcaaklepfdeheomiaaaaaaahaaaaaa
aiaaaaaalaaaaaaaaaaaaaaaabaaaaaaadaaaaaaaaaaaaaaapaaaaaalmaaaaaa
aaaaaaaaaaaaaaaaadaaaaaaabaaaaaaapaaaaaalmaaaaaaabaaaaaaaaaaaaaa
adaaaaaaacaaaaaaahaiaaaalmaaaaaaacaaaaaaaaaaaaaaadaaaaaaadaaaaaa
ahaiaaaalmaaaaaaadaaaaaaaaaaaaaaadaaaaaaaeaaaaaaahaiaaaalmaaaaaa
aeaaaaaaaaaaaaaaadaaaaaaafaaaaaaahaiaaaalmaaaaaaafaaaaaaaaaaaaaa
adaaaaaaagaaaaaaapaaaaaafdfgfpfaepfdejfeejepeoaafeeffiedepepfcee
aaklklklfdeieefceeakaaaaeaaaabaajbacaaaafjaaaaaeegiocaaaaaaaaaaa
akaaaaaafjaaaaaeegiocaaaabaaaaaaagaaaaaafjaaaaaeegiocaaaacaaaaaa
bjaaaaaafjaaaaaeegiocaaaadaaaaaabfaaaaaafpaaaaadpcbabaaaaaaaaaaa
fpaaaaadpcbabaaaabaaaaaafpaaaaadhcbabaaaacaaaaaafpaaaaaddcbabaaa
adaaaaaaghaaaaaepccabaaaaaaaaaaaabaaaaaagfaaaaadpccabaaaabaaaaaa
gfaaaaadhccabaaaacaaaaaagfaaaaadhccabaaaadaaaaaagfaaaaadhccabaaa
aeaaaaaagfaaaaadhccabaaaafaaaaaagfaaaaadpccabaaaagaaaaaagiaaaaac
ahaaaaaadiaaaaaipcaabaaaaaaaaaaafgbfbaaaaaaaaaaaegiocaaaadaaaaaa
abaaaaaadcaaaaakpcaabaaaaaaaaaaaegiocaaaadaaaaaaaaaaaaaaagbabaaa
aaaaaaaaegaobaaaaaaaaaaadcaaaaakpcaabaaaaaaaaaaaegiocaaaadaaaaaa
acaaaaaakgbkbaaaaaaaaaaaegaobaaaaaaaaaaadcaaaaakpcaabaaaaaaaaaaa
egiocaaaadaaaaaaadaaaaaapgbpbaaaaaaaaaaaegaobaaaaaaaaaaadgaaaaaf
pccabaaaaaaaaaaaegaobaaaaaaaaaaadcaaaaaldccabaaaabaaaaaaegbabaaa
adaaaaaaegiacaaaaaaaaaaaaiaaaaaaogikcaaaaaaaaaaaaiaaaaaadcaaaaal
mccabaaaabaaaaaaagbebaaaadaaaaaaagiecaaaaaaaaaaaajaaaaaakgiocaaa
aaaaaaaaajaaaaaadiaaaaahhcaabaaaabaaaaaajgbebaaaabaaaaaacgbjbaaa
acaaaaaadcaaaaakhcaabaaaabaaaaaajgbebaaaacaaaaaacgbjbaaaabaaaaaa
egacbaiaebaaaaaaabaaaaaadiaaaaahhcaabaaaabaaaaaaegacbaaaabaaaaaa
pgbpbaaaabaaaaaadgaaaaagbcaabaaaacaaaaaaakiacaaaadaaaaaaaiaaaaaa
dgaaaaagccaabaaaacaaaaaaakiacaaaadaaaaaaajaaaaaadgaaaaagecaabaaa
acaaaaaaakiacaaaadaaaaaaakaaaaaabaaaaaahcccabaaaacaaaaaaegacbaaa
abaaaaaaegacbaaaacaaaaaabaaaaaahbccabaaaacaaaaaaegbcbaaaabaaaaaa
egacbaaaacaaaaaabaaaaaaheccabaaaacaaaaaaegbcbaaaacaaaaaaegacbaaa
acaaaaaadgaaaaagbcaabaaaacaaaaaabkiacaaaadaaaaaaaiaaaaaadgaaaaag
ccaabaaaacaaaaaabkiacaaaadaaaaaaajaaaaaadgaaaaagecaabaaaacaaaaaa
bkiacaaaadaaaaaaakaaaaaabaaaaaahcccabaaaadaaaaaaegacbaaaabaaaaaa
egacbaaaacaaaaaabaaaaaahbccabaaaadaaaaaaegbcbaaaabaaaaaaegacbaaa
acaaaaaabaaaaaaheccabaaaadaaaaaaegbcbaaaacaaaaaaegacbaaaacaaaaaa
diaaaaajhcaabaaaacaaaaaafgifcaaaacaaaaaaaaaaaaaaegiccaaaadaaaaaa
bbaaaaaadcaaaaalhcaabaaaacaaaaaaegiccaaaadaaaaaabaaaaaaaagiacaaa
acaaaaaaaaaaaaaaegacbaaaacaaaaaadcaaaaalhcaabaaaacaaaaaaegiccaaa
adaaaaaabcaaaaaakgikcaaaacaaaaaaaaaaaaaaegacbaaaacaaaaaadcaaaaal
hcaabaaaacaaaaaaegiccaaaadaaaaaabdaaaaaapgipcaaaacaaaaaaaaaaaaaa
egacbaaaacaaaaaabaaaaaahcccabaaaaeaaaaaaegacbaaaabaaaaaaegacbaaa
acaaaaaabaaaaaahbccabaaaaeaaaaaaegbcbaaaabaaaaaaegacbaaaacaaaaaa
baaaaaaheccabaaaaeaaaaaaegbcbaaaacaaaaaaegacbaaaacaaaaaadgaaaaaf
icaabaaaabaaaaaaabeaaaaaaaaaiadpdiaaaaaihcaabaaaacaaaaaaegbcbaaa
acaaaaaapgipcaaaadaaaaaabeaaaaaadiaaaaaihcaabaaaadaaaaaafgafbaaa
acaaaaaaegiccaaaadaaaaaaanaaaaaadcaaaaaklcaabaaaacaaaaaaegiicaaa
adaaaaaaamaaaaaaagaabaaaacaaaaaaegaibaaaadaaaaaadcaaaaakhcaabaaa
abaaaaaaegiccaaaadaaaaaaaoaaaaaakgakbaaaacaaaaaaegadbaaaacaaaaaa
bbaaaaaibcaabaaaacaaaaaaegiocaaaacaaaaaabcaaaaaaegaobaaaabaaaaaa
bbaaaaaiccaabaaaacaaaaaaegiocaaaacaaaaaabdaaaaaaegaobaaaabaaaaaa
bbaaaaaiecaabaaaacaaaaaaegiocaaaacaaaaaabeaaaaaaegaobaaaabaaaaaa
diaaaaahpcaabaaaadaaaaaajgacbaaaabaaaaaaegakbaaaabaaaaaabbaaaaai
bcaabaaaaeaaaaaaegiocaaaacaaaaaabfaaaaaaegaobaaaadaaaaaabbaaaaai
ccaabaaaaeaaaaaaegiocaaaacaaaaaabgaaaaaaegaobaaaadaaaaaabbaaaaai
ecaabaaaaeaaaaaaegiocaaaacaaaaaabhaaaaaaegaobaaaadaaaaaaaaaaaaah
hcaabaaaacaaaaaaegacbaaaacaaaaaaegacbaaaaeaaaaaadiaaaaahicaabaaa
abaaaaaabkaabaaaabaaaaaabkaabaaaabaaaaaadcaaaaakicaabaaaabaaaaaa
akaabaaaabaaaaaaakaabaaaabaaaaaadkaabaiaebaaaaaaabaaaaaadcaaaaak
hcaabaaaacaaaaaaegiccaaaacaaaaaabiaaaaaapgapbaaaabaaaaaaegacbaaa
acaaaaaadiaaaaaihcaabaaaadaaaaaafgbfbaaaaaaaaaaaegiccaaaadaaaaaa
anaaaaaadcaaaaakhcaabaaaadaaaaaaegiccaaaadaaaaaaamaaaaaaagbabaaa
aaaaaaaaegacbaaaadaaaaaadcaaaaakhcaabaaaadaaaaaaegiccaaaadaaaaaa
aoaaaaaakgbkbaaaaaaaaaaaegacbaaaadaaaaaadcaaaaakhcaabaaaadaaaaaa
egiccaaaadaaaaaaapaaaaaapgbpbaaaaaaaaaaaegacbaaaadaaaaaaaaaaaaaj
pcaabaaaaeaaaaaafgafbaiaebaaaaaaadaaaaaaegiocaaaacaaaaaaadaaaaaa
diaaaaahpcaabaaaafaaaaaafgafbaaaabaaaaaaegaobaaaaeaaaaaadiaaaaah
pcaabaaaaeaaaaaaegaobaaaaeaaaaaaegaobaaaaeaaaaaaaaaaaaajpcaabaaa
agaaaaaaagaabaiaebaaaaaaadaaaaaaegiocaaaacaaaaaaacaaaaaaaaaaaaaj
pcaabaaaadaaaaaakgakbaiaebaaaaaaadaaaaaaegiocaaaacaaaaaaaeaaaaaa
dcaaaaajpcaabaaaafaaaaaaegaobaaaagaaaaaaagaabaaaabaaaaaaegaobaaa
afaaaaaadcaaaaajpcaabaaaabaaaaaaegaobaaaadaaaaaakgakbaaaabaaaaaa
egaobaaaafaaaaaadcaaaaajpcaabaaaaeaaaaaaegaobaaaagaaaaaaegaobaaa
agaaaaaaegaobaaaaeaaaaaadcaaaaajpcaabaaaadaaaaaaegaobaaaadaaaaaa
egaobaaaadaaaaaaegaobaaaaeaaaaaaeeaaaaafpcaabaaaaeaaaaaaegaobaaa
adaaaaaadcaaaaanpcaabaaaadaaaaaaegaobaaaadaaaaaaegiocaaaacaaaaaa
afaaaaaaaceaaaaaaaaaiadpaaaaiadpaaaaiadpaaaaiadpaoaaaaakpcaabaaa
adaaaaaaaceaaaaaaaaaiadpaaaaiadpaaaaiadpaaaaiadpegaobaaaadaaaaaa
diaaaaahpcaabaaaabaaaaaaegaobaaaabaaaaaaegaobaaaaeaaaaaadeaaaaak
pcaabaaaabaaaaaaegaobaaaabaaaaaaaceaaaaaaaaaaaaaaaaaaaaaaaaaaaaa
aaaaaaaadiaaaaahpcaabaaaabaaaaaaegaobaaaadaaaaaaegaobaaaabaaaaaa
diaaaaaihcaabaaaadaaaaaafgafbaaaabaaaaaaegiccaaaacaaaaaaahaaaaaa
dcaaaaakhcaabaaaadaaaaaaegiccaaaacaaaaaaagaaaaaaagaabaaaabaaaaaa
egacbaaaadaaaaaadcaaaaakhcaabaaaabaaaaaaegiccaaaacaaaaaaaiaaaaaa
kgakbaaaabaaaaaaegacbaaaadaaaaaadcaaaaakhcaabaaaabaaaaaaegiccaaa
acaaaaaaajaaaaaapgapbaaaabaaaaaaegacbaaaabaaaaaaaaaaaaahhccabaaa
afaaaaaaegacbaaaabaaaaaaegacbaaaacaaaaaadiaaaaaiccaabaaaaaaaaaaa
bkaabaaaaaaaaaaaakiacaaaabaaaaaaafaaaaaadiaaaaakncaabaaaabaaaaaa
agahbaaaaaaaaaaaaceaaaaaaaaaaadpaaaaaaaaaaaaaadpaaaaaadpdgaaaaaf
mccabaaaagaaaaaakgaobaaaaaaaaaaaaaaaaaahdccabaaaagaaaaaakgakbaaa
abaaaaaamgaabaaaabaaaaaadoaaaaab"
}

SubProgram "gles " {
Keywords { "DIRECTIONAL" "LIGHTMAP_OFF" "DIRLIGHTMAP_OFF" "SHADOWS_SCREEN" "VERTEXLIGHT_ON" }
"!!GLES
#define SHADER_API_GLES 1
#define tex2D texture2D


#ifdef VERTEX
#define gl_ModelViewProjectionMatrix glstate_matrix_mvp
uniform mat4 glstate_matrix_mvp;
#define gl_ModelViewMatrixInverseTranspose glstate_matrix_invtrans_modelview0
uniform mat4 glstate_matrix_invtrans_modelview0;
#define gl_ModelViewMatrix glstate_matrix_modelview0
uniform mat4 glstate_matrix_modelview0;

varying highp vec4 xlv_TEXCOORD5;
varying lowp vec3 xlv_TEXCOORD4;
varying lowp vec3 xlv_TEXCOORD3;
varying highp vec3 xlv_TEXCOORD2;
varying highp vec3 xlv_TEXCOORD1;
varying highp vec4 xlv_TEXCOORD0;
uniform highp vec4 _BumpMap_ST;
uniform highp vec4 _MainTex_ST;
uniform highp vec4 unity_Scale;
uniform highp mat4 _World2Object;
uniform highp mat4 _Object2World;


uniform highp mat4 unity_World2Shadow[4];
uniform highp vec4 unity_SHC;
uniform highp vec4 unity_SHBb;
uniform highp vec4 unity_SHBg;
uniform highp vec4 unity_SHBr;
uniform highp vec4 unity_SHAb;
uniform highp vec4 unity_SHAg;
uniform highp vec4 unity_SHAr;
uniform highp vec4 unity_LightColor[4];
uniform highp vec4 unity_4LightAtten0;
uniform highp vec4 unity_4LightPosZ0;
uniform highp vec4 unity_4LightPosY0;
uniform highp vec4 unity_4LightPosX0;
uniform lowp vec4 _WorldSpaceLightPos0;
attribute vec4 _glesTANGENT;
attribute vec4 _glesMultiTexCoord0;
attribute vec3 _glesNormal;
attribute vec4 _glesVertex;
void main ()
{
  vec4 tmpvar_1;
  tmpvar_1.xyz = normalize(_glesTANGENT.xyz);
  tmpvar_1.w = _glesTANGENT.w;
  vec3 tmpvar_2;
  tmpvar_2 = normalize(_glesNormal);
  highp vec3 shlight_3;
  highp vec4 tmpvar_4;
  lowp vec3 tmpvar_5;
  lowp vec3 tmpvar_6;
  highp vec3 tmpvar_7;
  highp vec3 tmpvar_8;
  tmpvar_7 = tmpvar_1.xyz;
  tmpvar_8 = (((tmpvar_2.yzx * tmpvar_1.zxy) - (tmpvar_2.zxy * tmpvar_1.yzx)) * _glesTANGENT.w);
  highp mat3 tmpvar_9;
  tmpvar_9[0].x = tmpvar_7.x;
  tmpvar_9[0].y = tmpvar_8.x;
  tmpvar_9[0].z = tmpvar_2.x;
  tmpvar_9[1].x = tmpvar_7.y;
  tmpvar_9[1].y = tmpvar_8.y;
  tmpvar_9[1].z = tmpvar_2.y;
  tmpvar_9[2].x = tmpvar_7.z;
  tmpvar_9[2].y = tmpvar_8.z;
  tmpvar_9[2].z = tmpvar_2.z;
  vec4 v_10;
  v_10.x = gl_ModelViewMatrixInverseTranspose[0].x;
  v_10.y = gl_ModelViewMatrixInverseTranspose[1].x;
  v_10.z = gl_ModelViewMatrixInverseTranspose[2].x;
  v_10.w = gl_ModelViewMatrixInverseTranspose[3].x;
  vec4 v_11;
  v_11.x = gl_ModelViewMatrixInverseTranspose[0].y;
  v_11.y = gl_ModelViewMatrixInverseTranspose[1].y;
  v_11.z = gl_ModelViewMatrixInverseTranspose[2].y;
  v_11.w = gl_ModelViewMatrixInverseTranspose[3].y;
  tmpvar_4.xy = ((_glesMultiTexCoord0.xy * _MainTex_ST.xy) + _MainTex_ST.zw);
  tmpvar_4.zw = ((_glesMultiTexCoord0.xy * _BumpMap_ST.xy) + _BumpMap_ST.zw);
  mat3 tmpvar_12;
  tmpvar_12[0] = _Object2World[0].xyz;
  tmpvar_12[1] = _Object2World[1].xyz;
  tmpvar_12[2] = _Object2World[2].xyz;
  highp vec3 tmpvar_13;
  tmpvar_13 = (tmpvar_12 * (tmpvar_2 * unity_Scale.w));
  highp vec3 tmpvar_14;
  highp vec3 tmpvar_15;
  tmpvar_14 = tmpvar_1.xyz;
  tmpvar_15 = (((tmpvar_2.yzx * tmpvar_1.zxy) - (tmpvar_2.zxy * tmpvar_1.yzx)) * _glesTANGENT.w);
  highp mat3 tmpvar_16;
  tmpvar_16[0].x = tmpvar_14.x;
  tmpvar_16[0].y = tmpvar_15.x;
  tmpvar_16[0].z = tmpvar_2.x;
  tmpvar_16[1].x = tmpvar_14.y;
  tmpvar_16[1].y = tmpvar_15.y;
  tmpvar_16[1].z = tmpvar_2.y;
  tmpvar_16[2].x = tmpvar_14.z;
  tmpvar_16[2].y = tmpvar_15.z;
  tmpvar_16[2].z = tmpvar_2.z;
  highp vec3 tmpvar_17;
  tmpvar_17 = (tmpvar_16 * (_World2Object * _WorldSpaceLightPos0).xyz);
  tmpvar_5 = tmpvar_17;
  highp vec4 tmpvar_18;
  tmpvar_18.w = 1.0;
  tmpvar_18.xyz = tmpvar_13;
  mediump vec3 tmpvar_19;
  mediump vec4 normal_20;
  normal_20 = tmpvar_18;
  highp float vC_21;
  mediump vec3 x3_22;
  mediump vec3 x2_23;
  mediump vec3 x1_24;
  highp float tmpvar_25;
  tmpvar_25 = dot (unity_SHAr, normal_20);
  x1_24.x = tmpvar_25;
  highp float tmpvar_26;
  tmpvar_26 = dot (unity_SHAg, normal_20);
  x1_24.y = tmpvar_26;
  highp float tmpvar_27;
  tmpvar_27 = dot (unity_SHAb, normal_20);
  x1_24.z = tmpvar_27;
  mediump vec4 tmpvar_28;
  tmpvar_28 = (normal_20.xyzz * normal_20.yzzx);
  highp float tmpvar_29;
  tmpvar_29 = dot (unity_SHBr, tmpvar_28);
  x2_23.x = tmpvar_29;
  highp float tmpvar_30;
  tmpvar_30 = dot (unity_SHBg, tmpvar_28);
  x2_23.y = tmpvar_30;
  highp float tmpvar_31;
  tmpvar_31 = dot (unity_SHBb, tmpvar_28);
  x2_23.z = tmpvar_31;
  mediump float tmpvar_32;
  tmpvar_32 = ((normal_20.x * normal_20.x) - (normal_20.y * normal_20.y));
  vC_21 = tmpvar_32;
  highp vec3 tmpvar_33;
  tmpvar_33 = (unity_SHC.xyz * vC_21);
  x3_22 = tmpvar_33;
  tmpvar_19 = ((x1_24 + x2_23) + x3_22);
  shlight_3 = tmpvar_19;
  tmpvar_6 = shlight_3;
  highp vec3 tmpvar_34;
  tmpvar_34 = (_Object2World * _glesVertex).xyz;
  highp vec4 tmpvar_35;
  tmpvar_35 = (unity_4LightPosX0 - tmpvar_34.x);
  highp vec4 tmpvar_36;
  tmpvar_36 = (unity_4LightPosY0 - tmpvar_34.y);
  highp vec4 tmpvar_37;
  tmpvar_37 = (unity_4LightPosZ0 - tmpvar_34.z);
  highp vec4 tmpvar_38;
  tmpvar_38 = (((tmpvar_35 * tmpvar_35) + (tmpvar_36 * tmpvar_36)) + (tmpvar_37 * tmpvar_37));
  highp vec4 tmpvar_39;
  tmpvar_39 = (max (vec4(0.0, 0.0, 0.0, 0.0), ((((tmpvar_35 * tmpvar_13.x) + (tmpvar_36 * tmpvar_13.y)) + (tmpvar_37 * tmpvar_13.z)) * inversesqrt(tmpvar_38))) * (1.0/((1.0 + (tmpvar_38 * unity_4LightAtten0)))));
  highp vec3 tmpvar_40;
  tmpvar_40 = (tmpvar_6 + ((((unity_LightColor[0].xyz * tmpvar_39.x) + (unity_LightColor[1].xyz * tmpvar_39.y)) + (unity_LightColor[2].xyz * tmpvar_39.z)) + (unity_LightColor[3].xyz * tmpvar_39.w)));
  tmpvar_6 = tmpvar_40;
  gl_Position = (gl_ModelViewProjectionMatrix * _glesVertex);
  xlv_TEXCOORD0 = tmpvar_4;
  xlv_TEXCOORD1 = (tmpvar_9 * v_10.xyz);
  xlv_TEXCOORD2 = (tmpvar_9 * v_11.xyz);
  xlv_TEXCOORD3 = tmpvar_5;
  xlv_TEXCOORD4 = tmpvar_6;
  xlv_TEXCOORD5 = (unity_World2Shadow[0] * (_Object2World * _glesVertex));
}



#endif
#ifdef FRAGMENT

varying highp vec4 xlv_TEXCOORD5;
varying lowp vec3 xlv_TEXCOORD4;
varying lowp vec3 xlv_TEXCOORD3;
varying highp vec3 xlv_TEXCOORD2;
varying highp vec3 xlv_TEXCOORD1;
varying highp vec4 xlv_TEXCOORD0;
uniform lowp float _Cutoff;
uniform sampler2D _Shade;
uniform sampler2D _BumpMap;
uniform sampler2D _MainTex;
uniform lowp vec4 _Color;
uniform sampler2D _ShadowMapTexture;
uniform lowp vec4 _LightColor0;
uniform highp vec4 _LightShadowData;
void main ()
{
  lowp vec4 c_1;
  lowp vec3 tmpvar_2;
  highp vec3 matcap_3;
  lowp vec3 tmpvar_4;
  tmpvar_4 = ((texture2D (_BumpMap, xlv_TEXCOORD0.zw).xyz * 2.0) - 1.0);
  lowp vec3 tmpvar_5;
  tmpvar_5 = (texture2D (_MainTex, xlv_TEXCOORD0.xy).xyz * _Color.w);
  highp vec2 tmpvar_6;
  tmpvar_6.x = dot (xlv_TEXCOORD1, tmpvar_4);
  tmpvar_6.y = dot (xlv_TEXCOORD2, tmpvar_4);
  highp vec2 P_7;
  P_7 = ((tmpvar_6 * 0.5) + 0.5);
  lowp vec3 tmpvar_8;
  tmpvar_8 = texture2D (_Shade, P_7).xyz;
  matcap_3 = tmpvar_8;
  lowp vec4 tmpvar_9;
  tmpvar_9 = texture2D (_MainTex, xlv_TEXCOORD0.xy);
  highp vec3 tmpvar_10;
  tmpvar_10 = (((matcap_3 * tmpvar_9.xyz) * _Color.xyz) * 3.0);
  tmpvar_2 = tmpvar_10;
  lowp vec4 tmpvar_11;
  tmpvar_11 = texture2D (_MainTex, xlv_TEXCOORD0.xy);
  lowp float tmpvar_12;
  tmpvar_12 = tmpvar_11.w;
  lowp float x_13;
  x_13 = (tmpvar_11.w - _Cutoff);
  if ((x_13 < 0.0)) {
    discard;
  };
  lowp float tmpvar_14;
  mediump float lightShadowDataX_15;
  highp float dist_16;
  lowp float tmpvar_17;
  tmpvar_17 = texture2DProj (_ShadowMapTexture, xlv_TEXCOORD5).x;
  dist_16 = tmpvar_17;
  highp float tmpvar_18;
  tmpvar_18 = _LightShadowData.x;
  lightShadowDataX_15 = tmpvar_18;
  highp float tmpvar_19;
  tmpvar_19 = max (float((dist_16 > (xlv_TEXCOORD5.z / xlv_TEXCOORD5.w))), lightShadowDataX_15);
  tmpvar_14 = tmpvar_19;
  lowp vec4 c_20;
  c_20.xyz = ((tmpvar_5 * _LightColor0.xyz) * ((max (0.0, dot (tmpvar_4, xlv_TEXCOORD3)) * tmpvar_14) * 2.0));
  c_20.w = tmpvar_12;
  c_1.w = c_20.w;
  c_1.xyz = (c_20.xyz + (tmpvar_5 * xlv_TEXCOORD4));
  c_1.xyz = (c_1.xyz + tmpvar_2);
  c_1.w = tmpvar_12;
  gl_FragData[0] = c_1;
}



#endif"
}

SubProgram "glesdesktop " {
Keywords { "DIRECTIONAL" "LIGHTMAP_OFF" "DIRLIGHTMAP_OFF" "SHADOWS_SCREEN" "VERTEXLIGHT_ON" }
"!!GLES
#define SHADER_API_GLES 1
#define tex2D texture2D


#ifdef VERTEX
#define gl_ModelViewProjectionMatrix glstate_matrix_mvp
uniform mat4 glstate_matrix_mvp;
#define gl_ModelViewMatrixInverseTranspose glstate_matrix_invtrans_modelview0
uniform mat4 glstate_matrix_invtrans_modelview0;
#define gl_ModelViewMatrix glstate_matrix_modelview0
uniform mat4 glstate_matrix_modelview0;

varying highp vec4 xlv_TEXCOORD5;
varying lowp vec3 xlv_TEXCOORD4;
varying lowp vec3 xlv_TEXCOORD3;
varying highp vec3 xlv_TEXCOORD2;
varying highp vec3 xlv_TEXCOORD1;
varying highp vec4 xlv_TEXCOORD0;
uniform highp vec4 _BumpMap_ST;
uniform highp vec4 _MainTex_ST;
uniform highp vec4 unity_Scale;
uniform highp mat4 _World2Object;
uniform highp mat4 _Object2World;


uniform highp vec4 unity_SHC;
uniform highp vec4 unity_SHBb;
uniform highp vec4 unity_SHBg;
uniform highp vec4 unity_SHBr;
uniform highp vec4 unity_SHAb;
uniform highp vec4 unity_SHAg;
uniform highp vec4 unity_SHAr;
uniform highp vec4 unity_LightColor[4];
uniform highp vec4 unity_4LightAtten0;
uniform highp vec4 unity_4LightPosZ0;
uniform highp vec4 unity_4LightPosY0;
uniform highp vec4 unity_4LightPosX0;
uniform lowp vec4 _WorldSpaceLightPos0;
uniform highp vec4 _ProjectionParams;
attribute vec4 _glesTANGENT;
attribute vec4 _glesMultiTexCoord0;
attribute vec3 _glesNormal;
attribute vec4 _glesVertex;
void main ()
{
  vec4 tmpvar_1;
  tmpvar_1.xyz = normalize(_glesTANGENT.xyz);
  tmpvar_1.w = _glesTANGENT.w;
  vec3 tmpvar_2;
  tmpvar_2 = normalize(_glesNormal);
  highp vec3 shlight_3;
  highp vec4 tmpvar_4;
  lowp vec3 tmpvar_5;
  lowp vec3 tmpvar_6;
  highp vec3 tmpvar_7;
  highp vec3 tmpvar_8;
  tmpvar_7 = tmpvar_1.xyz;
  tmpvar_8 = (((tmpvar_2.yzx * tmpvar_1.zxy) - (tmpvar_2.zxy * tmpvar_1.yzx)) * _glesTANGENT.w);
  highp mat3 tmpvar_9;
  tmpvar_9[0].x = tmpvar_7.x;
  tmpvar_9[0].y = tmpvar_8.x;
  tmpvar_9[0].z = tmpvar_2.x;
  tmpvar_9[1].x = tmpvar_7.y;
  tmpvar_9[1].y = tmpvar_8.y;
  tmpvar_9[1].z = tmpvar_2.y;
  tmpvar_9[2].x = tmpvar_7.z;
  tmpvar_9[2].y = tmpvar_8.z;
  tmpvar_9[2].z = tmpvar_2.z;
  vec4 v_10;
  v_10.x = gl_ModelViewMatrixInverseTranspose[0].x;
  v_10.y = gl_ModelViewMatrixInverseTranspose[1].x;
  v_10.z = gl_ModelViewMatrixInverseTranspose[2].x;
  v_10.w = gl_ModelViewMatrixInverseTranspose[3].x;
  vec4 v_11;
  v_11.x = gl_ModelViewMatrixInverseTranspose[0].y;
  v_11.y = gl_ModelViewMatrixInverseTranspose[1].y;
  v_11.z = gl_ModelViewMatrixInverseTranspose[2].y;
  v_11.w = gl_ModelViewMatrixInverseTranspose[3].y;
  highp vec4 tmpvar_12;
  tmpvar_12 = (gl_ModelViewProjectionMatrix * _glesVertex);
  tmpvar_4.xy = ((_glesMultiTexCoord0.xy * _MainTex_ST.xy) + _MainTex_ST.zw);
  tmpvar_4.zw = ((_glesMultiTexCoord0.xy * _BumpMap_ST.xy) + _BumpMap_ST.zw);
  mat3 tmpvar_13;
  tmpvar_13[0] = _Object2World[0].xyz;
  tmpvar_13[1] = _Object2World[1].xyz;
  tmpvar_13[2] = _Object2World[2].xyz;
  highp vec3 tmpvar_14;
  tmpvar_14 = (tmpvar_13 * (tmpvar_2 * unity_Scale.w));
  highp vec3 tmpvar_15;
  highp vec3 tmpvar_16;
  tmpvar_15 = tmpvar_1.xyz;
  tmpvar_16 = (((tmpvar_2.yzx * tmpvar_1.zxy) - (tmpvar_2.zxy * tmpvar_1.yzx)) * _glesTANGENT.w);
  highp mat3 tmpvar_17;
  tmpvar_17[0].x = tmpvar_15.x;
  tmpvar_17[0].y = tmpvar_16.x;
  tmpvar_17[0].z = tmpvar_2.x;
  tmpvar_17[1].x = tmpvar_15.y;
  tmpvar_17[1].y = tmpvar_16.y;
  tmpvar_17[1].z = tmpvar_2.y;
  tmpvar_17[2].x = tmpvar_15.z;
  tmpvar_17[2].y = tmpvar_16.z;
  tmpvar_17[2].z = tmpvar_2.z;
  highp vec3 tmpvar_18;
  tmpvar_18 = (tmpvar_17 * (_World2Object * _WorldSpaceLightPos0).xyz);
  tmpvar_5 = tmpvar_18;
  highp vec4 tmpvar_19;
  tmpvar_19.w = 1.0;
  tmpvar_19.xyz = tmpvar_14;
  mediump vec3 tmpvar_20;
  mediump vec4 normal_21;
  normal_21 = tmpvar_19;
  highp float vC_22;
  mediump vec3 x3_23;
  mediump vec3 x2_24;
  mediump vec3 x1_25;
  highp float tmpvar_26;
  tmpvar_26 = dot (unity_SHAr, normal_21);
  x1_25.x = tmpvar_26;
  highp float tmpvar_27;
  tmpvar_27 = dot (unity_SHAg, normal_21);
  x1_25.y = tmpvar_27;
  highp float tmpvar_28;
  tmpvar_28 = dot (unity_SHAb, normal_21);
  x1_25.z = tmpvar_28;
  mediump vec4 tmpvar_29;
  tmpvar_29 = (normal_21.xyzz * normal_21.yzzx);
  highp float tmpvar_30;
  tmpvar_30 = dot (unity_SHBr, tmpvar_29);
  x2_24.x = tmpvar_30;
  highp float tmpvar_31;
  tmpvar_31 = dot (unity_SHBg, tmpvar_29);
  x2_24.y = tmpvar_31;
  highp float tmpvar_32;
  tmpvar_32 = dot (unity_SHBb, tmpvar_29);
  x2_24.z = tmpvar_32;
  mediump float tmpvar_33;
  tmpvar_33 = ((normal_21.x * normal_21.x) - (normal_21.y * normal_21.y));
  vC_22 = tmpvar_33;
  highp vec3 tmpvar_34;
  tmpvar_34 = (unity_SHC.xyz * vC_22);
  x3_23 = tmpvar_34;
  tmpvar_20 = ((x1_25 + x2_24) + x3_23);
  shlight_3 = tmpvar_20;
  tmpvar_6 = shlight_3;
  highp vec3 tmpvar_35;
  tmpvar_35 = (_Object2World * _glesVertex).xyz;
  highp vec4 tmpvar_36;
  tmpvar_36 = (unity_4LightPosX0 - tmpvar_35.x);
  highp vec4 tmpvar_37;
  tmpvar_37 = (unity_4LightPosY0 - tmpvar_35.y);
  highp vec4 tmpvar_38;
  tmpvar_38 = (unity_4LightPosZ0 - tmpvar_35.z);
  highp vec4 tmpvar_39;
  tmpvar_39 = (((tmpvar_36 * tmpvar_36) + (tmpvar_37 * tmpvar_37)) + (tmpvar_38 * tmpvar_38));
  highp vec4 tmpvar_40;
  tmpvar_40 = (max (vec4(0.0, 0.0, 0.0, 0.0), ((((tmpvar_36 * tmpvar_14.x) + (tmpvar_37 * tmpvar_14.y)) + (tmpvar_38 * tmpvar_14.z)) * inversesqrt(tmpvar_39))) * (1.0/((1.0 + (tmpvar_39 * unity_4LightAtten0)))));
  highp vec3 tmpvar_41;
  tmpvar_41 = (tmpvar_6 + ((((unity_LightColor[0].xyz * tmpvar_40.x) + (unity_LightColor[1].xyz * tmpvar_40.y)) + (unity_LightColor[2].xyz * tmpvar_40.z)) + (unity_LightColor[3].xyz * tmpvar_40.w)));
  tmpvar_6 = tmpvar_41;
  highp vec4 o_42;
  highp vec4 tmpvar_43;
  tmpvar_43 = (tmpvar_12 * 0.5);
  highp vec2 tmpvar_44;
  tmpvar_44.x = tmpvar_43.x;
  tmpvar_44.y = (tmpvar_43.y * _ProjectionParams.x);
  o_42.xy = (tmpvar_44 + tmpvar_43.w);
  o_42.zw = tmpvar_12.zw;
  gl_Position = tmpvar_12;
  xlv_TEXCOORD0 = tmpvar_4;
  xlv_TEXCOORD1 = (tmpvar_9 * v_10.xyz);
  xlv_TEXCOORD2 = (tmpvar_9 * v_11.xyz);
  xlv_TEXCOORD3 = tmpvar_5;
  xlv_TEXCOORD4 = tmpvar_6;
  xlv_TEXCOORD5 = o_42;
}



#endif
#ifdef FRAGMENT

varying highp vec4 xlv_TEXCOORD5;
varying lowp vec3 xlv_TEXCOORD4;
varying lowp vec3 xlv_TEXCOORD3;
varying highp vec3 xlv_TEXCOORD2;
varying highp vec3 xlv_TEXCOORD1;
varying highp vec4 xlv_TEXCOORD0;
uniform lowp float _Cutoff;
uniform sampler2D _Shade;
uniform sampler2D _BumpMap;
uniform sampler2D _MainTex;
uniform lowp vec4 _Color;
uniform sampler2D _ShadowMapTexture;
uniform lowp vec4 _LightColor0;
void main ()
{
  lowp vec4 c_1;
  lowp vec3 tmpvar_2;
  highp vec3 matcap_3;
  lowp vec3 normal_4;
  normal_4.xy = ((texture2D (_BumpMap, xlv_TEXCOORD0.zw).wy * 2.0) - 1.0);
  normal_4.z = sqrt(((1.0 - (normal_4.x * normal_4.x)) - (normal_4.y * normal_4.y)));
  lowp vec3 tmpvar_5;
  tmpvar_5 = (texture2D (_MainTex, xlv_TEXCOORD0.xy).xyz * _Color.w);
  highp vec2 tmpvar_6;
  tmpvar_6.x = dot (xlv_TEXCOORD1, normal_4);
  tmpvar_6.y = dot (xlv_TEXCOORD2, normal_4);
  highp vec2 P_7;
  P_7 = ((tmpvar_6 * 0.5) + 0.5);
  lowp vec3 tmpvar_8;
  tmpvar_8 = texture2D (_Shade, P_7).xyz;
  matcap_3 = tmpvar_8;
  lowp vec4 tmpvar_9;
  tmpvar_9 = texture2D (_MainTex, xlv_TEXCOORD0.xy);
  highp vec3 tmpvar_10;
  tmpvar_10 = (((matcap_3 * tmpvar_9.xyz) * _Color.xyz) * 3.0);
  tmpvar_2 = tmpvar_10;
  lowp vec4 tmpvar_11;
  tmpvar_11 = texture2D (_MainTex, xlv_TEXCOORD0.xy);
  lowp float tmpvar_12;
  tmpvar_12 = tmpvar_11.w;
  lowp float x_13;
  x_13 = (tmpvar_11.w - _Cutoff);
  if ((x_13 < 0.0)) {
    discard;
  };
  lowp vec4 c_14;
  c_14.xyz = ((tmpvar_5 * _LightColor0.xyz) * ((max (0.0, dot (normal_4, xlv_TEXCOORD3)) * texture2DProj (_ShadowMapTexture, xlv_TEXCOORD5).x) * 2.0));
  c_14.w = tmpvar_12;
  c_1.w = c_14.w;
  c_1.xyz = (c_14.xyz + (tmpvar_5 * xlv_TEXCOORD4));
  c_1.xyz = (c_1.xyz + tmpvar_2);
  c_1.w = tmpvar_12;
  gl_FragData[0] = c_1;
}



#endif"
}

SubProgram "flash " {
Keywords { "DIRECTIONAL" "LIGHTMAP_OFF" "DIRLIGHTMAP_OFF" "SHADOWS_SCREEN" "VERTEXLIGHT_ON" }
Bind "vertex" Vertex
Bind "tangent" TexCoord2
Bind "normal" Normal
Bind "texcoord" TexCoord0
Matrix 0 [glstate_matrix_mvp]
Matrix 4 [glstate_matrix_invtrans_modelview0]
Vector 16 [_ProjectionParams]
Vector 17 [_WorldSpaceLightPos0]
Vector 18 [unity_4LightPosX0]
Vector 19 [unity_4LightPosY0]
Vector 20 [unity_4LightPosZ0]
Vector 21 [unity_4LightAtten0]
Vector 22 [unity_LightColor0]
Vector 23 [unity_LightColor1]
Vector 24 [unity_LightColor2]
Vector 25 [unity_LightColor3]
Vector 26 [unity_SHAr]
Vector 27 [unity_SHAg]
Vector 28 [unity_SHAb]
Vector 29 [unity_SHBr]
Vector 30 [unity_SHBg]
Vector 31 [unity_SHBb]
Vector 32 [unity_SHC]
Matrix 8 [_Object2World]
Matrix 12 [_World2Object]
Vector 33 [unity_Scale]
Vector 34 [unity_NPOTScale]
Vector 35 [_MainTex_ST]
Vector 36 [_BumpMap_ST]
"agal_vs
c37 1.0 0.0 0.5 0.0
[bc]
adaaaaaaadaaahacabaaaaoeaaaaaaaacbaaaappabaaaaaa mul r3.xyz, a1, c33.w
bdaaaaaaaaaaabacaaaaaaoeaaaaaaaaajaaaaoeabaaaaaa dp4 r0.x, a0, c9
bfaaaaaaabaaabacaaaaaaaaacaaaaaaaaaaaaaaaaaaaaaa neg r1.x, r0.x
abaaaaaaabaaapacabaaaaaaacaaaaaabdaaaaoeabaaaaaa add r1, r1.x, c19
bcaaaaaaadaaaiacadaaaakeacaaaaaaajaaaaoeabaaaaaa dp3 r3.w, r3.xyzz, c9
bcaaaaaaaeaaabacadaaaakeacaaaaaaaiaaaaoeabaaaaaa dp3 r4.x, r3.xyzz, c8
bcaaaaaaadaaabacadaaaakeacaaaaaaakaaaaoeabaaaaaa dp3 r3.x, r3.xyzz, c10
adaaaaaaacaaapacadaaaappacaaaaaaabaaaaoeacaaaaaa mul r2, r3.w, r1
bdaaaaaaaaaaabacaaaaaaoeaaaaaaaaaiaaaaoeabaaaaaa dp4 r0.x, a0, c8
bfaaaaaaaaaaabacaaaaaaaaacaaaaaaaaaaaaaaaaaaaaaa neg r0.x, r0.x
abaaaaaaaaaaapacaaaaaaaaacaaaaaabcaaaaoeabaaaaaa add r0, r0.x, c18
adaaaaaaabaaapacabaaaaoeacaaaaaaabaaaaoeacaaaaaa mul r1, r1, r1
aaaaaaaaaeaaaeacadaaaaaaacaaaaaaaaaaaaaaaaaaaaaa mov r4.z, r3.x
adaaaaaaafaaapacaeaaaaaaacaaaaaaaaaaaaoeacaaaaaa mul r5, r4.x, r0
abaaaaaaacaaapacafaaaaoeacaaaaaaacaaaaoeacaaaaaa add r2, r5, r2
aaaaaaaaaeaaaiaccfaaaaaaabaaaaaaaaaaaaaaaaaaaaaa mov r4.w, c37.x
bdaaaaaaaeaaacacaaaaaaoeaaaaaaaaakaaaaoeabaaaaaa dp4 r4.y, a0, c10
adaaaaaaafaaapacaaaaaaoeacaaaaaaaaaaaaoeacaaaaaa mul r5, r0, r0
abaaaaaaabaaapacafaaaaoeacaaaaaaabaaaaoeacaaaaaa add r1, r5, r1
bfaaaaaaaaaaacacaeaaaaffacaaaaaaaaaaaaaaaaaaaaaa neg r0.y, r4.y
abaaaaaaaaaaapacaaaaaaffacaaaaaabeaaaaoeabaaaaaa add r0, r0.y, c20
adaaaaaaafaaapacaaaaaaoeacaaaaaaaaaaaaoeacaaaaaa mul r5, r0, r0
abaaaaaaabaaapacafaaaaoeacaaaaaaabaaaaoeacaaaaaa add r1, r5, r1
adaaaaaaaaaaapacadaaaaaaacaaaaaaaaaaaaoeacaaaaaa mul r0, r3.x, r0
abaaaaaaaaaaapacaaaaaaoeacaaaaaaacaaaaoeacaaaaaa add r0, r0, r2
adaaaaaaacaaapacabaaaaoeacaaaaaabfaaaaoeabaaaaaa mul r2, r1, c21
aaaaaaaaaeaaacacadaaaappacaaaaaaaaaaaaaaaaaaaaaa mov r4.y, r3.w
akaaaaaaabaaabacabaaaaaaacaaaaaaaaaaaaaaaaaaaaaa rsq r1.x, r1.x
akaaaaaaabaaacacabaaaaffacaaaaaaaaaaaaaaaaaaaaaa rsq r1.y, r1.y
akaaaaaaabaaaiacabaaaappacaaaaaaaaaaaaaaaaaaaaaa rsq r1.w, r1.w
akaaaaaaabaaaeacabaaaakkacaaaaaaaaaaaaaaaaaaaaaa rsq r1.z, r1.z
adaaaaaaaaaaapacaaaaaaoeacaaaaaaabaaaaoeacaaaaaa mul r0, r0, r1
abaaaaaaabaaapacacaaaaoeacaaaaaacfaaaaaaabaaaaaa add r1, r2, c37.x
afaaaaaaabaaabacabaaaaaaacaaaaaaaaaaaaaaaaaaaaaa rcp r1.x, r1.x
afaaaaaaabaaacacabaaaaffacaaaaaaaaaaaaaaaaaaaaaa rcp r1.y, r1.y
afaaaaaaabaaaiacabaaaappacaaaaaaaaaaaaaaaaaaaaaa rcp r1.w, r1.w
afaaaaaaabaaaeacabaaaakkacaaaaaaaaaaaaaaaaaaaaaa rcp r1.z, r1.z
ahaaaaaaaaaaapacaaaaaaoeacaaaaaacfaaaaffabaaaaaa max r0, r0, c37.y
adaaaaaaaaaaapacaaaaaaoeacaaaaaaabaaaaoeacaaaaaa mul r0, r0, r1
adaaaaaaabaaahacaaaaaaffacaaaaaabhaaaaoeabaaaaaa mul r1.xyz, r0.y, c23
adaaaaaaafaaahacaaaaaaaaacaaaaaabgaaaaoeabaaaaaa mul r5.xyz, r0.x, c22
abaaaaaaabaaahacafaaaakeacaaaaaaabaaaakeacaaaaaa add r1.xyz, r5.xyzz, r1.xyzz
adaaaaaaaaaaahacaaaaaakkacaaaaaabiaaaaoeabaaaaaa mul r0.xyz, r0.z, c24
abaaaaaaaaaaahacaaaaaakeacaaaaaaabaaaakeacaaaaaa add r0.xyz, r0.xyzz, r1.xyzz
adaaaaaaabaaahacaaaaaappacaaaaaabjaaaaoeabaaaaaa mul r1.xyz, r0.w, c25
abaaaaaaabaaahacabaaaakeacaaaaaaaaaaaakeacaaaaaa add r1.xyz, r1.xyzz, r0.xyzz
adaaaaaaaaaaapacaeaaaakeacaaaaaaaeaaaacjacaaaaaa mul r0, r4.xyzz, r4.yzzx
adaaaaaaabaaaiacadaaaappacaaaaaaadaaaappacaaaaaa mul r1.w, r3.w, r3.w
bdaaaaaaadaaaeacaaaaaaoeacaaaaaabpaaaaoeabaaaaaa dp4 r3.z, r0, c31
bdaaaaaaadaaacacaaaaaaoeacaaaaaaboaaaaoeabaaaaaa dp4 r3.y, r0, c30
bdaaaaaaadaaabacaaaaaaoeacaaaaaabnaaaaoeabaaaaaa dp4 r3.x, r0, c29
adaaaaaaafaaaiacaeaaaaaaacaaaaaaaeaaaaaaacaaaaaa mul r5.w, r4.x, r4.x
acaaaaaaabaaaiacafaaaappacaaaaaaabaaaappacaaaaaa sub r1.w, r5.w, r1.w
adaaaaaaaaaaahacabaaaappacaaaaaacaaaaaoeabaaaaaa mul r0.xyz, r1.w, c32
bdaaaaaaacaaaeacaeaaaaoeacaaaaaabmaaaaoeabaaaaaa dp4 r2.z, r4, c28
bdaaaaaaacaaacacaeaaaaoeacaaaaaablaaaaoeabaaaaaa dp4 r2.y, r4, c27
bdaaaaaaacaaabacaeaaaaoeacaaaaaabkaaaaoeabaaaaaa dp4 r2.x, r4, c26
abaaaaaaacaaahacacaaaakeacaaaaaaadaaaakeacaaaaaa add r2.xyz, r2.xyzz, r3.xyzz
abaaaaaaacaaahacacaaaakeacaaaaaaaaaaaakeacaaaaaa add r2.xyz, r2.xyzz, r0.xyzz
aaaaaaaaaaaaahacafaaaaoeaaaaaaaaaaaaaaaaaaaaaaaa mov r0.xyz, a5
abaaaaaaaeaaahaeacaaaakeacaaaaaaabaaaakeacaaaaaa add v4.xyz, r2.xyzz, r1.xyzz
adaaaaaaabaaahacabaaaancaaaaaaaaaaaaaaajacaaaaaa mul r1.xyz, a1.zxyw, r0.yzxx
aaaaaaaaaaaaahacafaaaaoeaaaaaaaaaaaaaaaaaaaaaaaa mov r0.xyz, a5
adaaaaaaafaaahacabaaaamjaaaaaaaaaaaaaafcacaaaaaa mul r5.xyz, a1.yzxw, r0.zxyy
acaaaaaaabaaahacafaaaakeacaaaaaaabaaaakeacaaaaaa sub r1.xyz, r5.xyzz, r1.xyzz
adaaaaaaacaaahacabaaaakeacaaaaaaafaaaappaaaaaaaa mul r2.xyz, r1.xyzz, a5.w
aaaaaaaaaaaaapacaoaaaaoeabaaaaaaaaaaaaaaaaaaaaaa mov r0, c14
bdaaaaaaadaaaeacbbaaaaoeabaaaaaaaaaaaaoeacaaaaaa dp4 r3.z, c17, r0
aaaaaaaaaaaaapacanaaaaoeabaaaaaaaaaaaaaaaaaaaaaa mov r0, c13
bdaaaaaaadaaacacbbaaaaoeabaaaaaaaaaaaaoeacaaaaaa dp4 r3.y, c17, r0
aaaaaaaaabaaapacamaaaaoeabaaaaaaaaaaaaaaaaaaaaaa mov r1, c12
bdaaaaaaadaaabacbbaaaaoeabaaaaaaabaaaaoeacaaaaaa dp4 r3.x, c17, r1
bdaaaaaaaaaaaiacaaaaaaoeaaaaaaaaadaaaaoeabaaaaaa dp4 r0.w, a0, c3
bdaaaaaaaaaaaeacaaaaaaoeaaaaaaaaacaaaaoeabaaaaaa dp4 r0.z, a0, c2
bdaaaaaaaaaaabacaaaaaaoeaaaaaaaaaaaaaaoeabaaaaaa dp4 r0.x, a0, c0
bdaaaaaaaaaaacacaaaaaaoeaaaaaaaaabaaaaoeabaaaaaa dp4 r0.y, a0, c1
adaaaaaaabaaahacaaaaaapeacaaaaaacfaaaakkabaaaaaa mul r1.xyz, r0.xyww, c37.z
adaaaaaaabaaacacabaaaaffacaaaaaabaaaaaaaabaaaaaa mul r1.y, r1.y, c16.x
abaaaaaaabaaadacabaaaafeacaaaaaaabaaaakkacaaaaaa add r1.xy, r1.xyyy, r1.z
bcaaaaaaadaaacaeacaaaakeacaaaaaaadaaaakeacaaaaaa dp3 v3.y, r2.xyzz, r3.xyzz
bcaaaaaaabaaacaeacaaaakeacaaaaaaaeaaaaoeabaaaaaa dp3 v1.y, r2.xyzz, c4
bcaaaaaaacaaacaeacaaaakeacaaaaaaafaaaaoeabaaaaaa dp3 v2.y, r2.xyzz, c5
bcaaaaaaadaaaeaeabaaaaoeaaaaaaaaadaaaakeacaaaaaa dp3 v3.z, a1, r3.xyzz
bcaaaaaaadaaabaeafaaaaoeaaaaaaaaadaaaakeacaaaaaa dp3 v3.x, a5, r3.xyzz
adaaaaaaafaaadaeabaaaafeacaaaaaaccaaaaoeabaaaaaa mul v5.xy, r1.xyyy, c34
aaaaaaaaaaaaapadaaaaaaoeacaaaaaaaaaaaaaaaaaaaaaa mov o0, r0
aaaaaaaaafaaamaeaaaaaaopacaaaaaaaaaaaaaaaaaaaaaa mov v5.zw, r0.wwzw
adaaaaaaafaaamacadaaaaeeaaaaaaaaceaaaaeeabaaaaaa mul r5.zw, a3.xyxy, c36.xyxy
abaaaaaaaaaaamaeafaaaaopacaaaaaaceaaaaoeabaaaaaa add v0.zw, r5.wwzw, c36
adaaaaaaafaaadacadaaaaoeaaaaaaaacdaaaaoeabaaaaaa mul r5.xy, a3, c35
abaaaaaaaaaaadaeafaaaafeacaaaaaacdaaaaooabaaaaaa add v0.xy, r5.xyyy, c35.zwzw
bcaaaaaaabaaaeaeabaaaaoeaaaaaaaaaeaaaaoeabaaaaaa dp3 v1.z, a1, c4
bcaaaaaaabaaabaeafaaaaoeaaaaaaaaaeaaaaoeabaaaaaa dp3 v1.x, a5, c4
bcaaaaaaacaaaeaeabaaaaoeaaaaaaaaafaaaaoeabaaaaaa dp3 v2.z, a1, c5
bcaaaaaaacaaabaeafaaaaoeaaaaaaaaafaaaaoeabaaaaaa dp3 v2.x, a5, c5
aaaaaaaaabaaaiaeaaaaaaoeabaaaaaaaaaaaaaaaaaaaaaa mov v1.w, c0
aaaaaaaaacaaaiaeaaaaaaoeabaaaaaaaaaaaaaaaaaaaaaa mov v2.w, c0
aaaaaaaaadaaaiaeaaaaaaoeabaaaaaaaaaaaaaaaaaaaaaa mov v3.w, c0
aaaaaaaaaeaaaiaeaaaaaaoeabaaaaaaaaaaaaaaaaaaaaaa mov v4.w, c0
"
}

SubProgram "gles " {
Keywords { "DIRECTIONAL" "LIGHTMAP_OFF" "DIRLIGHTMAP_OFF" "SHADOWS_SCREEN" "SHADOWS_NATIVE" }
"!!GLES
#define SHADER_API_GLES 1
#define tex2D texture2D


#ifdef VERTEX

#extension GL_EXT_shadow_samplers : enable
#define gl_ModelViewProjectionMatrix glstate_matrix_mvp
uniform mat4 glstate_matrix_mvp;
#define gl_ModelViewMatrixInverseTranspose glstate_matrix_invtrans_modelview0
uniform mat4 glstate_matrix_invtrans_modelview0;
#define gl_ModelViewMatrix glstate_matrix_modelview0
uniform mat4 glstate_matrix_modelview0;
varying highp vec4 xlv_TEXCOORD5;
varying lowp vec3 xlv_TEXCOORD4;
varying lowp vec3 xlv_TEXCOORD3;
varying highp vec3 xlv_TEXCOORD2;
varying highp vec3 xlv_TEXCOORD1;
varying highp vec4 xlv_TEXCOORD0;
uniform highp vec4 _BumpMap_ST;
uniform highp vec4 _MainTex_ST;
uniform highp vec4 unity_Scale;
uniform highp mat4 _World2Object;
uniform highp mat4 _Object2World;


uniform highp mat4 unity_World2Shadow[4];
uniform highp vec4 unity_SHC;
uniform highp vec4 unity_SHBb;
uniform highp vec4 unity_SHBg;
uniform highp vec4 unity_SHBr;
uniform highp vec4 unity_SHAb;
uniform highp vec4 unity_SHAg;
uniform highp vec4 unity_SHAr;
uniform lowp vec4 _WorldSpaceLightPos0;
attribute vec4 _glesTANGENT;
attribute vec4 _glesMultiTexCoord0;
attribute vec3 _glesNormal;
attribute vec4 _glesVertex;
void main ()
{
  vec4 tmpvar_1;
  tmpvar_1.xyz = normalize(_glesTANGENT.xyz);
  tmpvar_1.w = _glesTANGENT.w;
  vec3 tmpvar_2;
  tmpvar_2 = normalize(_glesNormal);
  highp vec3 shlight_3;
  highp vec4 tmpvar_4;
  lowp vec3 tmpvar_5;
  lowp vec3 tmpvar_6;
  highp vec3 tmpvar_7;
  highp vec3 tmpvar_8;
  tmpvar_7 = tmpvar_1.xyz;
  tmpvar_8 = (((tmpvar_2.yzx * tmpvar_1.zxy) - (tmpvar_2.zxy * tmpvar_1.yzx)) * _glesTANGENT.w);
  highp mat3 tmpvar_9;
  tmpvar_9[0].x = tmpvar_7.x;
  tmpvar_9[0].y = tmpvar_8.x;
  tmpvar_9[0].z = tmpvar_2.x;
  tmpvar_9[1].x = tmpvar_7.y;
  tmpvar_9[1].y = tmpvar_8.y;
  tmpvar_9[1].z = tmpvar_2.y;
  tmpvar_9[2].x = tmpvar_7.z;
  tmpvar_9[2].y = tmpvar_8.z;
  tmpvar_9[2].z = tmpvar_2.z;
  vec4 v_10;
  v_10.x = gl_ModelViewMatrixInverseTranspose[0].x;
  v_10.y = gl_ModelViewMatrixInverseTranspose[1].x;
  v_10.z = gl_ModelViewMatrixInverseTranspose[2].x;
  v_10.w = gl_ModelViewMatrixInverseTranspose[3].x;
  vec4 v_11;
  v_11.x = gl_ModelViewMatrixInverseTranspose[0].y;
  v_11.y = gl_ModelViewMatrixInverseTranspose[1].y;
  v_11.z = gl_ModelViewMatrixInverseTranspose[2].y;
  v_11.w = gl_ModelViewMatrixInverseTranspose[3].y;
  tmpvar_4.xy = ((_glesMultiTexCoord0.xy * _MainTex_ST.xy) + _MainTex_ST.zw);
  tmpvar_4.zw = ((_glesMultiTexCoord0.xy * _BumpMap_ST.xy) + _BumpMap_ST.zw);
  mat3 tmpvar_12;
  tmpvar_12[0] = _Object2World[0].xyz;
  tmpvar_12[1] = _Object2World[1].xyz;
  tmpvar_12[2] = _Object2World[2].xyz;
  highp vec3 tmpvar_13;
  highp vec3 tmpvar_14;
  tmpvar_13 = tmpvar_1.xyz;
  tmpvar_14 = (((tmpvar_2.yzx * tmpvar_1.zxy) - (tmpvar_2.zxy * tmpvar_1.yzx)) * _glesTANGENT.w);
  highp mat3 tmpvar_15;
  tmpvar_15[0].x = tmpvar_13.x;
  tmpvar_15[0].y = tmpvar_14.x;
  tmpvar_15[0].z = tmpvar_2.x;
  tmpvar_15[1].x = tmpvar_13.y;
  tmpvar_15[1].y = tmpvar_14.y;
  tmpvar_15[1].z = tmpvar_2.y;
  tmpvar_15[2].x = tmpvar_13.z;
  tmpvar_15[2].y = tmpvar_14.z;
  tmpvar_15[2].z = tmpvar_2.z;
  highp vec3 tmpvar_16;
  tmpvar_16 = (tmpvar_15 * (_World2Object * _WorldSpaceLightPos0).xyz);
  tmpvar_5 = tmpvar_16;
  highp vec4 tmpvar_17;
  tmpvar_17.w = 1.0;
  tmpvar_17.xyz = (tmpvar_12 * (tmpvar_2 * unity_Scale.w));
  mediump vec3 tmpvar_18;
  mediump vec4 normal_19;
  normal_19 = tmpvar_17;
  highp float vC_20;
  mediump vec3 x3_21;
  mediump vec3 x2_22;
  mediump vec3 x1_23;
  highp float tmpvar_24;
  tmpvar_24 = dot (unity_SHAr, normal_19);
  x1_23.x = tmpvar_24;
  highp float tmpvar_25;
  tmpvar_25 = dot (unity_SHAg, normal_19);
  x1_23.y = tmpvar_25;
  highp float tmpvar_26;
  tmpvar_26 = dot (unity_SHAb, normal_19);
  x1_23.z = tmpvar_26;
  mediump vec4 tmpvar_27;
  tmpvar_27 = (normal_19.xyzz * normal_19.yzzx);
  highp float tmpvar_28;
  tmpvar_28 = dot (unity_SHBr, tmpvar_27);
  x2_22.x = tmpvar_28;
  highp float tmpvar_29;
  tmpvar_29 = dot (unity_SHBg, tmpvar_27);
  x2_22.y = tmpvar_29;
  highp float tmpvar_30;
  tmpvar_30 = dot (unity_SHBb, tmpvar_27);
  x2_22.z = tmpvar_30;
  mediump float tmpvar_31;
  tmpvar_31 = ((normal_19.x * normal_19.x) - (normal_19.y * normal_19.y));
  vC_20 = tmpvar_31;
  highp vec3 tmpvar_32;
  tmpvar_32 = (unity_SHC.xyz * vC_20);
  x3_21 = tmpvar_32;
  tmpvar_18 = ((x1_23 + x2_22) + x3_21);
  shlight_3 = tmpvar_18;
  tmpvar_6 = shlight_3;
  gl_Position = (gl_ModelViewProjectionMatrix * _glesVertex);
  xlv_TEXCOORD0 = tmpvar_4;
  xlv_TEXCOORD1 = (tmpvar_9 * v_10.xyz);
  xlv_TEXCOORD2 = (tmpvar_9 * v_11.xyz);
  xlv_TEXCOORD3 = tmpvar_5;
  xlv_TEXCOORD4 = tmpvar_6;
  xlv_TEXCOORD5 = (unity_World2Shadow[0] * (_Object2World * _glesVertex));
}



#endif
#ifdef FRAGMENT

#extension GL_EXT_shadow_samplers : enable
varying highp vec4 xlv_TEXCOORD5;
varying lowp vec3 xlv_TEXCOORD4;
varying lowp vec3 xlv_TEXCOORD3;
varying highp vec3 xlv_TEXCOORD2;
varying highp vec3 xlv_TEXCOORD1;
varying highp vec4 xlv_TEXCOORD0;
uniform lowp float _Cutoff;
uniform sampler2D _Shade;
uniform sampler2D _BumpMap;
uniform sampler2D _MainTex;
uniform lowp vec4 _Color;
uniform sampler2DShadow _ShadowMapTexture;
uniform lowp vec4 _LightColor0;
uniform highp vec4 _LightShadowData;
void main ()
{
  lowp vec4 c_1;
  lowp vec3 tmpvar_2;
  highp vec3 matcap_3;
  lowp vec3 tmpvar_4;
  tmpvar_4 = ((texture2D (_BumpMap, xlv_TEXCOORD0.zw).xyz * 2.0) - 1.0);
  lowp vec3 tmpvar_5;
  tmpvar_5 = (texture2D (_MainTex, xlv_TEXCOORD0.xy).xyz * _Color.w);
  highp vec2 tmpvar_6;
  tmpvar_6.x = dot (xlv_TEXCOORD1, tmpvar_4);
  tmpvar_6.y = dot (xlv_TEXCOORD2, tmpvar_4);
  highp vec2 P_7;
  P_7 = ((tmpvar_6 * 0.5) + 0.5);
  lowp vec3 tmpvar_8;
  tmpvar_8 = texture2D (_Shade, P_7).xyz;
  matcap_3 = tmpvar_8;
  lowp vec4 tmpvar_9;
  tmpvar_9 = texture2D (_MainTex, xlv_TEXCOORD0.xy);
  highp vec3 tmpvar_10;
  tmpvar_10 = (((matcap_3 * tmpvar_9.xyz) * _Color.xyz) * 3.0);
  tmpvar_2 = tmpvar_10;
  lowp vec4 tmpvar_11;
  tmpvar_11 = texture2D (_MainTex, xlv_TEXCOORD0.xy);
  lowp float tmpvar_12;
  tmpvar_12 = tmpvar_11.w;
  lowp float x_13;
  x_13 = (tmpvar_11.w - _Cutoff);
  if ((x_13 < 0.0)) {
    discard;
  };
  lowp float shadow_14;
  lowp float tmpvar_15;
  tmpvar_15 = shadow2DEXT (_ShadowMapTexture, xlv_TEXCOORD5.xyz);
  highp float tmpvar_16;
  tmpvar_16 = (_LightShadowData.x + (tmpvar_15 * (1.0 - _LightShadowData.x)));
  shadow_14 = tmpvar_16;
  lowp vec4 c_17;
  c_17.xyz = ((tmpvar_5 * _LightColor0.xyz) * ((max (0.0, dot (tmpvar_4, xlv_TEXCOORD3)) * shadow_14) * 2.0));
  c_17.w = tmpvar_12;
  c_1.w = c_17.w;
  c_1.xyz = (c_17.xyz + (tmpvar_5 * xlv_TEXCOORD4));
  c_1.xyz = (c_1.xyz + tmpvar_2);
  c_1.w = tmpvar_12;
  gl_FragData[0] = c_1;
}



#endif"
}

SubProgram "gles " {
Keywords { "DIRECTIONAL" "LIGHTMAP_ON" "DIRLIGHTMAP_OFF" "SHADOWS_SCREEN" "SHADOWS_NATIVE" }
"!!GLES
#define SHADER_API_GLES 1
#define tex2D texture2D


#ifdef VERTEX

#extension GL_EXT_shadow_samplers : enable
#define gl_ModelViewProjectionMatrix glstate_matrix_mvp
uniform mat4 glstate_matrix_mvp;
#define gl_ModelViewMatrixInverseTranspose glstate_matrix_invtrans_modelview0
uniform mat4 glstate_matrix_invtrans_modelview0;
#define gl_ModelViewMatrix glstate_matrix_modelview0
uniform mat4 glstate_matrix_modelview0;
varying highp vec4 xlv_TEXCOORD4;
varying highp vec2 xlv_TEXCOORD3;
varying highp vec3 xlv_TEXCOORD2;
varying highp vec3 xlv_TEXCOORD1;
varying highp vec4 xlv_TEXCOORD0;
uniform highp vec4 _BumpMap_ST;
uniform highp vec4 _MainTex_ST;
uniform highp vec4 unity_LightmapST;
uniform highp mat4 _Object2World;


uniform highp mat4 unity_World2Shadow[4];
attribute vec4 _glesTANGENT;
attribute vec4 _glesMultiTexCoord1;
attribute vec4 _glesMultiTexCoord0;
attribute vec3 _glesNormal;
attribute vec4 _glesVertex;
void main ()
{
  vec4 tmpvar_1;
  tmpvar_1.xyz = normalize(_glesTANGENT.xyz);
  tmpvar_1.w = _glesTANGENT.w;
  vec3 tmpvar_2;
  tmpvar_2 = normalize(_glesNormal);
  highp vec4 tmpvar_3;
  highp vec3 tmpvar_4;
  highp vec3 tmpvar_5;
  tmpvar_4 = tmpvar_1.xyz;
  tmpvar_5 = (((tmpvar_2.yzx * tmpvar_1.zxy) - (tmpvar_2.zxy * tmpvar_1.yzx)) * _glesTANGENT.w);
  highp mat3 tmpvar_6;
  tmpvar_6[0].x = tmpvar_4.x;
  tmpvar_6[0].y = tmpvar_5.x;
  tmpvar_6[0].z = tmpvar_2.x;
  tmpvar_6[1].x = tmpvar_4.y;
  tmpvar_6[1].y = tmpvar_5.y;
  tmpvar_6[1].z = tmpvar_2.y;
  tmpvar_6[2].x = tmpvar_4.z;
  tmpvar_6[2].y = tmpvar_5.z;
  tmpvar_6[2].z = tmpvar_2.z;
  vec4 v_7;
  v_7.x = gl_ModelViewMatrixInverseTranspose[0].x;
  v_7.y = gl_ModelViewMatrixInverseTranspose[1].x;
  v_7.z = gl_ModelViewMatrixInverseTranspose[2].x;
  v_7.w = gl_ModelViewMatrixInverseTranspose[3].x;
  vec4 v_8;
  v_8.x = gl_ModelViewMatrixInverseTranspose[0].y;
  v_8.y = gl_ModelViewMatrixInverseTranspose[1].y;
  v_8.z = gl_ModelViewMatrixInverseTranspose[2].y;
  v_8.w = gl_ModelViewMatrixInverseTranspose[3].y;
  tmpvar_3.xy = ((_glesMultiTexCoord0.xy * _MainTex_ST.xy) + _MainTex_ST.zw);
  tmpvar_3.zw = ((_glesMultiTexCoord0.xy * _BumpMap_ST.xy) + _BumpMap_ST.zw);
  gl_Position = (gl_ModelViewProjectionMatrix * _glesVertex);
  xlv_TEXCOORD0 = tmpvar_3;
  xlv_TEXCOORD1 = (tmpvar_6 * v_7.xyz);
  xlv_TEXCOORD2 = (tmpvar_6 * v_8.xyz);
  xlv_TEXCOORD3 = ((_glesMultiTexCoord1.xy * unity_LightmapST.xy) + unity_LightmapST.zw);
  xlv_TEXCOORD4 = (unity_World2Shadow[0] * (_Object2World * _glesVertex));
}



#endif
#ifdef FRAGMENT

#extension GL_EXT_shadow_samplers : enable
varying highp vec4 xlv_TEXCOORD4;
varying highp vec2 xlv_TEXCOORD3;
varying highp vec3 xlv_TEXCOORD2;
varying highp vec3 xlv_TEXCOORD1;
varying highp vec4 xlv_TEXCOORD0;
uniform lowp float _Cutoff;
uniform sampler2D unity_Lightmap;
uniform sampler2D _Shade;
uniform sampler2D _BumpMap;
uniform sampler2D _MainTex;
uniform lowp vec4 _Color;
uniform sampler2DShadow _ShadowMapTexture;
uniform highp vec4 _LightShadowData;
void main ()
{
  lowp vec4 c_1;
  lowp vec3 tmpvar_2;
  highp vec3 matcap_3;
  lowp vec3 tmpvar_4;
  tmpvar_4 = ((texture2D (_BumpMap, xlv_TEXCOORD0.zw).xyz * 2.0) - 1.0);
  highp vec2 tmpvar_5;
  tmpvar_5.x = dot (xlv_TEXCOORD1, tmpvar_4);
  tmpvar_5.y = dot (xlv_TEXCOORD2, tmpvar_4);
  highp vec2 P_6;
  P_6 = ((tmpvar_5 * 0.5) + 0.5);
  lowp vec3 tmpvar_7;
  tmpvar_7 = texture2D (_Shade, P_6).xyz;
  matcap_3 = tmpvar_7;
  lowp vec4 tmpvar_8;
  tmpvar_8 = texture2D (_MainTex, xlv_TEXCOORD0.xy);
  highp vec3 tmpvar_9;
  tmpvar_9 = (((matcap_3 * tmpvar_8.xyz) * _Color.xyz) * 3.0);
  tmpvar_2 = tmpvar_9;
  lowp vec4 tmpvar_10;
  tmpvar_10 = texture2D (_MainTex, xlv_TEXCOORD0.xy);
  lowp float tmpvar_11;
  tmpvar_11 = tmpvar_10.w;
  lowp float x_12;
  x_12 = (tmpvar_10.w - _Cutoff);
  if ((x_12 < 0.0)) {
    discard;
  };
  lowp float shadow_13;
  lowp float tmpvar_14;
  tmpvar_14 = shadow2DEXT (_ShadowMapTexture, xlv_TEXCOORD4.xyz);
  highp float tmpvar_15;
  tmpvar_15 = (_LightShadowData.x + (tmpvar_14 * (1.0 - _LightShadowData.x)));
  shadow_13 = tmpvar_15;
  c_1.xyz = ((texture2D (_MainTex, xlv_TEXCOORD0.xy).xyz * _Color.w) * min ((2.0 * texture2D (unity_Lightmap, xlv_TEXCOORD3).xyz), vec3((shadow_13 * 2.0))));
  c_1.w = tmpvar_11;
  c_1.xyz = (c_1.xyz + tmpvar_2);
  c_1.w = tmpvar_11;
  gl_FragData[0] = c_1;
}



#endif"
}

SubProgram "gles " {
Keywords { "DIRECTIONAL" "LIGHTMAP_ON" "DIRLIGHTMAP_ON" "SHADOWS_SCREEN" "SHADOWS_NATIVE" }
"!!GLES
#define SHADER_API_GLES 1
#define tex2D texture2D


#ifdef VERTEX

#extension GL_EXT_shadow_samplers : enable
#define gl_ModelViewProjectionMatrix glstate_matrix_mvp
uniform mat4 glstate_matrix_mvp;
#define gl_ModelViewMatrixInverseTranspose glstate_matrix_invtrans_modelview0
uniform mat4 glstate_matrix_invtrans_modelview0;
#define gl_ModelViewMatrix glstate_matrix_modelview0
uniform mat4 glstate_matrix_modelview0;
varying highp vec4 xlv_TEXCOORD4;
varying highp vec2 xlv_TEXCOORD3;
varying highp vec3 xlv_TEXCOORD2;
varying highp vec3 xlv_TEXCOORD1;
varying highp vec4 xlv_TEXCOORD0;
uniform highp vec4 _BumpMap_ST;
uniform highp vec4 _MainTex_ST;
uniform highp vec4 unity_LightmapST;
uniform highp mat4 _Object2World;


uniform highp mat4 unity_World2Shadow[4];
attribute vec4 _glesTANGENT;
attribute vec4 _glesMultiTexCoord1;
attribute vec4 _glesMultiTexCoord0;
attribute vec3 _glesNormal;
attribute vec4 _glesVertex;
void main ()
{
  vec4 tmpvar_1;
  tmpvar_1.xyz = normalize(_glesTANGENT.xyz);
  tmpvar_1.w = _glesTANGENT.w;
  vec3 tmpvar_2;
  tmpvar_2 = normalize(_glesNormal);
  highp vec4 tmpvar_3;
  highp vec3 tmpvar_4;
  highp vec3 tmpvar_5;
  tmpvar_4 = tmpvar_1.xyz;
  tmpvar_5 = (((tmpvar_2.yzx * tmpvar_1.zxy) - (tmpvar_2.zxy * tmpvar_1.yzx)) * _glesTANGENT.w);
  highp mat3 tmpvar_6;
  tmpvar_6[0].x = tmpvar_4.x;
  tmpvar_6[0].y = tmpvar_5.x;
  tmpvar_6[0].z = tmpvar_2.x;
  tmpvar_6[1].x = tmpvar_4.y;
  tmpvar_6[1].y = tmpvar_5.y;
  tmpvar_6[1].z = tmpvar_2.y;
  tmpvar_6[2].x = tmpvar_4.z;
  tmpvar_6[2].y = tmpvar_5.z;
  tmpvar_6[2].z = tmpvar_2.z;
  vec4 v_7;
  v_7.x = gl_ModelViewMatrixInverseTranspose[0].x;
  v_7.y = gl_ModelViewMatrixInverseTranspose[1].x;
  v_7.z = gl_ModelViewMatrixInverseTranspose[2].x;
  v_7.w = gl_ModelViewMatrixInverseTranspose[3].x;
  vec4 v_8;
  v_8.x = gl_ModelViewMatrixInverseTranspose[0].y;
  v_8.y = gl_ModelViewMatrixInverseTranspose[1].y;
  v_8.z = gl_ModelViewMatrixInverseTranspose[2].y;
  v_8.w = gl_ModelViewMatrixInverseTranspose[3].y;
  tmpvar_3.xy = ((_glesMultiTexCoord0.xy * _MainTex_ST.xy) + _MainTex_ST.zw);
  tmpvar_3.zw = ((_glesMultiTexCoord0.xy * _BumpMap_ST.xy) + _BumpMap_ST.zw);
  gl_Position = (gl_ModelViewProjectionMatrix * _glesVertex);
  xlv_TEXCOORD0 = tmpvar_3;
  xlv_TEXCOORD1 = (tmpvar_6 * v_7.xyz);
  xlv_TEXCOORD2 = (tmpvar_6 * v_8.xyz);
  xlv_TEXCOORD3 = ((_glesMultiTexCoord1.xy * unity_LightmapST.xy) + unity_LightmapST.zw);
  xlv_TEXCOORD4 = (unity_World2Shadow[0] * (_Object2World * _glesVertex));
}



#endif
#ifdef FRAGMENT

#extension GL_EXT_shadow_samplers : enable
varying highp vec4 xlv_TEXCOORD4;
varying highp vec2 xlv_TEXCOORD3;
varying highp vec3 xlv_TEXCOORD2;
varying highp vec3 xlv_TEXCOORD1;
varying highp vec4 xlv_TEXCOORD0;
uniform lowp float _Cutoff;
uniform sampler2D unity_LightmapInd;
uniform sampler2D unity_Lightmap;
uniform sampler2D _Shade;
uniform sampler2D _BumpMap;
uniform sampler2D _MainTex;
uniform lowp vec4 _Color;
uniform sampler2DShadow _ShadowMapTexture;
uniform highp vec4 _LightShadowData;
void main ()
{
  lowp vec4 c_1;
  lowp vec3 tmpvar_2;
  highp vec3 matcap_3;
  lowp vec3 tmpvar_4;
  tmpvar_4 = ((texture2D (_BumpMap, xlv_TEXCOORD0.zw).xyz * 2.0) - 1.0);
  lowp vec3 tmpvar_5;
  tmpvar_5 = (texture2D (_MainTex, xlv_TEXCOORD0.xy).xyz * _Color.w);
  highp vec2 tmpvar_6;
  tmpvar_6.x = dot (xlv_TEXCOORD1, tmpvar_4);
  tmpvar_6.y = dot (xlv_TEXCOORD2, tmpvar_4);
  highp vec2 P_7;
  P_7 = ((tmpvar_6 * 0.5) + 0.5);
  lowp vec3 tmpvar_8;
  tmpvar_8 = texture2D (_Shade, P_7).xyz;
  matcap_3 = tmpvar_8;
  lowp vec4 tmpvar_9;
  tmpvar_9 = texture2D (_MainTex, xlv_TEXCOORD0.xy);
  highp vec3 tmpvar_10;
  tmpvar_10 = (((matcap_3 * tmpvar_9.xyz) * _Color.xyz) * 3.0);
  tmpvar_2 = tmpvar_10;
  lowp vec4 tmpvar_11;
  tmpvar_11 = texture2D (_MainTex, xlv_TEXCOORD0.xy);
  lowp float tmpvar_12;
  tmpvar_12 = tmpvar_11.w;
  lowp float x_13;
  x_13 = (tmpvar_11.w - _Cutoff);
  if ((x_13 < 0.0)) {
    discard;
  };
  lowp float shadow_14;
  lowp float tmpvar_15;
  tmpvar_15 = shadow2DEXT (_ShadowMapTexture, xlv_TEXCOORD4.xyz);
  highp float tmpvar_16;
  tmpvar_16 = (_LightShadowData.x + (tmpvar_15 * (1.0 - _LightShadowData.x)));
  shadow_14 = tmpvar_16;
  mat3 tmpvar_17;
  tmpvar_17[0].x = 0.816497;
  tmpvar_17[0].y = -0.408248;
  tmpvar_17[0].z = -0.408248;
  tmpvar_17[1].x = 0.0;
  tmpvar_17[1].y = 0.707107;
  tmpvar_17[1].z = -0.707107;
  tmpvar_17[2].x = 0.57735;
  tmpvar_17[2].y = 0.57735;
  tmpvar_17[2].z = 0.57735;
  mediump vec3 normal_18;
  normal_18 = tmpvar_4;
  mediump vec3 scalePerBasisVector_19;
  mediump vec3 lm_20;
  lowp vec3 tmpvar_21;
  tmpvar_21 = (2.0 * texture2D (unity_Lightmap, xlv_TEXCOORD3).xyz);
  lm_20 = tmpvar_21;
  lowp vec3 tmpvar_22;
  tmpvar_22 = (2.0 * texture2D (unity_LightmapInd, xlv_TEXCOORD3).xyz);
  scalePerBasisVector_19 = tmpvar_22;
  lm_20 = (lm_20 * dot (clamp ((tmpvar_17 * normal_18), 0.0, 1.0), scalePerBasisVector_19));
  lowp vec3 tmpvar_23;
  tmpvar_23 = vec3((shadow_14 * 2.0));
  mediump vec3 tmpvar_24;
  tmpvar_24 = (tmpvar_5 * min (lm_20, tmpvar_23));
  c_1.xyz = tmpvar_24;
  c_1.w = tmpvar_12;
  c_1.xyz = (c_1.xyz + tmpvar_2);
  c_1.w = tmpvar_12;
  gl_FragData[0] = c_1;
}



#endif"
}

SubProgram "gles " {
Keywords { "DIRECTIONAL" "LIGHTMAP_OFF" "DIRLIGHTMAP_OFF" "SHADOWS_SCREEN" "SHADOWS_NATIVE" "VERTEXLIGHT_ON" }
"!!GLES
#define SHADER_API_GLES 1
#define tex2D texture2D


#ifdef VERTEX

#extension GL_EXT_shadow_samplers : enable
#define gl_ModelViewProjectionMatrix glstate_matrix_mvp
uniform mat4 glstate_matrix_mvp;
#define gl_ModelViewMatrixInverseTranspose glstate_matrix_invtrans_modelview0
uniform mat4 glstate_matrix_invtrans_modelview0;
#define gl_ModelViewMatrix glstate_matrix_modelview0
uniform mat4 glstate_matrix_modelview0;
varying highp vec4 xlv_TEXCOORD5;
varying lowp vec3 xlv_TEXCOORD4;
varying lowp vec3 xlv_TEXCOORD3;
varying highp vec3 xlv_TEXCOORD2;
varying highp vec3 xlv_TEXCOORD1;
varying highp vec4 xlv_TEXCOORD0;
uniform highp vec4 _BumpMap_ST;
uniform highp vec4 _MainTex_ST;
uniform highp vec4 unity_Scale;
uniform highp mat4 _World2Object;
uniform highp mat4 _Object2World;


uniform highp mat4 unity_World2Shadow[4];
uniform highp vec4 unity_SHC;
uniform highp vec4 unity_SHBb;
uniform highp vec4 unity_SHBg;
uniform highp vec4 unity_SHBr;
uniform highp vec4 unity_SHAb;
uniform highp vec4 unity_SHAg;
uniform highp vec4 unity_SHAr;
uniform highp vec4 unity_LightColor[4];
uniform highp vec4 unity_4LightAtten0;
uniform highp vec4 unity_4LightPosZ0;
uniform highp vec4 unity_4LightPosY0;
uniform highp vec4 unity_4LightPosX0;
uniform lowp vec4 _WorldSpaceLightPos0;
attribute vec4 _glesTANGENT;
attribute vec4 _glesMultiTexCoord0;
attribute vec3 _glesNormal;
attribute vec4 _glesVertex;
void main ()
{
  vec4 tmpvar_1;
  tmpvar_1.xyz = normalize(_glesTANGENT.xyz);
  tmpvar_1.w = _glesTANGENT.w;
  vec3 tmpvar_2;
  tmpvar_2 = normalize(_glesNormal);
  highp vec3 shlight_3;
  highp vec4 tmpvar_4;
  lowp vec3 tmpvar_5;
  lowp vec3 tmpvar_6;
  highp vec3 tmpvar_7;
  highp vec3 tmpvar_8;
  tmpvar_7 = tmpvar_1.xyz;
  tmpvar_8 = (((tmpvar_2.yzx * tmpvar_1.zxy) - (tmpvar_2.zxy * tmpvar_1.yzx)) * _glesTANGENT.w);
  highp mat3 tmpvar_9;
  tmpvar_9[0].x = tmpvar_7.x;
  tmpvar_9[0].y = tmpvar_8.x;
  tmpvar_9[0].z = tmpvar_2.x;
  tmpvar_9[1].x = tmpvar_7.y;
  tmpvar_9[1].y = tmpvar_8.y;
  tmpvar_9[1].z = tmpvar_2.y;
  tmpvar_9[2].x = tmpvar_7.z;
  tmpvar_9[2].y = tmpvar_8.z;
  tmpvar_9[2].z = tmpvar_2.z;
  vec4 v_10;
  v_10.x = gl_ModelViewMatrixInverseTranspose[0].x;
  v_10.y = gl_ModelViewMatrixInverseTranspose[1].x;
  v_10.z = gl_ModelViewMatrixInverseTranspose[2].x;
  v_10.w = gl_ModelViewMatrixInverseTranspose[3].x;
  vec4 v_11;
  v_11.x = gl_ModelViewMatrixInverseTranspose[0].y;
  v_11.y = gl_ModelViewMatrixInverseTranspose[1].y;
  v_11.z = gl_ModelViewMatrixInverseTranspose[2].y;
  v_11.w = gl_ModelViewMatrixInverseTranspose[3].y;
  tmpvar_4.xy = ((_glesMultiTexCoord0.xy * _MainTex_ST.xy) + _MainTex_ST.zw);
  tmpvar_4.zw = ((_glesMultiTexCoord0.xy * _BumpMap_ST.xy) + _BumpMap_ST.zw);
  mat3 tmpvar_12;
  tmpvar_12[0] = _Object2World[0].xyz;
  tmpvar_12[1] = _Object2World[1].xyz;
  tmpvar_12[2] = _Object2World[2].xyz;
  highp vec3 tmpvar_13;
  tmpvar_13 = (tmpvar_12 * (tmpvar_2 * unity_Scale.w));
  highp vec3 tmpvar_14;
  highp vec3 tmpvar_15;
  tmpvar_14 = tmpvar_1.xyz;
  tmpvar_15 = (((tmpvar_2.yzx * tmpvar_1.zxy) - (tmpvar_2.zxy * tmpvar_1.yzx)) * _glesTANGENT.w);
  highp mat3 tmpvar_16;
  tmpvar_16[0].x = tmpvar_14.x;
  tmpvar_16[0].y = tmpvar_15.x;
  tmpvar_16[0].z = tmpvar_2.x;
  tmpvar_16[1].x = tmpvar_14.y;
  tmpvar_16[1].y = tmpvar_15.y;
  tmpvar_16[1].z = tmpvar_2.y;
  tmpvar_16[2].x = tmpvar_14.z;
  tmpvar_16[2].y = tmpvar_15.z;
  tmpvar_16[2].z = tmpvar_2.z;
  highp vec3 tmpvar_17;
  tmpvar_17 = (tmpvar_16 * (_World2Object * _WorldSpaceLightPos0).xyz);
  tmpvar_5 = tmpvar_17;
  highp vec4 tmpvar_18;
  tmpvar_18.w = 1.0;
  tmpvar_18.xyz = tmpvar_13;
  mediump vec3 tmpvar_19;
  mediump vec4 normal_20;
  normal_20 = tmpvar_18;
  highp float vC_21;
  mediump vec3 x3_22;
  mediump vec3 x2_23;
  mediump vec3 x1_24;
  highp float tmpvar_25;
  tmpvar_25 = dot (unity_SHAr, normal_20);
  x1_24.x = tmpvar_25;
  highp float tmpvar_26;
  tmpvar_26 = dot (unity_SHAg, normal_20);
  x1_24.y = tmpvar_26;
  highp float tmpvar_27;
  tmpvar_27 = dot (unity_SHAb, normal_20);
  x1_24.z = tmpvar_27;
  mediump vec4 tmpvar_28;
  tmpvar_28 = (normal_20.xyzz * normal_20.yzzx);
  highp float tmpvar_29;
  tmpvar_29 = dot (unity_SHBr, tmpvar_28);
  x2_23.x = tmpvar_29;
  highp float tmpvar_30;
  tmpvar_30 = dot (unity_SHBg, tmpvar_28);
  x2_23.y = tmpvar_30;
  highp float tmpvar_31;
  tmpvar_31 = dot (unity_SHBb, tmpvar_28);
  x2_23.z = tmpvar_31;
  mediump float tmpvar_32;
  tmpvar_32 = ((normal_20.x * normal_20.x) - (normal_20.y * normal_20.y));
  vC_21 = tmpvar_32;
  highp vec3 tmpvar_33;
  tmpvar_33 = (unity_SHC.xyz * vC_21);
  x3_22 = tmpvar_33;
  tmpvar_19 = ((x1_24 + x2_23) + x3_22);
  shlight_3 = tmpvar_19;
  tmpvar_6 = shlight_3;
  highp vec3 tmpvar_34;
  tmpvar_34 = (_Object2World * _glesVertex).xyz;
  highp vec4 tmpvar_35;
  tmpvar_35 = (unity_4LightPosX0 - tmpvar_34.x);
  highp vec4 tmpvar_36;
  tmpvar_36 = (unity_4LightPosY0 - tmpvar_34.y);
  highp vec4 tmpvar_37;
  tmpvar_37 = (unity_4LightPosZ0 - tmpvar_34.z);
  highp vec4 tmpvar_38;
  tmpvar_38 = (((tmpvar_35 * tmpvar_35) + (tmpvar_36 * tmpvar_36)) + (tmpvar_37 * tmpvar_37));
  highp vec4 tmpvar_39;
  tmpvar_39 = (max (vec4(0.0, 0.0, 0.0, 0.0), ((((tmpvar_35 * tmpvar_13.x) + (tmpvar_36 * tmpvar_13.y)) + (tmpvar_37 * tmpvar_13.z)) * inversesqrt(tmpvar_38))) * (1.0/((1.0 + (tmpvar_38 * unity_4LightAtten0)))));
  highp vec3 tmpvar_40;
  tmpvar_40 = (tmpvar_6 + ((((unity_LightColor[0].xyz * tmpvar_39.x) + (unity_LightColor[1].xyz * tmpvar_39.y)) + (unity_LightColor[2].xyz * tmpvar_39.z)) + (unity_LightColor[3].xyz * tmpvar_39.w)));
  tmpvar_6 = tmpvar_40;
  gl_Position = (gl_ModelViewProjectionMatrix * _glesVertex);
  xlv_TEXCOORD0 = tmpvar_4;
  xlv_TEXCOORD1 = (tmpvar_9 * v_10.xyz);
  xlv_TEXCOORD2 = (tmpvar_9 * v_11.xyz);
  xlv_TEXCOORD3 = tmpvar_5;
  xlv_TEXCOORD4 = tmpvar_6;
  xlv_TEXCOORD5 = (unity_World2Shadow[0] * (_Object2World * _glesVertex));
}



#endif
#ifdef FRAGMENT

#extension GL_EXT_shadow_samplers : enable
varying highp vec4 xlv_TEXCOORD5;
varying lowp vec3 xlv_TEXCOORD4;
varying lowp vec3 xlv_TEXCOORD3;
varying highp vec3 xlv_TEXCOORD2;
varying highp vec3 xlv_TEXCOORD1;
varying highp vec4 xlv_TEXCOORD0;
uniform lowp float _Cutoff;
uniform sampler2D _Shade;
uniform sampler2D _BumpMap;
uniform sampler2D _MainTex;
uniform lowp vec4 _Color;
uniform sampler2DShadow _ShadowMapTexture;
uniform lowp vec4 _LightColor0;
uniform highp vec4 _LightShadowData;
void main ()
{
  lowp vec4 c_1;
  lowp vec3 tmpvar_2;
  highp vec3 matcap_3;
  lowp vec3 tmpvar_4;
  tmpvar_4 = ((texture2D (_BumpMap, xlv_TEXCOORD0.zw).xyz * 2.0) - 1.0);
  lowp vec3 tmpvar_5;
  tmpvar_5 = (texture2D (_MainTex, xlv_TEXCOORD0.xy).xyz * _Color.w);
  highp vec2 tmpvar_6;
  tmpvar_6.x = dot (xlv_TEXCOORD1, tmpvar_4);
  tmpvar_6.y = dot (xlv_TEXCOORD2, tmpvar_4);
  highp vec2 P_7;
  P_7 = ((tmpvar_6 * 0.5) + 0.5);
  lowp vec3 tmpvar_8;
  tmpvar_8 = texture2D (_Shade, P_7).xyz;
  matcap_3 = tmpvar_8;
  lowp vec4 tmpvar_9;
  tmpvar_9 = texture2D (_MainTex, xlv_TEXCOORD0.xy);
  highp vec3 tmpvar_10;
  tmpvar_10 = (((matcap_3 * tmpvar_9.xyz) * _Color.xyz) * 3.0);
  tmpvar_2 = tmpvar_10;
  lowp vec4 tmpvar_11;
  tmpvar_11 = texture2D (_MainTex, xlv_TEXCOORD0.xy);
  lowp float tmpvar_12;
  tmpvar_12 = tmpvar_11.w;
  lowp float x_13;
  x_13 = (tmpvar_11.w - _Cutoff);
  if ((x_13 < 0.0)) {
    discard;
  };
  lowp float shadow_14;
  lowp float tmpvar_15;
  tmpvar_15 = shadow2DEXT (_ShadowMapTexture, xlv_TEXCOORD5.xyz);
  highp float tmpvar_16;
  tmpvar_16 = (_LightShadowData.x + (tmpvar_15 * (1.0 - _LightShadowData.x)));
  shadow_14 = tmpvar_16;
  lowp vec4 c_17;
  c_17.xyz = ((tmpvar_5 * _LightColor0.xyz) * ((max (0.0, dot (tmpvar_4, xlv_TEXCOORD3)) * shadow_14) * 2.0));
  c_17.w = tmpvar_12;
  c_1.w = c_17.w;
  c_1.xyz = (c_17.xyz + (tmpvar_5 * xlv_TEXCOORD4));
  c_1.xyz = (c_1.xyz + tmpvar_2);
  c_1.w = tmpvar_12;
  gl_FragData[0] = c_1;
}



#endif"
}

}
Program "fp" {
// Fragment combos: 6
//   opengl - ALU: 23 to 37, TEX: 3 to 6
//   d3d9 - ALU: 24 to 36, TEX: 4 to 7
//   d3d11 - ALU: 11 to 24, TEX: 3 to 6, FLOW: 1 to 1
//   d3d11_9x - ALU: 11 to 18, TEX: 3 to 5, FLOW: 1 to 1
SubProgram "opengl " {
Keywords { "DIRECTIONAL" "LIGHTMAP_OFF" "DIRLIGHTMAP_OFF" "SHADOWS_OFF" }
Vector 0 [_LightColor0]
Vector 1 [_Color]
Float 2 [_Cutoff]
SetTexture 0 [_BumpMap] 2D
SetTexture 1 [_MainTex] 2D
SetTexture 2 [_Shade] 2D
"!!ARBfp1.0
OPTION ARB_precision_hint_fastest;
# 26 ALU, 3 TEX
PARAM c[5] = { program.local[0..2],
		{ 2, 1, 0, 0.5 },
		{ 3 } };
TEMP R0;
TEMP R1;
TEMP R2;
TEMP R3;
TEX R0, fragment.texcoord[0], texture[1], 2D;
TEX R1.yw, fragment.texcoord[0].zwzw, texture[0], 2D;
MAD R1.xy, R1.wyzw, c[3].x, -c[3].y;
MUL R1.z, R1.y, R1.y;
MAD R1.z, -R1.x, R1.x, -R1;
ADD R1.z, R1, c[3].y;
RSQ R1.z, R1.z;
RCP R1.z, R1.z;
SLT R1.w, R0, c[2].x;
DP3 R2.y, R1, fragment.texcoord[2];
DP3 R2.x, R1, fragment.texcoord[1];
MAD R2.xy, R2, c[3].w, c[3].w;
DP3 R1.x, R1, fragment.texcoord[3];
MAX R1.x, R1, c[3].z;
MOV result.color.w, R0;
TEX R2.xyz, R2, texture[2], 2D;
KIL -R1.w;
MUL R2.xyz, R0, R2;
MUL R2.xyz, R2, c[1];
MUL R0.xyz, R0, c[1].w;
MUL R3.xyz, R2, c[4].x;
MUL R2.xyz, R0, fragment.texcoord[4];
MUL R0.xyz, R0, c[0];
MUL R0.xyz, R1.x, R0;
MAD R0.xyz, R0, c[3].x, R2;
ADD result.color.xyz, R0, R3;
END
# 26 instructions, 4 R-regs
"
}

SubProgram "d3d9 " {
Keywords { "DIRECTIONAL" "LIGHTMAP_OFF" "DIRLIGHTMAP_OFF" "SHADOWS_OFF" }
Vector 0 [_LightColor0]
Vector 1 [_Color]
Float 2 [_Cutoff]
SetTexture 0 [_BumpMap] 2D
SetTexture 1 [_MainTex] 2D
SetTexture 2 [_Shade] 2D
"ps_2_0
; 28 ALU, 4 TEX
dcl_2d s0
dcl_2d s1
dcl_2d s2
def c3, 0.00000000, 1.00000000, 2.00000000, -1.00000000
def c4, 0.50000000, 3.00000000, 0, 0
dcl t0
dcl t1.xyz
dcl t2.xyz
dcl t3.xyz
dcl t4.xyz
texld r1, t0, s1
mov r0.y, t0.w
mov r0.x, t0.z
texld r0, r0, s0
mov r0.x, r0.w
mad_pp r2.xy, r0, c3.z, c3.w
mul_pp r0.x, r2.y, r2.y
mad_pp r0.x, -r2, r2, -r0
add_pp r0.x, r0, c3.y
rsq_pp r0.x, r0.x
rcp_pp r2.z, r0.x
add_pp r0.x, r1.w, -c2
cmp r0.x, r0, c3, c3.y
mov_pp r0, -r0.x
dp3 r3.x, r2, t1
dp3 r3.y, r2, t2
dp3_pp r2.x, r2, t3
mad_pp r3.xy, r3, c4.x, c4.x
max_pp r2.x, r2, c3
texkill r0.xyzw
texld r3, r3, s2
mul r0.xyz, r1, r3
mul r1.xyz, r1, c1.w
mul_pp r3.xyz, r1, c0
mul r0.xyz, r0, c1
mul r0.xyz, r0, c4.y
mul_pp r1.xyz, r1, t4
mul_pp r2.xyz, r2.x, r3
mad_pp r1.xyz, r2, c3.z, r1
add_pp r0.xyz, r1, r0
mov_pp r0.w, r1
mov_pp oC0, r0
"
}

SubProgram "d3d11 " {
Keywords { "DIRECTIONAL" "LIGHTMAP_OFF" "DIRLIGHTMAP_OFF" "SHADOWS_OFF" }
ConstBuffer "$Globals" 112 // 100 used size, 7 vars
Vector 16 [_LightColor0] 4
Vector 48 [_Color] 4
Float 96 [_Cutoff]
BindCB "$Globals" 0
SetTexture 0 [_BumpMap] 2D 1
SetTexture 1 [_MainTex] 2D 0
SetTexture 2 [_Shade] 2D 2
// 25 instructions, 3 temp regs, 0 temp arrays:
// ALU 13 float, 0 int, 0 uint
// TEX 3 (0 load, 0 comp, 0 bias, 0 grad)
// FLOW 1 static, 0 dynamic
"ps_4_0
eefiecedpddhdafmgegookdhlkenhpheinlbdggpabaaaaaaaaafaaaaadaaaaaa
cmaaaaaaoeaaaaaabiabaaaaejfdeheolaaaaaaaagaaaaaaaiaaaaaajiaaaaaa
aaaaaaaaabaaaaaaadaaaaaaaaaaaaaaapaaaaaakeaaaaaaaaaaaaaaaaaaaaaa
adaaaaaaabaaaaaaapapaaaakeaaaaaaabaaaaaaaaaaaaaaadaaaaaaacaaaaaa
ahahaaaakeaaaaaaacaaaaaaaaaaaaaaadaaaaaaadaaaaaaahahaaaakeaaaaaa
adaaaaaaaaaaaaaaadaaaaaaaeaaaaaaahahaaaakeaaaaaaaeaaaaaaaaaaaaaa
adaaaaaaafaaaaaaahahaaaafdfgfpfaepfdejfeejepeoaafeeffiedepepfcee
aaklklklepfdeheocmaaaaaaabaaaaaaaiaaaaaacaaaaaaaaaaaaaaaaaaaaaaa
adaaaaaaaaaaaaaaapaaaaaafdfgfpfegbhcghgfheaaklklfdeieefcoaadaaaa
eaaaaaaapiaaaaaafjaaaaaeegiocaaaaaaaaaaaahaaaaaafkaaaaadaagabaaa
aaaaaaaafkaaaaadaagabaaaabaaaaaafkaaaaadaagabaaaacaaaaaafibiaaae
aahabaaaaaaaaaaaffffaaaafibiaaaeaahabaaaabaaaaaaffffaaaafibiaaae
aahabaaaacaaaaaaffffaaaagcbaaaadpcbabaaaabaaaaaagcbaaaadhcbabaaa
acaaaaaagcbaaaadhcbabaaaadaaaaaagcbaaaadhcbabaaaaeaaaaaagcbaaaad
hcbabaaaafaaaaaagfaaaaadpccabaaaaaaaaaaagiaaaaacadaaaaaaefaaaaaj
pcaabaaaaaaaaaaaegbabaaaabaaaaaaeghobaaaabaaaaaaaagabaaaaaaaaaaa
aaaaaaajbcaabaaaabaaaaaadkaabaaaaaaaaaaaakiacaiaebaaaaaaaaaaaaaa
agaaaaaadbaaaaahbcaabaaaabaaaaaaakaabaaaabaaaaaaabeaaaaaaaaaaaaa
anaaaeadakaabaaaabaaaaaaefaaaaajpcaabaaaabaaaaaaogbkbaaaabaaaaaa
eghobaaaaaaaaaaaaagabaaaabaaaaaadcaaaaapdcaabaaaabaaaaaahgapbaaa
abaaaaaaaceaaaaaaaaaaaeaaaaaaaeaaaaaaaaaaaaaaaaaaceaaaaaaaaaialp
aaaaialpaaaaaaaaaaaaaaaadcaaaaakicaabaaaabaaaaaaakaabaiaebaaaaaa
abaaaaaaakaabaaaabaaaaaaabeaaaaaaaaaiadpdcaaaaakicaabaaaabaaaaaa
bkaabaiaebaaaaaaabaaaaaabkaabaaaabaaaaaadkaabaaaabaaaaaaelaaaaaf
ecaabaaaabaaaaaadkaabaaaabaaaaaabaaaaaahbcaabaaaacaaaaaaegbcbaaa
acaaaaaaegacbaaaabaaaaaabaaaaaahccaabaaaacaaaaaaegbcbaaaadaaaaaa
egacbaaaabaaaaaabaaaaaahbcaabaaaabaaaaaaegacbaaaabaaaaaaegbcbaaa
aeaaaaaadeaaaaahbcaabaaaabaaaaaaakaabaaaabaaaaaaabeaaaaaaaaaaaaa
aaaaaaahbcaabaaaabaaaaaaakaabaaaabaaaaaaakaabaaaabaaaaaadcaaaaap
gcaabaaaabaaaaaaagabbaaaacaaaaaaaceaaaaaaaaaaaaaaaaaaadpaaaaaadp
aaaaaaaaaceaaaaaaaaaaaaaaaaaaadpaaaaaadpaaaaaaaaefaaaaajpcaabaaa
acaaaaaajgafbaaaabaaaaaaeghobaaaacaaaaaaaagabaaaacaaaaaadiaaaaah
ocaabaaaabaaaaaaagajbaaaaaaaaaaaagajbaaaacaaaaaadiaaaaaiocaabaaa
abaaaaaafgaobaaaabaaaaaaagijcaaaaaaaaaaaadaaaaaadiaaaaaihcaabaaa
aaaaaaaaegacbaaaaaaaaaaapgipcaaaaaaaaaaaadaaaaaadgaaaaaficcabaaa
aaaaaaaadkaabaaaaaaaaaaadiaaaaaihcaabaaaacaaaaaaegacbaaaaaaaaaaa
egiccaaaaaaaaaaaabaaaaaadiaaaaahhcaabaaaaaaaaaaaegacbaaaaaaaaaaa
egbcbaaaafaaaaaadcaaaaajhcaabaaaaaaaaaaaegacbaaaacaaaaaaagaabaaa
abaaaaaaegacbaaaaaaaaaaadcaaaaamhccabaaaaaaaaaaajgahbaaaabaaaaaa
aceaaaaaaaaaeaeaaaaaeaeaaaaaeaeaaaaaaaaaegacbaaaaaaaaaaadoaaaaab
"
}

SubProgram "gles " {
Keywords { "DIRECTIONAL" "LIGHTMAP_OFF" "DIRLIGHTMAP_OFF" "SHADOWS_OFF" }
"!!GLES"
}

SubProgram "glesdesktop " {
Keywords { "DIRECTIONAL" "LIGHTMAP_OFF" "DIRLIGHTMAP_OFF" "SHADOWS_OFF" }
"!!GLES"
}

SubProgram "flash " {
Keywords { "DIRECTIONAL" "LIGHTMAP_OFF" "DIRLIGHTMAP_OFF" "SHADOWS_OFF" }
Vector 0 [_LightColor0]
Vector 1 [_Color]
Float 2 [_Cutoff]
SetTexture 0 [_BumpMap] 2D
SetTexture 1 [_MainTex] 2D
SetTexture 2 [_Shade] 2D
"agal_ps
c3 0.0 1.0 2.0 -1.0
c4 0.5 3.0 0.0 0.0
[bc]
ciaaaaaaabaaapacaaaaaaoeaeaaaaaaabaaaaaaafaababb tex r1, v0, s1 <2d wrap linear point>
aaaaaaaaaaaaacacaaaaaappaeaaaaaaaaaaaaaaaaaaaaaa mov r0.y, v0.w
aaaaaaaaaaaaabacaaaaaakkaeaaaaaaaaaaaaaaaaaaaaaa mov r0.x, v0.z
ciaaaaaaaaaaapacaaaaaafeacaaaaaaaaaaaaaaafaababb tex r0, r0.xyyy, s0 <2d wrap linear point>
aaaaaaaaaaaaabacaaaaaappacaaaaaaaaaaaaaaaaaaaaaa mov r0.x, r0.w
adaaaaaaacaaadacaaaaaafeacaaaaaaadaaaakkabaaaaaa mul r2.xy, r0.xyyy, c3.z
abaaaaaaacaaadacacaaaafeacaaaaaaadaaaappabaaaaaa add r2.xy, r2.xyyy, c3.w
adaaaaaaaaaaabacacaaaaffacaaaaaaacaaaaffacaaaaaa mul r0.x, r2.y, r2.y
bfaaaaaaacaaaiacacaaaaaaacaaaaaaaaaaaaaaaaaaaaaa neg r2.w, r2.x
adaaaaaaacaaaiacacaaaappacaaaaaaacaaaaaaacaaaaaa mul r2.w, r2.w, r2.x
acaaaaaaaaaaabacacaaaappacaaaaaaaaaaaaaaacaaaaaa sub r0.x, r2.w, r0.x
abaaaaaaaaaaabacaaaaaaaaacaaaaaaadaaaaffabaaaaaa add r0.x, r0.x, c3.y
akaaaaaaaaaaabacaaaaaaaaacaaaaaaaaaaaaaaaaaaaaaa rsq r0.x, r0.x
afaaaaaaacaaaeacaaaaaaaaacaaaaaaaaaaaaaaaaaaaaaa rcp r2.z, r0.x
acaaaaaaaaaaabacabaaaappacaaaaaaacaaaaoeabaaaaaa sub r0.x, r1.w, c2
ckaaaaaaaaaaabacaaaaaaaaacaaaaaaaeaaaakkabaaaaaa slt r0.x, r0.x, c4.z
bfaaaaaaaaaaapacaaaaaaaaacaaaaaaaaaaaaaaaaaaaaaa neg r0, r0.x
bcaaaaaaadaaabacacaaaakeacaaaaaaabaaaaoeaeaaaaaa dp3 r3.x, r2.xyzz, v1
bcaaaaaaadaaacacacaaaakeacaaaaaaacaaaaoeaeaaaaaa dp3 r3.y, r2.xyzz, v2
bcaaaaaaacaaabacacaaaakeacaaaaaaadaaaaoeaeaaaaaa dp3 r2.x, r2.xyzz, v3
adaaaaaaadaaadacadaaaafeacaaaaaaaeaaaaaaabaaaaaa mul r3.xy, r3.xyyy, c4.x
abaaaaaaadaaadacadaaaafeacaaaaaaaeaaaaaaabaaaaaa add r3.xy, r3.xyyy, c4.x
ahaaaaaaacaaabacacaaaaaaacaaaaaaadaaaaoeabaaaaaa max r2.x, r2.x, c3
chaaaaaaaaaaaaaaaaaaaaaaacaaaaaaaaaaaaaaaaaaaaaa kil a0.none, r0.x
ciaaaaaaadaaapacadaaaafeacaaaaaaacaaaaaaafaababb tex r3, r3.xyyy, s2 <2d wrap linear point>
adaaaaaaaaaaahacabaaaakeacaaaaaaadaaaakeacaaaaaa mul r0.xyz, r1.xyzz, r3.xyzz
adaaaaaaabaaahacabaaaakeacaaaaaaabaaaappabaaaaaa mul r1.xyz, r1.xyzz, c1.w
adaaaaaaadaaahacabaaaakeacaaaaaaaaaaaaoeabaaaaaa mul r3.xyz, r1.xyzz, c0
adaaaaaaaaaaahacaaaaaakeacaaaaaaabaaaaoeabaaaaaa mul r0.xyz, r0.xyzz, c1
adaaaaaaaaaaahacaaaaaakeacaaaaaaaeaaaaffabaaaaaa mul r0.xyz, r0.xyzz, c4.y
adaaaaaaabaaahacabaaaakeacaaaaaaaeaaaaoeaeaaaaaa mul r1.xyz, r1.xyzz, v4
adaaaaaaacaaahacacaaaaaaacaaaaaaadaaaakeacaaaaaa mul r2.xyz, r2.x, r3.xyzz
adaaaaaaacaaahacacaaaakeacaaaaaaadaaaakkabaaaaaa mul r2.xyz, r2.xyzz, c3.z
abaaaaaaabaaahacacaaaakeacaaaaaaabaaaakeacaaaaaa add r1.xyz, r2.xyzz, r1.xyzz
abaaaaaaaaaaahacabaaaakeacaaaaaaaaaaaakeacaaaaaa add r0.xyz, r1.xyzz, r0.xyzz
aaaaaaaaaaaaaiacabaaaappacaaaaaaaaaaaaaaaaaaaaaa mov r0.w, r1.w
aaaaaaaaaaaaapadaaaaaaoeacaaaaaaaaaaaaaaaaaaaaaa mov o0, r0
"
}

SubProgram "d3d11_9x " {
Keywords { "DIRECTIONAL" "LIGHTMAP_OFF" "DIRLIGHTMAP_OFF" "SHADOWS_OFF" }
ConstBuffer "$Globals" 112 // 100 used size, 7 vars
Vector 16 [_LightColor0] 4
Vector 48 [_Color] 4
Float 96 [_Cutoff]
BindCB "$Globals" 0
SetTexture 0 [_BumpMap] 2D 1
SetTexture 1 [_MainTex] 2D 0
SetTexture 2 [_Shade] 2D 2
// 25 instructions, 3 temp regs, 0 temp arrays:
// ALU 13 float, 0 int, 0 uint
// TEX 3 (0 load, 0 comp, 0 bias, 0 grad)
// FLOW 1 static, 0 dynamic
"ps_4_0_level_9_3
eefiecedhiiocckenedgichlpegelfchphmnoggpabaaaaaaiiahaaaaaeaaaaaa
daaaaaaaleacaaaajmagaaaafeahaaaaebgpgodjhmacaaaahmacaaaaaaacpppp
ciacaaaafeaaaaaaadaadaaaaaaafeaaaaaafeaaadaaceaaaaaafeaaabaaaaaa
aaababaaacacacaaaaaaabaaabaaaaaaaaaaaaaaaaaaadaaabaaabaaaaaaaaaa
aaaaagaaabaaacaaaaaaaaaaabacppppfbaaaaafadaaapkaaaaaaaeaaaaaialp
aaaaiadpaaaaaadpfbaaaaafaeaaapkaaaaaaaaaaaaaeaeaaaaaaaaaaaaaaaaa
bpaaaaacaaaaaaiaaaaaaplabpaaaaacaaaaaaiaabaaahlabpaaaaacaaaaaaia
acaaahlabpaaaaacaaaaaaiaadaachlabpaaaaacaaaaaaiaaeaachlabpaaaaac
aaaaaajaaaaiapkabpaaaaacaaaaaajaabaiapkabpaaaaacaaaaaajaacaiapka
abaaaaacaaaaadiaaaaaoolaecaaaaadabaaapiaaaaaoelaaaaioekaecaaaaad
aaaacpiaaaaaoeiaabaioekaacaaaaadacaacpiaabaappiaacaaaakbaeaaaaae
aaaacdiaaaaaohiaadaaaakaadaaffkaaeaaaaaeaaaaciiaaaaaaaiaaaaaaaib
adaakkkaaeaaaaaeaaaaciiaaaaaffiaaaaaffibaaaappiaahaaaaacaaaaciia
aaaappiaagaaaaacaaaaceiaaaaappiaaiaaaaadadaacbiaabaaoelaaaaaoeia
aiaaaaadadaacciaacaaoelaaaaaoeiaaeaaaaaeadaacdiaadaaoeiaadaappka
adaappkaebaaaaabacaaapiaecaaaaadacaaapiaadaaoeiaacaioekaaiaaaaad
acaaciiaaaaaoeiaadaaoelaalaaaaadaaaacbiaacaappiaaeaaaakaacaaaaad
acaaciiaaaaaaaiaaaaaaaiaafaaaaadaaaaahiaabaaoeiaacaaoeiaafaaaaad
aaaaahiaaaaaoeiaabaaoekaafaaaaadacaachiaabaaoeiaabaappkaafaaaaad
adaachiaacaaoeiaaaaaoekaafaaaaadacaachiaacaaoeiaaeaaoelaaeaaaaae
acaachiaadaaoeiaacaappiaacaaoeiaaeaaaaaeabaachiaaaaaoeiaaeaaffka
acaaoeiaabaaaaacaaaicpiaabaaoeiappppaaaafdeieefcoaadaaaaeaaaaaaa
piaaaaaafjaaaaaeegiocaaaaaaaaaaaahaaaaaafkaaaaadaagabaaaaaaaaaaa
fkaaaaadaagabaaaabaaaaaafkaaaaadaagabaaaacaaaaaafibiaaaeaahabaaa
aaaaaaaaffffaaaafibiaaaeaahabaaaabaaaaaaffffaaaafibiaaaeaahabaaa
acaaaaaaffffaaaagcbaaaadpcbabaaaabaaaaaagcbaaaadhcbabaaaacaaaaaa
gcbaaaadhcbabaaaadaaaaaagcbaaaadhcbabaaaaeaaaaaagcbaaaadhcbabaaa
afaaaaaagfaaaaadpccabaaaaaaaaaaagiaaaaacadaaaaaaefaaaaajpcaabaaa
aaaaaaaaegbabaaaabaaaaaaeghobaaaabaaaaaaaagabaaaaaaaaaaaaaaaaaaj
bcaabaaaabaaaaaadkaabaaaaaaaaaaaakiacaiaebaaaaaaaaaaaaaaagaaaaaa
dbaaaaahbcaabaaaabaaaaaaakaabaaaabaaaaaaabeaaaaaaaaaaaaaanaaaead
akaabaaaabaaaaaaefaaaaajpcaabaaaabaaaaaaogbkbaaaabaaaaaaeghobaaa
aaaaaaaaaagabaaaabaaaaaadcaaaaapdcaabaaaabaaaaaahgapbaaaabaaaaaa
aceaaaaaaaaaaaeaaaaaaaeaaaaaaaaaaaaaaaaaaceaaaaaaaaaialpaaaaialp
aaaaaaaaaaaaaaaadcaaaaakicaabaaaabaaaaaaakaabaiaebaaaaaaabaaaaaa
akaabaaaabaaaaaaabeaaaaaaaaaiadpdcaaaaakicaabaaaabaaaaaabkaabaia
ebaaaaaaabaaaaaabkaabaaaabaaaaaadkaabaaaabaaaaaaelaaaaafecaabaaa
abaaaaaadkaabaaaabaaaaaabaaaaaahbcaabaaaacaaaaaaegbcbaaaacaaaaaa
egacbaaaabaaaaaabaaaaaahccaabaaaacaaaaaaegbcbaaaadaaaaaaegacbaaa
abaaaaaabaaaaaahbcaabaaaabaaaaaaegacbaaaabaaaaaaegbcbaaaaeaaaaaa
deaaaaahbcaabaaaabaaaaaaakaabaaaabaaaaaaabeaaaaaaaaaaaaaaaaaaaah
bcaabaaaabaaaaaaakaabaaaabaaaaaaakaabaaaabaaaaaadcaaaaapgcaabaaa
abaaaaaaagabbaaaacaaaaaaaceaaaaaaaaaaaaaaaaaaadpaaaaaadpaaaaaaaa
aceaaaaaaaaaaaaaaaaaaadpaaaaaadpaaaaaaaaefaaaaajpcaabaaaacaaaaaa
jgafbaaaabaaaaaaeghobaaaacaaaaaaaagabaaaacaaaaaadiaaaaahocaabaaa
abaaaaaaagajbaaaaaaaaaaaagajbaaaacaaaaaadiaaaaaiocaabaaaabaaaaaa
fgaobaaaabaaaaaaagijcaaaaaaaaaaaadaaaaaadiaaaaaihcaabaaaaaaaaaaa
egacbaaaaaaaaaaapgipcaaaaaaaaaaaadaaaaaadgaaaaaficcabaaaaaaaaaaa
dkaabaaaaaaaaaaadiaaaaaihcaabaaaacaaaaaaegacbaaaaaaaaaaaegiccaaa
aaaaaaaaabaaaaaadiaaaaahhcaabaaaaaaaaaaaegacbaaaaaaaaaaaegbcbaaa
afaaaaaadcaaaaajhcaabaaaaaaaaaaaegacbaaaacaaaaaaagaabaaaabaaaaaa
egacbaaaaaaaaaaadcaaaaamhccabaaaaaaaaaaajgahbaaaabaaaaaaaceaaaaa
aaaaeaeaaaaaeaeaaaaaeaeaaaaaaaaaegacbaaaaaaaaaaadoaaaaabejfdeheo
laaaaaaaagaaaaaaaiaaaaaajiaaaaaaaaaaaaaaabaaaaaaadaaaaaaaaaaaaaa
apaaaaaakeaaaaaaaaaaaaaaaaaaaaaaadaaaaaaabaaaaaaapapaaaakeaaaaaa
abaaaaaaaaaaaaaaadaaaaaaacaaaaaaahahaaaakeaaaaaaacaaaaaaaaaaaaaa
adaaaaaaadaaaaaaahahaaaakeaaaaaaadaaaaaaaaaaaaaaadaaaaaaaeaaaaaa
ahahaaaakeaaaaaaaeaaaaaaaaaaaaaaadaaaaaaafaaaaaaahahaaaafdfgfpfa
epfdejfeejepeoaafeeffiedepepfceeaaklklklepfdeheocmaaaaaaabaaaaaa
aiaaaaaacaaaaaaaaaaaaaaaaaaaaaaaadaaaaaaaaaaaaaaapaaaaaafdfgfpfe
gbhcghgfheaaklkl"
}

SubProgram "opengl " {
Keywords { "DIRECTIONAL" "LIGHTMAP_ON" "DIRLIGHTMAP_OFF" "SHADOWS_OFF" }
Vector 0 [_Color]
Float 1 [_Cutoff]
SetTexture 0 [_BumpMap] 2D
SetTexture 1 [_MainTex] 2D
SetTexture 2 [_Shade] 2D
SetTexture 3 [unity_Lightmap] 2D
"!!ARBfp1.0
OPTION ARB_precision_hint_fastest;
# 23 ALU, 4 TEX
PARAM c[4] = { program.local[0..1],
		{ 8, 2, 1, 0.5 },
		{ 3 } };
TEMP R0;
TEMP R1;
TEMP R2;
TEX R1, fragment.texcoord[0], texture[1], 2D;
TEX R0.yw, fragment.texcoord[0].zwzw, texture[0], 2D;
MAD R0.xy, R0.wyzw, c[2].y, -c[2].z;
MUL R0.z, R0.y, R0.y;
MAD R0.z, -R0.x, R0.x, -R0;
SLT R2.x, R1.w, c[1];
ADD R0.z, R0, c[2];
RSQ R0.z, R0.z;
RCP R0.z, R0.z;
DP3 R0.w, R0, fragment.texcoord[2];
DP3 R0.z, fragment.texcoord[1], R0;
MAD R0.xy, R0.zwzw, c[2].w, c[2].w;
MOV result.color.w, R1;
KIL -R2.x;
TEX R2.xyz, R0, texture[2], 2D;
TEX R0, fragment.texcoord[3], texture[3], 2D;
MUL R2.xyz, R1, R2;
MUL R2.xyz, R2, c[0];
MUL R2.xyz, R2, c[3].x;
MUL R1.xyz, R1, c[0].w;
MUL R0.xyz, R0.w, R0;
MUL R0.xyz, R0, R1;
MAD result.color.xyz, R0, c[2].x, R2;
END
# 23 instructions, 3 R-regs
"
}

SubProgram "d3d9 " {
Keywords { "DIRECTIONAL" "LIGHTMAP_ON" "DIRLIGHTMAP_OFF" "SHADOWS_OFF" }
Vector 0 [_Color]
Float 1 [_Cutoff]
SetTexture 0 [_BumpMap] 2D
SetTexture 1 [_MainTex] 2D
SetTexture 2 [_Shade] 2D
SetTexture 3 [unity_Lightmap] 2D
"ps_2_0
; 24 ALU, 5 TEX
dcl_2d s0
dcl_2d s1
dcl_2d s2
dcl_2d s3
def c2, 0.00000000, 1.00000000, 2.00000000, -1.00000000
def c3, 0.50000000, 3.00000000, 8.00000000, 0
dcl t0
dcl t1.xyz
dcl t2.xyz
dcl t3.xy
texld r1, t0, s1
mov r0.y, t0.w
mov r0.x, t0.z
texld r0, r0, s0
mov r0.x, r0.w
mad_pp r2.xy, r0, c2.z, c2.w
mul_pp r0.x, r2.y, r2.y
mad_pp r0.x, -r2, r2, -r0
add_pp r0.x, r0, c2.y
rsq_pp r0.x, r0.x
rcp_pp r2.z, r0.x
add_pp r0.x, r1.w, -c1
dp3 r3.x, t1, r2
dp3 r3.y, r2, t2
cmp r0.x, r0, c2, c2.y
mov_pp r2, -r0.x
mad_pp r3.xy, r3, c3.x, c3.x
texld r0, r3, s2
texkill r2.xyzw
texld r2, t3, s3
mul r0.xyz, r1, r0
mul r0.xyz, r0, c0
mul r0.xyz, r0, c3.y
mul r1.xyz, r1, c0.w
mul_pp r2.xyz, r2.w, r2
mul_pp r1.xyz, r2, r1
mad_pp r0.xyz, r1, c3.z, r0
mov_pp r0.w, r1
mov_pp oC0, r0
"
}

SubProgram "d3d11 " {
Keywords { "DIRECTIONAL" "LIGHTMAP_ON" "DIRLIGHTMAP_OFF" "SHADOWS_OFF" }
ConstBuffer "$Globals" 128 // 116 used size, 8 vars
Vector 48 [_Color] 4
Float 112 [_Cutoff]
BindCB "$Globals" 0
SetTexture 0 [_BumpMap] 2D 1
SetTexture 1 [_MainTex] 2D 0
SetTexture 2 [_Shade] 2D 2
SetTexture 3 [unity_Lightmap] 2D 3
// 23 instructions, 3 temp regs, 0 temp arrays:
// ALU 11 float, 0 int, 0 uint
// TEX 4 (0 load, 0 comp, 0 bias, 0 grad)
// FLOW 1 static, 0 dynamic
"ps_4_0
eefiecedbibjpnhkcbjpmdfbccnhhcookehdkiddabaaaaaalmaeaaaaadaaaaaa
cmaaaaaammaaaaaaaaabaaaaejfdeheojiaaaaaaafaaaaaaaiaaaaaaiaaaaaaa
aaaaaaaaabaaaaaaadaaaaaaaaaaaaaaapaaaaaaimaaaaaaaaaaaaaaaaaaaaaa
adaaaaaaabaaaaaaapapaaaaimaaaaaaabaaaaaaaaaaaaaaadaaaaaaacaaaaaa
ahahaaaaimaaaaaaacaaaaaaaaaaaaaaadaaaaaaadaaaaaaahahaaaaimaaaaaa
adaaaaaaaaaaaaaaadaaaaaaaeaaaaaaadadaaaafdfgfpfaepfdejfeejepeoaa
feeffiedepepfceeaaklklklepfdeheocmaaaaaaabaaaaaaaiaaaaaacaaaaaaa
aaaaaaaaaaaaaaaaadaaaaaaaaaaaaaaapaaaaaafdfgfpfegbhcghgfheaaklkl
fdeieefcleadaaaaeaaaaaaaonaaaaaafjaaaaaeegiocaaaaaaaaaaaaiaaaaaa
fkaaaaadaagabaaaaaaaaaaafkaaaaadaagabaaaabaaaaaafkaaaaadaagabaaa
acaaaaaafkaaaaadaagabaaaadaaaaaafibiaaaeaahabaaaaaaaaaaaffffaaaa
fibiaaaeaahabaaaabaaaaaaffffaaaafibiaaaeaahabaaaacaaaaaaffffaaaa
fibiaaaeaahabaaaadaaaaaaffffaaaagcbaaaadpcbabaaaabaaaaaagcbaaaad
hcbabaaaacaaaaaagcbaaaadhcbabaaaadaaaaaagcbaaaaddcbabaaaaeaaaaaa
gfaaaaadpccabaaaaaaaaaaagiaaaaacadaaaaaaefaaaaajpcaabaaaaaaaaaaa
egbabaaaabaaaaaaeghobaaaabaaaaaaaagabaaaaaaaaaaaaaaaaaajbcaabaaa
abaaaaaadkaabaaaaaaaaaaaakiacaiaebaaaaaaaaaaaaaaahaaaaaadbaaaaah
bcaabaaaabaaaaaaakaabaaaabaaaaaaabeaaaaaaaaaaaaaanaaaeadakaabaaa
abaaaaaaefaaaaajpcaabaaaabaaaaaaogbkbaaaabaaaaaaeghobaaaaaaaaaaa
aagabaaaabaaaaaadcaaaaapdcaabaaaabaaaaaahgapbaaaabaaaaaaaceaaaaa
aaaaaaeaaaaaaaeaaaaaaaaaaaaaaaaaaceaaaaaaaaaialpaaaaialpaaaaaaaa
aaaaaaaadcaaaaakicaabaaaabaaaaaaakaabaiaebaaaaaaabaaaaaaakaabaaa
abaaaaaaabeaaaaaaaaaiadpdcaaaaakicaabaaaabaaaaaabkaabaiaebaaaaaa
abaaaaaabkaabaaaabaaaaaadkaabaaaabaaaaaaelaaaaafecaabaaaabaaaaaa
dkaabaaaabaaaaaabaaaaaahbcaabaaaacaaaaaaegbcbaaaacaaaaaaegacbaaa
abaaaaaabaaaaaahccaabaaaacaaaaaaegbcbaaaadaaaaaaegacbaaaabaaaaaa
dcaaaaapdcaabaaaabaaaaaaegaabaaaacaaaaaaaceaaaaaaaaaaadpaaaaaadp
aaaaaaaaaaaaaaaaaceaaaaaaaaaaadpaaaaaadpaaaaaaaaaaaaaaaaefaaaaaj
pcaabaaaabaaaaaaegaabaaaabaaaaaaeghobaaaacaaaaaaaagabaaaacaaaaaa
diaaaaahhcaabaaaabaaaaaaegacbaaaaaaaaaaaegacbaaaabaaaaaadiaaaaai
hcaabaaaabaaaaaaegacbaaaabaaaaaaegiccaaaaaaaaaaaadaaaaaadiaaaaak
hcaabaaaabaaaaaaegacbaaaabaaaaaaaceaaaaaaaaaeaeaaaaaeaeaaaaaeaea
aaaaaaaaefaaaaajpcaabaaaacaaaaaaegbabaaaaeaaaaaaeghobaaaadaaaaaa
aagabaaaadaaaaaadiaaaaahicaabaaaabaaaaaadkaabaaaacaaaaaaabeaaaaa
aaaaaaebdiaaaaahhcaabaaaacaaaaaaegacbaaaacaaaaaapgapbaaaabaaaaaa
diaaaaaihcaabaaaaaaaaaaaegacbaaaaaaaaaaapgipcaaaaaaaaaaaadaaaaaa
dgaaaaaficcabaaaaaaaaaaadkaabaaaaaaaaaaadcaaaaajhccabaaaaaaaaaaa
egacbaaaaaaaaaaaegacbaaaacaaaaaaegacbaaaabaaaaaadoaaaaab"
}

SubProgram "gles " {
Keywords { "DIRECTIONAL" "LIGHTMAP_ON" "DIRLIGHTMAP_OFF" "SHADOWS_OFF" }
"!!GLES"
}

SubProgram "glesdesktop " {
Keywords { "DIRECTIONAL" "LIGHTMAP_ON" "DIRLIGHTMAP_OFF" "SHADOWS_OFF" }
"!!GLES"
}

SubProgram "flash " {
Keywords { "DIRECTIONAL" "LIGHTMAP_ON" "DIRLIGHTMAP_OFF" "SHADOWS_OFF" }
Vector 0 [_Color]
Float 1 [_Cutoff]
SetTexture 0 [_BumpMap] 2D
SetTexture 1 [_MainTex] 2D
SetTexture 2 [_Shade] 2D
SetTexture 3 [unity_Lightmap] 2D
"agal_ps
c2 0.0 1.0 2.0 -1.0
c3 0.5 3.0 8.0 0.0
[bc]
ciaaaaaaabaaapacaaaaaaoeaeaaaaaaabaaaaaaafaababb tex r1, v0, s1 <2d wrap linear point>
aaaaaaaaaaaaacacaaaaaappaeaaaaaaaaaaaaaaaaaaaaaa mov r0.y, v0.w
aaaaaaaaaaaaabacaaaaaakkaeaaaaaaaaaaaaaaaaaaaaaa mov r0.x, v0.z
ciaaaaaaaaaaapacaaaaaafeacaaaaaaaaaaaaaaafaababb tex r0, r0.xyyy, s0 <2d wrap linear point>
aaaaaaaaaaaaabacaaaaaappacaaaaaaaaaaaaaaaaaaaaaa mov r0.x, r0.w
adaaaaaaacaaadacaaaaaafeacaaaaaaacaaaakkabaaaaaa mul r2.xy, r0.xyyy, c2.z
abaaaaaaacaaadacacaaaafeacaaaaaaacaaaappabaaaaaa add r2.xy, r2.xyyy, c2.w
adaaaaaaaaaaabacacaaaaffacaaaaaaacaaaaffacaaaaaa mul r0.x, r2.y, r2.y
bfaaaaaaadaaabacacaaaaaaacaaaaaaaaaaaaaaaaaaaaaa neg r3.x, r2.x
adaaaaaaadaaabacadaaaaaaacaaaaaaacaaaaaaacaaaaaa mul r3.x, r3.x, r2.x
acaaaaaaaaaaabacadaaaaaaacaaaaaaaaaaaaaaacaaaaaa sub r0.x, r3.x, r0.x
abaaaaaaaaaaabacaaaaaaaaacaaaaaaacaaaaffabaaaaaa add r0.x, r0.x, c2.y
akaaaaaaaaaaabacaaaaaaaaacaaaaaaaaaaaaaaaaaaaaaa rsq r0.x, r0.x
afaaaaaaacaaaeacaaaaaaaaacaaaaaaaaaaaaaaaaaaaaaa rcp r2.z, r0.x
acaaaaaaaaaaabacabaaaappacaaaaaaabaaaaoeabaaaaaa sub r0.x, r1.w, c1
bcaaaaaaadaaabacabaaaaoeaeaaaaaaacaaaakeacaaaaaa dp3 r3.x, v1, r2.xyzz
bcaaaaaaadaaacacacaaaakeacaaaaaaacaaaaoeaeaaaaaa dp3 r3.y, r2.xyzz, v2
ckaaaaaaaaaaabacaaaaaaaaacaaaaaaadaaaappabaaaaaa slt r0.x, r0.x, c3.w
bfaaaaaaacaaapacaaaaaaaaacaaaaaaaaaaaaaaaaaaaaaa neg r2, r0.x
adaaaaaaadaaadacadaaaafeacaaaaaaadaaaaaaabaaaaaa mul r3.xy, r3.xyyy, c3.x
abaaaaaaadaaadacadaaaafeacaaaaaaadaaaaaaabaaaaaa add r3.xy, r3.xyyy, c3.x
ciaaaaaaaaaaapacadaaaafeacaaaaaaacaaaaaaafaababb tex r0, r3.xyyy, s2 <2d wrap linear point>
chaaaaaaaaaaaaaaacaaaaaaacaaaaaaaaaaaaaaaaaaaaaa kil a0.none, r2.x
ciaaaaaaacaaapacadaaaaoeaeaaaaaaadaaaaaaafaababb tex r2, v3, s3 <2d wrap linear point>
adaaaaaaaaaaahacabaaaakeacaaaaaaaaaaaakeacaaaaaa mul r0.xyz, r1.xyzz, r0.xyzz
adaaaaaaaaaaahacaaaaaakeacaaaaaaaaaaaaoeabaaaaaa mul r0.xyz, r0.xyzz, c0
adaaaaaaaaaaahacaaaaaakeacaaaaaaadaaaaffabaaaaaa mul r0.xyz, r0.xyzz, c3.y
adaaaaaaabaaahacabaaaakeacaaaaaaaaaaaappabaaaaaa mul r1.xyz, r1.xyzz, c0.w
adaaaaaaacaaahacacaaaappacaaaaaaacaaaakeacaaaaaa mul r2.xyz, r2.w, r2.xyzz
adaaaaaaabaaahacacaaaakeacaaaaaaabaaaakeacaaaaaa mul r1.xyz, r2.xyzz, r1.xyzz
adaaaaaaacaaahacabaaaakeacaaaaaaadaaaakkabaaaaaa mul r2.xyz, r1.xyzz, c3.z
abaaaaaaaaaaahacacaaaakeacaaaaaaaaaaaakeacaaaaaa add r0.xyz, r2.xyzz, r0.xyzz
aaaaaaaaaaaaaiacabaaaappacaaaaaaaaaaaaaaaaaaaaaa mov r0.w, r1.w
aaaaaaaaaaaaapadaaaaaaoeacaaaaaaaaaaaaaaaaaaaaaa mov o0, r0
"
}

SubProgram "d3d11_9x " {
Keywords { "DIRECTIONAL" "LIGHTMAP_ON" "DIRLIGHTMAP_OFF" "SHADOWS_OFF" }
ConstBuffer "$Globals" 128 // 116 used size, 8 vars
Vector 48 [_Color] 4
Float 112 [_Cutoff]
BindCB "$Globals" 0
SetTexture 0 [_BumpMap] 2D 1
SetTexture 1 [_MainTex] 2D 0
SetTexture 2 [_Shade] 2D 2
SetTexture 3 [unity_Lightmap] 2D 3
// 23 instructions, 3 temp regs, 0 temp arrays:
// ALU 11 float, 0 int, 0 uint
// TEX 4 (0 load, 0 comp, 0 bias, 0 grad)
// FLOW 1 static, 0 dynamic
"ps_4_0_level_9_3
eefiecedbpgokghpkkdcbciceckjcdeingiplgnbabaaaaaabiahaaaaaeaaaaaa
daaaaaaaiiacaaaaeeagaaaaoeagaaaaebgpgodjfaacaaaafaacaaaaaaacpppp
aeacaaaaemaaaaaaacaadeaaaaaaemaaaaaaemaaaeaaceaaaaaaemaaabaaaaaa
aaababaaacacacaaadadadaaaaaaadaaabaaaaaaaaaaaaaaaaaaahaaabaaabaa
aaaaaaaaabacppppfbaaaaafacaaapkaaaaaaaeaaaaaialpaaaaiadpaaaaaadp
fbaaaaafadaaapkaaaaaeaeaaaaaaaebaaaaaaaaaaaaaaaabpaaaaacaaaaaaia
aaaaaplabpaaaaacaaaaaaiaabaaahlabpaaaaacaaaaaaiaacaaahlabpaaaaac
aaaaaaiaadaaadlabpaaaaacaaaaaajaaaaiapkabpaaaaacaaaaaajaabaiapka
bpaaaaacaaaaaajaacaiapkabpaaaaacaaaaaajaadaiapkaabaaaaacaaaaadia
aaaaoolaecaaaaadabaaapiaaaaaoelaaaaioekaecaaaaadaaaacpiaaaaaoeia
abaioekaacaaaaadacaacpiaabaappiaabaaaakbaeaaaaaeaaaacdiaaaaaohia
acaaaakaacaaffkaaeaaaaaeaaaaciiaaaaaaaiaaaaaaaibacaakkkaaeaaaaae
aaaaciiaaaaaffiaaaaaffibaaaappiaahaaaaacaaaaciiaaaaappiaagaaaaac
aaaaceiaaaaappiaaiaaaaadadaacbiaabaaoelaaaaaoeiaaiaaaaadadaaccia
acaaoelaaaaaoeiaaeaaaaaeaaaacdiaadaaoeiaacaappkaacaappkaebaaaaab
acaaapiaecaaaaadaaaaapiaaaaaoeiaacaioekaafaaaaadaaaaahiaabaaoeia
aaaaoeiaafaaaaadaaaaahiaaaaaoeiaaaaaoekaafaaaaadaaaachiaaaaaoeia
adaaaakaecaaaaadacaacpiaadaaoelaadaioekaafaaaaadaaaaciiaacaappia
adaaffkaafaaaaadacaachiaacaaoeiaaaaappiaafaaaaadadaachiaabaaoeia
aaaappkaaeaaaaaeabaachiaadaaoeiaacaaoeiaaaaaoeiaabaaaaacaaaicpia
abaaoeiappppaaaafdeieefcleadaaaaeaaaaaaaonaaaaaafjaaaaaeegiocaaa
aaaaaaaaaiaaaaaafkaaaaadaagabaaaaaaaaaaafkaaaaadaagabaaaabaaaaaa
fkaaaaadaagabaaaacaaaaaafkaaaaadaagabaaaadaaaaaafibiaaaeaahabaaa
aaaaaaaaffffaaaafibiaaaeaahabaaaabaaaaaaffffaaaafibiaaaeaahabaaa
acaaaaaaffffaaaafibiaaaeaahabaaaadaaaaaaffffaaaagcbaaaadpcbabaaa
abaaaaaagcbaaaadhcbabaaaacaaaaaagcbaaaadhcbabaaaadaaaaaagcbaaaad
dcbabaaaaeaaaaaagfaaaaadpccabaaaaaaaaaaagiaaaaacadaaaaaaefaaaaaj
pcaabaaaaaaaaaaaegbabaaaabaaaaaaeghobaaaabaaaaaaaagabaaaaaaaaaaa
aaaaaaajbcaabaaaabaaaaaadkaabaaaaaaaaaaaakiacaiaebaaaaaaaaaaaaaa
ahaaaaaadbaaaaahbcaabaaaabaaaaaaakaabaaaabaaaaaaabeaaaaaaaaaaaaa
anaaaeadakaabaaaabaaaaaaefaaaaajpcaabaaaabaaaaaaogbkbaaaabaaaaaa
eghobaaaaaaaaaaaaagabaaaabaaaaaadcaaaaapdcaabaaaabaaaaaahgapbaaa
abaaaaaaaceaaaaaaaaaaaeaaaaaaaeaaaaaaaaaaaaaaaaaaceaaaaaaaaaialp
aaaaialpaaaaaaaaaaaaaaaadcaaaaakicaabaaaabaaaaaaakaabaiaebaaaaaa
abaaaaaaakaabaaaabaaaaaaabeaaaaaaaaaiadpdcaaaaakicaabaaaabaaaaaa
bkaabaiaebaaaaaaabaaaaaabkaabaaaabaaaaaadkaabaaaabaaaaaaelaaaaaf
ecaabaaaabaaaaaadkaabaaaabaaaaaabaaaaaahbcaabaaaacaaaaaaegbcbaaa
acaaaaaaegacbaaaabaaaaaabaaaaaahccaabaaaacaaaaaaegbcbaaaadaaaaaa
egacbaaaabaaaaaadcaaaaapdcaabaaaabaaaaaaegaabaaaacaaaaaaaceaaaaa
aaaaaadpaaaaaadpaaaaaaaaaaaaaaaaaceaaaaaaaaaaadpaaaaaadpaaaaaaaa
aaaaaaaaefaaaaajpcaabaaaabaaaaaaegaabaaaabaaaaaaeghobaaaacaaaaaa
aagabaaaacaaaaaadiaaaaahhcaabaaaabaaaaaaegacbaaaaaaaaaaaegacbaaa
abaaaaaadiaaaaaihcaabaaaabaaaaaaegacbaaaabaaaaaaegiccaaaaaaaaaaa
adaaaaaadiaaaaakhcaabaaaabaaaaaaegacbaaaabaaaaaaaceaaaaaaaaaeaea
aaaaeaeaaaaaeaeaaaaaaaaaefaaaaajpcaabaaaacaaaaaaegbabaaaaeaaaaaa
eghobaaaadaaaaaaaagabaaaadaaaaaadiaaaaahicaabaaaabaaaaaadkaabaaa
acaaaaaaabeaaaaaaaaaaaebdiaaaaahhcaabaaaacaaaaaaegacbaaaacaaaaaa
pgapbaaaabaaaaaadiaaaaaihcaabaaaaaaaaaaaegacbaaaaaaaaaaapgipcaaa
aaaaaaaaadaaaaaadgaaaaaficcabaaaaaaaaaaadkaabaaaaaaaaaaadcaaaaaj
hccabaaaaaaaaaaaegacbaaaaaaaaaaaegacbaaaacaaaaaaegacbaaaabaaaaaa
doaaaaabejfdeheojiaaaaaaafaaaaaaaiaaaaaaiaaaaaaaaaaaaaaaabaaaaaa
adaaaaaaaaaaaaaaapaaaaaaimaaaaaaaaaaaaaaaaaaaaaaadaaaaaaabaaaaaa
apapaaaaimaaaaaaabaaaaaaaaaaaaaaadaaaaaaacaaaaaaahahaaaaimaaaaaa
acaaaaaaaaaaaaaaadaaaaaaadaaaaaaahahaaaaimaaaaaaadaaaaaaaaaaaaaa
adaaaaaaaeaaaaaaadadaaaafdfgfpfaepfdejfeejepeoaafeeffiedepepfcee
aaklklklepfdeheocmaaaaaaabaaaaaaaiaaaaaacaaaaaaaaaaaaaaaaaaaaaaa
adaaaaaaaaaaaaaaapaaaaaafdfgfpfegbhcghgfheaaklkl"
}

SubProgram "opengl " {
Keywords { "DIRECTIONAL" "LIGHTMAP_ON" "DIRLIGHTMAP_ON" "SHADOWS_OFF" }
Vector 0 [_Color]
Float 1 [_Cutoff]
SetTexture 0 [_BumpMap] 2D
SetTexture 1 [_MainTex] 2D
SetTexture 2 [_Shade] 2D
SetTexture 3 [unity_Lightmap] 2D
SetTexture 4 [unity_LightmapInd] 2D
"!!ARBfp1.0
OPTION ARB_precision_hint_fastest;
# 31 ALU, 5 TEX
PARAM c[6] = { program.local[0..1],
		{ 2, 1, 8, 0.5 },
		{ -0.40824828, -0.70710677, 0.57735026, 3 },
		{ -0.40824831, 0.70710677, 0.57735026 },
		{ 0.81649655, 0, 0.57735026 } };
TEMP R0;
TEMP R1;
TEMP R2;
TEMP R3;
TEMP R4;
TEMP R5;
TEX R2, fragment.texcoord[0], texture[1], 2D;
TEX R0.yw, fragment.texcoord[0].zwzw, texture[0], 2D;
MAD R3.xy, R0.wyzw, c[2].x, -c[2].y;
MUL R0.x, R3.y, R3.y;
MAD R0.x, -R3, R3, -R0;
SLT R0.z, R2.w, c[1].x;
ADD R0.x, R0, c[2].y;
RSQ R0.x, R0.x;
RCP R3.z, R0.x;
DP3 R0.y, R3, fragment.texcoord[2];
DP3 R0.x, R3, fragment.texcoord[1];
MAD R1.xy, R0, c[2].w, c[2].w;
DP3_SAT R5.z, R3, c[3];
DP3_SAT R5.x, R3, c[5];
DP3_SAT R5.y, R3, c[4];
MOV result.color.w, R2;
TEX R4.xyz, R1, texture[2], 2D;
TEX R1, fragment.texcoord[3], texture[4], 2D;
KIL -R0.z;
TEX R0, fragment.texcoord[3], texture[3], 2D;
MUL R1.xyz, R1.w, R1;
MUL R1.xyz, R1, R5;
DP3 R1.w, R1, c[2].z;
MUL R4.xyz, R2, R4;
MUL R4.xyz, R4, c[0];
MUL R0.xyz, R0.w, R0;
MUL R3.xyz, R4, c[3].w;
MUL R1.xyz, R2, c[0].w;
MUL R0.xyz, R0, R1.w;
MUL R0.xyz, R0, R1;
MAD result.color.xyz, R0, c[2].z, R3;
END
# 31 instructions, 6 R-regs
"
}

SubProgram "d3d9 " {
Keywords { "DIRECTIONAL" "LIGHTMAP_ON" "DIRLIGHTMAP_ON" "SHADOWS_OFF" }
Vector 0 [_Color]
Float 1 [_Cutoff]
SetTexture 0 [_BumpMap] 2D
SetTexture 1 [_MainTex] 2D
SetTexture 2 [_Shade] 2D
SetTexture 3 [unity_Lightmap] 2D
SetTexture 4 [unity_LightmapInd] 2D
"ps_2_0
; 31 ALU, 6 TEX
dcl_2d s0
dcl_2d s1
dcl_2d s2
dcl_2d s3
dcl_2d s4
def c2, 0.00000000, 1.00000000, 2.00000000, -1.00000000
def c3, -0.40824828, -0.70710677, 0.57735026, 8.00000000
def c4, -0.40824831, 0.70710677, 0.57735026, 0.50000000
def c5, 0.81649655, 0.00000000, 0.57735026, 3.00000000
dcl t0
dcl t1.xyz
dcl t2.xyz
dcl t3.xy
texld r2, t0, s1
mov r0.y, t0.w
mov r0.x, t0.z
texld r0, r0, s0
mov r0.x, r0.w
mad_pp r4.xy, r0, c2.z, c2.w
mul_pp r0.x, r4.y, r4.y
mad_pp r0.x, -r4, r4, -r0
add_pp r0.x, r0, c2.y
rsq_pp r0.x, r0.x
rcp_pp r4.z, r0.x
add_pp r0.x, r2.w, -c1
cmp r0.x, r0, c2, c2.y
mov_pp r0, -r0.x
dp3 r1.x, r4, t1
dp3 r1.y, r4, t2
mad_pp r1.xy, r1, c4.w, c4.w
dp3_pp_sat r5.z, r4, c3
dp3_pp_sat r5.y, r4, c4
dp3_pp_sat r5.x, r4, c5
texld r3, r1, s2
texkill r0.xyzw
texld r1, t3, s3
texld r0, t3, s4
mul_pp r0.xyz, r0.w, r0
mul_pp r0.xyz, r0, r5
mul r3.xyz, r2, r3
mul_pp r1.xyz, r1.w, r1
dp3_pp r0.x, r0, c3.w
mul_pp r0.xyz, r1, r0.x
mul r1.xyz, r3, c0
mul r2.xyz, r2, c0.w
mul r1.xyz, r1, c5.w
mul_pp r0.xyz, r0, r2
mad_pp r0.xyz, r0, c3.w, r1
mov_pp r0.w, r2
mov_pp oC0, r0
"
}

SubProgram "d3d11 " {
Keywords { "DIRECTIONAL" "LIGHTMAP_ON" "DIRLIGHTMAP_ON" "SHADOWS_OFF" }
ConstBuffer "$Globals" 128 // 116 used size, 8 vars
Vector 48 [_Color] 4
Float 112 [_Cutoff]
BindCB "$Globals" 0
SetTexture 0 [_BumpMap] 2D 1
SetTexture 1 [_MainTex] 2D 0
SetTexture 2 [_Shade] 2D 2
SetTexture 3 [unity_Lightmap] 2D 3
SetTexture 4 [unity_LightmapInd] 2D 4
// 31 instructions, 5 temp regs, 0 temp arrays:
// ALU 18 float, 0 int, 0 uint
// TEX 5 (0 load, 0 comp, 0 bias, 0 grad)
// FLOW 1 static, 0 dynamic
"ps_4_0
eefiecedgjgdiojedclblckponebjfhhbiciniakabaaaaaaoeafaaaaadaaaaaa
cmaaaaaammaaaaaaaaabaaaaejfdeheojiaaaaaaafaaaaaaaiaaaaaaiaaaaaaa
aaaaaaaaabaaaaaaadaaaaaaaaaaaaaaapaaaaaaimaaaaaaaaaaaaaaaaaaaaaa
adaaaaaaabaaaaaaapapaaaaimaaaaaaabaaaaaaaaaaaaaaadaaaaaaacaaaaaa
ahahaaaaimaaaaaaacaaaaaaaaaaaaaaadaaaaaaadaaaaaaahahaaaaimaaaaaa
adaaaaaaaaaaaaaaadaaaaaaaeaaaaaaadadaaaafdfgfpfaepfdejfeejepeoaa
feeffiedepepfceeaaklklklepfdeheocmaaaaaaabaaaaaaaiaaaaaacaaaaaaa
aaaaaaaaaaaaaaaaadaaaaaaaaaaaaaaapaaaaaafdfgfpfegbhcghgfheaaklkl
fdeieefcnmaeaaaaeaaaaaaadhabaaaafjaaaaaeegiocaaaaaaaaaaaaiaaaaaa
fkaaaaadaagabaaaaaaaaaaafkaaaaadaagabaaaabaaaaaafkaaaaadaagabaaa
acaaaaaafkaaaaadaagabaaaadaaaaaafkaaaaadaagabaaaaeaaaaaafibiaaae
aahabaaaaaaaaaaaffffaaaafibiaaaeaahabaaaabaaaaaaffffaaaafibiaaae
aahabaaaacaaaaaaffffaaaafibiaaaeaahabaaaadaaaaaaffffaaaafibiaaae
aahabaaaaeaaaaaaffffaaaagcbaaaadpcbabaaaabaaaaaagcbaaaadhcbabaaa
acaaaaaagcbaaaadhcbabaaaadaaaaaagcbaaaaddcbabaaaaeaaaaaagfaaaaad
pccabaaaaaaaaaaagiaaaaacafaaaaaaefaaaaajpcaabaaaaaaaaaaaegbabaaa
abaaaaaaeghobaaaabaaaaaaaagabaaaaaaaaaaaaaaaaaajbcaabaaaabaaaaaa
dkaabaaaaaaaaaaaakiacaiaebaaaaaaaaaaaaaaahaaaaaadbaaaaahbcaabaaa
abaaaaaaakaabaaaabaaaaaaabeaaaaaaaaaaaaaanaaaeadakaabaaaabaaaaaa
efaaaaajpcaabaaaabaaaaaaegbabaaaaeaaaaaaeghobaaaadaaaaaaaagabaaa
adaaaaaadiaaaaahicaabaaaabaaaaaadkaabaaaabaaaaaaabeaaaaaaaaaaaeb
diaaaaahhcaabaaaabaaaaaaegacbaaaabaaaaaapgapbaaaabaaaaaaefaaaaaj
pcaabaaaacaaaaaaegbabaaaaeaaaaaaeghobaaaaeaaaaaaaagabaaaaeaaaaaa
diaaaaahicaabaaaabaaaaaadkaabaaaacaaaaaaabeaaaaaaaaaaaebdiaaaaah
hcaabaaaacaaaaaaegacbaaaacaaaaaapgapbaaaabaaaaaaefaaaaajpcaabaaa
adaaaaaaogbkbaaaabaaaaaaeghobaaaaaaaaaaaaagabaaaabaaaaaadcaaaaap
dcaabaaaadaaaaaahgapbaaaadaaaaaaaceaaaaaaaaaaaeaaaaaaaeaaaaaaaaa
aaaaaaaaaceaaaaaaaaaialpaaaaialpaaaaaaaaaaaaaaaadcaaaaakicaabaaa
abaaaaaaakaabaiaebaaaaaaadaaaaaaakaabaaaadaaaaaaabeaaaaaaaaaiadp
dcaaaaakicaabaaaabaaaaaabkaabaiaebaaaaaaadaaaaaabkaabaaaadaaaaaa
dkaabaaaabaaaaaaelaaaaafecaabaaaadaaaaaadkaabaaaabaaaaaaapcaaaak
bcaabaaaaeaaaaaaaceaaaaaolaffbdpdkmnbddpaaaaaaaaaaaaaaaaigaabaaa
adaaaaaabacaaaakccaabaaaaeaaaaaaaceaaaaaomafnblopdaedfdpdkmnbddp
aaaaaaaaegacbaaaadaaaaaabacaaaakecaabaaaaeaaaaaaaceaaaaaolafnblo
pdaedflpdkmnbddpaaaaaaaaegacbaaaadaaaaaabaaaaaahicaabaaaabaaaaaa
egacbaaaaeaaaaaaegacbaaaacaaaaaadiaaaaahhcaabaaaabaaaaaapgapbaaa
abaaaaaaegacbaaaabaaaaaabaaaaaahbcaabaaaacaaaaaaegbcbaaaacaaaaaa
egacbaaaadaaaaaabaaaaaahccaabaaaacaaaaaaegbcbaaaadaaaaaaegacbaaa
adaaaaaadcaaaaapdcaabaaaacaaaaaaegaabaaaacaaaaaaaceaaaaaaaaaaadp
aaaaaadpaaaaaaaaaaaaaaaaaceaaaaaaaaaaadpaaaaaadpaaaaaaaaaaaaaaaa
efaaaaajpcaabaaaacaaaaaaegaabaaaacaaaaaaeghobaaaacaaaaaaaagabaaa
acaaaaaadiaaaaahhcaabaaaacaaaaaaegacbaaaaaaaaaaaegacbaaaacaaaaaa
diaaaaaihcaabaaaacaaaaaaegacbaaaacaaaaaaegiccaaaaaaaaaaaadaaaaaa
diaaaaakhcaabaaaacaaaaaaegacbaaaacaaaaaaaceaaaaaaaaaeaeaaaaaeaea
aaaaeaeaaaaaaaaadiaaaaaihcaabaaaaaaaaaaaegacbaaaaaaaaaaapgipcaaa
aaaaaaaaadaaaaaadgaaaaaficcabaaaaaaaaaaadkaabaaaaaaaaaaadcaaaaaj
hccabaaaaaaaaaaaegacbaaaaaaaaaaaegacbaaaabaaaaaaegacbaaaacaaaaaa
doaaaaab"
}

SubProgram "gles " {
Keywords { "DIRECTIONAL" "LIGHTMAP_ON" "DIRLIGHTMAP_ON" "SHADOWS_OFF" }
"!!GLES"
}

SubProgram "glesdesktop " {
Keywords { "DIRECTIONAL" "LIGHTMAP_ON" "DIRLIGHTMAP_ON" "SHADOWS_OFF" }
"!!GLES"
}

SubProgram "flash " {
Keywords { "DIRECTIONAL" "LIGHTMAP_ON" "DIRLIGHTMAP_ON" "SHADOWS_OFF" }
Vector 0 [_Color]
Float 1 [_Cutoff]
SetTexture 0 [_BumpMap] 2D
SetTexture 1 [_MainTex] 2D
SetTexture 2 [_Shade] 2D
SetTexture 3 [unity_Lightmap] 2D
SetTexture 4 [unity_LightmapInd] 2D
"agal_ps
c2 0.0 1.0 2.0 -1.0
c3 -0.408248 -0.707107 0.57735 8.0
c4 -0.408248 0.707107 0.57735 0.5
c5 0.816497 0.0 0.57735 3.0
[bc]
ciaaaaaaacaaapacaaaaaaoeaeaaaaaaabaaaaaaafaababb tex r2, v0, s1 <2d wrap linear point>
aaaaaaaaaaaaacacaaaaaappaeaaaaaaaaaaaaaaaaaaaaaa mov r0.y, v0.w
aaaaaaaaaaaaabacaaaaaakkaeaaaaaaaaaaaaaaaaaaaaaa mov r0.x, v0.z
ciaaaaaaaaaaapacaaaaaafeacaaaaaaaaaaaaaaafaababb tex r0, r0.xyyy, s0 <2d wrap linear point>
aaaaaaaaaaaaabacaaaaaappacaaaaaaaaaaaaaaaaaaaaaa mov r0.x, r0.w
adaaaaaaaeaaadacaaaaaafeacaaaaaaacaaaakkabaaaaaa mul r4.xy, r0.xyyy, c2.z
abaaaaaaaeaaadacaeaaaafeacaaaaaaacaaaappabaaaaaa add r4.xy, r4.xyyy, c2.w
adaaaaaaaaaaabacaeaaaaffacaaaaaaaeaaaaffacaaaaaa mul r0.x, r4.y, r4.y
bfaaaaaaabaaabacaeaaaaaaacaaaaaaaaaaaaaaaaaaaaaa neg r1.x, r4.x
adaaaaaaabaaabacabaaaaaaacaaaaaaaeaaaaaaacaaaaaa mul r1.x, r1.x, r4.x
acaaaaaaaaaaabacabaaaaaaacaaaaaaaaaaaaaaacaaaaaa sub r0.x, r1.x, r0.x
abaaaaaaaaaaabacaaaaaaaaacaaaaaaacaaaaffabaaaaaa add r0.x, r0.x, c2.y
akaaaaaaaaaaabacaaaaaaaaacaaaaaaaaaaaaaaaaaaaaaa rsq r0.x, r0.x
afaaaaaaaeaaaeacaaaaaaaaacaaaaaaaaaaaaaaaaaaaaaa rcp r4.z, r0.x
acaaaaaaaaaaabacacaaaappacaaaaaaabaaaaoeabaaaaaa sub r0.x, r2.w, c1
ckaaaaaaaaaaabacaaaaaaaaacaaaaaaafaaaaffabaaaaaa slt r0.x, r0.x, c5.y
bfaaaaaaaaaaapacaaaaaaaaacaaaaaaaaaaaaaaaaaaaaaa neg r0, r0.x
bcaaaaaaabaaabacaeaaaakeacaaaaaaabaaaaoeaeaaaaaa dp3 r1.x, r4.xyzz, v1
bcaaaaaaabaaacacaeaaaakeacaaaaaaacaaaaoeaeaaaaaa dp3 r1.y, r4.xyzz, v2
adaaaaaaabaaadacabaaaafeacaaaaaaaeaaaappabaaaaaa mul r1.xy, r1.xyyy, c4.w
abaaaaaaabaaadacabaaaafeacaaaaaaaeaaaappabaaaaaa add r1.xy, r1.xyyy, c4.w
bcaaaaaaafaaaeacaeaaaakeacaaaaaaadaaaaoeabaaaaaa dp3 r5.z, r4.xyzz, c3
bgaaaaaaafaaaeacafaaaakkacaaaaaaaaaaaaaaaaaaaaaa sat r5.z, r5.z
bcaaaaaaafaaacacaeaaaakeacaaaaaaaeaaaaoeabaaaaaa dp3 r5.y, r4.xyzz, c4
bgaaaaaaafaaacacafaaaaffacaaaaaaaaaaaaaaaaaaaaaa sat r5.y, r5.y
bcaaaaaaafaaabacaeaaaakeacaaaaaaafaaaaoeabaaaaaa dp3 r5.x, r4.xyzz, c5
bgaaaaaaafaaabacafaaaaaaacaaaaaaaaaaaaaaaaaaaaaa sat r5.x, r5.x
ciaaaaaaadaaapacabaaaafeacaaaaaaacaaaaaaafaababb tex r3, r1.xyyy, s2 <2d wrap linear point>
chaaaaaaaaaaaaaaaaaaaaaaacaaaaaaaaaaaaaaaaaaaaaa kil a0.none, r0.x
ciaaaaaaabaaapacadaaaaoeaeaaaaaaadaaaaaaafaababb tex r1, v3, s3 <2d wrap linear point>
ciaaaaaaaaaaapacadaaaaoeaeaaaaaaaeaaaaaaafaababb tex r0, v3, s4 <2d wrap linear point>
adaaaaaaaaaaahacaaaaaappacaaaaaaaaaaaakeacaaaaaa mul r0.xyz, r0.w, r0.xyzz
adaaaaaaaaaaahacaaaaaakeacaaaaaaafaaaakeacaaaaaa mul r0.xyz, r0.xyzz, r5.xyzz
adaaaaaaadaaahacacaaaakeacaaaaaaadaaaakeacaaaaaa mul r3.xyz, r2.xyzz, r3.xyzz
adaaaaaaabaaahacabaaaappacaaaaaaabaaaakeacaaaaaa mul r1.xyz, r1.w, r1.xyzz
bcaaaaaaaaaaabacaaaaaakeacaaaaaaadaaaappabaaaaaa dp3 r0.x, r0.xyzz, c3.w
adaaaaaaaaaaahacabaaaakeacaaaaaaaaaaaaaaacaaaaaa mul r0.xyz, r1.xyzz, r0.x
adaaaaaaabaaahacadaaaakeacaaaaaaaaaaaaoeabaaaaaa mul r1.xyz, r3.xyzz, c0
adaaaaaaacaaahacacaaaakeacaaaaaaaaaaaappabaaaaaa mul r2.xyz, r2.xyzz, c0.w
adaaaaaaabaaahacabaaaakeacaaaaaaafaaaappabaaaaaa mul r1.xyz, r1.xyzz, c5.w
adaaaaaaaaaaahacaaaaaakeacaaaaaaacaaaakeacaaaaaa mul r0.xyz, r0.xyzz, r2.xyzz
adaaaaaaaaaaahacaaaaaakeacaaaaaaadaaaappabaaaaaa mul r0.xyz, r0.xyzz, c3.w
abaaaaaaaaaaahacaaaaaakeacaaaaaaabaaaakeacaaaaaa add r0.xyz, r0.xyzz, r1.xyzz
aaaaaaaaaaaaaiacacaaaappacaaaaaaaaaaaaaaaaaaaaaa mov r0.w, r2.w
aaaaaaaaaaaaapadaaaaaaoeacaaaaaaaaaaaaaaaaaaaaaa mov o0, r0
"
}

SubProgram "d3d11_9x " {
Keywords { "DIRECTIONAL" "LIGHTMAP_ON" "DIRLIGHTMAP_ON" "SHADOWS_OFF" }
ConstBuffer "$Globals" 128 // 116 used size, 8 vars
Vector 48 [_Color] 4
Float 112 [_Cutoff]
BindCB "$Globals" 0
SetTexture 0 [_BumpMap] 2D 1
SetTexture 1 [_MainTex] 2D 0
SetTexture 2 [_Shade] 2D 2
SetTexture 3 [unity_Lightmap] 2D 3
SetTexture 4 [unity_LightmapInd] 2D 4
// 31 instructions, 5 temp regs, 0 temp arrays:
// ALU 18 float, 0 int, 0 uint
// TEX 5 (0 load, 0 comp, 0 bias, 0 grad)
// FLOW 1 static, 0 dynamic
"ps_4_0_level_9_3
eefiecedopdljkeggbhepdpkbofojainibjldidfabaaaaaabmajaaaaaeaaaaaa
daaaaaaageadaaaaeiaiaaaaoiaiaaaaebgpgodjcmadaaaacmadaaaaaaacpppp
nmacaaaafaaaaaaaacaadiaaaaaafaaaaaaafaaaafaaceaaaaaafaaaabaaaaaa
aaababaaacacacaaadadadaaaeaeaeaaaaaaadaaabaaaaaaaaaaaaaaaaaaahaa
abaaabaaaaaaaaaaabacppppfbaaaaafacaaapkaaaaaaaeaaaaaialpaaaaiadp
aaaaaadpfbaaaaafadaaapkaaaaaeaeaaaaaaaebaaaaaaaaaaaaaaaafbaaaaaf
aeaaapkaolaffbdpdkmnbddpaaaaaaaaaaaaaaaafbaaaaafafaaapkaomafnblo
pdaedfdpdkmnbddpaaaaaaaafbaaaaafagaaapkaolafnblopdaedflpdkmnbddp
aaaaaaaabpaaaaacaaaaaaiaaaaaaplabpaaaaacaaaaaaiaabaaahlabpaaaaac
aaaaaaiaacaaahlabpaaaaacaaaaaaiaadaaadlabpaaaaacaaaaaajaaaaiapka
bpaaaaacaaaaaajaabaiapkabpaaaaacaaaaaajaacaiapkabpaaaaacaaaaaaja
adaiapkabpaaaaacaaaaaajaaeaiapkaabaaaaacaaaaadiaaaaaoolaecaaaaad
abaaapiaaaaaoelaaaaioekaecaaaaadaaaacpiaaaaaoeiaabaioekaacaaaaad
acaacpiaabaappiaabaaaakbecaaaaadadaacpiaadaaoelaadaioekaebaaaaab
acaaapiaafaaaaadadaaciiaadaappiaadaaffkaafaaaaadacaachiaadaaoeia
adaappiaaeaaaaaeaaaacdiaaaaaohiaacaaaakaacaaffkaaeaaaaaeaaaaciia
aaaaaaiaaaaaaaibacaakkkaaeaaaaaeaaaaciiaaaaaffiaaaaaffibaaaappia
ahaaaaacaaaaciiaaaaappiaagaaaaacaaaaceiaaaaappiaaiaaaaadadaacbia
abaaoelaaaaaoeiaaiaaaaadadaacciaacaaoelaaaaaoeiaaeaaaaaeadaacdia
adaaoeiaacaappkaacaappkaecaaaaadaeaacpiaadaaoelaaeaioekaecaaaaad
adaaapiaadaaoeiaacaioekaafaaaaadaaaaciiaaeaappiaadaaffkaafaaaaad
aeaachiaaeaaoeiaaaaappiafkaaaaaeafaadbiaaeaaoekaaaaaoiiaaeaakkka
aiaaaaadafaadciaafaaoekaaaaaoeiaaiaaaaadafaadeiaagaaoekaaaaaoeia
aiaaaaadacaaciiaafaaoeiaaeaaoeiaafaaaaadaaaachiaacaappiaacaaoeia
afaaaaadacaaahiaabaaoeiaadaaoeiaafaaaaadacaaahiaacaaoeiaaaaaoeka
afaaaaadacaachiaacaaoeiaadaaaakaafaaaaadadaachiaabaaoeiaaaaappka
aeaaaaaeabaachiaadaaoeiaaaaaoeiaacaaoeiaabaaaaacaaaicpiaabaaoeia
ppppaaaafdeieefcnmaeaaaaeaaaaaaadhabaaaafjaaaaaeegiocaaaaaaaaaaa
aiaaaaaafkaaaaadaagabaaaaaaaaaaafkaaaaadaagabaaaabaaaaaafkaaaaad
aagabaaaacaaaaaafkaaaaadaagabaaaadaaaaaafkaaaaadaagabaaaaeaaaaaa
fibiaaaeaahabaaaaaaaaaaaffffaaaafibiaaaeaahabaaaabaaaaaaffffaaaa
fibiaaaeaahabaaaacaaaaaaffffaaaafibiaaaeaahabaaaadaaaaaaffffaaaa
fibiaaaeaahabaaaaeaaaaaaffffaaaagcbaaaadpcbabaaaabaaaaaagcbaaaad
hcbabaaaacaaaaaagcbaaaadhcbabaaaadaaaaaagcbaaaaddcbabaaaaeaaaaaa
gfaaaaadpccabaaaaaaaaaaagiaaaaacafaaaaaaefaaaaajpcaabaaaaaaaaaaa
egbabaaaabaaaaaaeghobaaaabaaaaaaaagabaaaaaaaaaaaaaaaaaajbcaabaaa
abaaaaaadkaabaaaaaaaaaaaakiacaiaebaaaaaaaaaaaaaaahaaaaaadbaaaaah
bcaabaaaabaaaaaaakaabaaaabaaaaaaabeaaaaaaaaaaaaaanaaaeadakaabaaa
abaaaaaaefaaaaajpcaabaaaabaaaaaaegbabaaaaeaaaaaaeghobaaaadaaaaaa
aagabaaaadaaaaaadiaaaaahicaabaaaabaaaaaadkaabaaaabaaaaaaabeaaaaa
aaaaaaebdiaaaaahhcaabaaaabaaaaaaegacbaaaabaaaaaapgapbaaaabaaaaaa
efaaaaajpcaabaaaacaaaaaaegbabaaaaeaaaaaaeghobaaaaeaaaaaaaagabaaa
aeaaaaaadiaaaaahicaabaaaabaaaaaadkaabaaaacaaaaaaabeaaaaaaaaaaaeb
diaaaaahhcaabaaaacaaaaaaegacbaaaacaaaaaapgapbaaaabaaaaaaefaaaaaj
pcaabaaaadaaaaaaogbkbaaaabaaaaaaeghobaaaaaaaaaaaaagabaaaabaaaaaa
dcaaaaapdcaabaaaadaaaaaahgapbaaaadaaaaaaaceaaaaaaaaaaaeaaaaaaaea
aaaaaaaaaaaaaaaaaceaaaaaaaaaialpaaaaialpaaaaaaaaaaaaaaaadcaaaaak
icaabaaaabaaaaaaakaabaiaebaaaaaaadaaaaaaakaabaaaadaaaaaaabeaaaaa
aaaaiadpdcaaaaakicaabaaaabaaaaaabkaabaiaebaaaaaaadaaaaaabkaabaaa
adaaaaaadkaabaaaabaaaaaaelaaaaafecaabaaaadaaaaaadkaabaaaabaaaaaa
apcaaaakbcaabaaaaeaaaaaaaceaaaaaolaffbdpdkmnbddpaaaaaaaaaaaaaaaa
igaabaaaadaaaaaabacaaaakccaabaaaaeaaaaaaaceaaaaaomafnblopdaedfdp
dkmnbddpaaaaaaaaegacbaaaadaaaaaabacaaaakecaabaaaaeaaaaaaaceaaaaa
olafnblopdaedflpdkmnbddpaaaaaaaaegacbaaaadaaaaaabaaaaaahicaabaaa
abaaaaaaegacbaaaaeaaaaaaegacbaaaacaaaaaadiaaaaahhcaabaaaabaaaaaa
pgapbaaaabaaaaaaegacbaaaabaaaaaabaaaaaahbcaabaaaacaaaaaaegbcbaaa
acaaaaaaegacbaaaadaaaaaabaaaaaahccaabaaaacaaaaaaegbcbaaaadaaaaaa
egacbaaaadaaaaaadcaaaaapdcaabaaaacaaaaaaegaabaaaacaaaaaaaceaaaaa
aaaaaadpaaaaaadpaaaaaaaaaaaaaaaaaceaaaaaaaaaaadpaaaaaadpaaaaaaaa
aaaaaaaaefaaaaajpcaabaaaacaaaaaaegaabaaaacaaaaaaeghobaaaacaaaaaa
aagabaaaacaaaaaadiaaaaahhcaabaaaacaaaaaaegacbaaaaaaaaaaaegacbaaa
acaaaaaadiaaaaaihcaabaaaacaaaaaaegacbaaaacaaaaaaegiccaaaaaaaaaaa
adaaaaaadiaaaaakhcaabaaaacaaaaaaegacbaaaacaaaaaaaceaaaaaaaaaeaea
aaaaeaeaaaaaeaeaaaaaaaaadiaaaaaihcaabaaaaaaaaaaaegacbaaaaaaaaaaa
pgipcaaaaaaaaaaaadaaaaaadgaaaaaficcabaaaaaaaaaaadkaabaaaaaaaaaaa
dcaaaaajhccabaaaaaaaaaaaegacbaaaaaaaaaaaegacbaaaabaaaaaaegacbaaa
acaaaaaadoaaaaabejfdeheojiaaaaaaafaaaaaaaiaaaaaaiaaaaaaaaaaaaaaa
abaaaaaaadaaaaaaaaaaaaaaapaaaaaaimaaaaaaaaaaaaaaaaaaaaaaadaaaaaa
abaaaaaaapapaaaaimaaaaaaabaaaaaaaaaaaaaaadaaaaaaacaaaaaaahahaaaa
imaaaaaaacaaaaaaaaaaaaaaadaaaaaaadaaaaaaahahaaaaimaaaaaaadaaaaaa
aaaaaaaaadaaaaaaaeaaaaaaadadaaaafdfgfpfaepfdejfeejepeoaafeeffied
epepfceeaaklklklepfdeheocmaaaaaaabaaaaaaaiaaaaaacaaaaaaaaaaaaaaa
aaaaaaaaadaaaaaaaaaaaaaaapaaaaaafdfgfpfegbhcghgfheaaklkl"
}

SubProgram "opengl " {
Keywords { "DIRECTIONAL" "LIGHTMAP_OFF" "DIRLIGHTMAP_OFF" "SHADOWS_SCREEN" }
Vector 0 [_LightColor0]
Vector 1 [_Color]
Float 2 [_Cutoff]
SetTexture 0 [_BumpMap] 2D
SetTexture 1 [_MainTex] 2D
SetTexture 2 [_Shade] 2D
SetTexture 3 [_ShadowMapTexture] 2D
"!!ARBfp1.0
OPTION ARB_precision_hint_fastest;
# 28 ALU, 4 TEX
PARAM c[5] = { program.local[0..2],
		{ 2, 1, 0, 0.5 },
		{ 3 } };
TEMP R0;
TEMP R1;
TEMP R2;
TEMP R3;
TEX R0, fragment.texcoord[0], texture[1], 2D;
TEX R1.yw, fragment.texcoord[0].zwzw, texture[0], 2D;
TXP R2.x, fragment.texcoord[5], texture[3], 2D;
MAD R3.xy, R1.wyzw, c[3].x, -c[3].y;
SLT R1.z, R0.w, c[2].x;
MUL R1.x, R3.y, R3.y;
MAD R1.x, -R3, R3, -R1;
ADD R1.x, R1, c[3].y;
RSQ R1.x, R1.x;
RCP R3.z, R1.x;
DP3 R1.w, R3, fragment.texcoord[3];
MAX R1.w, R1, c[3].z;
DP3 R1.y, R3, fragment.texcoord[2];
DP3 R1.x, R3, fragment.texcoord[1];
MAD R1.xy, R1, c[3].w, c[3].w;
MUL R1.w, R1, R2.x;
MOV result.color.w, R0;
KIL -R1.z;
TEX R1.xyz, R1, texture[2], 2D;
MUL R1.xyz, R0, R1;
MUL R1.xyz, R1, c[1];
MUL R0.xyz, R0, c[1].w;
MUL R2.yzw, R1.xxyz, c[4].x;
MUL R1.xyz, R0, fragment.texcoord[4];
MUL R0.xyz, R0, c[0];
MUL R0.xyz, R1.w, R0;
MAD R0.xyz, R0, c[3].x, R1;
ADD result.color.xyz, R0, R2.yzww;
END
# 28 instructions, 4 R-regs
"
}

SubProgram "d3d9 " {
Keywords { "DIRECTIONAL" "LIGHTMAP_OFF" "DIRLIGHTMAP_OFF" "SHADOWS_SCREEN" }
Vector 0 [_LightColor0]
Vector 1 [_Color]
Float 2 [_Cutoff]
SetTexture 0 [_BumpMap] 2D
SetTexture 1 [_MainTex] 2D
SetTexture 2 [_Shade] 2D
SetTexture 3 [_ShadowMapTexture] 2D
"ps_2_0
; 29 ALU, 5 TEX
dcl_2d s0
dcl_2d s1
dcl_2d s2
dcl_2d s3
def c3, 0.00000000, 1.00000000, 2.00000000, -1.00000000
def c4, 0.50000000, 3.00000000, 0, 0
dcl t0
dcl t1.xyz
dcl t2.xyz
dcl t3.xyz
dcl t4.xyz
dcl t5
texld r1, t0, s1
mov r0.y, t0.w
mov r0.x, t0.z
texld r0, r0, s0
mov r0.x, r0.w
mad_pp r2.xy, r0, c3.z, c3.w
mul_pp r0.x, r2.y, r2.y
mad_pp r0.x, -r2, r2, -r0
add_pp r0.x, r0, c3.y
rsq_pp r0.x, r0.x
rcp_pp r2.z, r0.x
add_pp r0.x, r1.w, -c2
cmp r0.x, r0, c3, c3.y
mov_pp r0, -r0.x
dp3 r3.x, r2, t1
dp3 r3.y, r2, t2
dp3_pp r2.x, r2, t3
mad_pp r3.xy, r3, c4.x, c4.x
max_pp r2.x, r2, c3
texld r3, r3, s2
texkill r0.xyzw
texldp r0, t5, s3
mul r3.xyz, r1, r3
mul r3.xyz, r3, c1
mul r1.xyz, r1, c1.w
mul_pp r0.x, r2, r0
mul_pp r2.xyz, r1, c0
mul r3.xyz, r3, c4.y
mul_pp r1.xyz, r1, t4
mul_pp r0.xyz, r0.x, r2
mad_pp r0.xyz, r0, c3.z, r1
add_pp r0.xyz, r0, r3
mov_pp r0.w, r1
mov_pp oC0, r0
"
}

SubProgram "d3d11 " {
Keywords { "DIRECTIONAL" "LIGHTMAP_OFF" "DIRLIGHTMAP_OFF" "SHADOWS_SCREEN" }
ConstBuffer "$Globals" 176 // 164 used size, 8 vars
Vector 16 [_LightColor0] 4
Vector 112 [_Color] 4
Float 160 [_Cutoff]
BindCB "$Globals" 0
SetTexture 0 [_BumpMap] 2D 2
SetTexture 1 [_MainTex] 2D 1
SetTexture 2 [_Shade] 2D 3
SetTexture 3 [_ShadowMapTexture] 2D 0
// 27 instructions, 3 temp regs, 0 temp arrays:
// ALU 14 float, 0 int, 0 uint
// TEX 4 (0 load, 0 comp, 0 bias, 0 grad)
// FLOW 1 static, 0 dynamic
"ps_4_0
eefiecedecmdfcbnmboeahokenlghkdmnjoblhblabaaaaaaiaafaaaaadaaaaaa
cmaaaaaapmaaaaaadaabaaaaejfdeheomiaaaaaaahaaaaaaaiaaaaaalaaaaaaa
aaaaaaaaabaaaaaaadaaaaaaaaaaaaaaapaaaaaalmaaaaaaaaaaaaaaaaaaaaaa
adaaaaaaabaaaaaaapapaaaalmaaaaaaabaaaaaaaaaaaaaaadaaaaaaacaaaaaa
ahahaaaalmaaaaaaacaaaaaaaaaaaaaaadaaaaaaadaaaaaaahahaaaalmaaaaaa
adaaaaaaaaaaaaaaadaaaaaaaeaaaaaaahahaaaalmaaaaaaaeaaaaaaaaaaaaaa
adaaaaaaafaaaaaaahahaaaalmaaaaaaafaaaaaaaaaaaaaaadaaaaaaagaaaaaa
apalaaaafdfgfpfaepfdejfeejepeoaafeeffiedepepfceeaaklklklepfdeheo
cmaaaaaaabaaaaaaaiaaaaaacaaaaaaaaaaaaaaaaaaaaaaaadaaaaaaaaaaaaaa
apaaaaaafdfgfpfegbhcghgfheaaklklfdeieefceiaeaaaaeaaaaaaabcabaaaa
fjaaaaaeegiocaaaaaaaaaaaalaaaaaafkaaaaadaagabaaaaaaaaaaafkaaaaad
aagabaaaabaaaaaafkaaaaadaagabaaaacaaaaaafkaaaaadaagabaaaadaaaaaa
fibiaaaeaahabaaaaaaaaaaaffffaaaafibiaaaeaahabaaaabaaaaaaffffaaaa
fibiaaaeaahabaaaacaaaaaaffffaaaafibiaaaeaahabaaaadaaaaaaffffaaaa
gcbaaaadpcbabaaaabaaaaaagcbaaaadhcbabaaaacaaaaaagcbaaaadhcbabaaa
adaaaaaagcbaaaadhcbabaaaaeaaaaaagcbaaaadhcbabaaaafaaaaaagcbaaaad
lcbabaaaagaaaaaagfaaaaadpccabaaaaaaaaaaagiaaaaacadaaaaaaefaaaaaj
pcaabaaaaaaaaaaaegbabaaaabaaaaaaeghobaaaabaaaaaaaagabaaaabaaaaaa
aaaaaaajbcaabaaaabaaaaaadkaabaaaaaaaaaaaakiacaiaebaaaaaaaaaaaaaa
akaaaaaadbaaaaahbcaabaaaabaaaaaaakaabaaaabaaaaaaabeaaaaaaaaaaaaa
anaaaeadakaabaaaabaaaaaaefaaaaajpcaabaaaabaaaaaaogbkbaaaabaaaaaa
eghobaaaaaaaaaaaaagabaaaacaaaaaadcaaaaapdcaabaaaabaaaaaahgapbaaa
abaaaaaaaceaaaaaaaaaaaeaaaaaaaeaaaaaaaaaaaaaaaaaaceaaaaaaaaaialp
aaaaialpaaaaaaaaaaaaaaaadcaaaaakicaabaaaabaaaaaaakaabaiaebaaaaaa
abaaaaaaakaabaaaabaaaaaaabeaaaaaaaaaiadpdcaaaaakicaabaaaabaaaaaa
bkaabaiaebaaaaaaabaaaaaabkaabaaaabaaaaaadkaabaaaabaaaaaaelaaaaaf
ecaabaaaabaaaaaadkaabaaaabaaaaaabaaaaaahbcaabaaaacaaaaaaegbcbaaa
acaaaaaaegacbaaaabaaaaaabaaaaaahccaabaaaacaaaaaaegbcbaaaadaaaaaa
egacbaaaabaaaaaabaaaaaahbcaabaaaabaaaaaaegacbaaaabaaaaaaegbcbaaa
aeaaaaaadeaaaaahbcaabaaaabaaaaaaakaabaaaabaaaaaaabeaaaaaaaaaaaaa
dcaaaaapgcaabaaaabaaaaaaagabbaaaacaaaaaaaceaaaaaaaaaaaaaaaaaaadp
aaaaaadpaaaaaaaaaceaaaaaaaaaaaaaaaaaaadpaaaaaadpaaaaaaaaefaaaaaj
pcaabaaaacaaaaaajgafbaaaabaaaaaaeghobaaaacaaaaaaaagabaaaadaaaaaa
diaaaaahocaabaaaabaaaaaaagajbaaaaaaaaaaaagajbaaaacaaaaaadiaaaaai
ocaabaaaabaaaaaafgaobaaaabaaaaaaagijcaaaaaaaaaaaahaaaaaaaoaaaaah
dcaabaaaacaaaaaaegbabaaaagaaaaaapgbpbaaaagaaaaaaefaaaaajpcaabaaa
acaaaaaaegaabaaaacaaaaaaeghobaaaadaaaaaaaagabaaaaaaaaaaaapaaaaah
bcaabaaaabaaaaaaagaabaaaabaaaaaaagaabaaaacaaaaaadiaaaaaihcaabaaa
aaaaaaaaegacbaaaaaaaaaaapgipcaaaaaaaaaaaahaaaaaadgaaaaaficcabaaa
aaaaaaaadkaabaaaaaaaaaaadiaaaaaihcaabaaaacaaaaaaegacbaaaaaaaaaaa
egiccaaaaaaaaaaaabaaaaaadiaaaaahhcaabaaaaaaaaaaaegacbaaaaaaaaaaa
egbcbaaaafaaaaaadcaaaaajhcaabaaaaaaaaaaaegacbaaaacaaaaaaagaabaaa
abaaaaaaegacbaaaaaaaaaaadcaaaaamhccabaaaaaaaaaaajgahbaaaabaaaaaa
aceaaaaaaaaaeaeaaaaaeaeaaaaaeaeaaaaaaaaaegacbaaaaaaaaaaadoaaaaab
"
}

SubProgram "gles " {
Keywords { "DIRECTIONAL" "LIGHTMAP_OFF" "DIRLIGHTMAP_OFF" "SHADOWS_SCREEN" }
"!!GLES"
}

SubProgram "glesdesktop " {
Keywords { "DIRECTIONAL" "LIGHTMAP_OFF" "DIRLIGHTMAP_OFF" "SHADOWS_SCREEN" }
"!!GLES"
}

SubProgram "flash " {
Keywords { "DIRECTIONAL" "LIGHTMAP_OFF" "DIRLIGHTMAP_OFF" "SHADOWS_SCREEN" }
Vector 0 [_LightColor0]
Vector 1 [_Color]
Float 2 [_Cutoff]
SetTexture 0 [_BumpMap] 2D
SetTexture 1 [_MainTex] 2D
SetTexture 2 [_Shade] 2D
SetTexture 3 [_ShadowMapTexture] 2D
"agal_ps
c3 0.0 1.0 2.0 -1.0
c4 0.5 3.0 0.0 0.0
[bc]
ciaaaaaaabaaapacaaaaaaoeaeaaaaaaabaaaaaaafaababb tex r1, v0, s1 <2d wrap linear point>
aaaaaaaaaaaaacacaaaaaappaeaaaaaaaaaaaaaaaaaaaaaa mov r0.y, v0.w
aaaaaaaaaaaaabacaaaaaakkaeaaaaaaaaaaaaaaaaaaaaaa mov r0.x, v0.z
ciaaaaaaaaaaapacaaaaaafeacaaaaaaaaaaaaaaafaababb tex r0, r0.xyyy, s0 <2d wrap linear point>
aaaaaaaaaaaaabacaaaaaappacaaaaaaaaaaaaaaaaaaaaaa mov r0.x, r0.w
adaaaaaaacaaadacaaaaaafeacaaaaaaadaaaakkabaaaaaa mul r2.xy, r0.xyyy, c3.z
abaaaaaaacaaadacacaaaafeacaaaaaaadaaaappabaaaaaa add r2.xy, r2.xyyy, c3.w
adaaaaaaaaaaabacacaaaaffacaaaaaaacaaaaffacaaaaaa mul r0.x, r2.y, r2.y
bfaaaaaaacaaaiacacaaaaaaacaaaaaaaaaaaaaaaaaaaaaa neg r2.w, r2.x
adaaaaaaacaaaiacacaaaappacaaaaaaacaaaaaaacaaaaaa mul r2.w, r2.w, r2.x
acaaaaaaaaaaabacacaaaappacaaaaaaaaaaaaaaacaaaaaa sub r0.x, r2.w, r0.x
abaaaaaaaaaaabacaaaaaaaaacaaaaaaadaaaaffabaaaaaa add r0.x, r0.x, c3.y
akaaaaaaaaaaabacaaaaaaaaacaaaaaaaaaaaaaaaaaaaaaa rsq r0.x, r0.x
afaaaaaaacaaaeacaaaaaaaaacaaaaaaaaaaaaaaaaaaaaaa rcp r2.z, r0.x
acaaaaaaaaaaabacabaaaappacaaaaaaacaaaaoeabaaaaaa sub r0.x, r1.w, c2
ckaaaaaaaaaaabacaaaaaaaaacaaaaaaaeaaaakkabaaaaaa slt r0.x, r0.x, c4.z
bfaaaaaaaaaaapacaaaaaaaaacaaaaaaaaaaaaaaaaaaaaaa neg r0, r0.x
bcaaaaaaadaaabacacaaaakeacaaaaaaabaaaaoeaeaaaaaa dp3 r3.x, r2.xyzz, v1
bcaaaaaaadaaacacacaaaakeacaaaaaaacaaaaoeaeaaaaaa dp3 r3.y, r2.xyzz, v2
bcaaaaaaacaaabacacaaaakeacaaaaaaadaaaaoeaeaaaaaa dp3 r2.x, r2.xyzz, v3
adaaaaaaadaaadacadaaaafeacaaaaaaaeaaaaaaabaaaaaa mul r3.xy, r3.xyyy, c4.x
abaaaaaaadaaadacadaaaafeacaaaaaaaeaaaaaaabaaaaaa add r3.xy, r3.xyyy, c4.x
ahaaaaaaacaaabacacaaaaaaacaaaaaaadaaaaoeabaaaaaa max r2.x, r2.x, c3
ciaaaaaaadaaapacadaaaafeacaaaaaaacaaaaaaafaababb tex r3, r3.xyyy, s2 <2d wrap linear point>
chaaaaaaaaaaaaaaaaaaaaaaacaaaaaaaaaaaaaaaaaaaaaa kil a0.none, r0.x
aeaaaaaaaeaaapacafaaaaoeaeaaaaaaafaaaappaeaaaaaa div r4, v5, v5.w
ciaaaaaaaaaaapacaeaaaafeacaaaaaaadaaaaaaafaababb tex r0, r4.xyyy, s3 <2d wrap linear point>
adaaaaaaadaaahacabaaaakeacaaaaaaadaaaakeacaaaaaa mul r3.xyz, r1.xyzz, r3.xyzz
adaaaaaaadaaahacadaaaakeacaaaaaaabaaaaoeabaaaaaa mul r3.xyz, r3.xyzz, c1
adaaaaaaabaaahacabaaaakeacaaaaaaabaaaappabaaaaaa mul r1.xyz, r1.xyzz, c1.w
adaaaaaaaaaaabacacaaaaaaacaaaaaaaaaaaaaaacaaaaaa mul r0.x, r2.x, r0.x
adaaaaaaacaaahacabaaaakeacaaaaaaaaaaaaoeabaaaaaa mul r2.xyz, r1.xyzz, c0
adaaaaaaadaaahacadaaaakeacaaaaaaaeaaaaffabaaaaaa mul r3.xyz, r3.xyzz, c4.y
adaaaaaaabaaahacabaaaakeacaaaaaaaeaaaaoeaeaaaaaa mul r1.xyz, r1.xyzz, v4
adaaaaaaaaaaahacaaaaaaaaacaaaaaaacaaaakeacaaaaaa mul r0.xyz, r0.x, r2.xyzz
adaaaaaaaaaaahacaaaaaakeacaaaaaaadaaaakkabaaaaaa mul r0.xyz, r0.xyzz, c3.z
abaaaaaaaaaaahacaaaaaakeacaaaaaaabaaaakeacaaaaaa add r0.xyz, r0.xyzz, r1.xyzz
abaaaaaaaaaaahacaaaaaakeacaaaaaaadaaaakeacaaaaaa add r0.xyz, r0.xyzz, r3.xyzz
aaaaaaaaaaaaaiacabaaaappacaaaaaaaaaaaaaaaaaaaaaa mov r0.w, r1.w
aaaaaaaaaaaaapadaaaaaaoeacaaaaaaaaaaaaaaaaaaaaaa mov o0, r0
"
}

SubProgram "opengl " {
Keywords { "DIRECTIONAL" "LIGHTMAP_ON" "DIRLIGHTMAP_OFF" "SHADOWS_SCREEN" }
Vector 0 [_Color]
Float 1 [_Cutoff]
SetTexture 0 [_BumpMap] 2D
SetTexture 1 [_MainTex] 2D
SetTexture 2 [_Shade] 2D
SetTexture 3 [_ShadowMapTexture] 2D
SetTexture 4 [unity_Lightmap] 2D
"!!ARBfp1.0
OPTION ARB_precision_hint_fastest;
# 29 ALU, 5 TEX
PARAM c[4] = { program.local[0..1],
		{ 8, 2, 1, 0.5 },
		{ 3 } };
TEMP R0;
TEMP R1;
TEMP R2;
TEMP R3;
TEMP R4;
TEX R0, fragment.texcoord[0], texture[1], 2D;
TEX R1.yw, fragment.texcoord[0].zwzw, texture[0], 2D;
TXP R4.x, fragment.texcoord[4], texture[3], 2D;
MAD R1.xy, R1.wyzw, c[2].y, -c[2].z;
MUL R1.z, R1.y, R1.y;
MAD R1.z, -R1.x, R1.x, -R1;
SLT R2.z, R0.w, c[1].x;
ADD R1.z, R1, c[2];
RSQ R1.z, R1.z;
RCP R1.z, R1.z;
DP3 R1.w, R1, fragment.texcoord[2];
DP3 R1.z, fragment.texcoord[1], R1;
MAD R2.xy, R1.zwzw, c[2].w, c[2].w;
MOV result.color.w, R0;
TEX R1, fragment.texcoord[3], texture[4], 2D;
KIL -R2.z;
TEX R2.xyz, R2, texture[2], 2D;
MUL R2.xyz, R0, R2;
MUL R3.xyz, R1.w, R1;
MUL R1.xyz, R1, R4.x;
MUL R3.xyz, R3, c[2].x;
MUL R2.xyz, R2, c[0];
MUL R1.xyz, R1, c[2].y;
MUL R4.xyz, R3, R4.x;
MIN R1.xyz, R3, R1;
MAX R1.xyz, R1, R4;
MUL R2.xyz, R2, c[3].x;
MUL R0.xyz, R0, c[0].w;
MAD result.color.xyz, R0, R1, R2;
END
# 29 instructions, 5 R-regs
"
}

SubProgram "d3d9 " {
Keywords { "DIRECTIONAL" "LIGHTMAP_ON" "DIRLIGHTMAP_OFF" "SHADOWS_SCREEN" }
Vector 0 [_Color]
Float 1 [_Cutoff]
SetTexture 0 [_BumpMap] 2D
SetTexture 1 [_MainTex] 2D
SetTexture 2 [_Shade] 2D
SetTexture 3 [_ShadowMapTexture] 2D
SetTexture 4 [unity_Lightmap] 2D
"ps_2_0
; 29 ALU, 6 TEX
dcl_2d s0
dcl_2d s1
dcl_2d s2
dcl_2d s3
dcl_2d s4
def c2, 0.00000000, 1.00000000, 8.00000000, 2.00000000
def c3, 2.00000000, -1.00000000, 0.50000000, 3.00000000
dcl t0
dcl t1.xyz
dcl t2.xyz
dcl t3.xy
dcl t4
texld r1, t0, s1
mov r0.y, t0.w
mov r0.x, t0.z
texld r0, r0, s0
mov r0.x, r0.w
mad_pp r2.xy, r0, c3.x, c3.y
mul_pp r0.x, r2.y, r2.y
mad_pp r0.x, -r2, r2, -r0
add_pp r0.x, r0, c2.y
rsq_pp r0.x, r0.x
rcp_pp r2.z, r0.x
add_pp r0.x, r1.w, -c1
dp3 r3.x, t1, r2
dp3 r3.y, r2, t2
cmp r0.x, r0, c2, c2.y
mov_pp r2, -r0.x
mad_pp r3.xy, r3, c3.z, c3.z
texld r0, r3, s2
texkill r2.xyzw
texldp r2, t4, s3
texld r3, t3, s4
mul r0.xyz, r1, r0
mul_pp r4.xyz, r3.w, r3
mul_pp r3.xyz, r3, r2.x
mul_pp r4.xyz, r4, c2.z
mul r0.xyz, r0, c0
mul_pp r3.xyz, r3, c2.w
mul_pp r2.xyz, r4, r2.x
min_pp r3.xyz, r4, r3
max_pp r2.xyz, r3, r2
mul r0.xyz, r0, c3.w
mul r1.xyz, r1, c0.w
mad_pp r0.xyz, r1, r2, r0
mov_pp r0.w, r1
mov_pp oC0, r0
"
}

SubProgram "d3d11 " {
Keywords { "DIRECTIONAL" "LIGHTMAP_ON" "DIRLIGHTMAP_OFF" "SHADOWS_SCREEN" }
ConstBuffer "$Globals" 192 // 180 used size, 9 vars
Vector 112 [_Color] 4
Float 176 [_Cutoff]
BindCB "$Globals" 0
SetTexture 0 [_BumpMap] 2D 2
SetTexture 1 [_MainTex] 2D 1
SetTexture 2 [_Shade] 2D 3
SetTexture 3 [_ShadowMapTexture] 2D 0
SetTexture 4 [unity_Lightmap] 2D 4
// 30 instructions, 4 temp regs, 0 temp arrays:
// ALU 17 float, 0 int, 0 uint
// TEX 5 (0 load, 0 comp, 0 bias, 0 grad)
// FLOW 1 static, 0 dynamic
"ps_4_0
eefiecedihpgagdohlgbnajaffdfkbmfkhhikhndabaaaaaamiafaaaaadaaaaaa
cmaaaaaaoeaaaaaabiabaaaaejfdeheolaaaaaaaagaaaaaaaiaaaaaajiaaaaaa
aaaaaaaaabaaaaaaadaaaaaaaaaaaaaaapaaaaaakeaaaaaaaaaaaaaaaaaaaaaa
adaaaaaaabaaaaaaapapaaaakeaaaaaaabaaaaaaaaaaaaaaadaaaaaaacaaaaaa
ahahaaaakeaaaaaaacaaaaaaaaaaaaaaadaaaaaaadaaaaaaahahaaaakeaaaaaa
adaaaaaaaaaaaaaaadaaaaaaaeaaaaaaadadaaaakeaaaaaaaeaaaaaaaaaaaaaa
adaaaaaaafaaaaaaapalaaaafdfgfpfaepfdejfeejepeoaafeeffiedepepfcee
aaklklklepfdeheocmaaaaaaabaaaaaaaiaaaaaacaaaaaaaaaaaaaaaaaaaaaaa
adaaaaaaaaaaaaaaapaaaaaafdfgfpfegbhcghgfheaaklklfdeieefckiaeaaaa
eaaaaaaackabaaaafjaaaaaeegiocaaaaaaaaaaaamaaaaaafkaaaaadaagabaaa
aaaaaaaafkaaaaadaagabaaaabaaaaaafkaaaaadaagabaaaacaaaaaafkaaaaad
aagabaaaadaaaaaafkaaaaadaagabaaaaeaaaaaafibiaaaeaahabaaaaaaaaaaa
ffffaaaafibiaaaeaahabaaaabaaaaaaffffaaaafibiaaaeaahabaaaacaaaaaa
ffffaaaafibiaaaeaahabaaaadaaaaaaffffaaaafibiaaaeaahabaaaaeaaaaaa
ffffaaaagcbaaaadpcbabaaaabaaaaaagcbaaaadhcbabaaaacaaaaaagcbaaaad
hcbabaaaadaaaaaagcbaaaaddcbabaaaaeaaaaaagcbaaaadlcbabaaaafaaaaaa
gfaaaaadpccabaaaaaaaaaaagiaaaaacaeaaaaaaefaaaaajpcaabaaaaaaaaaaa
egbabaaaabaaaaaaeghobaaaabaaaaaaaagabaaaabaaaaaaaaaaaaajbcaabaaa
abaaaaaadkaabaaaaaaaaaaaakiacaiaebaaaaaaaaaaaaaaalaaaaaadbaaaaah
bcaabaaaabaaaaaaakaabaaaabaaaaaaabeaaaaaaaaaaaaaanaaaeadakaabaaa
abaaaaaaaoaaaaahdcaabaaaabaaaaaaegbabaaaafaaaaaapgbpbaaaafaaaaaa
efaaaaajpcaabaaaabaaaaaaegaabaaaabaaaaaaeghobaaaadaaaaaaaagabaaa
aaaaaaaaaaaaaaahccaabaaaabaaaaaaakaabaaaabaaaaaaakaabaaaabaaaaaa
efaaaaajpcaabaaaacaaaaaaegbabaaaaeaaaaaaeghobaaaaeaaaaaaaagabaaa
aeaaaaaadiaaaaahocaabaaaabaaaaaafgafbaaaabaaaaaaagajbaaaacaaaaaa
diaaaaahicaabaaaacaaaaaadkaabaaaacaaaaaaabeaaaaaaaaaaaebdiaaaaah
hcaabaaaacaaaaaaegacbaaaacaaaaaapgapbaaaacaaaaaaddaaaaahocaabaaa
abaaaaaafgaobaaaabaaaaaaagajbaaaacaaaaaadiaaaaahhcaabaaaacaaaaaa
agaabaaaabaaaaaaegacbaaaacaaaaaadeaaaaahhcaabaaaabaaaaaajgahbaaa
abaaaaaaegacbaaaacaaaaaaefaaaaajpcaabaaaacaaaaaaogbkbaaaabaaaaaa
eghobaaaaaaaaaaaaagabaaaacaaaaaadcaaaaapdcaabaaaacaaaaaahgapbaaa
acaaaaaaaceaaaaaaaaaaaeaaaaaaaeaaaaaaaaaaaaaaaaaaceaaaaaaaaaialp
aaaaialpaaaaaaaaaaaaaaaadcaaaaakicaabaaaabaaaaaaakaabaiaebaaaaaa
acaaaaaaakaabaaaacaaaaaaabeaaaaaaaaaiadpdcaaaaakicaabaaaabaaaaaa
bkaabaiaebaaaaaaacaaaaaabkaabaaaacaaaaaadkaabaaaabaaaaaaelaaaaaf
ecaabaaaacaaaaaadkaabaaaabaaaaaabaaaaaahbcaabaaaadaaaaaaegbcbaaa
acaaaaaaegacbaaaacaaaaaabaaaaaahccaabaaaadaaaaaaegbcbaaaadaaaaaa
egacbaaaacaaaaaadcaaaaapdcaabaaaacaaaaaaegaabaaaadaaaaaaaceaaaaa
aaaaaadpaaaaaadpaaaaaaaaaaaaaaaaaceaaaaaaaaaaadpaaaaaadpaaaaaaaa
aaaaaaaaefaaaaajpcaabaaaacaaaaaaegaabaaaacaaaaaaeghobaaaacaaaaaa
aagabaaaadaaaaaadiaaaaahhcaabaaaacaaaaaaegacbaaaaaaaaaaaegacbaaa
acaaaaaadiaaaaaihcaabaaaacaaaaaaegacbaaaacaaaaaaegiccaaaaaaaaaaa
ahaaaaaadiaaaaakhcaabaaaacaaaaaaegacbaaaacaaaaaaaceaaaaaaaaaeaea
aaaaeaeaaaaaeaeaaaaaaaaadiaaaaaihcaabaaaaaaaaaaaegacbaaaaaaaaaaa
pgipcaaaaaaaaaaaahaaaaaadgaaaaaficcabaaaaaaaaaaadkaabaaaaaaaaaaa
dcaaaaajhccabaaaaaaaaaaaegacbaaaaaaaaaaaegacbaaaabaaaaaaegacbaaa
acaaaaaadoaaaaab"
}

SubProgram "gles " {
Keywords { "DIRECTIONAL" "LIGHTMAP_ON" "DIRLIGHTMAP_OFF" "SHADOWS_SCREEN" }
"!!GLES"
}

SubProgram "glesdesktop " {
Keywords { "DIRECTIONAL" "LIGHTMAP_ON" "DIRLIGHTMAP_OFF" "SHADOWS_SCREEN" }
"!!GLES"
}

SubProgram "flash " {
Keywords { "DIRECTIONAL" "LIGHTMAP_ON" "DIRLIGHTMAP_OFF" "SHADOWS_SCREEN" }
Vector 0 [_Color]
Float 1 [_Cutoff]
SetTexture 0 [_BumpMap] 2D
SetTexture 1 [_MainTex] 2D
SetTexture 2 [_Shade] 2D
SetTexture 3 [_ShadowMapTexture] 2D
SetTexture 4 [unity_Lightmap] 2D
"agal_ps
c2 0.0 1.0 8.0 2.0
c3 2.0 -1.0 0.5 3.0
[bc]
ciaaaaaaabaaapacaaaaaaoeaeaaaaaaabaaaaaaafaababb tex r1, v0, s1 <2d wrap linear point>
aaaaaaaaaaaaacacaaaaaappaeaaaaaaaaaaaaaaaaaaaaaa mov r0.y, v0.w
aaaaaaaaaaaaabacaaaaaakkaeaaaaaaaaaaaaaaaaaaaaaa mov r0.x, v0.z
ciaaaaaaaaaaapacaaaaaafeacaaaaaaaaaaaaaaafaababb tex r0, r0.xyyy, s0 <2d wrap linear point>
aaaaaaaaaaaaabacaaaaaappacaaaaaaaaaaaaaaaaaaaaaa mov r0.x, r0.w
adaaaaaaacaaadacaaaaaafeacaaaaaaadaaaaaaabaaaaaa mul r2.xy, r0.xyyy, c3.x
abaaaaaaacaaadacacaaaafeacaaaaaaadaaaaffabaaaaaa add r2.xy, r2.xyyy, c3.y
adaaaaaaaaaaabacacaaaaffacaaaaaaacaaaaffacaaaaaa mul r0.x, r2.y, r2.y
bfaaaaaaacaaaiacacaaaaaaacaaaaaaaaaaaaaaaaaaaaaa neg r2.w, r2.x
adaaaaaaacaaaiacacaaaappacaaaaaaacaaaaaaacaaaaaa mul r2.w, r2.w, r2.x
acaaaaaaaaaaabacacaaaappacaaaaaaaaaaaaaaacaaaaaa sub r0.x, r2.w, r0.x
abaaaaaaaaaaabacaaaaaaaaacaaaaaaacaaaaffabaaaaaa add r0.x, r0.x, c2.y
akaaaaaaaaaaabacaaaaaaaaacaaaaaaaaaaaaaaaaaaaaaa rsq r0.x, r0.x
afaaaaaaacaaaeacaaaaaaaaacaaaaaaaaaaaaaaaaaaaaaa rcp r2.z, r0.x
acaaaaaaaaaaabacabaaaappacaaaaaaabaaaaoeabaaaaaa sub r0.x, r1.w, c1
bcaaaaaaadaaabacabaaaaoeaeaaaaaaacaaaakeacaaaaaa dp3 r3.x, v1, r2.xyzz
bcaaaaaaadaaacacacaaaakeacaaaaaaacaaaaoeaeaaaaaa dp3 r3.y, r2.xyzz, v2
ckaaaaaaaaaaabacaaaaaaaaacaaaaaaacaaaaaaabaaaaaa slt r0.x, r0.x, c2.x
bfaaaaaaacaaapacaaaaaaaaacaaaaaaaaaaaaaaaaaaaaaa neg r2, r0.x
adaaaaaaadaaadacadaaaafeacaaaaaaadaaaakkabaaaaaa mul r3.xy, r3.xyyy, c3.z
abaaaaaaadaaadacadaaaafeacaaaaaaadaaaakkabaaaaaa add r3.xy, r3.xyyy, c3.z
ciaaaaaaaaaaapacadaaaafeacaaaaaaacaaaaaaafaababb tex r0, r3.xyyy, s2 <2d wrap linear point>
chaaaaaaaaaaaaaaacaaaaaaacaaaaaaaaaaaaaaaaaaaaaa kil a0.none, r2.x
aeaaaaaaaeaaapacaeaaaaoeaeaaaaaaaeaaaappaeaaaaaa div r4, v4, v4.w
ciaaaaaaacaaapacaeaaaafeacaaaaaaadaaaaaaafaababb tex r2, r4.xyyy, s3 <2d wrap linear point>
ciaaaaaaadaaapacadaaaaoeaeaaaaaaaeaaaaaaafaababb tex r3, v3, s4 <2d wrap linear point>
adaaaaaaaaaaahacabaaaakeacaaaaaaaaaaaakeacaaaaaa mul r0.xyz, r1.xyzz, r0.xyzz
adaaaaaaaeaaahacadaaaappacaaaaaaadaaaakeacaaaaaa mul r4.xyz, r3.w, r3.xyzz
adaaaaaaadaaahacadaaaakeacaaaaaaacaaaaaaacaaaaaa mul r3.xyz, r3.xyzz, r2.x
adaaaaaaaeaaahacaeaaaakeacaaaaaaacaaaakkabaaaaaa mul r4.xyz, r4.xyzz, c2.z
adaaaaaaaaaaahacaaaaaakeacaaaaaaaaaaaaoeabaaaaaa mul r0.xyz, r0.xyzz, c0
adaaaaaaadaaahacadaaaakeacaaaaaaacaaaappabaaaaaa mul r3.xyz, r3.xyzz, c2.w
adaaaaaaacaaahacaeaaaakeacaaaaaaacaaaaaaacaaaaaa mul r2.xyz, r4.xyzz, r2.x
agaaaaaaadaaahacaeaaaakeacaaaaaaadaaaakeacaaaaaa min r3.xyz, r4.xyzz, r3.xyzz
ahaaaaaaacaaahacadaaaakeacaaaaaaacaaaakeacaaaaaa max r2.xyz, r3.xyzz, r2.xyzz
adaaaaaaaaaaahacaaaaaakeacaaaaaaadaaaappabaaaaaa mul r0.xyz, r0.xyzz, c3.w
adaaaaaaabaaahacabaaaakeacaaaaaaaaaaaappabaaaaaa mul r1.xyz, r1.xyzz, c0.w
adaaaaaaacaaahacabaaaakeacaaaaaaacaaaakeacaaaaaa mul r2.xyz, r1.xyzz, r2.xyzz
abaaaaaaaaaaahacacaaaakeacaaaaaaaaaaaakeacaaaaaa add r0.xyz, r2.xyzz, r0.xyzz
aaaaaaaaaaaaaiacabaaaappacaaaaaaaaaaaaaaaaaaaaaa mov r0.w, r1.w
aaaaaaaaaaaaapadaaaaaaoeacaaaaaaaaaaaaaaaaaaaaaa mov o0, r0
"
}

SubProgram "opengl " {
Keywords { "DIRECTIONAL" "LIGHTMAP_ON" "DIRLIGHTMAP_ON" "SHADOWS_SCREEN" }
Vector 0 [_Color]
Float 1 [_Cutoff]
SetTexture 0 [_BumpMap] 2D
SetTexture 1 [_MainTex] 2D
SetTexture 2 [_Shade] 2D
SetTexture 3 [_ShadowMapTexture] 2D
SetTexture 4 [unity_Lightmap] 2D
SetTexture 5 [unity_LightmapInd] 2D
"!!ARBfp1.0
OPTION ARB_precision_hint_fastest;
# 37 ALU, 6 TEX
PARAM c[6] = { program.local[0..1],
		{ 2, 1, 8, 0.5 },
		{ -0.40824828, -0.70710677, 0.57735026, 3 },
		{ -0.40824831, 0.70710677, 0.57735026 },
		{ 0.81649655, 0, 0.57735026 } };
TEMP R0;
TEMP R1;
TEMP R2;
TEMP R3;
TEMP R4;
TEMP R5;
TEX R2, fragment.texcoord[0], texture[1], 2D;
TEX R0.yw, fragment.texcoord[0].zwzw, texture[0], 2D;
TEX R1, fragment.texcoord[3], texture[4], 2D;
TXP R4.x, fragment.texcoord[4], texture[3], 2D;
MAD R4.yz, R0.xwyw, c[2].x, -c[2].y;
MUL R0.x, R4.z, R4.z;
MAD R0.x, -R4.y, R4.y, -R0;
SLT R0.z, R2.w, c[1].x;
ADD R0.x, R0, c[2].y;
RSQ R0.x, R0.x;
RCP R4.w, R0.x;
DP3 R0.y, R4.yzww, fragment.texcoord[2];
DP3 R0.x, R4.yzww, fragment.texcoord[1];
MAD R3.xy, R0, c[2].w, c[2].w;
DP3_SAT R5.z, R4.yzww, c[3];
DP3_SAT R5.x, R4.yzww, c[5];
DP3_SAT R5.y, R4.yzww, c[4];
MOV result.color.w, R2;
KIL -R0.z;
TEX R0, fragment.texcoord[3], texture[5], 2D;
TEX R3.xyz, R3, texture[2], 2D;
MUL R3.xyz, R2, R3;
MUL R0.xyz, R0.w, R0;
MUL R0.xyz, R0, R5;
DP3 R0.w, R0, c[2].z;
MUL R0.xyz, R1.w, R1;
MUL R1.xyz, R1, R4.x;
MUL R0.xyz, R0, R0.w;
MUL R0.xyz, R0, c[2].z;
MUL R1.xyz, R1, c[2].x;
MUL R4.xyz, R0, R4.x;
MIN R0.xyz, R0, R1;
MUL R3.xyz, R3, c[0];
MAX R0.xyz, R0, R4;
MUL R1.xyz, R3, c[3].w;
MUL R2.xyz, R2, c[0].w;
MAD result.color.xyz, R2, R0, R1;
END
# 37 instructions, 6 R-regs
"
}

SubProgram "d3d9 " {
Keywords { "DIRECTIONAL" "LIGHTMAP_ON" "DIRLIGHTMAP_ON" "SHADOWS_SCREEN" }
Vector 0 [_Color]
Float 1 [_Cutoff]
SetTexture 0 [_BumpMap] 2D
SetTexture 1 [_MainTex] 2D
SetTexture 2 [_Shade] 2D
SetTexture 3 [_ShadowMapTexture] 2D
SetTexture 4 [unity_Lightmap] 2D
SetTexture 5 [unity_LightmapInd] 2D
"ps_2_0
; 36 ALU, 7 TEX
dcl_2d s0
dcl_2d s1
dcl_2d s2
dcl_2d s3
dcl_2d s4
dcl_2d s5
def c2, 0.00000000, 1.00000000, 2.00000000, -1.00000000
def c3, -0.40824828, -0.70710677, 0.57735026, 8.00000000
def c4, -0.40824831, 0.70710677, 0.57735026, 0.50000000
def c5, 0.81649655, 0.00000000, 0.57735026, 3.00000000
dcl t0
dcl t1.xyz
dcl t2.xyz
dcl t3.xy
dcl t4
texld r2, t0, s1
texldp r6, t4, s3
mov r0.y, t0.w
mov r0.x, t0.z
texld r0, r0, s0
mov r0.x, r0.w
mad_pp r4.xy, r0, c2.z, c2.w
mul_pp r0.x, r4.y, r4.y
mad_pp r0.x, -r4, r4, -r0
add_pp r0.x, r0, c2.y
rsq_pp r0.x, r0.x
rcp_pp r4.z, r0.x
add_pp r0.x, r2.w, -c1
cmp r0.x, r0, c2, c2.y
mov_pp r0, -r0.x
dp3 r1.x, r4, t1
dp3 r1.y, r4, t2
mad_pp r1.xy, r1, c4.w, c4.w
dp3_pp_sat r5.z, r4, c3
dp3_pp_sat r5.y, r4, c4
dp3_pp_sat r5.x, r4, c5
texld r3, r1, s2
texkill r0.xyzw
texld r1, t3, s4
texld r0, t3, s5
mul_pp r0.xyz, r0.w, r0
mul_pp r0.xyz, r0, r5
mul_pp r4.xyz, r1.w, r1
dp3_pp r0.x, r0, c3.w
mul_pp r0.xyz, r4, r0.x
mul_pp r1.xyz, r1, r6.x
mul r3.xyz, r2, r3
mul_pp r0.xyz, r0, c3.w
mul_pp r1.xyz, r1, c2.z
min_pp r1.xyz, r0, r1
mul_pp r0.xyz, r0, r6.x
max_pp r0.xyz, r1, r0
mul r3.xyz, r3, c0
mul r1.xyz, r3, c5.w
mul r2.xyz, r2, c0.w
mad_pp r0.xyz, r2, r0, r1
mov_pp r0.w, r2
mov_pp oC0, r0
"
}

SubProgram "d3d11 " {
Keywords { "DIRECTIONAL" "LIGHTMAP_ON" "DIRLIGHTMAP_ON" "SHADOWS_SCREEN" }
ConstBuffer "$Globals" 192 // 180 used size, 9 vars
Vector 112 [_Color] 4
Float 176 [_Cutoff]
BindCB "$Globals" 0
SetTexture 0 [_BumpMap] 2D 2
SetTexture 1 [_MainTex] 2D 1
SetTexture 2 [_Shade] 2D 3
SetTexture 3 [_ShadowMapTexture] 2D 0
SetTexture 4 [unity_Lightmap] 2D 4
SetTexture 5 [unity_LightmapInd] 2D 5
// 38 instructions, 5 temp regs, 0 temp arrays:
// ALU 24 float, 0 int, 0 uint
// TEX 6 (0 load, 0 comp, 0 bias, 0 grad)
// FLOW 1 static, 0 dynamic
"ps_4_0
eefiecedhpaphacbaohnfehgbmffclhlcdhokgphabaaaaaapaagaaaaadaaaaaa
cmaaaaaaoeaaaaaabiabaaaaejfdeheolaaaaaaaagaaaaaaaiaaaaaajiaaaaaa
aaaaaaaaabaaaaaaadaaaaaaaaaaaaaaapaaaaaakeaaaaaaaaaaaaaaaaaaaaaa
adaaaaaaabaaaaaaapapaaaakeaaaaaaabaaaaaaaaaaaaaaadaaaaaaacaaaaaa
ahahaaaakeaaaaaaacaaaaaaaaaaaaaaadaaaaaaadaaaaaaahahaaaakeaaaaaa
adaaaaaaaaaaaaaaadaaaaaaaeaaaaaaadadaaaakeaaaaaaaeaaaaaaaaaaaaaa
adaaaaaaafaaaaaaapalaaaafdfgfpfaepfdejfeejepeoaafeeffiedepepfcee
aaklklklepfdeheocmaaaaaaabaaaaaaaiaaaaaacaaaaaaaaaaaaaaaaaaaaaaa
adaaaaaaaaaaaaaaapaaaaaafdfgfpfegbhcghgfheaaklklfdeieefcnaafaaaa
eaaaaaaaheabaaaafjaaaaaeegiocaaaaaaaaaaaamaaaaaafkaaaaadaagabaaa
aaaaaaaafkaaaaadaagabaaaabaaaaaafkaaaaadaagabaaaacaaaaaafkaaaaad
aagabaaaadaaaaaafkaaaaadaagabaaaaeaaaaaafkaaaaadaagabaaaafaaaaaa
fibiaaaeaahabaaaaaaaaaaaffffaaaafibiaaaeaahabaaaabaaaaaaffffaaaa
fibiaaaeaahabaaaacaaaaaaffffaaaafibiaaaeaahabaaaadaaaaaaffffaaaa
fibiaaaeaahabaaaaeaaaaaaffffaaaafibiaaaeaahabaaaafaaaaaaffffaaaa
gcbaaaadpcbabaaaabaaaaaagcbaaaadhcbabaaaacaaaaaagcbaaaadhcbabaaa
adaaaaaagcbaaaaddcbabaaaaeaaaaaagcbaaaadlcbabaaaafaaaaaagfaaaaad
pccabaaaaaaaaaaagiaaaaacafaaaaaaefaaaaajpcaabaaaaaaaaaaaegbabaaa
abaaaaaaeghobaaaabaaaaaaaagabaaaabaaaaaaaaaaaaajbcaabaaaabaaaaaa
dkaabaaaaaaaaaaaakiacaiaebaaaaaaaaaaaaaaalaaaaaadbaaaaahbcaabaaa
abaaaaaaakaabaaaabaaaaaaabeaaaaaaaaaaaaaanaaaeadakaabaaaabaaaaaa
efaaaaajpcaabaaaabaaaaaaegbabaaaaeaaaaaaeghobaaaafaaaaaaaagabaaa
afaaaaaadiaaaaahicaabaaaabaaaaaadkaabaaaabaaaaaaabeaaaaaaaaaaaeb
diaaaaahhcaabaaaabaaaaaaegacbaaaabaaaaaapgapbaaaabaaaaaaefaaaaaj
pcaabaaaacaaaaaaogbkbaaaabaaaaaaeghobaaaaaaaaaaaaagabaaaacaaaaaa
dcaaaaapdcaabaaaacaaaaaahgapbaaaacaaaaaaaceaaaaaaaaaaaeaaaaaaaea
aaaaaaaaaaaaaaaaaceaaaaaaaaaialpaaaaialpaaaaaaaaaaaaaaaadcaaaaak
icaabaaaabaaaaaaakaabaiaebaaaaaaacaaaaaaakaabaaaacaaaaaaabeaaaaa
aaaaiadpdcaaaaakicaabaaaabaaaaaabkaabaiaebaaaaaaacaaaaaabkaabaaa
acaaaaaadkaabaaaabaaaaaaelaaaaafecaabaaaacaaaaaadkaabaaaabaaaaaa
apcaaaakbcaabaaaadaaaaaaaceaaaaaolaffbdpdkmnbddpaaaaaaaaaaaaaaaa
igaabaaaacaaaaaabacaaaakccaabaaaadaaaaaaaceaaaaaomafnblopdaedfdp
dkmnbddpaaaaaaaaegacbaaaacaaaaaabacaaaakecaabaaaadaaaaaaaceaaaaa
olafnblopdaedflpdkmnbddpaaaaaaaaegacbaaaacaaaaaabaaaaaahbcaabaaa
abaaaaaaegacbaaaadaaaaaaegacbaaaabaaaaaaefaaaaajpcaabaaaadaaaaaa
egbabaaaaeaaaaaaeghobaaaaeaaaaaaaagabaaaaeaaaaaadiaaaaahccaabaaa
abaaaaaadkaabaaaadaaaaaaabeaaaaaaaaaaaebdiaaaaahocaabaaaabaaaaaa
agajbaaaadaaaaaafgafbaaaabaaaaaadiaaaaahhcaabaaaabaaaaaaagaabaaa
abaaaaaajgahbaaaabaaaaaaaoaaaaahdcaabaaaaeaaaaaaegbabaaaafaaaaaa
pgbpbaaaafaaaaaaefaaaaajpcaabaaaaeaaaaaaegaabaaaaeaaaaaaeghobaaa
adaaaaaaaagabaaaaaaaaaaaaaaaaaahicaabaaaabaaaaaaakaabaaaaeaaaaaa
akaabaaaaeaaaaaadiaaaaahhcaabaaaaeaaaaaaegacbaaaabaaaaaaagaabaaa
aeaaaaaadiaaaaahhcaabaaaadaaaaaaegacbaaaadaaaaaapgapbaaaabaaaaaa
ddaaaaahhcaabaaaabaaaaaaegacbaaaabaaaaaaegacbaaaadaaaaaadeaaaaah
hcaabaaaabaaaaaaegacbaaaaeaaaaaaegacbaaaabaaaaaabaaaaaahbcaabaaa
adaaaaaaegbcbaaaacaaaaaaegacbaaaacaaaaaabaaaaaahccaabaaaadaaaaaa
egbcbaaaadaaaaaaegacbaaaacaaaaaadcaaaaapdcaabaaaacaaaaaaegaabaaa
adaaaaaaaceaaaaaaaaaaadpaaaaaadpaaaaaaaaaaaaaaaaaceaaaaaaaaaaadp
aaaaaadpaaaaaaaaaaaaaaaaefaaaaajpcaabaaaacaaaaaaegaabaaaacaaaaaa
eghobaaaacaaaaaaaagabaaaadaaaaaadiaaaaahhcaabaaaacaaaaaaegacbaaa
aaaaaaaaegacbaaaacaaaaaadiaaaaaihcaabaaaacaaaaaaegacbaaaacaaaaaa
egiccaaaaaaaaaaaahaaaaaadiaaaaakhcaabaaaacaaaaaaegacbaaaacaaaaaa
aceaaaaaaaaaeaeaaaaaeaeaaaaaeaeaaaaaaaaadiaaaaaihcaabaaaaaaaaaaa
egacbaaaaaaaaaaapgipcaaaaaaaaaaaahaaaaaadgaaaaaficcabaaaaaaaaaaa
dkaabaaaaaaaaaaadcaaaaajhccabaaaaaaaaaaaegacbaaaaaaaaaaaegacbaaa
abaaaaaaegacbaaaacaaaaaadoaaaaab"
}

SubProgram "gles " {
Keywords { "DIRECTIONAL" "LIGHTMAP_ON" "DIRLIGHTMAP_ON" "SHADOWS_SCREEN" }
"!!GLES"
}

SubProgram "glesdesktop " {
Keywords { "DIRECTIONAL" "LIGHTMAP_ON" "DIRLIGHTMAP_ON" "SHADOWS_SCREEN" }
"!!GLES"
}

SubProgram "flash " {
Keywords { "DIRECTIONAL" "LIGHTMAP_ON" "DIRLIGHTMAP_ON" "SHADOWS_SCREEN" }
Vector 0 [_Color]
Float 1 [_Cutoff]
SetTexture 0 [_BumpMap] 2D
SetTexture 1 [_MainTex] 2D
SetTexture 2 [_Shade] 2D
SetTexture 3 [_ShadowMapTexture] 2D
SetTexture 4 [unity_Lightmap] 2D
SetTexture 5 [unity_LightmapInd] 2D
"agal_ps
c2 0.0 1.0 2.0 -1.0
c3 -0.408248 -0.707107 0.57735 8.0
c4 -0.408248 0.707107 0.57735 0.5
c5 0.816497 0.0 0.57735 3.0
[bc]
ciaaaaaaacaaapacaaaaaaoeaeaaaaaaabaaaaaaafaababb tex r2, v0, s1 <2d wrap linear point>
aeaaaaaaaaaaapacaeaaaaoeaeaaaaaaaeaaaappaeaaaaaa div r0, v4, v4.w
ciaaaaaaagaaapacaaaaaafeacaaaaaaadaaaaaaafaababb tex r6, r0.xyyy, s3 <2d wrap linear point>
aaaaaaaaaaaaacacaaaaaappaeaaaaaaaaaaaaaaaaaaaaaa mov r0.y, v0.w
aaaaaaaaaaaaabacaaaaaakkaeaaaaaaaaaaaaaaaaaaaaaa mov r0.x, v0.z
ciaaaaaaaaaaapacaaaaaafeacaaaaaaaaaaaaaaafaababb tex r0, r0.xyyy, s0 <2d wrap linear point>
aaaaaaaaaaaaabacaaaaaappacaaaaaaaaaaaaaaaaaaaaaa mov r0.x, r0.w
adaaaaaaaeaaadacaaaaaafeacaaaaaaacaaaakkabaaaaaa mul r4.xy, r0.xyyy, c2.z
abaaaaaaaeaaadacaeaaaafeacaaaaaaacaaaappabaaaaaa add r4.xy, r4.xyyy, c2.w
adaaaaaaaaaaabacaeaaaaffacaaaaaaaeaaaaffacaaaaaa mul r0.x, r4.y, r4.y
bfaaaaaaabaaabacaeaaaaaaacaaaaaaaaaaaaaaaaaaaaaa neg r1.x, r4.x
adaaaaaaabaaabacabaaaaaaacaaaaaaaeaaaaaaacaaaaaa mul r1.x, r1.x, r4.x
acaaaaaaaaaaabacabaaaaaaacaaaaaaaaaaaaaaacaaaaaa sub r0.x, r1.x, r0.x
abaaaaaaaaaaabacaaaaaaaaacaaaaaaacaaaaffabaaaaaa add r0.x, r0.x, c2.y
akaaaaaaaaaaabacaaaaaaaaacaaaaaaaaaaaaaaaaaaaaaa rsq r0.x, r0.x
afaaaaaaaeaaaeacaaaaaaaaacaaaaaaaaaaaaaaaaaaaaaa rcp r4.z, r0.x
acaaaaaaaaaaabacacaaaappacaaaaaaabaaaaoeabaaaaaa sub r0.x, r2.w, c1
ckaaaaaaaaaaabacaaaaaaaaacaaaaaaafaaaaffabaaaaaa slt r0.x, r0.x, c5.y
bfaaaaaaaaaaapacaaaaaaaaacaaaaaaaaaaaaaaaaaaaaaa neg r0, r0.x
bcaaaaaaabaaabacaeaaaakeacaaaaaaabaaaaoeaeaaaaaa dp3 r1.x, r4.xyzz, v1
bcaaaaaaabaaacacaeaaaakeacaaaaaaacaaaaoeaeaaaaaa dp3 r1.y, r4.xyzz, v2
adaaaaaaabaaadacabaaaafeacaaaaaaaeaaaappabaaaaaa mul r1.xy, r1.xyyy, c4.w
abaaaaaaabaaadacabaaaafeacaaaaaaaeaaaappabaaaaaa add r1.xy, r1.xyyy, c4.w
bcaaaaaaafaaaeacaeaaaakeacaaaaaaadaaaaoeabaaaaaa dp3 r5.z, r4.xyzz, c3
bgaaaaaaafaaaeacafaaaakkacaaaaaaaaaaaaaaaaaaaaaa sat r5.z, r5.z
bcaaaaaaafaaacacaeaaaakeacaaaaaaaeaaaaoeabaaaaaa dp3 r5.y, r4.xyzz, c4
bgaaaaaaafaaacacafaaaaffacaaaaaaaaaaaaaaaaaaaaaa sat r5.y, r5.y
bcaaaaaaafaaabacaeaaaakeacaaaaaaafaaaaoeabaaaaaa dp3 r5.x, r4.xyzz, c5
bgaaaaaaafaaabacafaaaaaaacaaaaaaaaaaaaaaaaaaaaaa sat r5.x, r5.x
ciaaaaaaadaaapacabaaaafeacaaaaaaacaaaaaaafaababb tex r3, r1.xyyy, s2 <2d wrap linear point>
chaaaaaaaaaaaaaaaaaaaaaaacaaaaaaaaaaaaaaaaaaaaaa kil a0.none, r0.x
ciaaaaaaabaaapacadaaaaoeaeaaaaaaaeaaaaaaafaababb tex r1, v3, s4 <2d wrap linear point>
ciaaaaaaaaaaapacadaaaaoeaeaaaaaaafaaaaaaafaababb tex r0, v3, s5 <2d wrap linear point>
adaaaaaaaaaaahacaaaaaappacaaaaaaaaaaaakeacaaaaaa mul r0.xyz, r0.w, r0.xyzz
adaaaaaaaaaaahacaaaaaakeacaaaaaaafaaaakeacaaaaaa mul r0.xyz, r0.xyzz, r5.xyzz
adaaaaaaaeaaahacabaaaappacaaaaaaabaaaakeacaaaaaa mul r4.xyz, r1.w, r1.xyzz
bcaaaaaaaaaaabacaaaaaakeacaaaaaaadaaaappabaaaaaa dp3 r0.x, r0.xyzz, c3.w
adaaaaaaaaaaahacaeaaaakeacaaaaaaaaaaaaaaacaaaaaa mul r0.xyz, r4.xyzz, r0.x
adaaaaaaabaaahacabaaaakeacaaaaaaagaaaaaaacaaaaaa mul r1.xyz, r1.xyzz, r6.x
adaaaaaaadaaahacacaaaakeacaaaaaaadaaaakeacaaaaaa mul r3.xyz, r2.xyzz, r3.xyzz
adaaaaaaaaaaahacaaaaaakeacaaaaaaadaaaappabaaaaaa mul r0.xyz, r0.xyzz, c3.w
adaaaaaaabaaahacabaaaakeacaaaaaaacaaaakkabaaaaaa mul r1.xyz, r1.xyzz, c2.z
agaaaaaaabaaahacaaaaaakeacaaaaaaabaaaakeacaaaaaa min r1.xyz, r0.xyzz, r1.xyzz
adaaaaaaaaaaahacaaaaaakeacaaaaaaagaaaaaaacaaaaaa mul r0.xyz, r0.xyzz, r6.x
ahaaaaaaaaaaahacabaaaakeacaaaaaaaaaaaakeacaaaaaa max r0.xyz, r1.xyzz, r0.xyzz
adaaaaaaadaaahacadaaaakeacaaaaaaaaaaaaoeabaaaaaa mul r3.xyz, r3.xyzz, c0
adaaaaaaabaaahacadaaaakeacaaaaaaafaaaappabaaaaaa mul r1.xyz, r3.xyzz, c5.w
adaaaaaaacaaahacacaaaakeacaaaaaaaaaaaappabaaaaaa mul r2.xyz, r2.xyzz, c0.w
adaaaaaaaaaaahacacaaaakeacaaaaaaaaaaaakeacaaaaaa mul r0.xyz, r2.xyzz, r0.xyzz
abaaaaaaaaaaahacaaaaaakeacaaaaaaabaaaakeacaaaaaa add r0.xyz, r0.xyzz, r1.xyzz
aaaaaaaaaaaaaiacacaaaappacaaaaaaaaaaaaaaaaaaaaaa mov r0.w, r2.w
aaaaaaaaaaaaapadaaaaaaoeacaaaaaaaaaaaaaaaaaaaaaa mov o0, r0
"
}

}
	}
	Pass {
		Name "FORWARD"
		Tags { "LightMode" = "ForwardAdd" }
		ZWrite Off Blend One One Fog { Color (0,0,0,0) }
		ColorMask RGB
Program "vp" {
// Vertex combos: 5
//   opengl - ALU: 23 to 32
//   d3d9 - ALU: 26 to 35
//   d3d11 - ALU: 13 to 15, TEX: 0 to 0, FLOW: 1 to 1
//   d3d11_9x - ALU: 13 to 15, TEX: 0 to 0, FLOW: 1 to 1
SubProgram "opengl " {
Keywords { "POINT" }
Bind "vertex" Vertex
Bind "tangent" ATTR14
Bind "normal" Normal
Bind "texcoord" TexCoord0
Vector 21 [_WorldSpaceLightPos0]
Matrix 9 [_Object2World]
Matrix 13 [_World2Object]
Vector 22 [unity_Scale]
Matrix 17 [_LightMatrix0]
Vector 23 [_MainTex_ST]
Vector 24 [_BumpMap_ST]
"!!ARBvp1.0
# 31 ALU
PARAM c[25] = { program.local[0],
		state.matrix.mvp,
		state.matrix.modelview[0].invtrans,
		program.local[9..24] };
TEMP R0;
TEMP R1;
TEMP R2;
MOV R0.xyz, vertex.attrib[14];
MUL R2.xyz, vertex.normal.zxyw, R0.yzxw;
MAD R0.xyz, vertex.normal.yzxw, R0.zxyw, -R2;
MOV R1, c[21];
MUL R0.xyz, R0, vertex.attrib[14].w;
DP3 result.texcoord[1].y, R0, c[5];
DP3 result.texcoord[2].y, R0, c[6];
DP4 R0.w, vertex.position, c[12];
DP4 R2.z, R1, c[15];
DP4 R2.x, R1, c[13];
DP4 R2.y, R1, c[14];
MAD R1.xyz, R2, c[22].w, -vertex.position;
DP3 result.texcoord[3].y, R0, R1;
DP4 R0.z, vertex.position, c[11];
DP4 R0.x, vertex.position, c[9];
DP4 R0.y, vertex.position, c[10];
DP3 result.texcoord[3].z, vertex.normal, R1;
DP3 result.texcoord[3].x, vertex.attrib[14], R1;
DP4 result.texcoord[4].z, R0, c[19];
DP4 result.texcoord[4].y, R0, c[18];
DP4 result.texcoord[4].x, R0, c[17];
MAD result.texcoord[0].zw, vertex.texcoord[0].xyxy, c[24].xyxy, c[24];
MAD result.texcoord[0].xy, vertex.texcoord[0], c[23], c[23].zwzw;
DP4 result.position.w, vertex.position, c[4];
DP4 result.position.z, vertex.position, c[3];
DP4 result.position.y, vertex.position, c[2];
DP4 result.position.x, vertex.position, c[1];
DP3 result.texcoord[1].z, vertex.normal, c[5];
DP3 result.texcoord[1].x, vertex.attrib[14], c[5];
DP3 result.texcoord[2].z, vertex.normal, c[6];
DP3 result.texcoord[2].x, vertex.attrib[14], c[6];
END
# 31 instructions, 3 R-regs
"
}

SubProgram "d3d9 " {
Keywords { "POINT" }
Bind "vertex" Vertex
Bind "tangent" TexCoord2
Bind "normal" Normal
Bind "texcoord" TexCoord0
Matrix 0 [glstate_matrix_mvp]
Matrix 4 [glstate_matrix_invtrans_modelview0]
Vector 20 [_WorldSpaceLightPos0]
Matrix 8 [_Object2World]
Matrix 12 [_World2Object]
Vector 21 [unity_Scale]
Matrix 16 [_LightMatrix0]
Vector 22 [_MainTex_ST]
Vector 23 [_BumpMap_ST]
"vs_2_0
; 34 ALU
dcl_position0 v0
dcl_tangent0 v1
dcl_normal0 v2
dcl_texcoord0 v3
mov r1.xyz, v1
mov r0, c14
mul r2.xyz, v2.zxyw, r1.yzxw
mov r1.xyz, v1
mad r2.xyz, v2.yzxw, r1.zxyw, -r2
dp4 r3.z, c20, r0
mov r0, c13
mov r1, c12
dp4 r3.x, c20, r1
mul r1.xyz, r2, v1.w
dp4 r3.y, c20, r0
mad r0.xyz, r3, c21.w, -v0
dp3 oT3.y, r1, r0
dp3 oT3.z, v2, r0
dp3 oT3.x, v1, r0
dp4 r0.w, v0, c11
dp4 r0.z, v0, c10
dp4 r0.x, v0, c8
dp4 r0.y, v0, c9
dp3 oT1.y, r1, c4
dp3 oT2.y, r1, c5
dp4 oT4.z, r0, c18
dp4 oT4.y, r0, c17
dp4 oT4.x, r0, c16
mad oT0.zw, v3.xyxy, c23.xyxy, c23
mad oT0.xy, v3, c22, c22.zwzw
dp4 oPos.w, v0, c3
dp4 oPos.z, v0, c2
dp4 oPos.y, v0, c1
dp4 oPos.x, v0, c0
dp3 oT1.z, v2, c4
dp3 oT1.x, v1, c4
dp3 oT2.z, v2, c5
dp3 oT2.x, v1, c5
"
}

SubProgram "d3d11 " {
Keywords { "POINT" }
Bind "vertex" Vertex
Bind "tangent" TexCoord2
Bind "normal" Normal
Bind "texcoord" TexCoord0
Bind "color" Color
ConstBuffer "$Globals" 176 // 160 used size, 8 vars
Matrix 48 [_LightMatrix0] 4
Vector 128 [_MainTex_ST] 4
Vector 144 [_BumpMap_ST] 4
ConstBuffer "UnityLighting" 400 // 16 used size, 16 vars
Vector 0 [_WorldSpaceLightPos0] 4
ConstBuffer "UnityPerDraw" 336 // 336 used size, 6 vars
Matrix 0 [glstate_matrix_mvp] 4
Matrix 128 [glstate_matrix_invtrans_modelview0] 4
Matrix 192 [_Object2World] 4
Matrix 256 [_World2Object] 4
Vector 320 [unity_Scale] 4
BindCB "$Globals" 0
BindCB "UnityLighting" 1
BindCB "UnityPerDraw" 2
// 38 instructions, 2 temp regs, 0 temp arrays:
// ALU 15 float, 0 int, 0 uint
// TEX 0 (0 load, 0 comp, 0 bias, 0 grad)
// FLOW 1 static, 0 dynamic
"vs_4_0
eefiecedcgnmejllegcfldjpgekbfegnpkfoniddabaaaaaafeahaaaaadaaaaaa
cmaaaaaapeaaaaaakmabaaaaejfdeheomaaaaaaaagaaaaaaaiaaaaaajiaaaaaa
aaaaaaaaaaaaaaaaadaaaaaaaaaaaaaaapapaaaakbaaaaaaaaaaaaaaaaaaaaaa
adaaaaaaabaaaaaaapapaaaakjaaaaaaaaaaaaaaaaaaaaaaadaaaaaaacaaaaaa
ahahaaaalaaaaaaaaaaaaaaaaaaaaaaaadaaaaaaadaaaaaaapadaaaalaaaaaaa
abaaaaaaaaaaaaaaadaaaaaaaeaaaaaaapaaaaaaljaaaaaaaaaaaaaaaaaaaaaa
adaaaaaaafaaaaaaapaaaaaafaepfdejfeejepeoaafeebeoehefeofeaaeoepfc
enebemaafeeffiedepepfceeaaedepemepfcaaklepfdeheolaaaaaaaagaaaaaa
aiaaaaaajiaaaaaaaaaaaaaaabaaaaaaadaaaaaaaaaaaaaaapaaaaaakeaaaaaa
aaaaaaaaaaaaaaaaadaaaaaaabaaaaaaapaaaaaakeaaaaaaabaaaaaaaaaaaaaa
adaaaaaaacaaaaaaahaiaaaakeaaaaaaacaaaaaaaaaaaaaaadaaaaaaadaaaaaa
ahaiaaaakeaaaaaaadaaaaaaaaaaaaaaadaaaaaaaeaaaaaaahaiaaaakeaaaaaa
aeaaaaaaaaaaaaaaadaaaaaaafaaaaaaahaiaaaafdfgfpfaepfdejfeejepeoaa
feeffiedepepfceeaaklklklfdeieefckaafaaaaeaaaabaagiabaaaafjaaaaae
egiocaaaaaaaaaaaakaaaaaafjaaaaaeegiocaaaabaaaaaaabaaaaaafjaaaaae
egiocaaaacaaaaaabfaaaaaafpaaaaadpcbabaaaaaaaaaaafpaaaaadpcbabaaa
abaaaaaafpaaaaadhcbabaaaacaaaaaafpaaaaaddcbabaaaadaaaaaaghaaaaae
pccabaaaaaaaaaaaabaaaaaagfaaaaadpccabaaaabaaaaaagfaaaaadhccabaaa
acaaaaaagfaaaaadhccabaaaadaaaaaagfaaaaadhccabaaaaeaaaaaagfaaaaad
hccabaaaafaaaaaagiaaaaacacaaaaaadiaaaaaipcaabaaaaaaaaaaafgbfbaaa
aaaaaaaaegiocaaaacaaaaaaabaaaaaadcaaaaakpcaabaaaaaaaaaaaegiocaaa
acaaaaaaaaaaaaaaagbabaaaaaaaaaaaegaobaaaaaaaaaaadcaaaaakpcaabaaa
aaaaaaaaegiocaaaacaaaaaaacaaaaaakgbkbaaaaaaaaaaaegaobaaaaaaaaaaa
dcaaaaakpccabaaaaaaaaaaaegiocaaaacaaaaaaadaaaaaapgbpbaaaaaaaaaaa
egaobaaaaaaaaaaadcaaaaaldccabaaaabaaaaaaegbabaaaadaaaaaaegiacaaa
aaaaaaaaaiaaaaaaogikcaaaaaaaaaaaaiaaaaaadcaaaaalmccabaaaabaaaaaa
agbebaaaadaaaaaaagiecaaaaaaaaaaaajaaaaaakgiocaaaaaaaaaaaajaaaaaa
diaaaaahhcaabaaaaaaaaaaajgbebaaaabaaaaaacgbjbaaaacaaaaaadcaaaaak
hcaabaaaaaaaaaaajgbebaaaacaaaaaacgbjbaaaabaaaaaaegacbaiaebaaaaaa
aaaaaaaadiaaaaahhcaabaaaaaaaaaaaegacbaaaaaaaaaaapgbpbaaaabaaaaaa
dgaaaaagbcaabaaaabaaaaaaakiacaaaacaaaaaaaiaaaaaadgaaaaagccaabaaa
abaaaaaaakiacaaaacaaaaaaajaaaaaadgaaaaagecaabaaaabaaaaaaakiacaaa
acaaaaaaakaaaaaabaaaaaahcccabaaaacaaaaaaegacbaaaaaaaaaaaegacbaaa
abaaaaaabaaaaaahbccabaaaacaaaaaaegbcbaaaabaaaaaaegacbaaaabaaaaaa
baaaaaaheccabaaaacaaaaaaegbcbaaaacaaaaaaegacbaaaabaaaaaadgaaaaag
bcaabaaaabaaaaaabkiacaaaacaaaaaaaiaaaaaadgaaaaagccaabaaaabaaaaaa
bkiacaaaacaaaaaaajaaaaaadgaaaaagecaabaaaabaaaaaabkiacaaaacaaaaaa
akaaaaaabaaaaaahcccabaaaadaaaaaaegacbaaaaaaaaaaaegacbaaaabaaaaaa
baaaaaahbccabaaaadaaaaaaegbcbaaaabaaaaaaegacbaaaabaaaaaabaaaaaah
eccabaaaadaaaaaaegbcbaaaacaaaaaaegacbaaaabaaaaaadiaaaaajhcaabaaa
abaaaaaafgifcaaaabaaaaaaaaaaaaaaegiccaaaacaaaaaabbaaaaaadcaaaaal
hcaabaaaabaaaaaaegiccaaaacaaaaaabaaaaaaaagiacaaaabaaaaaaaaaaaaaa
egacbaaaabaaaaaadcaaaaalhcaabaaaabaaaaaaegiccaaaacaaaaaabcaaaaaa
kgikcaaaabaaaaaaaaaaaaaaegacbaaaabaaaaaadcaaaaalhcaabaaaabaaaaaa
egiccaaaacaaaaaabdaaaaaapgipcaaaabaaaaaaaaaaaaaaegacbaaaabaaaaaa
dcaaaaalhcaabaaaabaaaaaaegacbaaaabaaaaaapgipcaaaacaaaaaabeaaaaaa
egbcbaiaebaaaaaaaaaaaaaabaaaaaahcccabaaaaeaaaaaaegacbaaaaaaaaaaa
egacbaaaabaaaaaabaaaaaahbccabaaaaeaaaaaaegbcbaaaabaaaaaaegacbaaa
abaaaaaabaaaaaaheccabaaaaeaaaaaaegbcbaaaacaaaaaaegacbaaaabaaaaaa
diaaaaaipcaabaaaaaaaaaaafgbfbaaaaaaaaaaaegiocaaaacaaaaaaanaaaaaa
dcaaaaakpcaabaaaaaaaaaaaegiocaaaacaaaaaaamaaaaaaagbabaaaaaaaaaaa
egaobaaaaaaaaaaadcaaaaakpcaabaaaaaaaaaaaegiocaaaacaaaaaaaoaaaaaa
kgbkbaaaaaaaaaaaegaobaaaaaaaaaaadcaaaaakpcaabaaaaaaaaaaaegiocaaa
acaaaaaaapaaaaaapgbpbaaaaaaaaaaaegaobaaaaaaaaaaadiaaaaaihcaabaaa
abaaaaaafgafbaaaaaaaaaaaegiccaaaaaaaaaaaaeaaaaaadcaaaaakhcaabaaa
abaaaaaaegiccaaaaaaaaaaaadaaaaaaagaabaaaaaaaaaaaegacbaaaabaaaaaa
dcaaaaakhcaabaaaaaaaaaaaegiccaaaaaaaaaaaafaaaaaakgakbaaaaaaaaaaa
egacbaaaabaaaaaadcaaaaakhccabaaaafaaaaaaegiccaaaaaaaaaaaagaaaaaa
pgapbaaaaaaaaaaaegacbaaaaaaaaaaadoaaaaab"
}

SubProgram "gles " {
Keywords { "POINT" }
"!!GLES
#define SHADER_API_GLES 1
#define tex2D texture2D


#ifdef VERTEX
#define gl_ModelViewProjectionMatrix glstate_matrix_mvp
uniform mat4 glstate_matrix_mvp;
#define gl_ModelViewMatrixInverseTranspose glstate_matrix_invtrans_modelview0
uniform mat4 glstate_matrix_invtrans_modelview0;
#define gl_ModelViewMatrix glstate_matrix_modelview0
uniform mat4 glstate_matrix_modelview0;

varying highp vec3 xlv_TEXCOORD4;
varying mediump vec3 xlv_TEXCOORD3;
varying highp vec3 xlv_TEXCOORD2;
varying highp vec3 xlv_TEXCOORD1;
varying highp vec4 xlv_TEXCOORD0;
uniform highp vec4 _BumpMap_ST;
uniform highp vec4 _MainTex_ST;
uniform highp mat4 _LightMatrix0;
uniform highp vec4 unity_Scale;
uniform highp mat4 _World2Object;
uniform highp mat4 _Object2World;


uniform highp vec4 _WorldSpaceLightPos0;
attribute vec4 _glesTANGENT;
attribute vec4 _glesMultiTexCoord0;
attribute vec3 _glesNormal;
attribute vec4 _glesVertex;
void main ()
{
  vec4 tmpvar_1;
  tmpvar_1.xyz = normalize(_glesTANGENT.xyz);
  tmpvar_1.w = _glesTANGENT.w;
  vec3 tmpvar_2;
  tmpvar_2 = normalize(_glesNormal);
  highp vec4 tmpvar_3;
  mediump vec3 tmpvar_4;
  highp vec3 tmpvar_5;
  highp vec3 tmpvar_6;
  tmpvar_5 = tmpvar_1.xyz;
  tmpvar_6 = (((tmpvar_2.yzx * tmpvar_1.zxy) - (tmpvar_2.zxy * tmpvar_1.yzx)) * _glesTANGENT.w);
  highp mat3 tmpvar_7;
  tmpvar_7[0].x = tmpvar_5.x;
  tmpvar_7[0].y = tmpvar_6.x;
  tmpvar_7[0].z = tmpvar_2.x;
  tmpvar_7[1].x = tmpvar_5.y;
  tmpvar_7[1].y = tmpvar_6.y;
  tmpvar_7[1].z = tmpvar_2.y;
  tmpvar_7[2].x = tmpvar_5.z;
  tmpvar_7[2].y = tmpvar_6.z;
  tmpvar_7[2].z = tmpvar_2.z;
  vec4 v_8;
  v_8.x = gl_ModelViewMatrixInverseTranspose[0].x;
  v_8.y = gl_ModelViewMatrixInverseTranspose[1].x;
  v_8.z = gl_ModelViewMatrixInverseTranspose[2].x;
  v_8.w = gl_ModelViewMatrixInverseTranspose[3].x;
  vec4 v_9;
  v_9.x = gl_ModelViewMatrixInverseTranspose[0].y;
  v_9.y = gl_ModelViewMatrixInverseTranspose[1].y;
  v_9.z = gl_ModelViewMatrixInverseTranspose[2].y;
  v_9.w = gl_ModelViewMatrixInverseTranspose[3].y;
  tmpvar_3.xy = ((_glesMultiTexCoord0.xy * _MainTex_ST.xy) + _MainTex_ST.zw);
  tmpvar_3.zw = ((_glesMultiTexCoord0.xy * _BumpMap_ST.xy) + _BumpMap_ST.zw);
  highp vec3 tmpvar_10;
  highp vec3 tmpvar_11;
  tmpvar_10 = tmpvar_1.xyz;
  tmpvar_11 = (((tmpvar_2.yzx * tmpvar_1.zxy) - (tmpvar_2.zxy * tmpvar_1.yzx)) * _glesTANGENT.w);
  highp mat3 tmpvar_12;
  tmpvar_12[0].x = tmpvar_10.x;
  tmpvar_12[0].y = tmpvar_11.x;
  tmpvar_12[0].z = tmpvar_2.x;
  tmpvar_12[1].x = tmpvar_10.y;
  tmpvar_12[1].y = tmpvar_11.y;
  tmpvar_12[1].z = tmpvar_2.y;
  tmpvar_12[2].x = tmpvar_10.z;
  tmpvar_12[2].y = tmpvar_11.z;
  tmpvar_12[2].z = tmpvar_2.z;
  highp vec3 tmpvar_13;
  tmpvar_13 = (tmpvar_12 * (((_World2Object * _WorldSpaceLightPos0).xyz * unity_Scale.w) - _glesVertex.xyz));
  tmpvar_4 = tmpvar_13;
  gl_Position = (gl_ModelViewProjectionMatrix * _glesVertex);
  xlv_TEXCOORD0 = tmpvar_3;
  xlv_TEXCOORD1 = (tmpvar_7 * v_8.xyz);
  xlv_TEXCOORD2 = (tmpvar_7 * v_9.xyz);
  xlv_TEXCOORD3 = tmpvar_4;
  xlv_TEXCOORD4 = (_LightMatrix0 * (_Object2World * _glesVertex)).xyz;
}



#endif
#ifdef FRAGMENT

varying highp vec3 xlv_TEXCOORD4;
varying mediump vec3 xlv_TEXCOORD3;
varying highp vec4 xlv_TEXCOORD0;
uniform lowp float _Cutoff;
uniform sampler2D _BumpMap;
uniform sampler2D _MainTex;
uniform lowp vec4 _Color;
uniform sampler2D _LightTexture0;
uniform lowp vec4 _LightColor0;
void main ()
{
  lowp vec4 c_1;
  lowp vec3 lightDir_2;
  lowp vec4 tmpvar_3;
  tmpvar_3 = texture2D (_MainTex, xlv_TEXCOORD0.xy);
  lowp float tmpvar_4;
  tmpvar_4 = tmpvar_3.w;
  lowp float x_5;
  x_5 = (tmpvar_3.w - _Cutoff);
  if ((x_5 < 0.0)) {
    discard;
  };
  mediump vec3 tmpvar_6;
  tmpvar_6 = normalize(xlv_TEXCOORD3);
  lightDir_2 = tmpvar_6;
  highp float tmpvar_7;
  tmpvar_7 = dot (xlv_TEXCOORD4, xlv_TEXCOORD4);
  lowp vec4 c_8;
  c_8.xyz = (((texture2D (_MainTex, xlv_TEXCOORD0.xy).xyz * _Color.w) * _LightColor0.xyz) * ((max (0.0, dot (((texture2D (_BumpMap, xlv_TEXCOORD0.zw).xyz * 2.0) - 1.0), lightDir_2)) * texture2D (_LightTexture0, vec2(tmpvar_7)).w) * 2.0));
  c_8.w = tmpvar_4;
  c_1.xyz = c_8.xyz;
  c_1.w = tmpvar_4;
  gl_FragData[0] = c_1;
}



#endif"
}

SubProgram "glesdesktop " {
Keywords { "POINT" }
"!!GLES
#define SHADER_API_GLES 1
#define tex2D texture2D


#ifdef VERTEX
#define gl_ModelViewProjectionMatrix glstate_matrix_mvp
uniform mat4 glstate_matrix_mvp;
#define gl_ModelViewMatrixInverseTranspose glstate_matrix_invtrans_modelview0
uniform mat4 glstate_matrix_invtrans_modelview0;
#define gl_ModelViewMatrix glstate_matrix_modelview0
uniform mat4 glstate_matrix_modelview0;

varying highp vec3 xlv_TEXCOORD4;
varying mediump vec3 xlv_TEXCOORD3;
varying highp vec3 xlv_TEXCOORD2;
varying highp vec3 xlv_TEXCOORD1;
varying highp vec4 xlv_TEXCOORD0;
uniform highp vec4 _BumpMap_ST;
uniform highp vec4 _MainTex_ST;
uniform highp mat4 _LightMatrix0;
uniform highp vec4 unity_Scale;
uniform highp mat4 _World2Object;
uniform highp mat4 _Object2World;


uniform highp vec4 _WorldSpaceLightPos0;
attribute vec4 _glesTANGENT;
attribute vec4 _glesMultiTexCoord0;
attribute vec3 _glesNormal;
attribute vec4 _glesVertex;
void main ()
{
  vec4 tmpvar_1;
  tmpvar_1.xyz = normalize(_glesTANGENT.xyz);
  tmpvar_1.w = _glesTANGENT.w;
  vec3 tmpvar_2;
  tmpvar_2 = normalize(_glesNormal);
  highp vec4 tmpvar_3;
  mediump vec3 tmpvar_4;
  highp vec3 tmpvar_5;
  highp vec3 tmpvar_6;
  tmpvar_5 = tmpvar_1.xyz;
  tmpvar_6 = (((tmpvar_2.yzx * tmpvar_1.zxy) - (tmpvar_2.zxy * tmpvar_1.yzx)) * _glesTANGENT.w);
  highp mat3 tmpvar_7;
  tmpvar_7[0].x = tmpvar_5.x;
  tmpvar_7[0].y = tmpvar_6.x;
  tmpvar_7[0].z = tmpvar_2.x;
  tmpvar_7[1].x = tmpvar_5.y;
  tmpvar_7[1].y = tmpvar_6.y;
  tmpvar_7[1].z = tmpvar_2.y;
  tmpvar_7[2].x = tmpvar_5.z;
  tmpvar_7[2].y = tmpvar_6.z;
  tmpvar_7[2].z = tmpvar_2.z;
  vec4 v_8;
  v_8.x = gl_ModelViewMatrixInverseTranspose[0].x;
  v_8.y = gl_ModelViewMatrixInverseTranspose[1].x;
  v_8.z = gl_ModelViewMatrixInverseTranspose[2].x;
  v_8.w = gl_ModelViewMatrixInverseTranspose[3].x;
  vec4 v_9;
  v_9.x = gl_ModelViewMatrixInverseTranspose[0].y;
  v_9.y = gl_ModelViewMatrixInverseTranspose[1].y;
  v_9.z = gl_ModelViewMatrixInverseTranspose[2].y;
  v_9.w = gl_ModelViewMatrixInverseTranspose[3].y;
  tmpvar_3.xy = ((_glesMultiTexCoord0.xy * _MainTex_ST.xy) + _MainTex_ST.zw);
  tmpvar_3.zw = ((_glesMultiTexCoord0.xy * _BumpMap_ST.xy) + _BumpMap_ST.zw);
  highp vec3 tmpvar_10;
  highp vec3 tmpvar_11;
  tmpvar_10 = tmpvar_1.xyz;
  tmpvar_11 = (((tmpvar_2.yzx * tmpvar_1.zxy) - (tmpvar_2.zxy * tmpvar_1.yzx)) * _glesTANGENT.w);
  highp mat3 tmpvar_12;
  tmpvar_12[0].x = tmpvar_10.x;
  tmpvar_12[0].y = tmpvar_11.x;
  tmpvar_12[0].z = tmpvar_2.x;
  tmpvar_12[1].x = tmpvar_10.y;
  tmpvar_12[1].y = tmpvar_11.y;
  tmpvar_12[1].z = tmpvar_2.y;
  tmpvar_12[2].x = tmpvar_10.z;
  tmpvar_12[2].y = tmpvar_11.z;
  tmpvar_12[2].z = tmpvar_2.z;
  highp vec3 tmpvar_13;
  tmpvar_13 = (tmpvar_12 * (((_World2Object * _WorldSpaceLightPos0).xyz * unity_Scale.w) - _glesVertex.xyz));
  tmpvar_4 = tmpvar_13;
  gl_Position = (gl_ModelViewProjectionMatrix * _glesVertex);
  xlv_TEXCOORD0 = tmpvar_3;
  xlv_TEXCOORD1 = (tmpvar_7 * v_8.xyz);
  xlv_TEXCOORD2 = (tmpvar_7 * v_9.xyz);
  xlv_TEXCOORD3 = tmpvar_4;
  xlv_TEXCOORD4 = (_LightMatrix0 * (_Object2World * _glesVertex)).xyz;
}



#endif
#ifdef FRAGMENT

varying highp vec3 xlv_TEXCOORD4;
varying mediump vec3 xlv_TEXCOORD3;
varying highp vec4 xlv_TEXCOORD0;
uniform lowp float _Cutoff;
uniform sampler2D _BumpMap;
uniform sampler2D _MainTex;
uniform lowp vec4 _Color;
uniform sampler2D _LightTexture0;
uniform lowp vec4 _LightColor0;
void main ()
{
  lowp vec4 c_1;
  lowp vec3 lightDir_2;
  lowp vec3 normal_3;
  normal_3.xy = ((texture2D (_BumpMap, xlv_TEXCOORD0.zw).wy * 2.0) - 1.0);
  normal_3.z = sqrt(((1.0 - (normal_3.x * normal_3.x)) - (normal_3.y * normal_3.y)));
  lowp vec4 tmpvar_4;
  tmpvar_4 = texture2D (_MainTex, xlv_TEXCOORD0.xy);
  lowp float tmpvar_5;
  tmpvar_5 = tmpvar_4.w;
  lowp float x_6;
  x_6 = (tmpvar_4.w - _Cutoff);
  if ((x_6 < 0.0)) {
    discard;
  };
  mediump vec3 tmpvar_7;
  tmpvar_7 = normalize(xlv_TEXCOORD3);
  lightDir_2 = tmpvar_7;
  highp float tmpvar_8;
  tmpvar_8 = dot (xlv_TEXCOORD4, xlv_TEXCOORD4);
  lowp vec4 c_9;
  c_9.xyz = (((texture2D (_MainTex, xlv_TEXCOORD0.xy).xyz * _Color.w) * _LightColor0.xyz) * ((max (0.0, dot (normal_3, lightDir_2)) * texture2D (_LightTexture0, vec2(tmpvar_8)).w) * 2.0));
  c_9.w = tmpvar_5;
  c_1.xyz = c_9.xyz;
  c_1.w = tmpvar_5;
  gl_FragData[0] = c_1;
}



#endif"
}

SubProgram "flash " {
Keywords { "POINT" }
Bind "vertex" Vertex
Bind "tangent" TexCoord2
Bind "normal" Normal
Bind "texcoord" TexCoord0
Matrix 0 [glstate_matrix_mvp]
Matrix 4 [glstate_matrix_invtrans_modelview0]
Vector 20 [_WorldSpaceLightPos0]
Matrix 8 [_Object2World]
Matrix 12 [_World2Object]
Vector 21 [unity_Scale]
Matrix 16 [_LightMatrix0]
Vector 22 [_MainTex_ST]
Vector 23 [_BumpMap_ST]
"agal_vs
[bc]
aaaaaaaaabaaahacafaaaaoeaaaaaaaaaaaaaaaaaaaaaaaa mov r1.xyz, a5
aaaaaaaaaaaaapacaoaaaaoeabaaaaaaaaaaaaaaaaaaaaaa mov r0, c14
adaaaaaaacaaahacabaaaancaaaaaaaaabaaaaajacaaaaaa mul r2.xyz, a1.zxyw, r1.yzxx
aaaaaaaaabaaahacafaaaaoeaaaaaaaaaaaaaaaaaaaaaaaa mov r1.xyz, a5
adaaaaaaadaaahacabaaaamjaaaaaaaaabaaaafcacaaaaaa mul r3.xyz, a1.yzxw, r1.zxyy
acaaaaaaacaaahacadaaaakeacaaaaaaacaaaakeacaaaaaa sub r2.xyz, r3.xyzz, r2.xyzz
bdaaaaaaadaaaeacbeaaaaoeabaaaaaaaaaaaaoeacaaaaaa dp4 r3.z, c20, r0
aaaaaaaaaaaaapacanaaaaoeabaaaaaaaaaaaaaaaaaaaaaa mov r0, c13
aaaaaaaaabaaapacamaaaaoeabaaaaaaaaaaaaaaaaaaaaaa mov r1, c12
bdaaaaaaadaaabacbeaaaaoeabaaaaaaabaaaaoeacaaaaaa dp4 r3.x, c20, r1
adaaaaaaabaaahacacaaaakeacaaaaaaafaaaappaaaaaaaa mul r1.xyz, r2.xyzz, a5.w
bdaaaaaaadaaacacbeaaaaoeabaaaaaaaaaaaaoeacaaaaaa dp4 r3.y, c20, r0
adaaaaaaacaaahacadaaaakeacaaaaaabfaaaappabaaaaaa mul r2.xyz, r3.xyzz, c21.w
acaaaaaaaaaaahacacaaaakeacaaaaaaaaaaaaoeaaaaaaaa sub r0.xyz, r2.xyzz, a0
bcaaaaaaadaaacaeabaaaakeacaaaaaaaaaaaakeacaaaaaa dp3 v3.y, r1.xyzz, r0.xyzz
bcaaaaaaadaaaeaeabaaaaoeaaaaaaaaaaaaaakeacaaaaaa dp3 v3.z, a1, r0.xyzz
bcaaaaaaadaaabaeafaaaaoeaaaaaaaaaaaaaakeacaaaaaa dp3 v3.x, a5, r0.xyzz
bdaaaaaaaaaaaiacaaaaaaoeaaaaaaaaalaaaaoeabaaaaaa dp4 r0.w, a0, c11
bdaaaaaaaaaaaeacaaaaaaoeaaaaaaaaakaaaaoeabaaaaaa dp4 r0.z, a0, c10
bdaaaaaaaaaaabacaaaaaaoeaaaaaaaaaiaaaaoeabaaaaaa dp4 r0.x, a0, c8
bdaaaaaaaaaaacacaaaaaaoeaaaaaaaaajaaaaoeabaaaaaa dp4 r0.y, a0, c9
bcaaaaaaabaaacaeabaaaakeacaaaaaaaeaaaaoeabaaaaaa dp3 v1.y, r1.xyzz, c4
bcaaaaaaacaaacaeabaaaakeacaaaaaaafaaaaoeabaaaaaa dp3 v2.y, r1.xyzz, c5
bdaaaaaaaeaaaeaeaaaaaaoeacaaaaaabcaaaaoeabaaaaaa dp4 v4.z, r0, c18
bdaaaaaaaeaaacaeaaaaaaoeacaaaaaabbaaaaoeabaaaaaa dp4 v4.y, r0, c17
bdaaaaaaaeaaabaeaaaaaaoeacaaaaaabaaaaaoeabaaaaaa dp4 v4.x, r0, c16
adaaaaaaaaaaamacadaaaaeeaaaaaaaabhaaaaeeabaaaaaa mul r0.zw, a3.xyxy, c23.xyxy
abaaaaaaaaaaamaeaaaaaaopacaaaaaabhaaaaoeabaaaaaa add v0.zw, r0.wwzw, c23
adaaaaaaaaaaadacadaaaaoeaaaaaaaabgaaaaoeabaaaaaa mul r0.xy, a3, c22
abaaaaaaaaaaadaeaaaaaafeacaaaaaabgaaaaooabaaaaaa add v0.xy, r0.xyyy, c22.zwzw
bdaaaaaaaaaaaiadaaaaaaoeaaaaaaaaadaaaaoeabaaaaaa dp4 o0.w, a0, c3
bdaaaaaaaaaaaeadaaaaaaoeaaaaaaaaacaaaaoeabaaaaaa dp4 o0.z, a0, c2
bdaaaaaaaaaaacadaaaaaaoeaaaaaaaaabaaaaoeabaaaaaa dp4 o0.y, a0, c1
bdaaaaaaaaaaabadaaaaaaoeaaaaaaaaaaaaaaoeabaaaaaa dp4 o0.x, a0, c0
bcaaaaaaabaaaeaeabaaaaoeaaaaaaaaaeaaaaoeabaaaaaa dp3 v1.z, a1, c4
bcaaaaaaabaaabaeafaaaaoeaaaaaaaaaeaaaaoeabaaaaaa dp3 v1.x, a5, c4
bcaaaaaaacaaaeaeabaaaaoeaaaaaaaaafaaaaoeabaaaaaa dp3 v2.z, a1, c5
bcaaaaaaacaaabaeafaaaaoeaaaaaaaaafaaaaoeabaaaaaa dp3 v2.x, a5, c5
aaaaaaaaabaaaiaeaaaaaaoeabaaaaaaaaaaaaaaaaaaaaaa mov v1.w, c0
aaaaaaaaacaaaiaeaaaaaaoeabaaaaaaaaaaaaaaaaaaaaaa mov v2.w, c0
aaaaaaaaadaaaiaeaaaaaaoeabaaaaaaaaaaaaaaaaaaaaaa mov v3.w, c0
aaaaaaaaaeaaaiaeaaaaaaoeabaaaaaaaaaaaaaaaaaaaaaa mov v4.w, c0
"
}

SubProgram "d3d11_9x " {
Keywords { "POINT" }
Bind "vertex" Vertex
Bind "tangent" TexCoord2
Bind "normal" Normal
Bind "texcoord" TexCoord0
Bind "color" Color
ConstBuffer "$Globals" 176 // 160 used size, 8 vars
Matrix 48 [_LightMatrix0] 4
Vector 128 [_MainTex_ST] 4
Vector 144 [_BumpMap_ST] 4
ConstBuffer "UnityLighting" 400 // 16 used size, 16 vars
Vector 0 [_WorldSpaceLightPos0] 4
ConstBuffer "UnityPerDraw" 336 // 336 used size, 6 vars
Matrix 0 [glstate_matrix_mvp] 4
Matrix 128 [glstate_matrix_invtrans_modelview0] 4
Matrix 192 [_Object2World] 4
Matrix 256 [_World2Object] 4
Vector 320 [unity_Scale] 4
BindCB "$Globals" 0
BindCB "UnityLighting" 1
BindCB "UnityPerDraw" 2
// 38 instructions, 2 temp regs, 0 temp arrays:
// ALU 15 float, 0 int, 0 uint
// TEX 0 (0 load, 0 comp, 0 bias, 0 grad)
// FLOW 1 static, 0 dynamic
"vs_4_0_level_9_3
eefiecednepfcamjcjkhdjpnhehahkgamiaeegejabaaaaaaliakaaaaaeaaaaaa
daaaaaaajaadaaaadiajaaaaaaakaaaaebgpgodjfiadaaaafiadaaaaaaacpopp
oiacaaaahaaaaaaaagaaceaaaaaagmaaaaaagmaaaaaaceaaabaagmaaaaaaadaa
aeaaabaaaaaaaaaaaaaaaiaaacaaafaaaaaaaaaaabaaaaaaabaaahaaaaaaaaaa
acaaaaaaaeaaaiaaaaaaaaaaacaaaiaaadaaamaaaaaaaaaaacaaamaaajaaapaa
aaaaaaaaaaaaaaaaabacpoppbpaaaaacafaaaaiaaaaaapjabpaaaaacafaaabia
abaaapjabpaaaaacafaaaciaacaaapjabpaaaaacafaaadiaadaaapjaabaaaaac
aaaaabiaamaaaakaabaaaaacaaaaaciaanaaaakaabaaaaacaaaaaeiaaoaaaaka
aiaaaaadabaaaboaabaaoejaaaaaoeiaabaaaaacabaaahiaabaaoejaafaaaaad
acaaahiaabaamjiaacaancjaaeaaaaaeabaaahiaacaamjjaabaanciaacaaoeib
afaaaaadabaaahiaabaaoeiaabaappjaaiaaaaadabaaacoaabaaoeiaaaaaoeia
aiaaaaadabaaaeoaacaaoejaaaaaoeiaabaaaaacaaaaabiaamaaffkaabaaaaac
aaaaaciaanaaffkaabaaaaacaaaaaeiaaoaaffkaaiaaaaadacaaaboaabaaoeja
aaaaoeiaaiaaaaadacaaacoaabaaoeiaaaaaoeiaaiaaaaadacaaaeoaacaaoeja
aaaaoeiaaeaaaaaeaaaaadoaadaaoejaafaaoekaafaaookaaeaaaaaeaaaaamoa
adaaeejaagaaeekaagaaoekaabaaaaacaaaaapiaahaaoekaafaaaaadacaaahia
aaaaffiabeaaoekaaeaaaaaeacaaahiabdaaoekaaaaaaaiaacaaoeiaaeaaaaae
aaaaahiabfaaoekaaaaakkiaacaaoeiaaeaaaaaeaaaaahiabgaaoekaaaaappia
aaaaoeiaaeaaaaaeaaaaahiaaaaaoeiabhaappkaaaaaoejbaiaaaaadadaaaboa
abaaoejaaaaaoeiaaiaaaaadadaaacoaabaaoeiaaaaaoeiaaiaaaaadadaaaeoa
acaaoejaaaaaoeiaafaaaaadaaaaapiaaaaaffjabaaaoekaaeaaaaaeaaaaapia
apaaoekaaaaaaajaaaaaoeiaaeaaaaaeaaaaapiabbaaoekaaaaakkjaaaaaoeia
aeaaaaaeaaaaapiabcaaoekaaaaappjaaaaaoeiaafaaaaadabaaahiaaaaaffia
acaaoekaaeaaaaaeabaaahiaabaaoekaaaaaaaiaabaaoeiaaeaaaaaeaaaaahia
adaaoekaaaaakkiaabaaoeiaaeaaaaaeaeaaahoaaeaaoekaaaaappiaaaaaoeia
afaaaaadaaaaapiaaaaaffjaajaaoekaaeaaaaaeaaaaapiaaiaaoekaaaaaaaja
aaaaoeiaaeaaaaaeaaaaapiaakaaoekaaaaakkjaaaaaoeiaaeaaaaaeaaaaapia
alaaoekaaaaappjaaaaaoeiaaeaaaaaeaaaaadmaaaaappiaaaaaoekaaaaaoeia
abaaaaacaaaaammaaaaaoeiappppaaaafdeieefckaafaaaaeaaaabaagiabaaaa
fjaaaaaeegiocaaaaaaaaaaaakaaaaaafjaaaaaeegiocaaaabaaaaaaabaaaaaa
fjaaaaaeegiocaaaacaaaaaabfaaaaaafpaaaaadpcbabaaaaaaaaaaafpaaaaad
pcbabaaaabaaaaaafpaaaaadhcbabaaaacaaaaaafpaaaaaddcbabaaaadaaaaaa
ghaaaaaepccabaaaaaaaaaaaabaaaaaagfaaaaadpccabaaaabaaaaaagfaaaaad
hccabaaaacaaaaaagfaaaaadhccabaaaadaaaaaagfaaaaadhccabaaaaeaaaaaa
gfaaaaadhccabaaaafaaaaaagiaaaaacacaaaaaadiaaaaaipcaabaaaaaaaaaaa
fgbfbaaaaaaaaaaaegiocaaaacaaaaaaabaaaaaadcaaaaakpcaabaaaaaaaaaaa
egiocaaaacaaaaaaaaaaaaaaagbabaaaaaaaaaaaegaobaaaaaaaaaaadcaaaaak
pcaabaaaaaaaaaaaegiocaaaacaaaaaaacaaaaaakgbkbaaaaaaaaaaaegaobaaa
aaaaaaaadcaaaaakpccabaaaaaaaaaaaegiocaaaacaaaaaaadaaaaaapgbpbaaa
aaaaaaaaegaobaaaaaaaaaaadcaaaaaldccabaaaabaaaaaaegbabaaaadaaaaaa
egiacaaaaaaaaaaaaiaaaaaaogikcaaaaaaaaaaaaiaaaaaadcaaaaalmccabaaa
abaaaaaaagbebaaaadaaaaaaagiecaaaaaaaaaaaajaaaaaakgiocaaaaaaaaaaa
ajaaaaaadiaaaaahhcaabaaaaaaaaaaajgbebaaaabaaaaaacgbjbaaaacaaaaaa
dcaaaaakhcaabaaaaaaaaaaajgbebaaaacaaaaaacgbjbaaaabaaaaaaegacbaia
ebaaaaaaaaaaaaaadiaaaaahhcaabaaaaaaaaaaaegacbaaaaaaaaaaapgbpbaaa
abaaaaaadgaaaaagbcaabaaaabaaaaaaakiacaaaacaaaaaaaiaaaaaadgaaaaag
ccaabaaaabaaaaaaakiacaaaacaaaaaaajaaaaaadgaaaaagecaabaaaabaaaaaa
akiacaaaacaaaaaaakaaaaaabaaaaaahcccabaaaacaaaaaaegacbaaaaaaaaaaa
egacbaaaabaaaaaabaaaaaahbccabaaaacaaaaaaegbcbaaaabaaaaaaegacbaaa
abaaaaaabaaaaaaheccabaaaacaaaaaaegbcbaaaacaaaaaaegacbaaaabaaaaaa
dgaaaaagbcaabaaaabaaaaaabkiacaaaacaaaaaaaiaaaaaadgaaaaagccaabaaa
abaaaaaabkiacaaaacaaaaaaajaaaaaadgaaaaagecaabaaaabaaaaaabkiacaaa
acaaaaaaakaaaaaabaaaaaahcccabaaaadaaaaaaegacbaaaaaaaaaaaegacbaaa
abaaaaaabaaaaaahbccabaaaadaaaaaaegbcbaaaabaaaaaaegacbaaaabaaaaaa
baaaaaaheccabaaaadaaaaaaegbcbaaaacaaaaaaegacbaaaabaaaaaadiaaaaaj
hcaabaaaabaaaaaafgifcaaaabaaaaaaaaaaaaaaegiccaaaacaaaaaabbaaaaaa
dcaaaaalhcaabaaaabaaaaaaegiccaaaacaaaaaabaaaaaaaagiacaaaabaaaaaa
aaaaaaaaegacbaaaabaaaaaadcaaaaalhcaabaaaabaaaaaaegiccaaaacaaaaaa
bcaaaaaakgikcaaaabaaaaaaaaaaaaaaegacbaaaabaaaaaadcaaaaalhcaabaaa
abaaaaaaegiccaaaacaaaaaabdaaaaaapgipcaaaabaaaaaaaaaaaaaaegacbaaa
abaaaaaadcaaaaalhcaabaaaabaaaaaaegacbaaaabaaaaaapgipcaaaacaaaaaa
beaaaaaaegbcbaiaebaaaaaaaaaaaaaabaaaaaahcccabaaaaeaaaaaaegacbaaa
aaaaaaaaegacbaaaabaaaaaabaaaaaahbccabaaaaeaaaaaaegbcbaaaabaaaaaa
egacbaaaabaaaaaabaaaaaaheccabaaaaeaaaaaaegbcbaaaacaaaaaaegacbaaa
abaaaaaadiaaaaaipcaabaaaaaaaaaaafgbfbaaaaaaaaaaaegiocaaaacaaaaaa
anaaaaaadcaaaaakpcaabaaaaaaaaaaaegiocaaaacaaaaaaamaaaaaaagbabaaa
aaaaaaaaegaobaaaaaaaaaaadcaaaaakpcaabaaaaaaaaaaaegiocaaaacaaaaaa
aoaaaaaakgbkbaaaaaaaaaaaegaobaaaaaaaaaaadcaaaaakpcaabaaaaaaaaaaa
egiocaaaacaaaaaaapaaaaaapgbpbaaaaaaaaaaaegaobaaaaaaaaaaadiaaaaai
hcaabaaaabaaaaaafgafbaaaaaaaaaaaegiccaaaaaaaaaaaaeaaaaaadcaaaaak
hcaabaaaabaaaaaaegiccaaaaaaaaaaaadaaaaaaagaabaaaaaaaaaaaegacbaaa
abaaaaaadcaaaaakhcaabaaaaaaaaaaaegiccaaaaaaaaaaaafaaaaaakgakbaaa
aaaaaaaaegacbaaaabaaaaaadcaaaaakhccabaaaafaaaaaaegiccaaaaaaaaaaa
agaaaaaapgapbaaaaaaaaaaaegacbaaaaaaaaaaadoaaaaabejfdeheomaaaaaaa
agaaaaaaaiaaaaaajiaaaaaaaaaaaaaaaaaaaaaaadaaaaaaaaaaaaaaapapaaaa
kbaaaaaaaaaaaaaaaaaaaaaaadaaaaaaabaaaaaaapapaaaakjaaaaaaaaaaaaaa
aaaaaaaaadaaaaaaacaaaaaaahahaaaalaaaaaaaaaaaaaaaaaaaaaaaadaaaaaa
adaaaaaaapadaaaalaaaaaaaabaaaaaaaaaaaaaaadaaaaaaaeaaaaaaapaaaaaa
ljaaaaaaaaaaaaaaaaaaaaaaadaaaaaaafaaaaaaapaaaaaafaepfdejfeejepeo
aafeebeoehefeofeaaeoepfcenebemaafeeffiedepepfceeaaedepemepfcaakl
epfdeheolaaaaaaaagaaaaaaaiaaaaaajiaaaaaaaaaaaaaaabaaaaaaadaaaaaa
aaaaaaaaapaaaaaakeaaaaaaaaaaaaaaaaaaaaaaadaaaaaaabaaaaaaapaaaaaa
keaaaaaaabaaaaaaaaaaaaaaadaaaaaaacaaaaaaahaiaaaakeaaaaaaacaaaaaa
aaaaaaaaadaaaaaaadaaaaaaahaiaaaakeaaaaaaadaaaaaaaaaaaaaaadaaaaaa
aeaaaaaaahaiaaaakeaaaaaaaeaaaaaaaaaaaaaaadaaaaaaafaaaaaaahaiaaaa
fdfgfpfaepfdejfeejepeoaafeeffiedepepfceeaaklklkl"
}

SubProgram "opengl " {
Keywords { "DIRECTIONAL" }
Bind "vertex" Vertex
Bind "tangent" ATTR14
Bind "normal" Normal
Bind "texcoord" TexCoord0
Vector 13 [_WorldSpaceLightPos0]
Matrix 9 [_World2Object]
Vector 14 [_MainTex_ST]
Vector 15 [_BumpMap_ST]
"!!ARBvp1.0
# 23 ALU
PARAM c[16] = { program.local[0],
		state.matrix.mvp,
		state.matrix.modelview[0].invtrans,
		program.local[9..15] };
TEMP R0;
TEMP R1;
TEMP R2;
MOV R0.xyz, vertex.attrib[14];
MUL R1.xyz, vertex.normal.zxyw, R0.yzxw;
MAD R0.xyz, vertex.normal.yzxw, R0.zxyw, -R1;
MOV R1, c[13];
MUL R0.xyz, R0, vertex.attrib[14].w;
DP4 R2.z, R1, c[11];
DP4 R2.x, R1, c[9];
DP4 R2.y, R1, c[10];
DP3 result.texcoord[3].y, R0, R2;
DP3 result.texcoord[1].y, R0, c[5];
DP3 result.texcoord[2].y, R0, c[6];
DP3 result.texcoord[3].z, vertex.normal, R2;
DP3 result.texcoord[3].x, vertex.attrib[14], R2;
MAD result.texcoord[0].zw, vertex.texcoord[0].xyxy, c[15].xyxy, c[15];
MAD result.texcoord[0].xy, vertex.texcoord[0], c[14], c[14].zwzw;
DP4 result.position.w, vertex.position, c[4];
DP4 result.position.z, vertex.position, c[3];
DP4 result.position.y, vertex.position, c[2];
DP4 result.position.x, vertex.position, c[1];
DP3 result.texcoord[1].z, vertex.normal, c[5];
DP3 result.texcoord[1].x, vertex.attrib[14], c[5];
DP3 result.texcoord[2].z, vertex.normal, c[6];
DP3 result.texcoord[2].x, vertex.attrib[14], c[6];
END
# 23 instructions, 3 R-regs
"
}

SubProgram "d3d9 " {
Keywords { "DIRECTIONAL" }
Bind "vertex" Vertex
Bind "tangent" TexCoord2
Bind "normal" Normal
Bind "texcoord" TexCoord0
Matrix 0 [glstate_matrix_mvp]
Matrix 4 [glstate_matrix_invtrans_modelview0]
Vector 12 [_WorldSpaceLightPos0]
Matrix 8 [_World2Object]
Vector 13 [_MainTex_ST]
Vector 14 [_BumpMap_ST]
"vs_2_0
; 26 ALU
dcl_position0 v0
dcl_tangent0 v1
dcl_normal0 v2
dcl_texcoord0 v3
mov r0.xyz, v1
mul r1.xyz, v2.zxyw, r0.yzxw
mov r0.xyz, v1
mad r1.xyz, v2.yzxw, r0.zxyw, -r1
mul r2.xyz, r1, v1.w
mov r0, c10
dp4 r3.z, c12, r0
mov r1, c8
mov r0, c9
dp4 r3.x, c12, r1
dp4 r3.y, c12, r0
dp3 oT3.y, r2, r3
dp3 oT1.y, r2, c4
dp3 oT2.y, r2, c5
dp3 oT3.z, v2, r3
dp3 oT3.x, v1, r3
mad oT0.zw, v3.xyxy, c14.xyxy, c14
mad oT0.xy, v3, c13, c13.zwzw
dp4 oPos.w, v0, c3
dp4 oPos.z, v0, c2
dp4 oPos.y, v0, c1
dp4 oPos.x, v0, c0
dp3 oT1.z, v2, c4
dp3 oT1.x, v1, c4
dp3 oT2.z, v2, c5
dp3 oT2.x, v1, c5
"
}

SubProgram "d3d11 " {
Keywords { "DIRECTIONAL" }
Bind "vertex" Vertex
Bind "tangent" TexCoord2
Bind "normal" Normal
Bind "texcoord" TexCoord0
Bind "color" Color
ConstBuffer "$Globals" 112 // 96 used size, 7 vars
Vector 64 [_MainTex_ST] 4
Vector 80 [_BumpMap_ST] 4
ConstBuffer "UnityLighting" 400 // 16 used size, 16 vars
Vector 0 [_WorldSpaceLightPos0] 4
ConstBuffer "UnityPerDraw" 336 // 320 used size, 6 vars
Matrix 0 [glstate_matrix_mvp] 4
Matrix 128 [glstate_matrix_invtrans_modelview0] 4
Matrix 256 [_World2Object] 4
BindCB "$Globals" 0
BindCB "UnityLighting" 1
BindCB "UnityPerDraw" 2
// 29 instructions, 2 temp regs, 0 temp arrays:
// ALU 13 float, 0 int, 0 uint
// TEX 0 (0 load, 0 comp, 0 bias, 0 grad)
// FLOW 1 static, 0 dynamic
"vs_4_0
eefieceddenifidobfpnnodjdlfllkngklejdbocabaaaaaaneafaaaaadaaaaaa
cmaaaaaapeaaaaaajeabaaaaejfdeheomaaaaaaaagaaaaaaaiaaaaaajiaaaaaa
aaaaaaaaaaaaaaaaadaaaaaaaaaaaaaaapapaaaakbaaaaaaaaaaaaaaaaaaaaaa
adaaaaaaabaaaaaaapapaaaakjaaaaaaaaaaaaaaaaaaaaaaadaaaaaaacaaaaaa
ahahaaaalaaaaaaaaaaaaaaaaaaaaaaaadaaaaaaadaaaaaaapadaaaalaaaaaaa
abaaaaaaaaaaaaaaadaaaaaaaeaaaaaaapaaaaaaljaaaaaaaaaaaaaaaaaaaaaa
adaaaaaaafaaaaaaapaaaaaafaepfdejfeejepeoaafeebeoehefeofeaaeoepfc
enebemaafeeffiedepepfceeaaedepemepfcaaklepfdeheojiaaaaaaafaaaaaa
aiaaaaaaiaaaaaaaaaaaaaaaabaaaaaaadaaaaaaaaaaaaaaapaaaaaaimaaaaaa
aaaaaaaaaaaaaaaaadaaaaaaabaaaaaaapaaaaaaimaaaaaaabaaaaaaaaaaaaaa
adaaaaaaacaaaaaaahaiaaaaimaaaaaaacaaaaaaaaaaaaaaadaaaaaaadaaaaaa
ahaiaaaaimaaaaaaadaaaaaaaaaaaaaaadaaaaaaaeaaaaaaahaiaaaafdfgfpfa
epfdejfeejepeoaafeeffiedepepfceeaaklklklfdeieefcdiaeaaaaeaaaabaa
aoabaaaafjaaaaaeegiocaaaaaaaaaaaagaaaaaafjaaaaaeegiocaaaabaaaaaa
abaaaaaafjaaaaaeegiocaaaacaaaaaabeaaaaaafpaaaaadpcbabaaaaaaaaaaa
fpaaaaadpcbabaaaabaaaaaafpaaaaadhcbabaaaacaaaaaafpaaaaaddcbabaaa
adaaaaaaghaaaaaepccabaaaaaaaaaaaabaaaaaagfaaaaadpccabaaaabaaaaaa
gfaaaaadhccabaaaacaaaaaagfaaaaadhccabaaaadaaaaaagfaaaaadhccabaaa
aeaaaaaagiaaaaacacaaaaaadiaaaaaipcaabaaaaaaaaaaafgbfbaaaaaaaaaaa
egiocaaaacaaaaaaabaaaaaadcaaaaakpcaabaaaaaaaaaaaegiocaaaacaaaaaa
aaaaaaaaagbabaaaaaaaaaaaegaobaaaaaaaaaaadcaaaaakpcaabaaaaaaaaaaa
egiocaaaacaaaaaaacaaaaaakgbkbaaaaaaaaaaaegaobaaaaaaaaaaadcaaaaak
pccabaaaaaaaaaaaegiocaaaacaaaaaaadaaaaaapgbpbaaaaaaaaaaaegaobaaa
aaaaaaaadcaaaaaldccabaaaabaaaaaaegbabaaaadaaaaaaegiacaaaaaaaaaaa
aeaaaaaaogikcaaaaaaaaaaaaeaaaaaadcaaaaalmccabaaaabaaaaaaagbebaaa
adaaaaaaagiecaaaaaaaaaaaafaaaaaakgiocaaaaaaaaaaaafaaaaaadiaaaaah
hcaabaaaaaaaaaaajgbebaaaabaaaaaacgbjbaaaacaaaaaadcaaaaakhcaabaaa
aaaaaaaajgbebaaaacaaaaaacgbjbaaaabaaaaaaegacbaiaebaaaaaaaaaaaaaa
diaaaaahhcaabaaaaaaaaaaaegacbaaaaaaaaaaapgbpbaaaabaaaaaadgaaaaag
bcaabaaaabaaaaaaakiacaaaacaaaaaaaiaaaaaadgaaaaagccaabaaaabaaaaaa
akiacaaaacaaaaaaajaaaaaadgaaaaagecaabaaaabaaaaaaakiacaaaacaaaaaa
akaaaaaabaaaaaahcccabaaaacaaaaaaegacbaaaaaaaaaaaegacbaaaabaaaaaa
baaaaaahbccabaaaacaaaaaaegbcbaaaabaaaaaaegacbaaaabaaaaaabaaaaaah
eccabaaaacaaaaaaegbcbaaaacaaaaaaegacbaaaabaaaaaadgaaaaagbcaabaaa
abaaaaaabkiacaaaacaaaaaaaiaaaaaadgaaaaagccaabaaaabaaaaaabkiacaaa
acaaaaaaajaaaaaadgaaaaagecaabaaaabaaaaaabkiacaaaacaaaaaaakaaaaaa
baaaaaahcccabaaaadaaaaaaegacbaaaaaaaaaaaegacbaaaabaaaaaabaaaaaah
bccabaaaadaaaaaaegbcbaaaabaaaaaaegacbaaaabaaaaaabaaaaaaheccabaaa
adaaaaaaegbcbaaaacaaaaaaegacbaaaabaaaaaadiaaaaajhcaabaaaabaaaaaa
fgifcaaaabaaaaaaaaaaaaaaegiccaaaacaaaaaabbaaaaaadcaaaaalhcaabaaa
abaaaaaaegiccaaaacaaaaaabaaaaaaaagiacaaaabaaaaaaaaaaaaaaegacbaaa
abaaaaaadcaaaaalhcaabaaaabaaaaaaegiccaaaacaaaaaabcaaaaaakgikcaaa
abaaaaaaaaaaaaaaegacbaaaabaaaaaadcaaaaalhcaabaaaabaaaaaaegiccaaa
acaaaaaabdaaaaaapgipcaaaabaaaaaaaaaaaaaaegacbaaaabaaaaaabaaaaaah
cccabaaaaeaaaaaaegacbaaaaaaaaaaaegacbaaaabaaaaaabaaaaaahbccabaaa
aeaaaaaaegbcbaaaabaaaaaaegacbaaaabaaaaaabaaaaaaheccabaaaaeaaaaaa
egbcbaaaacaaaaaaegacbaaaabaaaaaadoaaaaab"
}

SubProgram "gles " {
Keywords { "DIRECTIONAL" }
"!!GLES
#define SHADER_API_GLES 1
#define tex2D texture2D


#ifdef VERTEX
#define gl_ModelViewProjectionMatrix glstate_matrix_mvp
uniform mat4 glstate_matrix_mvp;
#define gl_ModelViewMatrixInverseTranspose glstate_matrix_invtrans_modelview0
uniform mat4 glstate_matrix_invtrans_modelview0;
#define gl_ModelViewMatrix glstate_matrix_modelview0
uniform mat4 glstate_matrix_modelview0;

varying mediump vec3 xlv_TEXCOORD3;
varying highp vec3 xlv_TEXCOORD2;
varying highp vec3 xlv_TEXCOORD1;
varying highp vec4 xlv_TEXCOORD0;
uniform highp vec4 _BumpMap_ST;
uniform highp vec4 _MainTex_ST;
uniform highp mat4 _World2Object;


uniform lowp vec4 _WorldSpaceLightPos0;
attribute vec4 _glesTANGENT;
attribute vec4 _glesMultiTexCoord0;
attribute vec3 _glesNormal;
attribute vec4 _glesVertex;
void main ()
{
  vec4 tmpvar_1;
  tmpvar_1.xyz = normalize(_glesTANGENT.xyz);
  tmpvar_1.w = _glesTANGENT.w;
  vec3 tmpvar_2;
  tmpvar_2 = normalize(_glesNormal);
  highp vec4 tmpvar_3;
  mediump vec3 tmpvar_4;
  highp vec3 tmpvar_5;
  highp vec3 tmpvar_6;
  tmpvar_5 = tmpvar_1.xyz;
  tmpvar_6 = (((tmpvar_2.yzx * tmpvar_1.zxy) - (tmpvar_2.zxy * tmpvar_1.yzx)) * _glesTANGENT.w);
  highp mat3 tmpvar_7;
  tmpvar_7[0].x = tmpvar_5.x;
  tmpvar_7[0].y = tmpvar_6.x;
  tmpvar_7[0].z = tmpvar_2.x;
  tmpvar_7[1].x = tmpvar_5.y;
  tmpvar_7[1].y = tmpvar_6.y;
  tmpvar_7[1].z = tmpvar_2.y;
  tmpvar_7[2].x = tmpvar_5.z;
  tmpvar_7[2].y = tmpvar_6.z;
  tmpvar_7[2].z = tmpvar_2.z;
  vec4 v_8;
  v_8.x = gl_ModelViewMatrixInverseTranspose[0].x;
  v_8.y = gl_ModelViewMatrixInverseTranspose[1].x;
  v_8.z = gl_ModelViewMatrixInverseTranspose[2].x;
  v_8.w = gl_ModelViewMatrixInverseTranspose[3].x;
  vec4 v_9;
  v_9.x = gl_ModelViewMatrixInverseTranspose[0].y;
  v_9.y = gl_ModelViewMatrixInverseTranspose[1].y;
  v_9.z = gl_ModelViewMatrixInverseTranspose[2].y;
  v_9.w = gl_ModelViewMatrixInverseTranspose[3].y;
  tmpvar_3.xy = ((_glesMultiTexCoord0.xy * _MainTex_ST.xy) + _MainTex_ST.zw);
  tmpvar_3.zw = ((_glesMultiTexCoord0.xy * _BumpMap_ST.xy) + _BumpMap_ST.zw);
  highp vec3 tmpvar_10;
  highp vec3 tmpvar_11;
  tmpvar_10 = tmpvar_1.xyz;
  tmpvar_11 = (((tmpvar_2.yzx * tmpvar_1.zxy) - (tmpvar_2.zxy * tmpvar_1.yzx)) * _glesTANGENT.w);
  highp mat3 tmpvar_12;
  tmpvar_12[0].x = tmpvar_10.x;
  tmpvar_12[0].y = tmpvar_11.x;
  tmpvar_12[0].z = tmpvar_2.x;
  tmpvar_12[1].x = tmpvar_10.y;
  tmpvar_12[1].y = tmpvar_11.y;
  tmpvar_12[1].z = tmpvar_2.y;
  tmpvar_12[2].x = tmpvar_10.z;
  tmpvar_12[2].y = tmpvar_11.z;
  tmpvar_12[2].z = tmpvar_2.z;
  highp vec3 tmpvar_13;
  tmpvar_13 = (tmpvar_12 * (_World2Object * _WorldSpaceLightPos0).xyz);
  tmpvar_4 = tmpvar_13;
  gl_Position = (gl_ModelViewProjectionMatrix * _glesVertex);
  xlv_TEXCOORD0 = tmpvar_3;
  xlv_TEXCOORD1 = (tmpvar_7 * v_8.xyz);
  xlv_TEXCOORD2 = (tmpvar_7 * v_9.xyz);
  xlv_TEXCOORD3 = tmpvar_4;
}



#endif
#ifdef FRAGMENT

varying mediump vec3 xlv_TEXCOORD3;
varying highp vec4 xlv_TEXCOORD0;
uniform lowp float _Cutoff;
uniform sampler2D _BumpMap;
uniform sampler2D _MainTex;
uniform lowp vec4 _Color;
uniform lowp vec4 _LightColor0;
void main ()
{
  lowp vec4 c_1;
  lowp vec3 lightDir_2;
  lowp vec4 tmpvar_3;
  tmpvar_3 = texture2D (_MainTex, xlv_TEXCOORD0.xy);
  lowp float tmpvar_4;
  tmpvar_4 = tmpvar_3.w;
  lowp float x_5;
  x_5 = (tmpvar_3.w - _Cutoff);
  if ((x_5 < 0.0)) {
    discard;
  };
  lightDir_2 = xlv_TEXCOORD3;
  lowp vec4 c_6;
  c_6.xyz = (((texture2D (_MainTex, xlv_TEXCOORD0.xy).xyz * _Color.w) * _LightColor0.xyz) * (max (0.0, dot (((texture2D (_BumpMap, xlv_TEXCOORD0.zw).xyz * 2.0) - 1.0), lightDir_2)) * 2.0));
  c_6.w = tmpvar_4;
  c_1.xyz = c_6.xyz;
  c_1.w = tmpvar_4;
  gl_FragData[0] = c_1;
}



#endif"
}

SubProgram "glesdesktop " {
Keywords { "DIRECTIONAL" }
"!!GLES
#define SHADER_API_GLES 1
#define tex2D texture2D


#ifdef VERTEX
#define gl_ModelViewProjectionMatrix glstate_matrix_mvp
uniform mat4 glstate_matrix_mvp;
#define gl_ModelViewMatrixInverseTranspose glstate_matrix_invtrans_modelview0
uniform mat4 glstate_matrix_invtrans_modelview0;
#define gl_ModelViewMatrix glstate_matrix_modelview0
uniform mat4 glstate_matrix_modelview0;

varying mediump vec3 xlv_TEXCOORD3;
varying highp vec3 xlv_TEXCOORD2;
varying highp vec3 xlv_TEXCOORD1;
varying highp vec4 xlv_TEXCOORD0;
uniform highp vec4 _BumpMap_ST;
uniform highp vec4 _MainTex_ST;
uniform highp mat4 _World2Object;


uniform lowp vec4 _WorldSpaceLightPos0;
attribute vec4 _glesTANGENT;
attribute vec4 _glesMultiTexCoord0;
attribute vec3 _glesNormal;
attribute vec4 _glesVertex;
void main ()
{
  vec4 tmpvar_1;
  tmpvar_1.xyz = normalize(_glesTANGENT.xyz);
  tmpvar_1.w = _glesTANGENT.w;
  vec3 tmpvar_2;
  tmpvar_2 = normalize(_glesNormal);
  highp vec4 tmpvar_3;
  mediump vec3 tmpvar_4;
  highp vec3 tmpvar_5;
  highp vec3 tmpvar_6;
  tmpvar_5 = tmpvar_1.xyz;
  tmpvar_6 = (((tmpvar_2.yzx * tmpvar_1.zxy) - (tmpvar_2.zxy * tmpvar_1.yzx)) * _glesTANGENT.w);
  highp mat3 tmpvar_7;
  tmpvar_7[0].x = tmpvar_5.x;
  tmpvar_7[0].y = tmpvar_6.x;
  tmpvar_7[0].z = tmpvar_2.x;
  tmpvar_7[1].x = tmpvar_5.y;
  tmpvar_7[1].y = tmpvar_6.y;
  tmpvar_7[1].z = tmpvar_2.y;
  tmpvar_7[2].x = tmpvar_5.z;
  tmpvar_7[2].y = tmpvar_6.z;
  tmpvar_7[2].z = tmpvar_2.z;
  vec4 v_8;
  v_8.x = gl_ModelViewMatrixInverseTranspose[0].x;
  v_8.y = gl_ModelViewMatrixInverseTranspose[1].x;
  v_8.z = gl_ModelViewMatrixInverseTranspose[2].x;
  v_8.w = gl_ModelViewMatrixInverseTranspose[3].x;
  vec4 v_9;
  v_9.x = gl_ModelViewMatrixInverseTranspose[0].y;
  v_9.y = gl_ModelViewMatrixInverseTranspose[1].y;
  v_9.z = gl_ModelViewMatrixInverseTranspose[2].y;
  v_9.w = gl_ModelViewMatrixInverseTranspose[3].y;
  tmpvar_3.xy = ((_glesMultiTexCoord0.xy * _MainTex_ST.xy) + _MainTex_ST.zw);
  tmpvar_3.zw = ((_glesMultiTexCoord0.xy * _BumpMap_ST.xy) + _BumpMap_ST.zw);
  highp vec3 tmpvar_10;
  highp vec3 tmpvar_11;
  tmpvar_10 = tmpvar_1.xyz;
  tmpvar_11 = (((tmpvar_2.yzx * tmpvar_1.zxy) - (tmpvar_2.zxy * tmpvar_1.yzx)) * _glesTANGENT.w);
  highp mat3 tmpvar_12;
  tmpvar_12[0].x = tmpvar_10.x;
  tmpvar_12[0].y = tmpvar_11.x;
  tmpvar_12[0].z = tmpvar_2.x;
  tmpvar_12[1].x = tmpvar_10.y;
  tmpvar_12[1].y = tmpvar_11.y;
  tmpvar_12[1].z = tmpvar_2.y;
  tmpvar_12[2].x = tmpvar_10.z;
  tmpvar_12[2].y = tmpvar_11.z;
  tmpvar_12[2].z = tmpvar_2.z;
  highp vec3 tmpvar_13;
  tmpvar_13 = (tmpvar_12 * (_World2Object * _WorldSpaceLightPos0).xyz);
  tmpvar_4 = tmpvar_13;
  gl_Position = (gl_ModelViewProjectionMatrix * _glesVertex);
  xlv_TEXCOORD0 = tmpvar_3;
  xlv_TEXCOORD1 = (tmpvar_7 * v_8.xyz);
  xlv_TEXCOORD2 = (tmpvar_7 * v_9.xyz);
  xlv_TEXCOORD3 = tmpvar_4;
}



#endif
#ifdef FRAGMENT

varying mediump vec3 xlv_TEXCOORD3;
varying highp vec4 xlv_TEXCOORD0;
uniform lowp float _Cutoff;
uniform sampler2D _BumpMap;
uniform sampler2D _MainTex;
uniform lowp vec4 _Color;
uniform lowp vec4 _LightColor0;
void main ()
{
  lowp vec4 c_1;
  lowp vec3 lightDir_2;
  lowp vec3 normal_3;
  normal_3.xy = ((texture2D (_BumpMap, xlv_TEXCOORD0.zw).wy * 2.0) - 1.0);
  normal_3.z = sqrt(((1.0 - (normal_3.x * normal_3.x)) - (normal_3.y * normal_3.y)));
  lowp vec4 tmpvar_4;
  tmpvar_4 = texture2D (_MainTex, xlv_TEXCOORD0.xy);
  lowp float tmpvar_5;
  tmpvar_5 = tmpvar_4.w;
  lowp float x_6;
  x_6 = (tmpvar_4.w - _Cutoff);
  if ((x_6 < 0.0)) {
    discard;
  };
  lightDir_2 = xlv_TEXCOORD3;
  lowp vec4 c_7;
  c_7.xyz = (((texture2D (_MainTex, xlv_TEXCOORD0.xy).xyz * _Color.w) * _LightColor0.xyz) * (max (0.0, dot (normal_3, lightDir_2)) * 2.0));
  c_7.w = tmpvar_5;
  c_1.xyz = c_7.xyz;
  c_1.w = tmpvar_5;
  gl_FragData[0] = c_1;
}



#endif"
}

SubProgram "flash " {
Keywords { "DIRECTIONAL" }
Bind "vertex" Vertex
Bind "tangent" TexCoord2
Bind "normal" Normal
Bind "texcoord" TexCoord0
Matrix 0 [glstate_matrix_mvp]
Matrix 4 [glstate_matrix_invtrans_modelview0]
Vector 12 [_WorldSpaceLightPos0]
Matrix 8 [_World2Object]
Vector 13 [_MainTex_ST]
Vector 14 [_BumpMap_ST]
"agal_vs
[bc]
aaaaaaaaaaaaahacafaaaaoeaaaaaaaaaaaaaaaaaaaaaaaa mov r0.xyz, a5
adaaaaaaabaaahacabaaaancaaaaaaaaaaaaaaajacaaaaaa mul r1.xyz, a1.zxyw, r0.yzxx
aaaaaaaaaaaaahacafaaaaoeaaaaaaaaaaaaaaaaaaaaaaaa mov r0.xyz, a5
adaaaaaaacaaahacabaaaamjaaaaaaaaaaaaaafcacaaaaaa mul r2.xyz, a1.yzxw, r0.zxyy
acaaaaaaabaaahacacaaaakeacaaaaaaabaaaakeacaaaaaa sub r1.xyz, r2.xyzz, r1.xyzz
adaaaaaaacaaahacabaaaakeacaaaaaaafaaaappaaaaaaaa mul r2.xyz, r1.xyzz, a5.w
aaaaaaaaaaaaapacakaaaaoeabaaaaaaaaaaaaaaaaaaaaaa mov r0, c10
bdaaaaaaadaaaeacamaaaaoeabaaaaaaaaaaaaoeacaaaaaa dp4 r3.z, c12, r0
aaaaaaaaabaaapacaiaaaaoeabaaaaaaaaaaaaaaaaaaaaaa mov r1, c8
aaaaaaaaaaaaapacajaaaaoeabaaaaaaaaaaaaaaaaaaaaaa mov r0, c9
bdaaaaaaadaaabacamaaaaoeabaaaaaaabaaaaoeacaaaaaa dp4 r3.x, c12, r1
bdaaaaaaadaaacacamaaaaoeabaaaaaaaaaaaaoeacaaaaaa dp4 r3.y, c12, r0
bcaaaaaaadaaacaeacaaaakeacaaaaaaadaaaakeacaaaaaa dp3 v3.y, r2.xyzz, r3.xyzz
bcaaaaaaabaaacaeacaaaakeacaaaaaaaeaaaaoeabaaaaaa dp3 v1.y, r2.xyzz, c4
bcaaaaaaacaaacaeacaaaakeacaaaaaaafaaaaoeabaaaaaa dp3 v2.y, r2.xyzz, c5
bcaaaaaaadaaaeaeabaaaaoeaaaaaaaaadaaaakeacaaaaaa dp3 v3.z, a1, r3.xyzz
bcaaaaaaadaaabaeafaaaaoeaaaaaaaaadaaaakeacaaaaaa dp3 v3.x, a5, r3.xyzz
adaaaaaaaaaaamacadaaaaeeaaaaaaaaaoaaaaeeabaaaaaa mul r0.zw, a3.xyxy, c14.xyxy
abaaaaaaaaaaamaeaaaaaaopacaaaaaaaoaaaaoeabaaaaaa add v0.zw, r0.wwzw, c14
adaaaaaaaaaaadacadaaaaoeaaaaaaaaanaaaaoeabaaaaaa mul r0.xy, a3, c13
abaaaaaaaaaaadaeaaaaaafeacaaaaaaanaaaaooabaaaaaa add v0.xy, r0.xyyy, c13.zwzw
bdaaaaaaaaaaaiadaaaaaaoeaaaaaaaaadaaaaoeabaaaaaa dp4 o0.w, a0, c3
bdaaaaaaaaaaaeadaaaaaaoeaaaaaaaaacaaaaoeabaaaaaa dp4 o0.z, a0, c2
bdaaaaaaaaaaacadaaaaaaoeaaaaaaaaabaaaaoeabaaaaaa dp4 o0.y, a0, c1
bdaaaaaaaaaaabadaaaaaaoeaaaaaaaaaaaaaaoeabaaaaaa dp4 o0.x, a0, c0
bcaaaaaaabaaaeaeabaaaaoeaaaaaaaaaeaaaaoeabaaaaaa dp3 v1.z, a1, c4
bcaaaaaaabaaabaeafaaaaoeaaaaaaaaaeaaaaoeabaaaaaa dp3 v1.x, a5, c4
bcaaaaaaacaaaeaeabaaaaoeaaaaaaaaafaaaaoeabaaaaaa dp3 v2.z, a1, c5
bcaaaaaaacaaabaeafaaaaoeaaaaaaaaafaaaaoeabaaaaaa dp3 v2.x, a5, c5
aaaaaaaaabaaaiaeaaaaaaoeabaaaaaaaaaaaaaaaaaaaaaa mov v1.w, c0
aaaaaaaaacaaaiaeaaaaaaoeabaaaaaaaaaaaaaaaaaaaaaa mov v2.w, c0
aaaaaaaaadaaaiaeaaaaaaoeabaaaaaaaaaaaaaaaaaaaaaa mov v3.w, c0
"
}

SubProgram "d3d11_9x " {
Keywords { "DIRECTIONAL" }
Bind "vertex" Vertex
Bind "tangent" TexCoord2
Bind "normal" Normal
Bind "texcoord" TexCoord0
Bind "color" Color
ConstBuffer "$Globals" 112 // 96 used size, 7 vars
Vector 64 [_MainTex_ST] 4
Vector 80 [_BumpMap_ST] 4
ConstBuffer "UnityLighting" 400 // 16 used size, 16 vars
Vector 0 [_WorldSpaceLightPos0] 4
ConstBuffer "UnityPerDraw" 336 // 320 used size, 6 vars
Matrix 0 [glstate_matrix_mvp] 4
Matrix 128 [glstate_matrix_invtrans_modelview0] 4
Matrix 256 [_World2Object] 4
BindCB "$Globals" 0
BindCB "UnityLighting" 1
BindCB "UnityPerDraw" 2
// 29 instructions, 2 temp regs, 0 temp arrays:
// ALU 13 float, 0 int, 0 uint
// TEX 0 (0 load, 0 comp, 0 bias, 0 grad)
// FLOW 1 static, 0 dynamic
"vs_4_0_level_9_3
eefiecedcebdljgeaoaenphoidjpnppejbhgembdabaaaaaaiaaiaaaaaeaaaaaa
daaaaaaaniacaaaabiahaaaaoaahaaaaebgpgodjkaacaaaakaacaaaaaaacpopp
dmacaaaageaaaaaaafaaceaaaaaagaaaaaaagaaaaaaaceaaabaagaaaaaaaaeaa
acaaabaaaaaaaaaaabaaaaaaabaaadaaaaaaaaaaacaaaaaaaeaaaeaaaaaaaaaa
acaaaiaaadaaaiaaaaaaaaaaacaabaaaaeaaalaaaaaaaaaaaaaaaaaaabacpopp
bpaaaaacafaaaaiaaaaaapjabpaaaaacafaaabiaabaaapjabpaaaaacafaaacia
acaaapjabpaaaaacafaaadiaadaaapjaabaaaaacaaaaabiaaiaaaakaabaaaaac
aaaaaciaajaaaakaabaaaaacaaaaaeiaakaaaakaaiaaaaadabaaaboaabaaoeja
aaaaoeiaabaaaaacabaaahiaabaaoejaafaaaaadacaaahiaabaamjiaacaancja
aeaaaaaeabaaahiaacaamjjaabaanciaacaaoeibafaaaaadabaaahiaabaaoeia
abaappjaaiaaaaadabaaacoaabaaoeiaaaaaoeiaaiaaaaadabaaaeoaacaaoeja
aaaaoeiaabaaaaacaaaaabiaaiaaffkaabaaaaacaaaaaciaajaaffkaabaaaaac
aaaaaeiaakaaffkaaiaaaaadacaaaboaabaaoejaaaaaoeiaaiaaaaadacaaacoa
abaaoeiaaaaaoeiaaiaaaaadacaaaeoaacaaoejaaaaaoeiaaeaaaaaeaaaaadoa
adaaoejaabaaoekaabaaookaaeaaaaaeaaaaamoaadaaeejaacaaeekaacaaoeka
abaaaaacaaaaapiaadaaoekaafaaaaadacaaahiaaaaaffiaamaaoekaaeaaaaae
acaaahiaalaaoekaaaaaaaiaacaaoeiaaeaaaaaeaaaaahiaanaaoekaaaaakkia
acaaoeiaaeaaaaaeaaaaahiaaoaaoekaaaaappiaaaaaoeiaaiaaaaadadaaaboa
abaaoejaaaaaoeiaaiaaaaadadaaacoaabaaoeiaaaaaoeiaaiaaaaadadaaaeoa
acaaoejaaaaaoeiaafaaaaadaaaaapiaaaaaffjaafaaoekaaeaaaaaeaaaaapia
aeaaoekaaaaaaajaaaaaoeiaaeaaaaaeaaaaapiaagaaoekaaaaakkjaaaaaoeia
aeaaaaaeaaaaapiaahaaoekaaaaappjaaaaaoeiaaeaaaaaeaaaaadmaaaaappia
aaaaoekaaaaaoeiaabaaaaacaaaaammaaaaaoeiappppaaaafdeieefcdiaeaaaa
eaaaabaaaoabaaaafjaaaaaeegiocaaaaaaaaaaaagaaaaaafjaaaaaeegiocaaa
abaaaaaaabaaaaaafjaaaaaeegiocaaaacaaaaaabeaaaaaafpaaaaadpcbabaaa
aaaaaaaafpaaaaadpcbabaaaabaaaaaafpaaaaadhcbabaaaacaaaaaafpaaaaad
dcbabaaaadaaaaaaghaaaaaepccabaaaaaaaaaaaabaaaaaagfaaaaadpccabaaa
abaaaaaagfaaaaadhccabaaaacaaaaaagfaaaaadhccabaaaadaaaaaagfaaaaad
hccabaaaaeaaaaaagiaaaaacacaaaaaadiaaaaaipcaabaaaaaaaaaaafgbfbaaa
aaaaaaaaegiocaaaacaaaaaaabaaaaaadcaaaaakpcaabaaaaaaaaaaaegiocaaa
acaaaaaaaaaaaaaaagbabaaaaaaaaaaaegaobaaaaaaaaaaadcaaaaakpcaabaaa
aaaaaaaaegiocaaaacaaaaaaacaaaaaakgbkbaaaaaaaaaaaegaobaaaaaaaaaaa
dcaaaaakpccabaaaaaaaaaaaegiocaaaacaaaaaaadaaaaaapgbpbaaaaaaaaaaa
egaobaaaaaaaaaaadcaaaaaldccabaaaabaaaaaaegbabaaaadaaaaaaegiacaaa
aaaaaaaaaeaaaaaaogikcaaaaaaaaaaaaeaaaaaadcaaaaalmccabaaaabaaaaaa
agbebaaaadaaaaaaagiecaaaaaaaaaaaafaaaaaakgiocaaaaaaaaaaaafaaaaaa
diaaaaahhcaabaaaaaaaaaaajgbebaaaabaaaaaacgbjbaaaacaaaaaadcaaaaak
hcaabaaaaaaaaaaajgbebaaaacaaaaaacgbjbaaaabaaaaaaegacbaiaebaaaaaa
aaaaaaaadiaaaaahhcaabaaaaaaaaaaaegacbaaaaaaaaaaapgbpbaaaabaaaaaa
dgaaaaagbcaabaaaabaaaaaaakiacaaaacaaaaaaaiaaaaaadgaaaaagccaabaaa
abaaaaaaakiacaaaacaaaaaaajaaaaaadgaaaaagecaabaaaabaaaaaaakiacaaa
acaaaaaaakaaaaaabaaaaaahcccabaaaacaaaaaaegacbaaaaaaaaaaaegacbaaa
abaaaaaabaaaaaahbccabaaaacaaaaaaegbcbaaaabaaaaaaegacbaaaabaaaaaa
baaaaaaheccabaaaacaaaaaaegbcbaaaacaaaaaaegacbaaaabaaaaaadgaaaaag
bcaabaaaabaaaaaabkiacaaaacaaaaaaaiaaaaaadgaaaaagccaabaaaabaaaaaa
bkiacaaaacaaaaaaajaaaaaadgaaaaagecaabaaaabaaaaaabkiacaaaacaaaaaa
akaaaaaabaaaaaahcccabaaaadaaaaaaegacbaaaaaaaaaaaegacbaaaabaaaaaa
baaaaaahbccabaaaadaaaaaaegbcbaaaabaaaaaaegacbaaaabaaaaaabaaaaaah
eccabaaaadaaaaaaegbcbaaaacaaaaaaegacbaaaabaaaaaadiaaaaajhcaabaaa
abaaaaaafgifcaaaabaaaaaaaaaaaaaaegiccaaaacaaaaaabbaaaaaadcaaaaal
hcaabaaaabaaaaaaegiccaaaacaaaaaabaaaaaaaagiacaaaabaaaaaaaaaaaaaa
egacbaaaabaaaaaadcaaaaalhcaabaaaabaaaaaaegiccaaaacaaaaaabcaaaaaa
kgikcaaaabaaaaaaaaaaaaaaegacbaaaabaaaaaadcaaaaalhcaabaaaabaaaaaa
egiccaaaacaaaaaabdaaaaaapgipcaaaabaaaaaaaaaaaaaaegacbaaaabaaaaaa
baaaaaahcccabaaaaeaaaaaaegacbaaaaaaaaaaaegacbaaaabaaaaaabaaaaaah
bccabaaaaeaaaaaaegbcbaaaabaaaaaaegacbaaaabaaaaaabaaaaaaheccabaaa
aeaaaaaaegbcbaaaacaaaaaaegacbaaaabaaaaaadoaaaaabejfdeheomaaaaaaa
agaaaaaaaiaaaaaajiaaaaaaaaaaaaaaaaaaaaaaadaaaaaaaaaaaaaaapapaaaa
kbaaaaaaaaaaaaaaaaaaaaaaadaaaaaaabaaaaaaapapaaaakjaaaaaaaaaaaaaa
aaaaaaaaadaaaaaaacaaaaaaahahaaaalaaaaaaaaaaaaaaaaaaaaaaaadaaaaaa
adaaaaaaapadaaaalaaaaaaaabaaaaaaaaaaaaaaadaaaaaaaeaaaaaaapaaaaaa
ljaaaaaaaaaaaaaaaaaaaaaaadaaaaaaafaaaaaaapaaaaaafaepfdejfeejepeo
aafeebeoehefeofeaaeoepfcenebemaafeeffiedepepfceeaaedepemepfcaakl
epfdeheojiaaaaaaafaaaaaaaiaaaaaaiaaaaaaaaaaaaaaaabaaaaaaadaaaaaa
aaaaaaaaapaaaaaaimaaaaaaaaaaaaaaaaaaaaaaadaaaaaaabaaaaaaapaaaaaa
imaaaaaaabaaaaaaaaaaaaaaadaaaaaaacaaaaaaahaiaaaaimaaaaaaacaaaaaa
aaaaaaaaadaaaaaaadaaaaaaahaiaaaaimaaaaaaadaaaaaaaaaaaaaaadaaaaaa
aeaaaaaaahaiaaaafdfgfpfaepfdejfeejepeoaafeeffiedepepfceeaaklklkl
"
}

SubProgram "opengl " {
Keywords { "SPOT" }
Bind "vertex" Vertex
Bind "tangent" ATTR14
Bind "normal" Normal
Bind "texcoord" TexCoord0
Vector 21 [_WorldSpaceLightPos0]
Matrix 9 [_Object2World]
Matrix 13 [_World2Object]
Vector 22 [unity_Scale]
Matrix 17 [_LightMatrix0]
Vector 23 [_MainTex_ST]
Vector 24 [_BumpMap_ST]
"!!ARBvp1.0
# 32 ALU
PARAM c[25] = { program.local[0],
		state.matrix.mvp,
		state.matrix.modelview[0].invtrans,
		program.local[9..24] };
TEMP R0;
TEMP R1;
TEMP R2;
MOV R0.xyz, vertex.attrib[14];
MUL R2.xyz, vertex.normal.zxyw, R0.yzxw;
MAD R0.xyz, vertex.normal.yzxw, R0.zxyw, -R2;
MOV R1, c[21];
MUL R0.xyz, R0, vertex.attrib[14].w;
DP4 R0.w, vertex.position, c[12];
DP3 result.texcoord[1].y, R0, c[5];
DP3 result.texcoord[2].y, R0, c[6];
DP4 R2.z, R1, c[15];
DP4 R2.x, R1, c[13];
DP4 R2.y, R1, c[14];
MAD R1.xyz, R2, c[22].w, -vertex.position;
DP3 result.texcoord[3].y, R0, R1;
DP4 R0.z, vertex.position, c[11];
DP4 R0.x, vertex.position, c[9];
DP4 R0.y, vertex.position, c[10];
DP3 result.texcoord[3].z, vertex.normal, R1;
DP3 result.texcoord[3].x, vertex.attrib[14], R1;
DP4 result.texcoord[4].w, R0, c[20];
DP4 result.texcoord[4].z, R0, c[19];
DP4 result.texcoord[4].y, R0, c[18];
DP4 result.texcoord[4].x, R0, c[17];
MAD result.texcoord[0].zw, vertex.texcoord[0].xyxy, c[24].xyxy, c[24];
MAD result.texcoord[0].xy, vertex.texcoord[0], c[23], c[23].zwzw;
DP4 result.position.w, vertex.position, c[4];
DP4 result.position.z, vertex.position, c[3];
DP4 result.position.y, vertex.position, c[2];
DP4 result.position.x, vertex.position, c[1];
DP3 result.texcoord[1].z, vertex.normal, c[5];
DP3 result.texcoord[1].x, vertex.attrib[14], c[5];
DP3 result.texcoord[2].z, vertex.normal, c[6];
DP3 result.texcoord[2].x, vertex.attrib[14], c[6];
END
# 32 instructions, 3 R-regs
"
}

SubProgram "d3d9 " {
Keywords { "SPOT" }
Bind "vertex" Vertex
Bind "tangent" TexCoord2
Bind "normal" Normal
Bind "texcoord" TexCoord0
Matrix 0 [glstate_matrix_mvp]
Matrix 4 [glstate_matrix_invtrans_modelview0]
Vector 20 [_WorldSpaceLightPos0]
Matrix 8 [_Object2World]
Matrix 12 [_World2Object]
Vector 21 [unity_Scale]
Matrix 16 [_LightMatrix0]
Vector 22 [_MainTex_ST]
Vector 23 [_BumpMap_ST]
"vs_2_0
; 35 ALU
dcl_position0 v0
dcl_tangent0 v1
dcl_normal0 v2
dcl_texcoord0 v3
mov r1.xyz, v1
mov r0, c14
mul r2.xyz, v2.zxyw, r1.yzxw
mov r1.xyz, v1
mad r2.xyz, v2.yzxw, r1.zxyw, -r2
dp4 r3.z, c20, r0
mov r0, c13
mov r1, c12
dp4 r3.x, c20, r1
mul r1.xyz, r2, v1.w
dp4 r3.y, c20, r0
mad r0.xyz, r3, c21.w, -v0
dp4 r0.w, v0, c11
dp3 oT3.y, r1, r0
dp3 oT3.z, v2, r0
dp3 oT3.x, v1, r0
dp4 r0.z, v0, c10
dp4 r0.x, v0, c8
dp4 r0.y, v0, c9
dp3 oT1.y, r1, c4
dp3 oT2.y, r1, c5
dp4 oT4.w, r0, c19
dp4 oT4.z, r0, c18
dp4 oT4.y, r0, c17
dp4 oT4.x, r0, c16
mad oT0.zw, v3.xyxy, c23.xyxy, c23
mad oT0.xy, v3, c22, c22.zwzw
dp4 oPos.w, v0, c3
dp4 oPos.z, v0, c2
dp4 oPos.y, v0, c1
dp4 oPos.x, v0, c0
dp3 oT1.z, v2, c4
dp3 oT1.x, v1, c4
dp3 oT2.z, v2, c5
dp3 oT2.x, v1, c5
"
}

SubProgram "d3d11 " {
Keywords { "SPOT" }
Bind "vertex" Vertex
Bind "tangent" TexCoord2
Bind "normal" Normal
Bind "texcoord" TexCoord0
Bind "color" Color
ConstBuffer "$Globals" 176 // 160 used size, 8 vars
Matrix 48 [_LightMatrix0] 4
Vector 128 [_MainTex_ST] 4
Vector 144 [_BumpMap_ST] 4
ConstBuffer "UnityLighting" 400 // 16 used size, 16 vars
Vector 0 [_WorldSpaceLightPos0] 4
ConstBuffer "UnityPerDraw" 336 // 336 used size, 6 vars
Matrix 0 [glstate_matrix_mvp] 4
Matrix 128 [glstate_matrix_invtrans_modelview0] 4
Matrix 192 [_Object2World] 4
Matrix 256 [_World2Object] 4
Vector 320 [unity_Scale] 4
BindCB "$Globals" 0
BindCB "UnityLighting" 1
BindCB "UnityPerDraw" 2
// 38 instructions, 2 temp regs, 0 temp arrays:
// ALU 15 float, 0 int, 0 uint
// TEX 0 (0 load, 0 comp, 0 bias, 0 grad)
// FLOW 1 static, 0 dynamic
"vs_4_0
eefiecedikgklpcmihibfmeimimajpmphkfcjnbbabaaaaaafeahaaaaadaaaaaa
cmaaaaaapeaaaaaakmabaaaaejfdeheomaaaaaaaagaaaaaaaiaaaaaajiaaaaaa
aaaaaaaaaaaaaaaaadaaaaaaaaaaaaaaapapaaaakbaaaaaaaaaaaaaaaaaaaaaa
adaaaaaaabaaaaaaapapaaaakjaaaaaaaaaaaaaaaaaaaaaaadaaaaaaacaaaaaa
ahahaaaalaaaaaaaaaaaaaaaaaaaaaaaadaaaaaaadaaaaaaapadaaaalaaaaaaa
abaaaaaaaaaaaaaaadaaaaaaaeaaaaaaapaaaaaaljaaaaaaaaaaaaaaaaaaaaaa
adaaaaaaafaaaaaaapaaaaaafaepfdejfeejepeoaafeebeoehefeofeaaeoepfc
enebemaafeeffiedepepfceeaaedepemepfcaaklepfdeheolaaaaaaaagaaaaaa
aiaaaaaajiaaaaaaaaaaaaaaabaaaaaaadaaaaaaaaaaaaaaapaaaaaakeaaaaaa
aaaaaaaaaaaaaaaaadaaaaaaabaaaaaaapaaaaaakeaaaaaaabaaaaaaaaaaaaaa
adaaaaaaacaaaaaaahaiaaaakeaaaaaaacaaaaaaaaaaaaaaadaaaaaaadaaaaaa
ahaiaaaakeaaaaaaadaaaaaaaaaaaaaaadaaaaaaaeaaaaaaahaiaaaakeaaaaaa
aeaaaaaaaaaaaaaaadaaaaaaafaaaaaaapaaaaaafdfgfpfaepfdejfeejepeoaa
feeffiedepepfceeaaklklklfdeieefckaafaaaaeaaaabaagiabaaaafjaaaaae
egiocaaaaaaaaaaaakaaaaaafjaaaaaeegiocaaaabaaaaaaabaaaaaafjaaaaae
egiocaaaacaaaaaabfaaaaaafpaaaaadpcbabaaaaaaaaaaafpaaaaadpcbabaaa
abaaaaaafpaaaaadhcbabaaaacaaaaaafpaaaaaddcbabaaaadaaaaaaghaaaaae
pccabaaaaaaaaaaaabaaaaaagfaaaaadpccabaaaabaaaaaagfaaaaadhccabaaa
acaaaaaagfaaaaadhccabaaaadaaaaaagfaaaaadhccabaaaaeaaaaaagfaaaaad
pccabaaaafaaaaaagiaaaaacacaaaaaadiaaaaaipcaabaaaaaaaaaaafgbfbaaa
aaaaaaaaegiocaaaacaaaaaaabaaaaaadcaaaaakpcaabaaaaaaaaaaaegiocaaa
acaaaaaaaaaaaaaaagbabaaaaaaaaaaaegaobaaaaaaaaaaadcaaaaakpcaabaaa
aaaaaaaaegiocaaaacaaaaaaacaaaaaakgbkbaaaaaaaaaaaegaobaaaaaaaaaaa
dcaaaaakpccabaaaaaaaaaaaegiocaaaacaaaaaaadaaaaaapgbpbaaaaaaaaaaa
egaobaaaaaaaaaaadcaaaaaldccabaaaabaaaaaaegbabaaaadaaaaaaegiacaaa
aaaaaaaaaiaaaaaaogikcaaaaaaaaaaaaiaaaaaadcaaaaalmccabaaaabaaaaaa
agbebaaaadaaaaaaagiecaaaaaaaaaaaajaaaaaakgiocaaaaaaaaaaaajaaaaaa
diaaaaahhcaabaaaaaaaaaaajgbebaaaabaaaaaacgbjbaaaacaaaaaadcaaaaak
hcaabaaaaaaaaaaajgbebaaaacaaaaaacgbjbaaaabaaaaaaegacbaiaebaaaaaa
aaaaaaaadiaaaaahhcaabaaaaaaaaaaaegacbaaaaaaaaaaapgbpbaaaabaaaaaa
dgaaaaagbcaabaaaabaaaaaaakiacaaaacaaaaaaaiaaaaaadgaaaaagccaabaaa
abaaaaaaakiacaaaacaaaaaaajaaaaaadgaaaaagecaabaaaabaaaaaaakiacaaa
acaaaaaaakaaaaaabaaaaaahcccabaaaacaaaaaaegacbaaaaaaaaaaaegacbaaa
abaaaaaabaaaaaahbccabaaaacaaaaaaegbcbaaaabaaaaaaegacbaaaabaaaaaa
baaaaaaheccabaaaacaaaaaaegbcbaaaacaaaaaaegacbaaaabaaaaaadgaaaaag
bcaabaaaabaaaaaabkiacaaaacaaaaaaaiaaaaaadgaaaaagccaabaaaabaaaaaa
bkiacaaaacaaaaaaajaaaaaadgaaaaagecaabaaaabaaaaaabkiacaaaacaaaaaa
akaaaaaabaaaaaahcccabaaaadaaaaaaegacbaaaaaaaaaaaegacbaaaabaaaaaa
baaaaaahbccabaaaadaaaaaaegbcbaaaabaaaaaaegacbaaaabaaaaaabaaaaaah
eccabaaaadaaaaaaegbcbaaaacaaaaaaegacbaaaabaaaaaadiaaaaajhcaabaaa
abaaaaaafgifcaaaabaaaaaaaaaaaaaaegiccaaaacaaaaaabbaaaaaadcaaaaal
hcaabaaaabaaaaaaegiccaaaacaaaaaabaaaaaaaagiacaaaabaaaaaaaaaaaaaa
egacbaaaabaaaaaadcaaaaalhcaabaaaabaaaaaaegiccaaaacaaaaaabcaaaaaa
kgikcaaaabaaaaaaaaaaaaaaegacbaaaabaaaaaadcaaaaalhcaabaaaabaaaaaa
egiccaaaacaaaaaabdaaaaaapgipcaaaabaaaaaaaaaaaaaaegacbaaaabaaaaaa
dcaaaaalhcaabaaaabaaaaaaegacbaaaabaaaaaapgipcaaaacaaaaaabeaaaaaa
egbcbaiaebaaaaaaaaaaaaaabaaaaaahcccabaaaaeaaaaaaegacbaaaaaaaaaaa
egacbaaaabaaaaaabaaaaaahbccabaaaaeaaaaaaegbcbaaaabaaaaaaegacbaaa
abaaaaaabaaaaaaheccabaaaaeaaaaaaegbcbaaaacaaaaaaegacbaaaabaaaaaa
diaaaaaipcaabaaaaaaaaaaafgbfbaaaaaaaaaaaegiocaaaacaaaaaaanaaaaaa
dcaaaaakpcaabaaaaaaaaaaaegiocaaaacaaaaaaamaaaaaaagbabaaaaaaaaaaa
egaobaaaaaaaaaaadcaaaaakpcaabaaaaaaaaaaaegiocaaaacaaaaaaaoaaaaaa
kgbkbaaaaaaaaaaaegaobaaaaaaaaaaadcaaaaakpcaabaaaaaaaaaaaegiocaaa
acaaaaaaapaaaaaapgbpbaaaaaaaaaaaegaobaaaaaaaaaaadiaaaaaipcaabaaa
abaaaaaafgafbaaaaaaaaaaaegiocaaaaaaaaaaaaeaaaaaadcaaaaakpcaabaaa
abaaaaaaegiocaaaaaaaaaaaadaaaaaaagaabaaaaaaaaaaaegaobaaaabaaaaaa
dcaaaaakpcaabaaaabaaaaaaegiocaaaaaaaaaaaafaaaaaakgakbaaaaaaaaaaa
egaobaaaabaaaaaadcaaaaakpccabaaaafaaaaaaegiocaaaaaaaaaaaagaaaaaa
pgapbaaaaaaaaaaaegaobaaaabaaaaaadoaaaaab"
}

SubProgram "gles " {
Keywords { "SPOT" }
"!!GLES
#define SHADER_API_GLES 1
#define tex2D texture2D


#ifdef VERTEX
#define gl_ModelViewProjectionMatrix glstate_matrix_mvp
uniform mat4 glstate_matrix_mvp;
#define gl_ModelViewMatrixInverseTranspose glstate_matrix_invtrans_modelview0
uniform mat4 glstate_matrix_invtrans_modelview0;
#define gl_ModelViewMatrix glstate_matrix_modelview0
uniform mat4 glstate_matrix_modelview0;

varying highp vec4 xlv_TEXCOORD4;
varying mediump vec3 xlv_TEXCOORD3;
varying highp vec3 xlv_TEXCOORD2;
varying highp vec3 xlv_TEXCOORD1;
varying highp vec4 xlv_TEXCOORD0;
uniform highp vec4 _BumpMap_ST;
uniform highp vec4 _MainTex_ST;
uniform highp mat4 _LightMatrix0;
uniform highp vec4 unity_Scale;
uniform highp mat4 _World2Object;
uniform highp mat4 _Object2World;


uniform highp vec4 _WorldSpaceLightPos0;
attribute vec4 _glesTANGENT;
attribute vec4 _glesMultiTexCoord0;
attribute vec3 _glesNormal;
attribute vec4 _glesVertex;
void main ()
{
  vec4 tmpvar_1;
  tmpvar_1.xyz = normalize(_glesTANGENT.xyz);
  tmpvar_1.w = _glesTANGENT.w;
  vec3 tmpvar_2;
  tmpvar_2 = normalize(_glesNormal);
  highp vec4 tmpvar_3;
  mediump vec3 tmpvar_4;
  highp vec3 tmpvar_5;
  highp vec3 tmpvar_6;
  tmpvar_5 = tmpvar_1.xyz;
  tmpvar_6 = (((tmpvar_2.yzx * tmpvar_1.zxy) - (tmpvar_2.zxy * tmpvar_1.yzx)) * _glesTANGENT.w);
  highp mat3 tmpvar_7;
  tmpvar_7[0].x = tmpvar_5.x;
  tmpvar_7[0].y = tmpvar_6.x;
  tmpvar_7[0].z = tmpvar_2.x;
  tmpvar_7[1].x = tmpvar_5.y;
  tmpvar_7[1].y = tmpvar_6.y;
  tmpvar_7[1].z = tmpvar_2.y;
  tmpvar_7[2].x = tmpvar_5.z;
  tmpvar_7[2].y = tmpvar_6.z;
  tmpvar_7[2].z = tmpvar_2.z;
  vec4 v_8;
  v_8.x = gl_ModelViewMatrixInverseTranspose[0].x;
  v_8.y = gl_ModelViewMatrixInverseTranspose[1].x;
  v_8.z = gl_ModelViewMatrixInverseTranspose[2].x;
  v_8.w = gl_ModelViewMatrixInverseTranspose[3].x;
  vec4 v_9;
  v_9.x = gl_ModelViewMatrixInverseTranspose[0].y;
  v_9.y = gl_ModelViewMatrixInverseTranspose[1].y;
  v_9.z = gl_ModelViewMatrixInverseTranspose[2].y;
  v_9.w = gl_ModelViewMatrixInverseTranspose[3].y;
  tmpvar_3.xy = ((_glesMultiTexCoord0.xy * _MainTex_ST.xy) + _MainTex_ST.zw);
  tmpvar_3.zw = ((_glesMultiTexCoord0.xy * _BumpMap_ST.xy) + _BumpMap_ST.zw);
  highp vec3 tmpvar_10;
  highp vec3 tmpvar_11;
  tmpvar_10 = tmpvar_1.xyz;
  tmpvar_11 = (((tmpvar_2.yzx * tmpvar_1.zxy) - (tmpvar_2.zxy * tmpvar_1.yzx)) * _glesTANGENT.w);
  highp mat3 tmpvar_12;
  tmpvar_12[0].x = tmpvar_10.x;
  tmpvar_12[0].y = tmpvar_11.x;
  tmpvar_12[0].z = tmpvar_2.x;
  tmpvar_12[1].x = tmpvar_10.y;
  tmpvar_12[1].y = tmpvar_11.y;
  tmpvar_12[1].z = tmpvar_2.y;
  tmpvar_12[2].x = tmpvar_10.z;
  tmpvar_12[2].y = tmpvar_11.z;
  tmpvar_12[2].z = tmpvar_2.z;
  highp vec3 tmpvar_13;
  tmpvar_13 = (tmpvar_12 * (((_World2Object * _WorldSpaceLightPos0).xyz * unity_Scale.w) - _glesVertex.xyz));
  tmpvar_4 = tmpvar_13;
  gl_Position = (gl_ModelViewProjectionMatrix * _glesVertex);
  xlv_TEXCOORD0 = tmpvar_3;
  xlv_TEXCOORD1 = (tmpvar_7 * v_8.xyz);
  xlv_TEXCOORD2 = (tmpvar_7 * v_9.xyz);
  xlv_TEXCOORD3 = tmpvar_4;
  xlv_TEXCOORD4 = (_LightMatrix0 * (_Object2World * _glesVertex));
}



#endif
#ifdef FRAGMENT

varying highp vec4 xlv_TEXCOORD4;
varying mediump vec3 xlv_TEXCOORD3;
varying highp vec4 xlv_TEXCOORD0;
uniform lowp float _Cutoff;
uniform sampler2D _BumpMap;
uniform sampler2D _MainTex;
uniform lowp vec4 _Color;
uniform sampler2D _LightTextureB0;
uniform sampler2D _LightTexture0;
uniform lowp vec4 _LightColor0;
void main ()
{
  lowp vec4 c_1;
  lowp vec3 lightDir_2;
  lowp vec4 tmpvar_3;
  tmpvar_3 = texture2D (_MainTex, xlv_TEXCOORD0.xy);
  lowp float tmpvar_4;
  tmpvar_4 = tmpvar_3.w;
  lowp float x_5;
  x_5 = (tmpvar_3.w - _Cutoff);
  if ((x_5 < 0.0)) {
    discard;
  };
  mediump vec3 tmpvar_6;
  tmpvar_6 = normalize(xlv_TEXCOORD3);
  lightDir_2 = tmpvar_6;
  highp vec2 P_7;
  P_7 = ((xlv_TEXCOORD4.xy / xlv_TEXCOORD4.w) + 0.5);
  highp float tmpvar_8;
  tmpvar_8 = dot (xlv_TEXCOORD4.xyz, xlv_TEXCOORD4.xyz);
  lowp float atten_9;
  atten_9 = ((float((xlv_TEXCOORD4.z > 0.0)) * texture2D (_LightTexture0, P_7).w) * texture2D (_LightTextureB0, vec2(tmpvar_8)).w);
  lowp vec4 c_10;
  c_10.xyz = (((texture2D (_MainTex, xlv_TEXCOORD0.xy).xyz * _Color.w) * _LightColor0.xyz) * ((max (0.0, dot (((texture2D (_BumpMap, xlv_TEXCOORD0.zw).xyz * 2.0) - 1.0), lightDir_2)) * atten_9) * 2.0));
  c_10.w = tmpvar_4;
  c_1.xyz = c_10.xyz;
  c_1.w = tmpvar_4;
  gl_FragData[0] = c_1;
}



#endif"
}

SubProgram "glesdesktop " {
Keywords { "SPOT" }
"!!GLES
#define SHADER_API_GLES 1
#define tex2D texture2D


#ifdef VERTEX
#define gl_ModelViewProjectionMatrix glstate_matrix_mvp
uniform mat4 glstate_matrix_mvp;
#define gl_ModelViewMatrixInverseTranspose glstate_matrix_invtrans_modelview0
uniform mat4 glstate_matrix_invtrans_modelview0;
#define gl_ModelViewMatrix glstate_matrix_modelview0
uniform mat4 glstate_matrix_modelview0;

varying highp vec4 xlv_TEXCOORD4;
varying mediump vec3 xlv_TEXCOORD3;
varying highp vec3 xlv_TEXCOORD2;
varying highp vec3 xlv_TEXCOORD1;
varying highp vec4 xlv_TEXCOORD0;
uniform highp vec4 _BumpMap_ST;
uniform highp vec4 _MainTex_ST;
uniform highp mat4 _LightMatrix0;
uniform highp vec4 unity_Scale;
uniform highp mat4 _World2Object;
uniform highp mat4 _Object2World;


uniform highp vec4 _WorldSpaceLightPos0;
attribute vec4 _glesTANGENT;
attribute vec4 _glesMultiTexCoord0;
attribute vec3 _glesNormal;
attribute vec4 _glesVertex;
void main ()
{
  vec4 tmpvar_1;
  tmpvar_1.xyz = normalize(_glesTANGENT.xyz);
  tmpvar_1.w = _glesTANGENT.w;
  vec3 tmpvar_2;
  tmpvar_2 = normalize(_glesNormal);
  highp vec4 tmpvar_3;
  mediump vec3 tmpvar_4;
  highp vec3 tmpvar_5;
  highp vec3 tmpvar_6;
  tmpvar_5 = tmpvar_1.xyz;
  tmpvar_6 = (((tmpvar_2.yzx * tmpvar_1.zxy) - (tmpvar_2.zxy * tmpvar_1.yzx)) * _glesTANGENT.w);
  highp mat3 tmpvar_7;
  tmpvar_7[0].x = tmpvar_5.x;
  tmpvar_7[0].y = tmpvar_6.x;
  tmpvar_7[0].z = tmpvar_2.x;
  tmpvar_7[1].x = tmpvar_5.y;
  tmpvar_7[1].y = tmpvar_6.y;
  tmpvar_7[1].z = tmpvar_2.y;
  tmpvar_7[2].x = tmpvar_5.z;
  tmpvar_7[2].y = tmpvar_6.z;
  tmpvar_7[2].z = tmpvar_2.z;
  vec4 v_8;
  v_8.x = gl_ModelViewMatrixInverseTranspose[0].x;
  v_8.y = gl_ModelViewMatrixInverseTranspose[1].x;
  v_8.z = gl_ModelViewMatrixInverseTranspose[2].x;
  v_8.w = gl_ModelViewMatrixInverseTranspose[3].x;
  vec4 v_9;
  v_9.x = gl_ModelViewMatrixInverseTranspose[0].y;
  v_9.y = gl_ModelViewMatrixInverseTranspose[1].y;
  v_9.z = gl_ModelViewMatrixInverseTranspose[2].y;
  v_9.w = gl_ModelViewMatrixInverseTranspose[3].y;
  tmpvar_3.xy = ((_glesMultiTexCoord0.xy * _MainTex_ST.xy) + _MainTex_ST.zw);
  tmpvar_3.zw = ((_glesMultiTexCoord0.xy * _BumpMap_ST.xy) + _BumpMap_ST.zw);
  highp vec3 tmpvar_10;
  highp vec3 tmpvar_11;
  tmpvar_10 = tmpvar_1.xyz;
  tmpvar_11 = (((tmpvar_2.yzx * tmpvar_1.zxy) - (tmpvar_2.zxy * tmpvar_1.yzx)) * _glesTANGENT.w);
  highp mat3 tmpvar_12;
  tmpvar_12[0].x = tmpvar_10.x;
  tmpvar_12[0].y = tmpvar_11.x;
  tmpvar_12[0].z = tmpvar_2.x;
  tmpvar_12[1].x = tmpvar_10.y;
  tmpvar_12[1].y = tmpvar_11.y;
  tmpvar_12[1].z = tmpvar_2.y;
  tmpvar_12[2].x = tmpvar_10.z;
  tmpvar_12[2].y = tmpvar_11.z;
  tmpvar_12[2].z = tmpvar_2.z;
  highp vec3 tmpvar_13;
  tmpvar_13 = (tmpvar_12 * (((_World2Object * _WorldSpaceLightPos0).xyz * unity_Scale.w) - _glesVertex.xyz));
  tmpvar_4 = tmpvar_13;
  gl_Position = (gl_ModelViewProjectionMatrix * _glesVertex);
  xlv_TEXCOORD0 = tmpvar_3;
  xlv_TEXCOORD1 = (tmpvar_7 * v_8.xyz);
  xlv_TEXCOORD2 = (tmpvar_7 * v_9.xyz);
  xlv_TEXCOORD3 = tmpvar_4;
  xlv_TEXCOORD4 = (_LightMatrix0 * (_Object2World * _glesVertex));
}



#endif
#ifdef FRAGMENT

varying highp vec4 xlv_TEXCOORD4;
varying mediump vec3 xlv_TEXCOORD3;
varying highp vec4 xlv_TEXCOORD0;
uniform lowp float _Cutoff;
uniform sampler2D _BumpMap;
uniform sampler2D _MainTex;
uniform lowp vec4 _Color;
uniform sampler2D _LightTextureB0;
uniform sampler2D _LightTexture0;
uniform lowp vec4 _LightColor0;
void main ()
{
  lowp vec4 c_1;
  lowp vec3 lightDir_2;
  lowp vec3 normal_3;
  normal_3.xy = ((texture2D (_BumpMap, xlv_TEXCOORD0.zw).wy * 2.0) - 1.0);
  normal_3.z = sqrt(((1.0 - (normal_3.x * normal_3.x)) - (normal_3.y * normal_3.y)));
  lowp vec4 tmpvar_4;
  tmpvar_4 = texture2D (_MainTex, xlv_TEXCOORD0.xy);
  lowp float tmpvar_5;
  tmpvar_5 = tmpvar_4.w;
  lowp float x_6;
  x_6 = (tmpvar_4.w - _Cutoff);
  if ((x_6 < 0.0)) {
    discard;
  };
  mediump vec3 tmpvar_7;
  tmpvar_7 = normalize(xlv_TEXCOORD3);
  lightDir_2 = tmpvar_7;
  highp vec2 P_8;
  P_8 = ((xlv_TEXCOORD4.xy / xlv_TEXCOORD4.w) + 0.5);
  highp float tmpvar_9;
  tmpvar_9 = dot (xlv_TEXCOORD4.xyz, xlv_TEXCOORD4.xyz);
  lowp float atten_10;
  atten_10 = ((float((xlv_TEXCOORD4.z > 0.0)) * texture2D (_LightTexture0, P_8).w) * texture2D (_LightTextureB0, vec2(tmpvar_9)).w);
  lowp vec4 c_11;
  c_11.xyz = (((texture2D (_MainTex, xlv_TEXCOORD0.xy).xyz * _Color.w) * _LightColor0.xyz) * ((max (0.0, dot (normal_3, lightDir_2)) * atten_10) * 2.0));
  c_11.w = tmpvar_5;
  c_1.xyz = c_11.xyz;
  c_1.w = tmpvar_5;
  gl_FragData[0] = c_1;
}



#endif"
}

SubProgram "flash " {
Keywords { "SPOT" }
Bind "vertex" Vertex
Bind "tangent" TexCoord2
Bind "normal" Normal
Bind "texcoord" TexCoord0
Matrix 0 [glstate_matrix_mvp]
Matrix 4 [glstate_matrix_invtrans_modelview0]
Vector 20 [_WorldSpaceLightPos0]
Matrix 8 [_Object2World]
Matrix 12 [_World2Object]
Vector 21 [unity_Scale]
Matrix 16 [_LightMatrix0]
Vector 22 [_MainTex_ST]
Vector 23 [_BumpMap_ST]
"agal_vs
[bc]
aaaaaaaaabaaahacafaaaaoeaaaaaaaaaaaaaaaaaaaaaaaa mov r1.xyz, a5
aaaaaaaaaaaaapacaoaaaaoeabaaaaaaaaaaaaaaaaaaaaaa mov r0, c14
adaaaaaaacaaahacabaaaancaaaaaaaaabaaaaajacaaaaaa mul r2.xyz, a1.zxyw, r1.yzxx
aaaaaaaaabaaahacafaaaaoeaaaaaaaaaaaaaaaaaaaaaaaa mov r1.xyz, a5
adaaaaaaadaaahacabaaaamjaaaaaaaaabaaaafcacaaaaaa mul r3.xyz, a1.yzxw, r1.zxyy
acaaaaaaacaaahacadaaaakeacaaaaaaacaaaakeacaaaaaa sub r2.xyz, r3.xyzz, r2.xyzz
bdaaaaaaadaaaeacbeaaaaoeabaaaaaaaaaaaaoeacaaaaaa dp4 r3.z, c20, r0
aaaaaaaaaaaaapacanaaaaoeabaaaaaaaaaaaaaaaaaaaaaa mov r0, c13
aaaaaaaaabaaapacamaaaaoeabaaaaaaaaaaaaaaaaaaaaaa mov r1, c12
bdaaaaaaadaaabacbeaaaaoeabaaaaaaabaaaaoeacaaaaaa dp4 r3.x, c20, r1
adaaaaaaabaaahacacaaaakeacaaaaaaafaaaappaaaaaaaa mul r1.xyz, r2.xyzz, a5.w
bdaaaaaaadaaacacbeaaaaoeabaaaaaaaaaaaaoeacaaaaaa dp4 r3.y, c20, r0
adaaaaaaacaaahacadaaaakeacaaaaaabfaaaappabaaaaaa mul r2.xyz, r3.xyzz, c21.w
acaaaaaaaaaaahacacaaaakeacaaaaaaaaaaaaoeaaaaaaaa sub r0.xyz, r2.xyzz, a0
bdaaaaaaaaaaaiacaaaaaaoeaaaaaaaaalaaaaoeabaaaaaa dp4 r0.w, a0, c11
bcaaaaaaadaaacaeabaaaakeacaaaaaaaaaaaakeacaaaaaa dp3 v3.y, r1.xyzz, r0.xyzz
bcaaaaaaadaaaeaeabaaaaoeaaaaaaaaaaaaaakeacaaaaaa dp3 v3.z, a1, r0.xyzz
bcaaaaaaadaaabaeafaaaaoeaaaaaaaaaaaaaakeacaaaaaa dp3 v3.x, a5, r0.xyzz
bdaaaaaaaaaaaeacaaaaaaoeaaaaaaaaakaaaaoeabaaaaaa dp4 r0.z, a0, c10
bdaaaaaaaaaaabacaaaaaaoeaaaaaaaaaiaaaaoeabaaaaaa dp4 r0.x, a0, c8
bdaaaaaaaaaaacacaaaaaaoeaaaaaaaaajaaaaoeabaaaaaa dp4 r0.y, a0, c9
bcaaaaaaabaaacaeabaaaakeacaaaaaaaeaaaaoeabaaaaaa dp3 v1.y, r1.xyzz, c4
bcaaaaaaacaaacaeabaaaakeacaaaaaaafaaaaoeabaaaaaa dp3 v2.y, r1.xyzz, c5
bdaaaaaaaeaaaiaeaaaaaaoeacaaaaaabdaaaaoeabaaaaaa dp4 v4.w, r0, c19
bdaaaaaaaeaaaeaeaaaaaaoeacaaaaaabcaaaaoeabaaaaaa dp4 v4.z, r0, c18
bdaaaaaaaeaaacaeaaaaaaoeacaaaaaabbaaaaoeabaaaaaa dp4 v4.y, r0, c17
bdaaaaaaaeaaabaeaaaaaaoeacaaaaaabaaaaaoeabaaaaaa dp4 v4.x, r0, c16
adaaaaaaaaaaamacadaaaaeeaaaaaaaabhaaaaeeabaaaaaa mul r0.zw, a3.xyxy, c23.xyxy
abaaaaaaaaaaamaeaaaaaaopacaaaaaabhaaaaoeabaaaaaa add v0.zw, r0.wwzw, c23
adaaaaaaaaaaadacadaaaaoeaaaaaaaabgaaaaoeabaaaaaa mul r0.xy, a3, c22
abaaaaaaaaaaadaeaaaaaafeacaaaaaabgaaaaooabaaaaaa add v0.xy, r0.xyyy, c22.zwzw
bdaaaaaaaaaaaiadaaaaaaoeaaaaaaaaadaaaaoeabaaaaaa dp4 o0.w, a0, c3
bdaaaaaaaaaaaeadaaaaaaoeaaaaaaaaacaaaaoeabaaaaaa dp4 o0.z, a0, c2
bdaaaaaaaaaaacadaaaaaaoeaaaaaaaaabaaaaoeabaaaaaa dp4 o0.y, a0, c1
bdaaaaaaaaaaabadaaaaaaoeaaaaaaaaaaaaaaoeabaaaaaa dp4 o0.x, a0, c0
bcaaaaaaabaaaeaeabaaaaoeaaaaaaaaaeaaaaoeabaaaaaa dp3 v1.z, a1, c4
bcaaaaaaabaaabaeafaaaaoeaaaaaaaaaeaaaaoeabaaaaaa dp3 v1.x, a5, c4
bcaaaaaaacaaaeaeabaaaaoeaaaaaaaaafaaaaoeabaaaaaa dp3 v2.z, a1, c5
bcaaaaaaacaaabaeafaaaaoeaaaaaaaaafaaaaoeabaaaaaa dp3 v2.x, a5, c5
aaaaaaaaabaaaiaeaaaaaaoeabaaaaaaaaaaaaaaaaaaaaaa mov v1.w, c0
aaaaaaaaacaaaiaeaaaaaaoeabaaaaaaaaaaaaaaaaaaaaaa mov v2.w, c0
aaaaaaaaadaaaiaeaaaaaaoeabaaaaaaaaaaaaaaaaaaaaaa mov v3.w, c0
"
}

SubProgram "d3d11_9x " {
Keywords { "SPOT" }
Bind "vertex" Vertex
Bind "tangent" TexCoord2
Bind "normal" Normal
Bind "texcoord" TexCoord0
Bind "color" Color
ConstBuffer "$Globals" 176 // 160 used size, 8 vars
Matrix 48 [_LightMatrix0] 4
Vector 128 [_MainTex_ST] 4
Vector 144 [_BumpMap_ST] 4
ConstBuffer "UnityLighting" 400 // 16 used size, 16 vars
Vector 0 [_WorldSpaceLightPos0] 4
ConstBuffer "UnityPerDraw" 336 // 336 used size, 6 vars
Matrix 0 [glstate_matrix_mvp] 4
Matrix 128 [glstate_matrix_invtrans_modelview0] 4
Matrix 192 [_Object2World] 4
Matrix 256 [_World2Object] 4
Vector 320 [unity_Scale] 4
BindCB "$Globals" 0
BindCB "UnityLighting" 1
BindCB "UnityPerDraw" 2
// 38 instructions, 2 temp regs, 0 temp arrays:
// ALU 15 float, 0 int, 0 uint
// TEX 0 (0 load, 0 comp, 0 bias, 0 grad)
// FLOW 1 static, 0 dynamic
"vs_4_0_level_9_3
eefiecednfpimkhcfbkplgecglgkohhinnjlmjhlabaaaaaaliakaaaaaeaaaaaa
daaaaaaajaadaaaadiajaaaaaaakaaaaebgpgodjfiadaaaafiadaaaaaaacpopp
oiacaaaahaaaaaaaagaaceaaaaaagmaaaaaagmaaaaaaceaaabaagmaaaaaaadaa
aeaaabaaaaaaaaaaaaaaaiaaacaaafaaaaaaaaaaabaaaaaaabaaahaaaaaaaaaa
acaaaaaaaeaaaiaaaaaaaaaaacaaaiaaadaaamaaaaaaaaaaacaaamaaajaaapaa
aaaaaaaaaaaaaaaaabacpoppbpaaaaacafaaaaiaaaaaapjabpaaaaacafaaabia
abaaapjabpaaaaacafaaaciaacaaapjabpaaaaacafaaadiaadaaapjaabaaaaac
aaaaabiaamaaaakaabaaaaacaaaaaciaanaaaakaabaaaaacaaaaaeiaaoaaaaka
aiaaaaadabaaaboaabaaoejaaaaaoeiaabaaaaacabaaahiaabaaoejaafaaaaad
acaaahiaabaamjiaacaancjaaeaaaaaeabaaahiaacaamjjaabaanciaacaaoeib
afaaaaadabaaahiaabaaoeiaabaappjaaiaaaaadabaaacoaabaaoeiaaaaaoeia
aiaaaaadabaaaeoaacaaoejaaaaaoeiaabaaaaacaaaaabiaamaaffkaabaaaaac
aaaaaciaanaaffkaabaaaaacaaaaaeiaaoaaffkaaiaaaaadacaaaboaabaaoeja
aaaaoeiaaiaaaaadacaaacoaabaaoeiaaaaaoeiaaiaaaaadacaaaeoaacaaoeja
aaaaoeiaaeaaaaaeaaaaadoaadaaoejaafaaoekaafaaookaaeaaaaaeaaaaamoa
adaaeejaagaaeekaagaaoekaabaaaaacaaaaapiaahaaoekaafaaaaadacaaahia
aaaaffiabeaaoekaaeaaaaaeacaaahiabdaaoekaaaaaaaiaacaaoeiaaeaaaaae
aaaaahiabfaaoekaaaaakkiaacaaoeiaaeaaaaaeaaaaahiabgaaoekaaaaappia
aaaaoeiaaeaaaaaeaaaaahiaaaaaoeiabhaappkaaaaaoejbaiaaaaadadaaaboa
abaaoejaaaaaoeiaaiaaaaadadaaacoaabaaoeiaaaaaoeiaaiaaaaadadaaaeoa
acaaoejaaaaaoeiaafaaaaadaaaaapiaaaaaffjabaaaoekaaeaaaaaeaaaaapia
apaaoekaaaaaaajaaaaaoeiaaeaaaaaeaaaaapiabbaaoekaaaaakkjaaaaaoeia
aeaaaaaeaaaaapiabcaaoekaaaaappjaaaaaoeiaafaaaaadabaaapiaaaaaffia
acaaoekaaeaaaaaeabaaapiaabaaoekaaaaaaaiaabaaoeiaaeaaaaaeabaaapia
adaaoekaaaaakkiaabaaoeiaaeaaaaaeaeaaapoaaeaaoekaaaaappiaabaaoeia
afaaaaadaaaaapiaaaaaffjaajaaoekaaeaaaaaeaaaaapiaaiaaoekaaaaaaaja
aaaaoeiaaeaaaaaeaaaaapiaakaaoekaaaaakkjaaaaaoeiaaeaaaaaeaaaaapia
alaaoekaaaaappjaaaaaoeiaaeaaaaaeaaaaadmaaaaappiaaaaaoekaaaaaoeia
abaaaaacaaaaammaaaaaoeiappppaaaafdeieefckaafaaaaeaaaabaagiabaaaa
fjaaaaaeegiocaaaaaaaaaaaakaaaaaafjaaaaaeegiocaaaabaaaaaaabaaaaaa
fjaaaaaeegiocaaaacaaaaaabfaaaaaafpaaaaadpcbabaaaaaaaaaaafpaaaaad
pcbabaaaabaaaaaafpaaaaadhcbabaaaacaaaaaafpaaaaaddcbabaaaadaaaaaa
ghaaaaaepccabaaaaaaaaaaaabaaaaaagfaaaaadpccabaaaabaaaaaagfaaaaad
hccabaaaacaaaaaagfaaaaadhccabaaaadaaaaaagfaaaaadhccabaaaaeaaaaaa
gfaaaaadpccabaaaafaaaaaagiaaaaacacaaaaaadiaaaaaipcaabaaaaaaaaaaa
fgbfbaaaaaaaaaaaegiocaaaacaaaaaaabaaaaaadcaaaaakpcaabaaaaaaaaaaa
egiocaaaacaaaaaaaaaaaaaaagbabaaaaaaaaaaaegaobaaaaaaaaaaadcaaaaak
pcaabaaaaaaaaaaaegiocaaaacaaaaaaacaaaaaakgbkbaaaaaaaaaaaegaobaaa
aaaaaaaadcaaaaakpccabaaaaaaaaaaaegiocaaaacaaaaaaadaaaaaapgbpbaaa
aaaaaaaaegaobaaaaaaaaaaadcaaaaaldccabaaaabaaaaaaegbabaaaadaaaaaa
egiacaaaaaaaaaaaaiaaaaaaogikcaaaaaaaaaaaaiaaaaaadcaaaaalmccabaaa
abaaaaaaagbebaaaadaaaaaaagiecaaaaaaaaaaaajaaaaaakgiocaaaaaaaaaaa
ajaaaaaadiaaaaahhcaabaaaaaaaaaaajgbebaaaabaaaaaacgbjbaaaacaaaaaa
dcaaaaakhcaabaaaaaaaaaaajgbebaaaacaaaaaacgbjbaaaabaaaaaaegacbaia
ebaaaaaaaaaaaaaadiaaaaahhcaabaaaaaaaaaaaegacbaaaaaaaaaaapgbpbaaa
abaaaaaadgaaaaagbcaabaaaabaaaaaaakiacaaaacaaaaaaaiaaaaaadgaaaaag
ccaabaaaabaaaaaaakiacaaaacaaaaaaajaaaaaadgaaaaagecaabaaaabaaaaaa
akiacaaaacaaaaaaakaaaaaabaaaaaahcccabaaaacaaaaaaegacbaaaaaaaaaaa
egacbaaaabaaaaaabaaaaaahbccabaaaacaaaaaaegbcbaaaabaaaaaaegacbaaa
abaaaaaabaaaaaaheccabaaaacaaaaaaegbcbaaaacaaaaaaegacbaaaabaaaaaa
dgaaaaagbcaabaaaabaaaaaabkiacaaaacaaaaaaaiaaaaaadgaaaaagccaabaaa
abaaaaaabkiacaaaacaaaaaaajaaaaaadgaaaaagecaabaaaabaaaaaabkiacaaa
acaaaaaaakaaaaaabaaaaaahcccabaaaadaaaaaaegacbaaaaaaaaaaaegacbaaa
abaaaaaabaaaaaahbccabaaaadaaaaaaegbcbaaaabaaaaaaegacbaaaabaaaaaa
baaaaaaheccabaaaadaaaaaaegbcbaaaacaaaaaaegacbaaaabaaaaaadiaaaaaj
hcaabaaaabaaaaaafgifcaaaabaaaaaaaaaaaaaaegiccaaaacaaaaaabbaaaaaa
dcaaaaalhcaabaaaabaaaaaaegiccaaaacaaaaaabaaaaaaaagiacaaaabaaaaaa
aaaaaaaaegacbaaaabaaaaaadcaaaaalhcaabaaaabaaaaaaegiccaaaacaaaaaa
bcaaaaaakgikcaaaabaaaaaaaaaaaaaaegacbaaaabaaaaaadcaaaaalhcaabaaa
abaaaaaaegiccaaaacaaaaaabdaaaaaapgipcaaaabaaaaaaaaaaaaaaegacbaaa
abaaaaaadcaaaaalhcaabaaaabaaaaaaegacbaaaabaaaaaapgipcaaaacaaaaaa
beaaaaaaegbcbaiaebaaaaaaaaaaaaaabaaaaaahcccabaaaaeaaaaaaegacbaaa
aaaaaaaaegacbaaaabaaaaaabaaaaaahbccabaaaaeaaaaaaegbcbaaaabaaaaaa
egacbaaaabaaaaaabaaaaaaheccabaaaaeaaaaaaegbcbaaaacaaaaaaegacbaaa
abaaaaaadiaaaaaipcaabaaaaaaaaaaafgbfbaaaaaaaaaaaegiocaaaacaaaaaa
anaaaaaadcaaaaakpcaabaaaaaaaaaaaegiocaaaacaaaaaaamaaaaaaagbabaaa
aaaaaaaaegaobaaaaaaaaaaadcaaaaakpcaabaaaaaaaaaaaegiocaaaacaaaaaa
aoaaaaaakgbkbaaaaaaaaaaaegaobaaaaaaaaaaadcaaaaakpcaabaaaaaaaaaaa
egiocaaaacaaaaaaapaaaaaapgbpbaaaaaaaaaaaegaobaaaaaaaaaaadiaaaaai
pcaabaaaabaaaaaafgafbaaaaaaaaaaaegiocaaaaaaaaaaaaeaaaaaadcaaaaak
pcaabaaaabaaaaaaegiocaaaaaaaaaaaadaaaaaaagaabaaaaaaaaaaaegaobaaa
abaaaaaadcaaaaakpcaabaaaabaaaaaaegiocaaaaaaaaaaaafaaaaaakgakbaaa
aaaaaaaaegaobaaaabaaaaaadcaaaaakpccabaaaafaaaaaaegiocaaaaaaaaaaa
agaaaaaapgapbaaaaaaaaaaaegaobaaaabaaaaaadoaaaaabejfdeheomaaaaaaa
agaaaaaaaiaaaaaajiaaaaaaaaaaaaaaaaaaaaaaadaaaaaaaaaaaaaaapapaaaa
kbaaaaaaaaaaaaaaaaaaaaaaadaaaaaaabaaaaaaapapaaaakjaaaaaaaaaaaaaa
aaaaaaaaadaaaaaaacaaaaaaahahaaaalaaaaaaaaaaaaaaaaaaaaaaaadaaaaaa
adaaaaaaapadaaaalaaaaaaaabaaaaaaaaaaaaaaadaaaaaaaeaaaaaaapaaaaaa
ljaaaaaaaaaaaaaaaaaaaaaaadaaaaaaafaaaaaaapaaaaaafaepfdejfeejepeo
aafeebeoehefeofeaaeoepfcenebemaafeeffiedepepfceeaaedepemepfcaakl
epfdeheolaaaaaaaagaaaaaaaiaaaaaajiaaaaaaaaaaaaaaabaaaaaaadaaaaaa
aaaaaaaaapaaaaaakeaaaaaaaaaaaaaaaaaaaaaaadaaaaaaabaaaaaaapaaaaaa
keaaaaaaabaaaaaaaaaaaaaaadaaaaaaacaaaaaaahaiaaaakeaaaaaaacaaaaaa
aaaaaaaaadaaaaaaadaaaaaaahaiaaaakeaaaaaaadaaaaaaaaaaaaaaadaaaaaa
aeaaaaaaahaiaaaakeaaaaaaaeaaaaaaaaaaaaaaadaaaaaaafaaaaaaapaaaaaa
fdfgfpfaepfdejfeejepeoaafeeffiedepepfceeaaklklkl"
}

SubProgram "opengl " {
Keywords { "POINT_COOKIE" }
Bind "vertex" Vertex
Bind "tangent" ATTR14
Bind "normal" Normal
Bind "texcoord" TexCoord0
Vector 21 [_WorldSpaceLightPos0]
Matrix 9 [_Object2World]
Matrix 13 [_World2Object]
Vector 22 [unity_Scale]
Matrix 17 [_LightMatrix0]
Vector 23 [_MainTex_ST]
Vector 24 [_BumpMap_ST]
"!!ARBvp1.0
# 31 ALU
PARAM c[25] = { program.local[0],
		state.matrix.mvp,
		state.matrix.modelview[0].invtrans,
		program.local[9..24] };
TEMP R0;
TEMP R1;
TEMP R2;
MOV R0.xyz, vertex.attrib[14];
MUL R2.xyz, vertex.normal.zxyw, R0.yzxw;
MAD R0.xyz, vertex.normal.yzxw, R0.zxyw, -R2;
MOV R1, c[21];
MUL R0.xyz, R0, vertex.attrib[14].w;
DP3 result.texcoord[1].y, R0, c[5];
DP3 result.texcoord[2].y, R0, c[6];
DP4 R0.w, vertex.position, c[12];
DP4 R2.z, R1, c[15];
DP4 R2.x, R1, c[13];
DP4 R2.y, R1, c[14];
MAD R1.xyz, R2, c[22].w, -vertex.position;
DP3 result.texcoord[3].y, R0, R1;
DP4 R0.z, vertex.position, c[11];
DP4 R0.x, vertex.position, c[9];
DP4 R0.y, vertex.position, c[10];
DP3 result.texcoord[3].z, vertex.normal, R1;
DP3 result.texcoord[3].x, vertex.attrib[14], R1;
DP4 result.texcoord[4].z, R0, c[19];
DP4 result.texcoord[4].y, R0, c[18];
DP4 result.texcoord[4].x, R0, c[17];
MAD result.texcoord[0].zw, vertex.texcoord[0].xyxy, c[24].xyxy, c[24];
MAD result.texcoord[0].xy, vertex.texcoord[0], c[23], c[23].zwzw;
DP4 result.position.w, vertex.position, c[4];
DP4 result.position.z, vertex.position, c[3];
DP4 result.position.y, vertex.position, c[2];
DP4 result.position.x, vertex.position, c[1];
DP3 result.texcoord[1].z, vertex.normal, c[5];
DP3 result.texcoord[1].x, vertex.attrib[14], c[5];
DP3 result.texcoord[2].z, vertex.normal, c[6];
DP3 result.texcoord[2].x, vertex.attrib[14], c[6];
END
# 31 instructions, 3 R-regs
"
}

SubProgram "d3d9 " {
Keywords { "POINT_COOKIE" }
Bind "vertex" Vertex
Bind "tangent" TexCoord2
Bind "normal" Normal
Bind "texcoord" TexCoord0
Matrix 0 [glstate_matrix_mvp]
Matrix 4 [glstate_matrix_invtrans_modelview0]
Vector 20 [_WorldSpaceLightPos0]
Matrix 8 [_Object2World]
Matrix 12 [_World2Object]
Vector 21 [unity_Scale]
Matrix 16 [_LightMatrix0]
Vector 22 [_MainTex_ST]
Vector 23 [_BumpMap_ST]
"vs_2_0
; 34 ALU
dcl_position0 v0
dcl_tangent0 v1
dcl_normal0 v2
dcl_texcoord0 v3
mov r1.xyz, v1
mov r0, c14
mul r2.xyz, v2.zxyw, r1.yzxw
mov r1.xyz, v1
mad r2.xyz, v2.yzxw, r1.zxyw, -r2
dp4 r3.z, c20, r0
mov r0, c13
mov r1, c12
dp4 r3.x, c20, r1
mul r1.xyz, r2, v1.w
dp4 r3.y, c20, r0
mad r0.xyz, r3, c21.w, -v0
dp3 oT3.y, r1, r0
dp3 oT3.z, v2, r0
dp3 oT3.x, v1, r0
dp4 r0.w, v0, c11
dp4 r0.z, v0, c10
dp4 r0.x, v0, c8
dp4 r0.y, v0, c9
dp3 oT1.y, r1, c4
dp3 oT2.y, r1, c5
dp4 oT4.z, r0, c18
dp4 oT4.y, r0, c17
dp4 oT4.x, r0, c16
mad oT0.zw, v3.xyxy, c23.xyxy, c23
mad oT0.xy, v3, c22, c22.zwzw
dp4 oPos.w, v0, c3
dp4 oPos.z, v0, c2
dp4 oPos.y, v0, c1
dp4 oPos.x, v0, c0
dp3 oT1.z, v2, c4
dp3 oT1.x, v1, c4
dp3 oT2.z, v2, c5
dp3 oT2.x, v1, c5
"
}

SubProgram "d3d11 " {
Keywords { "POINT_COOKIE" }
Bind "vertex" Vertex
Bind "tangent" TexCoord2
Bind "normal" Normal
Bind "texcoord" TexCoord0
Bind "color" Color
ConstBuffer "$Globals" 176 // 160 used size, 8 vars
Matrix 48 [_LightMatrix0] 4
Vector 128 [_MainTex_ST] 4
Vector 144 [_BumpMap_ST] 4
ConstBuffer "UnityLighting" 400 // 16 used size, 16 vars
Vector 0 [_WorldSpaceLightPos0] 4
ConstBuffer "UnityPerDraw" 336 // 336 used size, 6 vars
Matrix 0 [glstate_matrix_mvp] 4
Matrix 128 [glstate_matrix_invtrans_modelview0] 4
Matrix 192 [_Object2World] 4
Matrix 256 [_World2Object] 4
Vector 320 [unity_Scale] 4
BindCB "$Globals" 0
BindCB "UnityLighting" 1
BindCB "UnityPerDraw" 2
// 38 instructions, 2 temp regs, 0 temp arrays:
// ALU 15 float, 0 int, 0 uint
// TEX 0 (0 load, 0 comp, 0 bias, 0 grad)
// FLOW 1 static, 0 dynamic
"vs_4_0
eefiecedcgnmejllegcfldjpgekbfegnpkfoniddabaaaaaafeahaaaaadaaaaaa
cmaaaaaapeaaaaaakmabaaaaejfdeheomaaaaaaaagaaaaaaaiaaaaaajiaaaaaa
aaaaaaaaaaaaaaaaadaaaaaaaaaaaaaaapapaaaakbaaaaaaaaaaaaaaaaaaaaaa
adaaaaaaabaaaaaaapapaaaakjaaaaaaaaaaaaaaaaaaaaaaadaaaaaaacaaaaaa
ahahaaaalaaaaaaaaaaaaaaaaaaaaaaaadaaaaaaadaaaaaaapadaaaalaaaaaaa
abaaaaaaaaaaaaaaadaaaaaaaeaaaaaaapaaaaaaljaaaaaaaaaaaaaaaaaaaaaa
adaaaaaaafaaaaaaapaaaaaafaepfdejfeejepeoaafeebeoehefeofeaaeoepfc
enebemaafeeffiedepepfceeaaedepemepfcaaklepfdeheolaaaaaaaagaaaaaa
aiaaaaaajiaaaaaaaaaaaaaaabaaaaaaadaaaaaaaaaaaaaaapaaaaaakeaaaaaa
aaaaaaaaaaaaaaaaadaaaaaaabaaaaaaapaaaaaakeaaaaaaabaaaaaaaaaaaaaa
adaaaaaaacaaaaaaahaiaaaakeaaaaaaacaaaaaaaaaaaaaaadaaaaaaadaaaaaa
ahaiaaaakeaaaaaaadaaaaaaaaaaaaaaadaaaaaaaeaaaaaaahaiaaaakeaaaaaa
aeaaaaaaaaaaaaaaadaaaaaaafaaaaaaahaiaaaafdfgfpfaepfdejfeejepeoaa
feeffiedepepfceeaaklklklfdeieefckaafaaaaeaaaabaagiabaaaafjaaaaae
egiocaaaaaaaaaaaakaaaaaafjaaaaaeegiocaaaabaaaaaaabaaaaaafjaaaaae
egiocaaaacaaaaaabfaaaaaafpaaaaadpcbabaaaaaaaaaaafpaaaaadpcbabaaa
abaaaaaafpaaaaadhcbabaaaacaaaaaafpaaaaaddcbabaaaadaaaaaaghaaaaae
pccabaaaaaaaaaaaabaaaaaagfaaaaadpccabaaaabaaaaaagfaaaaadhccabaaa
acaaaaaagfaaaaadhccabaaaadaaaaaagfaaaaadhccabaaaaeaaaaaagfaaaaad
hccabaaaafaaaaaagiaaaaacacaaaaaadiaaaaaipcaabaaaaaaaaaaafgbfbaaa
aaaaaaaaegiocaaaacaaaaaaabaaaaaadcaaaaakpcaabaaaaaaaaaaaegiocaaa
acaaaaaaaaaaaaaaagbabaaaaaaaaaaaegaobaaaaaaaaaaadcaaaaakpcaabaaa
aaaaaaaaegiocaaaacaaaaaaacaaaaaakgbkbaaaaaaaaaaaegaobaaaaaaaaaaa
dcaaaaakpccabaaaaaaaaaaaegiocaaaacaaaaaaadaaaaaapgbpbaaaaaaaaaaa
egaobaaaaaaaaaaadcaaaaaldccabaaaabaaaaaaegbabaaaadaaaaaaegiacaaa
aaaaaaaaaiaaaaaaogikcaaaaaaaaaaaaiaaaaaadcaaaaalmccabaaaabaaaaaa
agbebaaaadaaaaaaagiecaaaaaaaaaaaajaaaaaakgiocaaaaaaaaaaaajaaaaaa
diaaaaahhcaabaaaaaaaaaaajgbebaaaabaaaaaacgbjbaaaacaaaaaadcaaaaak
hcaabaaaaaaaaaaajgbebaaaacaaaaaacgbjbaaaabaaaaaaegacbaiaebaaaaaa
aaaaaaaadiaaaaahhcaabaaaaaaaaaaaegacbaaaaaaaaaaapgbpbaaaabaaaaaa
dgaaaaagbcaabaaaabaaaaaaakiacaaaacaaaaaaaiaaaaaadgaaaaagccaabaaa
abaaaaaaakiacaaaacaaaaaaajaaaaaadgaaaaagecaabaaaabaaaaaaakiacaaa
acaaaaaaakaaaaaabaaaaaahcccabaaaacaaaaaaegacbaaaaaaaaaaaegacbaaa
abaaaaaabaaaaaahbccabaaaacaaaaaaegbcbaaaabaaaaaaegacbaaaabaaaaaa
baaaaaaheccabaaaacaaaaaaegbcbaaaacaaaaaaegacbaaaabaaaaaadgaaaaag
bcaabaaaabaaaaaabkiacaaaacaaaaaaaiaaaaaadgaaaaagccaabaaaabaaaaaa
bkiacaaaacaaaaaaajaaaaaadgaaaaagecaabaaaabaaaaaabkiacaaaacaaaaaa
akaaaaaabaaaaaahcccabaaaadaaaaaaegacbaaaaaaaaaaaegacbaaaabaaaaaa
baaaaaahbccabaaaadaaaaaaegbcbaaaabaaaaaaegacbaaaabaaaaaabaaaaaah
eccabaaaadaaaaaaegbcbaaaacaaaaaaegacbaaaabaaaaaadiaaaaajhcaabaaa
abaaaaaafgifcaaaabaaaaaaaaaaaaaaegiccaaaacaaaaaabbaaaaaadcaaaaal
hcaabaaaabaaaaaaegiccaaaacaaaaaabaaaaaaaagiacaaaabaaaaaaaaaaaaaa
egacbaaaabaaaaaadcaaaaalhcaabaaaabaaaaaaegiccaaaacaaaaaabcaaaaaa
kgikcaaaabaaaaaaaaaaaaaaegacbaaaabaaaaaadcaaaaalhcaabaaaabaaaaaa
egiccaaaacaaaaaabdaaaaaapgipcaaaabaaaaaaaaaaaaaaegacbaaaabaaaaaa
dcaaaaalhcaabaaaabaaaaaaegacbaaaabaaaaaapgipcaaaacaaaaaabeaaaaaa
egbcbaiaebaaaaaaaaaaaaaabaaaaaahcccabaaaaeaaaaaaegacbaaaaaaaaaaa
egacbaaaabaaaaaabaaaaaahbccabaaaaeaaaaaaegbcbaaaabaaaaaaegacbaaa
abaaaaaabaaaaaaheccabaaaaeaaaaaaegbcbaaaacaaaaaaegacbaaaabaaaaaa
diaaaaaipcaabaaaaaaaaaaafgbfbaaaaaaaaaaaegiocaaaacaaaaaaanaaaaaa
dcaaaaakpcaabaaaaaaaaaaaegiocaaaacaaaaaaamaaaaaaagbabaaaaaaaaaaa
egaobaaaaaaaaaaadcaaaaakpcaabaaaaaaaaaaaegiocaaaacaaaaaaaoaaaaaa
kgbkbaaaaaaaaaaaegaobaaaaaaaaaaadcaaaaakpcaabaaaaaaaaaaaegiocaaa
acaaaaaaapaaaaaapgbpbaaaaaaaaaaaegaobaaaaaaaaaaadiaaaaaihcaabaaa
abaaaaaafgafbaaaaaaaaaaaegiccaaaaaaaaaaaaeaaaaaadcaaaaakhcaabaaa
abaaaaaaegiccaaaaaaaaaaaadaaaaaaagaabaaaaaaaaaaaegacbaaaabaaaaaa
dcaaaaakhcaabaaaaaaaaaaaegiccaaaaaaaaaaaafaaaaaakgakbaaaaaaaaaaa
egacbaaaabaaaaaadcaaaaakhccabaaaafaaaaaaegiccaaaaaaaaaaaagaaaaaa
pgapbaaaaaaaaaaaegacbaaaaaaaaaaadoaaaaab"
}

SubProgram "gles " {
Keywords { "POINT_COOKIE" }
"!!GLES
#define SHADER_API_GLES 1
#define tex2D texture2D


#ifdef VERTEX
#define gl_ModelViewProjectionMatrix glstate_matrix_mvp
uniform mat4 glstate_matrix_mvp;
#define gl_ModelViewMatrixInverseTranspose glstate_matrix_invtrans_modelview0
uniform mat4 glstate_matrix_invtrans_modelview0;
#define gl_ModelViewMatrix glstate_matrix_modelview0
uniform mat4 glstate_matrix_modelview0;

varying highp vec3 xlv_TEXCOORD4;
varying mediump vec3 xlv_TEXCOORD3;
varying highp vec3 xlv_TEXCOORD2;
varying highp vec3 xlv_TEXCOORD1;
varying highp vec4 xlv_TEXCOORD0;
uniform highp vec4 _BumpMap_ST;
uniform highp vec4 _MainTex_ST;
uniform highp mat4 _LightMatrix0;
uniform highp vec4 unity_Scale;
uniform highp mat4 _World2Object;
uniform highp mat4 _Object2World;


uniform highp vec4 _WorldSpaceLightPos0;
attribute vec4 _glesTANGENT;
attribute vec4 _glesMultiTexCoord0;
attribute vec3 _glesNormal;
attribute vec4 _glesVertex;
void main ()
{
  vec4 tmpvar_1;
  tmpvar_1.xyz = normalize(_glesTANGENT.xyz);
  tmpvar_1.w = _glesTANGENT.w;
  vec3 tmpvar_2;
  tmpvar_2 = normalize(_glesNormal);
  highp vec4 tmpvar_3;
  mediump vec3 tmpvar_4;
  highp vec3 tmpvar_5;
  highp vec3 tmpvar_6;
  tmpvar_5 = tmpvar_1.xyz;
  tmpvar_6 = (((tmpvar_2.yzx * tmpvar_1.zxy) - (tmpvar_2.zxy * tmpvar_1.yzx)) * _glesTANGENT.w);
  highp mat3 tmpvar_7;
  tmpvar_7[0].x = tmpvar_5.x;
  tmpvar_7[0].y = tmpvar_6.x;
  tmpvar_7[0].z = tmpvar_2.x;
  tmpvar_7[1].x = tmpvar_5.y;
  tmpvar_7[1].y = tmpvar_6.y;
  tmpvar_7[1].z = tmpvar_2.y;
  tmpvar_7[2].x = tmpvar_5.z;
  tmpvar_7[2].y = tmpvar_6.z;
  tmpvar_7[2].z = tmpvar_2.z;
  vec4 v_8;
  v_8.x = gl_ModelViewMatrixInverseTranspose[0].x;
  v_8.y = gl_ModelViewMatrixInverseTranspose[1].x;
  v_8.z = gl_ModelViewMatrixInverseTranspose[2].x;
  v_8.w = gl_ModelViewMatrixInverseTranspose[3].x;
  vec4 v_9;
  v_9.x = gl_ModelViewMatrixInverseTranspose[0].y;
  v_9.y = gl_ModelViewMatrixInverseTranspose[1].y;
  v_9.z = gl_ModelViewMatrixInverseTranspose[2].y;
  v_9.w = gl_ModelViewMatrixInverseTranspose[3].y;
  tmpvar_3.xy = ((_glesMultiTexCoord0.xy * _MainTex_ST.xy) + _MainTex_ST.zw);
  tmpvar_3.zw = ((_glesMultiTexCoord0.xy * _BumpMap_ST.xy) + _BumpMap_ST.zw);
  highp vec3 tmpvar_10;
  highp vec3 tmpvar_11;
  tmpvar_10 = tmpvar_1.xyz;
  tmpvar_11 = (((tmpvar_2.yzx * tmpvar_1.zxy) - (tmpvar_2.zxy * tmpvar_1.yzx)) * _glesTANGENT.w);
  highp mat3 tmpvar_12;
  tmpvar_12[0].x = tmpvar_10.x;
  tmpvar_12[0].y = tmpvar_11.x;
  tmpvar_12[0].z = tmpvar_2.x;
  tmpvar_12[1].x = tmpvar_10.y;
  tmpvar_12[1].y = tmpvar_11.y;
  tmpvar_12[1].z = tmpvar_2.y;
  tmpvar_12[2].x = tmpvar_10.z;
  tmpvar_12[2].y = tmpvar_11.z;
  tmpvar_12[2].z = tmpvar_2.z;
  highp vec3 tmpvar_13;
  tmpvar_13 = (tmpvar_12 * (((_World2Object * _WorldSpaceLightPos0).xyz * unity_Scale.w) - _glesVertex.xyz));
  tmpvar_4 = tmpvar_13;
  gl_Position = (gl_ModelViewProjectionMatrix * _glesVertex);
  xlv_TEXCOORD0 = tmpvar_3;
  xlv_TEXCOORD1 = (tmpvar_7 * v_8.xyz);
  xlv_TEXCOORD2 = (tmpvar_7 * v_9.xyz);
  xlv_TEXCOORD3 = tmpvar_4;
  xlv_TEXCOORD4 = (_LightMatrix0 * (_Object2World * _glesVertex)).xyz;
}



#endif
#ifdef FRAGMENT

varying highp vec3 xlv_TEXCOORD4;
varying mediump vec3 xlv_TEXCOORD3;
varying highp vec4 xlv_TEXCOORD0;
uniform lowp float _Cutoff;
uniform sampler2D _BumpMap;
uniform sampler2D _MainTex;
uniform lowp vec4 _Color;
uniform sampler2D _LightTextureB0;
uniform samplerCube _LightTexture0;
uniform lowp vec4 _LightColor0;
void main ()
{
  lowp vec4 c_1;
  lowp vec3 lightDir_2;
  lowp vec4 tmpvar_3;
  tmpvar_3 = texture2D (_MainTex, xlv_TEXCOORD0.xy);
  lowp float tmpvar_4;
  tmpvar_4 = tmpvar_3.w;
  lowp float x_5;
  x_5 = (tmpvar_3.w - _Cutoff);
  if ((x_5 < 0.0)) {
    discard;
  };
  mediump vec3 tmpvar_6;
  tmpvar_6 = normalize(xlv_TEXCOORD3);
  lightDir_2 = tmpvar_6;
  highp float tmpvar_7;
  tmpvar_7 = dot (xlv_TEXCOORD4, xlv_TEXCOORD4);
  lowp vec4 c_8;
  c_8.xyz = (((texture2D (_MainTex, xlv_TEXCOORD0.xy).xyz * _Color.w) * _LightColor0.xyz) * ((max (0.0, dot (((texture2D (_BumpMap, xlv_TEXCOORD0.zw).xyz * 2.0) - 1.0), lightDir_2)) * (texture2D (_LightTextureB0, vec2(tmpvar_7)).w * textureCube (_LightTexture0, xlv_TEXCOORD4).w)) * 2.0));
  c_8.w = tmpvar_4;
  c_1.xyz = c_8.xyz;
  c_1.w = tmpvar_4;
  gl_FragData[0] = c_1;
}



#endif"
}

SubProgram "glesdesktop " {
Keywords { "POINT_COOKIE" }
"!!GLES
#define SHADER_API_GLES 1
#define tex2D texture2D


#ifdef VERTEX
#define gl_ModelViewProjectionMatrix glstate_matrix_mvp
uniform mat4 glstate_matrix_mvp;
#define gl_ModelViewMatrixInverseTranspose glstate_matrix_invtrans_modelview0
uniform mat4 glstate_matrix_invtrans_modelview0;
#define gl_ModelViewMatrix glstate_matrix_modelview0
uniform mat4 glstate_matrix_modelview0;

varying highp vec3 xlv_TEXCOORD4;
varying mediump vec3 xlv_TEXCOORD3;
varying highp vec3 xlv_TEXCOORD2;
varying highp vec3 xlv_TEXCOORD1;
varying highp vec4 xlv_TEXCOORD0;
uniform highp vec4 _BumpMap_ST;
uniform highp vec4 _MainTex_ST;
uniform highp mat4 _LightMatrix0;
uniform highp vec4 unity_Scale;
uniform highp mat4 _World2Object;
uniform highp mat4 _Object2World;


uniform highp vec4 _WorldSpaceLightPos0;
attribute vec4 _glesTANGENT;
attribute vec4 _glesMultiTexCoord0;
attribute vec3 _glesNormal;
attribute vec4 _glesVertex;
void main ()
{
  vec4 tmpvar_1;
  tmpvar_1.xyz = normalize(_glesTANGENT.xyz);
  tmpvar_1.w = _glesTANGENT.w;
  vec3 tmpvar_2;
  tmpvar_2 = normalize(_glesNormal);
  highp vec4 tmpvar_3;
  mediump vec3 tmpvar_4;
  highp vec3 tmpvar_5;
  highp vec3 tmpvar_6;
  tmpvar_5 = tmpvar_1.xyz;
  tmpvar_6 = (((tmpvar_2.yzx * tmpvar_1.zxy) - (tmpvar_2.zxy * tmpvar_1.yzx)) * _glesTANGENT.w);
  highp mat3 tmpvar_7;
  tmpvar_7[0].x = tmpvar_5.x;
  tmpvar_7[0].y = tmpvar_6.x;
  tmpvar_7[0].z = tmpvar_2.x;
  tmpvar_7[1].x = tmpvar_5.y;
  tmpvar_7[1].y = tmpvar_6.y;
  tmpvar_7[1].z = tmpvar_2.y;
  tmpvar_7[2].x = tmpvar_5.z;
  tmpvar_7[2].y = tmpvar_6.z;
  tmpvar_7[2].z = tmpvar_2.z;
  vec4 v_8;
  v_8.x = gl_ModelViewMatrixInverseTranspose[0].x;
  v_8.y = gl_ModelViewMatrixInverseTranspose[1].x;
  v_8.z = gl_ModelViewMatrixInverseTranspose[2].x;
  v_8.w = gl_ModelViewMatrixInverseTranspose[3].x;
  vec4 v_9;
  v_9.x = gl_ModelViewMatrixInverseTranspose[0].y;
  v_9.y = gl_ModelViewMatrixInverseTranspose[1].y;
  v_9.z = gl_ModelViewMatrixInverseTranspose[2].y;
  v_9.w = gl_ModelViewMatrixInverseTranspose[3].y;
  tmpvar_3.xy = ((_glesMultiTexCoord0.xy * _MainTex_ST.xy) + _MainTex_ST.zw);
  tmpvar_3.zw = ((_glesMultiTexCoord0.xy * _BumpMap_ST.xy) + _BumpMap_ST.zw);
  highp vec3 tmpvar_10;
  highp vec3 tmpvar_11;
  tmpvar_10 = tmpvar_1.xyz;
  tmpvar_11 = (((tmpvar_2.yzx * tmpvar_1.zxy) - (tmpvar_2.zxy * tmpvar_1.yzx)) * _glesTANGENT.w);
  highp mat3 tmpvar_12;
  tmpvar_12[0].x = tmpvar_10.x;
  tmpvar_12[0].y = tmpvar_11.x;
  tmpvar_12[0].z = tmpvar_2.x;
  tmpvar_12[1].x = tmpvar_10.y;
  tmpvar_12[1].y = tmpvar_11.y;
  tmpvar_12[1].z = tmpvar_2.y;
  tmpvar_12[2].x = tmpvar_10.z;
  tmpvar_12[2].y = tmpvar_11.z;
  tmpvar_12[2].z = tmpvar_2.z;
  highp vec3 tmpvar_13;
  tmpvar_13 = (tmpvar_12 * (((_World2Object * _WorldSpaceLightPos0).xyz * unity_Scale.w) - _glesVertex.xyz));
  tmpvar_4 = tmpvar_13;
  gl_Position = (gl_ModelViewProjectionMatrix * _glesVertex);
  xlv_TEXCOORD0 = tmpvar_3;
  xlv_TEXCOORD1 = (tmpvar_7 * v_8.xyz);
  xlv_TEXCOORD2 = (tmpvar_7 * v_9.xyz);
  xlv_TEXCOORD3 = tmpvar_4;
  xlv_TEXCOORD4 = (_LightMatrix0 * (_Object2World * _glesVertex)).xyz;
}



#endif
#ifdef FRAGMENT

varying highp vec3 xlv_TEXCOORD4;
varying mediump vec3 xlv_TEXCOORD3;
varying highp vec4 xlv_TEXCOORD0;
uniform lowp float _Cutoff;
uniform sampler2D _BumpMap;
uniform sampler2D _MainTex;
uniform lowp vec4 _Color;
uniform sampler2D _LightTextureB0;
uniform samplerCube _LightTexture0;
uniform lowp vec4 _LightColor0;
void main ()
{
  lowp vec4 c_1;
  lowp vec3 lightDir_2;
  lowp vec3 normal_3;
  normal_3.xy = ((texture2D (_BumpMap, xlv_TEXCOORD0.zw).wy * 2.0) - 1.0);
  normal_3.z = sqrt(((1.0 - (normal_3.x * normal_3.x)) - (normal_3.y * normal_3.y)));
  lowp vec4 tmpvar_4;
  tmpvar_4 = texture2D (_MainTex, xlv_TEXCOORD0.xy);
  lowp float tmpvar_5;
  tmpvar_5 = tmpvar_4.w;
  lowp float x_6;
  x_6 = (tmpvar_4.w - _Cutoff);
  if ((x_6 < 0.0)) {
    discard;
  };
  mediump vec3 tmpvar_7;
  tmpvar_7 = normalize(xlv_TEXCOORD3);
  lightDir_2 = tmpvar_7;
  highp float tmpvar_8;
  tmpvar_8 = dot (xlv_TEXCOORD4, xlv_TEXCOORD4);
  lowp vec4 c_9;
  c_9.xyz = (((texture2D (_MainTex, xlv_TEXCOORD0.xy).xyz * _Color.w) * _LightColor0.xyz) * ((max (0.0, dot (normal_3, lightDir_2)) * (texture2D (_LightTextureB0, vec2(tmpvar_8)).w * textureCube (_LightTexture0, xlv_TEXCOORD4).w)) * 2.0));
  c_9.w = tmpvar_5;
  c_1.xyz = c_9.xyz;
  c_1.w = tmpvar_5;
  gl_FragData[0] = c_1;
}



#endif"
}

SubProgram "flash " {
Keywords { "POINT_COOKIE" }
Bind "vertex" Vertex
Bind "tangent" TexCoord2
Bind "normal" Normal
Bind "texcoord" TexCoord0
Matrix 0 [glstate_matrix_mvp]
Matrix 4 [glstate_matrix_invtrans_modelview0]
Vector 20 [_WorldSpaceLightPos0]
Matrix 8 [_Object2World]
Matrix 12 [_World2Object]
Vector 21 [unity_Scale]
Matrix 16 [_LightMatrix0]
Vector 22 [_MainTex_ST]
Vector 23 [_BumpMap_ST]
"agal_vs
[bc]
aaaaaaaaabaaahacafaaaaoeaaaaaaaaaaaaaaaaaaaaaaaa mov r1.xyz, a5
aaaaaaaaaaaaapacaoaaaaoeabaaaaaaaaaaaaaaaaaaaaaa mov r0, c14
adaaaaaaacaaahacabaaaancaaaaaaaaabaaaaajacaaaaaa mul r2.xyz, a1.zxyw, r1.yzxx
aaaaaaaaabaaahacafaaaaoeaaaaaaaaaaaaaaaaaaaaaaaa mov r1.xyz, a5
adaaaaaaadaaahacabaaaamjaaaaaaaaabaaaafcacaaaaaa mul r3.xyz, a1.yzxw, r1.zxyy
acaaaaaaacaaahacadaaaakeacaaaaaaacaaaakeacaaaaaa sub r2.xyz, r3.xyzz, r2.xyzz
bdaaaaaaadaaaeacbeaaaaoeabaaaaaaaaaaaaoeacaaaaaa dp4 r3.z, c20, r0
aaaaaaaaaaaaapacanaaaaoeabaaaaaaaaaaaaaaaaaaaaaa mov r0, c13
aaaaaaaaabaaapacamaaaaoeabaaaaaaaaaaaaaaaaaaaaaa mov r1, c12
bdaaaaaaadaaabacbeaaaaoeabaaaaaaabaaaaoeacaaaaaa dp4 r3.x, c20, r1
adaaaaaaabaaahacacaaaakeacaaaaaaafaaaappaaaaaaaa mul r1.xyz, r2.xyzz, a5.w
bdaaaaaaadaaacacbeaaaaoeabaaaaaaaaaaaaoeacaaaaaa dp4 r3.y, c20, r0
adaaaaaaacaaahacadaaaakeacaaaaaabfaaaappabaaaaaa mul r2.xyz, r3.xyzz, c21.w
acaaaaaaaaaaahacacaaaakeacaaaaaaaaaaaaoeaaaaaaaa sub r0.xyz, r2.xyzz, a0
bcaaaaaaadaaacaeabaaaakeacaaaaaaaaaaaakeacaaaaaa dp3 v3.y, r1.xyzz, r0.xyzz
bcaaaaaaadaaaeaeabaaaaoeaaaaaaaaaaaaaakeacaaaaaa dp3 v3.z, a1, r0.xyzz
bcaaaaaaadaaabaeafaaaaoeaaaaaaaaaaaaaakeacaaaaaa dp3 v3.x, a5, r0.xyzz
bdaaaaaaaaaaaiacaaaaaaoeaaaaaaaaalaaaaoeabaaaaaa dp4 r0.w, a0, c11
bdaaaaaaaaaaaeacaaaaaaoeaaaaaaaaakaaaaoeabaaaaaa dp4 r0.z, a0, c10
bdaaaaaaaaaaabacaaaaaaoeaaaaaaaaaiaaaaoeabaaaaaa dp4 r0.x, a0, c8
bdaaaaaaaaaaacacaaaaaaoeaaaaaaaaajaaaaoeabaaaaaa dp4 r0.y, a0, c9
bcaaaaaaabaaacaeabaaaakeacaaaaaaaeaaaaoeabaaaaaa dp3 v1.y, r1.xyzz, c4
bcaaaaaaacaaacaeabaaaakeacaaaaaaafaaaaoeabaaaaaa dp3 v2.y, r1.xyzz, c5
bdaaaaaaaeaaaeaeaaaaaaoeacaaaaaabcaaaaoeabaaaaaa dp4 v4.z, r0, c18
bdaaaaaaaeaaacaeaaaaaaoeacaaaaaabbaaaaoeabaaaaaa dp4 v4.y, r0, c17
bdaaaaaaaeaaabaeaaaaaaoeacaaaaaabaaaaaoeabaaaaaa dp4 v4.x, r0, c16
adaaaaaaaaaaamacadaaaaeeaaaaaaaabhaaaaeeabaaaaaa mul r0.zw, a3.xyxy, c23.xyxy
abaaaaaaaaaaamaeaaaaaaopacaaaaaabhaaaaoeabaaaaaa add v0.zw, r0.wwzw, c23
adaaaaaaaaaaadacadaaaaoeaaaaaaaabgaaaaoeabaaaaaa mul r0.xy, a3, c22
abaaaaaaaaaaadaeaaaaaafeacaaaaaabgaaaaooabaaaaaa add v0.xy, r0.xyyy, c22.zwzw
bdaaaaaaaaaaaiadaaaaaaoeaaaaaaaaadaaaaoeabaaaaaa dp4 o0.w, a0, c3
bdaaaaaaaaaaaeadaaaaaaoeaaaaaaaaacaaaaoeabaaaaaa dp4 o0.z, a0, c2
bdaaaaaaaaaaacadaaaaaaoeaaaaaaaaabaaaaoeabaaaaaa dp4 o0.y, a0, c1
bdaaaaaaaaaaabadaaaaaaoeaaaaaaaaaaaaaaoeabaaaaaa dp4 o0.x, a0, c0
bcaaaaaaabaaaeaeabaaaaoeaaaaaaaaaeaaaaoeabaaaaaa dp3 v1.z, a1, c4
bcaaaaaaabaaabaeafaaaaoeaaaaaaaaaeaaaaoeabaaaaaa dp3 v1.x, a5, c4
bcaaaaaaacaaaeaeabaaaaoeaaaaaaaaafaaaaoeabaaaaaa dp3 v2.z, a1, c5
bcaaaaaaacaaabaeafaaaaoeaaaaaaaaafaaaaoeabaaaaaa dp3 v2.x, a5, c5
aaaaaaaaabaaaiaeaaaaaaoeabaaaaaaaaaaaaaaaaaaaaaa mov v1.w, c0
aaaaaaaaacaaaiaeaaaaaaoeabaaaaaaaaaaaaaaaaaaaaaa mov v2.w, c0
aaaaaaaaadaaaiaeaaaaaaoeabaaaaaaaaaaaaaaaaaaaaaa mov v3.w, c0
aaaaaaaaaeaaaiaeaaaaaaoeabaaaaaaaaaaaaaaaaaaaaaa mov v4.w, c0
"
}

SubProgram "d3d11_9x " {
Keywords { "POINT_COOKIE" }
Bind "vertex" Vertex
Bind "tangent" TexCoord2
Bind "normal" Normal
Bind "texcoord" TexCoord0
Bind "color" Color
ConstBuffer "$Globals" 176 // 160 used size, 8 vars
Matrix 48 [_LightMatrix0] 4
Vector 128 [_MainTex_ST] 4
Vector 144 [_BumpMap_ST] 4
ConstBuffer "UnityLighting" 400 // 16 used size, 16 vars
Vector 0 [_WorldSpaceLightPos0] 4
ConstBuffer "UnityPerDraw" 336 // 336 used size, 6 vars
Matrix 0 [glstate_matrix_mvp] 4
Matrix 128 [glstate_matrix_invtrans_modelview0] 4
Matrix 192 [_Object2World] 4
Matrix 256 [_World2Object] 4
Vector 320 [unity_Scale] 4
BindCB "$Globals" 0
BindCB "UnityLighting" 1
BindCB "UnityPerDraw" 2
// 38 instructions, 2 temp regs, 0 temp arrays:
// ALU 15 float, 0 int, 0 uint
// TEX 0 (0 load, 0 comp, 0 bias, 0 grad)
// FLOW 1 static, 0 dynamic
"vs_4_0_level_9_3
eefiecednepfcamjcjkhdjpnhehahkgamiaeegejabaaaaaaliakaaaaaeaaaaaa
daaaaaaajaadaaaadiajaaaaaaakaaaaebgpgodjfiadaaaafiadaaaaaaacpopp
oiacaaaahaaaaaaaagaaceaaaaaagmaaaaaagmaaaaaaceaaabaagmaaaaaaadaa
aeaaabaaaaaaaaaaaaaaaiaaacaaafaaaaaaaaaaabaaaaaaabaaahaaaaaaaaaa
acaaaaaaaeaaaiaaaaaaaaaaacaaaiaaadaaamaaaaaaaaaaacaaamaaajaaapaa
aaaaaaaaaaaaaaaaabacpoppbpaaaaacafaaaaiaaaaaapjabpaaaaacafaaabia
abaaapjabpaaaaacafaaaciaacaaapjabpaaaaacafaaadiaadaaapjaabaaaaac
aaaaabiaamaaaakaabaaaaacaaaaaciaanaaaakaabaaaaacaaaaaeiaaoaaaaka
aiaaaaadabaaaboaabaaoejaaaaaoeiaabaaaaacabaaahiaabaaoejaafaaaaad
acaaahiaabaamjiaacaancjaaeaaaaaeabaaahiaacaamjjaabaanciaacaaoeib
afaaaaadabaaahiaabaaoeiaabaappjaaiaaaaadabaaacoaabaaoeiaaaaaoeia
aiaaaaadabaaaeoaacaaoejaaaaaoeiaabaaaaacaaaaabiaamaaffkaabaaaaac
aaaaaciaanaaffkaabaaaaacaaaaaeiaaoaaffkaaiaaaaadacaaaboaabaaoeja
aaaaoeiaaiaaaaadacaaacoaabaaoeiaaaaaoeiaaiaaaaadacaaaeoaacaaoeja
aaaaoeiaaeaaaaaeaaaaadoaadaaoejaafaaoekaafaaookaaeaaaaaeaaaaamoa
adaaeejaagaaeekaagaaoekaabaaaaacaaaaapiaahaaoekaafaaaaadacaaahia
aaaaffiabeaaoekaaeaaaaaeacaaahiabdaaoekaaaaaaaiaacaaoeiaaeaaaaae
aaaaahiabfaaoekaaaaakkiaacaaoeiaaeaaaaaeaaaaahiabgaaoekaaaaappia
aaaaoeiaaeaaaaaeaaaaahiaaaaaoeiabhaappkaaaaaoejbaiaaaaadadaaaboa
abaaoejaaaaaoeiaaiaaaaadadaaacoaabaaoeiaaaaaoeiaaiaaaaadadaaaeoa
acaaoejaaaaaoeiaafaaaaadaaaaapiaaaaaffjabaaaoekaaeaaaaaeaaaaapia
apaaoekaaaaaaajaaaaaoeiaaeaaaaaeaaaaapiabbaaoekaaaaakkjaaaaaoeia
aeaaaaaeaaaaapiabcaaoekaaaaappjaaaaaoeiaafaaaaadabaaahiaaaaaffia
acaaoekaaeaaaaaeabaaahiaabaaoekaaaaaaaiaabaaoeiaaeaaaaaeaaaaahia
adaaoekaaaaakkiaabaaoeiaaeaaaaaeaeaaahoaaeaaoekaaaaappiaaaaaoeia
afaaaaadaaaaapiaaaaaffjaajaaoekaaeaaaaaeaaaaapiaaiaaoekaaaaaaaja
aaaaoeiaaeaaaaaeaaaaapiaakaaoekaaaaakkjaaaaaoeiaaeaaaaaeaaaaapia
alaaoekaaaaappjaaaaaoeiaaeaaaaaeaaaaadmaaaaappiaaaaaoekaaaaaoeia
abaaaaacaaaaammaaaaaoeiappppaaaafdeieefckaafaaaaeaaaabaagiabaaaa
fjaaaaaeegiocaaaaaaaaaaaakaaaaaafjaaaaaeegiocaaaabaaaaaaabaaaaaa
fjaaaaaeegiocaaaacaaaaaabfaaaaaafpaaaaadpcbabaaaaaaaaaaafpaaaaad
pcbabaaaabaaaaaafpaaaaadhcbabaaaacaaaaaafpaaaaaddcbabaaaadaaaaaa
ghaaaaaepccabaaaaaaaaaaaabaaaaaagfaaaaadpccabaaaabaaaaaagfaaaaad
hccabaaaacaaaaaagfaaaaadhccabaaaadaaaaaagfaaaaadhccabaaaaeaaaaaa
gfaaaaadhccabaaaafaaaaaagiaaaaacacaaaaaadiaaaaaipcaabaaaaaaaaaaa
fgbfbaaaaaaaaaaaegiocaaaacaaaaaaabaaaaaadcaaaaakpcaabaaaaaaaaaaa
egiocaaaacaaaaaaaaaaaaaaagbabaaaaaaaaaaaegaobaaaaaaaaaaadcaaaaak
pcaabaaaaaaaaaaaegiocaaaacaaaaaaacaaaaaakgbkbaaaaaaaaaaaegaobaaa
aaaaaaaadcaaaaakpccabaaaaaaaaaaaegiocaaaacaaaaaaadaaaaaapgbpbaaa
aaaaaaaaegaobaaaaaaaaaaadcaaaaaldccabaaaabaaaaaaegbabaaaadaaaaaa
egiacaaaaaaaaaaaaiaaaaaaogikcaaaaaaaaaaaaiaaaaaadcaaaaalmccabaaa
abaaaaaaagbebaaaadaaaaaaagiecaaaaaaaaaaaajaaaaaakgiocaaaaaaaaaaa
ajaaaaaadiaaaaahhcaabaaaaaaaaaaajgbebaaaabaaaaaacgbjbaaaacaaaaaa
dcaaaaakhcaabaaaaaaaaaaajgbebaaaacaaaaaacgbjbaaaabaaaaaaegacbaia
ebaaaaaaaaaaaaaadiaaaaahhcaabaaaaaaaaaaaegacbaaaaaaaaaaapgbpbaaa
abaaaaaadgaaaaagbcaabaaaabaaaaaaakiacaaaacaaaaaaaiaaaaaadgaaaaag
ccaabaaaabaaaaaaakiacaaaacaaaaaaajaaaaaadgaaaaagecaabaaaabaaaaaa
akiacaaaacaaaaaaakaaaaaabaaaaaahcccabaaaacaaaaaaegacbaaaaaaaaaaa
egacbaaaabaaaaaabaaaaaahbccabaaaacaaaaaaegbcbaaaabaaaaaaegacbaaa
abaaaaaabaaaaaaheccabaaaacaaaaaaegbcbaaaacaaaaaaegacbaaaabaaaaaa
dgaaaaagbcaabaaaabaaaaaabkiacaaaacaaaaaaaiaaaaaadgaaaaagccaabaaa
abaaaaaabkiacaaaacaaaaaaajaaaaaadgaaaaagecaabaaaabaaaaaabkiacaaa
acaaaaaaakaaaaaabaaaaaahcccabaaaadaaaaaaegacbaaaaaaaaaaaegacbaaa
abaaaaaabaaaaaahbccabaaaadaaaaaaegbcbaaaabaaaaaaegacbaaaabaaaaaa
baaaaaaheccabaaaadaaaaaaegbcbaaaacaaaaaaegacbaaaabaaaaaadiaaaaaj
hcaabaaaabaaaaaafgifcaaaabaaaaaaaaaaaaaaegiccaaaacaaaaaabbaaaaaa
dcaaaaalhcaabaaaabaaaaaaegiccaaaacaaaaaabaaaaaaaagiacaaaabaaaaaa
aaaaaaaaegacbaaaabaaaaaadcaaaaalhcaabaaaabaaaaaaegiccaaaacaaaaaa
bcaaaaaakgikcaaaabaaaaaaaaaaaaaaegacbaaaabaaaaaadcaaaaalhcaabaaa
abaaaaaaegiccaaaacaaaaaabdaaaaaapgipcaaaabaaaaaaaaaaaaaaegacbaaa
abaaaaaadcaaaaalhcaabaaaabaaaaaaegacbaaaabaaaaaapgipcaaaacaaaaaa
beaaaaaaegbcbaiaebaaaaaaaaaaaaaabaaaaaahcccabaaaaeaaaaaaegacbaaa
aaaaaaaaegacbaaaabaaaaaabaaaaaahbccabaaaaeaaaaaaegbcbaaaabaaaaaa
egacbaaaabaaaaaabaaaaaaheccabaaaaeaaaaaaegbcbaaaacaaaaaaegacbaaa
abaaaaaadiaaaaaipcaabaaaaaaaaaaafgbfbaaaaaaaaaaaegiocaaaacaaaaaa
anaaaaaadcaaaaakpcaabaaaaaaaaaaaegiocaaaacaaaaaaamaaaaaaagbabaaa
aaaaaaaaegaobaaaaaaaaaaadcaaaaakpcaabaaaaaaaaaaaegiocaaaacaaaaaa
aoaaaaaakgbkbaaaaaaaaaaaegaobaaaaaaaaaaadcaaaaakpcaabaaaaaaaaaaa
egiocaaaacaaaaaaapaaaaaapgbpbaaaaaaaaaaaegaobaaaaaaaaaaadiaaaaai
hcaabaaaabaaaaaafgafbaaaaaaaaaaaegiccaaaaaaaaaaaaeaaaaaadcaaaaak
hcaabaaaabaaaaaaegiccaaaaaaaaaaaadaaaaaaagaabaaaaaaaaaaaegacbaaa
abaaaaaadcaaaaakhcaabaaaaaaaaaaaegiccaaaaaaaaaaaafaaaaaakgakbaaa
aaaaaaaaegacbaaaabaaaaaadcaaaaakhccabaaaafaaaaaaegiccaaaaaaaaaaa
agaaaaaapgapbaaaaaaaaaaaegacbaaaaaaaaaaadoaaaaabejfdeheomaaaaaaa
agaaaaaaaiaaaaaajiaaaaaaaaaaaaaaaaaaaaaaadaaaaaaaaaaaaaaapapaaaa
kbaaaaaaaaaaaaaaaaaaaaaaadaaaaaaabaaaaaaapapaaaakjaaaaaaaaaaaaaa
aaaaaaaaadaaaaaaacaaaaaaahahaaaalaaaaaaaaaaaaaaaaaaaaaaaadaaaaaa
adaaaaaaapadaaaalaaaaaaaabaaaaaaaaaaaaaaadaaaaaaaeaaaaaaapaaaaaa
ljaaaaaaaaaaaaaaaaaaaaaaadaaaaaaafaaaaaaapaaaaaafaepfdejfeejepeo
aafeebeoehefeofeaaeoepfcenebemaafeeffiedepepfceeaaedepemepfcaakl
epfdeheolaaaaaaaagaaaaaaaiaaaaaajiaaaaaaaaaaaaaaabaaaaaaadaaaaaa
aaaaaaaaapaaaaaakeaaaaaaaaaaaaaaaaaaaaaaadaaaaaaabaaaaaaapaaaaaa
keaaaaaaabaaaaaaaaaaaaaaadaaaaaaacaaaaaaahaiaaaakeaaaaaaacaaaaaa
aaaaaaaaadaaaaaaadaaaaaaahaiaaaakeaaaaaaadaaaaaaaaaaaaaaadaaaaaa
aeaaaaaaahaiaaaakeaaaaaaaeaaaaaaaaaaaaaaadaaaaaaafaaaaaaahaiaaaa
fdfgfpfaepfdejfeejepeoaafeeffiedepepfceeaaklklkl"
}

SubProgram "opengl " {
Keywords { "DIRECTIONAL_COOKIE" }
Bind "vertex" Vertex
Bind "tangent" ATTR14
Bind "normal" Normal
Bind "texcoord" TexCoord0
Vector 21 [_WorldSpaceLightPos0]
Matrix 9 [_Object2World]
Matrix 13 [_World2Object]
Matrix 17 [_LightMatrix0]
Vector 22 [_MainTex_ST]
Vector 23 [_BumpMap_ST]
"!!ARBvp1.0
# 29 ALU
PARAM c[24] = { program.local[0],
		state.matrix.mvp,
		state.matrix.modelview[0].invtrans,
		program.local[9..23] };
TEMP R0;
TEMP R1;
TEMP R2;
MOV R0.xyz, vertex.attrib[14];
MUL R1.xyz, vertex.normal.zxyw, R0.yzxw;
MAD R0.xyz, vertex.normal.yzxw, R0.zxyw, -R1;
MOV R1, c[21];
MUL R0.xyz, R0, vertex.attrib[14].w;
DP4 R2.z, R1, c[15];
DP4 R2.x, R1, c[13];
DP4 R2.y, R1, c[14];
DP3 result.texcoord[3].y, R0, R2;
DP3 result.texcoord[1].y, R0, c[5];
DP3 result.texcoord[2].y, R0, c[6];
DP4 R0.w, vertex.position, c[12];
DP4 R0.z, vertex.position, c[11];
DP4 R0.x, vertex.position, c[9];
DP4 R0.y, vertex.position, c[10];
DP3 result.texcoord[3].z, vertex.normal, R2;
DP3 result.texcoord[3].x, vertex.attrib[14], R2;
DP4 result.texcoord[4].y, R0, c[18];
DP4 result.texcoord[4].x, R0, c[17];
MAD result.texcoord[0].zw, vertex.texcoord[0].xyxy, c[23].xyxy, c[23];
MAD result.texcoord[0].xy, vertex.texcoord[0], c[22], c[22].zwzw;
DP4 result.position.w, vertex.position, c[4];
DP4 result.position.z, vertex.position, c[3];
DP4 result.position.y, vertex.position, c[2];
DP4 result.position.x, vertex.position, c[1];
DP3 result.texcoord[1].z, vertex.normal, c[5];
DP3 result.texcoord[1].x, vertex.attrib[14], c[5];
DP3 result.texcoord[2].z, vertex.normal, c[6];
DP3 result.texcoord[2].x, vertex.attrib[14], c[6];
END
# 29 instructions, 3 R-regs
"
}

SubProgram "d3d9 " {
Keywords { "DIRECTIONAL_COOKIE" }
Bind "vertex" Vertex
Bind "tangent" TexCoord2
Bind "normal" Normal
Bind "texcoord" TexCoord0
Matrix 0 [glstate_matrix_mvp]
Matrix 4 [glstate_matrix_invtrans_modelview0]
Vector 20 [_WorldSpaceLightPos0]
Matrix 8 [_Object2World]
Matrix 12 [_World2Object]
Matrix 16 [_LightMatrix0]
Vector 21 [_MainTex_ST]
Vector 22 [_BumpMap_ST]
"vs_2_0
; 32 ALU
dcl_position0 v0
dcl_tangent0 v1
dcl_normal0 v2
dcl_texcoord0 v3
mov r0.xyz, v1
mul r1.xyz, v2.zxyw, r0.yzxw
mov r0.xyz, v1
mad r1.xyz, v2.yzxw, r0.zxyw, -r1
mul r2.xyz, r1, v1.w
mov r0, c14
dp4 r3.z, c20, r0
mov r0, c13
dp4 r3.y, c20, r0
mov r1, c12
dp4 r3.x, c20, r1
dp4 r0.w, v0, c11
dp4 r0.z, v0, c10
dp4 r0.x, v0, c8
dp4 r0.y, v0, c9
dp3 oT3.y, r2, r3
dp3 oT1.y, r2, c4
dp3 oT2.y, r2, c5
dp3 oT3.z, v2, r3
dp3 oT3.x, v1, r3
dp4 oT4.y, r0, c17
dp4 oT4.x, r0, c16
mad oT0.zw, v3.xyxy, c22.xyxy, c22
mad oT0.xy, v3, c21, c21.zwzw
dp4 oPos.w, v0, c3
dp4 oPos.z, v0, c2
dp4 oPos.y, v0, c1
dp4 oPos.x, v0, c0
dp3 oT1.z, v2, c4
dp3 oT1.x, v1, c4
dp3 oT2.z, v2, c5
dp3 oT2.x, v1, c5
"
}

SubProgram "d3d11 " {
Keywords { "DIRECTIONAL_COOKIE" }
Bind "vertex" Vertex
Bind "tangent" TexCoord2
Bind "normal" Normal
Bind "texcoord" TexCoord0
Bind "color" Color
ConstBuffer "$Globals" 176 // 160 used size, 8 vars
Matrix 48 [_LightMatrix0] 4
Vector 128 [_MainTex_ST] 4
Vector 144 [_BumpMap_ST] 4
ConstBuffer "UnityLighting" 400 // 16 used size, 16 vars
Vector 0 [_WorldSpaceLightPos0] 4
ConstBuffer "UnityPerDraw" 336 // 320 used size, 6 vars
Matrix 0 [glstate_matrix_mvp] 4
Matrix 128 [glstate_matrix_invtrans_modelview0] 4
Matrix 192 [_Object2World] 4
Matrix 256 [_World2Object] 4
BindCB "$Globals" 0
BindCB "UnityLighting" 1
BindCB "UnityPerDraw" 2
// 37 instructions, 2 temp regs, 0 temp arrays:
// ALU 15 float, 0 int, 0 uint
// TEX 0 (0 load, 0 comp, 0 bias, 0 grad)
// FLOW 1 static, 0 dynamic
"vs_4_0
eefiecedjdoglodmfodekaklhkohionmfomcpdpjabaaaaaaciahaaaaadaaaaaa
cmaaaaaapeaaaaaakmabaaaaejfdeheomaaaaaaaagaaaaaaaiaaaaaajiaaaaaa
aaaaaaaaaaaaaaaaadaaaaaaaaaaaaaaapapaaaakbaaaaaaaaaaaaaaaaaaaaaa
adaaaaaaabaaaaaaapapaaaakjaaaaaaaaaaaaaaaaaaaaaaadaaaaaaacaaaaaa
ahahaaaalaaaaaaaaaaaaaaaaaaaaaaaadaaaaaaadaaaaaaapadaaaalaaaaaaa
abaaaaaaaaaaaaaaadaaaaaaaeaaaaaaapaaaaaaljaaaaaaaaaaaaaaaaaaaaaa
adaaaaaaafaaaaaaapaaaaaafaepfdejfeejepeoaafeebeoehefeofeaaeoepfc
enebemaafeeffiedepepfceeaaedepemepfcaaklepfdeheolaaaaaaaagaaaaaa
aiaaaaaajiaaaaaaaaaaaaaaabaaaaaaadaaaaaaaaaaaaaaapaaaaaakeaaaaaa
aaaaaaaaaaaaaaaaadaaaaaaabaaaaaaapaaaaaakeaaaaaaabaaaaaaaaaaaaaa
adaaaaaaacaaaaaaahaiaaaakeaaaaaaacaaaaaaaaaaaaaaadaaaaaaadaaaaaa
ahaiaaaakeaaaaaaadaaaaaaaaaaaaaaadaaaaaaaeaaaaaaahaiaaaakeaaaaaa
aeaaaaaaaaaaaaaaadaaaaaaafaaaaaaadamaaaafdfgfpfaepfdejfeejepeoaa
feeffiedepepfceeaaklklklfdeieefcheafaaaaeaaaabaafnabaaaafjaaaaae
egiocaaaaaaaaaaaakaaaaaafjaaaaaeegiocaaaabaaaaaaabaaaaaafjaaaaae
egiocaaaacaaaaaabeaaaaaafpaaaaadpcbabaaaaaaaaaaafpaaaaadpcbabaaa
abaaaaaafpaaaaadhcbabaaaacaaaaaafpaaaaaddcbabaaaadaaaaaaghaaaaae
pccabaaaaaaaaaaaabaaaaaagfaaaaadpccabaaaabaaaaaagfaaaaadhccabaaa
acaaaaaagfaaaaadhccabaaaadaaaaaagfaaaaadhccabaaaaeaaaaaagfaaaaad
dccabaaaafaaaaaagiaaaaacacaaaaaadiaaaaaipcaabaaaaaaaaaaafgbfbaaa
aaaaaaaaegiocaaaacaaaaaaabaaaaaadcaaaaakpcaabaaaaaaaaaaaegiocaaa
acaaaaaaaaaaaaaaagbabaaaaaaaaaaaegaobaaaaaaaaaaadcaaaaakpcaabaaa
aaaaaaaaegiocaaaacaaaaaaacaaaaaakgbkbaaaaaaaaaaaegaobaaaaaaaaaaa
dcaaaaakpccabaaaaaaaaaaaegiocaaaacaaaaaaadaaaaaapgbpbaaaaaaaaaaa
egaobaaaaaaaaaaadcaaaaaldccabaaaabaaaaaaegbabaaaadaaaaaaegiacaaa
aaaaaaaaaiaaaaaaogikcaaaaaaaaaaaaiaaaaaadcaaaaalmccabaaaabaaaaaa
agbebaaaadaaaaaaagiecaaaaaaaaaaaajaaaaaakgiocaaaaaaaaaaaajaaaaaa
diaaaaahhcaabaaaaaaaaaaajgbebaaaabaaaaaacgbjbaaaacaaaaaadcaaaaak
hcaabaaaaaaaaaaajgbebaaaacaaaaaacgbjbaaaabaaaaaaegacbaiaebaaaaaa
aaaaaaaadiaaaaahhcaabaaaaaaaaaaaegacbaaaaaaaaaaapgbpbaaaabaaaaaa
dgaaaaagbcaabaaaabaaaaaaakiacaaaacaaaaaaaiaaaaaadgaaaaagccaabaaa
abaaaaaaakiacaaaacaaaaaaajaaaaaadgaaaaagecaabaaaabaaaaaaakiacaaa
acaaaaaaakaaaaaabaaaaaahcccabaaaacaaaaaaegacbaaaaaaaaaaaegacbaaa
abaaaaaabaaaaaahbccabaaaacaaaaaaegbcbaaaabaaaaaaegacbaaaabaaaaaa
baaaaaaheccabaaaacaaaaaaegbcbaaaacaaaaaaegacbaaaabaaaaaadgaaaaag
bcaabaaaabaaaaaabkiacaaaacaaaaaaaiaaaaaadgaaaaagccaabaaaabaaaaaa
bkiacaaaacaaaaaaajaaaaaadgaaaaagecaabaaaabaaaaaabkiacaaaacaaaaaa
akaaaaaabaaaaaahcccabaaaadaaaaaaegacbaaaaaaaaaaaegacbaaaabaaaaaa
baaaaaahbccabaaaadaaaaaaegbcbaaaabaaaaaaegacbaaaabaaaaaabaaaaaah
eccabaaaadaaaaaaegbcbaaaacaaaaaaegacbaaaabaaaaaadiaaaaajhcaabaaa
abaaaaaafgifcaaaabaaaaaaaaaaaaaaegiccaaaacaaaaaabbaaaaaadcaaaaal
hcaabaaaabaaaaaaegiccaaaacaaaaaabaaaaaaaagiacaaaabaaaaaaaaaaaaaa
egacbaaaabaaaaaadcaaaaalhcaabaaaabaaaaaaegiccaaaacaaaaaabcaaaaaa
kgikcaaaabaaaaaaaaaaaaaaegacbaaaabaaaaaadcaaaaalhcaabaaaabaaaaaa
egiccaaaacaaaaaabdaaaaaapgipcaaaabaaaaaaaaaaaaaaegacbaaaabaaaaaa
baaaaaahcccabaaaaeaaaaaaegacbaaaaaaaaaaaegacbaaaabaaaaaabaaaaaah
bccabaaaaeaaaaaaegbcbaaaabaaaaaaegacbaaaabaaaaaabaaaaaaheccabaaa
aeaaaaaaegbcbaaaacaaaaaaegacbaaaabaaaaaadiaaaaaipcaabaaaaaaaaaaa
fgbfbaaaaaaaaaaaegiocaaaacaaaaaaanaaaaaadcaaaaakpcaabaaaaaaaaaaa
egiocaaaacaaaaaaamaaaaaaagbabaaaaaaaaaaaegaobaaaaaaaaaaadcaaaaak
pcaabaaaaaaaaaaaegiocaaaacaaaaaaaoaaaaaakgbkbaaaaaaaaaaaegaobaaa
aaaaaaaadcaaaaakpcaabaaaaaaaaaaaegiocaaaacaaaaaaapaaaaaapgbpbaaa
aaaaaaaaegaobaaaaaaaaaaadiaaaaaidcaabaaaabaaaaaafgafbaaaaaaaaaaa
egiacaaaaaaaaaaaaeaaaaaadcaaaaakdcaabaaaaaaaaaaaegiacaaaaaaaaaaa
adaaaaaaagaabaaaaaaaaaaaegaabaaaabaaaaaadcaaaaakdcaabaaaaaaaaaaa
egiacaaaaaaaaaaaafaaaaaakgakbaaaaaaaaaaaegaabaaaaaaaaaaadcaaaaak
dccabaaaafaaaaaaegiacaaaaaaaaaaaagaaaaaapgapbaaaaaaaaaaaegaabaaa
aaaaaaaadoaaaaab"
}

SubProgram "gles " {
Keywords { "DIRECTIONAL_COOKIE" }
"!!GLES
#define SHADER_API_GLES 1
#define tex2D texture2D


#ifdef VERTEX
#define gl_ModelViewProjectionMatrix glstate_matrix_mvp
uniform mat4 glstate_matrix_mvp;
#define gl_ModelViewMatrixInverseTranspose glstate_matrix_invtrans_modelview0
uniform mat4 glstate_matrix_invtrans_modelview0;
#define gl_ModelViewMatrix glstate_matrix_modelview0
uniform mat4 glstate_matrix_modelview0;

varying highp vec2 xlv_TEXCOORD4;
varying mediump vec3 xlv_TEXCOORD3;
varying highp vec3 xlv_TEXCOORD2;
varying highp vec3 xlv_TEXCOORD1;
varying highp vec4 xlv_TEXCOORD0;
uniform highp vec4 _BumpMap_ST;
uniform highp vec4 _MainTex_ST;
uniform highp mat4 _LightMatrix0;
uniform highp mat4 _World2Object;
uniform highp mat4 _Object2World;


uniform lowp vec4 _WorldSpaceLightPos0;
attribute vec4 _glesTANGENT;
attribute vec4 _glesMultiTexCoord0;
attribute vec3 _glesNormal;
attribute vec4 _glesVertex;
void main ()
{
  vec4 tmpvar_1;
  tmpvar_1.xyz = normalize(_glesTANGENT.xyz);
  tmpvar_1.w = _glesTANGENT.w;
  vec3 tmpvar_2;
  tmpvar_2 = normalize(_glesNormal);
  highp vec4 tmpvar_3;
  mediump vec3 tmpvar_4;
  highp vec3 tmpvar_5;
  highp vec3 tmpvar_6;
  tmpvar_5 = tmpvar_1.xyz;
  tmpvar_6 = (((tmpvar_2.yzx * tmpvar_1.zxy) - (tmpvar_2.zxy * tmpvar_1.yzx)) * _glesTANGENT.w);
  highp mat3 tmpvar_7;
  tmpvar_7[0].x = tmpvar_5.x;
  tmpvar_7[0].y = tmpvar_6.x;
  tmpvar_7[0].z = tmpvar_2.x;
  tmpvar_7[1].x = tmpvar_5.y;
  tmpvar_7[1].y = tmpvar_6.y;
  tmpvar_7[1].z = tmpvar_2.y;
  tmpvar_7[2].x = tmpvar_5.z;
  tmpvar_7[2].y = tmpvar_6.z;
  tmpvar_7[2].z = tmpvar_2.z;
  vec4 v_8;
  v_8.x = gl_ModelViewMatrixInverseTranspose[0].x;
  v_8.y = gl_ModelViewMatrixInverseTranspose[1].x;
  v_8.z = gl_ModelViewMatrixInverseTranspose[2].x;
  v_8.w = gl_ModelViewMatrixInverseTranspose[3].x;
  vec4 v_9;
  v_9.x = gl_ModelViewMatrixInverseTranspose[0].y;
  v_9.y = gl_ModelViewMatrixInverseTranspose[1].y;
  v_9.z = gl_ModelViewMatrixInverseTranspose[2].y;
  v_9.w = gl_ModelViewMatrixInverseTranspose[3].y;
  tmpvar_3.xy = ((_glesMultiTexCoord0.xy * _MainTex_ST.xy) + _MainTex_ST.zw);
  tmpvar_3.zw = ((_glesMultiTexCoord0.xy * _BumpMap_ST.xy) + _BumpMap_ST.zw);
  highp vec3 tmpvar_10;
  highp vec3 tmpvar_11;
  tmpvar_10 = tmpvar_1.xyz;
  tmpvar_11 = (((tmpvar_2.yzx * tmpvar_1.zxy) - (tmpvar_2.zxy * tmpvar_1.yzx)) * _glesTANGENT.w);
  highp mat3 tmpvar_12;
  tmpvar_12[0].x = tmpvar_10.x;
  tmpvar_12[0].y = tmpvar_11.x;
  tmpvar_12[0].z = tmpvar_2.x;
  tmpvar_12[1].x = tmpvar_10.y;
  tmpvar_12[1].y = tmpvar_11.y;
  tmpvar_12[1].z = tmpvar_2.y;
  tmpvar_12[2].x = tmpvar_10.z;
  tmpvar_12[2].y = tmpvar_11.z;
  tmpvar_12[2].z = tmpvar_2.z;
  highp vec3 tmpvar_13;
  tmpvar_13 = (tmpvar_12 * (_World2Object * _WorldSpaceLightPos0).xyz);
  tmpvar_4 = tmpvar_13;
  gl_Position = (gl_ModelViewProjectionMatrix * _glesVertex);
  xlv_TEXCOORD0 = tmpvar_3;
  xlv_TEXCOORD1 = (tmpvar_7 * v_8.xyz);
  xlv_TEXCOORD2 = (tmpvar_7 * v_9.xyz);
  xlv_TEXCOORD3 = tmpvar_4;
  xlv_TEXCOORD4 = (_LightMatrix0 * (_Object2World * _glesVertex)).xy;
}



#endif
#ifdef FRAGMENT

varying highp vec2 xlv_TEXCOORD4;
varying mediump vec3 xlv_TEXCOORD3;
varying highp vec4 xlv_TEXCOORD0;
uniform lowp float _Cutoff;
uniform sampler2D _BumpMap;
uniform sampler2D _MainTex;
uniform lowp vec4 _Color;
uniform sampler2D _LightTexture0;
uniform lowp vec4 _LightColor0;
void main ()
{
  lowp vec4 c_1;
  lowp vec3 lightDir_2;
  lowp vec4 tmpvar_3;
  tmpvar_3 = texture2D (_MainTex, xlv_TEXCOORD0.xy);
  lowp float tmpvar_4;
  tmpvar_4 = tmpvar_3.w;
  lowp float x_5;
  x_5 = (tmpvar_3.w - _Cutoff);
  if ((x_5 < 0.0)) {
    discard;
  };
  lightDir_2 = xlv_TEXCOORD3;
  lowp vec4 c_6;
  c_6.xyz = (((texture2D (_MainTex, xlv_TEXCOORD0.xy).xyz * _Color.w) * _LightColor0.xyz) * ((max (0.0, dot (((texture2D (_BumpMap, xlv_TEXCOORD0.zw).xyz * 2.0) - 1.0), lightDir_2)) * texture2D (_LightTexture0, xlv_TEXCOORD4).w) * 2.0));
  c_6.w = tmpvar_4;
  c_1.xyz = c_6.xyz;
  c_1.w = tmpvar_4;
  gl_FragData[0] = c_1;
}



#endif"
}

SubProgram "glesdesktop " {
Keywords { "DIRECTIONAL_COOKIE" }
"!!GLES
#define SHADER_API_GLES 1
#define tex2D texture2D


#ifdef VERTEX
#define gl_ModelViewProjectionMatrix glstate_matrix_mvp
uniform mat4 glstate_matrix_mvp;
#define gl_ModelViewMatrixInverseTranspose glstate_matrix_invtrans_modelview0
uniform mat4 glstate_matrix_invtrans_modelview0;
#define gl_ModelViewMatrix glstate_matrix_modelview0
uniform mat4 glstate_matrix_modelview0;

varying highp vec2 xlv_TEXCOORD4;
varying mediump vec3 xlv_TEXCOORD3;
varying highp vec3 xlv_TEXCOORD2;
varying highp vec3 xlv_TEXCOORD1;
varying highp vec4 xlv_TEXCOORD0;
uniform highp vec4 _BumpMap_ST;
uniform highp vec4 _MainTex_ST;
uniform highp mat4 _LightMatrix0;
uniform highp mat4 _World2Object;
uniform highp mat4 _Object2World;


uniform lowp vec4 _WorldSpaceLightPos0;
attribute vec4 _glesTANGENT;
attribute vec4 _glesMultiTexCoord0;
attribute vec3 _glesNormal;
attribute vec4 _glesVertex;
void main ()
{
  vec4 tmpvar_1;
  tmpvar_1.xyz = normalize(_glesTANGENT.xyz);
  tmpvar_1.w = _glesTANGENT.w;
  vec3 tmpvar_2;
  tmpvar_2 = normalize(_glesNormal);
  highp vec4 tmpvar_3;
  mediump vec3 tmpvar_4;
  highp vec3 tmpvar_5;
  highp vec3 tmpvar_6;
  tmpvar_5 = tmpvar_1.xyz;
  tmpvar_6 = (((tmpvar_2.yzx * tmpvar_1.zxy) - (tmpvar_2.zxy * tmpvar_1.yzx)) * _glesTANGENT.w);
  highp mat3 tmpvar_7;
  tmpvar_7[0].x = tmpvar_5.x;
  tmpvar_7[0].y = tmpvar_6.x;
  tmpvar_7[0].z = tmpvar_2.x;
  tmpvar_7[1].x = tmpvar_5.y;
  tmpvar_7[1].y = tmpvar_6.y;
  tmpvar_7[1].z = tmpvar_2.y;
  tmpvar_7[2].x = tmpvar_5.z;
  tmpvar_7[2].y = tmpvar_6.z;
  tmpvar_7[2].z = tmpvar_2.z;
  vec4 v_8;
  v_8.x = gl_ModelViewMatrixInverseTranspose[0].x;
  v_8.y = gl_ModelViewMatrixInverseTranspose[1].x;
  v_8.z = gl_ModelViewMatrixInverseTranspose[2].x;
  v_8.w = gl_ModelViewMatrixInverseTranspose[3].x;
  vec4 v_9;
  v_9.x = gl_ModelViewMatrixInverseTranspose[0].y;
  v_9.y = gl_ModelViewMatrixInverseTranspose[1].y;
  v_9.z = gl_ModelViewMatrixInverseTranspose[2].y;
  v_9.w = gl_ModelViewMatrixInverseTranspose[3].y;
  tmpvar_3.xy = ((_glesMultiTexCoord0.xy * _MainTex_ST.xy) + _MainTex_ST.zw);
  tmpvar_3.zw = ((_glesMultiTexCoord0.xy * _BumpMap_ST.xy) + _BumpMap_ST.zw);
  highp vec3 tmpvar_10;
  highp vec3 tmpvar_11;
  tmpvar_10 = tmpvar_1.xyz;
  tmpvar_11 = (((tmpvar_2.yzx * tmpvar_1.zxy) - (tmpvar_2.zxy * tmpvar_1.yzx)) * _glesTANGENT.w);
  highp mat3 tmpvar_12;
  tmpvar_12[0].x = tmpvar_10.x;
  tmpvar_12[0].y = tmpvar_11.x;
  tmpvar_12[0].z = tmpvar_2.x;
  tmpvar_12[1].x = tmpvar_10.y;
  tmpvar_12[1].y = tmpvar_11.y;
  tmpvar_12[1].z = tmpvar_2.y;
  tmpvar_12[2].x = tmpvar_10.z;
  tmpvar_12[2].y = tmpvar_11.z;
  tmpvar_12[2].z = tmpvar_2.z;
  highp vec3 tmpvar_13;
  tmpvar_13 = (tmpvar_12 * (_World2Object * _WorldSpaceLightPos0).xyz);
  tmpvar_4 = tmpvar_13;
  gl_Position = (gl_ModelViewProjectionMatrix * _glesVertex);
  xlv_TEXCOORD0 = tmpvar_3;
  xlv_TEXCOORD1 = (tmpvar_7 * v_8.xyz);
  xlv_TEXCOORD2 = (tmpvar_7 * v_9.xyz);
  xlv_TEXCOORD3 = tmpvar_4;
  xlv_TEXCOORD4 = (_LightMatrix0 * (_Object2World * _glesVertex)).xy;
}



#endif
#ifdef FRAGMENT

varying highp vec2 xlv_TEXCOORD4;
varying mediump vec3 xlv_TEXCOORD3;
varying highp vec4 xlv_TEXCOORD0;
uniform lowp float _Cutoff;
uniform sampler2D _BumpMap;
uniform sampler2D _MainTex;
uniform lowp vec4 _Color;
uniform sampler2D _LightTexture0;
uniform lowp vec4 _LightColor0;
void main ()
{
  lowp vec4 c_1;
  lowp vec3 lightDir_2;
  lowp vec3 normal_3;
  normal_3.xy = ((texture2D (_BumpMap, xlv_TEXCOORD0.zw).wy * 2.0) - 1.0);
  normal_3.z = sqrt(((1.0 - (normal_3.x * normal_3.x)) - (normal_3.y * normal_3.y)));
  lowp vec4 tmpvar_4;
  tmpvar_4 = texture2D (_MainTex, xlv_TEXCOORD0.xy);
  lowp float tmpvar_5;
  tmpvar_5 = tmpvar_4.w;
  lowp float x_6;
  x_6 = (tmpvar_4.w - _Cutoff);
  if ((x_6 < 0.0)) {
    discard;
  };
  lightDir_2 = xlv_TEXCOORD3;
  lowp vec4 c_7;
  c_7.xyz = (((texture2D (_MainTex, xlv_TEXCOORD0.xy).xyz * _Color.w) * _LightColor0.xyz) * ((max (0.0, dot (normal_3, lightDir_2)) * texture2D (_LightTexture0, xlv_TEXCOORD4).w) * 2.0));
  c_7.w = tmpvar_5;
  c_1.xyz = c_7.xyz;
  c_1.w = tmpvar_5;
  gl_FragData[0] = c_1;
}



#endif"
}

SubProgram "flash " {
Keywords { "DIRECTIONAL_COOKIE" }
Bind "vertex" Vertex
Bind "tangent" TexCoord2
Bind "normal" Normal
Bind "texcoord" TexCoord0
Matrix 0 [glstate_matrix_mvp]
Matrix 4 [glstate_matrix_invtrans_modelview0]
Vector 20 [_WorldSpaceLightPos0]
Matrix 8 [_Object2World]
Matrix 12 [_World2Object]
Matrix 16 [_LightMatrix0]
Vector 21 [_MainTex_ST]
Vector 22 [_BumpMap_ST]
"agal_vs
[bc]
aaaaaaaaaaaaahacafaaaaoeaaaaaaaaaaaaaaaaaaaaaaaa mov r0.xyz, a5
adaaaaaaabaaahacabaaaancaaaaaaaaaaaaaaajacaaaaaa mul r1.xyz, a1.zxyw, r0.yzxx
aaaaaaaaaaaaahacafaaaaoeaaaaaaaaaaaaaaaaaaaaaaaa mov r0.xyz, a5
adaaaaaaacaaahacabaaaamjaaaaaaaaaaaaaafcacaaaaaa mul r2.xyz, a1.yzxw, r0.zxyy
acaaaaaaabaaahacacaaaakeacaaaaaaabaaaakeacaaaaaa sub r1.xyz, r2.xyzz, r1.xyzz
adaaaaaaacaaahacabaaaakeacaaaaaaafaaaappaaaaaaaa mul r2.xyz, r1.xyzz, a5.w
aaaaaaaaaaaaapacaoaaaaoeabaaaaaaaaaaaaaaaaaaaaaa mov r0, c14
bdaaaaaaadaaaeacbeaaaaoeabaaaaaaaaaaaaoeacaaaaaa dp4 r3.z, c20, r0
aaaaaaaaaaaaapacanaaaaoeabaaaaaaaaaaaaaaaaaaaaaa mov r0, c13
bdaaaaaaadaaacacbeaaaaoeabaaaaaaaaaaaaoeacaaaaaa dp4 r3.y, c20, r0
aaaaaaaaabaaapacamaaaaoeabaaaaaaaaaaaaaaaaaaaaaa mov r1, c12
bdaaaaaaadaaabacbeaaaaoeabaaaaaaabaaaaoeacaaaaaa dp4 r3.x, c20, r1
bdaaaaaaaaaaaiacaaaaaaoeaaaaaaaaalaaaaoeabaaaaaa dp4 r0.w, a0, c11
bdaaaaaaaaaaaeacaaaaaaoeaaaaaaaaakaaaaoeabaaaaaa dp4 r0.z, a0, c10
bdaaaaaaaaaaabacaaaaaaoeaaaaaaaaaiaaaaoeabaaaaaa dp4 r0.x, a0, c8
bdaaaaaaaaaaacacaaaaaaoeaaaaaaaaajaaaaoeabaaaaaa dp4 r0.y, a0, c9
bcaaaaaaadaaacaeacaaaakeacaaaaaaadaaaakeacaaaaaa dp3 v3.y, r2.xyzz, r3.xyzz
bcaaaaaaabaaacaeacaaaakeacaaaaaaaeaaaaoeabaaaaaa dp3 v1.y, r2.xyzz, c4
bcaaaaaaacaaacaeacaaaakeacaaaaaaafaaaaoeabaaaaaa dp3 v2.y, r2.xyzz, c5
bcaaaaaaadaaaeaeabaaaaoeaaaaaaaaadaaaakeacaaaaaa dp3 v3.z, a1, r3.xyzz
bcaaaaaaadaaabaeafaaaaoeaaaaaaaaadaaaakeacaaaaaa dp3 v3.x, a5, r3.xyzz
bdaaaaaaaeaaacaeaaaaaaoeacaaaaaabbaaaaoeabaaaaaa dp4 v4.y, r0, c17
bdaaaaaaaeaaabaeaaaaaaoeacaaaaaabaaaaaoeabaaaaaa dp4 v4.x, r0, c16
adaaaaaaaaaaamacadaaaaeeaaaaaaaabgaaaaeeabaaaaaa mul r0.zw, a3.xyxy, c22.xyxy
abaaaaaaaaaaamaeaaaaaaopacaaaaaabgaaaaoeabaaaaaa add v0.zw, r0.wwzw, c22
adaaaaaaaaaaadacadaaaaoeaaaaaaaabfaaaaoeabaaaaaa mul r0.xy, a3, c21
abaaaaaaaaaaadaeaaaaaafeacaaaaaabfaaaaooabaaaaaa add v0.xy, r0.xyyy, c21.zwzw
bdaaaaaaaaaaaiadaaaaaaoeaaaaaaaaadaaaaoeabaaaaaa dp4 o0.w, a0, c3
bdaaaaaaaaaaaeadaaaaaaoeaaaaaaaaacaaaaoeabaaaaaa dp4 o0.z, a0, c2
bdaaaaaaaaaaacadaaaaaaoeaaaaaaaaabaaaaoeabaaaaaa dp4 o0.y, a0, c1
bdaaaaaaaaaaabadaaaaaaoeaaaaaaaaaaaaaaoeabaaaaaa dp4 o0.x, a0, c0
bcaaaaaaabaaaeaeabaaaaoeaaaaaaaaaeaaaaoeabaaaaaa dp3 v1.z, a1, c4
bcaaaaaaabaaabaeafaaaaoeaaaaaaaaaeaaaaoeabaaaaaa dp3 v1.x, a5, c4
bcaaaaaaacaaaeaeabaaaaoeaaaaaaaaafaaaaoeabaaaaaa dp3 v2.z, a1, c5
bcaaaaaaacaaabaeafaaaaoeaaaaaaaaafaaaaoeabaaaaaa dp3 v2.x, a5, c5
aaaaaaaaabaaaiaeaaaaaaoeabaaaaaaaaaaaaaaaaaaaaaa mov v1.w, c0
aaaaaaaaacaaaiaeaaaaaaoeabaaaaaaaaaaaaaaaaaaaaaa mov v2.w, c0
aaaaaaaaadaaaiaeaaaaaaoeabaaaaaaaaaaaaaaaaaaaaaa mov v3.w, c0
aaaaaaaaaeaaamaeaaaaaaoeabaaaaaaaaaaaaaaaaaaaaaa mov v4.zw, c0
"
}

SubProgram "d3d11_9x " {
Keywords { "DIRECTIONAL_COOKIE" }
Bind "vertex" Vertex
Bind "tangent" TexCoord2
Bind "normal" Normal
Bind "texcoord" TexCoord0
Bind "color" Color
ConstBuffer "$Globals" 176 // 160 used size, 8 vars
Matrix 48 [_LightMatrix0] 4
Vector 128 [_MainTex_ST] 4
Vector 144 [_BumpMap_ST] 4
ConstBuffer "UnityLighting" 400 // 16 used size, 16 vars
Vector 0 [_WorldSpaceLightPos0] 4
ConstBuffer "UnityPerDraw" 336 // 320 used size, 6 vars
Matrix 0 [glstate_matrix_mvp] 4
Matrix 128 [glstate_matrix_invtrans_modelview0] 4
Matrix 192 [_Object2World] 4
Matrix 256 [_World2Object] 4
BindCB "$Globals" 0
BindCB "UnityLighting" 1
BindCB "UnityPerDraw" 2
// 37 instructions, 2 temp regs, 0 temp arrays:
// ALU 15 float, 0 int, 0 uint
// TEX 0 (0 load, 0 comp, 0 bias, 0 grad)
// FLOW 1 static, 0 dynamic
"vs_4_0_level_9_3
eefiecediokmiankgknijhioohelklnnjiicckdeabaaaaaahiakaaaaaeaaaaaa
daaaaaaahmadaaaapiaiaaaamaajaaaaebgpgodjeeadaaaaeeadaaaaaaacpopp
neacaaaahaaaaaaaagaaceaaaaaagmaaaaaagmaaaaaaceaaabaagmaaaaaaadaa
aeaaabaaaaaaaaaaaaaaaiaaacaaafaaaaaaaaaaabaaaaaaabaaahaaaaaaaaaa
acaaaaaaaeaaaiaaaaaaaaaaacaaaiaaadaaamaaaaaaaaaaacaaamaaaiaaapaa
aaaaaaaaaaaaaaaaabacpoppbpaaaaacafaaaaiaaaaaapjabpaaaaacafaaabia
abaaapjabpaaaaacafaaaciaacaaapjabpaaaaacafaaadiaadaaapjaabaaaaac
aaaaabiaamaaaakaabaaaaacaaaaaciaanaaaakaabaaaaacaaaaaeiaaoaaaaka
aiaaaaadabaaaboaabaaoejaaaaaoeiaabaaaaacabaaahiaabaaoejaafaaaaad
acaaahiaabaamjiaacaancjaaeaaaaaeabaaahiaacaamjjaabaanciaacaaoeib
afaaaaadabaaahiaabaaoeiaabaappjaaiaaaaadabaaacoaabaaoeiaaaaaoeia
aiaaaaadabaaaeoaacaaoejaaaaaoeiaabaaaaacaaaaabiaamaaffkaabaaaaac
aaaaaciaanaaffkaabaaaaacaaaaaeiaaoaaffkaaiaaaaadacaaaboaabaaoeja
aaaaoeiaaiaaaaadacaaacoaabaaoeiaaaaaoeiaaiaaaaadacaaaeoaacaaoeja
aaaaoeiaaeaaaaaeaaaaadoaadaaoejaafaaoekaafaaookaaeaaaaaeaaaaamoa
adaaeejaagaaeekaagaaoekaabaaaaacaaaaapiaahaaoekaafaaaaadacaaahia
aaaaffiabeaaoekaaeaaaaaeacaaahiabdaaoekaaaaaaaiaacaaoeiaaeaaaaae
aaaaahiabfaaoekaaaaakkiaacaaoeiaaeaaaaaeaaaaahiabgaaoekaaaaappia
aaaaoeiaaiaaaaadadaaaboaabaaoejaaaaaoeiaaiaaaaadadaaacoaabaaoeia
aaaaoeiaaiaaaaadadaaaeoaacaaoejaaaaaoeiaafaaaaadaaaaapiaaaaaffja
baaaoekaaeaaaaaeaaaaapiaapaaoekaaaaaaajaaaaaoeiaaeaaaaaeaaaaapia
bbaaoekaaaaakkjaaaaaoeiaaeaaaaaeaaaaapiabcaaoekaaaaappjaaaaaoeia
afaaaaadabaaadiaaaaaffiaacaaoekaaeaaaaaeaaaaadiaabaaoekaaaaaaaia
abaaoeiaaeaaaaaeaaaaadiaadaaoekaaaaakkiaaaaaoeiaaeaaaaaeaeaaadoa
aeaaoekaaaaappiaaaaaoeiaafaaaaadaaaaapiaaaaaffjaajaaoekaaeaaaaae
aaaaapiaaiaaoekaaaaaaajaaaaaoeiaaeaaaaaeaaaaapiaakaaoekaaaaakkja
aaaaoeiaaeaaaaaeaaaaapiaalaaoekaaaaappjaaaaaoeiaaeaaaaaeaaaaadma
aaaappiaaaaaoekaaaaaoeiaabaaaaacaaaaammaaaaaoeiappppaaaafdeieefc
heafaaaaeaaaabaafnabaaaafjaaaaaeegiocaaaaaaaaaaaakaaaaaafjaaaaae
egiocaaaabaaaaaaabaaaaaafjaaaaaeegiocaaaacaaaaaabeaaaaaafpaaaaad
pcbabaaaaaaaaaaafpaaaaadpcbabaaaabaaaaaafpaaaaadhcbabaaaacaaaaaa
fpaaaaaddcbabaaaadaaaaaaghaaaaaepccabaaaaaaaaaaaabaaaaaagfaaaaad
pccabaaaabaaaaaagfaaaaadhccabaaaacaaaaaagfaaaaadhccabaaaadaaaaaa
gfaaaaadhccabaaaaeaaaaaagfaaaaaddccabaaaafaaaaaagiaaaaacacaaaaaa
diaaaaaipcaabaaaaaaaaaaafgbfbaaaaaaaaaaaegiocaaaacaaaaaaabaaaaaa
dcaaaaakpcaabaaaaaaaaaaaegiocaaaacaaaaaaaaaaaaaaagbabaaaaaaaaaaa
egaobaaaaaaaaaaadcaaaaakpcaabaaaaaaaaaaaegiocaaaacaaaaaaacaaaaaa
kgbkbaaaaaaaaaaaegaobaaaaaaaaaaadcaaaaakpccabaaaaaaaaaaaegiocaaa
acaaaaaaadaaaaaapgbpbaaaaaaaaaaaegaobaaaaaaaaaaadcaaaaaldccabaaa
abaaaaaaegbabaaaadaaaaaaegiacaaaaaaaaaaaaiaaaaaaogikcaaaaaaaaaaa
aiaaaaaadcaaaaalmccabaaaabaaaaaaagbebaaaadaaaaaaagiecaaaaaaaaaaa
ajaaaaaakgiocaaaaaaaaaaaajaaaaaadiaaaaahhcaabaaaaaaaaaaajgbebaaa
abaaaaaacgbjbaaaacaaaaaadcaaaaakhcaabaaaaaaaaaaajgbebaaaacaaaaaa
cgbjbaaaabaaaaaaegacbaiaebaaaaaaaaaaaaaadiaaaaahhcaabaaaaaaaaaaa
egacbaaaaaaaaaaapgbpbaaaabaaaaaadgaaaaagbcaabaaaabaaaaaaakiacaaa
acaaaaaaaiaaaaaadgaaaaagccaabaaaabaaaaaaakiacaaaacaaaaaaajaaaaaa
dgaaaaagecaabaaaabaaaaaaakiacaaaacaaaaaaakaaaaaabaaaaaahcccabaaa
acaaaaaaegacbaaaaaaaaaaaegacbaaaabaaaaaabaaaaaahbccabaaaacaaaaaa
egbcbaaaabaaaaaaegacbaaaabaaaaaabaaaaaaheccabaaaacaaaaaaegbcbaaa
acaaaaaaegacbaaaabaaaaaadgaaaaagbcaabaaaabaaaaaabkiacaaaacaaaaaa
aiaaaaaadgaaaaagccaabaaaabaaaaaabkiacaaaacaaaaaaajaaaaaadgaaaaag
ecaabaaaabaaaaaabkiacaaaacaaaaaaakaaaaaabaaaaaahcccabaaaadaaaaaa
egacbaaaaaaaaaaaegacbaaaabaaaaaabaaaaaahbccabaaaadaaaaaaegbcbaaa
abaaaaaaegacbaaaabaaaaaabaaaaaaheccabaaaadaaaaaaegbcbaaaacaaaaaa
egacbaaaabaaaaaadiaaaaajhcaabaaaabaaaaaafgifcaaaabaaaaaaaaaaaaaa
egiccaaaacaaaaaabbaaaaaadcaaaaalhcaabaaaabaaaaaaegiccaaaacaaaaaa
baaaaaaaagiacaaaabaaaaaaaaaaaaaaegacbaaaabaaaaaadcaaaaalhcaabaaa
abaaaaaaegiccaaaacaaaaaabcaaaaaakgikcaaaabaaaaaaaaaaaaaaegacbaaa
abaaaaaadcaaaaalhcaabaaaabaaaaaaegiccaaaacaaaaaabdaaaaaapgipcaaa
abaaaaaaaaaaaaaaegacbaaaabaaaaaabaaaaaahcccabaaaaeaaaaaaegacbaaa
aaaaaaaaegacbaaaabaaaaaabaaaaaahbccabaaaaeaaaaaaegbcbaaaabaaaaaa
egacbaaaabaaaaaabaaaaaaheccabaaaaeaaaaaaegbcbaaaacaaaaaaegacbaaa
abaaaaaadiaaaaaipcaabaaaaaaaaaaafgbfbaaaaaaaaaaaegiocaaaacaaaaaa
anaaaaaadcaaaaakpcaabaaaaaaaaaaaegiocaaaacaaaaaaamaaaaaaagbabaaa
aaaaaaaaegaobaaaaaaaaaaadcaaaaakpcaabaaaaaaaaaaaegiocaaaacaaaaaa
aoaaaaaakgbkbaaaaaaaaaaaegaobaaaaaaaaaaadcaaaaakpcaabaaaaaaaaaaa
egiocaaaacaaaaaaapaaaaaapgbpbaaaaaaaaaaaegaobaaaaaaaaaaadiaaaaai
dcaabaaaabaaaaaafgafbaaaaaaaaaaaegiacaaaaaaaaaaaaeaaaaaadcaaaaak
dcaabaaaaaaaaaaaegiacaaaaaaaaaaaadaaaaaaagaabaaaaaaaaaaaegaabaaa
abaaaaaadcaaaaakdcaabaaaaaaaaaaaegiacaaaaaaaaaaaafaaaaaakgakbaaa
aaaaaaaaegaabaaaaaaaaaaadcaaaaakdccabaaaafaaaaaaegiacaaaaaaaaaaa
agaaaaaapgapbaaaaaaaaaaaegaabaaaaaaaaaaadoaaaaabejfdeheomaaaaaaa
agaaaaaaaiaaaaaajiaaaaaaaaaaaaaaaaaaaaaaadaaaaaaaaaaaaaaapapaaaa
kbaaaaaaaaaaaaaaaaaaaaaaadaaaaaaabaaaaaaapapaaaakjaaaaaaaaaaaaaa
aaaaaaaaadaaaaaaacaaaaaaahahaaaalaaaaaaaaaaaaaaaaaaaaaaaadaaaaaa
adaaaaaaapadaaaalaaaaaaaabaaaaaaaaaaaaaaadaaaaaaaeaaaaaaapaaaaaa
ljaaaaaaaaaaaaaaaaaaaaaaadaaaaaaafaaaaaaapaaaaaafaepfdejfeejepeo
aafeebeoehefeofeaaeoepfcenebemaafeeffiedepepfceeaaedepemepfcaakl
epfdeheolaaaaaaaagaaaaaaaiaaaaaajiaaaaaaaaaaaaaaabaaaaaaadaaaaaa
aaaaaaaaapaaaaaakeaaaaaaaaaaaaaaaaaaaaaaadaaaaaaabaaaaaaapaaaaaa
keaaaaaaabaaaaaaaaaaaaaaadaaaaaaacaaaaaaahaiaaaakeaaaaaaacaaaaaa
aaaaaaaaadaaaaaaadaaaaaaahaiaaaakeaaaaaaadaaaaaaaaaaaaaaadaaaaaa
aeaaaaaaahaiaaaakeaaaaaaaeaaaaaaaaaaaaaaadaaaaaaafaaaaaaadamaaaa
fdfgfpfaepfdejfeejepeoaafeeffiedepepfceeaaklklkl"
}

}
Program "fp" {
// Fragment combos: 5
//   opengl - ALU: 17 to 29, TEX: 2 to 4
//   d3d9 - ALU: 20 to 32, TEX: 3 to 5
//   d3d11 - ALU: 9 to 19, TEX: 2 to 4, FLOW: 1 to 1
//   d3d11_9x - ALU: 9 to 19, TEX: 2 to 4, FLOW: 1 to 1
SubProgram "opengl " {
Keywords { "POINT" }
Vector 0 [_LightColor0]
Vector 1 [_Color]
Float 2 [_Cutoff]
SetTexture 0 [_BumpMap] 2D
SetTexture 1 [_MainTex] 2D
SetTexture 3 [_LightTexture0] 2D
"!!ARBfp1.0
OPTION ARB_precision_hint_fastest;
# 23 ALU, 3 TEX
PARAM c[4] = { program.local[0..2],
		{ 2, 1, 0 } };
TEMP R0;
TEMP R1;
TEMP R2;
TEX R0, fragment.texcoord[0], texture[1], 2D;
TEX R2.yw, fragment.texcoord[0].zwzw, texture[0], 2D;
SLT R1.y, R0.w, c[2].x;
DP3 R1.x, fragment.texcoord[4], fragment.texcoord[4];
DP3 R2.x, fragment.texcoord[3], fragment.texcoord[3];
MUL R0.xyz, R0, c[1].w;
RSQ R2.x, R2.x;
MUL R0.xyz, R0, c[0];
MOV result.color.w, R0;
TEX R1.w, R1.x, texture[3], 2D;
KIL -R1.y;
MAD R1.xy, R2.wyzw, c[3].x, -c[3].y;
MUL R1.z, R1.y, R1.y;
MAD R1.z, -R1.x, R1.x, -R1;
ADD R1.z, R1, c[3].y;
RSQ R1.z, R1.z;
MUL R2.xyz, R2.x, fragment.texcoord[3];
RCP R1.z, R1.z;
DP3 R1.x, R1, R2;
MAX R1.x, R1, c[3].z;
MUL R1.x, R1, R1.w;
MUL R0.xyz, R1.x, R0;
MUL result.color.xyz, R0, c[3].x;
END
# 23 instructions, 3 R-regs
"
}

SubProgram "d3d9 " {
Keywords { "POINT" }
Vector 0 [_LightColor0]
Vector 1 [_Color]
Float 2 [_Cutoff]
SetTexture 0 [_BumpMap] 2D
SetTexture 1 [_MainTex] 2D
SetTexture 3 [_LightTexture0] 2D
"ps_2_0
; 26 ALU, 4 TEX
dcl_2d s0
dcl_2d s1
dcl_2d s3
def c3, 0.00000000, 1.00000000, 2.00000000, -1.00000000
dcl t0
dcl t3.xyz
dcl t4.xyz
texld r2, t0, s1
add_pp r0.x, r2.w, -c2
cmp r1.x, r0, c3, c3.y
mov_pp r1, -r1.x
dp3 r0.x, t4, t4
mov r3.xy, r0.x
mov r0.y, t0.w
mov r0.x, t0.z
texld r0, r0, s0
texkill r1.xyzw
texld r3, r3, s3
mov r0.x, r0.w
mad_pp r4.xy, r0, c3.z, c3.w
mul_pp r0.x, r4.y, r4.y
mad_pp r0.x, -r4, r4, -r0
dp3_pp r1.x, t3, t3
add_pp r0.x, r0, c3.y
rsq_pp r0.x, r0.x
rsq_pp r1.x, r1.x
mul_pp r1.xyz, r1.x, t3
rcp_pp r4.z, r0.x
dp3_pp r0.x, r4, r1
mul r1.xyz, r2, c1.w
max_pp r0.x, r0, c3
mul_pp r1.xyz, r1, c0
mul_pp r0.x, r0, r3
mul_pp r0.xyz, r0.x, r1
mul_pp r0.xyz, r0, c3.z
mov_pp r0.w, r2
mov_pp oC0, r0
"
}

SubProgram "d3d11 " {
Keywords { "POINT" }
ConstBuffer "$Globals" 176 // 164 used size, 8 vars
Vector 16 [_LightColor0] 4
Vector 112 [_Color] 4
Float 160 [_Cutoff]
BindCB "$Globals" 0
SetTexture 0 [_BumpMap] 2D 2
SetTexture 1 [_MainTex] 2D 1
SetTexture 2 [_LightTexture0] 2D 0
// 22 instructions, 3 temp regs, 0 temp arrays:
// ALU 13 float, 0 int, 0 uint
// TEX 3 (0 load, 0 comp, 0 bias, 0 grad)
// FLOW 1 static, 0 dynamic
"ps_4_0
eefiecedooohejdkfecppfobkdlejhehnogaiencabaaaaaaemaeaaaaadaaaaaa
cmaaaaaaoeaaaaaabiabaaaaejfdeheolaaaaaaaagaaaaaaaiaaaaaajiaaaaaa
aaaaaaaaabaaaaaaadaaaaaaaaaaaaaaapaaaaaakeaaaaaaaaaaaaaaaaaaaaaa
adaaaaaaabaaaaaaapapaaaakeaaaaaaabaaaaaaaaaaaaaaadaaaaaaacaaaaaa
ahaaaaaakeaaaaaaacaaaaaaaaaaaaaaadaaaaaaadaaaaaaahaaaaaakeaaaaaa
adaaaaaaaaaaaaaaadaaaaaaaeaaaaaaahahaaaakeaaaaaaaeaaaaaaaaaaaaaa
adaaaaaaafaaaaaaahahaaaafdfgfpfaepfdejfeejepeoaafeeffiedepepfcee
aaklklklepfdeheocmaaaaaaabaaaaaaaiaaaaaacaaaaaaaaaaaaaaaaaaaaaaa
adaaaaaaaaaaaaaaapaaaaaafdfgfpfegbhcghgfheaaklklfdeieefccmadaaaa
eaaaaaaamlaaaaaafjaaaaaeegiocaaaaaaaaaaaalaaaaaafkaaaaadaagabaaa
aaaaaaaafkaaaaadaagabaaaabaaaaaafkaaaaadaagabaaaacaaaaaafibiaaae
aahabaaaaaaaaaaaffffaaaafibiaaaeaahabaaaabaaaaaaffffaaaafibiaaae
aahabaaaacaaaaaaffffaaaagcbaaaadpcbabaaaabaaaaaagcbaaaadhcbabaaa
aeaaaaaagcbaaaadhcbabaaaafaaaaaagfaaaaadpccabaaaaaaaaaaagiaaaaac
adaaaaaaefaaaaajpcaabaaaaaaaaaaaegbabaaaabaaaaaaeghobaaaabaaaaaa
aagabaaaabaaaaaaaaaaaaajbcaabaaaabaaaaaadkaabaaaaaaaaaaaakiacaia
ebaaaaaaaaaaaaaaakaaaaaadbaaaaahbcaabaaaabaaaaaaakaabaaaabaaaaaa
abeaaaaaaaaaaaaaanaaaeadakaabaaaabaaaaaabaaaaaahbcaabaaaabaaaaaa
egbcbaaaaeaaaaaaegbcbaaaaeaaaaaaeeaaaaafbcaabaaaabaaaaaaakaabaaa
abaaaaaadiaaaaahhcaabaaaabaaaaaaagaabaaaabaaaaaaegbcbaaaaeaaaaaa
efaaaaajpcaabaaaacaaaaaaogbkbaaaabaaaaaaeghobaaaaaaaaaaaaagabaaa
acaaaaaadcaaaaapdcaabaaaacaaaaaahgapbaaaacaaaaaaaceaaaaaaaaaaaea
aaaaaaeaaaaaaaaaaaaaaaaaaceaaaaaaaaaialpaaaaialpaaaaaaaaaaaaaaaa
dcaaaaakicaabaaaabaaaaaaakaabaiaebaaaaaaacaaaaaaakaabaaaacaaaaaa
abeaaaaaaaaaiadpdcaaaaakicaabaaaabaaaaaabkaabaiaebaaaaaaacaaaaaa
bkaabaaaacaaaaaadkaabaaaabaaaaaaelaaaaafecaabaaaacaaaaaadkaabaaa
abaaaaaabaaaaaahbcaabaaaabaaaaaaegacbaaaacaaaaaaegacbaaaabaaaaaa
deaaaaahbcaabaaaabaaaaaaakaabaaaabaaaaaaabeaaaaaaaaaaaaabaaaaaah
ccaabaaaabaaaaaaegbcbaaaafaaaaaaegbcbaaaafaaaaaaefaaaaajpcaabaaa
acaaaaaafgafbaaaabaaaaaaeghobaaaacaaaaaaaagabaaaaaaaaaaaapaaaaah
bcaabaaaabaaaaaaagaabaaaabaaaaaaagaabaaaacaaaaaadiaaaaaihcaabaaa
aaaaaaaaegacbaaaaaaaaaaapgipcaaaaaaaaaaaahaaaaaadgaaaaaficcabaaa
aaaaaaaadkaabaaaaaaaaaaadiaaaaaihcaabaaaaaaaaaaaegacbaaaaaaaaaaa
egiccaaaaaaaaaaaabaaaaaadiaaaaahhccabaaaaaaaaaaaagaabaaaabaaaaaa
egacbaaaaaaaaaaadoaaaaab"
}

SubProgram "gles " {
Keywords { "POINT" }
"!!GLES"
}

SubProgram "glesdesktop " {
Keywords { "POINT" }
"!!GLES"
}

SubProgram "flash " {
Keywords { "POINT" }
Vector 0 [_LightColor0]
Vector 1 [_Color]
Float 2 [_Cutoff]
SetTexture 0 [_BumpMap] 2D
SetTexture 1 [_MainTex] 2D
SetTexture 3 [_LightTexture0] 2D
"agal_ps
c3 0.0 1.0 2.0 -1.0
[bc]
ciaaaaaaacaaapacaaaaaaoeaeaaaaaaabaaaaaaafaababb tex r2, v0, s1 <2d wrap linear point>
acaaaaaaaaaaabacacaaaappacaaaaaaacaaaaoeabaaaaaa sub r0.x, r2.w, c2
ckaaaaaaabaaabacaaaaaaaaacaaaaaaadaaaaaaabaaaaaa slt r1.x, r0.x, c3.x
bfaaaaaaabaaapacabaaaaaaacaaaaaaaaaaaaaaaaaaaaaa neg r1, r1.x
bcaaaaaaaaaaabacaeaaaaoeaeaaaaaaaeaaaaoeaeaaaaaa dp3 r0.x, v4, v4
aaaaaaaaaaaaadacaaaaaaaaacaaaaaaaaaaaaaaaaaaaaaa mov r0.xy, r0.x
aaaaaaaaadaaacacaaaaaappaeaaaaaaaaaaaaaaaaaaaaaa mov r3.y, v0.w
aaaaaaaaadaaabacaaaaaakkaeaaaaaaaaaaaaaaaaaaaaaa mov r3.x, v0.z
chaaaaaaaaaaaaaaabaaaaaaacaaaaaaaaaaaaaaaaaaaaaa kil a0.none, r1.x
ciaaaaaaabaaapacadaaaafeacaaaaaaaaaaaaaaafaababb tex r1, r3.xyyy, s0 <2d wrap linear point>
ciaaaaaaaaaaapacaaaaaafeacaaaaaaadaaaaaaafaababb tex r0, r0.xyyy, s3 <2d wrap linear point>
bcaaaaaaabaaabacadaaaaoeaeaaaaaaadaaaaoeaeaaaaaa dp3 r1.x, v3, v3
aaaaaaaaaaaaacacabaaaaffacaaaaaaaaaaaaaaaaaaaaaa mov r0.y, r1.y
aaaaaaaaaaaaabacabaaaappacaaaaaaaaaaaaaaaaaaaaaa mov r0.x, r1.w
adaaaaaaadaaadacaaaaaafeacaaaaaaadaaaakkabaaaaaa mul r3.xy, r0.xyyy, c3.z
abaaaaaaadaaadacadaaaafeacaaaaaaadaaaappabaaaaaa add r3.xy, r3.xyyy, c3.w
adaaaaaaaaaaabacadaaaaffacaaaaaaadaaaaffacaaaaaa mul r0.x, r3.y, r3.y
bfaaaaaaadaaaiacadaaaaaaacaaaaaaaaaaaaaaaaaaaaaa neg r3.w, r3.x
adaaaaaaadaaaiacadaaaappacaaaaaaadaaaaaaacaaaaaa mul r3.w, r3.w, r3.x
acaaaaaaaaaaabacadaaaappacaaaaaaaaaaaaaaacaaaaaa sub r0.x, r3.w, r0.x
abaaaaaaaaaaabacaaaaaaaaacaaaaaaadaaaaffabaaaaaa add r0.x, r0.x, c3.y
akaaaaaaaaaaabacaaaaaaaaacaaaaaaaaaaaaaaaaaaaaaa rsq r0.x, r0.x
akaaaaaaabaaabacabaaaaaaacaaaaaaaaaaaaaaaaaaaaaa rsq r1.x, r1.x
adaaaaaaabaaahacabaaaaaaacaaaaaaadaaaaoeaeaaaaaa mul r1.xyz, r1.x, v3
afaaaaaaadaaaeacaaaaaaaaacaaaaaaaaaaaaaaaaaaaaaa rcp r3.z, r0.x
bcaaaaaaaaaaabacadaaaakeacaaaaaaabaaaakeacaaaaaa dp3 r0.x, r3.xyzz, r1.xyzz
ahaaaaaaaaaaabacaaaaaaaaacaaaaaaadaaaaoeabaaaaaa max r0.x, r0.x, c3
adaaaaaaaaaaabacaaaaaaaaacaaaaaaaaaaaappacaaaaaa mul r0.x, r0.x, r0.w
adaaaaaaabaaahacacaaaakeacaaaaaaabaaaappabaaaaaa mul r1.xyz, r2.xyzz, c1.w
adaaaaaaabaaahacabaaaakeacaaaaaaaaaaaaoeabaaaaaa mul r1.xyz, r1.xyzz, c0
adaaaaaaaaaaahacaaaaaaaaacaaaaaaabaaaakeacaaaaaa mul r0.xyz, r0.x, r1.xyzz
adaaaaaaaaaaahacaaaaaakeacaaaaaaadaaaakkabaaaaaa mul r0.xyz, r0.xyzz, c3.z
aaaaaaaaaaaaaiacacaaaappacaaaaaaaaaaaaaaaaaaaaaa mov r0.w, r2.w
aaaaaaaaaaaaapadaaaaaaoeacaaaaaaaaaaaaaaaaaaaaaa mov o0, r0
"
}

SubProgram "d3d11_9x " {
Keywords { "POINT" }
ConstBuffer "$Globals" 176 // 164 used size, 8 vars
Vector 16 [_LightColor0] 4
Vector 112 [_Color] 4
Float 160 [_Cutoff]
BindCB "$Globals" 0
SetTexture 0 [_BumpMap] 2D 2
SetTexture 1 [_MainTex] 2D 1
SetTexture 2 [_LightTexture0] 2D 0
// 22 instructions, 3 temp regs, 0 temp arrays:
// ALU 13 float, 0 int, 0 uint
// TEX 3 (0 load, 0 comp, 0 bias, 0 grad)
// FLOW 1 static, 0 dynamic
"ps_4_0_level_9_3
eefiecedeionfihlhjhjiihpmdnpmpnplkkbkbidabaaaaaafiagaaaaaeaaaaaa
daaaaaaadiacaaaagmafaaaaceagaaaaebgpgodjaaacaaaaaaacaaaaaaacpppp
kmabaaaafeaaaaaaadaadaaaaaaafeaaaaaafeaaadaaceaaaaaafeaaacaaaaaa
abababaaaaacacaaaaaaabaaabaaaaaaaaaaaaaaaaaaahaaabaaabaaaaaaaaaa
aaaaakaaabaaacaaaaaaaaaaabacppppfbaaaaafadaaapkaaaaaaaeaaaaaialp
aaaaiadpaaaaaaaabpaaaaacaaaaaaiaaaaaaplabpaaaaacaaaaaaiaadaachla
bpaaaaacaaaaaaiaaeaaahlabpaaaaacaaaaaajaaaaiapkabpaaaaacaaaaaaja
abaiapkabpaaaaacaaaaaajaacaiapkaecaaaaadaaaaapiaaaaaoelaabaioeka
acaaaaadabaacpiaaaaappiaacaaaakbabaaaaacacaaadiaaaaaoolaebaaaaab
abaaapiaecaaaaadabaacpiaacaaoeiaacaioekaaeaaaaaeabaacdiaabaaohia
adaaaakaadaaffkaaeaaaaaeabaaciiaabaaaaiaabaaaaibadaakkkaaeaaaaae
abaaciiaabaaffiaabaaffibabaappiaahaaaaacabaaciiaabaappiaagaaaaac
abaaceiaabaappiaceaaaaacacaachiaadaaoelaaiaaaaadabaacbiaabaaoeia
acaaoeiaaiaaaaadacaaadiaaeaaoelaaeaaoelaecaaaaadacaacpiaacaaoeia
aaaioekaafaaaaadabaacciaabaaaaiaacaaaaiafiaaaaaeabaacbiaabaaaaia
abaaffiaadaappkaacaaaaadabaacbiaabaaaaiaabaaaaiaafaaaaadabaacoia
aaaajaiaabaappkaafaaaaadabaacoiaabaaoeiaaaaajakaafaaaaadaaaachia
abaaaaiaabaapjiaabaaaaacaaaicpiaaaaaoeiappppaaaafdeieefccmadaaaa
eaaaaaaamlaaaaaafjaaaaaeegiocaaaaaaaaaaaalaaaaaafkaaaaadaagabaaa
aaaaaaaafkaaaaadaagabaaaabaaaaaafkaaaaadaagabaaaacaaaaaafibiaaae
aahabaaaaaaaaaaaffffaaaafibiaaaeaahabaaaabaaaaaaffffaaaafibiaaae
aahabaaaacaaaaaaffffaaaagcbaaaadpcbabaaaabaaaaaagcbaaaadhcbabaaa
aeaaaaaagcbaaaadhcbabaaaafaaaaaagfaaaaadpccabaaaaaaaaaaagiaaaaac
adaaaaaaefaaaaajpcaabaaaaaaaaaaaegbabaaaabaaaaaaeghobaaaabaaaaaa
aagabaaaabaaaaaaaaaaaaajbcaabaaaabaaaaaadkaabaaaaaaaaaaaakiacaia
ebaaaaaaaaaaaaaaakaaaaaadbaaaaahbcaabaaaabaaaaaaakaabaaaabaaaaaa
abeaaaaaaaaaaaaaanaaaeadakaabaaaabaaaaaabaaaaaahbcaabaaaabaaaaaa
egbcbaaaaeaaaaaaegbcbaaaaeaaaaaaeeaaaaafbcaabaaaabaaaaaaakaabaaa
abaaaaaadiaaaaahhcaabaaaabaaaaaaagaabaaaabaaaaaaegbcbaaaaeaaaaaa
efaaaaajpcaabaaaacaaaaaaogbkbaaaabaaaaaaeghobaaaaaaaaaaaaagabaaa
acaaaaaadcaaaaapdcaabaaaacaaaaaahgapbaaaacaaaaaaaceaaaaaaaaaaaea
aaaaaaeaaaaaaaaaaaaaaaaaaceaaaaaaaaaialpaaaaialpaaaaaaaaaaaaaaaa
dcaaaaakicaabaaaabaaaaaaakaabaiaebaaaaaaacaaaaaaakaabaaaacaaaaaa
abeaaaaaaaaaiadpdcaaaaakicaabaaaabaaaaaabkaabaiaebaaaaaaacaaaaaa
bkaabaaaacaaaaaadkaabaaaabaaaaaaelaaaaafecaabaaaacaaaaaadkaabaaa
abaaaaaabaaaaaahbcaabaaaabaaaaaaegacbaaaacaaaaaaegacbaaaabaaaaaa
deaaaaahbcaabaaaabaaaaaaakaabaaaabaaaaaaabeaaaaaaaaaaaaabaaaaaah
ccaabaaaabaaaaaaegbcbaaaafaaaaaaegbcbaaaafaaaaaaefaaaaajpcaabaaa
acaaaaaafgafbaaaabaaaaaaeghobaaaacaaaaaaaagabaaaaaaaaaaaapaaaaah
bcaabaaaabaaaaaaagaabaaaabaaaaaaagaabaaaacaaaaaadiaaaaaihcaabaaa
aaaaaaaaegacbaaaaaaaaaaapgipcaaaaaaaaaaaahaaaaaadgaaaaaficcabaaa
aaaaaaaadkaabaaaaaaaaaaadiaaaaaihcaabaaaaaaaaaaaegacbaaaaaaaaaaa
egiccaaaaaaaaaaaabaaaaaadiaaaaahhccabaaaaaaaaaaaagaabaaaabaaaaaa
egacbaaaaaaaaaaadoaaaaabejfdeheolaaaaaaaagaaaaaaaiaaaaaajiaaaaaa
aaaaaaaaabaaaaaaadaaaaaaaaaaaaaaapaaaaaakeaaaaaaaaaaaaaaaaaaaaaa
adaaaaaaabaaaaaaapapaaaakeaaaaaaabaaaaaaaaaaaaaaadaaaaaaacaaaaaa
ahaaaaaakeaaaaaaacaaaaaaaaaaaaaaadaaaaaaadaaaaaaahaaaaaakeaaaaaa
adaaaaaaaaaaaaaaadaaaaaaaeaaaaaaahahaaaakeaaaaaaaeaaaaaaaaaaaaaa
adaaaaaaafaaaaaaahahaaaafdfgfpfaepfdejfeejepeoaafeeffiedepepfcee
aaklklklepfdeheocmaaaaaaabaaaaaaaiaaaaaacaaaaaaaaaaaaaaaaaaaaaaa
adaaaaaaaaaaaaaaapaaaaaafdfgfpfegbhcghgfheaaklkl"
}

SubProgram "opengl " {
Keywords { "DIRECTIONAL" }
Vector 0 [_LightColor0]
Vector 1 [_Color]
Float 2 [_Cutoff]
SetTexture 0 [_BumpMap] 2D
SetTexture 1 [_MainTex] 2D
"!!ARBfp1.0
OPTION ARB_precision_hint_fastest;
# 17 ALU, 2 TEX
PARAM c[4] = { program.local[0..2],
		{ 2, 1, 0 } };
TEMP R0;
TEMP R1;
TEX R0, fragment.texcoord[0], texture[1], 2D;
TEX R1.yw, fragment.texcoord[0].zwzw, texture[0], 2D;
SLT R1.x, R0.w, c[2];
MUL R0.xyz, R0, c[1].w;
MUL R0.xyz, R0, c[0];
MOV result.color.w, R0;
KIL -R1.x;
MAD R1.xy, R1.wyzw, c[3].x, -c[3].y;
MUL R1.z, R1.y, R1.y;
MAD R1.z, -R1.x, R1.x, -R1;
ADD R1.z, R1, c[3].y;
RSQ R1.z, R1.z;
RCP R1.z, R1.z;
DP3 R1.x, R1, fragment.texcoord[3];
MAX R1.x, R1, c[3].z;
MUL R0.xyz, R1.x, R0;
MUL result.color.xyz, R0, c[3].x;
END
# 17 instructions, 2 R-regs
"
}

SubProgram "d3d9 " {
Keywords { "DIRECTIONAL" }
Vector 0 [_LightColor0]
Vector 1 [_Color]
Float 2 [_Cutoff]
SetTexture 0 [_BumpMap] 2D
SetTexture 1 [_MainTex] 2D
"ps_2_0
; 20 ALU, 3 TEX
dcl_2d s0
dcl_2d s1
def c3, 0.00000000, 1.00000000, 2.00000000, -1.00000000
dcl t0
dcl t3.xyz
texld r0, t0, s1
add_pp r1.x, r0.w, -c2
cmp r1.x, r1, c3, c3.y
mov_pp r1, -r1.x
mov r2.y, t0.w
mov r2.x, t0.z
texld r2, r2, s0
texkill r1.xyzw
mov r1.y, r2
mov r1.x, r2.w
mad_pp r1.xy, r1, c3.z, c3.w
mul_pp r2.x, r1.y, r1.y
mad_pp r2.x, -r1, r1, -r2
add_pp r2.x, r2, c3.y
rsq_pp r2.x, r2.x
rcp_pp r1.z, r2.x
mul r2.xyz, r0, c1.w
dp3_pp r0.x, r1, t3
mul_pp r1.xyz, r2, c0
max_pp r0.x, r0, c3
mul_pp r0.xyz, r0.x, r1
mul_pp r0.xyz, r0, c3.z
mov_pp oC0, r0
"
}

SubProgram "d3d11 " {
Keywords { "DIRECTIONAL" }
ConstBuffer "$Globals" 112 // 100 used size, 7 vars
Vector 16 [_LightColor0] 4
Vector 48 [_Color] 4
Float 96 [_Cutoff]
BindCB "$Globals" 0
SetTexture 0 [_BumpMap] 2D 1
SetTexture 1 [_MainTex] 2D 0
// 17 instructions, 2 temp regs, 0 temp arrays:
// ALU 9 float, 0 int, 0 uint
// TEX 2 (0 load, 0 comp, 0 bias, 0 grad)
// FLOW 1 static, 0 dynamic
"ps_4_0
eefieceddlkhehnnmpgcbaggcaejgdklogalnolfabaaaaaaiaadaaaaadaaaaaa
cmaaaaaammaaaaaaaaabaaaaejfdeheojiaaaaaaafaaaaaaaiaaaaaaiaaaaaaa
aaaaaaaaabaaaaaaadaaaaaaaaaaaaaaapaaaaaaimaaaaaaaaaaaaaaaaaaaaaa
adaaaaaaabaaaaaaapapaaaaimaaaaaaabaaaaaaaaaaaaaaadaaaaaaacaaaaaa
ahaaaaaaimaaaaaaacaaaaaaaaaaaaaaadaaaaaaadaaaaaaahaaaaaaimaaaaaa
adaaaaaaaaaaaaaaadaaaaaaaeaaaaaaahahaaaafdfgfpfaepfdejfeejepeoaa
feeffiedepepfceeaaklklklepfdeheocmaaaaaaabaaaaaaaiaaaaaacaaaaaaa
aaaaaaaaaaaaaaaaadaaaaaaaaaaaaaaapaaaaaafdfgfpfegbhcghgfheaaklkl
fdeieefchiacaaaaeaaaaaaajoaaaaaafjaaaaaeegiocaaaaaaaaaaaahaaaaaa
fkaaaaadaagabaaaaaaaaaaafkaaaaadaagabaaaabaaaaaafibiaaaeaahabaaa
aaaaaaaaffffaaaafibiaaaeaahabaaaabaaaaaaffffaaaagcbaaaadpcbabaaa
abaaaaaagcbaaaadhcbabaaaaeaaaaaagfaaaaadpccabaaaaaaaaaaagiaaaaac
acaaaaaaefaaaaajpcaabaaaaaaaaaaaegbabaaaabaaaaaaeghobaaaabaaaaaa
aagabaaaaaaaaaaaaaaaaaajbcaabaaaabaaaaaadkaabaaaaaaaaaaaakiacaia
ebaaaaaaaaaaaaaaagaaaaaadbaaaaahbcaabaaaabaaaaaaakaabaaaabaaaaaa
abeaaaaaaaaaaaaaanaaaeadakaabaaaabaaaaaaefaaaaajpcaabaaaabaaaaaa
ogbkbaaaabaaaaaaeghobaaaaaaaaaaaaagabaaaabaaaaaadcaaaaapdcaabaaa
abaaaaaahgapbaaaabaaaaaaaceaaaaaaaaaaaeaaaaaaaeaaaaaaaaaaaaaaaaa
aceaaaaaaaaaialpaaaaialpaaaaaaaaaaaaaaaadcaaaaakicaabaaaabaaaaaa
akaabaiaebaaaaaaabaaaaaaakaabaaaabaaaaaaabeaaaaaaaaaiadpdcaaaaak
icaabaaaabaaaaaabkaabaiaebaaaaaaabaaaaaabkaabaaaabaaaaaadkaabaaa
abaaaaaaelaaaaafecaabaaaabaaaaaadkaabaaaabaaaaaabaaaaaahbcaabaaa
abaaaaaaegacbaaaabaaaaaaegbcbaaaaeaaaaaadeaaaaahbcaabaaaabaaaaaa
akaabaaaabaaaaaaabeaaaaaaaaaaaaaaaaaaaahbcaabaaaabaaaaaaakaabaaa
abaaaaaaakaabaaaabaaaaaadiaaaaaihcaabaaaaaaaaaaaegacbaaaaaaaaaaa
pgipcaaaaaaaaaaaadaaaaaadgaaaaaficcabaaaaaaaaaaadkaabaaaaaaaaaaa
diaaaaaihcaabaaaaaaaaaaaegacbaaaaaaaaaaaegiccaaaaaaaaaaaabaaaaaa
diaaaaahhccabaaaaaaaaaaaagaabaaaabaaaaaaegacbaaaaaaaaaaadoaaaaab
"
}

SubProgram "gles " {
Keywords { "DIRECTIONAL" }
"!!GLES"
}

SubProgram "glesdesktop " {
Keywords { "DIRECTIONAL" }
"!!GLES"
}

SubProgram "flash " {
Keywords { "DIRECTIONAL" }
Vector 0 [_LightColor0]
Vector 1 [_Color]
Float 2 [_Cutoff]
SetTexture 0 [_BumpMap] 2D
SetTexture 1 [_MainTex] 2D
"agal_ps
c3 0.0 1.0 2.0 -1.0
[bc]
ciaaaaaaaaaaapacaaaaaaoeaeaaaaaaabaaaaaaafaababb tex r0, v0, s1 <2d wrap linear point>
acaaaaaaabaaabacaaaaaappacaaaaaaacaaaaoeabaaaaaa sub r1.x, r0.w, c2
ckaaaaaaabaaabacabaaaaaaacaaaaaaadaaaaaaabaaaaaa slt r1.x, r1.x, c3.x
bfaaaaaaabaaapacabaaaaaaacaaaaaaaaaaaaaaaaaaaaaa neg r1, r1.x
aaaaaaaaacaaacacaaaaaappaeaaaaaaaaaaaaaaaaaaaaaa mov r2.y, v0.w
aaaaaaaaacaaabacaaaaaakkaeaaaaaaaaaaaaaaaaaaaaaa mov r2.x, v0.z
ciaaaaaaacaaapacacaaaafeacaaaaaaaaaaaaaaafaababb tex r2, r2.xyyy, s0 <2d wrap linear point>
chaaaaaaaaaaaaaaabaaaaaaacaaaaaaaaaaaaaaaaaaaaaa kil a0.none, r1.x
aaaaaaaaabaaacacacaaaaffacaaaaaaaaaaaaaaaaaaaaaa mov r1.y, r2.y
aaaaaaaaabaaabacacaaaappacaaaaaaaaaaaaaaaaaaaaaa mov r1.x, r2.w
adaaaaaaabaaadacabaaaafeacaaaaaaadaaaakkabaaaaaa mul r1.xy, r1.xyyy, c3.z
abaaaaaaabaaadacabaaaafeacaaaaaaadaaaappabaaaaaa add r1.xy, r1.xyyy, c3.w
adaaaaaaacaaabacabaaaaffacaaaaaaabaaaaffacaaaaaa mul r2.x, r1.y, r1.y
bfaaaaaaabaaaiacabaaaaaaacaaaaaaaaaaaaaaaaaaaaaa neg r1.w, r1.x
adaaaaaaabaaaiacabaaaappacaaaaaaabaaaaaaacaaaaaa mul r1.w, r1.w, r1.x
acaaaaaaacaaabacabaaaappacaaaaaaacaaaaaaacaaaaaa sub r2.x, r1.w, r2.x
abaaaaaaacaaabacacaaaaaaacaaaaaaadaaaaffabaaaaaa add r2.x, r2.x, c3.y
akaaaaaaacaaabacacaaaaaaacaaaaaaaaaaaaaaaaaaaaaa rsq r2.x, r2.x
afaaaaaaabaaaeacacaaaaaaacaaaaaaaaaaaaaaaaaaaaaa rcp r1.z, r2.x
adaaaaaaacaaahacaaaaaakeacaaaaaaabaaaappabaaaaaa mul r2.xyz, r0.xyzz, c1.w
bcaaaaaaaaaaabacabaaaakeacaaaaaaadaaaaoeaeaaaaaa dp3 r0.x, r1.xyzz, v3
adaaaaaaabaaahacacaaaakeacaaaaaaaaaaaaoeabaaaaaa mul r1.xyz, r2.xyzz, c0
ahaaaaaaaaaaabacaaaaaaaaacaaaaaaadaaaaoeabaaaaaa max r0.x, r0.x, c3
adaaaaaaaaaaahacaaaaaaaaacaaaaaaabaaaakeacaaaaaa mul r0.xyz, r0.x, r1.xyzz
adaaaaaaaaaaahacaaaaaakeacaaaaaaadaaaakkabaaaaaa mul r0.xyz, r0.xyzz, c3.z
aaaaaaaaaaaaapadaaaaaaoeacaaaaaaaaaaaaaaaaaaaaaa mov o0, r0
"
}

SubProgram "d3d11_9x " {
Keywords { "DIRECTIONAL" }
ConstBuffer "$Globals" 112 // 100 used size, 7 vars
Vector 16 [_LightColor0] 4
Vector 48 [_Color] 4
Float 96 [_Cutoff]
BindCB "$Globals" 0
SetTexture 0 [_BumpMap] 2D 1
SetTexture 1 [_MainTex] 2D 0
// 17 instructions, 2 temp regs, 0 temp arrays:
// ALU 9 float, 0 int, 0 uint
// TEX 2 (0 load, 0 comp, 0 bias, 0 grad)
// FLOW 1 static, 0 dynamic
"ps_4_0_level_9_3
eefiecedombkdmfdgijadllicgeincfaaafhmhikabaaaaaadaafaaaaaeaaaaaa
daaaaaaanmabaaaafmaeaaaapmaeaaaaebgpgodjkeabaaaakeabaaaaaaacpppp
feabaaaafaaaaaaaadaacmaaaaaafaaaaaaafaaaacaaceaaaaaafaaaabaaaaaa
aaababaaaaaaabaaabaaaaaaaaaaaaaaaaaaadaaabaaabaaaaaaaaaaaaaaagaa
abaaacaaaaaaaaaaabacppppfbaaaaafadaaapkaaaaaaaeaaaaaialpaaaaiadp
aaaaaaaabpaaaaacaaaaaaiaaaaaaplabpaaaaacaaaaaaiaadaachlabpaaaaac
aaaaaajaaaaiapkabpaaaaacaaaaaajaabaiapkaecaaaaadaaaaapiaaaaaoela
aaaioekaacaaaaadabaacpiaaaaappiaacaaaakbabaaaaacacaaadiaaaaaoola
ebaaaaababaaapiaecaaaaadabaacpiaacaaoeiaabaioekaaeaaaaaeabaacdia
abaaohiaadaaaakaadaaffkaaeaaaaaeabaaciiaabaaaaiaabaaaaibadaakkka
aeaaaaaeabaaciiaabaaffiaabaaffibabaappiaahaaaaacabaaciiaabaappia
agaaaaacabaaceiaabaappiaaiaaaaadabaacbiaabaaoeiaadaaoelaalaaaaad
acaacbiaabaaaaiaadaappkaacaaaaadabaacbiaacaaaaiaacaaaaiaafaaaaad
abaacoiaaaaajaiaabaappkaafaaaaadabaacoiaabaaoeiaaaaajakaafaaaaad
aaaachiaabaaaaiaabaapjiaabaaaaacaaaicpiaaaaaoeiappppaaaafdeieefc
hiacaaaaeaaaaaaajoaaaaaafjaaaaaeegiocaaaaaaaaaaaahaaaaaafkaaaaad
aagabaaaaaaaaaaafkaaaaadaagabaaaabaaaaaafibiaaaeaahabaaaaaaaaaaa
ffffaaaafibiaaaeaahabaaaabaaaaaaffffaaaagcbaaaadpcbabaaaabaaaaaa
gcbaaaadhcbabaaaaeaaaaaagfaaaaadpccabaaaaaaaaaaagiaaaaacacaaaaaa
efaaaaajpcaabaaaaaaaaaaaegbabaaaabaaaaaaeghobaaaabaaaaaaaagabaaa
aaaaaaaaaaaaaaajbcaabaaaabaaaaaadkaabaaaaaaaaaaaakiacaiaebaaaaaa
aaaaaaaaagaaaaaadbaaaaahbcaabaaaabaaaaaaakaabaaaabaaaaaaabeaaaaa
aaaaaaaaanaaaeadakaabaaaabaaaaaaefaaaaajpcaabaaaabaaaaaaogbkbaaa
abaaaaaaeghobaaaaaaaaaaaaagabaaaabaaaaaadcaaaaapdcaabaaaabaaaaaa
hgapbaaaabaaaaaaaceaaaaaaaaaaaeaaaaaaaeaaaaaaaaaaaaaaaaaaceaaaaa
aaaaialpaaaaialpaaaaaaaaaaaaaaaadcaaaaakicaabaaaabaaaaaaakaabaia
ebaaaaaaabaaaaaaakaabaaaabaaaaaaabeaaaaaaaaaiadpdcaaaaakicaabaaa
abaaaaaabkaabaiaebaaaaaaabaaaaaabkaabaaaabaaaaaadkaabaaaabaaaaaa
elaaaaafecaabaaaabaaaaaadkaabaaaabaaaaaabaaaaaahbcaabaaaabaaaaaa
egacbaaaabaaaaaaegbcbaaaaeaaaaaadeaaaaahbcaabaaaabaaaaaaakaabaaa
abaaaaaaabeaaaaaaaaaaaaaaaaaaaahbcaabaaaabaaaaaaakaabaaaabaaaaaa
akaabaaaabaaaaaadiaaaaaihcaabaaaaaaaaaaaegacbaaaaaaaaaaapgipcaaa
aaaaaaaaadaaaaaadgaaaaaficcabaaaaaaaaaaadkaabaaaaaaaaaaadiaaaaai
hcaabaaaaaaaaaaaegacbaaaaaaaaaaaegiccaaaaaaaaaaaabaaaaaadiaaaaah
hccabaaaaaaaaaaaagaabaaaabaaaaaaegacbaaaaaaaaaaadoaaaaabejfdeheo
jiaaaaaaafaaaaaaaiaaaaaaiaaaaaaaaaaaaaaaabaaaaaaadaaaaaaaaaaaaaa
apaaaaaaimaaaaaaaaaaaaaaaaaaaaaaadaaaaaaabaaaaaaapapaaaaimaaaaaa
abaaaaaaaaaaaaaaadaaaaaaacaaaaaaahaaaaaaimaaaaaaacaaaaaaaaaaaaaa
adaaaaaaadaaaaaaahaaaaaaimaaaaaaadaaaaaaaaaaaaaaadaaaaaaaeaaaaaa
ahahaaaafdfgfpfaepfdejfeejepeoaafeeffiedepepfceeaaklklklepfdeheo
cmaaaaaaabaaaaaaaiaaaaaacaaaaaaaaaaaaaaaaaaaaaaaadaaaaaaaaaaaaaa
apaaaaaafdfgfpfegbhcghgfheaaklkl"
}

SubProgram "opengl " {
Keywords { "SPOT" }
Vector 0 [_LightColor0]
Vector 1 [_Color]
Float 2 [_Cutoff]
SetTexture 0 [_BumpMap] 2D
SetTexture 1 [_MainTex] 2D
SetTexture 3 [_LightTexture0] 2D
SetTexture 4 [_LightTextureB0] 2D
"!!ARBfp1.0
OPTION ARB_precision_hint_fastest;
# 29 ALU, 4 TEX
PARAM c[4] = { program.local[0..2],
		{ 2, 1, 0, 0.5 } };
TEMP R0;
TEMP R1;
TEMP R2;
TEMP R3;
TEX R2, fragment.texcoord[0], texture[1], 2D;
TEX R3.yw, fragment.texcoord[0].zwzw, texture[0], 2D;
SLT R0.w, R2, c[2].x;
DP3 R0.z, fragment.texcoord[4], fragment.texcoord[4];
RCP R0.x, fragment.texcoord[4].w;
DP3 R1.x, fragment.texcoord[3], fragment.texcoord[3];
RSQ R1.x, R1.x;
MUL R1.xyz, R1.x, fragment.texcoord[3];
MAD R0.xy, fragment.texcoord[4], R0.x, c[3].w;
MOV result.color.w, R2;
KIL -R0.w;
TEX R0.w, R0, texture[3], 2D;
TEX R1.w, R0.z, texture[4], 2D;
MAD R0.xy, R3.wyzw, c[3].x, -c[3].y;
MUL R0.z, R0.y, R0.y;
MAD R0.z, -R0.x, R0.x, -R0;
ADD R0.z, R0, c[3].y;
RSQ R0.z, R0.z;
RCP R0.z, R0.z;
DP3 R0.x, R0, R1;
MAX R1.x, R0, c[3].z;
MUL R0.xyz, R2, c[1].w;
SLT R1.y, c[3].z, fragment.texcoord[4].z;
MUL R0.w, R1.y, R0;
MUL R0.w, R0, R1;
MUL R0.xyz, R0, c[0];
MUL R0.w, R1.x, R0;
MUL R0.xyz, R0.w, R0;
MUL result.color.xyz, R0, c[3].x;
END
# 29 instructions, 4 R-regs
"
}

SubProgram "d3d9 " {
Keywords { "SPOT" }
Vector 0 [_LightColor0]
Vector 1 [_Color]
Float 2 [_Cutoff]
SetTexture 0 [_BumpMap] 2D
SetTexture 1 [_MainTex] 2D
SetTexture 3 [_LightTexture0] 2D
SetTexture 4 [_LightTextureB0] 2D
"ps_2_0
; 32 ALU, 5 TEX
dcl_2d s0
dcl_2d s1
dcl_2d s3
dcl_2d s4
def c3, 0.00000000, 1.00000000, 2.00000000, -1.00000000
def c4, 0.50000000, 0, 0, 0
dcl t0
dcl t3.xyz
dcl t4
texld r2, t0, s1
add_pp r0.x, r2.w, -c2
cmp r1.x, r0, c3, c3.y
dp3 r0.x, t4, t4
mov r3.xy, r0.x
mov_pp r1, -r1.x
rcp r0.x, t4.w
mad r0.xy, t4, r0.x, c4.x
mul r2.xyz, r2, c1.w
mov r4.y, t0.w
mov r4.x, t0.z
mul_pp r2.xyz, r2, c0
texkill r1.xyzw
texld r1, r4, s0
texld r3, r3, s4
texld r0, r0, s3
dp3_pp r1.x, t3, t3
mov r0.y, r1
mov r0.x, r1.w
mad_pp r4.xy, r0, c3.z, c3.w
mul_pp r0.x, r4.y, r4.y
mad_pp r0.x, -r4, r4, -r0
add_pp r0.x, r0, c3.y
rsq_pp r0.x, r0.x
rsq_pp r1.x, r1.x
mul_pp r1.xyz, r1.x, t3
rcp_pp r4.z, r0.x
dp3_pp r0.x, r4, r1
max_pp r0.x, r0, c3
cmp r1.x, -t4.z, c3, c3.y
mul_pp r1.x, r1, r0.w
mul_pp r1.x, r1, r3
mul_pp r0.x, r0, r1
mul_pp r0.xyz, r0.x, r2
mul_pp r0.xyz, r0, c3.z
mov_pp r0.w, r2
mov_pp oC0, r0
"
}

SubProgram "d3d11 " {
Keywords { "SPOT" }
ConstBuffer "$Globals" 176 // 164 used size, 8 vars
Vector 16 [_LightColor0] 4
Vector 112 [_Color] 4
Float 160 [_Cutoff]
BindCB "$Globals" 0
SetTexture 0 [_BumpMap] 2D 3
SetTexture 1 [_MainTex] 2D 2
SetTexture 2 [_LightTexture0] 2D 0
SetTexture 3 [_LightTextureB0] 2D 1
// 29 instructions, 3 temp regs, 0 temp arrays:
// ALU 18 float, 0 int, 1 uint
// TEX 4 (0 load, 0 comp, 0 bias, 0 grad)
// FLOW 1 static, 0 dynamic
"ps_4_0
eefiecednlbomgjiieakkbfdfnihfckdepbegbbgabaaaaaaeaafaaaaadaaaaaa
cmaaaaaaoeaaaaaabiabaaaaejfdeheolaaaaaaaagaaaaaaaiaaaaaajiaaaaaa
aaaaaaaaabaaaaaaadaaaaaaaaaaaaaaapaaaaaakeaaaaaaaaaaaaaaaaaaaaaa
adaaaaaaabaaaaaaapapaaaakeaaaaaaabaaaaaaaaaaaaaaadaaaaaaacaaaaaa
ahaaaaaakeaaaaaaacaaaaaaaaaaaaaaadaaaaaaadaaaaaaahaaaaaakeaaaaaa
adaaaaaaaaaaaaaaadaaaaaaaeaaaaaaahahaaaakeaaaaaaaeaaaaaaaaaaaaaa
adaaaaaaafaaaaaaapapaaaafdfgfpfaepfdejfeejepeoaafeeffiedepepfcee
aaklklklepfdeheocmaaaaaaabaaaaaaaiaaaaaacaaaaaaaaaaaaaaaaaaaaaaa
adaaaaaaaaaaaaaaapaaaaaafdfgfpfegbhcghgfheaaklklfdeieefccaaeaaaa
eaaaaaaaaiabaaaafjaaaaaeegiocaaaaaaaaaaaalaaaaaafkaaaaadaagabaaa
aaaaaaaafkaaaaadaagabaaaabaaaaaafkaaaaadaagabaaaacaaaaaafkaaaaad
aagabaaaadaaaaaafibiaaaeaahabaaaaaaaaaaaffffaaaafibiaaaeaahabaaa
abaaaaaaffffaaaafibiaaaeaahabaaaacaaaaaaffffaaaafibiaaaeaahabaaa
adaaaaaaffffaaaagcbaaaadpcbabaaaabaaaaaagcbaaaadhcbabaaaaeaaaaaa
gcbaaaadpcbabaaaafaaaaaagfaaaaadpccabaaaaaaaaaaagiaaaaacadaaaaaa
efaaaaajpcaabaaaaaaaaaaaegbabaaaabaaaaaaeghobaaaabaaaaaaaagabaaa
acaaaaaaaaaaaaajbcaabaaaabaaaaaadkaabaaaaaaaaaaaakiacaiaebaaaaaa
aaaaaaaaakaaaaaadbaaaaahbcaabaaaabaaaaaaakaabaaaabaaaaaaabeaaaaa
aaaaaaaaanaaaeadakaabaaaabaaaaaabaaaaaahbcaabaaaabaaaaaaegbcbaaa
aeaaaaaaegbcbaaaaeaaaaaaeeaaaaafbcaabaaaabaaaaaaakaabaaaabaaaaaa
diaaaaahhcaabaaaabaaaaaaagaabaaaabaaaaaaegbcbaaaaeaaaaaaefaaaaaj
pcaabaaaacaaaaaaogbkbaaaabaaaaaaeghobaaaaaaaaaaaaagabaaaadaaaaaa
dcaaaaapdcaabaaaacaaaaaahgapbaaaacaaaaaaaceaaaaaaaaaaaeaaaaaaaea
aaaaaaaaaaaaaaaaaceaaaaaaaaaialpaaaaialpaaaaaaaaaaaaaaaadcaaaaak
icaabaaaabaaaaaaakaabaiaebaaaaaaacaaaaaaakaabaaaacaaaaaaabeaaaaa
aaaaiadpdcaaaaakicaabaaaabaaaaaabkaabaiaebaaaaaaacaaaaaabkaabaaa
acaaaaaadkaabaaaabaaaaaaelaaaaafecaabaaaacaaaaaadkaabaaaabaaaaaa
baaaaaahbcaabaaaabaaaaaaegacbaaaacaaaaaaegacbaaaabaaaaaadeaaaaah
bcaabaaaabaaaaaaakaabaaaabaaaaaaabeaaaaaaaaaaaaaaoaaaaahgcaabaaa
abaaaaaaagbbbaaaafaaaaaapgbpbaaaafaaaaaaaaaaaaakgcaabaaaabaaaaaa
fgagbaaaabaaaaaaaceaaaaaaaaaaaaaaaaaaadpaaaaaadpaaaaaaaaefaaaaaj
pcaabaaaacaaaaaajgafbaaaabaaaaaaeghobaaaacaaaaaaaagabaaaaaaaaaaa
dbaaaaahccaabaaaabaaaaaaabeaaaaaaaaaaaaackbabaaaafaaaaaaabaaaaah
ccaabaaaabaaaaaabkaabaaaabaaaaaaabeaaaaaaaaaiadpdiaaaaahccaabaaa
abaaaaaadkaabaaaacaaaaaabkaabaaaabaaaaaabaaaaaahecaabaaaabaaaaaa
egbcbaaaafaaaaaaegbcbaaaafaaaaaaefaaaaajpcaabaaaacaaaaaakgakbaaa
abaaaaaaeghobaaaadaaaaaaaagabaaaabaaaaaadiaaaaahccaabaaaabaaaaaa
bkaabaaaabaaaaaaakaabaaaacaaaaaaapaaaaahbcaabaaaabaaaaaaagaabaaa
abaaaaaafgafbaaaabaaaaaadiaaaaaihcaabaaaaaaaaaaaegacbaaaaaaaaaaa
pgipcaaaaaaaaaaaahaaaaaadgaaaaaficcabaaaaaaaaaaadkaabaaaaaaaaaaa
diaaaaaihcaabaaaaaaaaaaaegacbaaaaaaaaaaaegiccaaaaaaaaaaaabaaaaaa
diaaaaahhccabaaaaaaaaaaaagaabaaaabaaaaaaegacbaaaaaaaaaaadoaaaaab
"
}

SubProgram "gles " {
Keywords { "SPOT" }
"!!GLES"
}

SubProgram "glesdesktop " {
Keywords { "SPOT" }
"!!GLES"
}

SubProgram "flash " {
Keywords { "SPOT" }
Vector 0 [_LightColor0]
Vector 1 [_Color]
Float 2 [_Cutoff]
SetTexture 0 [_BumpMap] 2D
SetTexture 1 [_MainTex] 2D
SetTexture 3 [_LightTexture0] 2D
SetTexture 4 [_LightTextureB0] 2D
"agal_ps
c3 0.0 1.0 2.0 -1.0
c4 0.5 0.0 0.0 0.0
[bc]
ciaaaaaaacaaapacaaaaaaoeaeaaaaaaabaaaaaaafaababb tex r2, v0, s1 <2d wrap linear point>
acaaaaaaaaaaabacacaaaappacaaaaaaacaaaaoeabaaaaaa sub r0.x, r2.w, c2
ckaaaaaaabaaabacaaaaaaaaacaaaaaaaeaaaaffabaaaaaa slt r1.x, r0.x, c4.y
bcaaaaaaaaaaabacaeaaaaoeaeaaaaaaaeaaaaoeaeaaaaaa dp3 r0.x, v4, v4
bfaaaaaaabaaapacabaaaaaaacaaaaaaaaaaaaaaaaaaaaaa neg r1, r1.x
aaaaaaaaaeaaadacaaaaaaaaacaaaaaaaaaaaaaaaaaaaaaa mov r4.xy, r0.x
afaaaaaaaaaaabacaeaaaappaeaaaaaaaaaaaaaaaaaaaaaa rcp r0.x, v4.w
adaaaaaaacaaahacacaaaakeacaaaaaaabaaaappabaaaaaa mul r2.xyz, r2.xyzz, c1.w
adaaaaaaaaaaadacaeaaaaoeaeaaaaaaaaaaaaaaacaaaaaa mul r0.xy, v4, r0.x
abaaaaaaaaaaadacaaaaaafeacaaaaaaaeaaaaaaabaaaaaa add r0.xy, r0.xyyy, c4.x
aaaaaaaaadaaacacaaaaaappaeaaaaaaaaaaaaaaaaaaaaaa mov r3.y, v0.w
aaaaaaaaadaaabacaaaaaakkaeaaaaaaaaaaaaaaaaaaaaaa mov r3.x, v0.z
adaaaaaaacaaahacacaaaakeacaaaaaaaaaaaaoeabaaaaaa mul r2.xyz, r2.xyzz, c0
ciaaaaaaadaaapacadaaaafeacaaaaaaaaaaaaaaafaababb tex r3, r3.xyyy, s0 <2d wrap linear point>
chaaaaaaaaaaaaaaabaaaaaaacaaaaaaaaaaaaaaaaaaaaaa kil a0.none, r1.x
ciaaaaaaabaaapacaaaaaafeacaaaaaaadaaaaaaafaababb tex r1, r0.xyyy, s3 <2d wrap linear point>
ciaaaaaaaaaaapacaeaaaafeacaaaaaaaeaaaaaaafaababb tex r0, r4.xyyy, s4 <2d wrap linear point>
bcaaaaaaabaaabacadaaaaoeaeaaaaaaadaaaaoeaeaaaaaa dp3 r1.x, v3, v3
akaaaaaaabaaabacabaaaaaaacaaaaaaaaaaaaaaaaaaaaaa rsq r1.x, r1.x
adaaaaaaabaaahacabaaaaaaacaaaaaaadaaaaoeaeaaaaaa mul r1.xyz, r1.x, v3
aaaaaaaaaaaaacacadaaaaffacaaaaaaaaaaaaaaaaaaaaaa mov r0.y, r3.y
aaaaaaaaaaaaabacadaaaappacaaaaaaaaaaaaaaaaaaaaaa mov r0.x, r3.w
adaaaaaaadaaadacaaaaaafeacaaaaaaadaaaakkabaaaaaa mul r3.xy, r0.xyyy, c3.z
abaaaaaaadaaadacadaaaafeacaaaaaaadaaaappabaaaaaa add r3.xy, r3.xyyy, c3.w
adaaaaaaaaaaabacadaaaaffacaaaaaaadaaaaffacaaaaaa mul r0.x, r3.y, r3.y
bfaaaaaaaeaaabacadaaaaaaacaaaaaaaaaaaaaaaaaaaaaa neg r4.x, r3.x
adaaaaaaaeaaabacaeaaaaaaacaaaaaaadaaaaaaacaaaaaa mul r4.x, r4.x, r3.x
acaaaaaaaaaaabacaeaaaaaaacaaaaaaaaaaaaaaacaaaaaa sub r0.x, r4.x, r0.x
abaaaaaaaaaaabacaaaaaaaaacaaaaaaadaaaaffabaaaaaa add r0.x, r0.x, c3.y
akaaaaaaaaaaabacaaaaaaaaacaaaaaaaaaaaaaaaaaaaaaa rsq r0.x, r0.x
afaaaaaaadaaaeacaaaaaaaaacaaaaaaaaaaaaaaaaaaaaaa rcp r3.z, r0.x
bcaaaaaaaaaaabacadaaaakeacaaaaaaabaaaakeacaaaaaa dp3 r0.x, r3.xyzz, r1.xyzz
ahaaaaaaaaaaabacaaaaaaaaacaaaaaaadaaaaoeabaaaaaa max r0.x, r0.x, c3
bfaaaaaaadaaaeacaeaaaakkaeaaaaaaaaaaaaaaaaaaaaaa neg r3.z, v4.z
ckaaaaaaabaaabacadaaaakkacaaaaaaaeaaaaffabaaaaaa slt r1.x, r3.z, c4.y
adaaaaaaabaaabacabaaaaaaacaaaaaaabaaaappacaaaaaa mul r1.x, r1.x, r1.w
adaaaaaaabaaabacabaaaaaaacaaaaaaaaaaaappacaaaaaa mul r1.x, r1.x, r0.w
adaaaaaaaaaaabacaaaaaaaaacaaaaaaabaaaaaaacaaaaaa mul r0.x, r0.x, r1.x
adaaaaaaaaaaahacaaaaaaaaacaaaaaaacaaaakeacaaaaaa mul r0.xyz, r0.x, r2.xyzz
adaaaaaaaaaaahacaaaaaakeacaaaaaaadaaaakkabaaaaaa mul r0.xyz, r0.xyzz, c3.z
aaaaaaaaaaaaaiacacaaaappacaaaaaaaaaaaaaaaaaaaaaa mov r0.w, r2.w
aaaaaaaaaaaaapadaaaaaaoeacaaaaaaaaaaaaaaaaaaaaaa mov o0, r0
"
}

SubProgram "d3d11_9x " {
Keywords { "SPOT" }
ConstBuffer "$Globals" 176 // 164 used size, 8 vars
Vector 16 [_LightColor0] 4
Vector 112 [_Color] 4
Float 160 [_Cutoff]
BindCB "$Globals" 0
SetTexture 0 [_BumpMap] 2D 3
SetTexture 1 [_MainTex] 2D 2
SetTexture 2 [_LightTexture0] 2D 0
SetTexture 3 [_LightTextureB0] 2D 1
// 29 instructions, 3 temp regs, 0 temp arrays:
// ALU 18 float, 0 int, 1 uint
// TEX 4 (0 load, 0 comp, 0 bias, 0 grad)
// FLOW 1 static, 0 dynamic
"ps_4_0_level_9_3
eefiecedcmmlecbkbfgojoecnngcpclicjnckcilabaaaaaameahaaaaaeaaaaaa
daaaaaaalaacaaaaniagaaaajaahaaaaebgpgodjhiacaaaahiacaaaaaaacpppp
caacaaaafiaaaaaaadaadeaaaaaafiaaaaaafiaaaeaaceaaaaaafiaaacaaaaaa
adababaaabacacaaaaadadaaaaaaabaaabaaaaaaaaaaaaaaaaaaahaaabaaabaa
aaaaaaaaaaaaakaaabaaacaaaaaaaaaaabacppppfbaaaaafadaaapkaaaaaaaea
aaaaialpaaaaiadpaaaaaadpfbaaaaafaeaaapkaaaaaaaaaaaaaaaaaaaaaaaaa
aaaaaaaabpaaaaacaaaaaaiaaaaaaplabpaaaaacaaaaaaiaadaachlabpaaaaac
aaaaaaiaaeaaaplabpaaaaacaaaaaajaaaaiapkabpaaaaacaaaaaajaabaiapka
bpaaaaacaaaaaajaacaiapkabpaaaaacaaaaaajaadaiapkaecaaaaadaaaaapia
aaaaoelaacaioekaacaaaaadabaacpiaaaaappiaacaaaakbabaaaaacacaaadia
aaaaoolaebaaaaababaaapiaecaaaaadabaacpiaacaaoeiaadaioekaaeaaaaae
abaacdiaabaaohiaadaaaakaadaaffkaaeaaaaaeabaaciiaabaaaaiaabaaaaib
adaakkkaaeaaaaaeabaaciiaabaaffiaabaaffibabaappiaahaaaaacabaaciia
abaappiaagaaaaacabaaceiaabaappiaceaaaaacacaachiaadaaoelaaiaaaaad
abaacbiaabaaoeiaacaaoeiaalaaaaadacaacbiaabaaaaiaaeaaaakaagaaaaac
abaaabiaaeaapplaaeaaaaaeabaaadiaaeaaoelaabaaaaiaadaappkaaiaaaaad
adaaaiiaaeaaoelaaeaaoelaabaaaaacadaaadiaadaappiaecaaaaadabaacpia
abaaoeiaaaaioekaecaaaaadadaacpiaadaaoeiaabaioekaafaaaaadabaacbia
abaappiaadaaaaiafiaaaaaeabaacbiaaeaakklbaeaaaakaabaaaaiafkaaaaae
abaacbiaacaaaaiaabaaaaiaaeaaaakaafaaaaadabaacoiaaaaajaiaabaappka
afaaaaadabaacoiaabaaoeiaaaaajakaafaaaaadaaaachiaabaaaaiaabaapjia
abaaaaacaaaicpiaaaaaoeiappppaaaafdeieefccaaeaaaaeaaaaaaaaiabaaaa
fjaaaaaeegiocaaaaaaaaaaaalaaaaaafkaaaaadaagabaaaaaaaaaaafkaaaaad
aagabaaaabaaaaaafkaaaaadaagabaaaacaaaaaafkaaaaadaagabaaaadaaaaaa
fibiaaaeaahabaaaaaaaaaaaffffaaaafibiaaaeaahabaaaabaaaaaaffffaaaa
fibiaaaeaahabaaaacaaaaaaffffaaaafibiaaaeaahabaaaadaaaaaaffffaaaa
gcbaaaadpcbabaaaabaaaaaagcbaaaadhcbabaaaaeaaaaaagcbaaaadpcbabaaa
afaaaaaagfaaaaadpccabaaaaaaaaaaagiaaaaacadaaaaaaefaaaaajpcaabaaa
aaaaaaaaegbabaaaabaaaaaaeghobaaaabaaaaaaaagabaaaacaaaaaaaaaaaaaj
bcaabaaaabaaaaaadkaabaaaaaaaaaaaakiacaiaebaaaaaaaaaaaaaaakaaaaaa
dbaaaaahbcaabaaaabaaaaaaakaabaaaabaaaaaaabeaaaaaaaaaaaaaanaaaead
akaabaaaabaaaaaabaaaaaahbcaabaaaabaaaaaaegbcbaaaaeaaaaaaegbcbaaa
aeaaaaaaeeaaaaafbcaabaaaabaaaaaaakaabaaaabaaaaaadiaaaaahhcaabaaa
abaaaaaaagaabaaaabaaaaaaegbcbaaaaeaaaaaaefaaaaajpcaabaaaacaaaaaa
ogbkbaaaabaaaaaaeghobaaaaaaaaaaaaagabaaaadaaaaaadcaaaaapdcaabaaa
acaaaaaahgapbaaaacaaaaaaaceaaaaaaaaaaaeaaaaaaaeaaaaaaaaaaaaaaaaa
aceaaaaaaaaaialpaaaaialpaaaaaaaaaaaaaaaadcaaaaakicaabaaaabaaaaaa
akaabaiaebaaaaaaacaaaaaaakaabaaaacaaaaaaabeaaaaaaaaaiadpdcaaaaak
icaabaaaabaaaaaabkaabaiaebaaaaaaacaaaaaabkaabaaaacaaaaaadkaabaaa
abaaaaaaelaaaaafecaabaaaacaaaaaadkaabaaaabaaaaaabaaaaaahbcaabaaa
abaaaaaaegacbaaaacaaaaaaegacbaaaabaaaaaadeaaaaahbcaabaaaabaaaaaa
akaabaaaabaaaaaaabeaaaaaaaaaaaaaaoaaaaahgcaabaaaabaaaaaaagbbbaaa
afaaaaaapgbpbaaaafaaaaaaaaaaaaakgcaabaaaabaaaaaafgagbaaaabaaaaaa
aceaaaaaaaaaaaaaaaaaaadpaaaaaadpaaaaaaaaefaaaaajpcaabaaaacaaaaaa
jgafbaaaabaaaaaaeghobaaaacaaaaaaaagabaaaaaaaaaaadbaaaaahccaabaaa
abaaaaaaabeaaaaaaaaaaaaackbabaaaafaaaaaaabaaaaahccaabaaaabaaaaaa
bkaabaaaabaaaaaaabeaaaaaaaaaiadpdiaaaaahccaabaaaabaaaaaadkaabaaa
acaaaaaabkaabaaaabaaaaaabaaaaaahecaabaaaabaaaaaaegbcbaaaafaaaaaa
egbcbaaaafaaaaaaefaaaaajpcaabaaaacaaaaaakgakbaaaabaaaaaaeghobaaa
adaaaaaaaagabaaaabaaaaaadiaaaaahccaabaaaabaaaaaabkaabaaaabaaaaaa
akaabaaaacaaaaaaapaaaaahbcaabaaaabaaaaaaagaabaaaabaaaaaafgafbaaa
abaaaaaadiaaaaaihcaabaaaaaaaaaaaegacbaaaaaaaaaaapgipcaaaaaaaaaaa
ahaaaaaadgaaaaaficcabaaaaaaaaaaadkaabaaaaaaaaaaadiaaaaaihcaabaaa
aaaaaaaaegacbaaaaaaaaaaaegiccaaaaaaaaaaaabaaaaaadiaaaaahhccabaaa
aaaaaaaaagaabaaaabaaaaaaegacbaaaaaaaaaaadoaaaaabejfdeheolaaaaaaa
agaaaaaaaiaaaaaajiaaaaaaaaaaaaaaabaaaaaaadaaaaaaaaaaaaaaapaaaaaa
keaaaaaaaaaaaaaaaaaaaaaaadaaaaaaabaaaaaaapapaaaakeaaaaaaabaaaaaa
aaaaaaaaadaaaaaaacaaaaaaahaaaaaakeaaaaaaacaaaaaaaaaaaaaaadaaaaaa
adaaaaaaahaaaaaakeaaaaaaadaaaaaaaaaaaaaaadaaaaaaaeaaaaaaahahaaaa
keaaaaaaaeaaaaaaaaaaaaaaadaaaaaaafaaaaaaapapaaaafdfgfpfaepfdejfe
ejepeoaafeeffiedepepfceeaaklklklepfdeheocmaaaaaaabaaaaaaaiaaaaaa
caaaaaaaaaaaaaaaaaaaaaaaadaaaaaaaaaaaaaaapaaaaaafdfgfpfegbhcghgf
heaaklkl"
}

SubProgram "opengl " {
Keywords { "POINT_COOKIE" }
Vector 0 [_LightColor0]
Vector 1 [_Color]
Float 2 [_Cutoff]
SetTexture 0 [_BumpMap] 2D
SetTexture 1 [_MainTex] 2D
SetTexture 3 [_LightTextureB0] 2D
SetTexture 4 [_LightTexture0] CUBE
"!!ARBfp1.0
OPTION ARB_precision_hint_fastest;
# 25 ALU, 4 TEX
PARAM c[4] = { program.local[0..2],
		{ 2, 1, 0 } };
TEMP R0;
TEMP R1;
TEMP R2;
TEMP R3;
TEX R2, fragment.texcoord[0], texture[1], 2D;
TEX R3.yw, fragment.texcoord[0].zwzw, texture[0], 2D;
TEX R1.w, fragment.texcoord[4], texture[4], CUBE;
SLT R0.y, R2.w, c[2].x;
DP3 R0.x, fragment.texcoord[4], fragment.texcoord[4];
DP3 R1.x, fragment.texcoord[3], fragment.texcoord[3];
RSQ R1.x, R1.x;
MUL R1.xyz, R1.x, fragment.texcoord[3];
MOV result.color.w, R2;
TEX R0.w, R0.x, texture[3], 2D;
KIL -R0.y;
MAD R0.xy, R3.wyzw, c[3].x, -c[3].y;
MUL R0.z, R0.y, R0.y;
MAD R0.z, -R0.x, R0.x, -R0;
ADD R0.z, R0, c[3].y;
RSQ R0.z, R0.z;
RCP R0.z, R0.z;
DP3 R0.x, R0, R1;
MAX R1.x, R0, c[3].z;
MUL R0.xyz, R2, c[1].w;
MUL R0.w, R0, R1;
MUL R0.xyz, R0, c[0];
MUL R0.w, R1.x, R0;
MUL R0.xyz, R0.w, R0;
MUL result.color.xyz, R0, c[3].x;
END
# 25 instructions, 4 R-regs
"
}

SubProgram "d3d9 " {
Keywords { "POINT_COOKIE" }
Vector 0 [_LightColor0]
Vector 1 [_Color]
Float 2 [_Cutoff]
SetTexture 0 [_BumpMap] 2D
SetTexture 1 [_MainTex] 2D
SetTexture 3 [_LightTextureB0] 2D
SetTexture 4 [_LightTexture0] CUBE
"ps_2_0
; 29 ALU, 5 TEX
dcl_2d s0
dcl_2d s1
dcl_2d s3
dcl_cube s4
def c3, 0.00000000, 1.00000000, 2.00000000, -1.00000000
dcl t0
dcl t3.xyz
dcl t4.xyz
texld r2, t0, s1
add_pp r0.x, r2.w, -c2
cmp r0.x, r0, c3, c3.y
mov_pp r1, -r0.x
dp3 r0.x, t4, t4
mul r2.xyz, r2, c1.w
mov r3.y, t0.w
mov r3.x, t0.z
mov r4.xy, r3
mov r0.xy, r0.x
mul_pp r2.xyz, r2, c0
texld r3, r0, s3
texkill r1.xyzw
texld r1, r4, s0
texld r0, t4, s4
dp3_pp r1.x, t3, t3
mov r0.y, r1
mov r0.x, r1.w
mad_pp r4.xy, r0, c3.z, c3.w
mul_pp r0.x, r4.y, r4.y
mad_pp r0.x, -r4, r4, -r0
add_pp r0.x, r0, c3.y
rsq_pp r0.x, r0.x
rsq_pp r1.x, r1.x
mul_pp r1.xyz, r1.x, t3
rcp_pp r4.z, r0.x
dp3_pp r0.x, r4, r1
max_pp r0.x, r0, c3
mul r1.x, r3, r0.w
mul_pp r0.x, r0, r1
mul_pp r0.xyz, r0.x, r2
mul_pp r0.xyz, r0, c3.z
mov_pp r0.w, r2
mov_pp oC0, r0
"
}

SubProgram "d3d11 " {
Keywords { "POINT_COOKIE" }
ConstBuffer "$Globals" 176 // 164 used size, 8 vars
Vector 16 [_LightColor0] 4
Vector 112 [_Color] 4
Float 160 [_Cutoff]
BindCB "$Globals" 0
SetTexture 0 [_BumpMap] 2D 3
SetTexture 1 [_MainTex] 2D 2
SetTexture 2 [_LightTextureB0] 2D 1
SetTexture 3 [_LightTexture0] CUBE 0
// 24 instructions, 4 temp regs, 0 temp arrays:
// ALU 14 float, 0 int, 0 uint
// TEX 4 (0 load, 0 comp, 0 bias, 0 grad)
// FLOW 1 static, 0 dynamic
"ps_4_0
eefiecedkijlajlnnhpffcipbjmmojgailleciplabaaaaaakiaeaaaaadaaaaaa
cmaaaaaaoeaaaaaabiabaaaaejfdeheolaaaaaaaagaaaaaaaiaaaaaajiaaaaaa
aaaaaaaaabaaaaaaadaaaaaaaaaaaaaaapaaaaaakeaaaaaaaaaaaaaaaaaaaaaa
adaaaaaaabaaaaaaapapaaaakeaaaaaaabaaaaaaaaaaaaaaadaaaaaaacaaaaaa
ahaaaaaakeaaaaaaacaaaaaaaaaaaaaaadaaaaaaadaaaaaaahaaaaaakeaaaaaa
adaaaaaaaaaaaaaaadaaaaaaaeaaaaaaahahaaaakeaaaaaaaeaaaaaaaaaaaaaa
adaaaaaaafaaaaaaahahaaaafdfgfpfaepfdejfeejepeoaafeeffiedepepfcee
aaklklklepfdeheocmaaaaaaabaaaaaaaiaaaaaacaaaaaaaaaaaaaaaaaaaaaaa
adaaaaaaaaaaaaaaapaaaaaafdfgfpfegbhcghgfheaaklklfdeieefciiadaaaa
eaaaaaaaocaaaaaafjaaaaaeegiocaaaaaaaaaaaalaaaaaafkaaaaadaagabaaa
aaaaaaaafkaaaaadaagabaaaabaaaaaafkaaaaadaagabaaaacaaaaaafkaaaaad
aagabaaaadaaaaaafibiaaaeaahabaaaaaaaaaaaffffaaaafibiaaaeaahabaaa
abaaaaaaffffaaaafibiaaaeaahabaaaacaaaaaaffffaaaafidaaaaeaahabaaa
adaaaaaaffffaaaagcbaaaadpcbabaaaabaaaaaagcbaaaadhcbabaaaaeaaaaaa
gcbaaaadhcbabaaaafaaaaaagfaaaaadpccabaaaaaaaaaaagiaaaaacaeaaaaaa
efaaaaajpcaabaaaaaaaaaaaegbabaaaabaaaaaaeghobaaaabaaaaaaaagabaaa
acaaaaaaaaaaaaajbcaabaaaabaaaaaadkaabaaaaaaaaaaaakiacaiaebaaaaaa
aaaaaaaaakaaaaaadbaaaaahbcaabaaaabaaaaaaakaabaaaabaaaaaaabeaaaaa
aaaaaaaaanaaaeadakaabaaaabaaaaaabaaaaaahbcaabaaaabaaaaaaegbcbaaa
aeaaaaaaegbcbaaaaeaaaaaaeeaaaaafbcaabaaaabaaaaaaakaabaaaabaaaaaa
diaaaaahhcaabaaaabaaaaaaagaabaaaabaaaaaaegbcbaaaaeaaaaaaefaaaaaj
pcaabaaaacaaaaaaogbkbaaaabaaaaaaeghobaaaaaaaaaaaaagabaaaadaaaaaa
dcaaaaapdcaabaaaacaaaaaahgapbaaaacaaaaaaaceaaaaaaaaaaaeaaaaaaaea
aaaaaaaaaaaaaaaaaceaaaaaaaaaialpaaaaialpaaaaaaaaaaaaaaaadcaaaaak
icaabaaaabaaaaaaakaabaiaebaaaaaaacaaaaaaakaabaaaacaaaaaaabeaaaaa
aaaaiadpdcaaaaakicaabaaaabaaaaaabkaabaiaebaaaaaaacaaaaaabkaabaaa
acaaaaaadkaabaaaabaaaaaaelaaaaafecaabaaaacaaaaaadkaabaaaabaaaaaa
baaaaaahbcaabaaaabaaaaaaegacbaaaacaaaaaaegacbaaaabaaaaaadeaaaaah
bcaabaaaabaaaaaaakaabaaaabaaaaaaabeaaaaaaaaaaaaabaaaaaahccaabaaa
abaaaaaaegbcbaaaafaaaaaaegbcbaaaafaaaaaaefaaaaajpcaabaaaacaaaaaa
fgafbaaaabaaaaaaeghobaaaacaaaaaaaagabaaaabaaaaaaefaaaaajpcaabaaa
adaaaaaaegbcbaaaafaaaaaaeghobaaaadaaaaaaaagabaaaaaaaaaaadiaaaaah
ccaabaaaabaaaaaaakaabaaaacaaaaaadkaabaaaadaaaaaaapaaaaahbcaabaaa
abaaaaaaagaabaaaabaaaaaafgafbaaaabaaaaaadiaaaaaihcaabaaaaaaaaaaa
egacbaaaaaaaaaaapgipcaaaaaaaaaaaahaaaaaadgaaaaaficcabaaaaaaaaaaa
dkaabaaaaaaaaaaadiaaaaaihcaabaaaaaaaaaaaegacbaaaaaaaaaaaegiccaaa
aaaaaaaaabaaaaaadiaaaaahhccabaaaaaaaaaaaagaabaaaabaaaaaaegacbaaa
aaaaaaaadoaaaaab"
}

SubProgram "gles " {
Keywords { "POINT_COOKIE" }
"!!GLES"
}

SubProgram "glesdesktop " {
Keywords { "POINT_COOKIE" }
"!!GLES"
}

SubProgram "flash " {
Keywords { "POINT_COOKIE" }
Vector 0 [_LightColor0]
Vector 1 [_Color]
Float 2 [_Cutoff]
SetTexture 0 [_BumpMap] 2D
SetTexture 1 [_MainTex] 2D
SetTexture 3 [_LightTextureB0] 2D
SetTexture 4 [_LightTexture0] CUBE
"agal_ps
c3 0.0 1.0 2.0 -1.0
[bc]
ciaaaaaaacaaapacaaaaaaoeaeaaaaaaabaaaaaaafaababb tex r2, v0, s1 <2d wrap linear point>
acaaaaaaaaaaabacacaaaappacaaaaaaacaaaaoeabaaaaaa sub r0.x, r2.w, c2
ckaaaaaaaaaaabacaaaaaaaaacaaaaaaadaaaaaaabaaaaaa slt r0.x, r0.x, c3.x
bfaaaaaaabaaapacaaaaaaaaacaaaaaaaaaaaaaaaaaaaaaa neg r1, r0.x
bcaaaaaaaaaaabacaeaaaaoeaeaaaaaaaeaaaaoeaeaaaaaa dp3 r0.x, v4, v4
adaaaaaaacaaahacacaaaakeacaaaaaaabaaaappabaaaaaa mul r2.xyz, r2.xyzz, c1.w
aaaaaaaaaaaaadacaaaaaaaaacaaaaaaaaaaaaaaaaaaaaaa mov r0.xy, r0.x
aaaaaaaaadaaacacaaaaaappaeaaaaaaaaaaaaaaaaaaaaaa mov r3.y, v0.w
aaaaaaaaadaaabacaaaaaakkaeaaaaaaaaaaaaaaaaaaaaaa mov r3.x, v0.z
adaaaaaaacaaahacacaaaakeacaaaaaaaaaaaaoeabaaaaaa mul r2.xyz, r2.xyzz, c0
ciaaaaaaadaaapacadaaaafeacaaaaaaaaaaaaaaafaababb tex r3, r3.xyyy, s0 <2d wrap linear point>
chaaaaaaaaaaaaaaabaaaaaaacaaaaaaaaaaaaaaaaaaaaaa kil a0.none, r1.x
ciaaaaaaabaaapacaaaaaafeacaaaaaaadaaaaaaafaababb tex r1, r0.xyyy, s3 <2d wrap linear point>
ciaaaaaaaaaaapacaeaaaaoeaeaaaaaaaeaaaaaaafbababb tex r0, v4, s4 <cube wrap linear point>
bcaaaaaaabaaabacadaaaaoeaeaaaaaaadaaaaoeaeaaaaaa dp3 r1.x, v3, v3
akaaaaaaabaaabacabaaaaaaacaaaaaaaaaaaaaaaaaaaaaa rsq r1.x, r1.x
adaaaaaaabaaahacabaaaaaaacaaaaaaadaaaaoeaeaaaaaa mul r1.xyz, r1.x, v3
aaaaaaaaaaaaacacadaaaaffacaaaaaaaaaaaaaaaaaaaaaa mov r0.y, r3.y
aaaaaaaaaaaaabacadaaaappacaaaaaaaaaaaaaaaaaaaaaa mov r0.x, r3.w
adaaaaaaadaaadacaaaaaafeacaaaaaaadaaaakkabaaaaaa mul r3.xy, r0.xyyy, c3.z
abaaaaaaadaaadacadaaaafeacaaaaaaadaaaappabaaaaaa add r3.xy, r3.xyyy, c3.w
adaaaaaaaaaaabacadaaaaffacaaaaaaadaaaaffacaaaaaa mul r0.x, r3.y, r3.y
bfaaaaaaaeaaabacadaaaaaaacaaaaaaaaaaaaaaaaaaaaaa neg r4.x, r3.x
adaaaaaaaeaaabacaeaaaaaaacaaaaaaadaaaaaaacaaaaaa mul r4.x, r4.x, r3.x
acaaaaaaaaaaabacaeaaaaaaacaaaaaaaaaaaaaaacaaaaaa sub r0.x, r4.x, r0.x
abaaaaaaaaaaabacaaaaaaaaacaaaaaaadaaaaffabaaaaaa add r0.x, r0.x, c3.y
akaaaaaaaaaaabacaaaaaaaaacaaaaaaaaaaaaaaaaaaaaaa rsq r0.x, r0.x
afaaaaaaadaaaeacaaaaaaaaacaaaaaaaaaaaaaaaaaaaaaa rcp r3.z, r0.x
bcaaaaaaaaaaabacadaaaakeacaaaaaaabaaaakeacaaaaaa dp3 r0.x, r3.xyzz, r1.xyzz
ahaaaaaaaaaaabacaaaaaaaaacaaaaaaadaaaaoeabaaaaaa max r0.x, r0.x, c3
adaaaaaaabaaabacabaaaappacaaaaaaaaaaaappacaaaaaa mul r1.x, r1.w, r0.w
adaaaaaaaaaaabacaaaaaaaaacaaaaaaabaaaaaaacaaaaaa mul r0.x, r0.x, r1.x
adaaaaaaaaaaahacaaaaaaaaacaaaaaaacaaaakeacaaaaaa mul r0.xyz, r0.x, r2.xyzz
adaaaaaaaaaaahacaaaaaakeacaaaaaaadaaaakkabaaaaaa mul r0.xyz, r0.xyzz, c3.z
aaaaaaaaaaaaaiacacaaaappacaaaaaaaaaaaaaaaaaaaaaa mov r0.w, r2.w
aaaaaaaaaaaaapadaaaaaaoeacaaaaaaaaaaaaaaaaaaaaaa mov o0, r0
"
}

SubProgram "d3d11_9x " {
Keywords { "POINT_COOKIE" }
ConstBuffer "$Globals" 176 // 164 used size, 8 vars
Vector 16 [_LightColor0] 4
Vector 112 [_Color] 4
Float 160 [_Cutoff]
BindCB "$Globals" 0
SetTexture 0 [_BumpMap] 2D 3
SetTexture 1 [_MainTex] 2D 2
SetTexture 2 [_LightTextureB0] 2D 1
SetTexture 3 [_LightTexture0] CUBE 0
// 24 instructions, 4 temp regs, 0 temp arrays:
// ALU 14 float, 0 int, 0 uint
// TEX 4 (0 load, 0 comp, 0 bias, 0 grad)
// FLOW 1 static, 0 dynamic
"ps_4_0_level_9_3
eefiecedegmmehgbfhgjelbampngibppiopjihdgabaaaaaaneagaaaaaeaaaaaa
daaaaaaafiacaaaaoiafaaaakaagaaaaebgpgodjcaacaaaacaacaaaaaaacpppp
miabaaaafiaaaaaaadaadeaaaaaafiaaaaaafiaaaeaaceaaaaaafiaaadaaaaaa
acababaaabacacaaaaadadaaaaaaabaaabaaaaaaaaaaaaaaaaaaahaaabaaabaa
aaaaaaaaaaaaakaaabaaacaaaaaaaaaaabacppppfbaaaaafadaaapkaaaaaaaea
aaaaialpaaaaiadpaaaaaaaabpaaaaacaaaaaaiaaaaaaplabpaaaaacaaaaaaia
adaachlabpaaaaacaaaaaaiaaeaaahlabpaaaaacaaaaaajiaaaiapkabpaaaaac
aaaaaajaabaiapkabpaaaaacaaaaaajaacaiapkabpaaaaacaaaaaajaadaiapka
ecaaaaadaaaaapiaaaaaoelaacaioekaacaaaaadabaacpiaaaaappiaacaaaakb
abaaaaacacaaadiaaaaaoolaebaaaaababaaapiaecaaaaadabaacpiaacaaoeia
adaioekaaeaaaaaeabaacdiaabaaohiaadaaaakaadaaffkaaeaaaaaeabaaciia
abaaaaiaabaaaaibadaakkkaaeaaaaaeabaaciiaabaaffiaabaaffibabaappia
ahaaaaacabaaciiaabaappiaagaaaaacabaaceiaabaappiaceaaaaacacaachia
adaaoelaaiaaaaadabaacbiaabaaoeiaacaaoeiaalaaaaadacaacbiaabaaaaia
adaappkaaiaaaaadabaaadiaaeaaoelaaeaaoelaecaaaaadadaaapiaaeaaoela
aaaioekaecaaaaadabaaapiaabaaoeiaabaioekaafaaaaadabaacbiaadaappia
abaaaaiafkaaaaaeabaacbiaacaaaaiaabaaaaiaadaappkaafaaaaadabaacoia
aaaajaiaabaappkaafaaaaadabaacoiaabaaoeiaaaaajakaafaaaaadaaaachia
abaaaaiaabaapjiaabaaaaacaaaicpiaaaaaoeiappppaaaafdeieefciiadaaaa
eaaaaaaaocaaaaaafjaaaaaeegiocaaaaaaaaaaaalaaaaaafkaaaaadaagabaaa
aaaaaaaafkaaaaadaagabaaaabaaaaaafkaaaaadaagabaaaacaaaaaafkaaaaad
aagabaaaadaaaaaafibiaaaeaahabaaaaaaaaaaaffffaaaafibiaaaeaahabaaa
abaaaaaaffffaaaafibiaaaeaahabaaaacaaaaaaffffaaaafidaaaaeaahabaaa
adaaaaaaffffaaaagcbaaaadpcbabaaaabaaaaaagcbaaaadhcbabaaaaeaaaaaa
gcbaaaadhcbabaaaafaaaaaagfaaaaadpccabaaaaaaaaaaagiaaaaacaeaaaaaa
efaaaaajpcaabaaaaaaaaaaaegbabaaaabaaaaaaeghobaaaabaaaaaaaagabaaa
acaaaaaaaaaaaaajbcaabaaaabaaaaaadkaabaaaaaaaaaaaakiacaiaebaaaaaa
aaaaaaaaakaaaaaadbaaaaahbcaabaaaabaaaaaaakaabaaaabaaaaaaabeaaaaa
aaaaaaaaanaaaeadakaabaaaabaaaaaabaaaaaahbcaabaaaabaaaaaaegbcbaaa
aeaaaaaaegbcbaaaaeaaaaaaeeaaaaafbcaabaaaabaaaaaaakaabaaaabaaaaaa
diaaaaahhcaabaaaabaaaaaaagaabaaaabaaaaaaegbcbaaaaeaaaaaaefaaaaaj
pcaabaaaacaaaaaaogbkbaaaabaaaaaaeghobaaaaaaaaaaaaagabaaaadaaaaaa
dcaaaaapdcaabaaaacaaaaaahgapbaaaacaaaaaaaceaaaaaaaaaaaeaaaaaaaea
aaaaaaaaaaaaaaaaaceaaaaaaaaaialpaaaaialpaaaaaaaaaaaaaaaadcaaaaak
icaabaaaabaaaaaaakaabaiaebaaaaaaacaaaaaaakaabaaaacaaaaaaabeaaaaa
aaaaiadpdcaaaaakicaabaaaabaaaaaabkaabaiaebaaaaaaacaaaaaabkaabaaa
acaaaaaadkaabaaaabaaaaaaelaaaaafecaabaaaacaaaaaadkaabaaaabaaaaaa
baaaaaahbcaabaaaabaaaaaaegacbaaaacaaaaaaegacbaaaabaaaaaadeaaaaah
bcaabaaaabaaaaaaakaabaaaabaaaaaaabeaaaaaaaaaaaaabaaaaaahccaabaaa
abaaaaaaegbcbaaaafaaaaaaegbcbaaaafaaaaaaefaaaaajpcaabaaaacaaaaaa
fgafbaaaabaaaaaaeghobaaaacaaaaaaaagabaaaabaaaaaaefaaaaajpcaabaaa
adaaaaaaegbcbaaaafaaaaaaeghobaaaadaaaaaaaagabaaaaaaaaaaadiaaaaah
ccaabaaaabaaaaaaakaabaaaacaaaaaadkaabaaaadaaaaaaapaaaaahbcaabaaa
abaaaaaaagaabaaaabaaaaaafgafbaaaabaaaaaadiaaaaaihcaabaaaaaaaaaaa
egacbaaaaaaaaaaapgipcaaaaaaaaaaaahaaaaaadgaaaaaficcabaaaaaaaaaaa
dkaabaaaaaaaaaaadiaaaaaihcaabaaaaaaaaaaaegacbaaaaaaaaaaaegiccaaa
aaaaaaaaabaaaaaadiaaaaahhccabaaaaaaaaaaaagaabaaaabaaaaaaegacbaaa
aaaaaaaadoaaaaabejfdeheolaaaaaaaagaaaaaaaiaaaaaajiaaaaaaaaaaaaaa
abaaaaaaadaaaaaaaaaaaaaaapaaaaaakeaaaaaaaaaaaaaaaaaaaaaaadaaaaaa
abaaaaaaapapaaaakeaaaaaaabaaaaaaaaaaaaaaadaaaaaaacaaaaaaahaaaaaa
keaaaaaaacaaaaaaaaaaaaaaadaaaaaaadaaaaaaahaaaaaakeaaaaaaadaaaaaa
aaaaaaaaadaaaaaaaeaaaaaaahahaaaakeaaaaaaaeaaaaaaaaaaaaaaadaaaaaa
afaaaaaaahahaaaafdfgfpfaepfdejfeejepeoaafeeffiedepepfceeaaklklkl
epfdeheocmaaaaaaabaaaaaaaiaaaaaacaaaaaaaaaaaaaaaaaaaaaaaadaaaaaa
aaaaaaaaapaaaaaafdfgfpfegbhcghgfheaaklkl"
}

SubProgram "opengl " {
Keywords { "DIRECTIONAL_COOKIE" }
Vector 0 [_LightColor0]
Vector 1 [_Color]
Float 2 [_Cutoff]
SetTexture 0 [_BumpMap] 2D
SetTexture 1 [_MainTex] 2D
SetTexture 3 [_LightTexture0] 2D
"!!ARBfp1.0
OPTION ARB_precision_hint_fastest;
# 19 ALU, 3 TEX
PARAM c[4] = { program.local[0..2],
		{ 2, 1, 0 } };
TEMP R0;
TEMP R1;
TEMP R2;
TEX R0, fragment.texcoord[0], texture[1], 2D;
TEX R2.yw, fragment.texcoord[0].zwzw, texture[0], 2D;
TEX R1.w, fragment.texcoord[4], texture[3], 2D;
SLT R1.x, R0.w, c[2];
MUL R0.xyz, R0, c[1].w;
MUL R0.xyz, R0, c[0];
MOV result.color.w, R0;
KIL -R1.x;
MAD R1.xy, R2.wyzw, c[3].x, -c[3].y;
MUL R1.z, R1.y, R1.y;
MAD R1.z, -R1.x, R1.x, -R1;
ADD R1.z, R1, c[3].y;
RSQ R1.z, R1.z;
RCP R1.z, R1.z;
DP3 R1.x, R1, fragment.texcoord[3];
MAX R1.x, R1, c[3].z;
MUL R1.x, R1, R1.w;
MUL R0.xyz, R1.x, R0;
MUL result.color.xyz, R0, c[3].x;
END
# 19 instructions, 3 R-regs
"
}

SubProgram "d3d9 " {
Keywords { "DIRECTIONAL_COOKIE" }
Vector 0 [_LightColor0]
Vector 1 [_Color]
Float 2 [_Cutoff]
SetTexture 0 [_BumpMap] 2D
SetTexture 1 [_MainTex] 2D
SetTexture 3 [_LightTexture0] 2D
"ps_2_0
; 22 ALU, 4 TEX
dcl_2d s0
dcl_2d s1
dcl_2d s3
def c3, 0.00000000, 1.00000000, 2.00000000, -1.00000000
dcl t0
dcl t3.xyz
dcl t4.xy
texld r1, t0, s1
add_pp r0.x, r1.w, -c2
cmp r0.x, r0, c3, c3.y
mov_pp r0, -r0.x
mul r1.xyz, r1, c1.w
mov r2.y, t0.w
mov r2.x, t0.z
mul_pp r1.xyz, r1, c0
texld r2, r2, s0
texkill r0.xyzw
texld r0, t4, s3
mov r0.y, r2
mov r0.x, r2.w
mad_pp r2.xy, r0, c3.z, c3.w
mul_pp r0.x, r2.y, r2.y
mad_pp r0.x, -r2, r2, -r0
add_pp r0.x, r0, c3.y
rsq_pp r0.x, r0.x
rcp_pp r2.z, r0.x
dp3_pp r0.x, r2, t3
max_pp r0.x, r0, c3
mul_pp r0.x, r0, r0.w
mul_pp r0.xyz, r0.x, r1
mul_pp r0.xyz, r0, c3.z
mov_pp r0.w, r1
mov_pp oC0, r0
"
}

SubProgram "d3d11 " {
Keywords { "DIRECTIONAL_COOKIE" }
ConstBuffer "$Globals" 176 // 164 used size, 8 vars
Vector 16 [_LightColor0] 4
Vector 112 [_Color] 4
Float 160 [_Cutoff]
BindCB "$Globals" 0
SetTexture 0 [_BumpMap] 2D 2
SetTexture 1 [_MainTex] 2D 1
SetTexture 2 [_LightTexture0] 2D 0
// 18 instructions, 3 temp regs, 0 temp arrays:
// ALU 9 float, 0 int, 0 uint
// TEX 3 (0 load, 0 comp, 0 bias, 0 grad)
// FLOW 1 static, 0 dynamic
"ps_4_0
eefiecednklfnkoifgbakkdneidpldnmgnboihigabaaaaaaoeadaaaaadaaaaaa
cmaaaaaaoeaaaaaabiabaaaaejfdeheolaaaaaaaagaaaaaaaiaaaaaajiaaaaaa
aaaaaaaaabaaaaaaadaaaaaaaaaaaaaaapaaaaaakeaaaaaaaaaaaaaaaaaaaaaa
adaaaaaaabaaaaaaapapaaaakeaaaaaaabaaaaaaaaaaaaaaadaaaaaaacaaaaaa
ahaaaaaakeaaaaaaacaaaaaaaaaaaaaaadaaaaaaadaaaaaaahaaaaaakeaaaaaa
adaaaaaaaaaaaaaaadaaaaaaaeaaaaaaahahaaaakeaaaaaaaeaaaaaaaaaaaaaa
adaaaaaaafaaaaaaadadaaaafdfgfpfaepfdejfeejepeoaafeeffiedepepfcee
aaklklklepfdeheocmaaaaaaabaaaaaaaiaaaaaacaaaaaaaaaaaaaaaaaaaaaaa
adaaaaaaaaaaaaaaapaaaaaafdfgfpfegbhcghgfheaaklklfdeieefcmeacaaaa
eaaaaaaalbaaaaaafjaaaaaeegiocaaaaaaaaaaaalaaaaaafkaaaaadaagabaaa
aaaaaaaafkaaaaadaagabaaaabaaaaaafkaaaaadaagabaaaacaaaaaafibiaaae
aahabaaaaaaaaaaaffffaaaafibiaaaeaahabaaaabaaaaaaffffaaaafibiaaae
aahabaaaacaaaaaaffffaaaagcbaaaadpcbabaaaabaaaaaagcbaaaadhcbabaaa
aeaaaaaagcbaaaaddcbabaaaafaaaaaagfaaaaadpccabaaaaaaaaaaagiaaaaac
adaaaaaaefaaaaajpcaabaaaaaaaaaaaegbabaaaabaaaaaaeghobaaaabaaaaaa
aagabaaaabaaaaaaaaaaaaajbcaabaaaabaaaaaadkaabaaaaaaaaaaaakiacaia
ebaaaaaaaaaaaaaaakaaaaaadbaaaaahbcaabaaaabaaaaaaakaabaaaabaaaaaa
abeaaaaaaaaaaaaaanaaaeadakaabaaaabaaaaaaefaaaaajpcaabaaaabaaaaaa
ogbkbaaaabaaaaaaeghobaaaaaaaaaaaaagabaaaacaaaaaadcaaaaapdcaabaaa
abaaaaaahgapbaaaabaaaaaaaceaaaaaaaaaaaeaaaaaaaeaaaaaaaaaaaaaaaaa
aceaaaaaaaaaialpaaaaialpaaaaaaaaaaaaaaaadcaaaaakicaabaaaabaaaaaa
akaabaiaebaaaaaaabaaaaaaakaabaaaabaaaaaaabeaaaaaaaaaiadpdcaaaaak
icaabaaaabaaaaaabkaabaiaebaaaaaaabaaaaaabkaabaaaabaaaaaadkaabaaa
abaaaaaaelaaaaafecaabaaaabaaaaaadkaabaaaabaaaaaabaaaaaahbcaabaaa
abaaaaaaegacbaaaabaaaaaaegbcbaaaaeaaaaaadeaaaaahbcaabaaaabaaaaaa
akaabaaaabaaaaaaabeaaaaaaaaaaaaaefaaaaajpcaabaaaacaaaaaaegbabaaa
afaaaaaaeghobaaaacaaaaaaaagabaaaaaaaaaaaapaaaaahbcaabaaaabaaaaaa
agaabaaaabaaaaaapgapbaaaacaaaaaadiaaaaaihcaabaaaaaaaaaaaegacbaaa
aaaaaaaapgipcaaaaaaaaaaaahaaaaaadgaaaaaficcabaaaaaaaaaaadkaabaaa
aaaaaaaadiaaaaaihcaabaaaaaaaaaaaegacbaaaaaaaaaaaegiccaaaaaaaaaaa
abaaaaaadiaaaaahhccabaaaaaaaaaaaagaabaaaabaaaaaaegacbaaaaaaaaaaa
doaaaaab"
}

SubProgram "gles " {
Keywords { "DIRECTIONAL_COOKIE" }
"!!GLES"
}

SubProgram "glesdesktop " {
Keywords { "DIRECTIONAL_COOKIE" }
"!!GLES"
}

SubProgram "flash " {
Keywords { "DIRECTIONAL_COOKIE" }
Vector 0 [_LightColor0]
Vector 1 [_Color]
Float 2 [_Cutoff]
SetTexture 0 [_BumpMap] 2D
SetTexture 1 [_MainTex] 2D
SetTexture 3 [_LightTexture0] 2D
"agal_ps
c3 0.0 1.0 2.0 -1.0
[bc]
ciaaaaaaabaaapacaaaaaaoeaeaaaaaaabaaaaaaafaababb tex r1, v0, s1 <2d wrap linear point>
acaaaaaaaaaaabacabaaaappacaaaaaaacaaaaoeabaaaaaa sub r0.x, r1.w, c2
ckaaaaaaaaaaabacaaaaaaaaacaaaaaaadaaaaaaabaaaaaa slt r0.x, r0.x, c3.x
bfaaaaaaaaaaapacaaaaaaaaacaaaaaaaaaaaaaaaaaaaaaa neg r0, r0.x
adaaaaaaabaaahacabaaaakeacaaaaaaabaaaappabaaaaaa mul r1.xyz, r1.xyzz, c1.w
aaaaaaaaacaaacacaaaaaappaeaaaaaaaaaaaaaaaaaaaaaa mov r2.y, v0.w
aaaaaaaaacaaabacaaaaaakkaeaaaaaaaaaaaaaaaaaaaaaa mov r2.x, v0.z
adaaaaaaabaaahacabaaaakeacaaaaaaaaaaaaoeabaaaaaa mul r1.xyz, r1.xyzz, c0
ciaaaaaaacaaapacacaaaafeacaaaaaaaaaaaaaaafaababb tex r2, r2.xyyy, s0 <2d wrap linear point>
chaaaaaaaaaaaaaaaaaaaaaaacaaaaaaaaaaaaaaaaaaaaaa kil a0.none, r0.x
ciaaaaaaaaaaapacaeaaaaoeaeaaaaaaadaaaaaaafaababb tex r0, v4, s3 <2d wrap linear point>
aaaaaaaaaaaaacacacaaaaffacaaaaaaaaaaaaaaaaaaaaaa mov r0.y, r2.y
aaaaaaaaaaaaabacacaaaappacaaaaaaaaaaaaaaaaaaaaaa mov r0.x, r2.w
adaaaaaaacaaadacaaaaaafeacaaaaaaadaaaakkabaaaaaa mul r2.xy, r0.xyyy, c3.z
abaaaaaaacaaadacacaaaafeacaaaaaaadaaaappabaaaaaa add r2.xy, r2.xyyy, c3.w
adaaaaaaaaaaabacacaaaaffacaaaaaaacaaaaffacaaaaaa mul r0.x, r2.y, r2.y
bfaaaaaaadaaabacacaaaaaaacaaaaaaaaaaaaaaaaaaaaaa neg r3.x, r2.x
adaaaaaaadaaabacadaaaaaaacaaaaaaacaaaaaaacaaaaaa mul r3.x, r3.x, r2.x
acaaaaaaaaaaabacadaaaaaaacaaaaaaaaaaaaaaacaaaaaa sub r0.x, r3.x, r0.x
abaaaaaaaaaaabacaaaaaaaaacaaaaaaadaaaaffabaaaaaa add r0.x, r0.x, c3.y
akaaaaaaaaaaabacaaaaaaaaacaaaaaaaaaaaaaaaaaaaaaa rsq r0.x, r0.x
afaaaaaaacaaaeacaaaaaaaaacaaaaaaaaaaaaaaaaaaaaaa rcp r2.z, r0.x
bcaaaaaaaaaaabacacaaaakeacaaaaaaadaaaaoeaeaaaaaa dp3 r0.x, r2.xyzz, v3
ahaaaaaaaaaaabacaaaaaaaaacaaaaaaadaaaaoeabaaaaaa max r0.x, r0.x, c3
adaaaaaaaaaaabacaaaaaaaaacaaaaaaaaaaaappacaaaaaa mul r0.x, r0.x, r0.w
adaaaaaaaaaaahacaaaaaaaaacaaaaaaabaaaakeacaaaaaa mul r0.xyz, r0.x, r1.xyzz
adaaaaaaaaaaahacaaaaaakeacaaaaaaadaaaakkabaaaaaa mul r0.xyz, r0.xyzz, c3.z
aaaaaaaaaaaaaiacabaaaappacaaaaaaaaaaaaaaaaaaaaaa mov r0.w, r1.w
aaaaaaaaaaaaapadaaaaaaoeacaaaaaaaaaaaaaaaaaaaaaa mov o0, r0
"
}

SubProgram "d3d11_9x " {
Keywords { "DIRECTIONAL_COOKIE" }
ConstBuffer "$Globals" 176 // 164 used size, 8 vars
Vector 16 [_LightColor0] 4
Vector 112 [_Color] 4
Float 160 [_Cutoff]
BindCB "$Globals" 0
SetTexture 0 [_BumpMap] 2D 2
SetTexture 1 [_MainTex] 2D 1
SetTexture 2 [_LightTexture0] 2D 0
// 18 instructions, 3 temp regs, 0 temp arrays:
// ALU 9 float, 0 int, 0 uint
// TEX 3 (0 load, 0 comp, 0 bias, 0 grad)
// FLOW 1 static, 0 dynamic
"ps_4_0_level_9_3
eefiecedehgmifgkmkjhgbfgleplkdimjmnbmpaiabaaaaaaneafaaaaaeaaaaaa
daaaaaaabmacaaaaoiaeaaaakaafaaaaebgpgodjoeabaaaaoeabaaaaaaacpppp
jaabaaaafeaaaaaaadaadaaaaaaafeaaaaaafeaaadaaceaaaaaafeaaacaaaaaa
abababaaaaacacaaaaaaabaaabaaaaaaaaaaaaaaaaaaahaaabaaabaaaaaaaaaa
aaaaakaaabaaacaaaaaaaaaaabacppppfbaaaaafadaaapkaaaaaaaeaaaaaialp
aaaaiadpaaaaaaaabpaaaaacaaaaaaiaaaaaaplabpaaaaacaaaaaaiaadaachla
bpaaaaacaaaaaaiaaeaaadlabpaaaaacaaaaaajaaaaiapkabpaaaaacaaaaaaja
abaiapkabpaaaaacaaaaaajaacaiapkaecaaaaadaaaaapiaaaaaoelaabaioeka
acaaaaadabaacpiaaaaappiaacaaaakbabaaaaacacaaadiaaaaaoolaebaaaaab
abaaapiaecaaaaadabaacpiaacaaoeiaacaioekaaeaaaaaeabaacdiaabaaohia
adaaaakaadaaffkaaeaaaaaeabaaciiaabaaaaiaabaaaaibadaakkkaaeaaaaae
abaaciiaabaaffiaabaaffibabaappiaahaaaaacabaaciiaabaappiaagaaaaac
abaaceiaabaappiaaiaaaaadabaacbiaabaaoeiaadaaoelaecaaaaadacaacpia
aeaaoelaaaaioekaafaaaaadabaacciaabaaaaiaacaappiafiaaaaaeabaacbia
abaaaaiaabaaffiaadaappkaacaaaaadabaacbiaabaaaaiaabaaaaiaafaaaaad
abaacoiaaaaajaiaabaappkaafaaaaadabaacoiaabaaoeiaaaaajakaafaaaaad
aaaachiaabaaaaiaabaapjiaabaaaaacaaaicpiaaaaaoeiappppaaaafdeieefc
meacaaaaeaaaaaaalbaaaaaafjaaaaaeegiocaaaaaaaaaaaalaaaaaafkaaaaad
aagabaaaaaaaaaaafkaaaaadaagabaaaabaaaaaafkaaaaadaagabaaaacaaaaaa
fibiaaaeaahabaaaaaaaaaaaffffaaaafibiaaaeaahabaaaabaaaaaaffffaaaa
fibiaaaeaahabaaaacaaaaaaffffaaaagcbaaaadpcbabaaaabaaaaaagcbaaaad
hcbabaaaaeaaaaaagcbaaaaddcbabaaaafaaaaaagfaaaaadpccabaaaaaaaaaaa
giaaaaacadaaaaaaefaaaaajpcaabaaaaaaaaaaaegbabaaaabaaaaaaeghobaaa
abaaaaaaaagabaaaabaaaaaaaaaaaaajbcaabaaaabaaaaaadkaabaaaaaaaaaaa
akiacaiaebaaaaaaaaaaaaaaakaaaaaadbaaaaahbcaabaaaabaaaaaaakaabaaa
abaaaaaaabeaaaaaaaaaaaaaanaaaeadakaabaaaabaaaaaaefaaaaajpcaabaaa
abaaaaaaogbkbaaaabaaaaaaeghobaaaaaaaaaaaaagabaaaacaaaaaadcaaaaap
dcaabaaaabaaaaaahgapbaaaabaaaaaaaceaaaaaaaaaaaeaaaaaaaeaaaaaaaaa
aaaaaaaaaceaaaaaaaaaialpaaaaialpaaaaaaaaaaaaaaaadcaaaaakicaabaaa
abaaaaaaakaabaiaebaaaaaaabaaaaaaakaabaaaabaaaaaaabeaaaaaaaaaiadp
dcaaaaakicaabaaaabaaaaaabkaabaiaebaaaaaaabaaaaaabkaabaaaabaaaaaa
dkaabaaaabaaaaaaelaaaaafecaabaaaabaaaaaadkaabaaaabaaaaaabaaaaaah
bcaabaaaabaaaaaaegacbaaaabaaaaaaegbcbaaaaeaaaaaadeaaaaahbcaabaaa
abaaaaaaakaabaaaabaaaaaaabeaaaaaaaaaaaaaefaaaaajpcaabaaaacaaaaaa
egbabaaaafaaaaaaeghobaaaacaaaaaaaagabaaaaaaaaaaaapaaaaahbcaabaaa
abaaaaaaagaabaaaabaaaaaapgapbaaaacaaaaaadiaaaaaihcaabaaaaaaaaaaa
egacbaaaaaaaaaaapgipcaaaaaaaaaaaahaaaaaadgaaaaaficcabaaaaaaaaaaa
dkaabaaaaaaaaaaadiaaaaaihcaabaaaaaaaaaaaegacbaaaaaaaaaaaegiccaaa
aaaaaaaaabaaaaaadiaaaaahhccabaaaaaaaaaaaagaabaaaabaaaaaaegacbaaa
aaaaaaaadoaaaaabejfdeheolaaaaaaaagaaaaaaaiaaaaaajiaaaaaaaaaaaaaa
abaaaaaaadaaaaaaaaaaaaaaapaaaaaakeaaaaaaaaaaaaaaaaaaaaaaadaaaaaa
abaaaaaaapapaaaakeaaaaaaabaaaaaaaaaaaaaaadaaaaaaacaaaaaaahaaaaaa
keaaaaaaacaaaaaaaaaaaaaaadaaaaaaadaaaaaaahaaaaaakeaaaaaaadaaaaaa
aaaaaaaaadaaaaaaaeaaaaaaahahaaaakeaaaaaaaeaaaaaaaaaaaaaaadaaaaaa
afaaaaaaadadaaaafdfgfpfaepfdejfeejepeoaafeeffiedepepfceeaaklklkl
epfdeheocmaaaaaaabaaaaaaaiaaaaaacaaaaaaaaaaaaaaaaaaaaaaaadaaaaaa
aaaaaaaaapaaaaaafdfgfpfegbhcghgfheaaklkl"
}

}
	}
	Pass {
		Name "PREPASS"
		Tags { "LightMode" = "PrePassBase" }
		Fog {Mode Off}
Program "vp" {
// Vertex combos: 1
//   opengl - ALU: 28 to 28
//   d3d9 - ALU: 29 to 29
//   d3d11 - ALU: 21 to 21, TEX: 0 to 0, FLOW: 1 to 1
//   d3d11_9x - ALU: 21 to 21, TEX: 0 to 0, FLOW: 1 to 1
SubProgram "opengl " {
Keywords { }
Bind "vertex" Vertex
Bind "tangent" ATTR14
Bind "normal" Normal
Bind "texcoord" TexCoord0
Matrix 9 [_Object2World]
Vector 13 [unity_Scale]
Vector 14 [_MainTex_ST]
Vector 15 [_BumpMap_ST]
"!!ARBvp1.0
# 28 ALU
PARAM c[16] = { program.local[0],
		state.matrix.mvp,
		state.matrix.modelview[0].invtrans,
		program.local[9..15] };
TEMP R0;
TEMP R1;
MOV R0.xyz, vertex.attrib[14];
MUL R1.xyz, vertex.normal.zxyw, R0.yzxw;
MAD R0.xyz, vertex.normal.yzxw, R0.zxyw, -R1;
MUL R1.xyz, R0, vertex.attrib[14].w;
DP3 R0.y, R1, c[9];
DP3 R0.x, vertex.attrib[14], c[9];
DP3 R0.z, vertex.normal, c[9];
MUL result.texcoord[3].xyz, R0, c[13].w;
DP3 R0.y, R1, c[10];
DP3 R0.x, vertex.attrib[14], c[10];
DP3 R0.z, vertex.normal, c[10];
MUL result.texcoord[4].xyz, R0, c[13].w;
DP3 R0.y, R1, c[11];
DP3 R0.x, vertex.attrib[14], c[11];
DP3 R0.z, vertex.normal, c[11];
DP3 result.texcoord[1].y, R1, c[5];
DP3 result.texcoord[2].y, R1, c[6];
MUL result.texcoord[5].xyz, R0, c[13].w;
MAD result.texcoord[0].zw, vertex.texcoord[0].xyxy, c[15].xyxy, c[15];
MAD result.texcoord[0].xy, vertex.texcoord[0], c[14], c[14].zwzw;
DP4 result.position.w, vertex.position, c[4];
DP4 result.position.z, vertex.position, c[3];
DP4 result.position.y, vertex.position, c[2];
DP4 result.position.x, vertex.position, c[1];
DP3 result.texcoord[1].z, vertex.normal, c[5];
DP3 result.texcoord[1].x, vertex.attrib[14], c[5];
DP3 result.texcoord[2].z, vertex.normal, c[6];
DP3 result.texcoord[2].x, vertex.attrib[14], c[6];
END
# 28 instructions, 2 R-regs
"
}

SubProgram "d3d9 " {
Keywords { }
Bind "vertex" Vertex
Bind "tangent" TexCoord2
Bind "normal" Normal
Bind "texcoord" TexCoord0
Matrix 0 [glstate_matrix_mvp]
Matrix 4 [glstate_matrix_invtrans_modelview0]
Matrix 8 [_Object2World]
Vector 12 [unity_Scale]
Vector 13 [_MainTex_ST]
Vector 14 [_BumpMap_ST]
"vs_2_0
; 29 ALU
dcl_position0 v0
dcl_tangent0 v1
dcl_normal0 v2
dcl_texcoord0 v3
mov r0.xyz, v1
mul r1.xyz, v2.zxyw, r0.yzxw
mov r0.xyz, v1
mad r0.xyz, v2.yzxw, r0.zxyw, -r1
mul r1.xyz, r0, v1.w
dp3 r0.y, r1, c8
dp3 r0.x, v1, c8
dp3 r0.z, v2, c8
mul oT3.xyz, r0, c12.w
dp3 r0.y, r1, c9
dp3 r0.x, v1, c9
dp3 r0.z, v2, c9
mul oT4.xyz, r0, c12.w
dp3 r0.y, r1, c10
dp3 r0.x, v1, c10
dp3 r0.z, v2, c10
dp3 oT1.y, r1, c4
dp3 oT2.y, r1, c5
mul oT5.xyz, r0, c12.w
mad oT0.zw, v3.xyxy, c14.xyxy, c14
mad oT0.xy, v3, c13, c13.zwzw
dp4 oPos.w, v0, c3
dp4 oPos.z, v0, c2
dp4 oPos.y, v0, c1
dp4 oPos.x, v0, c0
dp3 oT1.z, v2, c4
dp3 oT1.x, v1, c4
dp3 oT2.z, v2, c5
dp3 oT2.x, v1, c5
"
}

SubProgram "d3d11 " {
Keywords { }
Bind "vertex" Vertex
Bind "tangent" TexCoord2
Bind "normal" Normal
Bind "texcoord" TexCoord0
Bind "color" Color
ConstBuffer "$Globals" 112 // 96 used size, 7 vars
Vector 64 [_MainTex_ST] 4
Vector 80 [_BumpMap_ST] 4
ConstBuffer "UnityPerDraw" 336 // 336 used size, 6 vars
Matrix 0 [glstate_matrix_mvp] 4
Matrix 128 [glstate_matrix_invtrans_modelview0] 4
Matrix 192 [_Object2World] 4
Vector 320 [unity_Scale] 4
BindCB "$Globals" 0
BindCB "UnityPerDraw" 1
// 43 instructions, 3 temp regs, 0 temp arrays:
// ALU 21 float, 0 int, 0 uint
// TEX 0 (0 load, 0 comp, 0 bias, 0 grad)
// FLOW 1 static, 0 dynamic
"vs_4_0
eefiecedafljjodmlgkmmgjecaggpbfehkghepioabaaaaaaeeahaaaaadaaaaaa
cmaaaaaapeaaaaaameabaaaaejfdeheomaaaaaaaagaaaaaaaiaaaaaajiaaaaaa
aaaaaaaaaaaaaaaaadaaaaaaaaaaaaaaapapaaaakbaaaaaaaaaaaaaaaaaaaaaa
adaaaaaaabaaaaaaapapaaaakjaaaaaaaaaaaaaaaaaaaaaaadaaaaaaacaaaaaa
ahahaaaalaaaaaaaaaaaaaaaaaaaaaaaadaaaaaaadaaaaaaapadaaaalaaaaaaa
abaaaaaaaaaaaaaaadaaaaaaaeaaaaaaapaaaaaaljaaaaaaaaaaaaaaaaaaaaaa
adaaaaaaafaaaaaaapaaaaaafaepfdejfeejepeoaafeebeoehefeofeaaeoepfc
enebemaafeeffiedepepfceeaaedepemepfcaaklepfdeheomiaaaaaaahaaaaaa
aiaaaaaalaaaaaaaaaaaaaaaabaaaaaaadaaaaaaaaaaaaaaapaaaaaalmaaaaaa
aaaaaaaaaaaaaaaaadaaaaaaabaaaaaaapaaaaaalmaaaaaaabaaaaaaaaaaaaaa
adaaaaaaacaaaaaaahaiaaaalmaaaaaaacaaaaaaaaaaaaaaadaaaaaaadaaaaaa
ahaiaaaalmaaaaaaadaaaaaaaaaaaaaaadaaaaaaaeaaaaaaahaiaaaalmaaaaaa
aeaaaaaaaaaaaaaaadaaaaaaafaaaaaaahaiaaaalmaaaaaaafaaaaaaaaaaaaaa
adaaaaaaagaaaaaaahaiaaaafdfgfpfaepfdejfeejepeoaafeeffiedepepfcee
aaklklklfdeieefchiafaaaaeaaaabaafoabaaaafjaaaaaeegiocaaaaaaaaaaa
agaaaaaafjaaaaaeegiocaaaabaaaaaabfaaaaaafpaaaaadpcbabaaaaaaaaaaa
fpaaaaadpcbabaaaabaaaaaafpaaaaadhcbabaaaacaaaaaafpaaaaaddcbabaaa
adaaaaaaghaaaaaepccabaaaaaaaaaaaabaaaaaagfaaaaadpccabaaaabaaaaaa
gfaaaaadhccabaaaacaaaaaagfaaaaadhccabaaaadaaaaaagfaaaaadhccabaaa
aeaaaaaagfaaaaadhccabaaaafaaaaaagfaaaaadhccabaaaagaaaaaagiaaaaac
adaaaaaadiaaaaaipcaabaaaaaaaaaaafgbfbaaaaaaaaaaaegiocaaaabaaaaaa
abaaaaaadcaaaaakpcaabaaaaaaaaaaaegiocaaaabaaaaaaaaaaaaaaagbabaaa
aaaaaaaaegaobaaaaaaaaaaadcaaaaakpcaabaaaaaaaaaaaegiocaaaabaaaaaa
acaaaaaakgbkbaaaaaaaaaaaegaobaaaaaaaaaaadcaaaaakpccabaaaaaaaaaaa
egiocaaaabaaaaaaadaaaaaapgbpbaaaaaaaaaaaegaobaaaaaaaaaaadcaaaaal
dccabaaaabaaaaaaegbabaaaadaaaaaaegiacaaaaaaaaaaaaeaaaaaaogikcaaa
aaaaaaaaaeaaaaaadcaaaaalmccabaaaabaaaaaaagbebaaaadaaaaaaagiecaaa
aaaaaaaaafaaaaaakgiocaaaaaaaaaaaafaaaaaadiaaaaahhcaabaaaaaaaaaaa
jgbebaaaabaaaaaacgbjbaaaacaaaaaadcaaaaakhcaabaaaaaaaaaaajgbebaaa
acaaaaaacgbjbaaaabaaaaaaegacbaiaebaaaaaaaaaaaaaadiaaaaahhcaabaaa
aaaaaaaaegacbaaaaaaaaaaapgbpbaaaabaaaaaadgaaaaagbcaabaaaabaaaaaa
akiacaaaabaaaaaaaiaaaaaadgaaaaagccaabaaaabaaaaaaakiacaaaabaaaaaa
ajaaaaaadgaaaaagecaabaaaabaaaaaaakiacaaaabaaaaaaakaaaaaabaaaaaah
cccabaaaacaaaaaaegacbaaaaaaaaaaaegacbaaaabaaaaaabaaaaaahbccabaaa
acaaaaaaegbcbaaaabaaaaaaegacbaaaabaaaaaabaaaaaaheccabaaaacaaaaaa
egbcbaaaacaaaaaaegacbaaaabaaaaaadgaaaaagbcaabaaaabaaaaaabkiacaaa
abaaaaaaaiaaaaaadgaaaaagccaabaaaabaaaaaabkiacaaaabaaaaaaajaaaaaa
dgaaaaagecaabaaaabaaaaaabkiacaaaabaaaaaaakaaaaaabaaaaaahcccabaaa
adaaaaaaegacbaaaaaaaaaaaegacbaaaabaaaaaabaaaaaahbccabaaaadaaaaaa
egbcbaaaabaaaaaaegacbaaaabaaaaaabaaaaaaheccabaaaadaaaaaaegbcbaaa
acaaaaaaegacbaaaabaaaaaadgaaaaagbcaabaaaabaaaaaaakiacaaaabaaaaaa
amaaaaaadgaaaaagccaabaaaabaaaaaaakiacaaaabaaaaaaanaaaaaadgaaaaag
ecaabaaaabaaaaaaakiacaaaabaaaaaaaoaaaaaabaaaaaahccaabaaaacaaaaaa
egacbaaaaaaaaaaaegacbaaaabaaaaaabaaaaaahbcaabaaaacaaaaaaegbcbaaa
abaaaaaaegacbaaaabaaaaaabaaaaaahecaabaaaacaaaaaaegbcbaaaacaaaaaa
egacbaaaabaaaaaadiaaaaaihccabaaaaeaaaaaaegacbaaaacaaaaaapgipcaaa
abaaaaaabeaaaaaadgaaaaagbcaabaaaabaaaaaabkiacaaaabaaaaaaamaaaaaa
dgaaaaagccaabaaaabaaaaaabkiacaaaabaaaaaaanaaaaaadgaaaaagecaabaaa
abaaaaaabkiacaaaabaaaaaaaoaaaaaabaaaaaahccaabaaaacaaaaaaegacbaaa
aaaaaaaaegacbaaaabaaaaaabaaaaaahbcaabaaaacaaaaaaegbcbaaaabaaaaaa
egacbaaaabaaaaaabaaaaaahecaabaaaacaaaaaaegbcbaaaacaaaaaaegacbaaa
abaaaaaadiaaaaaihccabaaaafaaaaaaegacbaaaacaaaaaapgipcaaaabaaaaaa
beaaaaaadgaaaaagbcaabaaaabaaaaaackiacaaaabaaaaaaamaaaaaadgaaaaag
ccaabaaaabaaaaaackiacaaaabaaaaaaanaaaaaadgaaaaagecaabaaaabaaaaaa
ckiacaaaabaaaaaaaoaaaaaabaaaaaahccaabaaaaaaaaaaaegacbaaaaaaaaaaa
egacbaaaabaaaaaabaaaaaahbcaabaaaaaaaaaaaegbcbaaaabaaaaaaegacbaaa
abaaaaaabaaaaaahecaabaaaaaaaaaaaegbcbaaaacaaaaaaegacbaaaabaaaaaa
diaaaaaihccabaaaagaaaaaaegacbaaaaaaaaaaapgipcaaaabaaaaaabeaaaaaa
doaaaaab"
}

SubProgram "gles " {
Keywords { }
"!!GLES
#define SHADER_API_GLES 1
#define tex2D texture2D


#ifdef VERTEX
#define gl_ModelViewProjectionMatrix glstate_matrix_mvp
uniform mat4 glstate_matrix_mvp;
#define gl_ModelViewMatrixInverseTranspose glstate_matrix_invtrans_modelview0
uniform mat4 glstate_matrix_invtrans_modelview0;
#define gl_ModelViewMatrix glstate_matrix_modelview0
uniform mat4 glstate_matrix_modelview0;

varying highp vec3 xlv_TEXCOORD5;
varying highp vec3 xlv_TEXCOORD4;
varying highp vec3 xlv_TEXCOORD3;
varying highp vec3 xlv_TEXCOORD2;
varying highp vec3 xlv_TEXCOORD1;
varying highp vec4 xlv_TEXCOORD0;
uniform highp vec4 _BumpMap_ST;
uniform highp vec4 _MainTex_ST;
uniform highp vec4 unity_Scale;
uniform highp mat4 _Object2World;


attribute vec4 _glesTANGENT;
attribute vec4 _glesMultiTexCoord0;
attribute vec3 _glesNormal;
attribute vec4 _glesVertex;
void main ()
{
  vec4 tmpvar_1;
  tmpvar_1.xyz = normalize(_glesTANGENT.xyz);
  tmpvar_1.w = _glesTANGENT.w;
  vec3 tmpvar_2;
  tmpvar_2 = normalize(_glesNormal);
  highp vec4 tmpvar_3;
  highp vec3 tmpvar_4;
  highp vec3 tmpvar_5;
  tmpvar_4 = tmpvar_1.xyz;
  tmpvar_5 = (((tmpvar_2.yzx * tmpvar_1.zxy) - (tmpvar_2.zxy * tmpvar_1.yzx)) * _glesTANGENT.w);
  highp mat3 tmpvar_6;
  tmpvar_6[0].x = tmpvar_4.x;
  tmpvar_6[0].y = tmpvar_5.x;
  tmpvar_6[0].z = tmpvar_2.x;
  tmpvar_6[1].x = tmpvar_4.y;
  tmpvar_6[1].y = tmpvar_5.y;
  tmpvar_6[1].z = tmpvar_2.y;
  tmpvar_6[2].x = tmpvar_4.z;
  tmpvar_6[2].y = tmpvar_5.z;
  tmpvar_6[2].z = tmpvar_2.z;
  vec4 v_7;
  v_7.x = gl_ModelViewMatrixInverseTranspose[0].x;
  v_7.y = gl_ModelViewMatrixInverseTranspose[1].x;
  v_7.z = gl_ModelViewMatrixInverseTranspose[2].x;
  v_7.w = gl_ModelViewMatrixInverseTranspose[3].x;
  vec4 v_8;
  v_8.x = gl_ModelViewMatrixInverseTranspose[0].y;
  v_8.y = gl_ModelViewMatrixInverseTranspose[1].y;
  v_8.z = gl_ModelViewMatrixInverseTranspose[2].y;
  v_8.w = gl_ModelViewMatrixInverseTranspose[3].y;
  tmpvar_3.xy = ((_glesMultiTexCoord0.xy * _MainTex_ST.xy) + _MainTex_ST.zw);
  tmpvar_3.zw = ((_glesMultiTexCoord0.xy * _BumpMap_ST.xy) + _BumpMap_ST.zw);
  highp vec3 tmpvar_9;
  highp vec3 tmpvar_10;
  tmpvar_9 = tmpvar_1.xyz;
  tmpvar_10 = (((tmpvar_2.yzx * tmpvar_1.zxy) - (tmpvar_2.zxy * tmpvar_1.yzx)) * _glesTANGENT.w);
  highp mat3 tmpvar_11;
  tmpvar_11[0].x = tmpvar_9.x;
  tmpvar_11[0].y = tmpvar_10.x;
  tmpvar_11[0].z = tmpvar_2.x;
  tmpvar_11[1].x = tmpvar_9.y;
  tmpvar_11[1].y = tmpvar_10.y;
  tmpvar_11[1].z = tmpvar_2.y;
  tmpvar_11[2].x = tmpvar_9.z;
  tmpvar_11[2].y = tmpvar_10.z;
  tmpvar_11[2].z = tmpvar_2.z;
  vec3 v_12;
  v_12.x = _Object2World[0].x;
  v_12.y = _Object2World[1].x;
  v_12.z = _Object2World[2].x;
  vec3 v_13;
  v_13.x = _Object2World[0].y;
  v_13.y = _Object2World[1].y;
  v_13.z = _Object2World[2].y;
  vec3 v_14;
  v_14.x = _Object2World[0].z;
  v_14.y = _Object2World[1].z;
  v_14.z = _Object2World[2].z;
  gl_Position = (gl_ModelViewProjectionMatrix * _glesVertex);
  xlv_TEXCOORD0 = tmpvar_3;
  xlv_TEXCOORD1 = (tmpvar_6 * v_7.xyz);
  xlv_TEXCOORD2 = (tmpvar_6 * v_8.xyz);
  xlv_TEXCOORD3 = ((tmpvar_11 * v_12) * unity_Scale.w);
  xlv_TEXCOORD4 = ((tmpvar_11 * v_13) * unity_Scale.w);
  xlv_TEXCOORD5 = ((tmpvar_11 * v_14) * unity_Scale.w);
}



#endif
#ifdef FRAGMENT

varying highp vec3 xlv_TEXCOORD5;
varying highp vec3 xlv_TEXCOORD4;
varying highp vec3 xlv_TEXCOORD3;
varying highp vec4 xlv_TEXCOORD0;
uniform lowp float _Cutoff;
uniform sampler2D _BumpMap;
uniform sampler2D _MainTex;
void main ()
{
  lowp vec4 res_1;
  lowp vec3 worldN_2;
  lowp vec3 tmpvar_3;
  tmpvar_3 = ((texture2D (_BumpMap, xlv_TEXCOORD0.zw).xyz * 2.0) - 1.0);
  lowp float x_4;
  x_4 = (texture2D (_MainTex, xlv_TEXCOORD0.xy).w - _Cutoff);
  if ((x_4 < 0.0)) {
    discard;
  };
  highp float tmpvar_5;
  tmpvar_5 = dot (xlv_TEXCOORD3, tmpvar_3);
  worldN_2.x = tmpvar_5;
  highp float tmpvar_6;
  tmpvar_6 = dot (xlv_TEXCOORD4, tmpvar_3);
  worldN_2.y = tmpvar_6;
  highp float tmpvar_7;
  tmpvar_7 = dot (xlv_TEXCOORD5, tmpvar_3);
  worldN_2.z = tmpvar_7;
  res_1.xyz = ((worldN_2 * 0.5) + 0.5);
  res_1.w = 0.0;
  gl_FragData[0] = res_1;
}



#endif"
}

SubProgram "glesdesktop " {
Keywords { }
"!!GLES
#define SHADER_API_GLES 1
#define tex2D texture2D


#ifdef VERTEX
#define gl_ModelViewProjectionMatrix glstate_matrix_mvp
uniform mat4 glstate_matrix_mvp;
#define gl_ModelViewMatrixInverseTranspose glstate_matrix_invtrans_modelview0
uniform mat4 glstate_matrix_invtrans_modelview0;
#define gl_ModelViewMatrix glstate_matrix_modelview0
uniform mat4 glstate_matrix_modelview0;

varying highp vec3 xlv_TEXCOORD5;
varying highp vec3 xlv_TEXCOORD4;
varying highp vec3 xlv_TEXCOORD3;
varying highp vec3 xlv_TEXCOORD2;
varying highp vec3 xlv_TEXCOORD1;
varying highp vec4 xlv_TEXCOORD0;
uniform highp vec4 _BumpMap_ST;
uniform highp vec4 _MainTex_ST;
uniform highp vec4 unity_Scale;
uniform highp mat4 _Object2World;


attribute vec4 _glesTANGENT;
attribute vec4 _glesMultiTexCoord0;
attribute vec3 _glesNormal;
attribute vec4 _glesVertex;
void main ()
{
  vec4 tmpvar_1;
  tmpvar_1.xyz = normalize(_glesTANGENT.xyz);
  tmpvar_1.w = _glesTANGENT.w;
  vec3 tmpvar_2;
  tmpvar_2 = normalize(_glesNormal);
  highp vec4 tmpvar_3;
  highp vec3 tmpvar_4;
  highp vec3 tmpvar_5;
  tmpvar_4 = tmpvar_1.xyz;
  tmpvar_5 = (((tmpvar_2.yzx * tmpvar_1.zxy) - (tmpvar_2.zxy * tmpvar_1.yzx)) * _glesTANGENT.w);
  highp mat3 tmpvar_6;
  tmpvar_6[0].x = tmpvar_4.x;
  tmpvar_6[0].y = tmpvar_5.x;
  tmpvar_6[0].z = tmpvar_2.x;
  tmpvar_6[1].x = tmpvar_4.y;
  tmpvar_6[1].y = tmpvar_5.y;
  tmpvar_6[1].z = tmpvar_2.y;
  tmpvar_6[2].x = tmpvar_4.z;
  tmpvar_6[2].y = tmpvar_5.z;
  tmpvar_6[2].z = tmpvar_2.z;
  vec4 v_7;
  v_7.x = gl_ModelViewMatrixInverseTranspose[0].x;
  v_7.y = gl_ModelViewMatrixInverseTranspose[1].x;
  v_7.z = gl_ModelViewMatrixInverseTranspose[2].x;
  v_7.w = gl_ModelViewMatrixInverseTranspose[3].x;
  vec4 v_8;
  v_8.x = gl_ModelViewMatrixInverseTranspose[0].y;
  v_8.y = gl_ModelViewMatrixInverseTranspose[1].y;
  v_8.z = gl_ModelViewMatrixInverseTranspose[2].y;
  v_8.w = gl_ModelViewMatrixInverseTranspose[3].y;
  tmpvar_3.xy = ((_glesMultiTexCoord0.xy * _MainTex_ST.xy) + _MainTex_ST.zw);
  tmpvar_3.zw = ((_glesMultiTexCoord0.xy * _BumpMap_ST.xy) + _BumpMap_ST.zw);
  highp vec3 tmpvar_9;
  highp vec3 tmpvar_10;
  tmpvar_9 = tmpvar_1.xyz;
  tmpvar_10 = (((tmpvar_2.yzx * tmpvar_1.zxy) - (tmpvar_2.zxy * tmpvar_1.yzx)) * _glesTANGENT.w);
  highp mat3 tmpvar_11;
  tmpvar_11[0].x = tmpvar_9.x;
  tmpvar_11[0].y = tmpvar_10.x;
  tmpvar_11[0].z = tmpvar_2.x;
  tmpvar_11[1].x = tmpvar_9.y;
  tmpvar_11[1].y = tmpvar_10.y;
  tmpvar_11[1].z = tmpvar_2.y;
  tmpvar_11[2].x = tmpvar_9.z;
  tmpvar_11[2].y = tmpvar_10.z;
  tmpvar_11[2].z = tmpvar_2.z;
  vec3 v_12;
  v_12.x = _Object2World[0].x;
  v_12.y = _Object2World[1].x;
  v_12.z = _Object2World[2].x;
  vec3 v_13;
  v_13.x = _Object2World[0].y;
  v_13.y = _Object2World[1].y;
  v_13.z = _Object2World[2].y;
  vec3 v_14;
  v_14.x = _Object2World[0].z;
  v_14.y = _Object2World[1].z;
  v_14.z = _Object2World[2].z;
  gl_Position = (gl_ModelViewProjectionMatrix * _glesVertex);
  xlv_TEXCOORD0 = tmpvar_3;
  xlv_TEXCOORD1 = (tmpvar_6 * v_7.xyz);
  xlv_TEXCOORD2 = (tmpvar_6 * v_8.xyz);
  xlv_TEXCOORD3 = ((tmpvar_11 * v_12) * unity_Scale.w);
  xlv_TEXCOORD4 = ((tmpvar_11 * v_13) * unity_Scale.w);
  xlv_TEXCOORD5 = ((tmpvar_11 * v_14) * unity_Scale.w);
}



#endif
#ifdef FRAGMENT

varying highp vec3 xlv_TEXCOORD5;
varying highp vec3 xlv_TEXCOORD4;
varying highp vec3 xlv_TEXCOORD3;
varying highp vec4 xlv_TEXCOORD0;
uniform lowp float _Cutoff;
uniform sampler2D _BumpMap;
uniform sampler2D _MainTex;
void main ()
{
  lowp vec4 res_1;
  lowp vec3 worldN_2;
  lowp vec3 normal_3;
  normal_3.xy = ((texture2D (_BumpMap, xlv_TEXCOORD0.zw).wy * 2.0) - 1.0);
  normal_3.z = sqrt(((1.0 - (normal_3.x * normal_3.x)) - (normal_3.y * normal_3.y)));
  lowp float x_4;
  x_4 = (texture2D (_MainTex, xlv_TEXCOORD0.xy).w - _Cutoff);
  if ((x_4 < 0.0)) {
    discard;
  };
  highp float tmpvar_5;
  tmpvar_5 = dot (xlv_TEXCOORD3, normal_3);
  worldN_2.x = tmpvar_5;
  highp float tmpvar_6;
  tmpvar_6 = dot (xlv_TEXCOORD4, normal_3);
  worldN_2.y = tmpvar_6;
  highp float tmpvar_7;
  tmpvar_7 = dot (xlv_TEXCOORD5, normal_3);
  worldN_2.z = tmpvar_7;
  res_1.xyz = ((worldN_2 * 0.5) + 0.5);
  res_1.w = 0.0;
  gl_FragData[0] = res_1;
}



#endif"
}

SubProgram "d3d11_9x " {
Keywords { }
Bind "vertex" Vertex
Bind "tangent" TexCoord2
Bind "normal" Normal
Bind "texcoord" TexCoord0
Bind "color" Color
ConstBuffer "$Globals" 112 // 96 used size, 7 vars
Vector 64 [_MainTex_ST] 4
Vector 80 [_BumpMap_ST] 4
ConstBuffer "UnityPerDraw" 336 // 336 used size, 6 vars
Matrix 0 [glstate_matrix_mvp] 4
Matrix 128 [glstate_matrix_invtrans_modelview0] 4
Matrix 192 [_Object2World] 4
Vector 320 [unity_Scale] 4
BindCB "$Globals" 0
BindCB "UnityPerDraw" 1
// 43 instructions, 3 temp regs, 0 temp arrays:
// ALU 21 float, 0 int, 0 uint
// TEX 0 (0 load, 0 comp, 0 bias, 0 grad)
// FLOW 1 static, 0 dynamic
"vs_4_0_level_9_3
eefiecednmfhkihaolfjemopldhemjdblocgbcplabaaaaaajeakaaaaaeaaaaaa
daaaaaaahmadaaaapmaiaaaameajaaaaebgpgodjeeadaaaaeeadaaaaaaacpopp
oaacaaaageaaaaaaafaaceaaaaaagaaaaaaagaaaaaaaceaaabaagaaaaaaaaeaa
acaaabaaaaaaaaaaabaaaaaaaeaaadaaaaaaaaaaabaaaiaaadaaahaaaaaaaaaa
abaaamaaadaaakaaaaaaaaaaabaabeaaabaaanaaaaaaaaaaaaaaaaaaabacpopp
bpaaaaacafaaaaiaaaaaapjabpaaaaacafaaabiaabaaapjabpaaaaacafaaacia
acaaapjabpaaaaacafaaadiaadaaapjaabaaaaacaaaaabiaahaaaakaabaaaaac
aaaaaciaaiaaaakaabaaaaacaaaaaeiaajaaaakaaiaaaaadabaaaboaabaaoeja
aaaaoeiaabaaaaacabaaahiaabaaoejaafaaaaadacaaahiaabaamjiaacaancja
aeaaaaaeabaaahiaacaamjjaabaanciaacaaoeibafaaaaadabaaahiaabaaoeia
abaappjaaiaaaaadabaaacoaabaaoeiaaaaaoeiaaiaaaaadabaaaeoaacaaoeja
aaaaoeiaabaaaaacaaaaabiaahaaffkaabaaaaacaaaaaciaaiaaffkaabaaaaac
aaaaaeiaajaaffkaaiaaaaadacaaaboaabaaoejaaaaaoeiaaiaaaaadacaaacoa
abaaoeiaaaaaoeiaaiaaaaadacaaaeoaacaaoejaaaaaoeiaaeaaaaaeaaaaadoa
adaaoejaabaaoekaabaaookaaeaaaaaeaaaaamoaadaaeejaacaaeekaacaaoeka
abaaaaacaaaaabiaakaaaakaabaaaaacaaaaaciaalaaaakaabaaaaacaaaaaeia
amaaaakaaiaaaaadacaaaciaabaaoeiaaaaaoeiaaiaaaaadacaaabiaabaaoeja
aaaaoeiaaiaaaaadacaaaeiaacaaoejaaaaaoeiaafaaaaadadaaahoaacaaoeia
anaappkaabaaaaacaaaaabiaakaaffkaabaaaaacaaaaaciaalaaffkaabaaaaac
aaaaaeiaamaaffkaaiaaaaadacaaaciaabaaoeiaaaaaoeiaaiaaaaadacaaabia
abaaoejaaaaaoeiaaiaaaaadacaaaeiaacaaoejaaaaaoeiaafaaaaadaeaaahoa
acaaoeiaanaappkaabaaaaacaaaaabiaakaakkkaabaaaaacaaaaaciaalaakkka
abaaaaacaaaaaeiaamaakkkaaiaaaaadabaaaciaabaaoeiaaaaaoeiaaiaaaaad
abaaabiaabaaoejaaaaaoeiaaiaaaaadabaaaeiaacaaoejaaaaaoeiaafaaaaad
afaaahoaabaaoeiaanaappkaafaaaaadaaaaapiaaaaaffjaaeaaoekaaeaaaaae
aaaaapiaadaaoekaaaaaaajaaaaaoeiaaeaaaaaeaaaaapiaafaaoekaaaaakkja
aaaaoeiaaeaaaaaeaaaaapiaagaaoekaaaaappjaaaaaoeiaaeaaaaaeaaaaadma
aaaappiaaaaaoekaaaaaoeiaabaaaaacaaaaammaaaaaoeiappppaaaafdeieefc
hiafaaaaeaaaabaafoabaaaafjaaaaaeegiocaaaaaaaaaaaagaaaaaafjaaaaae
egiocaaaabaaaaaabfaaaaaafpaaaaadpcbabaaaaaaaaaaafpaaaaadpcbabaaa
abaaaaaafpaaaaadhcbabaaaacaaaaaafpaaaaaddcbabaaaadaaaaaaghaaaaae
pccabaaaaaaaaaaaabaaaaaagfaaaaadpccabaaaabaaaaaagfaaaaadhccabaaa
acaaaaaagfaaaaadhccabaaaadaaaaaagfaaaaadhccabaaaaeaaaaaagfaaaaad
hccabaaaafaaaaaagfaaaaadhccabaaaagaaaaaagiaaaaacadaaaaaadiaaaaai
pcaabaaaaaaaaaaafgbfbaaaaaaaaaaaegiocaaaabaaaaaaabaaaaaadcaaaaak
pcaabaaaaaaaaaaaegiocaaaabaaaaaaaaaaaaaaagbabaaaaaaaaaaaegaobaaa
aaaaaaaadcaaaaakpcaabaaaaaaaaaaaegiocaaaabaaaaaaacaaaaaakgbkbaaa
aaaaaaaaegaobaaaaaaaaaaadcaaaaakpccabaaaaaaaaaaaegiocaaaabaaaaaa
adaaaaaapgbpbaaaaaaaaaaaegaobaaaaaaaaaaadcaaaaaldccabaaaabaaaaaa
egbabaaaadaaaaaaegiacaaaaaaaaaaaaeaaaaaaogikcaaaaaaaaaaaaeaaaaaa
dcaaaaalmccabaaaabaaaaaaagbebaaaadaaaaaaagiecaaaaaaaaaaaafaaaaaa
kgiocaaaaaaaaaaaafaaaaaadiaaaaahhcaabaaaaaaaaaaajgbebaaaabaaaaaa
cgbjbaaaacaaaaaadcaaaaakhcaabaaaaaaaaaaajgbebaaaacaaaaaacgbjbaaa
abaaaaaaegacbaiaebaaaaaaaaaaaaaadiaaaaahhcaabaaaaaaaaaaaegacbaaa
aaaaaaaapgbpbaaaabaaaaaadgaaaaagbcaabaaaabaaaaaaakiacaaaabaaaaaa
aiaaaaaadgaaaaagccaabaaaabaaaaaaakiacaaaabaaaaaaajaaaaaadgaaaaag
ecaabaaaabaaaaaaakiacaaaabaaaaaaakaaaaaabaaaaaahcccabaaaacaaaaaa
egacbaaaaaaaaaaaegacbaaaabaaaaaabaaaaaahbccabaaaacaaaaaaegbcbaaa
abaaaaaaegacbaaaabaaaaaabaaaaaaheccabaaaacaaaaaaegbcbaaaacaaaaaa
egacbaaaabaaaaaadgaaaaagbcaabaaaabaaaaaabkiacaaaabaaaaaaaiaaaaaa
dgaaaaagccaabaaaabaaaaaabkiacaaaabaaaaaaajaaaaaadgaaaaagecaabaaa
abaaaaaabkiacaaaabaaaaaaakaaaaaabaaaaaahcccabaaaadaaaaaaegacbaaa
aaaaaaaaegacbaaaabaaaaaabaaaaaahbccabaaaadaaaaaaegbcbaaaabaaaaaa
egacbaaaabaaaaaabaaaaaaheccabaaaadaaaaaaegbcbaaaacaaaaaaegacbaaa
abaaaaaadgaaaaagbcaabaaaabaaaaaaakiacaaaabaaaaaaamaaaaaadgaaaaag
ccaabaaaabaaaaaaakiacaaaabaaaaaaanaaaaaadgaaaaagecaabaaaabaaaaaa
akiacaaaabaaaaaaaoaaaaaabaaaaaahccaabaaaacaaaaaaegacbaaaaaaaaaaa
egacbaaaabaaaaaabaaaaaahbcaabaaaacaaaaaaegbcbaaaabaaaaaaegacbaaa
abaaaaaabaaaaaahecaabaaaacaaaaaaegbcbaaaacaaaaaaegacbaaaabaaaaaa
diaaaaaihccabaaaaeaaaaaaegacbaaaacaaaaaapgipcaaaabaaaaaabeaaaaaa
dgaaaaagbcaabaaaabaaaaaabkiacaaaabaaaaaaamaaaaaadgaaaaagccaabaaa
abaaaaaabkiacaaaabaaaaaaanaaaaaadgaaaaagecaabaaaabaaaaaabkiacaaa
abaaaaaaaoaaaaaabaaaaaahccaabaaaacaaaaaaegacbaaaaaaaaaaaegacbaaa
abaaaaaabaaaaaahbcaabaaaacaaaaaaegbcbaaaabaaaaaaegacbaaaabaaaaaa
baaaaaahecaabaaaacaaaaaaegbcbaaaacaaaaaaegacbaaaabaaaaaadiaaaaai
hccabaaaafaaaaaaegacbaaaacaaaaaapgipcaaaabaaaaaabeaaaaaadgaaaaag
bcaabaaaabaaaaaackiacaaaabaaaaaaamaaaaaadgaaaaagccaabaaaabaaaaaa
ckiacaaaabaaaaaaanaaaaaadgaaaaagecaabaaaabaaaaaackiacaaaabaaaaaa
aoaaaaaabaaaaaahccaabaaaaaaaaaaaegacbaaaaaaaaaaaegacbaaaabaaaaaa
baaaaaahbcaabaaaaaaaaaaaegbcbaaaabaaaaaaegacbaaaabaaaaaabaaaaaah
ecaabaaaaaaaaaaaegbcbaaaacaaaaaaegacbaaaabaaaaaadiaaaaaihccabaaa
agaaaaaaegacbaaaaaaaaaaapgipcaaaabaaaaaabeaaaaaadoaaaaabejfdeheo
maaaaaaaagaaaaaaaiaaaaaajiaaaaaaaaaaaaaaaaaaaaaaadaaaaaaaaaaaaaa
apapaaaakbaaaaaaaaaaaaaaaaaaaaaaadaaaaaaabaaaaaaapapaaaakjaaaaaa
aaaaaaaaaaaaaaaaadaaaaaaacaaaaaaahahaaaalaaaaaaaaaaaaaaaaaaaaaaa
adaaaaaaadaaaaaaapadaaaalaaaaaaaabaaaaaaaaaaaaaaadaaaaaaaeaaaaaa
apaaaaaaljaaaaaaaaaaaaaaaaaaaaaaadaaaaaaafaaaaaaapaaaaaafaepfdej
feejepeoaafeebeoehefeofeaaeoepfcenebemaafeeffiedepepfceeaaedepem
epfcaaklepfdeheomiaaaaaaahaaaaaaaiaaaaaalaaaaaaaaaaaaaaaabaaaaaa
adaaaaaaaaaaaaaaapaaaaaalmaaaaaaaaaaaaaaaaaaaaaaadaaaaaaabaaaaaa
apaaaaaalmaaaaaaabaaaaaaaaaaaaaaadaaaaaaacaaaaaaahaiaaaalmaaaaaa
acaaaaaaaaaaaaaaadaaaaaaadaaaaaaahaiaaaalmaaaaaaadaaaaaaaaaaaaaa
adaaaaaaaeaaaaaaahaiaaaalmaaaaaaaeaaaaaaaaaaaaaaadaaaaaaafaaaaaa
ahaiaaaalmaaaaaaafaaaaaaaaaaaaaaadaaaaaaagaaaaaaahaiaaaafdfgfpfa
epfdejfeejepeoaafeeffiedepepfceeaaklklkl"
}

}
Program "fp" {
// Fragment combos: 1
//   opengl - ALU: 15 to 15, TEX: 2 to 2
//   d3d9 - ALU: 19 to 19, TEX: 3 to 3
//   d3d11 - ALU: 6 to 6, TEX: 2 to 2, FLOW: 1 to 1
//   d3d11_9x - ALU: 6 to 6, TEX: 2 to 2, FLOW: 1 to 1
SubProgram "opengl " {
Keywords { }
Float 0 [_Cutoff]
SetTexture 0 [_BumpMap] 2D
SetTexture 2 [_MainTex] 2D
"!!ARBfp1.0
OPTION ARB_precision_hint_fastest;
# 15 ALU, 2 TEX
PARAM c[2] = { program.local[0],
		{ 0, 2, 1, 0.5 } };
TEMP R0;
TEMP R1;
TEX R0.w, fragment.texcoord[0], texture[2], 2D;
SLT R0.x, R0.w, c[0];
MOV result.color.w, c[1].x;
TEX R0.yw, fragment.texcoord[0].zwzw, texture[0], 2D;
KIL -R0.x;
MAD R0.xy, R0.wyzw, c[1].y, -c[1].z;
MUL R0.z, R0.y, R0.y;
MAD R0.z, -R0.x, R0.x, -R0;
ADD R0.z, R0, c[1];
RSQ R0.z, R0.z;
RCP R0.z, R0.z;
DP3 R1.z, fragment.texcoord[5], R0;
DP3 R1.x, R0, fragment.texcoord[3];
DP3 R1.y, R0, fragment.texcoord[4];
MAD result.color.xyz, R1, c[1].w, c[1].w;
END
# 15 instructions, 2 R-regs
"
}

SubProgram "d3d9 " {
Keywords { }
Float 0 [_Cutoff]
SetTexture 0 [_BumpMap] 2D
SetTexture 2 [_MainTex] 2D
"ps_2_0
; 19 ALU, 3 TEX
dcl_2d s0
dcl_2d s2
def c1, 0.00000000, 1.00000000, 2.00000000, -1.00000000
def c2, 0.50000000, 0, 0, 0
dcl t0
dcl t3.xyz
dcl t4.xyz
dcl t5.xyz
texld r0, t0, s2
add_pp r0.x, r0.w, -c0
cmp r0.x, r0, c1, c1.y
mov_pp r0, -r0.x
mov r1.y, t0.w
mov r1.x, t0.z
texld r1, r1, s0
texkill r0.xyzw
mov r0.y, r1
mov r0.x, r1.w
mad_pp r0.xy, r0, c1.z, c1.w
mul_pp r1.x, r0.y, r0.y
mad_pp r1.x, -r0, r0, -r1
add_pp r1.x, r1, c1.y
rsq_pp r1.x, r1.x
rcp_pp r0.z, r1.x
dp3 r1.z, t5, r0
dp3 r1.x, r0, t3
dp3 r1.y, r0, t4
mad_pp r0.xyz, r1, c2.x, c2.x
mov_pp r0.w, c1.x
mov_pp oC0, r0
"
}

SubProgram "d3d11 " {
Keywords { }
ConstBuffer "$Globals" 112 // 100 used size, 7 vars
Float 96 [_Cutoff]
BindCB "$Globals" 0
SetTexture 0 [_BumpMap] 2D 1
SetTexture 1 [_MainTex] 2D 0
// 15 instructions, 2 temp regs, 0 temp arrays:
// ALU 6 float, 0 int, 0 uint
// TEX 2 (0 load, 0 comp, 0 bias, 0 grad)
// FLOW 1 static, 0 dynamic
"ps_4_0
eefiecedbbpobiljoelhfclehopigncamcgbajlnabaaaaaakiadaaaaadaaaaaa
cmaaaaaapmaaaaaadaabaaaaejfdeheomiaaaaaaahaaaaaaaiaaaaaalaaaaaaa
aaaaaaaaabaaaaaaadaaaaaaaaaaaaaaapaaaaaalmaaaaaaaaaaaaaaaaaaaaaa
adaaaaaaabaaaaaaapapaaaalmaaaaaaabaaaaaaaaaaaaaaadaaaaaaacaaaaaa
ahaaaaaalmaaaaaaacaaaaaaaaaaaaaaadaaaaaaadaaaaaaahaaaaaalmaaaaaa
adaaaaaaaaaaaaaaadaaaaaaaeaaaaaaahahaaaalmaaaaaaaeaaaaaaaaaaaaaa
adaaaaaaafaaaaaaahahaaaalmaaaaaaafaaaaaaaaaaaaaaadaaaaaaagaaaaaa
ahahaaaafdfgfpfaepfdejfeejepeoaafeeffiedepepfceeaaklklklepfdeheo
cmaaaaaaabaaaaaaaiaaaaaacaaaaaaaaaaaaaaaaaaaaaaaadaaaaaaaaaaaaaa
apaaaaaafdfgfpfegbhcghgfheaaklklfdeieefchaacaaaaeaaaaaaajmaaaaaa
fjaaaaaeegiocaaaaaaaaaaaahaaaaaafkaaaaadaagabaaaaaaaaaaafkaaaaad
aagabaaaabaaaaaafibiaaaeaahabaaaaaaaaaaaffffaaaafibiaaaeaahabaaa
abaaaaaaffffaaaagcbaaaadpcbabaaaabaaaaaagcbaaaadhcbabaaaaeaaaaaa
gcbaaaadhcbabaaaafaaaaaagcbaaaadhcbabaaaagaaaaaagfaaaaadpccabaaa
aaaaaaaagiaaaaacacaaaaaaefaaaaajpcaabaaaaaaaaaaaegbabaaaabaaaaaa
eghobaaaabaaaaaaaagabaaaaaaaaaaaaaaaaaajbcaabaaaaaaaaaaadkaabaaa
aaaaaaaaakiacaiaebaaaaaaaaaaaaaaagaaaaaadbaaaaahbcaabaaaaaaaaaaa
akaabaaaaaaaaaaaabeaaaaaaaaaaaaaanaaaeadakaabaaaaaaaaaaaefaaaaaj
pcaabaaaaaaaaaaaogbkbaaaabaaaaaaeghobaaaaaaaaaaaaagabaaaabaaaaaa
dcaaaaapdcaabaaaaaaaaaaahgapbaaaaaaaaaaaaceaaaaaaaaaaaeaaaaaaaea
aaaaaaaaaaaaaaaaaceaaaaaaaaaialpaaaaialpaaaaaaaaaaaaaaaadcaaaaak
icaabaaaaaaaaaaaakaabaiaebaaaaaaaaaaaaaaakaabaaaaaaaaaaaabeaaaaa
aaaaiadpdcaaaaakicaabaaaaaaaaaaabkaabaiaebaaaaaaaaaaaaaabkaabaaa
aaaaaaaadkaabaaaaaaaaaaaelaaaaafecaabaaaaaaaaaaadkaabaaaaaaaaaaa
baaaaaahbcaabaaaabaaaaaaegbcbaaaaeaaaaaaegacbaaaaaaaaaaabaaaaaah
ccaabaaaabaaaaaaegbcbaaaafaaaaaaegacbaaaaaaaaaaabaaaaaahecaabaaa
abaaaaaaegbcbaaaagaaaaaaegacbaaaaaaaaaaadcaaaaaphccabaaaaaaaaaaa
egacbaaaabaaaaaaaceaaaaaaaaaaadpaaaaaadpaaaaaadpaaaaaaaaaceaaaaa
aaaaaadpaaaaaadpaaaaaadpaaaaaaaadgaaaaaficcabaaaaaaaaaaaabeaaaaa
aaaaaaaadoaaaaab"
}

SubProgram "gles " {
Keywords { }
"!!GLES"
}

SubProgram "glesdesktop " {
Keywords { }
"!!GLES"
}

SubProgram "d3d11_9x " {
Keywords { }
ConstBuffer "$Globals" 112 // 100 used size, 7 vars
Float 96 [_Cutoff]
BindCB "$Globals" 0
SetTexture 0 [_BumpMap] 2D 1
SetTexture 1 [_MainTex] 2D 0
// 15 instructions, 2 temp regs, 0 temp arrays:
// ALU 6 float, 0 int, 0 uint
// TEX 2 (0 load, 0 comp, 0 bias, 0 grad)
// FLOW 1 static, 0 dynamic
"ps_4_0_level_9_3
eefiecedmmlfkfobapfceahbjbmfhbljgdnolnggabaaaaaagaafaaaaaeaaaaaa
daaaaaaaoeabaaaafmaeaaaacmafaaaaebgpgodjkmabaaaakmabaaaaaaacpppp
heabaaaadiaaaaaaabaacmaaaaaadiaaaaaadiaaacaaceaaaaaadiaaabaaaaaa
aaababaaaaaaagaaabaaaaaaaaaaaaaaabacppppfbaaaaafabaaapkaaaaaaaea
aaaaialpaaaaiadpaaaaaadpfbaaaaafacaaapkaaaaaaaaaaaaaaaaaaaaaaaaa
aaaaaaaabpaaaaacaaaaaaiaaaaaaplabpaaaaacaaaaaaiaadaaahlabpaaaaac
aaaaaaiaaeaaahlabpaaaaacaaaaaaiaafaaahlabpaaaaacaaaaaajaaaaiapka
bpaaaaacaaaaaajaabaiapkaecaaaaadaaaacpiaaaaaoelaaaaioekaacaaaaad
aaaacpiaaaaappiaaaaaaakbabaaaaacabaaadiaaaaaoolaebaaaaabaaaaapia
ecaaaaadaaaacpiaabaaoeiaabaioekaaeaaaaaeaaaacdiaaaaaohiaabaaaaka
abaaffkaaeaaaaaeaaaaciiaaaaaaaiaaaaaaaibabaakkkaaeaaaaaeaaaaciia
aaaaffiaaaaaffibaaaappiaahaaaaacaaaaciiaaaaappiaagaaaaacaaaaceia
aaaappiaaiaaaaadabaacbiaadaaoelaaaaaoeiaaiaaaaadabaacciaaeaaoela
aaaaoeiaaiaaaaadabaaceiaafaaoelaaaaaoeiaaeaaaaaeaaaachiaabaaoeia
abaappkaabaappkaabaaaaacaaaaciiaacaaaakaabaaaaacaaaicpiaaaaaoeia
ppppaaaafdeieefchaacaaaaeaaaaaaajmaaaaaafjaaaaaeegiocaaaaaaaaaaa
ahaaaaaafkaaaaadaagabaaaaaaaaaaafkaaaaadaagabaaaabaaaaaafibiaaae
aahabaaaaaaaaaaaffffaaaafibiaaaeaahabaaaabaaaaaaffffaaaagcbaaaad
pcbabaaaabaaaaaagcbaaaadhcbabaaaaeaaaaaagcbaaaadhcbabaaaafaaaaaa
gcbaaaadhcbabaaaagaaaaaagfaaaaadpccabaaaaaaaaaaagiaaaaacacaaaaaa
efaaaaajpcaabaaaaaaaaaaaegbabaaaabaaaaaaeghobaaaabaaaaaaaagabaaa
aaaaaaaaaaaaaaajbcaabaaaaaaaaaaadkaabaaaaaaaaaaaakiacaiaebaaaaaa
aaaaaaaaagaaaaaadbaaaaahbcaabaaaaaaaaaaaakaabaaaaaaaaaaaabeaaaaa
aaaaaaaaanaaaeadakaabaaaaaaaaaaaefaaaaajpcaabaaaaaaaaaaaogbkbaaa
abaaaaaaeghobaaaaaaaaaaaaagabaaaabaaaaaadcaaaaapdcaabaaaaaaaaaaa
hgapbaaaaaaaaaaaaceaaaaaaaaaaaeaaaaaaaeaaaaaaaaaaaaaaaaaaceaaaaa
aaaaialpaaaaialpaaaaaaaaaaaaaaaadcaaaaakicaabaaaaaaaaaaaakaabaia
ebaaaaaaaaaaaaaaakaabaaaaaaaaaaaabeaaaaaaaaaiadpdcaaaaakicaabaaa
aaaaaaaabkaabaiaebaaaaaaaaaaaaaabkaabaaaaaaaaaaadkaabaaaaaaaaaaa
elaaaaafecaabaaaaaaaaaaadkaabaaaaaaaaaaabaaaaaahbcaabaaaabaaaaaa
egbcbaaaaeaaaaaaegacbaaaaaaaaaaabaaaaaahccaabaaaabaaaaaaegbcbaaa
afaaaaaaegacbaaaaaaaaaaabaaaaaahecaabaaaabaaaaaaegbcbaaaagaaaaaa
egacbaaaaaaaaaaadcaaaaaphccabaaaaaaaaaaaegacbaaaabaaaaaaaceaaaaa
aaaaaadpaaaaaadpaaaaaadpaaaaaaaaaceaaaaaaaaaaadpaaaaaadpaaaaaadp
aaaaaaaadgaaaaaficcabaaaaaaaaaaaabeaaaaaaaaaaaaadoaaaaabejfdeheo
miaaaaaaahaaaaaaaiaaaaaalaaaaaaaaaaaaaaaabaaaaaaadaaaaaaaaaaaaaa
apaaaaaalmaaaaaaaaaaaaaaaaaaaaaaadaaaaaaabaaaaaaapapaaaalmaaaaaa
abaaaaaaaaaaaaaaadaaaaaaacaaaaaaahaaaaaalmaaaaaaacaaaaaaaaaaaaaa
adaaaaaaadaaaaaaahaaaaaalmaaaaaaadaaaaaaaaaaaaaaadaaaaaaaeaaaaaa
ahahaaaalmaaaaaaaeaaaaaaaaaaaaaaadaaaaaaafaaaaaaahahaaaalmaaaaaa
afaaaaaaaaaaaaaaadaaaaaaagaaaaaaahahaaaafdfgfpfaepfdejfeejepeoaa
feeffiedepepfceeaaklklklepfdeheocmaaaaaaabaaaaaaaiaaaaaacaaaaaaa
aaaaaaaaaaaaaaaaadaaaaaaaaaaaaaaapaaaaaafdfgfpfegbhcghgfheaaklkl
"
}

}
	}
	Pass {
		Name "PREPASS"
		Tags { "LightMode" = "PrePassFinal" }
		ZWrite Off
Program "vp" {
// Vertex combos: 6
//   opengl - ALU: 22 to 40
//   d3d9 - ALU: 23 to 40
//   d3d11 - ALU: 12 to 23, TEX: 0 to 0, FLOW: 1 to 1
//   d3d11_9x - ALU: 12 to 23, TEX: 0 to 0, FLOW: 1 to 1
SubProgram "opengl " {
Keywords { "LIGHTMAP_OFF" "DIRLIGHTMAP_OFF" "HDR_LIGHT_PREPASS_OFF" }
Bind "vertex" Vertex
Bind "tangent" ATTR14
Bind "normal" Normal
Bind "texcoord" TexCoord0
Vector 13 [_ProjectionParams]
Vector 14 [unity_SHAr]
Vector 15 [unity_SHAg]
Vector 16 [unity_SHAb]
Vector 17 [unity_SHBr]
Vector 18 [unity_SHBg]
Vector 19 [unity_SHBb]
Vector 20 [unity_SHC]
Matrix 9 [_Object2World]
Vector 21 [unity_Scale]
Vector 22 [_MainTex_ST]
Vector 23 [_BumpMap_ST]
"!!ARBvp1.0
# 40 ALU
PARAM c[24] = { { 0.5, 1 },
		state.matrix.mvp,
		state.matrix.modelview[0].invtrans,
		program.local[9..23] };
TEMP R0;
TEMP R1;
TEMP R2;
MUL R1.xyz, vertex.normal, c[21].w;
DP3 R2.w, R1, c[10];
DP3 R0.x, R1, c[9];
DP3 R0.z, R1, c[11];
MOV R0.y, R2.w;
MOV R0.w, c[0].y;
MUL R1, R0.xyzz, R0.yzzx;
DP4 R2.z, R0, c[16];
DP4 R2.y, R0, c[15];
DP4 R2.x, R0, c[14];
DP4 R0.w, R1, c[19];
DP4 R0.y, R1, c[17];
DP4 R0.z, R1, c[18];
MUL R1.w, R2, R2;
ADD R0.yzw, R2.xxyz, R0;
MOV R1.xyz, vertex.attrib[14];
MUL R2.xyz, vertex.normal.zxyw, R1.yzxw;
MAD R1.xyz, vertex.normal.yzxw, R1.zxyw, -R2;
MUL R1.xyz, R1, vertex.attrib[14].w;
MAD R0.x, R0, R0, -R1.w;
MUL R2.xyz, R0.x, c[20];
ADD result.texcoord[4].xyz, R0.yzww, R2;
DP4 R0.w, vertex.position, c[4];
DP4 R0.z, vertex.position, c[3];
DP3 result.texcoord[1].y, R1, c[5];
DP4 R0.x, vertex.position, c[1];
DP4 R0.y, vertex.position, c[2];
MUL R2.xyz, R0.xyww, c[0].x;
DP3 result.texcoord[2].y, R1, c[6];
MOV R1.x, R2;
MUL R1.y, R2, c[13].x;
ADD result.texcoord[3].xy, R1, R2.z;
MOV result.position, R0;
MOV result.texcoord[3].zw, R0;
MAD result.texcoord[0].zw, vertex.texcoord[0].xyxy, c[23].xyxy, c[23];
MAD result.texcoord[0].xy, vertex.texcoord[0], c[22], c[22].zwzw;
DP3 result.texcoord[1].z, vertex.normal, c[5];
DP3 result.texcoord[1].x, vertex.attrib[14], c[5];
DP3 result.texcoord[2].z, vertex.normal, c[6];
DP3 result.texcoord[2].x, vertex.attrib[14], c[6];
END
# 40 instructions, 3 R-regs
"
}

SubProgram "d3d9 " {
Keywords { "LIGHTMAP_OFF" "DIRLIGHTMAP_OFF" "HDR_LIGHT_PREPASS_OFF" }
Bind "vertex" Vertex
Bind "tangent" TexCoord2
Bind "normal" Normal
Bind "texcoord" TexCoord0
Matrix 0 [glstate_matrix_mvp]
Matrix 4 [glstate_matrix_invtrans_modelview0]
Vector 12 [_ProjectionParams]
Vector 13 [_ScreenParams]
Vector 14 [unity_SHAr]
Vector 15 [unity_SHAg]
Vector 16 [unity_SHAb]
Vector 17 [unity_SHBr]
Vector 18 [unity_SHBg]
Vector 19 [unity_SHBb]
Vector 20 [unity_SHC]
Matrix 8 [_Object2World]
Vector 21 [unity_Scale]
Vector 22 [_MainTex_ST]
Vector 23 [_BumpMap_ST]
"vs_2_0
; 40 ALU
def c24, 0.50000000, 1.00000000, 0, 0
dcl_position0 v0
dcl_tangent0 v1
dcl_normal0 v2
dcl_texcoord0 v3
mul r1.xyz, v2, c21.w
dp3 r2.w, r1, c9
dp3 r0.x, r1, c8
dp3 r0.z, r1, c10
mov r0.y, r2.w
mov r0.w, c24.y
mul r1, r0.xyzz, r0.yzzx
dp4 r2.z, r0, c16
dp4 r2.y, r0, c15
dp4 r2.x, r0, c14
dp4 r0.w, r1, c19
dp4 r0.y, r1, c17
dp4 r0.z, r1, c18
add r1.xyz, r2, r0.yzww
mul r0.y, r2.w, r2.w
mad r0.w, r0.x, r0.x, -r0.y
mov r2.xyz, v1
mov r0.xyz, v1
mul r2.xyz, v2.zxyw, r2.yzxw
mad r2.xyz, v2.yzxw, r0.zxyw, -r2
mul r0.xyz, r0.w, c20
add oT4.xyz, r1, r0
mul r2.xyz, r2, v1.w
dp4 r0.w, v0, c3
dp4 r0.z, v0, c2
dp4 r0.x, v0, c0
dp4 r0.y, v0, c1
mul r1.xyz, r0.xyww, c24.x
mul r1.y, r1, c12.x
dp3 oT1.y, r2, c4
dp3 oT2.y, r2, c5
mad oT3.xy, r1.z, c13.zwzw, r1
mov oPos, r0
mov oT3.zw, r0
mad oT0.zw, v3.xyxy, c23.xyxy, c23
mad oT0.xy, v3, c22, c22.zwzw
dp3 oT1.z, v2, c4
dp3 oT1.x, v1, c4
dp3 oT2.z, v2, c5
dp3 oT2.x, v1, c5
"
}

SubProgram "d3d11 " {
Keywords { "LIGHTMAP_OFF" "DIRLIGHTMAP_OFF" "HDR_LIGHT_PREPASS_OFF" }
Bind "vertex" Vertex
Bind "tangent" TexCoord2
Bind "normal" Normal
Bind "texcoord" TexCoord0
Bind "color" Color
ConstBuffer "$Globals" 128 // 96 used size, 8 vars
Vector 64 [_MainTex_ST] 4
Vector 80 [_BumpMap_ST] 4
ConstBuffer "UnityPerCamera" 128 // 96 used size, 8 vars
Vector 80 [_ProjectionParams] 4
ConstBuffer "UnityLighting" 400 // 400 used size, 16 vars
Vector 288 [unity_SHAr] 4
Vector 304 [unity_SHAg] 4
Vector 320 [unity_SHAb] 4
Vector 336 [unity_SHBr] 4
Vector 352 [unity_SHBg] 4
Vector 368 [unity_SHBb] 4
Vector 384 [unity_SHC] 4
ConstBuffer "UnityPerDraw" 336 // 336 used size, 6 vars
Matrix 0 [glstate_matrix_mvp] 4
Matrix 128 [glstate_matrix_invtrans_modelview0] 4
Matrix 192 [_Object2World] 4
Vector 320 [unity_Scale] 4
BindCB "$Globals" 0
BindCB "UnityPerCamera" 1
BindCB "UnityLighting" 2
BindCB "UnityPerDraw" 3
// 43 instructions, 4 temp regs, 0 temp arrays:
// ALU 23 float, 0 int, 0 uint
// TEX 0 (0 load, 0 comp, 0 bias, 0 grad)
// FLOW 1 static, 0 dynamic
"vs_4_0
eefiecedhenpnkfakdchpiakopoppgigdkhjamkdabaaaaaakaahaaaaadaaaaaa
cmaaaaaapeaaaaaakmabaaaaejfdeheomaaaaaaaagaaaaaaaiaaaaaajiaaaaaa
aaaaaaaaaaaaaaaaadaaaaaaaaaaaaaaapapaaaakbaaaaaaaaaaaaaaaaaaaaaa
adaaaaaaabaaaaaaapapaaaakjaaaaaaaaaaaaaaaaaaaaaaadaaaaaaacaaaaaa
ahahaaaalaaaaaaaaaaaaaaaaaaaaaaaadaaaaaaadaaaaaaapadaaaalaaaaaaa
abaaaaaaaaaaaaaaadaaaaaaaeaaaaaaapaaaaaaljaaaaaaaaaaaaaaaaaaaaaa
adaaaaaaafaaaaaaapaaaaaafaepfdejfeejepeoaafeebeoehefeofeaaeoepfc
enebemaafeeffiedepepfceeaaedepemepfcaaklepfdeheolaaaaaaaagaaaaaa
aiaaaaaajiaaaaaaaaaaaaaaabaaaaaaadaaaaaaaaaaaaaaapaaaaaakeaaaaaa
aaaaaaaaaaaaaaaaadaaaaaaabaaaaaaapaaaaaakeaaaaaaabaaaaaaaaaaaaaa
adaaaaaaacaaaaaaahaiaaaakeaaaaaaacaaaaaaaaaaaaaaadaaaaaaadaaaaaa
ahaiaaaakeaaaaaaadaaaaaaaaaaaaaaadaaaaaaaeaaaaaaapaaaaaakeaaaaaa
aeaaaaaaaaaaaaaaadaaaaaaafaaaaaaahaiaaaafdfgfpfaepfdejfeejepeoaa
feeffiedepepfceeaaklklklfdeieefcomafaaaaeaaaabaahlabaaaafjaaaaae
egiocaaaaaaaaaaaagaaaaaafjaaaaaeegiocaaaabaaaaaaagaaaaaafjaaaaae
egiocaaaacaaaaaabjaaaaaafjaaaaaeegiocaaaadaaaaaabfaaaaaafpaaaaad
pcbabaaaaaaaaaaafpaaaaadpcbabaaaabaaaaaafpaaaaadhcbabaaaacaaaaaa
fpaaaaaddcbabaaaadaaaaaaghaaaaaepccabaaaaaaaaaaaabaaaaaagfaaaaad
pccabaaaabaaaaaagfaaaaadhccabaaaacaaaaaagfaaaaadhccabaaaadaaaaaa
gfaaaaadpccabaaaaeaaaaaagfaaaaadhccabaaaafaaaaaagiaaaaacaeaaaaaa
diaaaaaipcaabaaaaaaaaaaafgbfbaaaaaaaaaaaegiocaaaadaaaaaaabaaaaaa
dcaaaaakpcaabaaaaaaaaaaaegiocaaaadaaaaaaaaaaaaaaagbabaaaaaaaaaaa
egaobaaaaaaaaaaadcaaaaakpcaabaaaaaaaaaaaegiocaaaadaaaaaaacaaaaaa
kgbkbaaaaaaaaaaaegaobaaaaaaaaaaadcaaaaakpcaabaaaaaaaaaaaegiocaaa
adaaaaaaadaaaaaapgbpbaaaaaaaaaaaegaobaaaaaaaaaaadgaaaaafpccabaaa
aaaaaaaaegaobaaaaaaaaaaadcaaaaaldccabaaaabaaaaaaegbabaaaadaaaaaa
egiacaaaaaaaaaaaaeaaaaaaogikcaaaaaaaaaaaaeaaaaaadcaaaaalmccabaaa
abaaaaaaagbebaaaadaaaaaaagiecaaaaaaaaaaaafaaaaaakgiocaaaaaaaaaaa
afaaaaaadiaaaaahhcaabaaaabaaaaaajgbebaaaabaaaaaacgbjbaaaacaaaaaa
dcaaaaakhcaabaaaabaaaaaajgbebaaaacaaaaaacgbjbaaaabaaaaaaegacbaia
ebaaaaaaabaaaaaadiaaaaahhcaabaaaabaaaaaaegacbaaaabaaaaaapgbpbaaa
abaaaaaadgaaaaagbcaabaaaacaaaaaaakiacaaaadaaaaaaaiaaaaaadgaaaaag
ccaabaaaacaaaaaaakiacaaaadaaaaaaajaaaaaadgaaaaagecaabaaaacaaaaaa
akiacaaaadaaaaaaakaaaaaabaaaaaahcccabaaaacaaaaaaegacbaaaabaaaaaa
egacbaaaacaaaaaabaaaaaahbccabaaaacaaaaaaegbcbaaaabaaaaaaegacbaaa
acaaaaaabaaaaaaheccabaaaacaaaaaaegbcbaaaacaaaaaaegacbaaaacaaaaaa
dgaaaaagbcaabaaaacaaaaaabkiacaaaadaaaaaaaiaaaaaadgaaaaagccaabaaa
acaaaaaabkiacaaaadaaaaaaajaaaaaadgaaaaagecaabaaaacaaaaaabkiacaaa
adaaaaaaakaaaaaabaaaaaahcccabaaaadaaaaaaegacbaaaabaaaaaaegacbaaa
acaaaaaabaaaaaahbccabaaaadaaaaaaegbcbaaaabaaaaaaegacbaaaacaaaaaa
baaaaaaheccabaaaadaaaaaaegbcbaaaacaaaaaaegacbaaaacaaaaaadiaaaaai
ccaabaaaaaaaaaaabkaabaaaaaaaaaaaakiacaaaabaaaaaaafaaaaaadiaaaaak
ncaabaaaabaaaaaaagahbaaaaaaaaaaaaceaaaaaaaaaaadpaaaaaaaaaaaaaadp
aaaaaadpdgaaaaafmccabaaaaeaaaaaakgaobaaaaaaaaaaaaaaaaaahdccabaaa
aeaaaaaakgakbaaaabaaaaaamgaabaaaabaaaaaadiaaaaaihcaabaaaaaaaaaaa
egbcbaaaacaaaaaapgipcaaaadaaaaaabeaaaaaadiaaaaaihcaabaaaabaaaaaa
fgafbaaaaaaaaaaaegiccaaaadaaaaaaanaaaaaadcaaaaaklcaabaaaaaaaaaaa
egiicaaaadaaaaaaamaaaaaaagaabaaaaaaaaaaaegaibaaaabaaaaaadcaaaaak
hcaabaaaaaaaaaaaegiccaaaadaaaaaaaoaaaaaakgakbaaaaaaaaaaaegadbaaa
aaaaaaaadgaaaaaficaabaaaaaaaaaaaabeaaaaaaaaaiadpbbaaaaaibcaabaaa
abaaaaaaegiocaaaacaaaaaabcaaaaaaegaobaaaaaaaaaaabbaaaaaiccaabaaa
abaaaaaaegiocaaaacaaaaaabdaaaaaaegaobaaaaaaaaaaabbaaaaaiecaabaaa
abaaaaaaegiocaaaacaaaaaabeaaaaaaegaobaaaaaaaaaaadiaaaaahpcaabaaa
acaaaaaajgacbaaaaaaaaaaaegakbaaaaaaaaaaabbaaaaaibcaabaaaadaaaaaa
egiocaaaacaaaaaabfaaaaaaegaobaaaacaaaaaabbaaaaaiccaabaaaadaaaaaa
egiocaaaacaaaaaabgaaaaaaegaobaaaacaaaaaabbaaaaaiecaabaaaadaaaaaa
egiocaaaacaaaaaabhaaaaaaegaobaaaacaaaaaaaaaaaaahhcaabaaaabaaaaaa
egacbaaaabaaaaaaegacbaaaadaaaaaadiaaaaahccaabaaaaaaaaaaabkaabaaa
aaaaaaaabkaabaaaaaaaaaaadcaaaaakbcaabaaaaaaaaaaaakaabaaaaaaaaaaa
akaabaaaaaaaaaaabkaabaiaebaaaaaaaaaaaaaadcaaaaakhccabaaaafaaaaaa
egiccaaaacaaaaaabiaaaaaaagaabaaaaaaaaaaaegacbaaaabaaaaaadoaaaaab
"
}

SubProgram "gles " {
Keywords { "LIGHTMAP_OFF" "DIRLIGHTMAP_OFF" "HDR_LIGHT_PREPASS_OFF" }
"!!GLES
#define SHADER_API_GLES 1
#define tex2D texture2D


#ifdef VERTEX
#define gl_ModelViewProjectionMatrix glstate_matrix_mvp
uniform mat4 glstate_matrix_mvp;
#define gl_ModelViewMatrixInverseTranspose glstate_matrix_invtrans_modelview0
uniform mat4 glstate_matrix_invtrans_modelview0;
#define gl_ModelViewMatrix glstate_matrix_modelview0
uniform mat4 glstate_matrix_modelview0;

varying highp vec3 xlv_TEXCOORD4;
varying highp vec4 xlv_TEXCOORD3;
varying highp vec3 xlv_TEXCOORD2;
varying highp vec3 xlv_TEXCOORD1;
varying highp vec4 xlv_TEXCOORD0;
uniform highp vec4 _BumpMap_ST;
uniform highp vec4 _MainTex_ST;
uniform highp vec4 unity_Scale;
uniform highp mat4 _Object2World;


uniform highp vec4 unity_SHC;
uniform highp vec4 unity_SHBb;
uniform highp vec4 unity_SHBg;
uniform highp vec4 unity_SHBr;
uniform highp vec4 unity_SHAb;
uniform highp vec4 unity_SHAg;
uniform highp vec4 unity_SHAr;
uniform highp vec4 _ProjectionParams;
attribute vec4 _glesTANGENT;
attribute vec4 _glesMultiTexCoord0;
attribute vec3 _glesNormal;
attribute vec4 _glesVertex;
void main ()
{
  vec4 tmpvar_1;
  tmpvar_1.xyz = normalize(_glesTANGENT.xyz);
  tmpvar_1.w = _glesTANGENT.w;
  vec3 tmpvar_2;
  tmpvar_2 = normalize(_glesNormal);
  highp vec4 tmpvar_3;
  highp vec3 tmpvar_4;
  highp vec3 tmpvar_5;
  highp vec3 tmpvar_6;
  tmpvar_5 = tmpvar_1.xyz;
  tmpvar_6 = (((tmpvar_2.yzx * tmpvar_1.zxy) - (tmpvar_2.zxy * tmpvar_1.yzx)) * _glesTANGENT.w);
  highp mat3 tmpvar_7;
  tmpvar_7[0].x = tmpvar_5.x;
  tmpvar_7[0].y = tmpvar_6.x;
  tmpvar_7[0].z = tmpvar_2.x;
  tmpvar_7[1].x = tmpvar_5.y;
  tmpvar_7[1].y = tmpvar_6.y;
  tmpvar_7[1].z = tmpvar_2.y;
  tmpvar_7[2].x = tmpvar_5.z;
  tmpvar_7[2].y = tmpvar_6.z;
  tmpvar_7[2].z = tmpvar_2.z;
  vec4 v_8;
  v_8.x = gl_ModelViewMatrixInverseTranspose[0].x;
  v_8.y = gl_ModelViewMatrixInverseTranspose[1].x;
  v_8.z = gl_ModelViewMatrixInverseTranspose[2].x;
  v_8.w = gl_ModelViewMatrixInverseTranspose[3].x;
  vec4 v_9;
  v_9.x = gl_ModelViewMatrixInverseTranspose[0].y;
  v_9.y = gl_ModelViewMatrixInverseTranspose[1].y;
  v_9.z = gl_ModelViewMatrixInverseTranspose[2].y;
  v_9.w = gl_ModelViewMatrixInverseTranspose[3].y;
  highp vec4 tmpvar_10;
  tmpvar_10 = (gl_ModelViewProjectionMatrix * _glesVertex);
  tmpvar_3.xy = ((_glesMultiTexCoord0.xy * _MainTex_ST.xy) + _MainTex_ST.zw);
  tmpvar_3.zw = ((_glesMultiTexCoord0.xy * _BumpMap_ST.xy) + _BumpMap_ST.zw);
  highp vec4 o_11;
  highp vec4 tmpvar_12;
  tmpvar_12 = (tmpvar_10 * 0.5);
  highp vec2 tmpvar_13;
  tmpvar_13.x = tmpvar_12.x;
  tmpvar_13.y = (tmpvar_12.y * _ProjectionParams.x);
  o_11.xy = (tmpvar_13 + tmpvar_12.w);
  o_11.zw = tmpvar_10.zw;
  mat3 tmpvar_14;
  tmpvar_14[0] = _Object2World[0].xyz;
  tmpvar_14[1] = _Object2World[1].xyz;
  tmpvar_14[2] = _Object2World[2].xyz;
  highp vec4 tmpvar_15;
  tmpvar_15.w = 1.0;
  tmpvar_15.xyz = (tmpvar_14 * (tmpvar_2 * unity_Scale.w));
  mediump vec3 tmpvar_16;
  mediump vec4 normal_17;
  normal_17 = tmpvar_15;
  highp float vC_18;
  mediump vec3 x3_19;
  mediump vec3 x2_20;
  mediump vec3 x1_21;
  highp float tmpvar_22;
  tmpvar_22 = dot (unity_SHAr, normal_17);
  x1_21.x = tmpvar_22;
  highp float tmpvar_23;
  tmpvar_23 = dot (unity_SHAg, normal_17);
  x1_21.y = tmpvar_23;
  highp float tmpvar_24;
  tmpvar_24 = dot (unity_SHAb, normal_17);
  x1_21.z = tmpvar_24;
  mediump vec4 tmpvar_25;
  tmpvar_25 = (normal_17.xyzz * normal_17.yzzx);
  highp float tmpvar_26;
  tmpvar_26 = dot (unity_SHBr, tmpvar_25);
  x2_20.x = tmpvar_26;
  highp float tmpvar_27;
  tmpvar_27 = dot (unity_SHBg, tmpvar_25);
  x2_20.y = tmpvar_27;
  highp float tmpvar_28;
  tmpvar_28 = dot (unity_SHBb, tmpvar_25);
  x2_20.z = tmpvar_28;
  mediump float tmpvar_29;
  tmpvar_29 = ((normal_17.x * normal_17.x) - (normal_17.y * normal_17.y));
  vC_18 = tmpvar_29;
  highp vec3 tmpvar_30;
  tmpvar_30 = (unity_SHC.xyz * vC_18);
  x3_19 = tmpvar_30;
  tmpvar_16 = ((x1_21 + x2_20) + x3_19);
  tmpvar_4 = tmpvar_16;
  gl_Position = tmpvar_10;
  xlv_TEXCOORD0 = tmpvar_3;
  xlv_TEXCOORD1 = (tmpvar_7 * v_8.xyz);
  xlv_TEXCOORD2 = (tmpvar_7 * v_9.xyz);
  xlv_TEXCOORD3 = o_11;
  xlv_TEXCOORD4 = tmpvar_4;
}



#endif
#ifdef FRAGMENT

varying highp vec3 xlv_TEXCOORD4;
varying highp vec4 xlv_TEXCOORD3;
varying highp vec3 xlv_TEXCOORD2;
varying highp vec3 xlv_TEXCOORD1;
varying highp vec4 xlv_TEXCOORD0;
uniform lowp float _Cutoff;
uniform sampler2D _LightBuffer;
uniform sampler2D _Shade;
uniform sampler2D _BumpMap;
uniform sampler2D _MainTex;
uniform lowp vec4 _Color;
void main ()
{
  lowp vec4 tmpvar_1;
  mediump vec4 c_2;
  mediump vec4 light_3;
  lowp vec3 tmpvar_4;
  highp vec3 matcap_5;
  lowp vec3 tmpvar_6;
  tmpvar_6 = ((texture2D (_BumpMap, xlv_TEXCOORD0.zw).xyz * 2.0) - 1.0);
  lowp vec3 tmpvar_7;
  tmpvar_7 = (texture2D (_MainTex, xlv_TEXCOORD0.xy).xyz * _Color.w);
  highp vec2 tmpvar_8;
  tmpvar_8.x = dot (xlv_TEXCOORD1, tmpvar_6);
  tmpvar_8.y = dot (xlv_TEXCOORD2, tmpvar_6);
  highp vec2 P_9;
  P_9 = ((tmpvar_8 * 0.5) + 0.5);
  lowp vec3 tmpvar_10;
  tmpvar_10 = texture2D (_Shade, P_9).xyz;
  matcap_5 = tmpvar_10;
  lowp vec4 tmpvar_11;
  tmpvar_11 = texture2D (_MainTex, xlv_TEXCOORD0.xy);
  highp vec3 tmpvar_12;
  tmpvar_12 = (((matcap_5 * tmpvar_11.xyz) * _Color.xyz) * 3.0);
  tmpvar_4 = tmpvar_12;
  lowp vec4 tmpvar_13;
  tmpvar_13 = texture2D (_MainTex, xlv_TEXCOORD0.xy);
  lowp float x_14;
  x_14 = (tmpvar_13.w - _Cutoff);
  if ((x_14 < 0.0)) {
    discard;
  };
  lowp vec4 tmpvar_15;
  tmpvar_15 = texture2DProj (_LightBuffer, xlv_TEXCOORD3);
  light_3 = tmpvar_15;
  mediump vec4 tmpvar_16;
  tmpvar_16 = -(log2(max (light_3, vec4(0.001, 0.001, 0.001, 0.001))));
  light_3.w = tmpvar_16.w;
  highp vec3 tmpvar_17;
  tmpvar_17 = (tmpvar_16.xyz + xlv_TEXCOORD4);
  light_3.xyz = tmpvar_17;
  lowp vec4 c_18;
  mediump vec3 tmpvar_19;
  tmpvar_19 = (tmpvar_7 * light_3.xyz);
  c_18.xyz = tmpvar_19;
  c_18.w = tmpvar_13.w;
  c_2 = c_18;
  c_2.xyz = (c_2.xyz + tmpvar_4);
  tmpvar_1 = c_2;
  gl_FragData[0] = tmpvar_1;
}



#endif"
}

SubProgram "glesdesktop " {
Keywords { "LIGHTMAP_OFF" "DIRLIGHTMAP_OFF" "HDR_LIGHT_PREPASS_OFF" }
"!!GLES
#define SHADER_API_GLES 1
#define tex2D texture2D


#ifdef VERTEX
#define gl_ModelViewProjectionMatrix glstate_matrix_mvp
uniform mat4 glstate_matrix_mvp;
#define gl_ModelViewMatrixInverseTranspose glstate_matrix_invtrans_modelview0
uniform mat4 glstate_matrix_invtrans_modelview0;
#define gl_ModelViewMatrix glstate_matrix_modelview0
uniform mat4 glstate_matrix_modelview0;

varying highp vec3 xlv_TEXCOORD4;
varying highp vec4 xlv_TEXCOORD3;
varying highp vec3 xlv_TEXCOORD2;
varying highp vec3 xlv_TEXCOORD1;
varying highp vec4 xlv_TEXCOORD0;
uniform highp vec4 _BumpMap_ST;
uniform highp vec4 _MainTex_ST;
uniform highp vec4 unity_Scale;
uniform highp mat4 _Object2World;


uniform highp vec4 unity_SHC;
uniform highp vec4 unity_SHBb;
uniform highp vec4 unity_SHBg;
uniform highp vec4 unity_SHBr;
uniform highp vec4 unity_SHAb;
uniform highp vec4 unity_SHAg;
uniform highp vec4 unity_SHAr;
uniform highp vec4 _ProjectionParams;
attribute vec4 _glesTANGENT;
attribute vec4 _glesMultiTexCoord0;
attribute vec3 _glesNormal;
attribute vec4 _glesVertex;
void main ()
{
  vec4 tmpvar_1;
  tmpvar_1.xyz = normalize(_glesTANGENT.xyz);
  tmpvar_1.w = _glesTANGENT.w;
  vec3 tmpvar_2;
  tmpvar_2 = normalize(_glesNormal);
  highp vec4 tmpvar_3;
  highp vec3 tmpvar_4;
  highp vec3 tmpvar_5;
  highp vec3 tmpvar_6;
  tmpvar_5 = tmpvar_1.xyz;
  tmpvar_6 = (((tmpvar_2.yzx * tmpvar_1.zxy) - (tmpvar_2.zxy * tmpvar_1.yzx)) * _glesTANGENT.w);
  highp mat3 tmpvar_7;
  tmpvar_7[0].x = tmpvar_5.x;
  tmpvar_7[0].y = tmpvar_6.x;
  tmpvar_7[0].z = tmpvar_2.x;
  tmpvar_7[1].x = tmpvar_5.y;
  tmpvar_7[1].y = tmpvar_6.y;
  tmpvar_7[1].z = tmpvar_2.y;
  tmpvar_7[2].x = tmpvar_5.z;
  tmpvar_7[2].y = tmpvar_6.z;
  tmpvar_7[2].z = tmpvar_2.z;
  vec4 v_8;
  v_8.x = gl_ModelViewMatrixInverseTranspose[0].x;
  v_8.y = gl_ModelViewMatrixInverseTranspose[1].x;
  v_8.z = gl_ModelViewMatrixInverseTranspose[2].x;
  v_8.w = gl_ModelViewMatrixInverseTranspose[3].x;
  vec4 v_9;
  v_9.x = gl_ModelViewMatrixInverseTranspose[0].y;
  v_9.y = gl_ModelViewMatrixInverseTranspose[1].y;
  v_9.z = gl_ModelViewMatrixInverseTranspose[2].y;
  v_9.w = gl_ModelViewMatrixInverseTranspose[3].y;
  highp vec4 tmpvar_10;
  tmpvar_10 = (gl_ModelViewProjectionMatrix * _glesVertex);
  tmpvar_3.xy = ((_glesMultiTexCoord0.xy * _MainTex_ST.xy) + _MainTex_ST.zw);
  tmpvar_3.zw = ((_glesMultiTexCoord0.xy * _BumpMap_ST.xy) + _BumpMap_ST.zw);
  highp vec4 o_11;
  highp vec4 tmpvar_12;
  tmpvar_12 = (tmpvar_10 * 0.5);
  highp vec2 tmpvar_13;
  tmpvar_13.x = tmpvar_12.x;
  tmpvar_13.y = (tmpvar_12.y * _ProjectionParams.x);
  o_11.xy = (tmpvar_13 + tmpvar_12.w);
  o_11.zw = tmpvar_10.zw;
  mat3 tmpvar_14;
  tmpvar_14[0] = _Object2World[0].xyz;
  tmpvar_14[1] = _Object2World[1].xyz;
  tmpvar_14[2] = _Object2World[2].xyz;
  highp vec4 tmpvar_15;
  tmpvar_15.w = 1.0;
  tmpvar_15.xyz = (tmpvar_14 * (tmpvar_2 * unity_Scale.w));
  mediump vec3 tmpvar_16;
  mediump vec4 normal_17;
  normal_17 = tmpvar_15;
  highp float vC_18;
  mediump vec3 x3_19;
  mediump vec3 x2_20;
  mediump vec3 x1_21;
  highp float tmpvar_22;
  tmpvar_22 = dot (unity_SHAr, normal_17);
  x1_21.x = tmpvar_22;
  highp float tmpvar_23;
  tmpvar_23 = dot (unity_SHAg, normal_17);
  x1_21.y = tmpvar_23;
  highp float tmpvar_24;
  tmpvar_24 = dot (unity_SHAb, normal_17);
  x1_21.z = tmpvar_24;
  mediump vec4 tmpvar_25;
  tmpvar_25 = (normal_17.xyzz * normal_17.yzzx);
  highp float tmpvar_26;
  tmpvar_26 = dot (unity_SHBr, tmpvar_25);
  x2_20.x = tmpvar_26;
  highp float tmpvar_27;
  tmpvar_27 = dot (unity_SHBg, tmpvar_25);
  x2_20.y = tmpvar_27;
  highp float tmpvar_28;
  tmpvar_28 = dot (unity_SHBb, tmpvar_25);
  x2_20.z = tmpvar_28;
  mediump float tmpvar_29;
  tmpvar_29 = ((normal_17.x * normal_17.x) - (normal_17.y * normal_17.y));
  vC_18 = tmpvar_29;
  highp vec3 tmpvar_30;
  tmpvar_30 = (unity_SHC.xyz * vC_18);
  x3_19 = tmpvar_30;
  tmpvar_16 = ((x1_21 + x2_20) + x3_19);
  tmpvar_4 = tmpvar_16;
  gl_Position = tmpvar_10;
  xlv_TEXCOORD0 = tmpvar_3;
  xlv_TEXCOORD1 = (tmpvar_7 * v_8.xyz);
  xlv_TEXCOORD2 = (tmpvar_7 * v_9.xyz);
  xlv_TEXCOORD3 = o_11;
  xlv_TEXCOORD4 = tmpvar_4;
}



#endif
#ifdef FRAGMENT

varying highp vec3 xlv_TEXCOORD4;
varying highp vec4 xlv_TEXCOORD3;
varying highp vec3 xlv_TEXCOORD2;
varying highp vec3 xlv_TEXCOORD1;
varying highp vec4 xlv_TEXCOORD0;
uniform lowp float _Cutoff;
uniform sampler2D _LightBuffer;
uniform sampler2D _Shade;
uniform sampler2D _BumpMap;
uniform sampler2D _MainTex;
uniform lowp vec4 _Color;
void main ()
{
  lowp vec4 tmpvar_1;
  mediump vec4 c_2;
  mediump vec4 light_3;
  lowp vec3 tmpvar_4;
  highp vec3 matcap_5;
  lowp vec3 normal_6;
  normal_6.xy = ((texture2D (_BumpMap, xlv_TEXCOORD0.zw).wy * 2.0) - 1.0);
  normal_6.z = sqrt(((1.0 - (normal_6.x * normal_6.x)) - (normal_6.y * normal_6.y)));
  lowp vec3 tmpvar_7;
  tmpvar_7 = (texture2D (_MainTex, xlv_TEXCOORD0.xy).xyz * _Color.w);
  highp vec2 tmpvar_8;
  tmpvar_8.x = dot (xlv_TEXCOORD1, normal_6);
  tmpvar_8.y = dot (xlv_TEXCOORD2, normal_6);
  highp vec2 P_9;
  P_9 = ((tmpvar_8 * 0.5) + 0.5);
  lowp vec3 tmpvar_10;
  tmpvar_10 = texture2D (_Shade, P_9).xyz;
  matcap_5 = tmpvar_10;
  lowp vec4 tmpvar_11;
  tmpvar_11 = texture2D (_MainTex, xlv_TEXCOORD0.xy);
  highp vec3 tmpvar_12;
  tmpvar_12 = (((matcap_5 * tmpvar_11.xyz) * _Color.xyz) * 3.0);
  tmpvar_4 = tmpvar_12;
  lowp vec4 tmpvar_13;
  tmpvar_13 = texture2D (_MainTex, xlv_TEXCOORD0.xy);
  lowp float x_14;
  x_14 = (tmpvar_13.w - _Cutoff);
  if ((x_14 < 0.0)) {
    discard;
  };
  lowp vec4 tmpvar_15;
  tmpvar_15 = texture2DProj (_LightBuffer, xlv_TEXCOORD3);
  light_3 = tmpvar_15;
  mediump vec4 tmpvar_16;
  tmpvar_16 = -(log2(max (light_3, vec4(0.001, 0.001, 0.001, 0.001))));
  light_3.w = tmpvar_16.w;
  highp vec3 tmpvar_17;
  tmpvar_17 = (tmpvar_16.xyz + xlv_TEXCOORD4);
  light_3.xyz = tmpvar_17;
  lowp vec4 c_18;
  mediump vec3 tmpvar_19;
  tmpvar_19 = (tmpvar_7 * light_3.xyz);
  c_18.xyz = tmpvar_19;
  c_18.w = tmpvar_13.w;
  c_2 = c_18;
  c_2.xyz = (c_2.xyz + tmpvar_4);
  tmpvar_1 = c_2;
  gl_FragData[0] = tmpvar_1;
}



#endif"
}

SubProgram "d3d11_9x " {
Keywords { "LIGHTMAP_OFF" "DIRLIGHTMAP_OFF" "HDR_LIGHT_PREPASS_OFF" }
Bind "vertex" Vertex
Bind "tangent" TexCoord2
Bind "normal" Normal
Bind "texcoord" TexCoord0
Bind "color" Color
ConstBuffer "$Globals" 128 // 96 used size, 8 vars
Vector 64 [_MainTex_ST] 4
Vector 80 [_BumpMap_ST] 4
ConstBuffer "UnityPerCamera" 128 // 96 used size, 8 vars
Vector 80 [_ProjectionParams] 4
ConstBuffer "UnityLighting" 400 // 400 used size, 16 vars
Vector 288 [unity_SHAr] 4
Vector 304 [unity_SHAg] 4
Vector 320 [unity_SHAb] 4
Vector 336 [unity_SHBr] 4
Vector 352 [unity_SHBg] 4
Vector 368 [unity_SHBb] 4
Vector 384 [unity_SHC] 4
ConstBuffer "UnityPerDraw" 336 // 336 used size, 6 vars
Matrix 0 [glstate_matrix_mvp] 4
Matrix 128 [glstate_matrix_invtrans_modelview0] 4
Matrix 192 [_Object2World] 4
Vector 320 [unity_Scale] 4
BindCB "$Globals" 0
BindCB "UnityPerCamera" 1
BindCB "UnityLighting" 2
BindCB "UnityPerDraw" 3
// 43 instructions, 4 temp regs, 0 temp arrays:
// ALU 23 float, 0 int, 0 uint
// TEX 0 (0 load, 0 comp, 0 bias, 0 grad)
// FLOW 1 static, 0 dynamic
"vs_4_0_level_9_3
eefiecedpcngbnoedphobaihhaadlcokdebdfinjabaaaaaaemalaaaaaeaaaaaa
daaaaaaaniadaaaammajaaaajeakaaaaebgpgodjkaadaaaakaadaaaaaaacpopp
ceadaaaahmaaaaaaahaaceaaaaaahiaaaaaahiaaaaaaceaaabaahiaaaaaaaeaa
acaaabaaaaaaaaaaabaaafaaabaaadaaaaaaaaaaacaabcaaahaaaeaaaaaaaaaa
adaaaaaaaeaaalaaaaaaaaaaadaaaiaaadaaapaaaaaaaaaaadaaamaaadaabcaa
aaaaaaaaadaabeaaabaabfaaaaaaaaaaaaaaaaaaabacpoppfbaaaaafbgaaapka
aaaaaadpaaaaiadpaaaaaaaaaaaaaaaabpaaaaacafaaaaiaaaaaapjabpaaaaac
afaaabiaabaaapjabpaaaaacafaaaciaacaaapjabpaaaaacafaaadiaadaaapja
abaaaaacaaaaabiaapaaaakaabaaaaacaaaaaciabaaaaakaabaaaaacaaaaaeia
bbaaaakaaiaaaaadabaaaboaabaaoejaaaaaoeiaabaaaaacabaaahiaacaaoeja
afaaaaadacaaahiaabaanciaabaamjjaaeaaaaaeabaaahiaabaamjiaabaancja
acaaoeibafaaaaadabaaahiaabaaoeiaabaappjaaiaaaaadabaaacoaabaaoeia
aaaaoeiaaiaaaaadabaaaeoaacaaoejaaaaaoeiaabaaaaacaaaaabiaapaaffka
abaaaaacaaaaaciabaaaffkaabaaaaacaaaaaeiabbaaffkaaiaaaaadacaaaboa
abaaoejaaaaaoeiaaiaaaaadacaaacoaabaaoeiaaaaaoeiaaiaaaaadacaaaeoa
acaaoejaaaaaoeiaaeaaaaaeaaaaadoaadaaoejaabaaoekaabaaookaaeaaaaae
aaaaamoaadaaeejaacaaeekaacaaoekaafaaaaadaaaaapiaaaaaffjaamaaoeka
aeaaaaaeaaaaapiaalaaoekaaaaaaajaaaaaoeiaaeaaaaaeaaaaapiaanaaoeka
aaaakkjaaaaaoeiaaeaaaaaeaaaaapiaaoaaoekaaaaappjaaaaaoeiaafaaaaad
abaaabiaaaaaffiaadaaaakaafaaaaadabaaaiiaabaaaaiabgaaaakaafaaaaad
abaaafiaaaaapeiabgaaaakaacaaaaadadaaadoaabaakkiaabaaomiaafaaaaad
abaaahiaacaaoejabfaappkaafaaaaadacaaahiaabaaffiabdaaoekaaeaaaaae
abaaaliabcaakekaabaaaaiaacaakeiaaeaaaaaeabaaahiabeaaoekaabaakkia
abaapeiaabaaaaacabaaaiiabgaaffkaajaaaaadacaaabiaaeaaoekaabaaoeia
ajaaaaadacaaaciaafaaoekaabaaoeiaajaaaaadacaaaeiaagaaoekaabaaoeia
afaaaaadadaaapiaabaacjiaabaakeiaajaaaaadaeaaabiaahaaoekaadaaoeia
ajaaaaadaeaaaciaaiaaoekaadaaoeiaajaaaaadaeaaaeiaajaaoekaadaaoeia
acaaaaadacaaahiaacaaoeiaaeaaoeiaafaaaaadabaaaciaabaaffiaabaaffia
aeaaaaaeabaaabiaabaaaaiaabaaaaiaabaaffibaeaaaaaeaeaaahoaakaaoeka
abaaaaiaacaaoeiaaeaaaaaeaaaaadmaaaaappiaaaaaoekaaaaaoeiaabaaaaac
aaaaammaaaaaoeiaabaaaaacadaaamoaaaaaoeiappppaaaafdeieefcomafaaaa
eaaaabaahlabaaaafjaaaaaeegiocaaaaaaaaaaaagaaaaaafjaaaaaeegiocaaa
abaaaaaaagaaaaaafjaaaaaeegiocaaaacaaaaaabjaaaaaafjaaaaaeegiocaaa
adaaaaaabfaaaaaafpaaaaadpcbabaaaaaaaaaaafpaaaaadpcbabaaaabaaaaaa
fpaaaaadhcbabaaaacaaaaaafpaaaaaddcbabaaaadaaaaaaghaaaaaepccabaaa
aaaaaaaaabaaaaaagfaaaaadpccabaaaabaaaaaagfaaaaadhccabaaaacaaaaaa
gfaaaaadhccabaaaadaaaaaagfaaaaadpccabaaaaeaaaaaagfaaaaadhccabaaa
afaaaaaagiaaaaacaeaaaaaadiaaaaaipcaabaaaaaaaaaaafgbfbaaaaaaaaaaa
egiocaaaadaaaaaaabaaaaaadcaaaaakpcaabaaaaaaaaaaaegiocaaaadaaaaaa
aaaaaaaaagbabaaaaaaaaaaaegaobaaaaaaaaaaadcaaaaakpcaabaaaaaaaaaaa
egiocaaaadaaaaaaacaaaaaakgbkbaaaaaaaaaaaegaobaaaaaaaaaaadcaaaaak
pcaabaaaaaaaaaaaegiocaaaadaaaaaaadaaaaaapgbpbaaaaaaaaaaaegaobaaa
aaaaaaaadgaaaaafpccabaaaaaaaaaaaegaobaaaaaaaaaaadcaaaaaldccabaaa
abaaaaaaegbabaaaadaaaaaaegiacaaaaaaaaaaaaeaaaaaaogikcaaaaaaaaaaa
aeaaaaaadcaaaaalmccabaaaabaaaaaaagbebaaaadaaaaaaagiecaaaaaaaaaaa
afaaaaaakgiocaaaaaaaaaaaafaaaaaadiaaaaahhcaabaaaabaaaaaajgbebaaa
abaaaaaacgbjbaaaacaaaaaadcaaaaakhcaabaaaabaaaaaajgbebaaaacaaaaaa
cgbjbaaaabaaaaaaegacbaiaebaaaaaaabaaaaaadiaaaaahhcaabaaaabaaaaaa
egacbaaaabaaaaaapgbpbaaaabaaaaaadgaaaaagbcaabaaaacaaaaaaakiacaaa
adaaaaaaaiaaaaaadgaaaaagccaabaaaacaaaaaaakiacaaaadaaaaaaajaaaaaa
dgaaaaagecaabaaaacaaaaaaakiacaaaadaaaaaaakaaaaaabaaaaaahcccabaaa
acaaaaaaegacbaaaabaaaaaaegacbaaaacaaaaaabaaaaaahbccabaaaacaaaaaa
egbcbaaaabaaaaaaegacbaaaacaaaaaabaaaaaaheccabaaaacaaaaaaegbcbaaa
acaaaaaaegacbaaaacaaaaaadgaaaaagbcaabaaaacaaaaaabkiacaaaadaaaaaa
aiaaaaaadgaaaaagccaabaaaacaaaaaabkiacaaaadaaaaaaajaaaaaadgaaaaag
ecaabaaaacaaaaaabkiacaaaadaaaaaaakaaaaaabaaaaaahcccabaaaadaaaaaa
egacbaaaabaaaaaaegacbaaaacaaaaaabaaaaaahbccabaaaadaaaaaaegbcbaaa
abaaaaaaegacbaaaacaaaaaabaaaaaaheccabaaaadaaaaaaegbcbaaaacaaaaaa
egacbaaaacaaaaaadiaaaaaiccaabaaaaaaaaaaabkaabaaaaaaaaaaaakiacaaa
abaaaaaaafaaaaaadiaaaaakncaabaaaabaaaaaaagahbaaaaaaaaaaaaceaaaaa
aaaaaadpaaaaaaaaaaaaaadpaaaaaadpdgaaaaafmccabaaaaeaaaaaakgaobaaa
aaaaaaaaaaaaaaahdccabaaaaeaaaaaakgakbaaaabaaaaaamgaabaaaabaaaaaa
diaaaaaihcaabaaaaaaaaaaaegbcbaaaacaaaaaapgipcaaaadaaaaaabeaaaaaa
diaaaaaihcaabaaaabaaaaaafgafbaaaaaaaaaaaegiccaaaadaaaaaaanaaaaaa
dcaaaaaklcaabaaaaaaaaaaaegiicaaaadaaaaaaamaaaaaaagaabaaaaaaaaaaa
egaibaaaabaaaaaadcaaaaakhcaabaaaaaaaaaaaegiccaaaadaaaaaaaoaaaaaa
kgakbaaaaaaaaaaaegadbaaaaaaaaaaadgaaaaaficaabaaaaaaaaaaaabeaaaaa
aaaaiadpbbaaaaaibcaabaaaabaaaaaaegiocaaaacaaaaaabcaaaaaaegaobaaa
aaaaaaaabbaaaaaiccaabaaaabaaaaaaegiocaaaacaaaaaabdaaaaaaegaobaaa
aaaaaaaabbaaaaaiecaabaaaabaaaaaaegiocaaaacaaaaaabeaaaaaaegaobaaa
aaaaaaaadiaaaaahpcaabaaaacaaaaaajgacbaaaaaaaaaaaegakbaaaaaaaaaaa
bbaaaaaibcaabaaaadaaaaaaegiocaaaacaaaaaabfaaaaaaegaobaaaacaaaaaa
bbaaaaaiccaabaaaadaaaaaaegiocaaaacaaaaaabgaaaaaaegaobaaaacaaaaaa
bbaaaaaiecaabaaaadaaaaaaegiocaaaacaaaaaabhaaaaaaegaobaaaacaaaaaa
aaaaaaahhcaabaaaabaaaaaaegacbaaaabaaaaaaegacbaaaadaaaaaadiaaaaah
ccaabaaaaaaaaaaabkaabaaaaaaaaaaabkaabaaaaaaaaaaadcaaaaakbcaabaaa
aaaaaaaaakaabaaaaaaaaaaaakaabaaaaaaaaaaabkaabaiaebaaaaaaaaaaaaaa
dcaaaaakhccabaaaafaaaaaaegiccaaaacaaaaaabiaaaaaaagaabaaaaaaaaaaa
egacbaaaabaaaaaadoaaaaabejfdeheomaaaaaaaagaaaaaaaiaaaaaajiaaaaaa
aaaaaaaaaaaaaaaaadaaaaaaaaaaaaaaapapaaaakbaaaaaaaaaaaaaaaaaaaaaa
adaaaaaaabaaaaaaapapaaaakjaaaaaaaaaaaaaaaaaaaaaaadaaaaaaacaaaaaa
ahahaaaalaaaaaaaaaaaaaaaaaaaaaaaadaaaaaaadaaaaaaapadaaaalaaaaaaa
abaaaaaaaaaaaaaaadaaaaaaaeaaaaaaapaaaaaaljaaaaaaaaaaaaaaaaaaaaaa
adaaaaaaafaaaaaaapaaaaaafaepfdejfeejepeoaafeebeoehefeofeaaeoepfc
enebemaafeeffiedepepfceeaaedepemepfcaaklepfdeheolaaaaaaaagaaaaaa
aiaaaaaajiaaaaaaaaaaaaaaabaaaaaaadaaaaaaaaaaaaaaapaaaaaakeaaaaaa
aaaaaaaaaaaaaaaaadaaaaaaabaaaaaaapaaaaaakeaaaaaaabaaaaaaaaaaaaaa
adaaaaaaacaaaaaaahaiaaaakeaaaaaaacaaaaaaaaaaaaaaadaaaaaaadaaaaaa
ahaiaaaakeaaaaaaadaaaaaaaaaaaaaaadaaaaaaaeaaaaaaapaaaaaakeaaaaaa
aeaaaaaaaaaaaaaaadaaaaaaafaaaaaaahaiaaaafdfgfpfaepfdejfeejepeoaa
feeffiedepepfceeaaklklkl"
}

SubProgram "opengl " {
Keywords { "LIGHTMAP_ON" "DIRLIGHTMAP_OFF" "HDR_LIGHT_PREPASS_OFF" }
Bind "vertex" Vertex
Bind "tangent" ATTR14
Bind "normal" Normal
Bind "texcoord" TexCoord0
Bind "texcoord1" TexCoord1
Vector 17 [_ProjectionParams]
Vector 18 [unity_ShadowFadeCenterAndType]
Matrix 13 [_Object2World]
Vector 19 [unity_LightmapST]
Vector 20 [_MainTex_ST]
Vector 21 [_BumpMap_ST]
"!!ARBvp1.0
# 31 ALU
PARAM c[22] = { { 0.5, 1 },
		state.matrix.modelview[0],
		state.matrix.mvp,
		state.matrix.modelview[0].invtrans,
		program.local[13..21] };
TEMP R0;
TEMP R1;
TEMP R2;
MOV R0.xyz, vertex.attrib[14];
MUL R1.xyz, vertex.normal.zxyw, R0.yzxw;
MAD R0.xyz, vertex.normal.yzxw, R0.zxyw, -R1;
MUL R2.xyz, R0, vertex.attrib[14].w;
DP4 R0.w, vertex.position, c[8];
DP4 R0.z, vertex.position, c[7];
DP4 R0.x, vertex.position, c[5];
DP4 R0.y, vertex.position, c[6];
MUL R1.xyz, R0.xyww, c[0].x;
MUL R1.y, R1, c[17].x;
ADD result.texcoord[3].xy, R1, R1.z;
MOV result.position, R0;
MOV R0.x, c[0].y;
ADD R0.y, R0.x, -c[18].w;
DP4 R0.x, vertex.position, c[3];
DP4 R1.z, vertex.position, c[15];
DP4 R1.x, vertex.position, c[13];
DP4 R1.y, vertex.position, c[14];
ADD R1.xyz, R1, -c[18];
DP3 result.texcoord[1].y, R2, c[9];
DP3 result.texcoord[2].y, R2, c[10];
MOV result.texcoord[3].zw, R0;
MUL result.texcoord[5].xyz, R1, c[18].w;
MAD result.texcoord[0].zw, vertex.texcoord[0].xyxy, c[21].xyxy, c[21];
MAD result.texcoord[0].xy, vertex.texcoord[0], c[20], c[20].zwzw;
MAD result.texcoord[4].xy, vertex.texcoord[1], c[19], c[19].zwzw;
MUL result.texcoord[5].w, -R0.x, R0.y;
DP3 result.texcoord[1].z, vertex.normal, c[9];
DP3 result.texcoord[1].x, vertex.attrib[14], c[9];
DP3 result.texcoord[2].z, vertex.normal, c[10];
DP3 result.texcoord[2].x, vertex.attrib[14], c[10];
END
# 31 instructions, 3 R-regs
"
}

SubProgram "d3d9 " {
Keywords { "LIGHTMAP_ON" "DIRLIGHTMAP_OFF" "HDR_LIGHT_PREPASS_OFF" }
Bind "vertex" Vertex
Bind "tangent" TexCoord2
Bind "normal" Normal
Bind "texcoord" TexCoord0
Bind "texcoord1" TexCoord1
Matrix 0 [glstate_matrix_modelview0]
Matrix 4 [glstate_matrix_mvp]
Matrix 8 [glstate_matrix_invtrans_modelview0]
Vector 16 [_ProjectionParams]
Vector 17 [_ScreenParams]
Vector 18 [unity_ShadowFadeCenterAndType]
Matrix 12 [_Object2World]
Vector 19 [unity_LightmapST]
Vector 20 [_MainTex_ST]
Vector 21 [_BumpMap_ST]
"vs_2_0
; 32 ALU
def c22, 0.50000000, 1.00000000, 0, 0
dcl_position0 v0
dcl_tangent0 v1
dcl_normal0 v2
dcl_texcoord0 v3
dcl_texcoord1 v4
mov r0.xyz, v1
mul r1.xyz, v2.zxyw, r0.yzxw
mov r0.xyz, v1
mad r0.xyz, v2.yzxw, r0.zxyw, -r1
mul r2.xyz, r0, v1.w
dp4 r0.w, v0, c7
dp4 r0.z, v0, c6
dp4 r0.x, v0, c4
dp4 r0.y, v0, c5
mul r1.xyz, r0.xyww, c22.x
mul r1.y, r1, c16.x
mad oT3.xy, r1.z, c17.zwzw, r1
mov oPos, r0
mov r0.x, c18.w
add r0.y, c22, -r0.x
dp4 r0.x, v0, c2
dp4 r1.z, v0, c14
dp4 r1.x, v0, c12
dp4 r1.y, v0, c13
add r1.xyz, r1, -c18
dp3 oT1.y, r2, c8
dp3 oT2.y, r2, c9
mov oT3.zw, r0
mul oT5.xyz, r1, c18.w
mad oT0.zw, v3.xyxy, c21.xyxy, c21
mad oT0.xy, v3, c20, c20.zwzw
mad oT4.xy, v4, c19, c19.zwzw
mul oT5.w, -r0.x, r0.y
dp3 oT1.z, v2, c8
dp3 oT1.x, v1, c8
dp3 oT2.z, v2, c9
dp3 oT2.x, v1, c9
"
}

SubProgram "d3d11 " {
Keywords { "LIGHTMAP_ON" "DIRLIGHTMAP_OFF" "HDR_LIGHT_PREPASS_OFF" }
Bind "vertex" Vertex
Bind "tangent" TexCoord2
Bind "normal" Normal
Bind "texcoord" TexCoord0
Bind "texcoord1" TexCoord1
Bind "color" Color
ConstBuffer "$Globals" 160 // 112 used size, 10 vars
Vector 64 [unity_LightmapST] 4
Vector 80 [_MainTex_ST] 4
Vector 96 [_BumpMap_ST] 4
ConstBuffer "UnityPerCamera" 128 // 96 used size, 8 vars
Vector 80 [_ProjectionParams] 4
ConstBuffer "UnityShadows" 416 // 416 used size, 8 vars
Vector 400 [unity_ShadowFadeCenterAndType] 4
ConstBuffer "UnityPerDraw" 336 // 256 used size, 6 vars
Matrix 0 [glstate_matrix_mvp] 4
Matrix 64 [glstate_matrix_modelview0] 4
Matrix 128 [glstate_matrix_invtrans_modelview0] 4
Matrix 192 [_Object2World] 4
BindCB "$Globals" 0
BindCB "UnityPerCamera" 1
BindCB "UnityShadows" 2
BindCB "UnityPerDraw" 3
// 40 instructions, 3 temp regs, 0 temp arrays:
// ALU 18 float, 0 int, 0 uint
// TEX 0 (0 load, 0 comp, 0 bias, 0 grad)
// FLOW 1 static, 0 dynamic
"vs_4_0
eefieceddgafdejbhaohagalejpbbjcdgnigfeghabaaaaaakmahaaaaadaaaaaa
cmaaaaaapeaaaaaameabaaaaejfdeheomaaaaaaaagaaaaaaaiaaaaaajiaaaaaa
aaaaaaaaaaaaaaaaadaaaaaaaaaaaaaaapapaaaakbaaaaaaaaaaaaaaaaaaaaaa
adaaaaaaabaaaaaaapapaaaakjaaaaaaaaaaaaaaaaaaaaaaadaaaaaaacaaaaaa
ahahaaaalaaaaaaaaaaaaaaaaaaaaaaaadaaaaaaadaaaaaaapadaaaalaaaaaaa
abaaaaaaaaaaaaaaadaaaaaaaeaaaaaaapadaaaaljaaaaaaaaaaaaaaaaaaaaaa
adaaaaaaafaaaaaaapaaaaaafaepfdejfeejepeoaafeebeoehefeofeaaeoepfc
enebemaafeeffiedepepfceeaaedepemepfcaaklepfdeheomiaaaaaaahaaaaaa
aiaaaaaalaaaaaaaaaaaaaaaabaaaaaaadaaaaaaaaaaaaaaapaaaaaalmaaaaaa
aaaaaaaaaaaaaaaaadaaaaaaabaaaaaaapaaaaaalmaaaaaaabaaaaaaaaaaaaaa
adaaaaaaacaaaaaaahaiaaaalmaaaaaaacaaaaaaaaaaaaaaadaaaaaaadaaaaaa
ahaiaaaalmaaaaaaadaaaaaaaaaaaaaaadaaaaaaaeaaaaaaapaaaaaalmaaaaaa
aeaaaaaaaaaaaaaaadaaaaaaafaaaaaaadamaaaalmaaaaaaafaaaaaaaaaaaaaa
adaaaaaaagaaaaaaapaaaaaafdfgfpfaepfdejfeejepeoaafeeffiedepepfcee
aaklklklfdeieefcoaafaaaaeaaaabaahiabaaaafjaaaaaeegiocaaaaaaaaaaa
ahaaaaaafjaaaaaeegiocaaaabaaaaaaagaaaaaafjaaaaaeegiocaaaacaaaaaa
bkaaaaaafjaaaaaeegiocaaaadaaaaaabaaaaaaafpaaaaadpcbabaaaaaaaaaaa
fpaaaaadpcbabaaaabaaaaaafpaaaaadhcbabaaaacaaaaaafpaaaaaddcbabaaa
adaaaaaafpaaaaaddcbabaaaaeaaaaaaghaaaaaepccabaaaaaaaaaaaabaaaaaa
gfaaaaadpccabaaaabaaaaaagfaaaaadhccabaaaacaaaaaagfaaaaadhccabaaa
adaaaaaagfaaaaadpccabaaaaeaaaaaagfaaaaaddccabaaaafaaaaaagfaaaaad
pccabaaaagaaaaaagiaaaaacadaaaaaadiaaaaaipcaabaaaaaaaaaaafgbfbaaa
aaaaaaaaegiocaaaadaaaaaaabaaaaaadcaaaaakpcaabaaaaaaaaaaaegiocaaa
adaaaaaaaaaaaaaaagbabaaaaaaaaaaaegaobaaaaaaaaaaadcaaaaakpcaabaaa
aaaaaaaaegiocaaaadaaaaaaacaaaaaakgbkbaaaaaaaaaaaegaobaaaaaaaaaaa
dcaaaaakpcaabaaaaaaaaaaaegiocaaaadaaaaaaadaaaaaapgbpbaaaaaaaaaaa
egaobaaaaaaaaaaadgaaaaafpccabaaaaaaaaaaaegaobaaaaaaaaaaadcaaaaal
dccabaaaabaaaaaaegbabaaaadaaaaaaegiacaaaaaaaaaaaafaaaaaaogikcaaa
aaaaaaaaafaaaaaadcaaaaalmccabaaaabaaaaaaagbebaaaadaaaaaaagiecaaa
aaaaaaaaagaaaaaakgiocaaaaaaaaaaaagaaaaaadiaaaaahhcaabaaaabaaaaaa
jgbebaaaabaaaaaacgbjbaaaacaaaaaadcaaaaakhcaabaaaabaaaaaajgbebaaa
acaaaaaacgbjbaaaabaaaaaaegacbaiaebaaaaaaabaaaaaadiaaaaahhcaabaaa
abaaaaaaegacbaaaabaaaaaapgbpbaaaabaaaaaadgaaaaagbcaabaaaacaaaaaa
akiacaaaadaaaaaaaiaaaaaadgaaaaagccaabaaaacaaaaaaakiacaaaadaaaaaa
ajaaaaaadgaaaaagecaabaaaacaaaaaaakiacaaaadaaaaaaakaaaaaabaaaaaah
cccabaaaacaaaaaaegacbaaaabaaaaaaegacbaaaacaaaaaabaaaaaahbccabaaa
acaaaaaaegbcbaaaabaaaaaaegacbaaaacaaaaaabaaaaaaheccabaaaacaaaaaa
egbcbaaaacaaaaaaegacbaaaacaaaaaadgaaaaagbcaabaaaacaaaaaabkiacaaa
adaaaaaaaiaaaaaadgaaaaagccaabaaaacaaaaaabkiacaaaadaaaaaaajaaaaaa
dgaaaaagecaabaaaacaaaaaabkiacaaaadaaaaaaakaaaaaabaaaaaahcccabaaa
adaaaaaaegacbaaaabaaaaaaegacbaaaacaaaaaabaaaaaahbccabaaaadaaaaaa
egbcbaaaabaaaaaaegacbaaaacaaaaaabaaaaaaheccabaaaadaaaaaaegbcbaaa
acaaaaaaegacbaaaacaaaaaadiaaaaaiccaabaaaaaaaaaaabkaabaaaaaaaaaaa
akiacaaaabaaaaaaafaaaaaadiaaaaakncaabaaaabaaaaaaagahbaaaaaaaaaaa
aceaaaaaaaaaaadpaaaaaaaaaaaaaadpaaaaaadpdgaaaaafmccabaaaaeaaaaaa
kgaobaaaaaaaaaaaaaaaaaahdccabaaaaeaaaaaakgakbaaaabaaaaaamgaabaaa
abaaaaaadcaaaaaldccabaaaafaaaaaaegbabaaaaeaaaaaaegiacaaaaaaaaaaa
aeaaaaaaogikcaaaaaaaaaaaaeaaaaaadiaaaaaihcaabaaaaaaaaaaafgbfbaaa
aaaaaaaaegiccaaaadaaaaaaanaaaaaadcaaaaakhcaabaaaaaaaaaaaegiccaaa
adaaaaaaamaaaaaaagbabaaaaaaaaaaaegacbaaaaaaaaaaadcaaaaakhcaabaaa
aaaaaaaaegiccaaaadaaaaaaaoaaaaaakgbkbaaaaaaaaaaaegacbaaaaaaaaaaa
dcaaaaakhcaabaaaaaaaaaaaegiccaaaadaaaaaaapaaaaaapgbpbaaaaaaaaaaa
egacbaaaaaaaaaaaaaaaaaajhcaabaaaaaaaaaaaegacbaaaaaaaaaaaegiccaia
ebaaaaaaacaaaaaabjaaaaaadiaaaaaihccabaaaagaaaaaaegacbaaaaaaaaaaa
pgipcaaaacaaaaaabjaaaaaadiaaaaaibcaabaaaaaaaaaaabkbabaaaaaaaaaaa
ckiacaaaadaaaaaaafaaaaaadcaaaaakbcaabaaaaaaaaaaackiacaaaadaaaaaa
aeaaaaaaakbabaaaaaaaaaaaakaabaaaaaaaaaaadcaaaaakbcaabaaaaaaaaaaa
ckiacaaaadaaaaaaagaaaaaackbabaaaaaaaaaaaakaabaaaaaaaaaaadcaaaaak
bcaabaaaaaaaaaaackiacaaaadaaaaaaahaaaaaadkbabaaaaaaaaaaaakaabaaa
aaaaaaaaaaaaaaajccaabaaaaaaaaaaadkiacaiaebaaaaaaacaaaaaabjaaaaaa
abeaaaaaaaaaiadpdiaaaaaiiccabaaaagaaaaaabkaabaaaaaaaaaaaakaabaia
ebaaaaaaaaaaaaaadoaaaaab"
}

SubProgram "gles " {
Keywords { "LIGHTMAP_ON" "DIRLIGHTMAP_OFF" "HDR_LIGHT_PREPASS_OFF" }
"!!GLES
#define SHADER_API_GLES 1
#define tex2D texture2D


#ifdef VERTEX
#define gl_ModelViewProjectionMatrix glstate_matrix_mvp
uniform mat4 glstate_matrix_mvp;
#define gl_ModelViewMatrixInverseTranspose glstate_matrix_invtrans_modelview0
uniform mat4 glstate_matrix_invtrans_modelview0;
#define gl_ModelViewMatrix glstate_matrix_modelview0
uniform mat4 glstate_matrix_modelview0;

varying highp vec4 xlv_TEXCOORD5;
varying highp vec2 xlv_TEXCOORD4;
varying highp vec4 xlv_TEXCOORD3;
varying highp vec3 xlv_TEXCOORD2;
varying highp vec3 xlv_TEXCOORD1;
varying highp vec4 xlv_TEXCOORD0;
uniform highp vec4 _BumpMap_ST;
uniform highp vec4 _MainTex_ST;
uniform highp vec4 unity_LightmapST;
uniform highp mat4 _Object2World;



uniform highp vec4 unity_ShadowFadeCenterAndType;
uniform highp vec4 _ProjectionParams;
attribute vec4 _glesTANGENT;
attribute vec4 _glesMultiTexCoord1;
attribute vec4 _glesMultiTexCoord0;
attribute vec3 _glesNormal;
attribute vec4 _glesVertex;
void main ()
{
  vec4 tmpvar_1;
  tmpvar_1.xyz = normalize(_glesTANGENT.xyz);
  tmpvar_1.w = _glesTANGENT.w;
  vec3 tmpvar_2;
  tmpvar_2 = normalize(_glesNormal);
  highp vec4 tmpvar_3;
  highp vec4 tmpvar_4;
  highp vec3 tmpvar_5;
  highp vec3 tmpvar_6;
  tmpvar_5 = tmpvar_1.xyz;
  tmpvar_6 = (((tmpvar_2.yzx * tmpvar_1.zxy) - (tmpvar_2.zxy * tmpvar_1.yzx)) * _glesTANGENT.w);
  highp mat3 tmpvar_7;
  tmpvar_7[0].x = tmpvar_5.x;
  tmpvar_7[0].y = tmpvar_6.x;
  tmpvar_7[0].z = tmpvar_2.x;
  tmpvar_7[1].x = tmpvar_5.y;
  tmpvar_7[1].y = tmpvar_6.y;
  tmpvar_7[1].z = tmpvar_2.y;
  tmpvar_7[2].x = tmpvar_5.z;
  tmpvar_7[2].y = tmpvar_6.z;
  tmpvar_7[2].z = tmpvar_2.z;
  vec4 v_8;
  v_8.x = gl_ModelViewMatrixInverseTranspose[0].x;
  v_8.y = gl_ModelViewMatrixInverseTranspose[1].x;
  v_8.z = gl_ModelViewMatrixInverseTranspose[2].x;
  v_8.w = gl_ModelViewMatrixInverseTranspose[3].x;
  vec4 v_9;
  v_9.x = gl_ModelViewMatrixInverseTranspose[0].y;
  v_9.y = gl_ModelViewMatrixInverseTranspose[1].y;
  v_9.z = gl_ModelViewMatrixInverseTranspose[2].y;
  v_9.w = gl_ModelViewMatrixInverseTranspose[3].y;
  highp vec4 tmpvar_10;
  tmpvar_10 = (gl_ModelViewProjectionMatrix * _glesVertex);
  tmpvar_3.xy = ((_glesMultiTexCoord0.xy * _MainTex_ST.xy) + _MainTex_ST.zw);
  tmpvar_3.zw = ((_glesMultiTexCoord0.xy * _BumpMap_ST.xy) + _BumpMap_ST.zw);
  highp vec4 o_11;
  highp vec4 tmpvar_12;
  tmpvar_12 = (tmpvar_10 * 0.5);
  highp vec2 tmpvar_13;
  tmpvar_13.x = tmpvar_12.x;
  tmpvar_13.y = (tmpvar_12.y * _ProjectionParams.x);
  o_11.xy = (tmpvar_13 + tmpvar_12.w);
  o_11.zw = tmpvar_10.zw;
  tmpvar_4.xyz = (((_Object2World * _glesVertex).xyz - unity_ShadowFadeCenterAndType.xyz) * unity_ShadowFadeCenterAndType.w);
  tmpvar_4.w = (-((gl_ModelViewMatrix * _glesVertex).z) * (1.0 - unity_ShadowFadeCenterAndType.w));
  gl_Position = tmpvar_10;
  xlv_TEXCOORD0 = tmpvar_3;
  xlv_TEXCOORD1 = (tmpvar_7 * v_8.xyz);
  xlv_TEXCOORD2 = (tmpvar_7 * v_9.xyz);
  xlv_TEXCOORD3 = o_11;
  xlv_TEXCOORD4 = ((_glesMultiTexCoord1.xy * unity_LightmapST.xy) + unity_LightmapST.zw);
  xlv_TEXCOORD5 = tmpvar_4;
}



#endif
#ifdef FRAGMENT

varying highp vec4 xlv_TEXCOORD5;
varying highp vec2 xlv_TEXCOORD4;
varying highp vec4 xlv_TEXCOORD3;
varying highp vec3 xlv_TEXCOORD2;
varying highp vec3 xlv_TEXCOORD1;
varying highp vec4 xlv_TEXCOORD0;
uniform lowp float _Cutoff;
uniform highp vec4 unity_LightmapFade;
uniform sampler2D unity_LightmapInd;
uniform sampler2D unity_Lightmap;
uniform sampler2D _LightBuffer;
uniform sampler2D _Shade;
uniform sampler2D _BumpMap;
uniform sampler2D _MainTex;
uniform lowp vec4 _Color;
void main ()
{
  lowp vec4 tmpvar_1;
  mediump vec4 c_2;
  mediump vec3 lmIndirect_3;
  mediump vec3 lmFull_4;
  mediump vec4 light_5;
  lowp vec3 tmpvar_6;
  highp vec3 matcap_7;
  lowp vec3 tmpvar_8;
  tmpvar_8 = ((texture2D (_BumpMap, xlv_TEXCOORD0.zw).xyz * 2.0) - 1.0);
  lowp vec3 tmpvar_9;
  tmpvar_9 = (texture2D (_MainTex, xlv_TEXCOORD0.xy).xyz * _Color.w);
  highp vec2 tmpvar_10;
  tmpvar_10.x = dot (xlv_TEXCOORD1, tmpvar_8);
  tmpvar_10.y = dot (xlv_TEXCOORD2, tmpvar_8);
  highp vec2 P_11;
  P_11 = ((tmpvar_10 * 0.5) + 0.5);
  lowp vec3 tmpvar_12;
  tmpvar_12 = texture2D (_Shade, P_11).xyz;
  matcap_7 = tmpvar_12;
  lowp vec4 tmpvar_13;
  tmpvar_13 = texture2D (_MainTex, xlv_TEXCOORD0.xy);
  highp vec3 tmpvar_14;
  tmpvar_14 = (((matcap_7 * tmpvar_13.xyz) * _Color.xyz) * 3.0);
  tmpvar_6 = tmpvar_14;
  lowp vec4 tmpvar_15;
  tmpvar_15 = texture2D (_MainTex, xlv_TEXCOORD0.xy);
  lowp float x_16;
  x_16 = (tmpvar_15.w - _Cutoff);
  if ((x_16 < 0.0)) {
    discard;
  };
  lowp vec4 tmpvar_17;
  tmpvar_17 = texture2DProj (_LightBuffer, xlv_TEXCOORD3);
  light_5 = tmpvar_17;
  mediump vec4 tmpvar_18;
  tmpvar_18 = -(log2(max (light_5, vec4(0.001, 0.001, 0.001, 0.001))));
  light_5.w = tmpvar_18.w;
  lowp vec3 tmpvar_19;
  tmpvar_19 = (2.0 * texture2D (unity_Lightmap, xlv_TEXCOORD4).xyz);
  lmFull_4 = tmpvar_19;
  lowp vec3 tmpvar_20;
  tmpvar_20 = (2.0 * texture2D (unity_LightmapInd, xlv_TEXCOORD4).xyz);
  lmIndirect_3 = tmpvar_20;
  highp float tmpvar_21;
  tmpvar_21 = clamp (((sqrt(dot (xlv_TEXCOORD5, xlv_TEXCOORD5)) * unity_LightmapFade.z) + unity_LightmapFade.w), 0.0, 1.0);
  light_5.xyz = (tmpvar_18.xyz + mix (lmIndirect_3, lmFull_4, vec3(tmpvar_21)));
  lowp vec4 c_22;
  mediump vec3 tmpvar_23;
  tmpvar_23 = (tmpvar_9 * light_5.xyz);
  c_22.xyz = tmpvar_23;
  c_22.w = tmpvar_15.w;
  c_2 = c_22;
  c_2.xyz = (c_2.xyz + tmpvar_6);
  tmpvar_1 = c_2;
  gl_FragData[0] = tmpvar_1;
}



#endif"
}

SubProgram "glesdesktop " {
Keywords { "LIGHTMAP_ON" "DIRLIGHTMAP_OFF" "HDR_LIGHT_PREPASS_OFF" }
"!!GLES
#define SHADER_API_GLES 1
#define tex2D texture2D


#ifdef VERTEX
#define gl_ModelViewProjectionMatrix glstate_matrix_mvp
uniform mat4 glstate_matrix_mvp;
#define gl_ModelViewMatrixInverseTranspose glstate_matrix_invtrans_modelview0
uniform mat4 glstate_matrix_invtrans_modelview0;
#define gl_ModelViewMatrix glstate_matrix_modelview0
uniform mat4 glstate_matrix_modelview0;

varying highp vec4 xlv_TEXCOORD5;
varying highp vec2 xlv_TEXCOORD4;
varying highp vec4 xlv_TEXCOORD3;
varying highp vec3 xlv_TEXCOORD2;
varying highp vec3 xlv_TEXCOORD1;
varying highp vec4 xlv_TEXCOORD0;
uniform highp vec4 _BumpMap_ST;
uniform highp vec4 _MainTex_ST;
uniform highp vec4 unity_LightmapST;
uniform highp mat4 _Object2World;



uniform highp vec4 unity_ShadowFadeCenterAndType;
uniform highp vec4 _ProjectionParams;
attribute vec4 _glesTANGENT;
attribute vec4 _glesMultiTexCoord1;
attribute vec4 _glesMultiTexCoord0;
attribute vec3 _glesNormal;
attribute vec4 _glesVertex;
void main ()
{
  vec4 tmpvar_1;
  tmpvar_1.xyz = normalize(_glesTANGENT.xyz);
  tmpvar_1.w = _glesTANGENT.w;
  vec3 tmpvar_2;
  tmpvar_2 = normalize(_glesNormal);
  highp vec4 tmpvar_3;
  highp vec4 tmpvar_4;
  highp vec3 tmpvar_5;
  highp vec3 tmpvar_6;
  tmpvar_5 = tmpvar_1.xyz;
  tmpvar_6 = (((tmpvar_2.yzx * tmpvar_1.zxy) - (tmpvar_2.zxy * tmpvar_1.yzx)) * _glesTANGENT.w);
  highp mat3 tmpvar_7;
  tmpvar_7[0].x = tmpvar_5.x;
  tmpvar_7[0].y = tmpvar_6.x;
  tmpvar_7[0].z = tmpvar_2.x;
  tmpvar_7[1].x = tmpvar_5.y;
  tmpvar_7[1].y = tmpvar_6.y;
  tmpvar_7[1].z = tmpvar_2.y;
  tmpvar_7[2].x = tmpvar_5.z;
  tmpvar_7[2].y = tmpvar_6.z;
  tmpvar_7[2].z = tmpvar_2.z;
  vec4 v_8;
  v_8.x = gl_ModelViewMatrixInverseTranspose[0].x;
  v_8.y = gl_ModelViewMatrixInverseTranspose[1].x;
  v_8.z = gl_ModelViewMatrixInverseTranspose[2].x;
  v_8.w = gl_ModelViewMatrixInverseTranspose[3].x;
  vec4 v_9;
  v_9.x = gl_ModelViewMatrixInverseTranspose[0].y;
  v_9.y = gl_ModelViewMatrixInverseTranspose[1].y;
  v_9.z = gl_ModelViewMatrixInverseTranspose[2].y;
  v_9.w = gl_ModelViewMatrixInverseTranspose[3].y;
  highp vec4 tmpvar_10;
  tmpvar_10 = (gl_ModelViewProjectionMatrix * _glesVertex);
  tmpvar_3.xy = ((_glesMultiTexCoord0.xy * _MainTex_ST.xy) + _MainTex_ST.zw);
  tmpvar_3.zw = ((_glesMultiTexCoord0.xy * _BumpMap_ST.xy) + _BumpMap_ST.zw);
  highp vec4 o_11;
  highp vec4 tmpvar_12;
  tmpvar_12 = (tmpvar_10 * 0.5);
  highp vec2 tmpvar_13;
  tmpvar_13.x = tmpvar_12.x;
  tmpvar_13.y = (tmpvar_12.y * _ProjectionParams.x);
  o_11.xy = (tmpvar_13 + tmpvar_12.w);
  o_11.zw = tmpvar_10.zw;
  tmpvar_4.xyz = (((_Object2World * _glesVertex).xyz - unity_ShadowFadeCenterAndType.xyz) * unity_ShadowFadeCenterAndType.w);
  tmpvar_4.w = (-((gl_ModelViewMatrix * _glesVertex).z) * (1.0 - unity_ShadowFadeCenterAndType.w));
  gl_Position = tmpvar_10;
  xlv_TEXCOORD0 = tmpvar_3;
  xlv_TEXCOORD1 = (tmpvar_7 * v_8.xyz);
  xlv_TEXCOORD2 = (tmpvar_7 * v_9.xyz);
  xlv_TEXCOORD3 = o_11;
  xlv_TEXCOORD4 = ((_glesMultiTexCoord1.xy * unity_LightmapST.xy) + unity_LightmapST.zw);
  xlv_TEXCOORD5 = tmpvar_4;
}



#endif
#ifdef FRAGMENT

varying highp vec4 xlv_TEXCOORD5;
varying highp vec2 xlv_TEXCOORD4;
varying highp vec4 xlv_TEXCOORD3;
varying highp vec3 xlv_TEXCOORD2;
varying highp vec3 xlv_TEXCOORD1;
varying highp vec4 xlv_TEXCOORD0;
uniform lowp float _Cutoff;
uniform highp vec4 unity_LightmapFade;
uniform sampler2D unity_LightmapInd;
uniform sampler2D unity_Lightmap;
uniform sampler2D _LightBuffer;
uniform sampler2D _Shade;
uniform sampler2D _BumpMap;
uniform sampler2D _MainTex;
uniform lowp vec4 _Color;
void main ()
{
  lowp vec4 tmpvar_1;
  mediump vec4 c_2;
  mediump vec3 lmIndirect_3;
  mediump vec3 lmFull_4;
  mediump vec4 light_5;
  lowp vec3 tmpvar_6;
  highp vec3 matcap_7;
  lowp vec3 normal_8;
  normal_8.xy = ((texture2D (_BumpMap, xlv_TEXCOORD0.zw).wy * 2.0) - 1.0);
  normal_8.z = sqrt(((1.0 - (normal_8.x * normal_8.x)) - (normal_8.y * normal_8.y)));
  lowp vec3 tmpvar_9;
  tmpvar_9 = (texture2D (_MainTex, xlv_TEXCOORD0.xy).xyz * _Color.w);
  highp vec2 tmpvar_10;
  tmpvar_10.x = dot (xlv_TEXCOORD1, normal_8);
  tmpvar_10.y = dot (xlv_TEXCOORD2, normal_8);
  highp vec2 P_11;
  P_11 = ((tmpvar_10 * 0.5) + 0.5);
  lowp vec3 tmpvar_12;
  tmpvar_12 = texture2D (_Shade, P_11).xyz;
  matcap_7 = tmpvar_12;
  lowp vec4 tmpvar_13;
  tmpvar_13 = texture2D (_MainTex, xlv_TEXCOORD0.xy);
  highp vec3 tmpvar_14;
  tmpvar_14 = (((matcap_7 * tmpvar_13.xyz) * _Color.xyz) * 3.0);
  tmpvar_6 = tmpvar_14;
  lowp vec4 tmpvar_15;
  tmpvar_15 = texture2D (_MainTex, xlv_TEXCOORD0.xy);
  lowp float x_16;
  x_16 = (tmpvar_15.w - _Cutoff);
  if ((x_16 < 0.0)) {
    discard;
  };
  lowp vec4 tmpvar_17;
  tmpvar_17 = texture2DProj (_LightBuffer, xlv_TEXCOORD3);
  light_5 = tmpvar_17;
  mediump vec4 tmpvar_18;
  tmpvar_18 = -(log2(max (light_5, vec4(0.001, 0.001, 0.001, 0.001))));
  light_5.w = tmpvar_18.w;
  lowp vec4 tmpvar_19;
  tmpvar_19 = texture2D (unity_Lightmap, xlv_TEXCOORD4);
  lowp vec3 tmpvar_20;
  tmpvar_20 = ((8.0 * tmpvar_19.w) * tmpvar_19.xyz);
  lmFull_4 = tmpvar_20;
  lowp vec4 tmpvar_21;
  tmpvar_21 = texture2D (unity_LightmapInd, xlv_TEXCOORD4);
  lowp vec3 tmpvar_22;
  tmpvar_22 = ((8.0 * tmpvar_21.w) * tmpvar_21.xyz);
  lmIndirect_3 = tmpvar_22;
  highp float tmpvar_23;
  tmpvar_23 = clamp (((sqrt(dot (xlv_TEXCOORD5, xlv_TEXCOORD5)) * unity_LightmapFade.z) + unity_LightmapFade.w), 0.0, 1.0);
  light_5.xyz = (tmpvar_18.xyz + mix (lmIndirect_3, lmFull_4, vec3(tmpvar_23)));
  lowp vec4 c_24;
  mediump vec3 tmpvar_25;
  tmpvar_25 = (tmpvar_9 * light_5.xyz);
  c_24.xyz = tmpvar_25;
  c_24.w = tmpvar_15.w;
  c_2 = c_24;
  c_2.xyz = (c_2.xyz + tmpvar_6);
  tmpvar_1 = c_2;
  gl_FragData[0] = tmpvar_1;
}



#endif"
}

SubProgram "d3d11_9x " {
Keywords { "LIGHTMAP_ON" "DIRLIGHTMAP_OFF" "HDR_LIGHT_PREPASS_OFF" }
Bind "vertex" Vertex
Bind "tangent" TexCoord2
Bind "normal" Normal
Bind "texcoord" TexCoord0
Bind "texcoord1" TexCoord1
Bind "color" Color
ConstBuffer "$Globals" 160 // 112 used size, 10 vars
Vector 64 [unity_LightmapST] 4
Vector 80 [_MainTex_ST] 4
Vector 96 [_BumpMap_ST] 4
ConstBuffer "UnityPerCamera" 128 // 96 used size, 8 vars
Vector 80 [_ProjectionParams] 4
ConstBuffer "UnityShadows" 416 // 416 used size, 8 vars
Vector 400 [unity_ShadowFadeCenterAndType] 4
ConstBuffer "UnityPerDraw" 336 // 256 used size, 6 vars
Matrix 0 [glstate_matrix_mvp] 4
Matrix 64 [glstate_matrix_modelview0] 4
Matrix 128 [glstate_matrix_invtrans_modelview0] 4
Matrix 192 [_Object2World] 4
BindCB "$Globals" 0
BindCB "UnityPerCamera" 1
BindCB "UnityShadows" 2
BindCB "UnityPerDraw" 3
// 40 instructions, 3 temp regs, 0 temp arrays:
// ALU 18 float, 0 int, 0 uint
// TEX 0 (0 load, 0 comp, 0 bias, 0 grad)
// FLOW 1 static, 0 dynamic
"vs_4_0_level_9_3
eefiecedkjkgfcgncfidgilmnklclfbimddhgoloabaaaaaadialaaaaaeaaaaaa
daaaaaaaliadaaaakaajaaaagiakaaaaebgpgodjiaadaaaaiaadaaaaaaacpopp
bmadaaaageaaaaaaafaaceaaaaaagaaaaaaagaaaaaaaceaaabaagaaaaaaaaeaa
adaaabaaaaaaaaaaabaaafaaabaaaeaaaaaaaaaaacaabjaaabaaafaaaaaaaaaa
adaaaaaaalaaagaaaaaaaaaaadaaamaaaeaabbaaaaaaaaaaaaaaaaaaabacpopp
fbaaaaafbfaaapkaaaaaaadpaaaaiadpaaaaaaaaaaaaaaaabpaaaaacafaaaaia
aaaaapjabpaaaaacafaaabiaabaaapjabpaaaaacafaaaciaacaaapjabpaaaaac
afaaadiaadaaapjabpaaaaacafaaaeiaaeaaapjaabaaaaacaaaaabiaaoaaaaka
abaaaaacaaaaaciaapaaaakaabaaaaacaaaaaeiabaaaaakaaiaaaaadabaaaboa
abaaoejaaaaaoeiaabaaaaacabaaahiaabaaoejaafaaaaadacaaahiaabaamjia
acaancjaaeaaaaaeabaaahiaacaamjjaabaanciaacaaoeibafaaaaadabaaahia
abaaoeiaabaappjaaiaaaaadabaaacoaabaaoeiaaaaaoeiaaiaaaaadabaaaeoa
acaaoejaaaaaoeiaabaaaaacaaaaabiaaoaaffkaabaaaaacaaaaaciaapaaffka
abaaaaacaaaaaeiabaaaffkaaiaaaaadacaaaboaabaaoejaaaaaoeiaaiaaaaad
acaaacoaabaaoeiaaaaaoeiaaiaaaaadacaaaeoaacaaoejaaaaaoeiaaeaaaaae
aaaaadoaadaaoejaacaaoekaacaaookaaeaaaaaeaaaaamoaadaaeejaadaaeeka
adaaoekaafaaaaadaaaaapiaaaaaffjaahaaoekaaeaaaaaeaaaaapiaagaaoeka
aaaaaajaaaaaoeiaaeaaaaaeaaaaapiaaiaaoekaaaaakkjaaaaaoeiaaeaaaaae
aaaaapiaajaaoekaaaaappjaaaaaoeiaafaaaaadabaaabiaaaaaffiaaeaaaaka
afaaaaadabaaaiiaabaaaaiabfaaaakaafaaaaadabaaafiaaaaapeiabfaaaaka
acaaaaadadaaadoaabaakkiaabaaomiaaeaaaaaeaeaaadoaaeaaoejaabaaoeka
abaaookaafaaaaadabaaahiaaaaaffjabcaaoekaaeaaaaaeabaaahiabbaaoeka
aaaaaajaabaaoeiaaeaaaaaeabaaahiabdaaoekaaaaakkjaabaaoeiaaeaaaaae
abaaahiabeaaoekaaaaappjaabaaoeiaacaaaaadabaaahiaabaaoeiaafaaoekb
afaaaaadafaaahoaabaaoeiaafaappkaafaaaaadabaaabiaaaaaffjaalaakkka
aeaaaaaeabaaabiaakaakkkaaaaaaajaabaaaaiaaeaaaaaeabaaabiaamaakkka
aaaakkjaabaaaaiaaeaaaaaeabaaabiaanaakkkaaaaappjaabaaaaiaabaaaaac
abaaaiiaafaappkaacaaaaadabaaaciaabaappibbfaaffkaafaaaaadafaaaioa
abaaffiaabaaaaibaeaaaaaeaaaaadmaaaaappiaaaaaoekaaaaaoeiaabaaaaac
aaaaammaaaaaoeiaabaaaaacadaaamoaaaaaoeiappppaaaafdeieefcoaafaaaa
eaaaabaahiabaaaafjaaaaaeegiocaaaaaaaaaaaahaaaaaafjaaaaaeegiocaaa
abaaaaaaagaaaaaafjaaaaaeegiocaaaacaaaaaabkaaaaaafjaaaaaeegiocaaa
adaaaaaabaaaaaaafpaaaaadpcbabaaaaaaaaaaafpaaaaadpcbabaaaabaaaaaa
fpaaaaadhcbabaaaacaaaaaafpaaaaaddcbabaaaadaaaaaafpaaaaaddcbabaaa
aeaaaaaaghaaaaaepccabaaaaaaaaaaaabaaaaaagfaaaaadpccabaaaabaaaaaa
gfaaaaadhccabaaaacaaaaaagfaaaaadhccabaaaadaaaaaagfaaaaadpccabaaa
aeaaaaaagfaaaaaddccabaaaafaaaaaagfaaaaadpccabaaaagaaaaaagiaaaaac
adaaaaaadiaaaaaipcaabaaaaaaaaaaafgbfbaaaaaaaaaaaegiocaaaadaaaaaa
abaaaaaadcaaaaakpcaabaaaaaaaaaaaegiocaaaadaaaaaaaaaaaaaaagbabaaa
aaaaaaaaegaobaaaaaaaaaaadcaaaaakpcaabaaaaaaaaaaaegiocaaaadaaaaaa
acaaaaaakgbkbaaaaaaaaaaaegaobaaaaaaaaaaadcaaaaakpcaabaaaaaaaaaaa
egiocaaaadaaaaaaadaaaaaapgbpbaaaaaaaaaaaegaobaaaaaaaaaaadgaaaaaf
pccabaaaaaaaaaaaegaobaaaaaaaaaaadcaaaaaldccabaaaabaaaaaaegbabaaa
adaaaaaaegiacaaaaaaaaaaaafaaaaaaogikcaaaaaaaaaaaafaaaaaadcaaaaal
mccabaaaabaaaaaaagbebaaaadaaaaaaagiecaaaaaaaaaaaagaaaaaakgiocaaa
aaaaaaaaagaaaaaadiaaaaahhcaabaaaabaaaaaajgbebaaaabaaaaaacgbjbaaa
acaaaaaadcaaaaakhcaabaaaabaaaaaajgbebaaaacaaaaaacgbjbaaaabaaaaaa
egacbaiaebaaaaaaabaaaaaadiaaaaahhcaabaaaabaaaaaaegacbaaaabaaaaaa
pgbpbaaaabaaaaaadgaaaaagbcaabaaaacaaaaaaakiacaaaadaaaaaaaiaaaaaa
dgaaaaagccaabaaaacaaaaaaakiacaaaadaaaaaaajaaaaaadgaaaaagecaabaaa
acaaaaaaakiacaaaadaaaaaaakaaaaaabaaaaaahcccabaaaacaaaaaaegacbaaa
abaaaaaaegacbaaaacaaaaaabaaaaaahbccabaaaacaaaaaaegbcbaaaabaaaaaa
egacbaaaacaaaaaabaaaaaaheccabaaaacaaaaaaegbcbaaaacaaaaaaegacbaaa
acaaaaaadgaaaaagbcaabaaaacaaaaaabkiacaaaadaaaaaaaiaaaaaadgaaaaag
ccaabaaaacaaaaaabkiacaaaadaaaaaaajaaaaaadgaaaaagecaabaaaacaaaaaa
bkiacaaaadaaaaaaakaaaaaabaaaaaahcccabaaaadaaaaaaegacbaaaabaaaaaa
egacbaaaacaaaaaabaaaaaahbccabaaaadaaaaaaegbcbaaaabaaaaaaegacbaaa
acaaaaaabaaaaaaheccabaaaadaaaaaaegbcbaaaacaaaaaaegacbaaaacaaaaaa
diaaaaaiccaabaaaaaaaaaaabkaabaaaaaaaaaaaakiacaaaabaaaaaaafaaaaaa
diaaaaakncaabaaaabaaaaaaagahbaaaaaaaaaaaaceaaaaaaaaaaadpaaaaaaaa
aaaaaadpaaaaaadpdgaaaaafmccabaaaaeaaaaaakgaobaaaaaaaaaaaaaaaaaah
dccabaaaaeaaaaaakgakbaaaabaaaaaamgaabaaaabaaaaaadcaaaaaldccabaaa
afaaaaaaegbabaaaaeaaaaaaegiacaaaaaaaaaaaaeaaaaaaogikcaaaaaaaaaaa
aeaaaaaadiaaaaaihcaabaaaaaaaaaaafgbfbaaaaaaaaaaaegiccaaaadaaaaaa
anaaaaaadcaaaaakhcaabaaaaaaaaaaaegiccaaaadaaaaaaamaaaaaaagbabaaa
aaaaaaaaegacbaaaaaaaaaaadcaaaaakhcaabaaaaaaaaaaaegiccaaaadaaaaaa
aoaaaaaakgbkbaaaaaaaaaaaegacbaaaaaaaaaaadcaaaaakhcaabaaaaaaaaaaa
egiccaaaadaaaaaaapaaaaaapgbpbaaaaaaaaaaaegacbaaaaaaaaaaaaaaaaaaj
hcaabaaaaaaaaaaaegacbaaaaaaaaaaaegiccaiaebaaaaaaacaaaaaabjaaaaaa
diaaaaaihccabaaaagaaaaaaegacbaaaaaaaaaaapgipcaaaacaaaaaabjaaaaaa
diaaaaaibcaabaaaaaaaaaaabkbabaaaaaaaaaaackiacaaaadaaaaaaafaaaaaa
dcaaaaakbcaabaaaaaaaaaaackiacaaaadaaaaaaaeaaaaaaakbabaaaaaaaaaaa
akaabaaaaaaaaaaadcaaaaakbcaabaaaaaaaaaaackiacaaaadaaaaaaagaaaaaa
ckbabaaaaaaaaaaaakaabaaaaaaaaaaadcaaaaakbcaabaaaaaaaaaaackiacaaa
adaaaaaaahaaaaaadkbabaaaaaaaaaaaakaabaaaaaaaaaaaaaaaaaajccaabaaa
aaaaaaaadkiacaiaebaaaaaaacaaaaaabjaaaaaaabeaaaaaaaaaiadpdiaaaaai
iccabaaaagaaaaaabkaabaaaaaaaaaaaakaabaiaebaaaaaaaaaaaaaadoaaaaab
ejfdeheomaaaaaaaagaaaaaaaiaaaaaajiaaaaaaaaaaaaaaaaaaaaaaadaaaaaa
aaaaaaaaapapaaaakbaaaaaaaaaaaaaaaaaaaaaaadaaaaaaabaaaaaaapapaaaa
kjaaaaaaaaaaaaaaaaaaaaaaadaaaaaaacaaaaaaahahaaaalaaaaaaaaaaaaaaa
aaaaaaaaadaaaaaaadaaaaaaapadaaaalaaaaaaaabaaaaaaaaaaaaaaadaaaaaa
aeaaaaaaapadaaaaljaaaaaaaaaaaaaaaaaaaaaaadaaaaaaafaaaaaaapaaaaaa
faepfdejfeejepeoaafeebeoehefeofeaaeoepfcenebemaafeeffiedepepfcee
aaedepemepfcaaklepfdeheomiaaaaaaahaaaaaaaiaaaaaalaaaaaaaaaaaaaaa
abaaaaaaadaaaaaaaaaaaaaaapaaaaaalmaaaaaaaaaaaaaaaaaaaaaaadaaaaaa
abaaaaaaapaaaaaalmaaaaaaabaaaaaaaaaaaaaaadaaaaaaacaaaaaaahaiaaaa
lmaaaaaaacaaaaaaaaaaaaaaadaaaaaaadaaaaaaahaiaaaalmaaaaaaadaaaaaa
aaaaaaaaadaaaaaaaeaaaaaaapaaaaaalmaaaaaaaeaaaaaaaaaaaaaaadaaaaaa
afaaaaaaadamaaaalmaaaaaaafaaaaaaaaaaaaaaadaaaaaaagaaaaaaapaaaaaa
fdfgfpfaepfdejfeejepeoaafeeffiedepepfceeaaklklkl"
}

SubProgram "opengl " {
Keywords { "LIGHTMAP_ON" "DIRLIGHTMAP_ON" "HDR_LIGHT_PREPASS_OFF" }
Bind "vertex" Vertex
Bind "tangent" ATTR14
Bind "normal" Normal
Bind "texcoord" TexCoord0
Bind "texcoord1" TexCoord1
Vector 9 [_ProjectionParams]
Vector 10 [unity_LightmapST]
Vector 11 [_MainTex_ST]
Vector 12 [_BumpMap_ST]
"!!ARBvp1.0
# 22 ALU
PARAM c[13] = { { 0.5 },
		state.matrix.mvp,
		state.matrix.modelview[0].invtrans,
		program.local[9..12] };
TEMP R0;
TEMP R1;
TEMP R2;
MOV R0.xyz, vertex.attrib[14];
MUL R1.xyz, vertex.normal.zxyw, R0.yzxw;
MAD R0.xyz, vertex.normal.yzxw, R0.zxyw, -R1;
MUL R2.xyz, R0, vertex.attrib[14].w;
DP4 R0.w, vertex.position, c[4];
DP4 R0.z, vertex.position, c[3];
DP4 R0.x, vertex.position, c[1];
DP4 R0.y, vertex.position, c[2];
MUL R1.xyz, R0.xyww, c[0].x;
MUL R1.y, R1, c[9].x;
DP3 result.texcoord[1].y, R2, c[5];
DP3 result.texcoord[2].y, R2, c[6];
ADD result.texcoord[3].xy, R1, R1.z;
MOV result.position, R0;
MOV result.texcoord[3].zw, R0;
MAD result.texcoord[0].zw, vertex.texcoord[0].xyxy, c[12].xyxy, c[12];
MAD result.texcoord[0].xy, vertex.texcoord[0], c[11], c[11].zwzw;
MAD result.texcoord[4].xy, vertex.texcoord[1], c[10], c[10].zwzw;
DP3 result.texcoord[1].z, vertex.normal, c[5];
DP3 result.texcoord[1].x, vertex.attrib[14], c[5];
DP3 result.texcoord[2].z, vertex.normal, c[6];
DP3 result.texcoord[2].x, vertex.attrib[14], c[6];
END
# 22 instructions, 3 R-regs
"
}

SubProgram "d3d9 " {
Keywords { "LIGHTMAP_ON" "DIRLIGHTMAP_ON" "HDR_LIGHT_PREPASS_OFF" }
Bind "vertex" Vertex
Bind "tangent" TexCoord2
Bind "normal" Normal
Bind "texcoord" TexCoord0
Bind "texcoord1" TexCoord1
Matrix 0 [glstate_matrix_mvp]
Matrix 4 [glstate_matrix_invtrans_modelview0]
Vector 8 [_ProjectionParams]
Vector 9 [_ScreenParams]
Vector 10 [unity_LightmapST]
Vector 11 [_MainTex_ST]
Vector 12 [_BumpMap_ST]
"vs_2_0
; 23 ALU
def c13, 0.50000000, 0, 0, 0
dcl_position0 v0
dcl_tangent0 v1
dcl_normal0 v2
dcl_texcoord0 v3
dcl_texcoord1 v4
mov r0.xyz, v1
mul r1.xyz, v2.zxyw, r0.yzxw
mov r0.xyz, v1
mad r0.xyz, v2.yzxw, r0.zxyw, -r1
mul r2.xyz, r0, v1.w
dp4 r0.w, v0, c3
dp4 r0.z, v0, c2
dp4 r0.x, v0, c0
dp4 r0.y, v0, c1
mul r1.xyz, r0.xyww, c13.x
mul r1.y, r1, c8.x
dp3 oT1.y, r2, c4
dp3 oT2.y, r2, c5
mad oT3.xy, r1.z, c9.zwzw, r1
mov oPos, r0
mov oT3.zw, r0
mad oT0.zw, v3.xyxy, c12.xyxy, c12
mad oT0.xy, v3, c11, c11.zwzw
mad oT4.xy, v4, c10, c10.zwzw
dp3 oT1.z, v2, c4
dp3 oT1.x, v1, c4
dp3 oT2.z, v2, c5
dp3 oT2.x, v1, c5
"
}

SubProgram "d3d11 " {
Keywords { "LIGHTMAP_ON" "DIRLIGHTMAP_ON" "HDR_LIGHT_PREPASS_OFF" }
Bind "vertex" Vertex
Bind "tangent" TexCoord2
Bind "normal" Normal
Bind "texcoord" TexCoord0
Bind "texcoord1" TexCoord1
Bind "color" Color
ConstBuffer "$Globals" 160 // 112 used size, 10 vars
Vector 64 [unity_LightmapST] 4
Vector 80 [_MainTex_ST] 4
Vector 96 [_BumpMap_ST] 4
ConstBuffer "UnityPerCamera" 128 // 96 used size, 8 vars
Vector 80 [_ProjectionParams] 4
ConstBuffer "UnityPerDraw" 336 // 192 used size, 6 vars
Matrix 0 [glstate_matrix_mvp] 4
Matrix 128 [glstate_matrix_invtrans_modelview0] 4
BindCB "$Globals" 0
BindCB "UnityPerCamera" 1
BindCB "UnityPerDraw" 2
// 28 instructions, 3 temp regs, 0 temp arrays:
// ALU 12 float, 0 int, 0 uint
// TEX 0 (0 load, 0 comp, 0 bias, 0 grad)
// FLOW 1 static, 0 dynamic
"vs_4_0
eefieceddiphfhfdikaepmipefehoajefkecphkhabaaaaaamaafaaaaadaaaaaa
cmaaaaaapeaaaaaakmabaaaaejfdeheomaaaaaaaagaaaaaaaiaaaaaajiaaaaaa
aaaaaaaaaaaaaaaaadaaaaaaaaaaaaaaapapaaaakbaaaaaaaaaaaaaaaaaaaaaa
adaaaaaaabaaaaaaapapaaaakjaaaaaaaaaaaaaaaaaaaaaaadaaaaaaacaaaaaa
ahahaaaalaaaaaaaaaaaaaaaaaaaaaaaadaaaaaaadaaaaaaapadaaaalaaaaaaa
abaaaaaaaaaaaaaaadaaaaaaaeaaaaaaapadaaaaljaaaaaaaaaaaaaaaaaaaaaa
adaaaaaaafaaaaaaapaaaaaafaepfdejfeejepeoaafeebeoehefeofeaaeoepfc
enebemaafeeffiedepepfceeaaedepemepfcaaklepfdeheolaaaaaaaagaaaaaa
aiaaaaaajiaaaaaaaaaaaaaaabaaaaaaadaaaaaaaaaaaaaaapaaaaaakeaaaaaa
aaaaaaaaaaaaaaaaadaaaaaaabaaaaaaapaaaaaakeaaaaaaabaaaaaaaaaaaaaa
adaaaaaaacaaaaaaahaiaaaakeaaaaaaacaaaaaaaaaaaaaaadaaaaaaadaaaaaa
ahaiaaaakeaaaaaaadaaaaaaaaaaaaaaadaaaaaaaeaaaaaaapaaaaaakeaaaaaa
aeaaaaaaaaaaaaaaadaaaaaaafaaaaaaadamaaaafdfgfpfaepfdejfeejepeoaa
feeffiedepepfceeaaklklklfdeieefcamaeaaaaeaaaabaaadabaaaafjaaaaae
egiocaaaaaaaaaaaahaaaaaafjaaaaaeegiocaaaabaaaaaaagaaaaaafjaaaaae
egiocaaaacaaaaaaalaaaaaafpaaaaadpcbabaaaaaaaaaaafpaaaaadpcbabaaa
abaaaaaafpaaaaadhcbabaaaacaaaaaafpaaaaaddcbabaaaadaaaaaafpaaaaad
dcbabaaaaeaaaaaaghaaaaaepccabaaaaaaaaaaaabaaaaaagfaaaaadpccabaaa
abaaaaaagfaaaaadhccabaaaacaaaaaagfaaaaadhccabaaaadaaaaaagfaaaaad
pccabaaaaeaaaaaagfaaaaaddccabaaaafaaaaaagiaaaaacadaaaaaadiaaaaai
pcaabaaaaaaaaaaafgbfbaaaaaaaaaaaegiocaaaacaaaaaaabaaaaaadcaaaaak
pcaabaaaaaaaaaaaegiocaaaacaaaaaaaaaaaaaaagbabaaaaaaaaaaaegaobaaa
aaaaaaaadcaaaaakpcaabaaaaaaaaaaaegiocaaaacaaaaaaacaaaaaakgbkbaaa
aaaaaaaaegaobaaaaaaaaaaadcaaaaakpcaabaaaaaaaaaaaegiocaaaacaaaaaa
adaaaaaapgbpbaaaaaaaaaaaegaobaaaaaaaaaaadgaaaaafpccabaaaaaaaaaaa
egaobaaaaaaaaaaadcaaaaaldccabaaaabaaaaaaegbabaaaadaaaaaaegiacaaa
aaaaaaaaafaaaaaaogikcaaaaaaaaaaaafaaaaaadcaaaaalmccabaaaabaaaaaa
agbebaaaadaaaaaaagiecaaaaaaaaaaaagaaaaaakgiocaaaaaaaaaaaagaaaaaa
diaaaaahhcaabaaaabaaaaaajgbebaaaabaaaaaacgbjbaaaacaaaaaadcaaaaak
hcaabaaaabaaaaaajgbebaaaacaaaaaacgbjbaaaabaaaaaaegacbaiaebaaaaaa
abaaaaaadiaaaaahhcaabaaaabaaaaaaegacbaaaabaaaaaapgbpbaaaabaaaaaa
dgaaaaagbcaabaaaacaaaaaaakiacaaaacaaaaaaaiaaaaaadgaaaaagccaabaaa
acaaaaaaakiacaaaacaaaaaaajaaaaaadgaaaaagecaabaaaacaaaaaaakiacaaa
acaaaaaaakaaaaaabaaaaaahcccabaaaacaaaaaaegacbaaaabaaaaaaegacbaaa
acaaaaaabaaaaaahbccabaaaacaaaaaaegbcbaaaabaaaaaaegacbaaaacaaaaaa
baaaaaaheccabaaaacaaaaaaegbcbaaaacaaaaaaegacbaaaacaaaaaadgaaaaag
bcaabaaaacaaaaaabkiacaaaacaaaaaaaiaaaaaadgaaaaagccaabaaaacaaaaaa
bkiacaaaacaaaaaaajaaaaaadgaaaaagecaabaaaacaaaaaabkiacaaaacaaaaaa
akaaaaaabaaaaaahcccabaaaadaaaaaaegacbaaaabaaaaaaegacbaaaacaaaaaa
baaaaaahbccabaaaadaaaaaaegbcbaaaabaaaaaaegacbaaaacaaaaaabaaaaaah
eccabaaaadaaaaaaegbcbaaaacaaaaaaegacbaaaacaaaaaadiaaaaaiccaabaaa
aaaaaaaabkaabaaaaaaaaaaaakiacaaaabaaaaaaafaaaaaadiaaaaakncaabaaa
abaaaaaaagahbaaaaaaaaaaaaceaaaaaaaaaaadpaaaaaaaaaaaaaadpaaaaaadp
dgaaaaafmccabaaaaeaaaaaakgaobaaaaaaaaaaaaaaaaaahdccabaaaaeaaaaaa
kgakbaaaabaaaaaamgaabaaaabaaaaaadcaaaaaldccabaaaafaaaaaaegbabaaa
aeaaaaaaegiacaaaaaaaaaaaaeaaaaaaogikcaaaaaaaaaaaaeaaaaaadoaaaaab
"
}

SubProgram "gles " {
Keywords { "LIGHTMAP_ON" "DIRLIGHTMAP_ON" "HDR_LIGHT_PREPASS_OFF" }
"!!GLES
#define SHADER_API_GLES 1
#define tex2D texture2D


#ifdef VERTEX
#define gl_ModelViewProjectionMatrix glstate_matrix_mvp
uniform mat4 glstate_matrix_mvp;
#define gl_ModelViewMatrixInverseTranspose glstate_matrix_invtrans_modelview0
uniform mat4 glstate_matrix_invtrans_modelview0;
#define gl_ModelViewMatrix glstate_matrix_modelview0
uniform mat4 glstate_matrix_modelview0;

varying highp vec2 xlv_TEXCOORD4;
varying highp vec4 xlv_TEXCOORD3;
varying highp vec3 xlv_TEXCOORD2;
varying highp vec3 xlv_TEXCOORD1;
varying highp vec4 xlv_TEXCOORD0;
uniform highp vec4 _BumpMap_ST;
uniform highp vec4 _MainTex_ST;
uniform highp vec4 unity_LightmapST;


uniform highp vec4 _ProjectionParams;
attribute vec4 _glesTANGENT;
attribute vec4 _glesMultiTexCoord1;
attribute vec4 _glesMultiTexCoord0;
attribute vec3 _glesNormal;
attribute vec4 _glesVertex;
void main ()
{
  vec4 tmpvar_1;
  tmpvar_1.xyz = normalize(_glesTANGENT.xyz);
  tmpvar_1.w = _glesTANGENT.w;
  vec3 tmpvar_2;
  tmpvar_2 = normalize(_glesNormal);
  highp vec4 tmpvar_3;
  highp vec3 tmpvar_4;
  highp vec3 tmpvar_5;
  tmpvar_4 = tmpvar_1.xyz;
  tmpvar_5 = (((tmpvar_2.yzx * tmpvar_1.zxy) - (tmpvar_2.zxy * tmpvar_1.yzx)) * _glesTANGENT.w);
  highp mat3 tmpvar_6;
  tmpvar_6[0].x = tmpvar_4.x;
  tmpvar_6[0].y = tmpvar_5.x;
  tmpvar_6[0].z = tmpvar_2.x;
  tmpvar_6[1].x = tmpvar_4.y;
  tmpvar_6[1].y = tmpvar_5.y;
  tmpvar_6[1].z = tmpvar_2.y;
  tmpvar_6[2].x = tmpvar_4.z;
  tmpvar_6[2].y = tmpvar_5.z;
  tmpvar_6[2].z = tmpvar_2.z;
  vec4 v_7;
  v_7.x = gl_ModelViewMatrixInverseTranspose[0].x;
  v_7.y = gl_ModelViewMatrixInverseTranspose[1].x;
  v_7.z = gl_ModelViewMatrixInverseTranspose[2].x;
  v_7.w = gl_ModelViewMatrixInverseTranspose[3].x;
  vec4 v_8;
  v_8.x = gl_ModelViewMatrixInverseTranspose[0].y;
  v_8.y = gl_ModelViewMatrixInverseTranspose[1].y;
  v_8.z = gl_ModelViewMatrixInverseTranspose[2].y;
  v_8.w = gl_ModelViewMatrixInverseTranspose[3].y;
  highp vec4 tmpvar_9;
  tmpvar_9 = (gl_ModelViewProjectionMatrix * _glesVertex);
  tmpvar_3.xy = ((_glesMultiTexCoord0.xy * _MainTex_ST.xy) + _MainTex_ST.zw);
  tmpvar_3.zw = ((_glesMultiTexCoord0.xy * _BumpMap_ST.xy) + _BumpMap_ST.zw);
  highp vec4 o_10;
  highp vec4 tmpvar_11;
  tmpvar_11 = (tmpvar_9 * 0.5);
  highp vec2 tmpvar_12;
  tmpvar_12.x = tmpvar_11.x;
  tmpvar_12.y = (tmpvar_11.y * _ProjectionParams.x);
  o_10.xy = (tmpvar_12 + tmpvar_11.w);
  o_10.zw = tmpvar_9.zw;
  gl_Position = tmpvar_9;
  xlv_TEXCOORD0 = tmpvar_3;
  xlv_TEXCOORD1 = (tmpvar_6 * v_7.xyz);
  xlv_TEXCOORD2 = (tmpvar_6 * v_8.xyz);
  xlv_TEXCOORD3 = o_10;
  xlv_TEXCOORD4 = ((_glesMultiTexCoord1.xy * unity_LightmapST.xy) + unity_LightmapST.zw);
}



#endif
#ifdef FRAGMENT

varying highp vec2 xlv_TEXCOORD4;
varying highp vec4 xlv_TEXCOORD3;
varying highp vec3 xlv_TEXCOORD2;
varying highp vec3 xlv_TEXCOORD1;
varying highp vec4 xlv_TEXCOORD0;
uniform lowp float _Cutoff;
uniform sampler2D unity_LightmapInd;
uniform sampler2D unity_Lightmap;
uniform sampler2D _LightBuffer;
uniform sampler2D _Shade;
uniform sampler2D _BumpMap;
uniform sampler2D _MainTex;
uniform lowp vec4 _Color;
void main ()
{
  lowp vec4 tmpvar_1;
  mediump vec4 c_2;
  mediump vec4 light_3;
  lowp vec3 tmpvar_4;
  highp vec3 matcap_5;
  lowp vec3 tmpvar_6;
  tmpvar_6 = ((texture2D (_BumpMap, xlv_TEXCOORD0.zw).xyz * 2.0) - 1.0);
  lowp vec3 tmpvar_7;
  tmpvar_7 = (texture2D (_MainTex, xlv_TEXCOORD0.xy).xyz * _Color.w);
  highp vec2 tmpvar_8;
  tmpvar_8.x = dot (xlv_TEXCOORD1, tmpvar_6);
  tmpvar_8.y = dot (xlv_TEXCOORD2, tmpvar_6);
  highp vec2 P_9;
  P_9 = ((tmpvar_8 * 0.5) + 0.5);
  lowp vec3 tmpvar_10;
  tmpvar_10 = texture2D (_Shade, P_9).xyz;
  matcap_5 = tmpvar_10;
  lowp vec4 tmpvar_11;
  tmpvar_11 = texture2D (_MainTex, xlv_TEXCOORD0.xy);
  highp vec3 tmpvar_12;
  tmpvar_12 = (((matcap_5 * tmpvar_11.xyz) * _Color.xyz) * 3.0);
  tmpvar_4 = tmpvar_12;
  lowp vec4 tmpvar_13;
  tmpvar_13 = texture2D (_MainTex, xlv_TEXCOORD0.xy);
  lowp float x_14;
  x_14 = (tmpvar_13.w - _Cutoff);
  if ((x_14 < 0.0)) {
    discard;
  };
  lowp vec4 tmpvar_15;
  tmpvar_15 = texture2DProj (_LightBuffer, xlv_TEXCOORD3);
  light_3 = tmpvar_15;
  mat3 tmpvar_16;
  tmpvar_16[0].x = 0.816497;
  tmpvar_16[0].y = -0.408248;
  tmpvar_16[0].z = -0.408248;
  tmpvar_16[1].x = 0.0;
  tmpvar_16[1].y = 0.707107;
  tmpvar_16[1].z = -0.707107;
  tmpvar_16[2].x = 0.57735;
  tmpvar_16[2].y = 0.57735;
  tmpvar_16[2].z = 0.57735;
  mediump vec3 normal_17;
  normal_17 = tmpvar_6;
  mediump vec3 scalePerBasisVector_18;
  mediump vec3 lm_19;
  lowp vec3 tmpvar_20;
  tmpvar_20 = (2.0 * texture2D (unity_Lightmap, xlv_TEXCOORD4).xyz);
  lm_19 = tmpvar_20;
  lowp vec3 tmpvar_21;
  tmpvar_21 = (2.0 * texture2D (unity_LightmapInd, xlv_TEXCOORD4).xyz);
  scalePerBasisVector_18 = tmpvar_21;
  lm_19 = (lm_19 * dot (clamp ((tmpvar_16 * normal_17), 0.0, 1.0), scalePerBasisVector_18));
  mediump vec4 tmpvar_22;
  tmpvar_22.w = 0.0;
  tmpvar_22.xyz = lm_19;
  mediump vec4 tmpvar_23;
  tmpvar_23 = (-(log2(max (light_3, vec4(0.001, 0.001, 0.001, 0.001)))) + tmpvar_22);
  light_3 = tmpvar_23;
  lowp vec4 c_24;
  mediump vec3 tmpvar_25;
  tmpvar_25 = (tmpvar_7 * tmpvar_23.xyz);
  c_24.xyz = tmpvar_25;
  c_24.w = tmpvar_13.w;
  c_2 = c_24;
  c_2.xyz = (c_2.xyz + tmpvar_4);
  tmpvar_1 = c_2;
  gl_FragData[0] = tmpvar_1;
}



#endif"
}

SubProgram "glesdesktop " {
Keywords { "LIGHTMAP_ON" "DIRLIGHTMAP_ON" "HDR_LIGHT_PREPASS_OFF" }
"!!GLES
#define SHADER_API_GLES 1
#define tex2D texture2D


#ifdef VERTEX
#define gl_ModelViewProjectionMatrix glstate_matrix_mvp
uniform mat4 glstate_matrix_mvp;
#define gl_ModelViewMatrixInverseTranspose glstate_matrix_invtrans_modelview0
uniform mat4 glstate_matrix_invtrans_modelview0;
#define gl_ModelViewMatrix glstate_matrix_modelview0
uniform mat4 glstate_matrix_modelview0;

varying highp vec2 xlv_TEXCOORD4;
varying highp vec4 xlv_TEXCOORD3;
varying highp vec3 xlv_TEXCOORD2;
varying highp vec3 xlv_TEXCOORD1;
varying highp vec4 xlv_TEXCOORD0;
uniform highp vec4 _BumpMap_ST;
uniform highp vec4 _MainTex_ST;
uniform highp vec4 unity_LightmapST;


uniform highp vec4 _ProjectionParams;
attribute vec4 _glesTANGENT;
attribute vec4 _glesMultiTexCoord1;
attribute vec4 _glesMultiTexCoord0;
attribute vec3 _glesNormal;
attribute vec4 _glesVertex;
void main ()
{
  vec4 tmpvar_1;
  tmpvar_1.xyz = normalize(_glesTANGENT.xyz);
  tmpvar_1.w = _glesTANGENT.w;
  vec3 tmpvar_2;
  tmpvar_2 = normalize(_glesNormal);
  highp vec4 tmpvar_3;
  highp vec3 tmpvar_4;
  highp vec3 tmpvar_5;
  tmpvar_4 = tmpvar_1.xyz;
  tmpvar_5 = (((tmpvar_2.yzx * tmpvar_1.zxy) - (tmpvar_2.zxy * tmpvar_1.yzx)) * _glesTANGENT.w);
  highp mat3 tmpvar_6;
  tmpvar_6[0].x = tmpvar_4.x;
  tmpvar_6[0].y = tmpvar_5.x;
  tmpvar_6[0].z = tmpvar_2.x;
  tmpvar_6[1].x = tmpvar_4.y;
  tmpvar_6[1].y = tmpvar_5.y;
  tmpvar_6[1].z = tmpvar_2.y;
  tmpvar_6[2].x = tmpvar_4.z;
  tmpvar_6[2].y = tmpvar_5.z;
  tmpvar_6[2].z = tmpvar_2.z;
  vec4 v_7;
  v_7.x = gl_ModelViewMatrixInverseTranspose[0].x;
  v_7.y = gl_ModelViewMatrixInverseTranspose[1].x;
  v_7.z = gl_ModelViewMatrixInverseTranspose[2].x;
  v_7.w = gl_ModelViewMatrixInverseTranspose[3].x;
  vec4 v_8;
  v_8.x = gl_ModelViewMatrixInverseTranspose[0].y;
  v_8.y = gl_ModelViewMatrixInverseTranspose[1].y;
  v_8.z = gl_ModelViewMatrixInverseTranspose[2].y;
  v_8.w = gl_ModelViewMatrixInverseTranspose[3].y;
  highp vec4 tmpvar_9;
  tmpvar_9 = (gl_ModelViewProjectionMatrix * _glesVertex);
  tmpvar_3.xy = ((_glesMultiTexCoord0.xy * _MainTex_ST.xy) + _MainTex_ST.zw);
  tmpvar_3.zw = ((_glesMultiTexCoord0.xy * _BumpMap_ST.xy) + _BumpMap_ST.zw);
  highp vec4 o_10;
  highp vec4 tmpvar_11;
  tmpvar_11 = (tmpvar_9 * 0.5);
  highp vec2 tmpvar_12;
  tmpvar_12.x = tmpvar_11.x;
  tmpvar_12.y = (tmpvar_11.y * _ProjectionParams.x);
  o_10.xy = (tmpvar_12 + tmpvar_11.w);
  o_10.zw = tmpvar_9.zw;
  gl_Position = tmpvar_9;
  xlv_TEXCOORD0 = tmpvar_3;
  xlv_TEXCOORD1 = (tmpvar_6 * v_7.xyz);
  xlv_TEXCOORD2 = (tmpvar_6 * v_8.xyz);
  xlv_TEXCOORD3 = o_10;
  xlv_TEXCOORD4 = ((_glesMultiTexCoord1.xy * unity_LightmapST.xy) + unity_LightmapST.zw);
}



#endif
#ifdef FRAGMENT

varying highp vec2 xlv_TEXCOORD4;
varying highp vec4 xlv_TEXCOORD3;
varying highp vec3 xlv_TEXCOORD2;
varying highp vec3 xlv_TEXCOORD1;
varying highp vec4 xlv_TEXCOORD0;
uniform lowp float _Cutoff;
uniform sampler2D unity_LightmapInd;
uniform sampler2D unity_Lightmap;
uniform sampler2D _LightBuffer;
uniform sampler2D _Shade;
uniform sampler2D _BumpMap;
uniform sampler2D _MainTex;
uniform lowp vec4 _Color;
void main ()
{
  lowp vec4 tmpvar_1;
  mediump vec4 c_2;
  mediump vec4 light_3;
  lowp vec3 tmpvar_4;
  highp vec3 matcap_5;
  lowp vec3 normal_6;
  normal_6.xy = ((texture2D (_BumpMap, xlv_TEXCOORD0.zw).wy * 2.0) - 1.0);
  normal_6.z = sqrt(((1.0 - (normal_6.x * normal_6.x)) - (normal_6.y * normal_6.y)));
  lowp vec3 tmpvar_7;
  tmpvar_7 = (texture2D (_MainTex, xlv_TEXCOORD0.xy).xyz * _Color.w);
  highp vec2 tmpvar_8;
  tmpvar_8.x = dot (xlv_TEXCOORD1, normal_6);
  tmpvar_8.y = dot (xlv_TEXCOORD2, normal_6);
  highp vec2 P_9;
  P_9 = ((tmpvar_8 * 0.5) + 0.5);
  lowp vec3 tmpvar_10;
  tmpvar_10 = texture2D (_Shade, P_9).xyz;
  matcap_5 = tmpvar_10;
  lowp vec4 tmpvar_11;
  tmpvar_11 = texture2D (_MainTex, xlv_TEXCOORD0.xy);
  highp vec3 tmpvar_12;
  tmpvar_12 = (((matcap_5 * tmpvar_11.xyz) * _Color.xyz) * 3.0);
  tmpvar_4 = tmpvar_12;
  lowp vec4 tmpvar_13;
  tmpvar_13 = texture2D (_MainTex, xlv_TEXCOORD0.xy);
  lowp float x_14;
  x_14 = (tmpvar_13.w - _Cutoff);
  if ((x_14 < 0.0)) {
    discard;
  };
  lowp vec4 tmpvar_15;
  tmpvar_15 = texture2DProj (_LightBuffer, xlv_TEXCOORD3);
  light_3 = tmpvar_15;
  lowp vec4 tmpvar_16;
  tmpvar_16 = texture2D (unity_Lightmap, xlv_TEXCOORD4);
  lowp vec4 tmpvar_17;
  tmpvar_17 = texture2D (unity_LightmapInd, xlv_TEXCOORD4);
  mat3 tmpvar_18;
  tmpvar_18[0].x = 0.816497;
  tmpvar_18[0].y = -0.408248;
  tmpvar_18[0].z = -0.408248;
  tmpvar_18[1].x = 0.0;
  tmpvar_18[1].y = 0.707107;
  tmpvar_18[1].z = -0.707107;
  tmpvar_18[2].x = 0.57735;
  tmpvar_18[2].y = 0.57735;
  tmpvar_18[2].z = 0.57735;
  mediump vec3 normal_19;
  normal_19 = normal_6;
  mediump vec3 scalePerBasisVector_20;
  mediump vec3 lm_21;
  lowp vec3 tmpvar_22;
  tmpvar_22 = ((8.0 * tmpvar_16.w) * tmpvar_16.xyz);
  lm_21 = tmpvar_22;
  lowp vec3 tmpvar_23;
  tmpvar_23 = ((8.0 * tmpvar_17.w) * tmpvar_17.xyz);
  scalePerBasisVector_20 = tmpvar_23;
  lm_21 = (lm_21 * dot (clamp ((tmpvar_18 * normal_19), 0.0, 1.0), scalePerBasisVector_20));
  mediump vec4 tmpvar_24;
  tmpvar_24.w = 0.0;
  tmpvar_24.xyz = lm_21;
  mediump vec4 tmpvar_25;
  tmpvar_25 = (-(log2(max (light_3, vec4(0.001, 0.001, 0.001, 0.001)))) + tmpvar_24);
  light_3 = tmpvar_25;
  lowp vec4 c_26;
  mediump vec3 tmpvar_27;
  tmpvar_27 = (tmpvar_7 * tmpvar_25.xyz);
  c_26.xyz = tmpvar_27;
  c_26.w = tmpvar_13.w;
  c_2 = c_26;
  c_2.xyz = (c_2.xyz + tmpvar_4);
  tmpvar_1 = c_2;
  gl_FragData[0] = tmpvar_1;
}



#endif"
}

SubProgram "d3d11_9x " {
Keywords { "LIGHTMAP_ON" "DIRLIGHTMAP_ON" "HDR_LIGHT_PREPASS_OFF" }
Bind "vertex" Vertex
Bind "tangent" TexCoord2
Bind "normal" Normal
Bind "texcoord" TexCoord0
Bind "texcoord1" TexCoord1
Bind "color" Color
ConstBuffer "$Globals" 160 // 112 used size, 10 vars
Vector 64 [unity_LightmapST] 4
Vector 80 [_MainTex_ST] 4
Vector 96 [_BumpMap_ST] 4
ConstBuffer "UnityPerCamera" 128 // 96 used size, 8 vars
Vector 80 [_ProjectionParams] 4
ConstBuffer "UnityPerDraw" 336 // 192 used size, 6 vars
Matrix 0 [glstate_matrix_mvp] 4
Matrix 128 [glstate_matrix_invtrans_modelview0] 4
BindCB "$Globals" 0
BindCB "UnityPerCamera" 1
BindCB "UnityPerDraw" 2
// 28 instructions, 3 temp regs, 0 temp arrays:
// ALU 12 float, 0 int, 0 uint
// TEX 0 (0 load, 0 comp, 0 bias, 0 grad)
// FLOW 1 static, 0 dynamic
"vs_4_0_level_9_3
eefiecedeiefdblkdkljdbafeijanneeempfpnmoabaaaaaafmaiaaaaaeaaaaaa
daaaaaaamiacaaaanmagaaaakeahaaaaebgpgodjjaacaaaajaacaaaaaaacpopp
diacaaaafiaaaaaaaeaaceaaaaaafeaaaaaafeaaaaaaceaaabaafeaaaaaaaeaa
adaaabaaaaaaaaaaabaaafaaabaaaeaaaaaaaaaaacaaaaaaaeaaafaaaaaaaaaa
acaaaiaaadaaajaaaaaaaaaaaaaaaaaaabacpoppfbaaaaafamaaapkaaaaaaadp
aaaaaaaaaaaaaaaaaaaaaaaabpaaaaacafaaaaiaaaaaapjabpaaaaacafaaabia
abaaapjabpaaaaacafaaaciaacaaapjabpaaaaacafaaadiaadaaapjabpaaaaac
afaaaeiaaeaaapjaabaaaaacaaaaabiaajaaaakaabaaaaacaaaaaciaakaaaaka
abaaaaacaaaaaeiaalaaaakaaiaaaaadabaaaboaabaaoejaaaaaoeiaabaaaaac
abaaahiaabaaoejaafaaaaadacaaahiaabaamjiaacaancjaaeaaaaaeabaaahia
acaamjjaabaanciaacaaoeibafaaaaadabaaahiaabaaoeiaabaappjaaiaaaaad
abaaacoaabaaoeiaaaaaoeiaaiaaaaadabaaaeoaacaaoejaaaaaoeiaabaaaaac
aaaaabiaajaaffkaabaaaaacaaaaaciaakaaffkaabaaaaacaaaaaeiaalaaffka
aiaaaaadacaaaboaabaaoejaaaaaoeiaaiaaaaadacaaacoaabaaoeiaaaaaoeia
aiaaaaadacaaaeoaacaaoejaaaaaoeiaaeaaaaaeaaaaadoaadaaoejaacaaoeka
acaaookaaeaaaaaeaaaaamoaadaaeejaadaaeekaadaaoekaafaaaaadaaaaapia
aaaaffjaagaaoekaaeaaaaaeaaaaapiaafaaoekaaaaaaajaaaaaoeiaaeaaaaae
aaaaapiaahaaoekaaaaakkjaaaaaoeiaaeaaaaaeaaaaapiaaiaaoekaaaaappja
aaaaoeiaafaaaaadabaaabiaaaaaffiaaeaaaakaafaaaaadabaaaiiaabaaaaia
amaaaakaafaaaaadabaaafiaaaaapeiaamaaaakaacaaaaadadaaadoaabaakkia
abaaomiaaeaaaaaeaeaaadoaaeaaoejaabaaoekaabaaookaaeaaaaaeaaaaadma
aaaappiaaaaaoekaaaaaoeiaabaaaaacaaaaammaaaaaoeiaabaaaaacadaaamoa
aaaaoeiappppaaaafdeieefcamaeaaaaeaaaabaaadabaaaafjaaaaaeegiocaaa
aaaaaaaaahaaaaaafjaaaaaeegiocaaaabaaaaaaagaaaaaafjaaaaaeegiocaaa
acaaaaaaalaaaaaafpaaaaadpcbabaaaaaaaaaaafpaaaaadpcbabaaaabaaaaaa
fpaaaaadhcbabaaaacaaaaaafpaaaaaddcbabaaaadaaaaaafpaaaaaddcbabaaa
aeaaaaaaghaaaaaepccabaaaaaaaaaaaabaaaaaagfaaaaadpccabaaaabaaaaaa
gfaaaaadhccabaaaacaaaaaagfaaaaadhccabaaaadaaaaaagfaaaaadpccabaaa
aeaaaaaagfaaaaaddccabaaaafaaaaaagiaaaaacadaaaaaadiaaaaaipcaabaaa
aaaaaaaafgbfbaaaaaaaaaaaegiocaaaacaaaaaaabaaaaaadcaaaaakpcaabaaa
aaaaaaaaegiocaaaacaaaaaaaaaaaaaaagbabaaaaaaaaaaaegaobaaaaaaaaaaa
dcaaaaakpcaabaaaaaaaaaaaegiocaaaacaaaaaaacaaaaaakgbkbaaaaaaaaaaa
egaobaaaaaaaaaaadcaaaaakpcaabaaaaaaaaaaaegiocaaaacaaaaaaadaaaaaa
pgbpbaaaaaaaaaaaegaobaaaaaaaaaaadgaaaaafpccabaaaaaaaaaaaegaobaaa
aaaaaaaadcaaaaaldccabaaaabaaaaaaegbabaaaadaaaaaaegiacaaaaaaaaaaa
afaaaaaaogikcaaaaaaaaaaaafaaaaaadcaaaaalmccabaaaabaaaaaaagbebaaa
adaaaaaaagiecaaaaaaaaaaaagaaaaaakgiocaaaaaaaaaaaagaaaaaadiaaaaah
hcaabaaaabaaaaaajgbebaaaabaaaaaacgbjbaaaacaaaaaadcaaaaakhcaabaaa
abaaaaaajgbebaaaacaaaaaacgbjbaaaabaaaaaaegacbaiaebaaaaaaabaaaaaa
diaaaaahhcaabaaaabaaaaaaegacbaaaabaaaaaapgbpbaaaabaaaaaadgaaaaag
bcaabaaaacaaaaaaakiacaaaacaaaaaaaiaaaaaadgaaaaagccaabaaaacaaaaaa
akiacaaaacaaaaaaajaaaaaadgaaaaagecaabaaaacaaaaaaakiacaaaacaaaaaa
akaaaaaabaaaaaahcccabaaaacaaaaaaegacbaaaabaaaaaaegacbaaaacaaaaaa
baaaaaahbccabaaaacaaaaaaegbcbaaaabaaaaaaegacbaaaacaaaaaabaaaaaah
eccabaaaacaaaaaaegbcbaaaacaaaaaaegacbaaaacaaaaaadgaaaaagbcaabaaa
acaaaaaabkiacaaaacaaaaaaaiaaaaaadgaaaaagccaabaaaacaaaaaabkiacaaa
acaaaaaaajaaaaaadgaaaaagecaabaaaacaaaaaabkiacaaaacaaaaaaakaaaaaa
baaaaaahcccabaaaadaaaaaaegacbaaaabaaaaaaegacbaaaacaaaaaabaaaaaah
bccabaaaadaaaaaaegbcbaaaabaaaaaaegacbaaaacaaaaaabaaaaaaheccabaaa
adaaaaaaegbcbaaaacaaaaaaegacbaaaacaaaaaadiaaaaaiccaabaaaaaaaaaaa
bkaabaaaaaaaaaaaakiacaaaabaaaaaaafaaaaaadiaaaaakncaabaaaabaaaaaa
agahbaaaaaaaaaaaaceaaaaaaaaaaadpaaaaaaaaaaaaaadpaaaaaadpdgaaaaaf
mccabaaaaeaaaaaakgaobaaaaaaaaaaaaaaaaaahdccabaaaaeaaaaaakgakbaaa
abaaaaaamgaabaaaabaaaaaadcaaaaaldccabaaaafaaaaaaegbabaaaaeaaaaaa
egiacaaaaaaaaaaaaeaaaaaaogikcaaaaaaaaaaaaeaaaaaadoaaaaabejfdeheo
maaaaaaaagaaaaaaaiaaaaaajiaaaaaaaaaaaaaaaaaaaaaaadaaaaaaaaaaaaaa
apapaaaakbaaaaaaaaaaaaaaaaaaaaaaadaaaaaaabaaaaaaapapaaaakjaaaaaa
aaaaaaaaaaaaaaaaadaaaaaaacaaaaaaahahaaaalaaaaaaaaaaaaaaaaaaaaaaa
adaaaaaaadaaaaaaapadaaaalaaaaaaaabaaaaaaaaaaaaaaadaaaaaaaeaaaaaa
apadaaaaljaaaaaaaaaaaaaaaaaaaaaaadaaaaaaafaaaaaaapaaaaaafaepfdej
feejepeoaafeebeoehefeofeaaeoepfcenebemaafeeffiedepepfceeaaedepem
epfcaaklepfdeheolaaaaaaaagaaaaaaaiaaaaaajiaaaaaaaaaaaaaaabaaaaaa
adaaaaaaaaaaaaaaapaaaaaakeaaaaaaaaaaaaaaaaaaaaaaadaaaaaaabaaaaaa
apaaaaaakeaaaaaaabaaaaaaaaaaaaaaadaaaaaaacaaaaaaahaiaaaakeaaaaaa
acaaaaaaaaaaaaaaadaaaaaaadaaaaaaahaiaaaakeaaaaaaadaaaaaaaaaaaaaa
adaaaaaaaeaaaaaaapaaaaaakeaaaaaaaeaaaaaaaaaaaaaaadaaaaaaafaaaaaa
adamaaaafdfgfpfaepfdejfeejepeoaafeeffiedepepfceeaaklklkl"
}

SubProgram "opengl " {
Keywords { "LIGHTMAP_OFF" "DIRLIGHTMAP_OFF" "HDR_LIGHT_PREPASS_ON" }
Bind "vertex" Vertex
Bind "tangent" ATTR14
Bind "normal" Normal
Bind "texcoord" TexCoord0
Vector 13 [_ProjectionParams]
Vector 14 [unity_SHAr]
Vector 15 [unity_SHAg]
Vector 16 [unity_SHAb]
Vector 17 [unity_SHBr]
Vector 18 [unity_SHBg]
Vector 19 [unity_SHBb]
Vector 20 [unity_SHC]
Matrix 9 [_Object2World]
Vector 21 [unity_Scale]
Vector 22 [_MainTex_ST]
Vector 23 [_BumpMap_ST]
"!!ARBvp1.0
# 40 ALU
PARAM c[24] = { { 0.5, 1 },
		state.matrix.mvp,
		state.matrix.modelview[0].invtrans,
		program.local[9..23] };
TEMP R0;
TEMP R1;
TEMP R2;
MUL R1.xyz, vertex.normal, c[21].w;
DP3 R2.w, R1, c[10];
DP3 R0.x, R1, c[9];
DP3 R0.z, R1, c[11];
MOV R0.y, R2.w;
MOV R0.w, c[0].y;
MUL R1, R0.xyzz, R0.yzzx;
DP4 R2.z, R0, c[16];
DP4 R2.y, R0, c[15];
DP4 R2.x, R0, c[14];
DP4 R0.w, R1, c[19];
DP4 R0.y, R1, c[17];
DP4 R0.z, R1, c[18];
MUL R1.w, R2, R2;
ADD R0.yzw, R2.xxyz, R0;
MOV R1.xyz, vertex.attrib[14];
MUL R2.xyz, vertex.normal.zxyw, R1.yzxw;
MAD R1.xyz, vertex.normal.yzxw, R1.zxyw, -R2;
MUL R1.xyz, R1, vertex.attrib[14].w;
MAD R0.x, R0, R0, -R1.w;
MUL R2.xyz, R0.x, c[20];
ADD result.texcoord[4].xyz, R0.yzww, R2;
DP4 R0.w, vertex.position, c[4];
DP4 R0.z, vertex.position, c[3];
DP3 result.texcoord[1].y, R1, c[5];
DP4 R0.x, vertex.position, c[1];
DP4 R0.y, vertex.position, c[2];
MUL R2.xyz, R0.xyww, c[0].x;
DP3 result.texcoord[2].y, R1, c[6];
MOV R1.x, R2;
MUL R1.y, R2, c[13].x;
ADD result.texcoord[3].xy, R1, R2.z;
MOV result.position, R0;
MOV result.texcoord[3].zw, R0;
MAD result.texcoord[0].zw, vertex.texcoord[0].xyxy, c[23].xyxy, c[23];
MAD result.texcoord[0].xy, vertex.texcoord[0], c[22], c[22].zwzw;
DP3 result.texcoord[1].z, vertex.normal, c[5];
DP3 result.texcoord[1].x, vertex.attrib[14], c[5];
DP3 result.texcoord[2].z, vertex.normal, c[6];
DP3 result.texcoord[2].x, vertex.attrib[14], c[6];
END
# 40 instructions, 3 R-regs
"
}

SubProgram "d3d9 " {
Keywords { "LIGHTMAP_OFF" "DIRLIGHTMAP_OFF" "HDR_LIGHT_PREPASS_ON" }
Bind "vertex" Vertex
Bind "tangent" TexCoord2
Bind "normal" Normal
Bind "texcoord" TexCoord0
Matrix 0 [glstate_matrix_mvp]
Matrix 4 [glstate_matrix_invtrans_modelview0]
Vector 12 [_ProjectionParams]
Vector 13 [_ScreenParams]
Vector 14 [unity_SHAr]
Vector 15 [unity_SHAg]
Vector 16 [unity_SHAb]
Vector 17 [unity_SHBr]
Vector 18 [unity_SHBg]
Vector 19 [unity_SHBb]
Vector 20 [unity_SHC]
Matrix 8 [_Object2World]
Vector 21 [unity_Scale]
Vector 22 [_MainTex_ST]
Vector 23 [_BumpMap_ST]
"vs_2_0
; 40 ALU
def c24, 0.50000000, 1.00000000, 0, 0
dcl_position0 v0
dcl_tangent0 v1
dcl_normal0 v2
dcl_texcoord0 v3
mul r1.xyz, v2, c21.w
dp3 r2.w, r1, c9
dp3 r0.x, r1, c8
dp3 r0.z, r1, c10
mov r0.y, r2.w
mov r0.w, c24.y
mul r1, r0.xyzz, r0.yzzx
dp4 r2.z, r0, c16
dp4 r2.y, r0, c15
dp4 r2.x, r0, c14
dp4 r0.w, r1, c19
dp4 r0.y, r1, c17
dp4 r0.z, r1, c18
add r1.xyz, r2, r0.yzww
mul r0.y, r2.w, r2.w
mad r0.w, r0.x, r0.x, -r0.y
mov r2.xyz, v1
mov r0.xyz, v1
mul r2.xyz, v2.zxyw, r2.yzxw
mad r2.xyz, v2.yzxw, r0.zxyw, -r2
mul r0.xyz, r0.w, c20
add oT4.xyz, r1, r0
mul r2.xyz, r2, v1.w
dp4 r0.w, v0, c3
dp4 r0.z, v0, c2
dp4 r0.x, v0, c0
dp4 r0.y, v0, c1
mul r1.xyz, r0.xyww, c24.x
mul r1.y, r1, c12.x
dp3 oT1.y, r2, c4
dp3 oT2.y, r2, c5
mad oT3.xy, r1.z, c13.zwzw, r1
mov oPos, r0
mov oT3.zw, r0
mad oT0.zw, v3.xyxy, c23.xyxy, c23
mad oT0.xy, v3, c22, c22.zwzw
dp3 oT1.z, v2, c4
dp3 oT1.x, v1, c4
dp3 oT2.z, v2, c5
dp3 oT2.x, v1, c5
"
}

SubProgram "d3d11 " {
Keywords { "LIGHTMAP_OFF" "DIRLIGHTMAP_OFF" "HDR_LIGHT_PREPASS_ON" }
Bind "vertex" Vertex
Bind "tangent" TexCoord2
Bind "normal" Normal
Bind "texcoord" TexCoord0
Bind "color" Color
ConstBuffer "$Globals" 128 // 96 used size, 8 vars
Vector 64 [_MainTex_ST] 4
Vector 80 [_BumpMap_ST] 4
ConstBuffer "UnityPerCamera" 128 // 96 used size, 8 vars
Vector 80 [_ProjectionParams] 4
ConstBuffer "UnityLighting" 400 // 400 used size, 16 vars
Vector 288 [unity_SHAr] 4
Vector 304 [unity_SHAg] 4
Vector 320 [unity_SHAb] 4
Vector 336 [unity_SHBr] 4
Vector 352 [unity_SHBg] 4
Vector 368 [unity_SHBb] 4
Vector 384 [unity_SHC] 4
ConstBuffer "UnityPerDraw" 336 // 336 used size, 6 vars
Matrix 0 [glstate_matrix_mvp] 4
Matrix 128 [glstate_matrix_invtrans_modelview0] 4
Matrix 192 [_Object2World] 4
Vector 320 [unity_Scale] 4
BindCB "$Globals" 0
BindCB "UnityPerCamera" 1
BindCB "UnityLighting" 2
BindCB "UnityPerDraw" 3
// 43 instructions, 4 temp regs, 0 temp arrays:
// ALU 23 float, 0 int, 0 uint
// TEX 0 (0 load, 0 comp, 0 bias, 0 grad)
// FLOW 1 static, 0 dynamic
"vs_4_0
eefiecedhenpnkfakdchpiakopoppgigdkhjamkdabaaaaaakaahaaaaadaaaaaa
cmaaaaaapeaaaaaakmabaaaaejfdeheomaaaaaaaagaaaaaaaiaaaaaajiaaaaaa
aaaaaaaaaaaaaaaaadaaaaaaaaaaaaaaapapaaaakbaaaaaaaaaaaaaaaaaaaaaa
adaaaaaaabaaaaaaapapaaaakjaaaaaaaaaaaaaaaaaaaaaaadaaaaaaacaaaaaa
ahahaaaalaaaaaaaaaaaaaaaaaaaaaaaadaaaaaaadaaaaaaapadaaaalaaaaaaa
abaaaaaaaaaaaaaaadaaaaaaaeaaaaaaapaaaaaaljaaaaaaaaaaaaaaaaaaaaaa
adaaaaaaafaaaaaaapaaaaaafaepfdejfeejepeoaafeebeoehefeofeaaeoepfc
enebemaafeeffiedepepfceeaaedepemepfcaaklepfdeheolaaaaaaaagaaaaaa
aiaaaaaajiaaaaaaaaaaaaaaabaaaaaaadaaaaaaaaaaaaaaapaaaaaakeaaaaaa
aaaaaaaaaaaaaaaaadaaaaaaabaaaaaaapaaaaaakeaaaaaaabaaaaaaaaaaaaaa
adaaaaaaacaaaaaaahaiaaaakeaaaaaaacaaaaaaaaaaaaaaadaaaaaaadaaaaaa
ahaiaaaakeaaaaaaadaaaaaaaaaaaaaaadaaaaaaaeaaaaaaapaaaaaakeaaaaaa
aeaaaaaaaaaaaaaaadaaaaaaafaaaaaaahaiaaaafdfgfpfaepfdejfeejepeoaa
feeffiedepepfceeaaklklklfdeieefcomafaaaaeaaaabaahlabaaaafjaaaaae
egiocaaaaaaaaaaaagaaaaaafjaaaaaeegiocaaaabaaaaaaagaaaaaafjaaaaae
egiocaaaacaaaaaabjaaaaaafjaaaaaeegiocaaaadaaaaaabfaaaaaafpaaaaad
pcbabaaaaaaaaaaafpaaaaadpcbabaaaabaaaaaafpaaaaadhcbabaaaacaaaaaa
fpaaaaaddcbabaaaadaaaaaaghaaaaaepccabaaaaaaaaaaaabaaaaaagfaaaaad
pccabaaaabaaaaaagfaaaaadhccabaaaacaaaaaagfaaaaadhccabaaaadaaaaaa
gfaaaaadpccabaaaaeaaaaaagfaaaaadhccabaaaafaaaaaagiaaaaacaeaaaaaa
diaaaaaipcaabaaaaaaaaaaafgbfbaaaaaaaaaaaegiocaaaadaaaaaaabaaaaaa
dcaaaaakpcaabaaaaaaaaaaaegiocaaaadaaaaaaaaaaaaaaagbabaaaaaaaaaaa
egaobaaaaaaaaaaadcaaaaakpcaabaaaaaaaaaaaegiocaaaadaaaaaaacaaaaaa
kgbkbaaaaaaaaaaaegaobaaaaaaaaaaadcaaaaakpcaabaaaaaaaaaaaegiocaaa
adaaaaaaadaaaaaapgbpbaaaaaaaaaaaegaobaaaaaaaaaaadgaaaaafpccabaaa
aaaaaaaaegaobaaaaaaaaaaadcaaaaaldccabaaaabaaaaaaegbabaaaadaaaaaa
egiacaaaaaaaaaaaaeaaaaaaogikcaaaaaaaaaaaaeaaaaaadcaaaaalmccabaaa
abaaaaaaagbebaaaadaaaaaaagiecaaaaaaaaaaaafaaaaaakgiocaaaaaaaaaaa
afaaaaaadiaaaaahhcaabaaaabaaaaaajgbebaaaabaaaaaacgbjbaaaacaaaaaa
dcaaaaakhcaabaaaabaaaaaajgbebaaaacaaaaaacgbjbaaaabaaaaaaegacbaia
ebaaaaaaabaaaaaadiaaaaahhcaabaaaabaaaaaaegacbaaaabaaaaaapgbpbaaa
abaaaaaadgaaaaagbcaabaaaacaaaaaaakiacaaaadaaaaaaaiaaaaaadgaaaaag
ccaabaaaacaaaaaaakiacaaaadaaaaaaajaaaaaadgaaaaagecaabaaaacaaaaaa
akiacaaaadaaaaaaakaaaaaabaaaaaahcccabaaaacaaaaaaegacbaaaabaaaaaa
egacbaaaacaaaaaabaaaaaahbccabaaaacaaaaaaegbcbaaaabaaaaaaegacbaaa
acaaaaaabaaaaaaheccabaaaacaaaaaaegbcbaaaacaaaaaaegacbaaaacaaaaaa
dgaaaaagbcaabaaaacaaaaaabkiacaaaadaaaaaaaiaaaaaadgaaaaagccaabaaa
acaaaaaabkiacaaaadaaaaaaajaaaaaadgaaaaagecaabaaaacaaaaaabkiacaaa
adaaaaaaakaaaaaabaaaaaahcccabaaaadaaaaaaegacbaaaabaaaaaaegacbaaa
acaaaaaabaaaaaahbccabaaaadaaaaaaegbcbaaaabaaaaaaegacbaaaacaaaaaa
baaaaaaheccabaaaadaaaaaaegbcbaaaacaaaaaaegacbaaaacaaaaaadiaaaaai
ccaabaaaaaaaaaaabkaabaaaaaaaaaaaakiacaaaabaaaaaaafaaaaaadiaaaaak
ncaabaaaabaaaaaaagahbaaaaaaaaaaaaceaaaaaaaaaaadpaaaaaaaaaaaaaadp
aaaaaadpdgaaaaafmccabaaaaeaaaaaakgaobaaaaaaaaaaaaaaaaaahdccabaaa
aeaaaaaakgakbaaaabaaaaaamgaabaaaabaaaaaadiaaaaaihcaabaaaaaaaaaaa
egbcbaaaacaaaaaapgipcaaaadaaaaaabeaaaaaadiaaaaaihcaabaaaabaaaaaa
fgafbaaaaaaaaaaaegiccaaaadaaaaaaanaaaaaadcaaaaaklcaabaaaaaaaaaaa
egiicaaaadaaaaaaamaaaaaaagaabaaaaaaaaaaaegaibaaaabaaaaaadcaaaaak
hcaabaaaaaaaaaaaegiccaaaadaaaaaaaoaaaaaakgakbaaaaaaaaaaaegadbaaa
aaaaaaaadgaaaaaficaabaaaaaaaaaaaabeaaaaaaaaaiadpbbaaaaaibcaabaaa
abaaaaaaegiocaaaacaaaaaabcaaaaaaegaobaaaaaaaaaaabbaaaaaiccaabaaa
abaaaaaaegiocaaaacaaaaaabdaaaaaaegaobaaaaaaaaaaabbaaaaaiecaabaaa
abaaaaaaegiocaaaacaaaaaabeaaaaaaegaobaaaaaaaaaaadiaaaaahpcaabaaa
acaaaaaajgacbaaaaaaaaaaaegakbaaaaaaaaaaabbaaaaaibcaabaaaadaaaaaa
egiocaaaacaaaaaabfaaaaaaegaobaaaacaaaaaabbaaaaaiccaabaaaadaaaaaa
egiocaaaacaaaaaabgaaaaaaegaobaaaacaaaaaabbaaaaaiecaabaaaadaaaaaa
egiocaaaacaaaaaabhaaaaaaegaobaaaacaaaaaaaaaaaaahhcaabaaaabaaaaaa
egacbaaaabaaaaaaegacbaaaadaaaaaadiaaaaahccaabaaaaaaaaaaabkaabaaa
aaaaaaaabkaabaaaaaaaaaaadcaaaaakbcaabaaaaaaaaaaaakaabaaaaaaaaaaa
akaabaaaaaaaaaaabkaabaiaebaaaaaaaaaaaaaadcaaaaakhccabaaaafaaaaaa
egiccaaaacaaaaaabiaaaaaaagaabaaaaaaaaaaaegacbaaaabaaaaaadoaaaaab
"
}

SubProgram "gles " {
Keywords { "LIGHTMAP_OFF" "DIRLIGHTMAP_OFF" "HDR_LIGHT_PREPASS_ON" }
"!!GLES
#define SHADER_API_GLES 1
#define tex2D texture2D


#ifdef VERTEX
#define gl_ModelViewProjectionMatrix glstate_matrix_mvp
uniform mat4 glstate_matrix_mvp;
#define gl_ModelViewMatrixInverseTranspose glstate_matrix_invtrans_modelview0
uniform mat4 glstate_matrix_invtrans_modelview0;
#define gl_ModelViewMatrix glstate_matrix_modelview0
uniform mat4 glstate_matrix_modelview0;

varying highp vec3 xlv_TEXCOORD4;
varying highp vec4 xlv_TEXCOORD3;
varying highp vec3 xlv_TEXCOORD2;
varying highp vec3 xlv_TEXCOORD1;
varying highp vec4 xlv_TEXCOORD0;
uniform highp vec4 _BumpMap_ST;
uniform highp vec4 _MainTex_ST;
uniform highp vec4 unity_Scale;
uniform highp mat4 _Object2World;


uniform highp vec4 unity_SHC;
uniform highp vec4 unity_SHBb;
uniform highp vec4 unity_SHBg;
uniform highp vec4 unity_SHBr;
uniform highp vec4 unity_SHAb;
uniform highp vec4 unity_SHAg;
uniform highp vec4 unity_SHAr;
uniform highp vec4 _ProjectionParams;
attribute vec4 _glesTANGENT;
attribute vec4 _glesMultiTexCoord0;
attribute vec3 _glesNormal;
attribute vec4 _glesVertex;
void main ()
{
  vec4 tmpvar_1;
  tmpvar_1.xyz = normalize(_glesTANGENT.xyz);
  tmpvar_1.w = _glesTANGENT.w;
  vec3 tmpvar_2;
  tmpvar_2 = normalize(_glesNormal);
  highp vec4 tmpvar_3;
  highp vec3 tmpvar_4;
  highp vec3 tmpvar_5;
  highp vec3 tmpvar_6;
  tmpvar_5 = tmpvar_1.xyz;
  tmpvar_6 = (((tmpvar_2.yzx * tmpvar_1.zxy) - (tmpvar_2.zxy * tmpvar_1.yzx)) * _glesTANGENT.w);
  highp mat3 tmpvar_7;
  tmpvar_7[0].x = tmpvar_5.x;
  tmpvar_7[0].y = tmpvar_6.x;
  tmpvar_7[0].z = tmpvar_2.x;
  tmpvar_7[1].x = tmpvar_5.y;
  tmpvar_7[1].y = tmpvar_6.y;
  tmpvar_7[1].z = tmpvar_2.y;
  tmpvar_7[2].x = tmpvar_5.z;
  tmpvar_7[2].y = tmpvar_6.z;
  tmpvar_7[2].z = tmpvar_2.z;
  vec4 v_8;
  v_8.x = gl_ModelViewMatrixInverseTranspose[0].x;
  v_8.y = gl_ModelViewMatrixInverseTranspose[1].x;
  v_8.z = gl_ModelViewMatrixInverseTranspose[2].x;
  v_8.w = gl_ModelViewMatrixInverseTranspose[3].x;
  vec4 v_9;
  v_9.x = gl_ModelViewMatrixInverseTranspose[0].y;
  v_9.y = gl_ModelViewMatrixInverseTranspose[1].y;
  v_9.z = gl_ModelViewMatrixInverseTranspose[2].y;
  v_9.w = gl_ModelViewMatrixInverseTranspose[3].y;
  highp vec4 tmpvar_10;
  tmpvar_10 = (gl_ModelViewProjectionMatrix * _glesVertex);
  tmpvar_3.xy = ((_glesMultiTexCoord0.xy * _MainTex_ST.xy) + _MainTex_ST.zw);
  tmpvar_3.zw = ((_glesMultiTexCoord0.xy * _BumpMap_ST.xy) + _BumpMap_ST.zw);
  highp vec4 o_11;
  highp vec4 tmpvar_12;
  tmpvar_12 = (tmpvar_10 * 0.5);
  highp vec2 tmpvar_13;
  tmpvar_13.x = tmpvar_12.x;
  tmpvar_13.y = (tmpvar_12.y * _ProjectionParams.x);
  o_11.xy = (tmpvar_13 + tmpvar_12.w);
  o_11.zw = tmpvar_10.zw;
  mat3 tmpvar_14;
  tmpvar_14[0] = _Object2World[0].xyz;
  tmpvar_14[1] = _Object2World[1].xyz;
  tmpvar_14[2] = _Object2World[2].xyz;
  highp vec4 tmpvar_15;
  tmpvar_15.w = 1.0;
  tmpvar_15.xyz = (tmpvar_14 * (tmpvar_2 * unity_Scale.w));
  mediump vec3 tmpvar_16;
  mediump vec4 normal_17;
  normal_17 = tmpvar_15;
  highp float vC_18;
  mediump vec3 x3_19;
  mediump vec3 x2_20;
  mediump vec3 x1_21;
  highp float tmpvar_22;
  tmpvar_22 = dot (unity_SHAr, normal_17);
  x1_21.x = tmpvar_22;
  highp float tmpvar_23;
  tmpvar_23 = dot (unity_SHAg, normal_17);
  x1_21.y = tmpvar_23;
  highp float tmpvar_24;
  tmpvar_24 = dot (unity_SHAb, normal_17);
  x1_21.z = tmpvar_24;
  mediump vec4 tmpvar_25;
  tmpvar_25 = (normal_17.xyzz * normal_17.yzzx);
  highp float tmpvar_26;
  tmpvar_26 = dot (unity_SHBr, tmpvar_25);
  x2_20.x = tmpvar_26;
  highp float tmpvar_27;
  tmpvar_27 = dot (unity_SHBg, tmpvar_25);
  x2_20.y = tmpvar_27;
  highp float tmpvar_28;
  tmpvar_28 = dot (unity_SHBb, tmpvar_25);
  x2_20.z = tmpvar_28;
  mediump float tmpvar_29;
  tmpvar_29 = ((normal_17.x * normal_17.x) - (normal_17.y * normal_17.y));
  vC_18 = tmpvar_29;
  highp vec3 tmpvar_30;
  tmpvar_30 = (unity_SHC.xyz * vC_18);
  x3_19 = tmpvar_30;
  tmpvar_16 = ((x1_21 + x2_20) + x3_19);
  tmpvar_4 = tmpvar_16;
  gl_Position = tmpvar_10;
  xlv_TEXCOORD0 = tmpvar_3;
  xlv_TEXCOORD1 = (tmpvar_7 * v_8.xyz);
  xlv_TEXCOORD2 = (tmpvar_7 * v_9.xyz);
  xlv_TEXCOORD3 = o_11;
  xlv_TEXCOORD4 = tmpvar_4;
}



#endif
#ifdef FRAGMENT

varying highp vec3 xlv_TEXCOORD4;
varying highp vec4 xlv_TEXCOORD3;
varying highp vec3 xlv_TEXCOORD2;
varying highp vec3 xlv_TEXCOORD1;
varying highp vec4 xlv_TEXCOORD0;
uniform lowp float _Cutoff;
uniform sampler2D _LightBuffer;
uniform sampler2D _Shade;
uniform sampler2D _BumpMap;
uniform sampler2D _MainTex;
uniform lowp vec4 _Color;
void main ()
{
  lowp vec4 tmpvar_1;
  mediump vec4 c_2;
  mediump vec4 light_3;
  lowp vec3 tmpvar_4;
  highp vec3 matcap_5;
  lowp vec3 tmpvar_6;
  tmpvar_6 = ((texture2D (_BumpMap, xlv_TEXCOORD0.zw).xyz * 2.0) - 1.0);
  lowp vec3 tmpvar_7;
  tmpvar_7 = (texture2D (_MainTex, xlv_TEXCOORD0.xy).xyz * _Color.w);
  highp vec2 tmpvar_8;
  tmpvar_8.x = dot (xlv_TEXCOORD1, tmpvar_6);
  tmpvar_8.y = dot (xlv_TEXCOORD2, tmpvar_6);
  highp vec2 P_9;
  P_9 = ((tmpvar_8 * 0.5) + 0.5);
  lowp vec3 tmpvar_10;
  tmpvar_10 = texture2D (_Shade, P_9).xyz;
  matcap_5 = tmpvar_10;
  lowp vec4 tmpvar_11;
  tmpvar_11 = texture2D (_MainTex, xlv_TEXCOORD0.xy);
  highp vec3 tmpvar_12;
  tmpvar_12 = (((matcap_5 * tmpvar_11.xyz) * _Color.xyz) * 3.0);
  tmpvar_4 = tmpvar_12;
  lowp vec4 tmpvar_13;
  tmpvar_13 = texture2D (_MainTex, xlv_TEXCOORD0.xy);
  lowp float x_14;
  x_14 = (tmpvar_13.w - _Cutoff);
  if ((x_14 < 0.0)) {
    discard;
  };
  lowp vec4 tmpvar_15;
  tmpvar_15 = texture2DProj (_LightBuffer, xlv_TEXCOORD3);
  light_3 = tmpvar_15;
  mediump vec4 tmpvar_16;
  tmpvar_16 = max (light_3, vec4(0.001, 0.001, 0.001, 0.001));
  light_3.w = tmpvar_16.w;
  highp vec3 tmpvar_17;
  tmpvar_17 = (tmpvar_16.xyz + xlv_TEXCOORD4);
  light_3.xyz = tmpvar_17;
  lowp vec4 c_18;
  mediump vec3 tmpvar_19;
  tmpvar_19 = (tmpvar_7 * light_3.xyz);
  c_18.xyz = tmpvar_19;
  c_18.w = tmpvar_13.w;
  c_2 = c_18;
  c_2.xyz = (c_2.xyz + tmpvar_4);
  tmpvar_1 = c_2;
  gl_FragData[0] = tmpvar_1;
}



#endif"
}

SubProgram "glesdesktop " {
Keywords { "LIGHTMAP_OFF" "DIRLIGHTMAP_OFF" "HDR_LIGHT_PREPASS_ON" }
"!!GLES
#define SHADER_API_GLES 1
#define tex2D texture2D


#ifdef VERTEX
#define gl_ModelViewProjectionMatrix glstate_matrix_mvp
uniform mat4 glstate_matrix_mvp;
#define gl_ModelViewMatrixInverseTranspose glstate_matrix_invtrans_modelview0
uniform mat4 glstate_matrix_invtrans_modelview0;
#define gl_ModelViewMatrix glstate_matrix_modelview0
uniform mat4 glstate_matrix_modelview0;

varying highp vec3 xlv_TEXCOORD4;
varying highp vec4 xlv_TEXCOORD3;
varying highp vec3 xlv_TEXCOORD2;
varying highp vec3 xlv_TEXCOORD1;
varying highp vec4 xlv_TEXCOORD0;
uniform highp vec4 _BumpMap_ST;
uniform highp vec4 _MainTex_ST;
uniform highp vec4 unity_Scale;
uniform highp mat4 _Object2World;


uniform highp vec4 unity_SHC;
uniform highp vec4 unity_SHBb;
uniform highp vec4 unity_SHBg;
uniform highp vec4 unity_SHBr;
uniform highp vec4 unity_SHAb;
uniform highp vec4 unity_SHAg;
uniform highp vec4 unity_SHAr;
uniform highp vec4 _ProjectionParams;
attribute vec4 _glesTANGENT;
attribute vec4 _glesMultiTexCoord0;
attribute vec3 _glesNormal;
attribute vec4 _glesVertex;
void main ()
{
  vec4 tmpvar_1;
  tmpvar_1.xyz = normalize(_glesTANGENT.xyz);
  tmpvar_1.w = _glesTANGENT.w;
  vec3 tmpvar_2;
  tmpvar_2 = normalize(_glesNormal);
  highp vec4 tmpvar_3;
  highp vec3 tmpvar_4;
  highp vec3 tmpvar_5;
  highp vec3 tmpvar_6;
  tmpvar_5 = tmpvar_1.xyz;
  tmpvar_6 = (((tmpvar_2.yzx * tmpvar_1.zxy) - (tmpvar_2.zxy * tmpvar_1.yzx)) * _glesTANGENT.w);
  highp mat3 tmpvar_7;
  tmpvar_7[0].x = tmpvar_5.x;
  tmpvar_7[0].y = tmpvar_6.x;
  tmpvar_7[0].z = tmpvar_2.x;
  tmpvar_7[1].x = tmpvar_5.y;
  tmpvar_7[1].y = tmpvar_6.y;
  tmpvar_7[1].z = tmpvar_2.y;
  tmpvar_7[2].x = tmpvar_5.z;
  tmpvar_7[2].y = tmpvar_6.z;
  tmpvar_7[2].z = tmpvar_2.z;
  vec4 v_8;
  v_8.x = gl_ModelViewMatrixInverseTranspose[0].x;
  v_8.y = gl_ModelViewMatrixInverseTranspose[1].x;
  v_8.z = gl_ModelViewMatrixInverseTranspose[2].x;
  v_8.w = gl_ModelViewMatrixInverseTranspose[3].x;
  vec4 v_9;
  v_9.x = gl_ModelViewMatrixInverseTranspose[0].y;
  v_9.y = gl_ModelViewMatrixInverseTranspose[1].y;
  v_9.z = gl_ModelViewMatrixInverseTranspose[2].y;
  v_9.w = gl_ModelViewMatrixInverseTranspose[3].y;
  highp vec4 tmpvar_10;
  tmpvar_10 = (gl_ModelViewProjectionMatrix * _glesVertex);
  tmpvar_3.xy = ((_glesMultiTexCoord0.xy * _MainTex_ST.xy) + _MainTex_ST.zw);
  tmpvar_3.zw = ((_glesMultiTexCoord0.xy * _BumpMap_ST.xy) + _BumpMap_ST.zw);
  highp vec4 o_11;
  highp vec4 tmpvar_12;
  tmpvar_12 = (tmpvar_10 * 0.5);
  highp vec2 tmpvar_13;
  tmpvar_13.x = tmpvar_12.x;
  tmpvar_13.y = (tmpvar_12.y * _ProjectionParams.x);
  o_11.xy = (tmpvar_13 + tmpvar_12.w);
  o_11.zw = tmpvar_10.zw;
  mat3 tmpvar_14;
  tmpvar_14[0] = _Object2World[0].xyz;
  tmpvar_14[1] = _Object2World[1].xyz;
  tmpvar_14[2] = _Object2World[2].xyz;
  highp vec4 tmpvar_15;
  tmpvar_15.w = 1.0;
  tmpvar_15.xyz = (tmpvar_14 * (tmpvar_2 * unity_Scale.w));
  mediump vec3 tmpvar_16;
  mediump vec4 normal_17;
  normal_17 = tmpvar_15;
  highp float vC_18;
  mediump vec3 x3_19;
  mediump vec3 x2_20;
  mediump vec3 x1_21;
  highp float tmpvar_22;
  tmpvar_22 = dot (unity_SHAr, normal_17);
  x1_21.x = tmpvar_22;
  highp float tmpvar_23;
  tmpvar_23 = dot (unity_SHAg, normal_17);
  x1_21.y = tmpvar_23;
  highp float tmpvar_24;
  tmpvar_24 = dot (unity_SHAb, normal_17);
  x1_21.z = tmpvar_24;
  mediump vec4 tmpvar_25;
  tmpvar_25 = (normal_17.xyzz * normal_17.yzzx);
  highp float tmpvar_26;
  tmpvar_26 = dot (unity_SHBr, tmpvar_25);
  x2_20.x = tmpvar_26;
  highp float tmpvar_27;
  tmpvar_27 = dot (unity_SHBg, tmpvar_25);
  x2_20.y = tmpvar_27;
  highp float tmpvar_28;
  tmpvar_28 = dot (unity_SHBb, tmpvar_25);
  x2_20.z = tmpvar_28;
  mediump float tmpvar_29;
  tmpvar_29 = ((normal_17.x * normal_17.x) - (normal_17.y * normal_17.y));
  vC_18 = tmpvar_29;
  highp vec3 tmpvar_30;
  tmpvar_30 = (unity_SHC.xyz * vC_18);
  x3_19 = tmpvar_30;
  tmpvar_16 = ((x1_21 + x2_20) + x3_19);
  tmpvar_4 = tmpvar_16;
  gl_Position = tmpvar_10;
  xlv_TEXCOORD0 = tmpvar_3;
  xlv_TEXCOORD1 = (tmpvar_7 * v_8.xyz);
  xlv_TEXCOORD2 = (tmpvar_7 * v_9.xyz);
  xlv_TEXCOORD3 = o_11;
  xlv_TEXCOORD4 = tmpvar_4;
}



#endif
#ifdef FRAGMENT

varying highp vec3 xlv_TEXCOORD4;
varying highp vec4 xlv_TEXCOORD3;
varying highp vec3 xlv_TEXCOORD2;
varying highp vec3 xlv_TEXCOORD1;
varying highp vec4 xlv_TEXCOORD0;
uniform lowp float _Cutoff;
uniform sampler2D _LightBuffer;
uniform sampler2D _Shade;
uniform sampler2D _BumpMap;
uniform sampler2D _MainTex;
uniform lowp vec4 _Color;
void main ()
{
  lowp vec4 tmpvar_1;
  mediump vec4 c_2;
  mediump vec4 light_3;
  lowp vec3 tmpvar_4;
  highp vec3 matcap_5;
  lowp vec3 normal_6;
  normal_6.xy = ((texture2D (_BumpMap, xlv_TEXCOORD0.zw).wy * 2.0) - 1.0);
  normal_6.z = sqrt(((1.0 - (normal_6.x * normal_6.x)) - (normal_6.y * normal_6.y)));
  lowp vec3 tmpvar_7;
  tmpvar_7 = (texture2D (_MainTex, xlv_TEXCOORD0.xy).xyz * _Color.w);
  highp vec2 tmpvar_8;
  tmpvar_8.x = dot (xlv_TEXCOORD1, normal_6);
  tmpvar_8.y = dot (xlv_TEXCOORD2, normal_6);
  highp vec2 P_9;
  P_9 = ((tmpvar_8 * 0.5) + 0.5);
  lowp vec3 tmpvar_10;
  tmpvar_10 = texture2D (_Shade, P_9).xyz;
  matcap_5 = tmpvar_10;
  lowp vec4 tmpvar_11;
  tmpvar_11 = texture2D (_MainTex, xlv_TEXCOORD0.xy);
  highp vec3 tmpvar_12;
  tmpvar_12 = (((matcap_5 * tmpvar_11.xyz) * _Color.xyz) * 3.0);
  tmpvar_4 = tmpvar_12;
  lowp vec4 tmpvar_13;
  tmpvar_13 = texture2D (_MainTex, xlv_TEXCOORD0.xy);
  lowp float x_14;
  x_14 = (tmpvar_13.w - _Cutoff);
  if ((x_14 < 0.0)) {
    discard;
  };
  lowp vec4 tmpvar_15;
  tmpvar_15 = texture2DProj (_LightBuffer, xlv_TEXCOORD3);
  light_3 = tmpvar_15;
  mediump vec4 tmpvar_16;
  tmpvar_16 = max (light_3, vec4(0.001, 0.001, 0.001, 0.001));
  light_3.w = tmpvar_16.w;
  highp vec3 tmpvar_17;
  tmpvar_17 = (tmpvar_16.xyz + xlv_TEXCOORD4);
  light_3.xyz = tmpvar_17;
  lowp vec4 c_18;
  mediump vec3 tmpvar_19;
  tmpvar_19 = (tmpvar_7 * light_3.xyz);
  c_18.xyz = tmpvar_19;
  c_18.w = tmpvar_13.w;
  c_2 = c_18;
  c_2.xyz = (c_2.xyz + tmpvar_4);
  tmpvar_1 = c_2;
  gl_FragData[0] = tmpvar_1;
}



#endif"
}

SubProgram "d3d11_9x " {
Keywords { "LIGHTMAP_OFF" "DIRLIGHTMAP_OFF" "HDR_LIGHT_PREPASS_ON" }
Bind "vertex" Vertex
Bind "tangent" TexCoord2
Bind "normal" Normal
Bind "texcoord" TexCoord0
Bind "color" Color
ConstBuffer "$Globals" 128 // 96 used size, 8 vars
Vector 64 [_MainTex_ST] 4
Vector 80 [_BumpMap_ST] 4
ConstBuffer "UnityPerCamera" 128 // 96 used size, 8 vars
Vector 80 [_ProjectionParams] 4
ConstBuffer "UnityLighting" 400 // 400 used size, 16 vars
Vector 288 [unity_SHAr] 4
Vector 304 [unity_SHAg] 4
Vector 320 [unity_SHAb] 4
Vector 336 [unity_SHBr] 4
Vector 352 [unity_SHBg] 4
Vector 368 [unity_SHBb] 4
Vector 384 [unity_SHC] 4
ConstBuffer "UnityPerDraw" 336 // 336 used size, 6 vars
Matrix 0 [glstate_matrix_mvp] 4
Matrix 128 [glstate_matrix_invtrans_modelview0] 4
Matrix 192 [_Object2World] 4
Vector 320 [unity_Scale] 4
BindCB "$Globals" 0
BindCB "UnityPerCamera" 1
BindCB "UnityLighting" 2
BindCB "UnityPerDraw" 3
// 43 instructions, 4 temp regs, 0 temp arrays:
// ALU 23 float, 0 int, 0 uint
// TEX 0 (0 load, 0 comp, 0 bias, 0 grad)
// FLOW 1 static, 0 dynamic
"vs_4_0_level_9_3
eefiecedpcngbnoedphobaihhaadlcokdebdfinjabaaaaaaemalaaaaaeaaaaaa
daaaaaaaniadaaaammajaaaajeakaaaaebgpgodjkaadaaaakaadaaaaaaacpopp
ceadaaaahmaaaaaaahaaceaaaaaahiaaaaaahiaaaaaaceaaabaahiaaaaaaaeaa
acaaabaaaaaaaaaaabaaafaaabaaadaaaaaaaaaaacaabcaaahaaaeaaaaaaaaaa
adaaaaaaaeaaalaaaaaaaaaaadaaaiaaadaaapaaaaaaaaaaadaaamaaadaabcaa
aaaaaaaaadaabeaaabaabfaaaaaaaaaaaaaaaaaaabacpoppfbaaaaafbgaaapka
aaaaaadpaaaaiadpaaaaaaaaaaaaaaaabpaaaaacafaaaaiaaaaaapjabpaaaaac
afaaabiaabaaapjabpaaaaacafaaaciaacaaapjabpaaaaacafaaadiaadaaapja
abaaaaacaaaaabiaapaaaakaabaaaaacaaaaaciabaaaaakaabaaaaacaaaaaeia
bbaaaakaaiaaaaadabaaaboaabaaoejaaaaaoeiaabaaaaacabaaahiaacaaoeja
afaaaaadacaaahiaabaanciaabaamjjaaeaaaaaeabaaahiaabaamjiaabaancja
acaaoeibafaaaaadabaaahiaabaaoeiaabaappjaaiaaaaadabaaacoaabaaoeia
aaaaoeiaaiaaaaadabaaaeoaacaaoejaaaaaoeiaabaaaaacaaaaabiaapaaffka
abaaaaacaaaaaciabaaaffkaabaaaaacaaaaaeiabbaaffkaaiaaaaadacaaaboa
abaaoejaaaaaoeiaaiaaaaadacaaacoaabaaoeiaaaaaoeiaaiaaaaadacaaaeoa
acaaoejaaaaaoeiaaeaaaaaeaaaaadoaadaaoejaabaaoekaabaaookaaeaaaaae
aaaaamoaadaaeejaacaaeekaacaaoekaafaaaaadaaaaapiaaaaaffjaamaaoeka
aeaaaaaeaaaaapiaalaaoekaaaaaaajaaaaaoeiaaeaaaaaeaaaaapiaanaaoeka
aaaakkjaaaaaoeiaaeaaaaaeaaaaapiaaoaaoekaaaaappjaaaaaoeiaafaaaaad
abaaabiaaaaaffiaadaaaakaafaaaaadabaaaiiaabaaaaiabgaaaakaafaaaaad
abaaafiaaaaapeiabgaaaakaacaaaaadadaaadoaabaakkiaabaaomiaafaaaaad
abaaahiaacaaoejabfaappkaafaaaaadacaaahiaabaaffiabdaaoekaaeaaaaae
abaaaliabcaakekaabaaaaiaacaakeiaaeaaaaaeabaaahiabeaaoekaabaakkia
abaapeiaabaaaaacabaaaiiabgaaffkaajaaaaadacaaabiaaeaaoekaabaaoeia
ajaaaaadacaaaciaafaaoekaabaaoeiaajaaaaadacaaaeiaagaaoekaabaaoeia
afaaaaadadaaapiaabaacjiaabaakeiaajaaaaadaeaaabiaahaaoekaadaaoeia
ajaaaaadaeaaaciaaiaaoekaadaaoeiaajaaaaadaeaaaeiaajaaoekaadaaoeia
acaaaaadacaaahiaacaaoeiaaeaaoeiaafaaaaadabaaaciaabaaffiaabaaffia
aeaaaaaeabaaabiaabaaaaiaabaaaaiaabaaffibaeaaaaaeaeaaahoaakaaoeka
abaaaaiaacaaoeiaaeaaaaaeaaaaadmaaaaappiaaaaaoekaaaaaoeiaabaaaaac
aaaaammaaaaaoeiaabaaaaacadaaamoaaaaaoeiappppaaaafdeieefcomafaaaa
eaaaabaahlabaaaafjaaaaaeegiocaaaaaaaaaaaagaaaaaafjaaaaaeegiocaaa
abaaaaaaagaaaaaafjaaaaaeegiocaaaacaaaaaabjaaaaaafjaaaaaeegiocaaa
adaaaaaabfaaaaaafpaaaaadpcbabaaaaaaaaaaafpaaaaadpcbabaaaabaaaaaa
fpaaaaadhcbabaaaacaaaaaafpaaaaaddcbabaaaadaaaaaaghaaaaaepccabaaa
aaaaaaaaabaaaaaagfaaaaadpccabaaaabaaaaaagfaaaaadhccabaaaacaaaaaa
gfaaaaadhccabaaaadaaaaaagfaaaaadpccabaaaaeaaaaaagfaaaaadhccabaaa
afaaaaaagiaaaaacaeaaaaaadiaaaaaipcaabaaaaaaaaaaafgbfbaaaaaaaaaaa
egiocaaaadaaaaaaabaaaaaadcaaaaakpcaabaaaaaaaaaaaegiocaaaadaaaaaa
aaaaaaaaagbabaaaaaaaaaaaegaobaaaaaaaaaaadcaaaaakpcaabaaaaaaaaaaa
egiocaaaadaaaaaaacaaaaaakgbkbaaaaaaaaaaaegaobaaaaaaaaaaadcaaaaak
pcaabaaaaaaaaaaaegiocaaaadaaaaaaadaaaaaapgbpbaaaaaaaaaaaegaobaaa
aaaaaaaadgaaaaafpccabaaaaaaaaaaaegaobaaaaaaaaaaadcaaaaaldccabaaa
abaaaaaaegbabaaaadaaaaaaegiacaaaaaaaaaaaaeaaaaaaogikcaaaaaaaaaaa
aeaaaaaadcaaaaalmccabaaaabaaaaaaagbebaaaadaaaaaaagiecaaaaaaaaaaa
afaaaaaakgiocaaaaaaaaaaaafaaaaaadiaaaaahhcaabaaaabaaaaaajgbebaaa
abaaaaaacgbjbaaaacaaaaaadcaaaaakhcaabaaaabaaaaaajgbebaaaacaaaaaa
cgbjbaaaabaaaaaaegacbaiaebaaaaaaabaaaaaadiaaaaahhcaabaaaabaaaaaa
egacbaaaabaaaaaapgbpbaaaabaaaaaadgaaaaagbcaabaaaacaaaaaaakiacaaa
adaaaaaaaiaaaaaadgaaaaagccaabaaaacaaaaaaakiacaaaadaaaaaaajaaaaaa
dgaaaaagecaabaaaacaaaaaaakiacaaaadaaaaaaakaaaaaabaaaaaahcccabaaa
acaaaaaaegacbaaaabaaaaaaegacbaaaacaaaaaabaaaaaahbccabaaaacaaaaaa
egbcbaaaabaaaaaaegacbaaaacaaaaaabaaaaaaheccabaaaacaaaaaaegbcbaaa
acaaaaaaegacbaaaacaaaaaadgaaaaagbcaabaaaacaaaaaabkiacaaaadaaaaaa
aiaaaaaadgaaaaagccaabaaaacaaaaaabkiacaaaadaaaaaaajaaaaaadgaaaaag
ecaabaaaacaaaaaabkiacaaaadaaaaaaakaaaaaabaaaaaahcccabaaaadaaaaaa
egacbaaaabaaaaaaegacbaaaacaaaaaabaaaaaahbccabaaaadaaaaaaegbcbaaa
abaaaaaaegacbaaaacaaaaaabaaaaaaheccabaaaadaaaaaaegbcbaaaacaaaaaa
egacbaaaacaaaaaadiaaaaaiccaabaaaaaaaaaaabkaabaaaaaaaaaaaakiacaaa
abaaaaaaafaaaaaadiaaaaakncaabaaaabaaaaaaagahbaaaaaaaaaaaaceaaaaa
aaaaaadpaaaaaaaaaaaaaadpaaaaaadpdgaaaaafmccabaaaaeaaaaaakgaobaaa
aaaaaaaaaaaaaaahdccabaaaaeaaaaaakgakbaaaabaaaaaamgaabaaaabaaaaaa
diaaaaaihcaabaaaaaaaaaaaegbcbaaaacaaaaaapgipcaaaadaaaaaabeaaaaaa
diaaaaaihcaabaaaabaaaaaafgafbaaaaaaaaaaaegiccaaaadaaaaaaanaaaaaa
dcaaaaaklcaabaaaaaaaaaaaegiicaaaadaaaaaaamaaaaaaagaabaaaaaaaaaaa
egaibaaaabaaaaaadcaaaaakhcaabaaaaaaaaaaaegiccaaaadaaaaaaaoaaaaaa
kgakbaaaaaaaaaaaegadbaaaaaaaaaaadgaaaaaficaabaaaaaaaaaaaabeaaaaa
aaaaiadpbbaaaaaibcaabaaaabaaaaaaegiocaaaacaaaaaabcaaaaaaegaobaaa
aaaaaaaabbaaaaaiccaabaaaabaaaaaaegiocaaaacaaaaaabdaaaaaaegaobaaa
aaaaaaaabbaaaaaiecaabaaaabaaaaaaegiocaaaacaaaaaabeaaaaaaegaobaaa
aaaaaaaadiaaaaahpcaabaaaacaaaaaajgacbaaaaaaaaaaaegakbaaaaaaaaaaa
bbaaaaaibcaabaaaadaaaaaaegiocaaaacaaaaaabfaaaaaaegaobaaaacaaaaaa
bbaaaaaiccaabaaaadaaaaaaegiocaaaacaaaaaabgaaaaaaegaobaaaacaaaaaa
bbaaaaaiecaabaaaadaaaaaaegiocaaaacaaaaaabhaaaaaaegaobaaaacaaaaaa
aaaaaaahhcaabaaaabaaaaaaegacbaaaabaaaaaaegacbaaaadaaaaaadiaaaaah
ccaabaaaaaaaaaaabkaabaaaaaaaaaaabkaabaaaaaaaaaaadcaaaaakbcaabaaa
aaaaaaaaakaabaaaaaaaaaaaakaabaaaaaaaaaaabkaabaiaebaaaaaaaaaaaaaa
dcaaaaakhccabaaaafaaaaaaegiccaaaacaaaaaabiaaaaaaagaabaaaaaaaaaaa
egacbaaaabaaaaaadoaaaaabejfdeheomaaaaaaaagaaaaaaaiaaaaaajiaaaaaa
aaaaaaaaaaaaaaaaadaaaaaaaaaaaaaaapapaaaakbaaaaaaaaaaaaaaaaaaaaaa
adaaaaaaabaaaaaaapapaaaakjaaaaaaaaaaaaaaaaaaaaaaadaaaaaaacaaaaaa
ahahaaaalaaaaaaaaaaaaaaaaaaaaaaaadaaaaaaadaaaaaaapadaaaalaaaaaaa
abaaaaaaaaaaaaaaadaaaaaaaeaaaaaaapaaaaaaljaaaaaaaaaaaaaaaaaaaaaa
adaaaaaaafaaaaaaapaaaaaafaepfdejfeejepeoaafeebeoehefeofeaaeoepfc
enebemaafeeffiedepepfceeaaedepemepfcaaklepfdeheolaaaaaaaagaaaaaa
aiaaaaaajiaaaaaaaaaaaaaaabaaaaaaadaaaaaaaaaaaaaaapaaaaaakeaaaaaa
aaaaaaaaaaaaaaaaadaaaaaaabaaaaaaapaaaaaakeaaaaaaabaaaaaaaaaaaaaa
adaaaaaaacaaaaaaahaiaaaakeaaaaaaacaaaaaaaaaaaaaaadaaaaaaadaaaaaa
ahaiaaaakeaaaaaaadaaaaaaaaaaaaaaadaaaaaaaeaaaaaaapaaaaaakeaaaaaa
aeaaaaaaaaaaaaaaadaaaaaaafaaaaaaahaiaaaafdfgfpfaepfdejfeejepeoaa
feeffiedepepfceeaaklklkl"
}

SubProgram "opengl " {
Keywords { "LIGHTMAP_ON" "DIRLIGHTMAP_OFF" "HDR_LIGHT_PREPASS_ON" }
Bind "vertex" Vertex
Bind "tangent" ATTR14
Bind "normal" Normal
Bind "texcoord" TexCoord0
Bind "texcoord1" TexCoord1
Vector 17 [_ProjectionParams]
Vector 18 [unity_ShadowFadeCenterAndType]
Matrix 13 [_Object2World]
Vector 19 [unity_LightmapST]
Vector 20 [_MainTex_ST]
Vector 21 [_BumpMap_ST]
"!!ARBvp1.0
# 31 ALU
PARAM c[22] = { { 0.5, 1 },
		state.matrix.modelview[0],
		state.matrix.mvp,
		state.matrix.modelview[0].invtrans,
		program.local[13..21] };
TEMP R0;
TEMP R1;
TEMP R2;
MOV R0.xyz, vertex.attrib[14];
MUL R1.xyz, vertex.normal.zxyw, R0.yzxw;
MAD R0.xyz, vertex.normal.yzxw, R0.zxyw, -R1;
MUL R2.xyz, R0, vertex.attrib[14].w;
DP4 R0.w, vertex.position, c[8];
DP4 R0.z, vertex.position, c[7];
DP4 R0.x, vertex.position, c[5];
DP4 R0.y, vertex.position, c[6];
MUL R1.xyz, R0.xyww, c[0].x;
MUL R1.y, R1, c[17].x;
ADD result.texcoord[3].xy, R1, R1.z;
MOV result.position, R0;
MOV R0.x, c[0].y;
ADD R0.y, R0.x, -c[18].w;
DP4 R0.x, vertex.position, c[3];
DP4 R1.z, vertex.position, c[15];
DP4 R1.x, vertex.position, c[13];
DP4 R1.y, vertex.position, c[14];
ADD R1.xyz, R1, -c[18];
DP3 result.texcoord[1].y, R2, c[9];
DP3 result.texcoord[2].y, R2, c[10];
MOV result.texcoord[3].zw, R0;
MUL result.texcoord[5].xyz, R1, c[18].w;
MAD result.texcoord[0].zw, vertex.texcoord[0].xyxy, c[21].xyxy, c[21];
MAD result.texcoord[0].xy, vertex.texcoord[0], c[20], c[20].zwzw;
MAD result.texcoord[4].xy, vertex.texcoord[1], c[19], c[19].zwzw;
MUL result.texcoord[5].w, -R0.x, R0.y;
DP3 result.texcoord[1].z, vertex.normal, c[9];
DP3 result.texcoord[1].x, vertex.attrib[14], c[9];
DP3 result.texcoord[2].z, vertex.normal, c[10];
DP3 result.texcoord[2].x, vertex.attrib[14], c[10];
END
# 31 instructions, 3 R-regs
"
}

SubProgram "d3d9 " {
Keywords { "LIGHTMAP_ON" "DIRLIGHTMAP_OFF" "HDR_LIGHT_PREPASS_ON" }
Bind "vertex" Vertex
Bind "tangent" TexCoord2
Bind "normal" Normal
Bind "texcoord" TexCoord0
Bind "texcoord1" TexCoord1
Matrix 0 [glstate_matrix_modelview0]
Matrix 4 [glstate_matrix_mvp]
Matrix 8 [glstate_matrix_invtrans_modelview0]
Vector 16 [_ProjectionParams]
Vector 17 [_ScreenParams]
Vector 18 [unity_ShadowFadeCenterAndType]
Matrix 12 [_Object2World]
Vector 19 [unity_LightmapST]
Vector 20 [_MainTex_ST]
Vector 21 [_BumpMap_ST]
"vs_2_0
; 32 ALU
def c22, 0.50000000, 1.00000000, 0, 0
dcl_position0 v0
dcl_tangent0 v1
dcl_normal0 v2
dcl_texcoord0 v3
dcl_texcoord1 v4
mov r0.xyz, v1
mul r1.xyz, v2.zxyw, r0.yzxw
mov r0.xyz, v1
mad r0.xyz, v2.yzxw, r0.zxyw, -r1
mul r2.xyz, r0, v1.w
dp4 r0.w, v0, c7
dp4 r0.z, v0, c6
dp4 r0.x, v0, c4
dp4 r0.y, v0, c5
mul r1.xyz, r0.xyww, c22.x
mul r1.y, r1, c16.x
mad oT3.xy, r1.z, c17.zwzw, r1
mov oPos, r0
mov r0.x, c18.w
add r0.y, c22, -r0.x
dp4 r0.x, v0, c2
dp4 r1.z, v0, c14
dp4 r1.x, v0, c12
dp4 r1.y, v0, c13
add r1.xyz, r1, -c18
dp3 oT1.y, r2, c8
dp3 oT2.y, r2, c9
mov oT3.zw, r0
mul oT5.xyz, r1, c18.w
mad oT0.zw, v3.xyxy, c21.xyxy, c21
mad oT0.xy, v3, c20, c20.zwzw
mad oT4.xy, v4, c19, c19.zwzw
mul oT5.w, -r0.x, r0.y
dp3 oT1.z, v2, c8
dp3 oT1.x, v1, c8
dp3 oT2.z, v2, c9
dp3 oT2.x, v1, c9
"
}

SubProgram "d3d11 " {
Keywords { "LIGHTMAP_ON" "DIRLIGHTMAP_OFF" "HDR_LIGHT_PREPASS_ON" }
Bind "vertex" Vertex
Bind "tangent" TexCoord2
Bind "normal" Normal
Bind "texcoord" TexCoord0
Bind "texcoord1" TexCoord1
Bind "color" Color
ConstBuffer "$Globals" 160 // 112 used size, 10 vars
Vector 64 [unity_LightmapST] 4
Vector 80 [_MainTex_ST] 4
Vector 96 [_BumpMap_ST] 4
ConstBuffer "UnityPerCamera" 128 // 96 used size, 8 vars
Vector 80 [_ProjectionParams] 4
ConstBuffer "UnityShadows" 416 // 416 used size, 8 vars
Vector 400 [unity_ShadowFadeCenterAndType] 4
ConstBuffer "UnityPerDraw" 336 // 256 used size, 6 vars
Matrix 0 [glstate_matrix_mvp] 4
Matrix 64 [glstate_matrix_modelview0] 4
Matrix 128 [glstate_matrix_invtrans_modelview0] 4
Matrix 192 [_Object2World] 4
BindCB "$Globals" 0
BindCB "UnityPerCamera" 1
BindCB "UnityShadows" 2
BindCB "UnityPerDraw" 3
// 40 instructions, 3 temp regs, 0 temp arrays:
// ALU 18 float, 0 int, 0 uint
// TEX 0 (0 load, 0 comp, 0 bias, 0 grad)
// FLOW 1 static, 0 dynamic
"vs_4_0
eefieceddgafdejbhaohagalejpbbjcdgnigfeghabaaaaaakmahaaaaadaaaaaa
cmaaaaaapeaaaaaameabaaaaejfdeheomaaaaaaaagaaaaaaaiaaaaaajiaaaaaa
aaaaaaaaaaaaaaaaadaaaaaaaaaaaaaaapapaaaakbaaaaaaaaaaaaaaaaaaaaaa
adaaaaaaabaaaaaaapapaaaakjaaaaaaaaaaaaaaaaaaaaaaadaaaaaaacaaaaaa
ahahaaaalaaaaaaaaaaaaaaaaaaaaaaaadaaaaaaadaaaaaaapadaaaalaaaaaaa
abaaaaaaaaaaaaaaadaaaaaaaeaaaaaaapadaaaaljaaaaaaaaaaaaaaaaaaaaaa
adaaaaaaafaaaaaaapaaaaaafaepfdejfeejepeoaafeebeoehefeofeaaeoepfc
enebemaafeeffiedepepfceeaaedepemepfcaaklepfdeheomiaaaaaaahaaaaaa
aiaaaaaalaaaaaaaaaaaaaaaabaaaaaaadaaaaaaaaaaaaaaapaaaaaalmaaaaaa
aaaaaaaaaaaaaaaaadaaaaaaabaaaaaaapaaaaaalmaaaaaaabaaaaaaaaaaaaaa
adaaaaaaacaaaaaaahaiaaaalmaaaaaaacaaaaaaaaaaaaaaadaaaaaaadaaaaaa
ahaiaaaalmaaaaaaadaaaaaaaaaaaaaaadaaaaaaaeaaaaaaapaaaaaalmaaaaaa
aeaaaaaaaaaaaaaaadaaaaaaafaaaaaaadamaaaalmaaaaaaafaaaaaaaaaaaaaa
adaaaaaaagaaaaaaapaaaaaafdfgfpfaepfdejfeejepeoaafeeffiedepepfcee
aaklklklfdeieefcoaafaaaaeaaaabaahiabaaaafjaaaaaeegiocaaaaaaaaaaa
ahaaaaaafjaaaaaeegiocaaaabaaaaaaagaaaaaafjaaaaaeegiocaaaacaaaaaa
bkaaaaaafjaaaaaeegiocaaaadaaaaaabaaaaaaafpaaaaadpcbabaaaaaaaaaaa
fpaaaaadpcbabaaaabaaaaaafpaaaaadhcbabaaaacaaaaaafpaaaaaddcbabaaa
adaaaaaafpaaaaaddcbabaaaaeaaaaaaghaaaaaepccabaaaaaaaaaaaabaaaaaa
gfaaaaadpccabaaaabaaaaaagfaaaaadhccabaaaacaaaaaagfaaaaadhccabaaa
adaaaaaagfaaaaadpccabaaaaeaaaaaagfaaaaaddccabaaaafaaaaaagfaaaaad
pccabaaaagaaaaaagiaaaaacadaaaaaadiaaaaaipcaabaaaaaaaaaaafgbfbaaa
aaaaaaaaegiocaaaadaaaaaaabaaaaaadcaaaaakpcaabaaaaaaaaaaaegiocaaa
adaaaaaaaaaaaaaaagbabaaaaaaaaaaaegaobaaaaaaaaaaadcaaaaakpcaabaaa
aaaaaaaaegiocaaaadaaaaaaacaaaaaakgbkbaaaaaaaaaaaegaobaaaaaaaaaaa
dcaaaaakpcaabaaaaaaaaaaaegiocaaaadaaaaaaadaaaaaapgbpbaaaaaaaaaaa
egaobaaaaaaaaaaadgaaaaafpccabaaaaaaaaaaaegaobaaaaaaaaaaadcaaaaal
dccabaaaabaaaaaaegbabaaaadaaaaaaegiacaaaaaaaaaaaafaaaaaaogikcaaa
aaaaaaaaafaaaaaadcaaaaalmccabaaaabaaaaaaagbebaaaadaaaaaaagiecaaa
aaaaaaaaagaaaaaakgiocaaaaaaaaaaaagaaaaaadiaaaaahhcaabaaaabaaaaaa
jgbebaaaabaaaaaacgbjbaaaacaaaaaadcaaaaakhcaabaaaabaaaaaajgbebaaa
acaaaaaacgbjbaaaabaaaaaaegacbaiaebaaaaaaabaaaaaadiaaaaahhcaabaaa
abaaaaaaegacbaaaabaaaaaapgbpbaaaabaaaaaadgaaaaagbcaabaaaacaaaaaa
akiacaaaadaaaaaaaiaaaaaadgaaaaagccaabaaaacaaaaaaakiacaaaadaaaaaa
ajaaaaaadgaaaaagecaabaaaacaaaaaaakiacaaaadaaaaaaakaaaaaabaaaaaah
cccabaaaacaaaaaaegacbaaaabaaaaaaegacbaaaacaaaaaabaaaaaahbccabaaa
acaaaaaaegbcbaaaabaaaaaaegacbaaaacaaaaaabaaaaaaheccabaaaacaaaaaa
egbcbaaaacaaaaaaegacbaaaacaaaaaadgaaaaagbcaabaaaacaaaaaabkiacaaa
adaaaaaaaiaaaaaadgaaaaagccaabaaaacaaaaaabkiacaaaadaaaaaaajaaaaaa
dgaaaaagecaabaaaacaaaaaabkiacaaaadaaaaaaakaaaaaabaaaaaahcccabaaa
adaaaaaaegacbaaaabaaaaaaegacbaaaacaaaaaabaaaaaahbccabaaaadaaaaaa
egbcbaaaabaaaaaaegacbaaaacaaaaaabaaaaaaheccabaaaadaaaaaaegbcbaaa
acaaaaaaegacbaaaacaaaaaadiaaaaaiccaabaaaaaaaaaaabkaabaaaaaaaaaaa
akiacaaaabaaaaaaafaaaaaadiaaaaakncaabaaaabaaaaaaagahbaaaaaaaaaaa
aceaaaaaaaaaaadpaaaaaaaaaaaaaadpaaaaaadpdgaaaaafmccabaaaaeaaaaaa
kgaobaaaaaaaaaaaaaaaaaahdccabaaaaeaaaaaakgakbaaaabaaaaaamgaabaaa
abaaaaaadcaaaaaldccabaaaafaaaaaaegbabaaaaeaaaaaaegiacaaaaaaaaaaa
aeaaaaaaogikcaaaaaaaaaaaaeaaaaaadiaaaaaihcaabaaaaaaaaaaafgbfbaaa
aaaaaaaaegiccaaaadaaaaaaanaaaaaadcaaaaakhcaabaaaaaaaaaaaegiccaaa
adaaaaaaamaaaaaaagbabaaaaaaaaaaaegacbaaaaaaaaaaadcaaaaakhcaabaaa
aaaaaaaaegiccaaaadaaaaaaaoaaaaaakgbkbaaaaaaaaaaaegacbaaaaaaaaaaa
dcaaaaakhcaabaaaaaaaaaaaegiccaaaadaaaaaaapaaaaaapgbpbaaaaaaaaaaa
egacbaaaaaaaaaaaaaaaaaajhcaabaaaaaaaaaaaegacbaaaaaaaaaaaegiccaia
ebaaaaaaacaaaaaabjaaaaaadiaaaaaihccabaaaagaaaaaaegacbaaaaaaaaaaa
pgipcaaaacaaaaaabjaaaaaadiaaaaaibcaabaaaaaaaaaaabkbabaaaaaaaaaaa
ckiacaaaadaaaaaaafaaaaaadcaaaaakbcaabaaaaaaaaaaackiacaaaadaaaaaa
aeaaaaaaakbabaaaaaaaaaaaakaabaaaaaaaaaaadcaaaaakbcaabaaaaaaaaaaa
ckiacaaaadaaaaaaagaaaaaackbabaaaaaaaaaaaakaabaaaaaaaaaaadcaaaaak
bcaabaaaaaaaaaaackiacaaaadaaaaaaahaaaaaadkbabaaaaaaaaaaaakaabaaa
aaaaaaaaaaaaaaajccaabaaaaaaaaaaadkiacaiaebaaaaaaacaaaaaabjaaaaaa
abeaaaaaaaaaiadpdiaaaaaiiccabaaaagaaaaaabkaabaaaaaaaaaaaakaabaia
ebaaaaaaaaaaaaaadoaaaaab"
}

SubProgram "gles " {
Keywords { "LIGHTMAP_ON" "DIRLIGHTMAP_OFF" "HDR_LIGHT_PREPASS_ON" }
"!!GLES
#define SHADER_API_GLES 1
#define tex2D texture2D


#ifdef VERTEX
#define gl_ModelViewProjectionMatrix glstate_matrix_mvp
uniform mat4 glstate_matrix_mvp;
#define gl_ModelViewMatrixInverseTranspose glstate_matrix_invtrans_modelview0
uniform mat4 glstate_matrix_invtrans_modelview0;
#define gl_ModelViewMatrix glstate_matrix_modelview0
uniform mat4 glstate_matrix_modelview0;

varying highp vec4 xlv_TEXCOORD5;
varying highp vec2 xlv_TEXCOORD4;
varying highp vec4 xlv_TEXCOORD3;
varying highp vec3 xlv_TEXCOORD2;
varying highp vec3 xlv_TEXCOORD1;
varying highp vec4 xlv_TEXCOORD0;
uniform highp vec4 _BumpMap_ST;
uniform highp vec4 _MainTex_ST;
uniform highp vec4 unity_LightmapST;
uniform highp mat4 _Object2World;



uniform highp vec4 unity_ShadowFadeCenterAndType;
uniform highp vec4 _ProjectionParams;
attribute vec4 _glesTANGENT;
attribute vec4 _glesMultiTexCoord1;
attribute vec4 _glesMultiTexCoord0;
attribute vec3 _glesNormal;
attribute vec4 _glesVertex;
void main ()
{
  vec4 tmpvar_1;
  tmpvar_1.xyz = normalize(_glesTANGENT.xyz);
  tmpvar_1.w = _glesTANGENT.w;
  vec3 tmpvar_2;
  tmpvar_2 = normalize(_glesNormal);
  highp vec4 tmpvar_3;
  highp vec4 tmpvar_4;
  highp vec3 tmpvar_5;
  highp vec3 tmpvar_6;
  tmpvar_5 = tmpvar_1.xyz;
  tmpvar_6 = (((tmpvar_2.yzx * tmpvar_1.zxy) - (tmpvar_2.zxy * tmpvar_1.yzx)) * _glesTANGENT.w);
  highp mat3 tmpvar_7;
  tmpvar_7[0].x = tmpvar_5.x;
  tmpvar_7[0].y = tmpvar_6.x;
  tmpvar_7[0].z = tmpvar_2.x;
  tmpvar_7[1].x = tmpvar_5.y;
  tmpvar_7[1].y = tmpvar_6.y;
  tmpvar_7[1].z = tmpvar_2.y;
  tmpvar_7[2].x = tmpvar_5.z;
  tmpvar_7[2].y = tmpvar_6.z;
  tmpvar_7[2].z = tmpvar_2.z;
  vec4 v_8;
  v_8.x = gl_ModelViewMatrixInverseTranspose[0].x;
  v_8.y = gl_ModelViewMatrixInverseTranspose[1].x;
  v_8.z = gl_ModelViewMatrixInverseTranspose[2].x;
  v_8.w = gl_ModelViewMatrixInverseTranspose[3].x;
  vec4 v_9;
  v_9.x = gl_ModelViewMatrixInverseTranspose[0].y;
  v_9.y = gl_ModelViewMatrixInverseTranspose[1].y;
  v_9.z = gl_ModelViewMatrixInverseTranspose[2].y;
  v_9.w = gl_ModelViewMatrixInverseTranspose[3].y;
  highp vec4 tmpvar_10;
  tmpvar_10 = (gl_ModelViewProjectionMatrix * _glesVertex);
  tmpvar_3.xy = ((_glesMultiTexCoord0.xy * _MainTex_ST.xy) + _MainTex_ST.zw);
  tmpvar_3.zw = ((_glesMultiTexCoord0.xy * _BumpMap_ST.xy) + _BumpMap_ST.zw);
  highp vec4 o_11;
  highp vec4 tmpvar_12;
  tmpvar_12 = (tmpvar_10 * 0.5);
  highp vec2 tmpvar_13;
  tmpvar_13.x = tmpvar_12.x;
  tmpvar_13.y = (tmpvar_12.y * _ProjectionParams.x);
  o_11.xy = (tmpvar_13 + tmpvar_12.w);
  o_11.zw = tmpvar_10.zw;
  tmpvar_4.xyz = (((_Object2World * _glesVertex).xyz - unity_ShadowFadeCenterAndType.xyz) * unity_ShadowFadeCenterAndType.w);
  tmpvar_4.w = (-((gl_ModelViewMatrix * _glesVertex).z) * (1.0 - unity_ShadowFadeCenterAndType.w));
  gl_Position = tmpvar_10;
  xlv_TEXCOORD0 = tmpvar_3;
  xlv_TEXCOORD1 = (tmpvar_7 * v_8.xyz);
  xlv_TEXCOORD2 = (tmpvar_7 * v_9.xyz);
  xlv_TEXCOORD3 = o_11;
  xlv_TEXCOORD4 = ((_glesMultiTexCoord1.xy * unity_LightmapST.xy) + unity_LightmapST.zw);
  xlv_TEXCOORD5 = tmpvar_4;
}



#endif
#ifdef FRAGMENT

varying highp vec4 xlv_TEXCOORD5;
varying highp vec2 xlv_TEXCOORD4;
varying highp vec4 xlv_TEXCOORD3;
varying highp vec3 xlv_TEXCOORD2;
varying highp vec3 xlv_TEXCOORD1;
varying highp vec4 xlv_TEXCOORD0;
uniform lowp float _Cutoff;
uniform highp vec4 unity_LightmapFade;
uniform sampler2D unity_LightmapInd;
uniform sampler2D unity_Lightmap;
uniform sampler2D _LightBuffer;
uniform sampler2D _Shade;
uniform sampler2D _BumpMap;
uniform sampler2D _MainTex;
uniform lowp vec4 _Color;
void main ()
{
  lowp vec4 tmpvar_1;
  mediump vec4 c_2;
  mediump vec3 lmIndirect_3;
  mediump vec3 lmFull_4;
  mediump vec4 light_5;
  lowp vec3 tmpvar_6;
  highp vec3 matcap_7;
  lowp vec3 tmpvar_8;
  tmpvar_8 = ((texture2D (_BumpMap, xlv_TEXCOORD0.zw).xyz * 2.0) - 1.0);
  lowp vec3 tmpvar_9;
  tmpvar_9 = (texture2D (_MainTex, xlv_TEXCOORD0.xy).xyz * _Color.w);
  highp vec2 tmpvar_10;
  tmpvar_10.x = dot (xlv_TEXCOORD1, tmpvar_8);
  tmpvar_10.y = dot (xlv_TEXCOORD2, tmpvar_8);
  highp vec2 P_11;
  P_11 = ((tmpvar_10 * 0.5) + 0.5);
  lowp vec3 tmpvar_12;
  tmpvar_12 = texture2D (_Shade, P_11).xyz;
  matcap_7 = tmpvar_12;
  lowp vec4 tmpvar_13;
  tmpvar_13 = texture2D (_MainTex, xlv_TEXCOORD0.xy);
  highp vec3 tmpvar_14;
  tmpvar_14 = (((matcap_7 * tmpvar_13.xyz) * _Color.xyz) * 3.0);
  tmpvar_6 = tmpvar_14;
  lowp vec4 tmpvar_15;
  tmpvar_15 = texture2D (_MainTex, xlv_TEXCOORD0.xy);
  lowp float x_16;
  x_16 = (tmpvar_15.w - _Cutoff);
  if ((x_16 < 0.0)) {
    discard;
  };
  lowp vec4 tmpvar_17;
  tmpvar_17 = texture2DProj (_LightBuffer, xlv_TEXCOORD3);
  light_5 = tmpvar_17;
  mediump vec4 tmpvar_18;
  tmpvar_18 = max (light_5, vec4(0.001, 0.001, 0.001, 0.001));
  light_5.w = tmpvar_18.w;
  lowp vec3 tmpvar_19;
  tmpvar_19 = (2.0 * texture2D (unity_Lightmap, xlv_TEXCOORD4).xyz);
  lmFull_4 = tmpvar_19;
  lowp vec3 tmpvar_20;
  tmpvar_20 = (2.0 * texture2D (unity_LightmapInd, xlv_TEXCOORD4).xyz);
  lmIndirect_3 = tmpvar_20;
  highp float tmpvar_21;
  tmpvar_21 = clamp (((sqrt(dot (xlv_TEXCOORD5, xlv_TEXCOORD5)) * unity_LightmapFade.z) + unity_LightmapFade.w), 0.0, 1.0);
  light_5.xyz = (tmpvar_18.xyz + mix (lmIndirect_3, lmFull_4, vec3(tmpvar_21)));
  lowp vec4 c_22;
  mediump vec3 tmpvar_23;
  tmpvar_23 = (tmpvar_9 * light_5.xyz);
  c_22.xyz = tmpvar_23;
  c_22.w = tmpvar_15.w;
  c_2 = c_22;
  c_2.xyz = (c_2.xyz + tmpvar_6);
  tmpvar_1 = c_2;
  gl_FragData[0] = tmpvar_1;
}



#endif"
}

SubProgram "glesdesktop " {
Keywords { "LIGHTMAP_ON" "DIRLIGHTMAP_OFF" "HDR_LIGHT_PREPASS_ON" }
"!!GLES
#define SHADER_API_GLES 1
#define tex2D texture2D


#ifdef VERTEX
#define gl_ModelViewProjectionMatrix glstate_matrix_mvp
uniform mat4 glstate_matrix_mvp;
#define gl_ModelViewMatrixInverseTranspose glstate_matrix_invtrans_modelview0
uniform mat4 glstate_matrix_invtrans_modelview0;
#define gl_ModelViewMatrix glstate_matrix_modelview0
uniform mat4 glstate_matrix_modelview0;

varying highp vec4 xlv_TEXCOORD5;
varying highp vec2 xlv_TEXCOORD4;
varying highp vec4 xlv_TEXCOORD3;
varying highp vec3 xlv_TEXCOORD2;
varying highp vec3 xlv_TEXCOORD1;
varying highp vec4 xlv_TEXCOORD0;
uniform highp vec4 _BumpMap_ST;
uniform highp vec4 _MainTex_ST;
uniform highp vec4 unity_LightmapST;
uniform highp mat4 _Object2World;



uniform highp vec4 unity_ShadowFadeCenterAndType;
uniform highp vec4 _ProjectionParams;
attribute vec4 _glesTANGENT;
attribute vec4 _glesMultiTexCoord1;
attribute vec4 _glesMultiTexCoord0;
attribute vec3 _glesNormal;
attribute vec4 _glesVertex;
void main ()
{
  vec4 tmpvar_1;
  tmpvar_1.xyz = normalize(_glesTANGENT.xyz);
  tmpvar_1.w = _glesTANGENT.w;
  vec3 tmpvar_2;
  tmpvar_2 = normalize(_glesNormal);
  highp vec4 tmpvar_3;
  highp vec4 tmpvar_4;
  highp vec3 tmpvar_5;
  highp vec3 tmpvar_6;
  tmpvar_5 = tmpvar_1.xyz;
  tmpvar_6 = (((tmpvar_2.yzx * tmpvar_1.zxy) - (tmpvar_2.zxy * tmpvar_1.yzx)) * _glesTANGENT.w);
  highp mat3 tmpvar_7;
  tmpvar_7[0].x = tmpvar_5.x;
  tmpvar_7[0].y = tmpvar_6.x;
  tmpvar_7[0].z = tmpvar_2.x;
  tmpvar_7[1].x = tmpvar_5.y;
  tmpvar_7[1].y = tmpvar_6.y;
  tmpvar_7[1].z = tmpvar_2.y;
  tmpvar_7[2].x = tmpvar_5.z;
  tmpvar_7[2].y = tmpvar_6.z;
  tmpvar_7[2].z = tmpvar_2.z;
  vec4 v_8;
  v_8.x = gl_ModelViewMatrixInverseTranspose[0].x;
  v_8.y = gl_ModelViewMatrixInverseTranspose[1].x;
  v_8.z = gl_ModelViewMatrixInverseTranspose[2].x;
  v_8.w = gl_ModelViewMatrixInverseTranspose[3].x;
  vec4 v_9;
  v_9.x = gl_ModelViewMatrixInverseTranspose[0].y;
  v_9.y = gl_ModelViewMatrixInverseTranspose[1].y;
  v_9.z = gl_ModelViewMatrixInverseTranspose[2].y;
  v_9.w = gl_ModelViewMatrixInverseTranspose[3].y;
  highp vec4 tmpvar_10;
  tmpvar_10 = (gl_ModelViewProjectionMatrix * _glesVertex);
  tmpvar_3.xy = ((_glesMultiTexCoord0.xy * _MainTex_ST.xy) + _MainTex_ST.zw);
  tmpvar_3.zw = ((_glesMultiTexCoord0.xy * _BumpMap_ST.xy) + _BumpMap_ST.zw);
  highp vec4 o_11;
  highp vec4 tmpvar_12;
  tmpvar_12 = (tmpvar_10 * 0.5);
  highp vec2 tmpvar_13;
  tmpvar_13.x = tmpvar_12.x;
  tmpvar_13.y = (tmpvar_12.y * _ProjectionParams.x);
  o_11.xy = (tmpvar_13 + tmpvar_12.w);
  o_11.zw = tmpvar_10.zw;
  tmpvar_4.xyz = (((_Object2World * _glesVertex).xyz - unity_ShadowFadeCenterAndType.xyz) * unity_ShadowFadeCenterAndType.w);
  tmpvar_4.w = (-((gl_ModelViewMatrix * _glesVertex).z) * (1.0 - unity_ShadowFadeCenterAndType.w));
  gl_Position = tmpvar_10;
  xlv_TEXCOORD0 = tmpvar_3;
  xlv_TEXCOORD1 = (tmpvar_7 * v_8.xyz);
  xlv_TEXCOORD2 = (tmpvar_7 * v_9.xyz);
  xlv_TEXCOORD3 = o_11;
  xlv_TEXCOORD4 = ((_glesMultiTexCoord1.xy * unity_LightmapST.xy) + unity_LightmapST.zw);
  xlv_TEXCOORD5 = tmpvar_4;
}



#endif
#ifdef FRAGMENT

varying highp vec4 xlv_TEXCOORD5;
varying highp vec2 xlv_TEXCOORD4;
varying highp vec4 xlv_TEXCOORD3;
varying highp vec3 xlv_TEXCOORD2;
varying highp vec3 xlv_TEXCOORD1;
varying highp vec4 xlv_TEXCOORD0;
uniform lowp float _Cutoff;
uniform highp vec4 unity_LightmapFade;
uniform sampler2D unity_LightmapInd;
uniform sampler2D unity_Lightmap;
uniform sampler2D _LightBuffer;
uniform sampler2D _Shade;
uniform sampler2D _BumpMap;
uniform sampler2D _MainTex;
uniform lowp vec4 _Color;
void main ()
{
  lowp vec4 tmpvar_1;
  mediump vec4 c_2;
  mediump vec3 lmIndirect_3;
  mediump vec3 lmFull_4;
  mediump vec4 light_5;
  lowp vec3 tmpvar_6;
  highp vec3 matcap_7;
  lowp vec3 normal_8;
  normal_8.xy = ((texture2D (_BumpMap, xlv_TEXCOORD0.zw).wy * 2.0) - 1.0);
  normal_8.z = sqrt(((1.0 - (normal_8.x * normal_8.x)) - (normal_8.y * normal_8.y)));
  lowp vec3 tmpvar_9;
  tmpvar_9 = (texture2D (_MainTex, xlv_TEXCOORD0.xy).xyz * _Color.w);
  highp vec2 tmpvar_10;
  tmpvar_10.x = dot (xlv_TEXCOORD1, normal_8);
  tmpvar_10.y = dot (xlv_TEXCOORD2, normal_8);
  highp vec2 P_11;
  P_11 = ((tmpvar_10 * 0.5) + 0.5);
  lowp vec3 tmpvar_12;
  tmpvar_12 = texture2D (_Shade, P_11).xyz;
  matcap_7 = tmpvar_12;
  lowp vec4 tmpvar_13;
  tmpvar_13 = texture2D (_MainTex, xlv_TEXCOORD0.xy);
  highp vec3 tmpvar_14;
  tmpvar_14 = (((matcap_7 * tmpvar_13.xyz) * _Color.xyz) * 3.0);
  tmpvar_6 = tmpvar_14;
  lowp vec4 tmpvar_15;
  tmpvar_15 = texture2D (_MainTex, xlv_TEXCOORD0.xy);
  lowp float x_16;
  x_16 = (tmpvar_15.w - _Cutoff);
  if ((x_16 < 0.0)) {
    discard;
  };
  lowp vec4 tmpvar_17;
  tmpvar_17 = texture2DProj (_LightBuffer, xlv_TEXCOORD3);
  light_5 = tmpvar_17;
  mediump vec4 tmpvar_18;
  tmpvar_18 = max (light_5, vec4(0.001, 0.001, 0.001, 0.001));
  light_5.w = tmpvar_18.w;
  lowp vec4 tmpvar_19;
  tmpvar_19 = texture2D (unity_Lightmap, xlv_TEXCOORD4);
  lowp vec3 tmpvar_20;
  tmpvar_20 = ((8.0 * tmpvar_19.w) * tmpvar_19.xyz);
  lmFull_4 = tmpvar_20;
  lowp vec4 tmpvar_21;
  tmpvar_21 = texture2D (unity_LightmapInd, xlv_TEXCOORD4);
  lowp vec3 tmpvar_22;
  tmpvar_22 = ((8.0 * tmpvar_21.w) * tmpvar_21.xyz);
  lmIndirect_3 = tmpvar_22;
  highp float tmpvar_23;
  tmpvar_23 = clamp (((sqrt(dot (xlv_TEXCOORD5, xlv_TEXCOORD5)) * unity_LightmapFade.z) + unity_LightmapFade.w), 0.0, 1.0);
  light_5.xyz = (tmpvar_18.xyz + mix (lmIndirect_3, lmFull_4, vec3(tmpvar_23)));
  lowp vec4 c_24;
  mediump vec3 tmpvar_25;
  tmpvar_25 = (tmpvar_9 * light_5.xyz);
  c_24.xyz = tmpvar_25;
  c_24.w = tmpvar_15.w;
  c_2 = c_24;
  c_2.xyz = (c_2.xyz + tmpvar_6);
  tmpvar_1 = c_2;
  gl_FragData[0] = tmpvar_1;
}



#endif"
}

SubProgram "d3d11_9x " {
Keywords { "LIGHTMAP_ON" "DIRLIGHTMAP_OFF" "HDR_LIGHT_PREPASS_ON" }
Bind "vertex" Vertex
Bind "tangent" TexCoord2
Bind "normal" Normal
Bind "texcoord" TexCoord0
Bind "texcoord1" TexCoord1
Bind "color" Color
ConstBuffer "$Globals" 160 // 112 used size, 10 vars
Vector 64 [unity_LightmapST] 4
Vector 80 [_MainTex_ST] 4
Vector 96 [_BumpMap_ST] 4
ConstBuffer "UnityPerCamera" 128 // 96 used size, 8 vars
Vector 80 [_ProjectionParams] 4
ConstBuffer "UnityShadows" 416 // 416 used size, 8 vars
Vector 400 [unity_ShadowFadeCenterAndType] 4
ConstBuffer "UnityPerDraw" 336 // 256 used size, 6 vars
Matrix 0 [glstate_matrix_mvp] 4
Matrix 64 [glstate_matrix_modelview0] 4
Matrix 128 [glstate_matrix_invtrans_modelview0] 4
Matrix 192 [_Object2World] 4
BindCB "$Globals" 0
BindCB "UnityPerCamera" 1
BindCB "UnityShadows" 2
BindCB "UnityPerDraw" 3
// 40 instructions, 3 temp regs, 0 temp arrays:
// ALU 18 float, 0 int, 0 uint
// TEX 0 (0 load, 0 comp, 0 bias, 0 grad)
// FLOW 1 static, 0 dynamic
"vs_4_0_level_9_3
eefiecedkjkgfcgncfidgilmnklclfbimddhgoloabaaaaaadialaaaaaeaaaaaa
daaaaaaaliadaaaakaajaaaagiakaaaaebgpgodjiaadaaaaiaadaaaaaaacpopp
bmadaaaageaaaaaaafaaceaaaaaagaaaaaaagaaaaaaaceaaabaagaaaaaaaaeaa
adaaabaaaaaaaaaaabaaafaaabaaaeaaaaaaaaaaacaabjaaabaaafaaaaaaaaaa
adaaaaaaalaaagaaaaaaaaaaadaaamaaaeaabbaaaaaaaaaaaaaaaaaaabacpopp
fbaaaaafbfaaapkaaaaaaadpaaaaiadpaaaaaaaaaaaaaaaabpaaaaacafaaaaia
aaaaapjabpaaaaacafaaabiaabaaapjabpaaaaacafaaaciaacaaapjabpaaaaac
afaaadiaadaaapjabpaaaaacafaaaeiaaeaaapjaabaaaaacaaaaabiaaoaaaaka
abaaaaacaaaaaciaapaaaakaabaaaaacaaaaaeiabaaaaakaaiaaaaadabaaaboa
abaaoejaaaaaoeiaabaaaaacabaaahiaabaaoejaafaaaaadacaaahiaabaamjia
acaancjaaeaaaaaeabaaahiaacaamjjaabaanciaacaaoeibafaaaaadabaaahia
abaaoeiaabaappjaaiaaaaadabaaacoaabaaoeiaaaaaoeiaaiaaaaadabaaaeoa
acaaoejaaaaaoeiaabaaaaacaaaaabiaaoaaffkaabaaaaacaaaaaciaapaaffka
abaaaaacaaaaaeiabaaaffkaaiaaaaadacaaaboaabaaoejaaaaaoeiaaiaaaaad
acaaacoaabaaoeiaaaaaoeiaaiaaaaadacaaaeoaacaaoejaaaaaoeiaaeaaaaae
aaaaadoaadaaoejaacaaoekaacaaookaaeaaaaaeaaaaamoaadaaeejaadaaeeka
adaaoekaafaaaaadaaaaapiaaaaaffjaahaaoekaaeaaaaaeaaaaapiaagaaoeka
aaaaaajaaaaaoeiaaeaaaaaeaaaaapiaaiaaoekaaaaakkjaaaaaoeiaaeaaaaae
aaaaapiaajaaoekaaaaappjaaaaaoeiaafaaaaadabaaabiaaaaaffiaaeaaaaka
afaaaaadabaaaiiaabaaaaiabfaaaakaafaaaaadabaaafiaaaaapeiabfaaaaka
acaaaaadadaaadoaabaakkiaabaaomiaaeaaaaaeaeaaadoaaeaaoejaabaaoeka
abaaookaafaaaaadabaaahiaaaaaffjabcaaoekaaeaaaaaeabaaahiabbaaoeka
aaaaaajaabaaoeiaaeaaaaaeabaaahiabdaaoekaaaaakkjaabaaoeiaaeaaaaae
abaaahiabeaaoekaaaaappjaabaaoeiaacaaaaadabaaahiaabaaoeiaafaaoekb
afaaaaadafaaahoaabaaoeiaafaappkaafaaaaadabaaabiaaaaaffjaalaakkka
aeaaaaaeabaaabiaakaakkkaaaaaaajaabaaaaiaaeaaaaaeabaaabiaamaakkka
aaaakkjaabaaaaiaaeaaaaaeabaaabiaanaakkkaaaaappjaabaaaaiaabaaaaac
abaaaiiaafaappkaacaaaaadabaaaciaabaappibbfaaffkaafaaaaadafaaaioa
abaaffiaabaaaaibaeaaaaaeaaaaadmaaaaappiaaaaaoekaaaaaoeiaabaaaaac
aaaaammaaaaaoeiaabaaaaacadaaamoaaaaaoeiappppaaaafdeieefcoaafaaaa
eaaaabaahiabaaaafjaaaaaeegiocaaaaaaaaaaaahaaaaaafjaaaaaeegiocaaa
abaaaaaaagaaaaaafjaaaaaeegiocaaaacaaaaaabkaaaaaafjaaaaaeegiocaaa
adaaaaaabaaaaaaafpaaaaadpcbabaaaaaaaaaaafpaaaaadpcbabaaaabaaaaaa
fpaaaaadhcbabaaaacaaaaaafpaaaaaddcbabaaaadaaaaaafpaaaaaddcbabaaa
aeaaaaaaghaaaaaepccabaaaaaaaaaaaabaaaaaagfaaaaadpccabaaaabaaaaaa
gfaaaaadhccabaaaacaaaaaagfaaaaadhccabaaaadaaaaaagfaaaaadpccabaaa
aeaaaaaagfaaaaaddccabaaaafaaaaaagfaaaaadpccabaaaagaaaaaagiaaaaac
adaaaaaadiaaaaaipcaabaaaaaaaaaaafgbfbaaaaaaaaaaaegiocaaaadaaaaaa
abaaaaaadcaaaaakpcaabaaaaaaaaaaaegiocaaaadaaaaaaaaaaaaaaagbabaaa
aaaaaaaaegaobaaaaaaaaaaadcaaaaakpcaabaaaaaaaaaaaegiocaaaadaaaaaa
acaaaaaakgbkbaaaaaaaaaaaegaobaaaaaaaaaaadcaaaaakpcaabaaaaaaaaaaa
egiocaaaadaaaaaaadaaaaaapgbpbaaaaaaaaaaaegaobaaaaaaaaaaadgaaaaaf
pccabaaaaaaaaaaaegaobaaaaaaaaaaadcaaaaaldccabaaaabaaaaaaegbabaaa
adaaaaaaegiacaaaaaaaaaaaafaaaaaaogikcaaaaaaaaaaaafaaaaaadcaaaaal
mccabaaaabaaaaaaagbebaaaadaaaaaaagiecaaaaaaaaaaaagaaaaaakgiocaaa
aaaaaaaaagaaaaaadiaaaaahhcaabaaaabaaaaaajgbebaaaabaaaaaacgbjbaaa
acaaaaaadcaaaaakhcaabaaaabaaaaaajgbebaaaacaaaaaacgbjbaaaabaaaaaa
egacbaiaebaaaaaaabaaaaaadiaaaaahhcaabaaaabaaaaaaegacbaaaabaaaaaa
pgbpbaaaabaaaaaadgaaaaagbcaabaaaacaaaaaaakiacaaaadaaaaaaaiaaaaaa
dgaaaaagccaabaaaacaaaaaaakiacaaaadaaaaaaajaaaaaadgaaaaagecaabaaa
acaaaaaaakiacaaaadaaaaaaakaaaaaabaaaaaahcccabaaaacaaaaaaegacbaaa
abaaaaaaegacbaaaacaaaaaabaaaaaahbccabaaaacaaaaaaegbcbaaaabaaaaaa
egacbaaaacaaaaaabaaaaaaheccabaaaacaaaaaaegbcbaaaacaaaaaaegacbaaa
acaaaaaadgaaaaagbcaabaaaacaaaaaabkiacaaaadaaaaaaaiaaaaaadgaaaaag
ccaabaaaacaaaaaabkiacaaaadaaaaaaajaaaaaadgaaaaagecaabaaaacaaaaaa
bkiacaaaadaaaaaaakaaaaaabaaaaaahcccabaaaadaaaaaaegacbaaaabaaaaaa
egacbaaaacaaaaaabaaaaaahbccabaaaadaaaaaaegbcbaaaabaaaaaaegacbaaa
acaaaaaabaaaaaaheccabaaaadaaaaaaegbcbaaaacaaaaaaegacbaaaacaaaaaa
diaaaaaiccaabaaaaaaaaaaabkaabaaaaaaaaaaaakiacaaaabaaaaaaafaaaaaa
diaaaaakncaabaaaabaaaaaaagahbaaaaaaaaaaaaceaaaaaaaaaaadpaaaaaaaa
aaaaaadpaaaaaadpdgaaaaafmccabaaaaeaaaaaakgaobaaaaaaaaaaaaaaaaaah
dccabaaaaeaaaaaakgakbaaaabaaaaaamgaabaaaabaaaaaadcaaaaaldccabaaa
afaaaaaaegbabaaaaeaaaaaaegiacaaaaaaaaaaaaeaaaaaaogikcaaaaaaaaaaa
aeaaaaaadiaaaaaihcaabaaaaaaaaaaafgbfbaaaaaaaaaaaegiccaaaadaaaaaa
anaaaaaadcaaaaakhcaabaaaaaaaaaaaegiccaaaadaaaaaaamaaaaaaagbabaaa
aaaaaaaaegacbaaaaaaaaaaadcaaaaakhcaabaaaaaaaaaaaegiccaaaadaaaaaa
aoaaaaaakgbkbaaaaaaaaaaaegacbaaaaaaaaaaadcaaaaakhcaabaaaaaaaaaaa
egiccaaaadaaaaaaapaaaaaapgbpbaaaaaaaaaaaegacbaaaaaaaaaaaaaaaaaaj
hcaabaaaaaaaaaaaegacbaaaaaaaaaaaegiccaiaebaaaaaaacaaaaaabjaaaaaa
diaaaaaihccabaaaagaaaaaaegacbaaaaaaaaaaapgipcaaaacaaaaaabjaaaaaa
diaaaaaibcaabaaaaaaaaaaabkbabaaaaaaaaaaackiacaaaadaaaaaaafaaaaaa
dcaaaaakbcaabaaaaaaaaaaackiacaaaadaaaaaaaeaaaaaaakbabaaaaaaaaaaa
akaabaaaaaaaaaaadcaaaaakbcaabaaaaaaaaaaackiacaaaadaaaaaaagaaaaaa
ckbabaaaaaaaaaaaakaabaaaaaaaaaaadcaaaaakbcaabaaaaaaaaaaackiacaaa
adaaaaaaahaaaaaadkbabaaaaaaaaaaaakaabaaaaaaaaaaaaaaaaaajccaabaaa
aaaaaaaadkiacaiaebaaaaaaacaaaaaabjaaaaaaabeaaaaaaaaaiadpdiaaaaai
iccabaaaagaaaaaabkaabaaaaaaaaaaaakaabaiaebaaaaaaaaaaaaaadoaaaaab
ejfdeheomaaaaaaaagaaaaaaaiaaaaaajiaaaaaaaaaaaaaaaaaaaaaaadaaaaaa
aaaaaaaaapapaaaakbaaaaaaaaaaaaaaaaaaaaaaadaaaaaaabaaaaaaapapaaaa
kjaaaaaaaaaaaaaaaaaaaaaaadaaaaaaacaaaaaaahahaaaalaaaaaaaaaaaaaaa
aaaaaaaaadaaaaaaadaaaaaaapadaaaalaaaaaaaabaaaaaaaaaaaaaaadaaaaaa
aeaaaaaaapadaaaaljaaaaaaaaaaaaaaaaaaaaaaadaaaaaaafaaaaaaapaaaaaa
faepfdejfeejepeoaafeebeoehefeofeaaeoepfcenebemaafeeffiedepepfcee
aaedepemepfcaaklepfdeheomiaaaaaaahaaaaaaaiaaaaaalaaaaaaaaaaaaaaa
abaaaaaaadaaaaaaaaaaaaaaapaaaaaalmaaaaaaaaaaaaaaaaaaaaaaadaaaaaa
abaaaaaaapaaaaaalmaaaaaaabaaaaaaaaaaaaaaadaaaaaaacaaaaaaahaiaaaa
lmaaaaaaacaaaaaaaaaaaaaaadaaaaaaadaaaaaaahaiaaaalmaaaaaaadaaaaaa
aaaaaaaaadaaaaaaaeaaaaaaapaaaaaalmaaaaaaaeaaaaaaaaaaaaaaadaaaaaa
afaaaaaaadamaaaalmaaaaaaafaaaaaaaaaaaaaaadaaaaaaagaaaaaaapaaaaaa
fdfgfpfaepfdejfeejepeoaafeeffiedepepfceeaaklklkl"
}

SubProgram "opengl " {
Keywords { "LIGHTMAP_ON" "DIRLIGHTMAP_ON" "HDR_LIGHT_PREPASS_ON" }
Bind "vertex" Vertex
Bind "tangent" ATTR14
Bind "normal" Normal
Bind "texcoord" TexCoord0
Bind "texcoord1" TexCoord1
Vector 9 [_ProjectionParams]
Vector 10 [unity_LightmapST]
Vector 11 [_MainTex_ST]
Vector 12 [_BumpMap_ST]
"!!ARBvp1.0
# 22 ALU
PARAM c[13] = { { 0.5 },
		state.matrix.mvp,
		state.matrix.modelview[0].invtrans,
		program.local[9..12] };
TEMP R0;
TEMP R1;
TEMP R2;
MOV R0.xyz, vertex.attrib[14];
MUL R1.xyz, vertex.normal.zxyw, R0.yzxw;
MAD R0.xyz, vertex.normal.yzxw, R0.zxyw, -R1;
MUL R2.xyz, R0, vertex.attrib[14].w;
DP4 R0.w, vertex.position, c[4];
DP4 R0.z, vertex.position, c[3];
DP4 R0.x, vertex.position, c[1];
DP4 R0.y, vertex.position, c[2];
MUL R1.xyz, R0.xyww, c[0].x;
MUL R1.y, R1, c[9].x;
DP3 result.texcoord[1].y, R2, c[5];
DP3 result.texcoord[2].y, R2, c[6];
ADD result.texcoord[3].xy, R1, R1.z;
MOV result.position, R0;
MOV result.texcoord[3].zw, R0;
MAD result.texcoord[0].zw, vertex.texcoord[0].xyxy, c[12].xyxy, c[12];
MAD result.texcoord[0].xy, vertex.texcoord[0], c[11], c[11].zwzw;
MAD result.texcoord[4].xy, vertex.texcoord[1], c[10], c[10].zwzw;
DP3 result.texcoord[1].z, vertex.normal, c[5];
DP3 result.texcoord[1].x, vertex.attrib[14], c[5];
DP3 result.texcoord[2].z, vertex.normal, c[6];
DP3 result.texcoord[2].x, vertex.attrib[14], c[6];
END
# 22 instructions, 3 R-regs
"
}

SubProgram "d3d9 " {
Keywords { "LIGHTMAP_ON" "DIRLIGHTMAP_ON" "HDR_LIGHT_PREPASS_ON" }
Bind "vertex" Vertex
Bind "tangent" TexCoord2
Bind "normal" Normal
Bind "texcoord" TexCoord0
Bind "texcoord1" TexCoord1
Matrix 0 [glstate_matrix_mvp]
Matrix 4 [glstate_matrix_invtrans_modelview0]
Vector 8 [_ProjectionParams]
Vector 9 [_ScreenParams]
Vector 10 [unity_LightmapST]
Vector 11 [_MainTex_ST]
Vector 12 [_BumpMap_ST]
"vs_2_0
; 23 ALU
def c13, 0.50000000, 0, 0, 0
dcl_position0 v0
dcl_tangent0 v1
dcl_normal0 v2
dcl_texcoord0 v3
dcl_texcoord1 v4
mov r0.xyz, v1
mul r1.xyz, v2.zxyw, r0.yzxw
mov r0.xyz, v1
mad r0.xyz, v2.yzxw, r0.zxyw, -r1
mul r2.xyz, r0, v1.w
dp4 r0.w, v0, c3
dp4 r0.z, v0, c2
dp4 r0.x, v0, c0
dp4 r0.y, v0, c1
mul r1.xyz, r0.xyww, c13.x
mul r1.y, r1, c8.x
dp3 oT1.y, r2, c4
dp3 oT2.y, r2, c5
mad oT3.xy, r1.z, c9.zwzw, r1
mov oPos, r0
mov oT3.zw, r0
mad oT0.zw, v3.xyxy, c12.xyxy, c12
mad oT0.xy, v3, c11, c11.zwzw
mad oT4.xy, v4, c10, c10.zwzw
dp3 oT1.z, v2, c4
dp3 oT1.x, v1, c4
dp3 oT2.z, v2, c5
dp3 oT2.x, v1, c5
"
}

SubProgram "d3d11 " {
Keywords { "LIGHTMAP_ON" "DIRLIGHTMAP_ON" "HDR_LIGHT_PREPASS_ON" }
Bind "vertex" Vertex
Bind "tangent" TexCoord2
Bind "normal" Normal
Bind "texcoord" TexCoord0
Bind "texcoord1" TexCoord1
Bind "color" Color
ConstBuffer "$Globals" 160 // 112 used size, 10 vars
Vector 64 [unity_LightmapST] 4
Vector 80 [_MainTex_ST] 4
Vector 96 [_BumpMap_ST] 4
ConstBuffer "UnityPerCamera" 128 // 96 used size, 8 vars
Vector 80 [_ProjectionParams] 4
ConstBuffer "UnityPerDraw" 336 // 192 used size, 6 vars
Matrix 0 [glstate_matrix_mvp] 4
Matrix 128 [glstate_matrix_invtrans_modelview0] 4
BindCB "$Globals" 0
BindCB "UnityPerCamera" 1
BindCB "UnityPerDraw" 2
// 28 instructions, 3 temp regs, 0 temp arrays:
// ALU 12 float, 0 int, 0 uint
// TEX 0 (0 load, 0 comp, 0 bias, 0 grad)
// FLOW 1 static, 0 dynamic
"vs_4_0
eefieceddiphfhfdikaepmipefehoajefkecphkhabaaaaaamaafaaaaadaaaaaa
cmaaaaaapeaaaaaakmabaaaaejfdeheomaaaaaaaagaaaaaaaiaaaaaajiaaaaaa
aaaaaaaaaaaaaaaaadaaaaaaaaaaaaaaapapaaaakbaaaaaaaaaaaaaaaaaaaaaa
adaaaaaaabaaaaaaapapaaaakjaaaaaaaaaaaaaaaaaaaaaaadaaaaaaacaaaaaa
ahahaaaalaaaaaaaaaaaaaaaaaaaaaaaadaaaaaaadaaaaaaapadaaaalaaaaaaa
abaaaaaaaaaaaaaaadaaaaaaaeaaaaaaapadaaaaljaaaaaaaaaaaaaaaaaaaaaa
adaaaaaaafaaaaaaapaaaaaafaepfdejfeejepeoaafeebeoehefeofeaaeoepfc
enebemaafeeffiedepepfceeaaedepemepfcaaklepfdeheolaaaaaaaagaaaaaa
aiaaaaaajiaaaaaaaaaaaaaaabaaaaaaadaaaaaaaaaaaaaaapaaaaaakeaaaaaa
aaaaaaaaaaaaaaaaadaaaaaaabaaaaaaapaaaaaakeaaaaaaabaaaaaaaaaaaaaa
adaaaaaaacaaaaaaahaiaaaakeaaaaaaacaaaaaaaaaaaaaaadaaaaaaadaaaaaa
ahaiaaaakeaaaaaaadaaaaaaaaaaaaaaadaaaaaaaeaaaaaaapaaaaaakeaaaaaa
aeaaaaaaaaaaaaaaadaaaaaaafaaaaaaadamaaaafdfgfpfaepfdejfeejepeoaa
feeffiedepepfceeaaklklklfdeieefcamaeaaaaeaaaabaaadabaaaafjaaaaae
egiocaaaaaaaaaaaahaaaaaafjaaaaaeegiocaaaabaaaaaaagaaaaaafjaaaaae
egiocaaaacaaaaaaalaaaaaafpaaaaadpcbabaaaaaaaaaaafpaaaaadpcbabaaa
abaaaaaafpaaaaadhcbabaaaacaaaaaafpaaaaaddcbabaaaadaaaaaafpaaaaad
dcbabaaaaeaaaaaaghaaaaaepccabaaaaaaaaaaaabaaaaaagfaaaaadpccabaaa
abaaaaaagfaaaaadhccabaaaacaaaaaagfaaaaadhccabaaaadaaaaaagfaaaaad
pccabaaaaeaaaaaagfaaaaaddccabaaaafaaaaaagiaaaaacadaaaaaadiaaaaai
pcaabaaaaaaaaaaafgbfbaaaaaaaaaaaegiocaaaacaaaaaaabaaaaaadcaaaaak
pcaabaaaaaaaaaaaegiocaaaacaaaaaaaaaaaaaaagbabaaaaaaaaaaaegaobaaa
aaaaaaaadcaaaaakpcaabaaaaaaaaaaaegiocaaaacaaaaaaacaaaaaakgbkbaaa
aaaaaaaaegaobaaaaaaaaaaadcaaaaakpcaabaaaaaaaaaaaegiocaaaacaaaaaa
adaaaaaapgbpbaaaaaaaaaaaegaobaaaaaaaaaaadgaaaaafpccabaaaaaaaaaaa
egaobaaaaaaaaaaadcaaaaaldccabaaaabaaaaaaegbabaaaadaaaaaaegiacaaa
aaaaaaaaafaaaaaaogikcaaaaaaaaaaaafaaaaaadcaaaaalmccabaaaabaaaaaa
agbebaaaadaaaaaaagiecaaaaaaaaaaaagaaaaaakgiocaaaaaaaaaaaagaaaaaa
diaaaaahhcaabaaaabaaaaaajgbebaaaabaaaaaacgbjbaaaacaaaaaadcaaaaak
hcaabaaaabaaaaaajgbebaaaacaaaaaacgbjbaaaabaaaaaaegacbaiaebaaaaaa
abaaaaaadiaaaaahhcaabaaaabaaaaaaegacbaaaabaaaaaapgbpbaaaabaaaaaa
dgaaaaagbcaabaaaacaaaaaaakiacaaaacaaaaaaaiaaaaaadgaaaaagccaabaaa
acaaaaaaakiacaaaacaaaaaaajaaaaaadgaaaaagecaabaaaacaaaaaaakiacaaa
acaaaaaaakaaaaaabaaaaaahcccabaaaacaaaaaaegacbaaaabaaaaaaegacbaaa
acaaaaaabaaaaaahbccabaaaacaaaaaaegbcbaaaabaaaaaaegacbaaaacaaaaaa
baaaaaaheccabaaaacaaaaaaegbcbaaaacaaaaaaegacbaaaacaaaaaadgaaaaag
bcaabaaaacaaaaaabkiacaaaacaaaaaaaiaaaaaadgaaaaagccaabaaaacaaaaaa
bkiacaaaacaaaaaaajaaaaaadgaaaaagecaabaaaacaaaaaabkiacaaaacaaaaaa
akaaaaaabaaaaaahcccabaaaadaaaaaaegacbaaaabaaaaaaegacbaaaacaaaaaa
baaaaaahbccabaaaadaaaaaaegbcbaaaabaaaaaaegacbaaaacaaaaaabaaaaaah
eccabaaaadaaaaaaegbcbaaaacaaaaaaegacbaaaacaaaaaadiaaaaaiccaabaaa
aaaaaaaabkaabaaaaaaaaaaaakiacaaaabaaaaaaafaaaaaadiaaaaakncaabaaa
abaaaaaaagahbaaaaaaaaaaaaceaaaaaaaaaaadpaaaaaaaaaaaaaadpaaaaaadp
dgaaaaafmccabaaaaeaaaaaakgaobaaaaaaaaaaaaaaaaaahdccabaaaaeaaaaaa
kgakbaaaabaaaaaamgaabaaaabaaaaaadcaaaaaldccabaaaafaaaaaaegbabaaa
aeaaaaaaegiacaaaaaaaaaaaaeaaaaaaogikcaaaaaaaaaaaaeaaaaaadoaaaaab
"
}

SubProgram "gles " {
Keywords { "LIGHTMAP_ON" "DIRLIGHTMAP_ON" "HDR_LIGHT_PREPASS_ON" }
"!!GLES
#define SHADER_API_GLES 1
#define tex2D texture2D


#ifdef VERTEX
#define gl_ModelViewProjectionMatrix glstate_matrix_mvp
uniform mat4 glstate_matrix_mvp;
#define gl_ModelViewMatrixInverseTranspose glstate_matrix_invtrans_modelview0
uniform mat4 glstate_matrix_invtrans_modelview0;
#define gl_ModelViewMatrix glstate_matrix_modelview0
uniform mat4 glstate_matrix_modelview0;

varying highp vec2 xlv_TEXCOORD4;
varying highp vec4 xlv_TEXCOORD3;
varying highp vec3 xlv_TEXCOORD2;
varying highp vec3 xlv_TEXCOORD1;
varying highp vec4 xlv_TEXCOORD0;
uniform highp vec4 _BumpMap_ST;
uniform highp vec4 _MainTex_ST;
uniform highp vec4 unity_LightmapST;


uniform highp vec4 _ProjectionParams;
attribute vec4 _glesTANGENT;
attribute vec4 _glesMultiTexCoord1;
attribute vec4 _glesMultiTexCoord0;
attribute vec3 _glesNormal;
attribute vec4 _glesVertex;
void main ()
{
  vec4 tmpvar_1;
  tmpvar_1.xyz = normalize(_glesTANGENT.xyz);
  tmpvar_1.w = _glesTANGENT.w;
  vec3 tmpvar_2;
  tmpvar_2 = normalize(_glesNormal);
  highp vec4 tmpvar_3;
  highp vec3 tmpvar_4;
  highp vec3 tmpvar_5;
  tmpvar_4 = tmpvar_1.xyz;
  tmpvar_5 = (((tmpvar_2.yzx * tmpvar_1.zxy) - (tmpvar_2.zxy * tmpvar_1.yzx)) * _glesTANGENT.w);
  highp mat3 tmpvar_6;
  tmpvar_6[0].x = tmpvar_4.x;
  tmpvar_6[0].y = tmpvar_5.x;
  tmpvar_6[0].z = tmpvar_2.x;
  tmpvar_6[1].x = tmpvar_4.y;
  tmpvar_6[1].y = tmpvar_5.y;
  tmpvar_6[1].z = tmpvar_2.y;
  tmpvar_6[2].x = tmpvar_4.z;
  tmpvar_6[2].y = tmpvar_5.z;
  tmpvar_6[2].z = tmpvar_2.z;
  vec4 v_7;
  v_7.x = gl_ModelViewMatrixInverseTranspose[0].x;
  v_7.y = gl_ModelViewMatrixInverseTranspose[1].x;
  v_7.z = gl_ModelViewMatrixInverseTranspose[2].x;
  v_7.w = gl_ModelViewMatrixInverseTranspose[3].x;
  vec4 v_8;
  v_8.x = gl_ModelViewMatrixInverseTranspose[0].y;
  v_8.y = gl_ModelViewMatrixInverseTranspose[1].y;
  v_8.z = gl_ModelViewMatrixInverseTranspose[2].y;
  v_8.w = gl_ModelViewMatrixInverseTranspose[3].y;
  highp vec4 tmpvar_9;
  tmpvar_9 = (gl_ModelViewProjectionMatrix * _glesVertex);
  tmpvar_3.xy = ((_glesMultiTexCoord0.xy * _MainTex_ST.xy) + _MainTex_ST.zw);
  tmpvar_3.zw = ((_glesMultiTexCoord0.xy * _BumpMap_ST.xy) + _BumpMap_ST.zw);
  highp vec4 o_10;
  highp vec4 tmpvar_11;
  tmpvar_11 = (tmpvar_9 * 0.5);
  highp vec2 tmpvar_12;
  tmpvar_12.x = tmpvar_11.x;
  tmpvar_12.y = (tmpvar_11.y * _ProjectionParams.x);
  o_10.xy = (tmpvar_12 + tmpvar_11.w);
  o_10.zw = tmpvar_9.zw;
  gl_Position = tmpvar_9;
  xlv_TEXCOORD0 = tmpvar_3;
  xlv_TEXCOORD1 = (tmpvar_6 * v_7.xyz);
  xlv_TEXCOORD2 = (tmpvar_6 * v_8.xyz);
  xlv_TEXCOORD3 = o_10;
  xlv_TEXCOORD4 = ((_glesMultiTexCoord1.xy * unity_LightmapST.xy) + unity_LightmapST.zw);
}



#endif
#ifdef FRAGMENT

varying highp vec2 xlv_TEXCOORD4;
varying highp vec4 xlv_TEXCOORD3;
varying highp vec3 xlv_TEXCOORD2;
varying highp vec3 xlv_TEXCOORD1;
varying highp vec4 xlv_TEXCOORD0;
uniform lowp float _Cutoff;
uniform sampler2D unity_LightmapInd;
uniform sampler2D unity_Lightmap;
uniform sampler2D _LightBuffer;
uniform sampler2D _Shade;
uniform sampler2D _BumpMap;
uniform sampler2D _MainTex;
uniform lowp vec4 _Color;
void main ()
{
  lowp vec4 tmpvar_1;
  mediump vec4 c_2;
  mediump vec4 light_3;
  lowp vec3 tmpvar_4;
  highp vec3 matcap_5;
  lowp vec3 tmpvar_6;
  tmpvar_6 = ((texture2D (_BumpMap, xlv_TEXCOORD0.zw).xyz * 2.0) - 1.0);
  lowp vec3 tmpvar_7;
  tmpvar_7 = (texture2D (_MainTex, xlv_TEXCOORD0.xy).xyz * _Color.w);
  highp vec2 tmpvar_8;
  tmpvar_8.x = dot (xlv_TEXCOORD1, tmpvar_6);
  tmpvar_8.y = dot (xlv_TEXCOORD2, tmpvar_6);
  highp vec2 P_9;
  P_9 = ((tmpvar_8 * 0.5) + 0.5);
  lowp vec3 tmpvar_10;
  tmpvar_10 = texture2D (_Shade, P_9).xyz;
  matcap_5 = tmpvar_10;
  lowp vec4 tmpvar_11;
  tmpvar_11 = texture2D (_MainTex, xlv_TEXCOORD0.xy);
  highp vec3 tmpvar_12;
  tmpvar_12 = (((matcap_5 * tmpvar_11.xyz) * _Color.xyz) * 3.0);
  tmpvar_4 = tmpvar_12;
  lowp vec4 tmpvar_13;
  tmpvar_13 = texture2D (_MainTex, xlv_TEXCOORD0.xy);
  lowp float x_14;
  x_14 = (tmpvar_13.w - _Cutoff);
  if ((x_14 < 0.0)) {
    discard;
  };
  lowp vec4 tmpvar_15;
  tmpvar_15 = texture2DProj (_LightBuffer, xlv_TEXCOORD3);
  light_3 = tmpvar_15;
  mat3 tmpvar_16;
  tmpvar_16[0].x = 0.816497;
  tmpvar_16[0].y = -0.408248;
  tmpvar_16[0].z = -0.408248;
  tmpvar_16[1].x = 0.0;
  tmpvar_16[1].y = 0.707107;
  tmpvar_16[1].z = -0.707107;
  tmpvar_16[2].x = 0.57735;
  tmpvar_16[2].y = 0.57735;
  tmpvar_16[2].z = 0.57735;
  mediump vec3 normal_17;
  normal_17 = tmpvar_6;
  mediump vec3 scalePerBasisVector_18;
  mediump vec3 lm_19;
  lowp vec3 tmpvar_20;
  tmpvar_20 = (2.0 * texture2D (unity_Lightmap, xlv_TEXCOORD4).xyz);
  lm_19 = tmpvar_20;
  lowp vec3 tmpvar_21;
  tmpvar_21 = (2.0 * texture2D (unity_LightmapInd, xlv_TEXCOORD4).xyz);
  scalePerBasisVector_18 = tmpvar_21;
  lm_19 = (lm_19 * dot (clamp ((tmpvar_16 * normal_17), 0.0, 1.0), scalePerBasisVector_18));
  mediump vec4 tmpvar_22;
  tmpvar_22.w = 0.0;
  tmpvar_22.xyz = lm_19;
  mediump vec4 tmpvar_23;
  tmpvar_23 = (max (light_3, vec4(0.001, 0.001, 0.001, 0.001)) + tmpvar_22);
  light_3 = tmpvar_23;
  lowp vec4 c_24;
  mediump vec3 tmpvar_25;
  tmpvar_25 = (tmpvar_7 * tmpvar_23.xyz);
  c_24.xyz = tmpvar_25;
  c_24.w = tmpvar_13.w;
  c_2 = c_24;
  c_2.xyz = (c_2.xyz + tmpvar_4);
  tmpvar_1 = c_2;
  gl_FragData[0] = tmpvar_1;
}



#endif"
}

SubProgram "glesdesktop " {
Keywords { "LIGHTMAP_ON" "DIRLIGHTMAP_ON" "HDR_LIGHT_PREPASS_ON" }
"!!GLES
#define SHADER_API_GLES 1
#define tex2D texture2D


#ifdef VERTEX
#define gl_ModelViewProjectionMatrix glstate_matrix_mvp
uniform mat4 glstate_matrix_mvp;
#define gl_ModelViewMatrixInverseTranspose glstate_matrix_invtrans_modelview0
uniform mat4 glstate_matrix_invtrans_modelview0;
#define gl_ModelViewMatrix glstate_matrix_modelview0
uniform mat4 glstate_matrix_modelview0;

varying highp vec2 xlv_TEXCOORD4;
varying highp vec4 xlv_TEXCOORD3;
varying highp vec3 xlv_TEXCOORD2;
varying highp vec3 xlv_TEXCOORD1;
varying highp vec4 xlv_TEXCOORD0;
uniform highp vec4 _BumpMap_ST;
uniform highp vec4 _MainTex_ST;
uniform highp vec4 unity_LightmapST;


uniform highp vec4 _ProjectionParams;
attribute vec4 _glesTANGENT;
attribute vec4 _glesMultiTexCoord1;
attribute vec4 _glesMultiTexCoord0;
attribute vec3 _glesNormal;
attribute vec4 _glesVertex;
void main ()
{
  vec4 tmpvar_1;
  tmpvar_1.xyz = normalize(_glesTANGENT.xyz);
  tmpvar_1.w = _glesTANGENT.w;
  vec3 tmpvar_2;
  tmpvar_2 = normalize(_glesNormal);
  highp vec4 tmpvar_3;
  highp vec3 tmpvar_4;
  highp vec3 tmpvar_5;
  tmpvar_4 = tmpvar_1.xyz;
  tmpvar_5 = (((tmpvar_2.yzx * tmpvar_1.zxy) - (tmpvar_2.zxy * tmpvar_1.yzx)) * _glesTANGENT.w);
  highp mat3 tmpvar_6;
  tmpvar_6[0].x = tmpvar_4.x;
  tmpvar_6[0].y = tmpvar_5.x;
  tmpvar_6[0].z = tmpvar_2.x;
  tmpvar_6[1].x = tmpvar_4.y;
  tmpvar_6[1].y = tmpvar_5.y;
  tmpvar_6[1].z = tmpvar_2.y;
  tmpvar_6[2].x = tmpvar_4.z;
  tmpvar_6[2].y = tmpvar_5.z;
  tmpvar_6[2].z = tmpvar_2.z;
  vec4 v_7;
  v_7.x = gl_ModelViewMatrixInverseTranspose[0].x;
  v_7.y = gl_ModelViewMatrixInverseTranspose[1].x;
  v_7.z = gl_ModelViewMatrixInverseTranspose[2].x;
  v_7.w = gl_ModelViewMatrixInverseTranspose[3].x;
  vec4 v_8;
  v_8.x = gl_ModelViewMatrixInverseTranspose[0].y;
  v_8.y = gl_ModelViewMatrixInverseTranspose[1].y;
  v_8.z = gl_ModelViewMatrixInverseTranspose[2].y;
  v_8.w = gl_ModelViewMatrixInverseTranspose[3].y;
  highp vec4 tmpvar_9;
  tmpvar_9 = (gl_ModelViewProjectionMatrix * _glesVertex);
  tmpvar_3.xy = ((_glesMultiTexCoord0.xy * _MainTex_ST.xy) + _MainTex_ST.zw);
  tmpvar_3.zw = ((_glesMultiTexCoord0.xy * _BumpMap_ST.xy) + _BumpMap_ST.zw);
  highp vec4 o_10;
  highp vec4 tmpvar_11;
  tmpvar_11 = (tmpvar_9 * 0.5);
  highp vec2 tmpvar_12;
  tmpvar_12.x = tmpvar_11.x;
  tmpvar_12.y = (tmpvar_11.y * _ProjectionParams.x);
  o_10.xy = (tmpvar_12 + tmpvar_11.w);
  o_10.zw = tmpvar_9.zw;
  gl_Position = tmpvar_9;
  xlv_TEXCOORD0 = tmpvar_3;
  xlv_TEXCOORD1 = (tmpvar_6 * v_7.xyz);
  xlv_TEXCOORD2 = (tmpvar_6 * v_8.xyz);
  xlv_TEXCOORD3 = o_10;
  xlv_TEXCOORD4 = ((_glesMultiTexCoord1.xy * unity_LightmapST.xy) + unity_LightmapST.zw);
}



#endif
#ifdef FRAGMENT

varying highp vec2 xlv_TEXCOORD4;
varying highp vec4 xlv_TEXCOORD3;
varying highp vec3 xlv_TEXCOORD2;
varying highp vec3 xlv_TEXCOORD1;
varying highp vec4 xlv_TEXCOORD0;
uniform lowp float _Cutoff;
uniform sampler2D unity_LightmapInd;
uniform sampler2D unity_Lightmap;
uniform sampler2D _LightBuffer;
uniform sampler2D _Shade;
uniform sampler2D _BumpMap;
uniform sampler2D _MainTex;
uniform lowp vec4 _Color;
void main ()
{
  lowp vec4 tmpvar_1;
  mediump vec4 c_2;
  mediump vec4 light_3;
  lowp vec3 tmpvar_4;
  highp vec3 matcap_5;
  lowp vec3 normal_6;
  normal_6.xy = ((texture2D (_BumpMap, xlv_TEXCOORD0.zw).wy * 2.0) - 1.0);
  normal_6.z = sqrt(((1.0 - (normal_6.x * normal_6.x)) - (normal_6.y * normal_6.y)));
  lowp vec3 tmpvar_7;
  tmpvar_7 = (texture2D (_MainTex, xlv_TEXCOORD0.xy).xyz * _Color.w);
  highp vec2 tmpvar_8;
  tmpvar_8.x = dot (xlv_TEXCOORD1, normal_6);
  tmpvar_8.y = dot (xlv_TEXCOORD2, normal_6);
  highp vec2 P_9;
  P_9 = ((tmpvar_8 * 0.5) + 0.5);
  lowp vec3 tmpvar_10;
  tmpvar_10 = texture2D (_Shade, P_9).xyz;
  matcap_5 = tmpvar_10;
  lowp vec4 tmpvar_11;
  tmpvar_11 = texture2D (_MainTex, xlv_TEXCOORD0.xy);
  highp vec3 tmpvar_12;
  tmpvar_12 = (((matcap_5 * tmpvar_11.xyz) * _Color.xyz) * 3.0);
  tmpvar_4 = tmpvar_12;
  lowp vec4 tmpvar_13;
  tmpvar_13 = texture2D (_MainTex, xlv_TEXCOORD0.xy);
  lowp float x_14;
  x_14 = (tmpvar_13.w - _Cutoff);
  if ((x_14 < 0.0)) {
    discard;
  };
  lowp vec4 tmpvar_15;
  tmpvar_15 = texture2DProj (_LightBuffer, xlv_TEXCOORD3);
  light_3 = tmpvar_15;
  lowp vec4 tmpvar_16;
  tmpvar_16 = texture2D (unity_Lightmap, xlv_TEXCOORD4);
  lowp vec4 tmpvar_17;
  tmpvar_17 = texture2D (unity_LightmapInd, xlv_TEXCOORD4);
  mat3 tmpvar_18;
  tmpvar_18[0].x = 0.816497;
  tmpvar_18[0].y = -0.408248;
  tmpvar_18[0].z = -0.408248;
  tmpvar_18[1].x = 0.0;
  tmpvar_18[1].y = 0.707107;
  tmpvar_18[1].z = -0.707107;
  tmpvar_18[2].x = 0.57735;
  tmpvar_18[2].y = 0.57735;
  tmpvar_18[2].z = 0.57735;
  mediump vec3 normal_19;
  normal_19 = normal_6;
  mediump vec3 scalePerBasisVector_20;
  mediump vec3 lm_21;
  lowp vec3 tmpvar_22;
  tmpvar_22 = ((8.0 * tmpvar_16.w) * tmpvar_16.xyz);
  lm_21 = tmpvar_22;
  lowp vec3 tmpvar_23;
  tmpvar_23 = ((8.0 * tmpvar_17.w) * tmpvar_17.xyz);
  scalePerBasisVector_20 = tmpvar_23;
  lm_21 = (lm_21 * dot (clamp ((tmpvar_18 * normal_19), 0.0, 1.0), scalePerBasisVector_20));
  mediump vec4 tmpvar_24;
  tmpvar_24.w = 0.0;
  tmpvar_24.xyz = lm_21;
  mediump vec4 tmpvar_25;
  tmpvar_25 = (max (light_3, vec4(0.001, 0.001, 0.001, 0.001)) + tmpvar_24);
  light_3 = tmpvar_25;
  lowp vec4 c_26;
  mediump vec3 tmpvar_27;
  tmpvar_27 = (tmpvar_7 * tmpvar_25.xyz);
  c_26.xyz = tmpvar_27;
  c_26.w = tmpvar_13.w;
  c_2 = c_26;
  c_2.xyz = (c_2.xyz + tmpvar_4);
  tmpvar_1 = c_2;
  gl_FragData[0] = tmpvar_1;
}



#endif"
}

SubProgram "d3d11_9x " {
Keywords { "LIGHTMAP_ON" "DIRLIGHTMAP_ON" "HDR_LIGHT_PREPASS_ON" }
Bind "vertex" Vertex
Bind "tangent" TexCoord2
Bind "normal" Normal
Bind "texcoord" TexCoord0
Bind "texcoord1" TexCoord1
Bind "color" Color
ConstBuffer "$Globals" 160 // 112 used size, 10 vars
Vector 64 [unity_LightmapST] 4
Vector 80 [_MainTex_ST] 4
Vector 96 [_BumpMap_ST] 4
ConstBuffer "UnityPerCamera" 128 // 96 used size, 8 vars
Vector 80 [_ProjectionParams] 4
ConstBuffer "UnityPerDraw" 336 // 192 used size, 6 vars
Matrix 0 [glstate_matrix_mvp] 4
Matrix 128 [glstate_matrix_invtrans_modelview0] 4
BindCB "$Globals" 0
BindCB "UnityPerCamera" 1
BindCB "UnityPerDraw" 2
// 28 instructions, 3 temp regs, 0 temp arrays:
// ALU 12 float, 0 int, 0 uint
// TEX 0 (0 load, 0 comp, 0 bias, 0 grad)
// FLOW 1 static, 0 dynamic
"vs_4_0_level_9_3
eefiecedeiefdblkdkljdbafeijanneeempfpnmoabaaaaaafmaiaaaaaeaaaaaa
daaaaaaamiacaaaanmagaaaakeahaaaaebgpgodjjaacaaaajaacaaaaaaacpopp
diacaaaafiaaaaaaaeaaceaaaaaafeaaaaaafeaaaaaaceaaabaafeaaaaaaaeaa
adaaabaaaaaaaaaaabaaafaaabaaaeaaaaaaaaaaacaaaaaaaeaaafaaaaaaaaaa
acaaaiaaadaaajaaaaaaaaaaaaaaaaaaabacpoppfbaaaaafamaaapkaaaaaaadp
aaaaaaaaaaaaaaaaaaaaaaaabpaaaaacafaaaaiaaaaaapjabpaaaaacafaaabia
abaaapjabpaaaaacafaaaciaacaaapjabpaaaaacafaaadiaadaaapjabpaaaaac
afaaaeiaaeaaapjaabaaaaacaaaaabiaajaaaakaabaaaaacaaaaaciaakaaaaka
abaaaaacaaaaaeiaalaaaakaaiaaaaadabaaaboaabaaoejaaaaaoeiaabaaaaac
abaaahiaabaaoejaafaaaaadacaaahiaabaamjiaacaancjaaeaaaaaeabaaahia
acaamjjaabaanciaacaaoeibafaaaaadabaaahiaabaaoeiaabaappjaaiaaaaad
abaaacoaabaaoeiaaaaaoeiaaiaaaaadabaaaeoaacaaoejaaaaaoeiaabaaaaac
aaaaabiaajaaffkaabaaaaacaaaaaciaakaaffkaabaaaaacaaaaaeiaalaaffka
aiaaaaadacaaaboaabaaoejaaaaaoeiaaiaaaaadacaaacoaabaaoeiaaaaaoeia
aiaaaaadacaaaeoaacaaoejaaaaaoeiaaeaaaaaeaaaaadoaadaaoejaacaaoeka
acaaookaaeaaaaaeaaaaamoaadaaeejaadaaeekaadaaoekaafaaaaadaaaaapia
aaaaffjaagaaoekaaeaaaaaeaaaaapiaafaaoekaaaaaaajaaaaaoeiaaeaaaaae
aaaaapiaahaaoekaaaaakkjaaaaaoeiaaeaaaaaeaaaaapiaaiaaoekaaaaappja
aaaaoeiaafaaaaadabaaabiaaaaaffiaaeaaaakaafaaaaadabaaaiiaabaaaaia
amaaaakaafaaaaadabaaafiaaaaapeiaamaaaakaacaaaaadadaaadoaabaakkia
abaaomiaaeaaaaaeaeaaadoaaeaaoejaabaaoekaabaaookaaeaaaaaeaaaaadma
aaaappiaaaaaoekaaaaaoeiaabaaaaacaaaaammaaaaaoeiaabaaaaacadaaamoa
aaaaoeiappppaaaafdeieefcamaeaaaaeaaaabaaadabaaaafjaaaaaeegiocaaa
aaaaaaaaahaaaaaafjaaaaaeegiocaaaabaaaaaaagaaaaaafjaaaaaeegiocaaa
acaaaaaaalaaaaaafpaaaaadpcbabaaaaaaaaaaafpaaaaadpcbabaaaabaaaaaa
fpaaaaadhcbabaaaacaaaaaafpaaaaaddcbabaaaadaaaaaafpaaaaaddcbabaaa
aeaaaaaaghaaaaaepccabaaaaaaaaaaaabaaaaaagfaaaaadpccabaaaabaaaaaa
gfaaaaadhccabaaaacaaaaaagfaaaaadhccabaaaadaaaaaagfaaaaadpccabaaa
aeaaaaaagfaaaaaddccabaaaafaaaaaagiaaaaacadaaaaaadiaaaaaipcaabaaa
aaaaaaaafgbfbaaaaaaaaaaaegiocaaaacaaaaaaabaaaaaadcaaaaakpcaabaaa
aaaaaaaaegiocaaaacaaaaaaaaaaaaaaagbabaaaaaaaaaaaegaobaaaaaaaaaaa
dcaaaaakpcaabaaaaaaaaaaaegiocaaaacaaaaaaacaaaaaakgbkbaaaaaaaaaaa
egaobaaaaaaaaaaadcaaaaakpcaabaaaaaaaaaaaegiocaaaacaaaaaaadaaaaaa
pgbpbaaaaaaaaaaaegaobaaaaaaaaaaadgaaaaafpccabaaaaaaaaaaaegaobaaa
aaaaaaaadcaaaaaldccabaaaabaaaaaaegbabaaaadaaaaaaegiacaaaaaaaaaaa
afaaaaaaogikcaaaaaaaaaaaafaaaaaadcaaaaalmccabaaaabaaaaaaagbebaaa
adaaaaaaagiecaaaaaaaaaaaagaaaaaakgiocaaaaaaaaaaaagaaaaaadiaaaaah
hcaabaaaabaaaaaajgbebaaaabaaaaaacgbjbaaaacaaaaaadcaaaaakhcaabaaa
abaaaaaajgbebaaaacaaaaaacgbjbaaaabaaaaaaegacbaiaebaaaaaaabaaaaaa
diaaaaahhcaabaaaabaaaaaaegacbaaaabaaaaaapgbpbaaaabaaaaaadgaaaaag
bcaabaaaacaaaaaaakiacaaaacaaaaaaaiaaaaaadgaaaaagccaabaaaacaaaaaa
akiacaaaacaaaaaaajaaaaaadgaaaaagecaabaaaacaaaaaaakiacaaaacaaaaaa
akaaaaaabaaaaaahcccabaaaacaaaaaaegacbaaaabaaaaaaegacbaaaacaaaaaa
baaaaaahbccabaaaacaaaaaaegbcbaaaabaaaaaaegacbaaaacaaaaaabaaaaaah
eccabaaaacaaaaaaegbcbaaaacaaaaaaegacbaaaacaaaaaadgaaaaagbcaabaaa
acaaaaaabkiacaaaacaaaaaaaiaaaaaadgaaaaagccaabaaaacaaaaaabkiacaaa
acaaaaaaajaaaaaadgaaaaagecaabaaaacaaaaaabkiacaaaacaaaaaaakaaaaaa
baaaaaahcccabaaaadaaaaaaegacbaaaabaaaaaaegacbaaaacaaaaaabaaaaaah
bccabaaaadaaaaaaegbcbaaaabaaaaaaegacbaaaacaaaaaabaaaaaaheccabaaa
adaaaaaaegbcbaaaacaaaaaaegacbaaaacaaaaaadiaaaaaiccaabaaaaaaaaaaa
bkaabaaaaaaaaaaaakiacaaaabaaaaaaafaaaaaadiaaaaakncaabaaaabaaaaaa
agahbaaaaaaaaaaaaceaaaaaaaaaaadpaaaaaaaaaaaaaadpaaaaaadpdgaaaaaf
mccabaaaaeaaaaaakgaobaaaaaaaaaaaaaaaaaahdccabaaaaeaaaaaakgakbaaa
abaaaaaamgaabaaaabaaaaaadcaaaaaldccabaaaafaaaaaaegbabaaaaeaaaaaa
egiacaaaaaaaaaaaaeaaaaaaogikcaaaaaaaaaaaaeaaaaaadoaaaaabejfdeheo
maaaaaaaagaaaaaaaiaaaaaajiaaaaaaaaaaaaaaaaaaaaaaadaaaaaaaaaaaaaa
apapaaaakbaaaaaaaaaaaaaaaaaaaaaaadaaaaaaabaaaaaaapapaaaakjaaaaaa
aaaaaaaaaaaaaaaaadaaaaaaacaaaaaaahahaaaalaaaaaaaaaaaaaaaaaaaaaaa
adaaaaaaadaaaaaaapadaaaalaaaaaaaabaaaaaaaaaaaaaaadaaaaaaaeaaaaaa
apadaaaaljaaaaaaaaaaaaaaaaaaaaaaadaaaaaaafaaaaaaapaaaaaafaepfdej
feejepeoaafeebeoehefeofeaaeoepfcenebemaafeeffiedepepfceeaaedepem
epfcaaklepfdeheolaaaaaaaagaaaaaaaiaaaaaajiaaaaaaaaaaaaaaabaaaaaa
adaaaaaaaaaaaaaaapaaaaaakeaaaaaaaaaaaaaaaaaaaaaaadaaaaaaabaaaaaa
apaaaaaakeaaaaaaabaaaaaaaaaaaaaaadaaaaaaacaaaaaaahaiaaaakeaaaaaa
acaaaaaaaaaaaaaaadaaaaaaadaaaaaaahaiaaaakeaaaaaaadaaaaaaaaaaaaaa
adaaaaaaaeaaaaaaapaaaaaakeaaaaaaaeaaaaaaaaaaaaaaadaaaaaaafaaaaaa
adamaaaafdfgfpfaepfdejfeejepeoaafeeffiedepepfceeaaklklkl"
}

}
Program "fp" {
// Fragment combos: 6
//   opengl - ALU: 22 to 36, TEX: 4 to 6
//   d3d9 - ALU: 23 to 35, TEX: 5 to 7
//   d3d11 - ALU: 11 to 19, TEX: 4 to 6, FLOW: 1 to 1
//   d3d11_9x - ALU: 11 to 19, TEX: 4 to 6, FLOW: 1 to 1
SubProgram "opengl " {
Keywords { "LIGHTMAP_OFF" "DIRLIGHTMAP_OFF" "HDR_LIGHT_PREPASS_OFF" }
Vector 0 [_Color]
Float 1 [_Cutoff]
SetTexture 0 [_BumpMap] 2D
SetTexture 1 [_MainTex] 2D
SetTexture 2 [_Shade] 2D
SetTexture 3 [_LightBuffer] 2D
"!!ARBfp1.0
OPTION ARB_precision_hint_fastest;
# 25 ALU, 4 TEX
PARAM c[3] = { program.local[0..1],
		{ 2, 1, 0.5, 3 } };
TEMP R0;
TEMP R1;
TEMP R2;
TEX R0, fragment.texcoord[0], texture[1], 2D;
TEX R1.yw, fragment.texcoord[0].zwzw, texture[0], 2D;
MAD R1.xy, R1.wyzw, c[2].x, -c[2].y;
MUL R1.z, R1.y, R1.y;
MAD R1.z, -R1.x, R1.x, -R1;
SLT R2.x, R0.w, c[1];
ADD R1.z, R1, c[2].y;
RSQ R1.z, R1.z;
RCP R1.z, R1.z;
DP3 R1.w, R1, fragment.texcoord[2];
DP3 R1.z, fragment.texcoord[1], R1;
MAD R1.xy, R1.zwzw, c[2].z, c[2].z;
MOV result.color.w, R0;
KIL -R2.x;
TEX R2.xyz, R1, texture[2], 2D;
TXP R1.xyz, fragment.texcoord[3], texture[3], 2D;
MUL R2.xyz, R0, R2;
MUL R2.xyz, R2, c[0];
MUL R2.xyz, R2, c[2].w;
LG2 R1.x, R1.x;
LG2 R1.z, R1.z;
LG2 R1.y, R1.y;
ADD R1.xyz, -R1, fragment.texcoord[4];
MUL R0.xyz, R0, c[0].w;
MAD result.color.xyz, R0, R1, R2;
END
# 25 instructions, 3 R-regs
"
}

SubProgram "d3d9 " {
Keywords { "LIGHTMAP_OFF" "DIRLIGHTMAP_OFF" "HDR_LIGHT_PREPASS_OFF" }
Vector 0 [_Color]
Float 1 [_Cutoff]
SetTexture 0 [_BumpMap] 2D
SetTexture 1 [_MainTex] 2D
SetTexture 2 [_Shade] 2D
SetTexture 3 [_LightBuffer] 2D
"ps_2_0
; 26 ALU, 5 TEX
dcl_2d s0
dcl_2d s1
dcl_2d s2
dcl_2d s3
def c2, 0.00000000, 1.00000000, 2.00000000, -1.00000000
def c3, 0.50000000, 3.00000000, 0, 0
dcl t0
dcl t1.xyz
dcl t2.xyz
dcl t3
dcl t4.xyz
texld r1, t0, s1
mov r0.y, t0.w
mov r0.x, t0.z
texld r0, r0, s0
mov r0.x, r0.w
mad_pp r2.xy, r0, c2.z, c2.w
mul_pp r0.x, r2.y, r2.y
mad_pp r0.x, -r2, r2, -r0
add_pp r0.x, r0, c2.y
rsq_pp r0.x, r0.x
rcp_pp r2.z, r0.x
add_pp r0.x, r1.w, -c1
dp3 r3.x, t1, r2
dp3 r3.y, r2, t2
cmp r0.x, r0, c2, c2.y
mov_pp r2, -r0.x
mad_pp r3.xy, r3, c3.x, c3.x
texld r0, r3, s2
texkill r2.xyzw
texldp r2, t3, s3
mul r0.xyz, r1, r0
mul r0.xyz, r0, c0
mul r0.xyz, r0, c3.y
log_pp r2.x, r2.x
log_pp r2.z, r2.z
log_pp r2.y, r2.y
add_pp r2.xyz, -r2, t4
mul r1.xyz, r1, c0.w
mov_pp r0.w, r1
mad_pp r0.xyz, r1, r2, r0
mov_pp oC0, r0
"
}

SubProgram "d3d11 " {
Keywords { "LIGHTMAP_OFF" "DIRLIGHTMAP_OFF" "HDR_LIGHT_PREPASS_OFF" }
ConstBuffer "$Globals" 128 // 116 used size, 8 vars
Vector 48 [_Color] 4
Float 112 [_Cutoff]
BindCB "$Globals" 0
SetTexture 0 [_BumpMap] 2D 1
SetTexture 1 [_MainTex] 2D 0
SetTexture 2 [_Shade] 2D 2
SetTexture 3 [_LightBuffer] 2D 3
// 24 instructions, 3 temp regs, 0 temp arrays:
// ALU 12 float, 0 int, 0 uint
// TEX 4 (0 load, 0 comp, 0 bias, 0 grad)
// FLOW 1 static, 0 dynamic
"ps_4_0
eefieceddogohmbcgpjnlbfmkhnebfodedeamlbcabaaaaaapiaeaaaaadaaaaaa
cmaaaaaaoeaaaaaabiabaaaaejfdeheolaaaaaaaagaaaaaaaiaaaaaajiaaaaaa
aaaaaaaaabaaaaaaadaaaaaaaaaaaaaaapaaaaaakeaaaaaaaaaaaaaaaaaaaaaa
adaaaaaaabaaaaaaapapaaaakeaaaaaaabaaaaaaaaaaaaaaadaaaaaaacaaaaaa
ahahaaaakeaaaaaaacaaaaaaaaaaaaaaadaaaaaaadaaaaaaahahaaaakeaaaaaa
adaaaaaaaaaaaaaaadaaaaaaaeaaaaaaapalaaaakeaaaaaaaeaaaaaaaaaaaaaa
adaaaaaaafaaaaaaahahaaaafdfgfpfaepfdejfeejepeoaafeeffiedepepfcee
aaklklklepfdeheocmaaaaaaabaaaaaaaiaaaaaacaaaaaaaaaaaaaaaaaaaaaaa
adaaaaaaaaaaaaaaapaaaaaafdfgfpfegbhcghgfheaaklklfdeieefcniadaaaa
eaaaaaaapgaaaaaafjaaaaaeegiocaaaaaaaaaaaaiaaaaaafkaaaaadaagabaaa
aaaaaaaafkaaaaadaagabaaaabaaaaaafkaaaaadaagabaaaacaaaaaafkaaaaad
aagabaaaadaaaaaafibiaaaeaahabaaaaaaaaaaaffffaaaafibiaaaeaahabaaa
abaaaaaaffffaaaafibiaaaeaahabaaaacaaaaaaffffaaaafibiaaaeaahabaaa
adaaaaaaffffaaaagcbaaaadpcbabaaaabaaaaaagcbaaaadhcbabaaaacaaaaaa
gcbaaaadhcbabaaaadaaaaaagcbaaaadlcbabaaaaeaaaaaagcbaaaadhcbabaaa
afaaaaaagfaaaaadpccabaaaaaaaaaaagiaaaaacadaaaaaaefaaaaajpcaabaaa
aaaaaaaaegbabaaaabaaaaaaeghobaaaabaaaaaaaagabaaaaaaaaaaaaaaaaaaj
bcaabaaaabaaaaaadkaabaaaaaaaaaaaakiacaiaebaaaaaaaaaaaaaaahaaaaaa
dbaaaaahbcaabaaaabaaaaaaakaabaaaabaaaaaaabeaaaaaaaaaaaaaanaaaead
akaabaaaabaaaaaaefaaaaajpcaabaaaabaaaaaaogbkbaaaabaaaaaaeghobaaa
aaaaaaaaaagabaaaabaaaaaadcaaaaapdcaabaaaabaaaaaahgapbaaaabaaaaaa
aceaaaaaaaaaaaeaaaaaaaeaaaaaaaaaaaaaaaaaaceaaaaaaaaaialpaaaaialp
aaaaaaaaaaaaaaaadcaaaaakicaabaaaabaaaaaaakaabaiaebaaaaaaabaaaaaa
akaabaaaabaaaaaaabeaaaaaaaaaiadpdcaaaaakicaabaaaabaaaaaabkaabaia
ebaaaaaaabaaaaaabkaabaaaabaaaaaadkaabaaaabaaaaaaelaaaaafecaabaaa
abaaaaaadkaabaaaabaaaaaabaaaaaahbcaabaaaacaaaaaaegbcbaaaacaaaaaa
egacbaaaabaaaaaabaaaaaahccaabaaaacaaaaaaegbcbaaaadaaaaaaegacbaaa
abaaaaaadcaaaaapdcaabaaaabaaaaaaegaabaaaacaaaaaaaceaaaaaaaaaaadp
aaaaaadpaaaaaaaaaaaaaaaaaceaaaaaaaaaaadpaaaaaadpaaaaaaaaaaaaaaaa
efaaaaajpcaabaaaabaaaaaaegaabaaaabaaaaaaeghobaaaacaaaaaaaagabaaa
acaaaaaadiaaaaahhcaabaaaabaaaaaaegacbaaaaaaaaaaaegacbaaaabaaaaaa
diaaaaaihcaabaaaabaaaaaaegacbaaaabaaaaaaegiccaaaaaaaaaaaadaaaaaa
diaaaaakhcaabaaaabaaaaaaegacbaaaabaaaaaaaceaaaaaaaaaeaeaaaaaeaea
aaaaeaeaaaaaaaaaaoaaaaahdcaabaaaacaaaaaaegbabaaaaeaaaaaapgbpbaaa
aeaaaaaaefaaaaajpcaabaaaacaaaaaaegaabaaaacaaaaaaeghobaaaadaaaaaa
aagabaaaadaaaaaacpaaaaafhcaabaaaacaaaaaaegacbaaaacaaaaaaaaaaaaai
hcaabaaaacaaaaaaegacbaiaebaaaaaaacaaaaaaegbcbaaaafaaaaaadiaaaaai
hcaabaaaaaaaaaaaegacbaaaaaaaaaaapgipcaaaaaaaaaaaadaaaaaadgaaaaaf
iccabaaaaaaaaaaadkaabaaaaaaaaaaadcaaaaajhccabaaaaaaaaaaaegacbaaa
aaaaaaaaegacbaaaacaaaaaaegacbaaaabaaaaaadoaaaaab"
}

SubProgram "gles " {
Keywords { "LIGHTMAP_OFF" "DIRLIGHTMAP_OFF" "HDR_LIGHT_PREPASS_OFF" }
"!!GLES"
}

SubProgram "glesdesktop " {
Keywords { "LIGHTMAP_OFF" "DIRLIGHTMAP_OFF" "HDR_LIGHT_PREPASS_OFF" }
"!!GLES"
}

SubProgram "d3d11_9x " {
Keywords { "LIGHTMAP_OFF" "DIRLIGHTMAP_OFF" "HDR_LIGHT_PREPASS_OFF" }
ConstBuffer "$Globals" 128 // 116 used size, 8 vars
Vector 48 [_Color] 4
Float 112 [_Cutoff]
BindCB "$Globals" 0
SetTexture 0 [_BumpMap] 2D 1
SetTexture 1 [_MainTex] 2D 0
SetTexture 2 [_Shade] 2D 2
SetTexture 3 [_LightBuffer] 2D 3
// 24 instructions, 3 temp regs, 0 temp arrays:
// ALU 12 float, 0 int, 0 uint
// TEX 4 (0 load, 0 comp, 0 bias, 0 grad)
// FLOW 1 static, 0 dynamic
"ps_4_0_level_9_3
eefiecedcnlblfgmdilmldhdpnpbmndfhgkcgfloabaaaaaajaahaaaaaeaaaaaa
daaaaaaameacaaaakeagaaaafmahaaaaebgpgodjimacaaaaimacaaaaaaacpppp
eaacaaaaemaaaaaaacaadeaaaaaaemaaaaaaemaaaeaaceaaaaaaemaaabaaaaaa
aaababaaacacacaaadadadaaaaaaadaaabaaaaaaaaaaaaaaaaaaahaaabaaabaa
aaaaaaaaabacppppfbaaaaafacaaapkaaaaaaaeaaaaaialpaaaaiadpaaaaaadp
fbaaaaafadaaapkaaaaaeaeaaaaaaaaaaaaaaaaaaaaaaaaabpaaaaacaaaaaaia
aaaaaplabpaaaaacaaaaaaiaabaaahlabpaaaaacaaaaaaiaacaaahlabpaaaaac
aaaaaaiaadaaaplabpaaaaacaaaaaaiaaeaaahlabpaaaaacaaaaaajaaaaiapka
bpaaaaacaaaaaajaabaiapkabpaaaaacaaaaaajaacaiapkabpaaaaacaaaaaaja
adaiapkaabaaaaacaaaaadiaaaaaoolaecaaaaadabaaapiaaaaaoelaaaaioeka
ecaaaaadaaaacpiaaaaaoeiaabaioekaacaaaaadacaacpiaabaappiaabaaaakb
aeaaaaaeaaaacdiaaaaaohiaacaaaakaacaaffkaaeaaaaaeaaaaciiaaaaaaaia
aaaaaaibacaakkkaaeaaaaaeaaaaciiaaaaaffiaaaaaffibaaaappiaahaaaaac
aaaaciiaaaaappiaagaaaaacaaaaceiaaaaappiaaiaaaaadadaacbiaabaaoela
aaaaoeiaaiaaaaadadaacciaacaaoelaaaaaoeiaaeaaaaaeaaaacdiaadaaoeia
acaappkaacaappkaebaaaaabacaaapiaecaaaaadaaaaapiaaaaaoeiaacaioeka
afaaaaadaaaaahiaabaaoeiaaaaaoeiaafaaaaadaaaaahiaaaaaoeiaaaaaoeka
afaaaaadaaaachiaaaaaoeiaadaaaakaagaaaaacaaaaaiiaadaapplaafaaaaad
acaaadiaaaaappiaadaaoelaecaaaaadacaacpiaacaaoeiaadaioekaapaaaaac
adaacbiaacaaaaiaapaaaaacadaacciaacaaffiaapaaaaacadaaceiaacaakkia
acaaaaadacaachiaadaaoeibaeaaoelaafaaaaadadaachiaabaaoeiaaaaappka
aeaaaaaeabaachiaadaaoeiaacaaoeiaaaaaoeiaabaaaaacaaaicpiaabaaoeia
ppppaaaafdeieefcniadaaaaeaaaaaaapgaaaaaafjaaaaaeegiocaaaaaaaaaaa
aiaaaaaafkaaaaadaagabaaaaaaaaaaafkaaaaadaagabaaaabaaaaaafkaaaaad
aagabaaaacaaaaaafkaaaaadaagabaaaadaaaaaafibiaaaeaahabaaaaaaaaaaa
ffffaaaafibiaaaeaahabaaaabaaaaaaffffaaaafibiaaaeaahabaaaacaaaaaa
ffffaaaafibiaaaeaahabaaaadaaaaaaffffaaaagcbaaaadpcbabaaaabaaaaaa
gcbaaaadhcbabaaaacaaaaaagcbaaaadhcbabaaaadaaaaaagcbaaaadlcbabaaa
aeaaaaaagcbaaaadhcbabaaaafaaaaaagfaaaaadpccabaaaaaaaaaaagiaaaaac
adaaaaaaefaaaaajpcaabaaaaaaaaaaaegbabaaaabaaaaaaeghobaaaabaaaaaa
aagabaaaaaaaaaaaaaaaaaajbcaabaaaabaaaaaadkaabaaaaaaaaaaaakiacaia
ebaaaaaaaaaaaaaaahaaaaaadbaaaaahbcaabaaaabaaaaaaakaabaaaabaaaaaa
abeaaaaaaaaaaaaaanaaaeadakaabaaaabaaaaaaefaaaaajpcaabaaaabaaaaaa
ogbkbaaaabaaaaaaeghobaaaaaaaaaaaaagabaaaabaaaaaadcaaaaapdcaabaaa
abaaaaaahgapbaaaabaaaaaaaceaaaaaaaaaaaeaaaaaaaeaaaaaaaaaaaaaaaaa
aceaaaaaaaaaialpaaaaialpaaaaaaaaaaaaaaaadcaaaaakicaabaaaabaaaaaa
akaabaiaebaaaaaaabaaaaaaakaabaaaabaaaaaaabeaaaaaaaaaiadpdcaaaaak
icaabaaaabaaaaaabkaabaiaebaaaaaaabaaaaaabkaabaaaabaaaaaadkaabaaa
abaaaaaaelaaaaafecaabaaaabaaaaaadkaabaaaabaaaaaabaaaaaahbcaabaaa
acaaaaaaegbcbaaaacaaaaaaegacbaaaabaaaaaabaaaaaahccaabaaaacaaaaaa
egbcbaaaadaaaaaaegacbaaaabaaaaaadcaaaaapdcaabaaaabaaaaaaegaabaaa
acaaaaaaaceaaaaaaaaaaadpaaaaaadpaaaaaaaaaaaaaaaaaceaaaaaaaaaaadp
aaaaaadpaaaaaaaaaaaaaaaaefaaaaajpcaabaaaabaaaaaaegaabaaaabaaaaaa
eghobaaaacaaaaaaaagabaaaacaaaaaadiaaaaahhcaabaaaabaaaaaaegacbaaa
aaaaaaaaegacbaaaabaaaaaadiaaaaaihcaabaaaabaaaaaaegacbaaaabaaaaaa
egiccaaaaaaaaaaaadaaaaaadiaaaaakhcaabaaaabaaaaaaegacbaaaabaaaaaa
aceaaaaaaaaaeaeaaaaaeaeaaaaaeaeaaaaaaaaaaoaaaaahdcaabaaaacaaaaaa
egbabaaaaeaaaaaapgbpbaaaaeaaaaaaefaaaaajpcaabaaaacaaaaaaegaabaaa
acaaaaaaeghobaaaadaaaaaaaagabaaaadaaaaaacpaaaaafhcaabaaaacaaaaaa
egacbaaaacaaaaaaaaaaaaaihcaabaaaacaaaaaaegacbaiaebaaaaaaacaaaaaa
egbcbaaaafaaaaaadiaaaaaihcaabaaaaaaaaaaaegacbaaaaaaaaaaapgipcaaa
aaaaaaaaadaaaaaadgaaaaaficcabaaaaaaaaaaadkaabaaaaaaaaaaadcaaaaaj
hccabaaaaaaaaaaaegacbaaaaaaaaaaaegacbaaaacaaaaaaegacbaaaabaaaaaa
doaaaaabejfdeheolaaaaaaaagaaaaaaaiaaaaaajiaaaaaaaaaaaaaaabaaaaaa
adaaaaaaaaaaaaaaapaaaaaakeaaaaaaaaaaaaaaaaaaaaaaadaaaaaaabaaaaaa
apapaaaakeaaaaaaabaaaaaaaaaaaaaaadaaaaaaacaaaaaaahahaaaakeaaaaaa
acaaaaaaaaaaaaaaadaaaaaaadaaaaaaahahaaaakeaaaaaaadaaaaaaaaaaaaaa
adaaaaaaaeaaaaaaapalaaaakeaaaaaaaeaaaaaaaaaaaaaaadaaaaaaafaaaaaa
ahahaaaafdfgfpfaepfdejfeejepeoaafeeffiedepepfceeaaklklklepfdeheo
cmaaaaaaabaaaaaaaiaaaaaacaaaaaaaaaaaaaaaaaaaaaaaadaaaaaaaaaaaaaa
apaaaaaafdfgfpfegbhcghgfheaaklkl"
}

SubProgram "opengl " {
Keywords { "LIGHTMAP_ON" "DIRLIGHTMAP_OFF" "HDR_LIGHT_PREPASS_OFF" }
Vector 0 [_Color]
Vector 1 [unity_LightmapFade]
Float 2 [_Cutoff]
SetTexture 0 [_BumpMap] 2D
SetTexture 1 [_MainTex] 2D
SetTexture 2 [_Shade] 2D
SetTexture 3 [_LightBuffer] 2D
SetTexture 4 [unity_Lightmap] 2D
SetTexture 5 [unity_LightmapInd] 2D
"!!ARBfp1.0
OPTION ARB_precision_hint_fastest;
# 36 ALU, 6 TEX
PARAM c[5] = { program.local[0..2],
		{ 8, 2, 1, 0.5 },
		{ 3 } };
TEMP R0;
TEMP R1;
TEMP R2;
TEMP R3;
TEMP R4;
TEX R0, fragment.texcoord[0], texture[1], 2D;
TEX R1.yw, fragment.texcoord[0].zwzw, texture[0], 2D;
MAD R1.xy, R1.wyzw, c[3].y, -c[3].z;
MUL R1.z, R1.y, R1.y;
MAD R1.z, -R1.x, R1.x, -R1;
SLT R2.x, R0.w, c[2];
ADD R1.z, R1, c[3];
RSQ R1.z, R1.z;
RCP R1.z, R1.z;
DP3 R1.w, R1, fragment.texcoord[2];
DP3 R1.z, fragment.texcoord[1], R1;
MAD R3.xy, R1.zwzw, c[3].w, c[3].w;
MOV result.color.w, R0;
TEX R4.xyz, R3, texture[2], 2D;
TEX R1, fragment.texcoord[4], texture[4], 2D;
KIL -R2.x;
TEX R2, fragment.texcoord[4], texture[5], 2D;
TXP R3.xyz, fragment.texcoord[3], texture[3], 2D;
MUL R4.xyz, R0, R4;
MUL R1.xyz, R1.w, R1;
DP4 R1.w, fragment.texcoord[5], fragment.texcoord[5];
MUL R2.xyz, R2.w, R2;
MUL R2.xyz, R2, c[3].x;
RSQ R1.w, R1.w;
RCP R1.w, R1.w;
MAD R1.xyz, R1, c[3].x, -R2;
MAD_SAT R1.w, R1, c[1].z, c[1];
MAD R1.xyz, R1.w, R1, R2;
LG2 R2.x, R3.x;
LG2 R2.y, R3.y;
LG2 R2.z, R3.z;
ADD R1.xyz, -R2, R1;
MUL R4.xyz, R4, c[0];
MUL R2.xyz, R4, c[4].x;
MUL R0.xyz, R0, c[0].w;
MAD result.color.xyz, R0, R1, R2;
END
# 36 instructions, 5 R-regs
"
}

SubProgram "d3d9 " {
Keywords { "LIGHTMAP_ON" "DIRLIGHTMAP_OFF" "HDR_LIGHT_PREPASS_OFF" }
Vector 0 [_Color]
Vector 1 [unity_LightmapFade]
Float 2 [_Cutoff]
SetTexture 0 [_BumpMap] 2D
SetTexture 1 [_MainTex] 2D
SetTexture 2 [_Shade] 2D
SetTexture 3 [_LightBuffer] 2D
SetTexture 4 [unity_Lightmap] 2D
SetTexture 5 [unity_LightmapInd] 2D
"ps_2_0
; 35 ALU, 7 TEX
dcl_2d s0
dcl_2d s1
dcl_2d s2
dcl_2d s3
dcl_2d s4
dcl_2d s5
def c3, 0.00000000, 1.00000000, 8.00000000, 0.50000000
def c4, 2.00000000, -1.00000000, 3.00000000, 0
dcl t0
dcl t1.xyz
dcl t2.xyz
dcl t3
dcl t4.xy
dcl t5
texld r1, t0, s1
mov r0.y, t0.w
mov r0.x, t0.z
texld r0, r0, s0
mov r0.x, r0.w
mad_pp r2.xy, r0, c4.x, c4.y
mul_pp r0.x, r2.y, r2.y
mad_pp r0.x, -r2, r2, -r0
add_pp r0.x, r0, c3.y
rsq_pp r0.x, r0.x
rcp_pp r2.z, r0.x
add_pp r0.x, r1.w, -c2
cmp r0.x, r0, c3, c3.y
mov_pp r0, -r0.x
dp3 r3.x, t1, r2
dp3 r3.y, r2, t2
mad_pp r2.xy, r3, c3.w, c3.w
texld r4, r2, s2
texkill r0.xyzw
texldp r2, t3, s3
texld r0, t4, s5
texld r3, t4, s4
mul_pp r5.xyz, r0.w, r0
mul r4.xyz, r1, r4
dp4 r0.x, t5, t5
rsq r0.x, r0.x
rcp r0.x, r0.x
mul_pp r5.xyz, r5, c3.z
mul_pp r3.xyz, r3.w, r3
log_pp r2.x, r2.x
log_pp r2.y, r2.y
log_pp r2.z, r2.z
mul r4.xyz, r4, c0
mad_pp r3.xyz, r3, c3.z, -r5
mad_sat r0.x, r0, c1.z, c1.w
mad_pp r0.xyz, r0.x, r3, r5
add_pp r0.xyz, -r2, r0
mul r2.xyz, r4, c4.z
mul r1.xyz, r1, c0.w
mov_pp r0.w, r1
mad_pp r0.xyz, r1, r0, r2
mov_pp oC0, r0
"
}

SubProgram "d3d11 " {
Keywords { "LIGHTMAP_ON" "DIRLIGHTMAP_OFF" "HDR_LIGHT_PREPASS_OFF" }
ConstBuffer "$Globals" 160 // 148 used size, 10 vars
Vector 48 [_Color] 4
Vector 112 [unity_LightmapFade] 4
Float 144 [_Cutoff]
BindCB "$Globals" 0
SetTexture 0 [_BumpMap] 2D 1
SetTexture 1 [_MainTex] 2D 0
SetTexture 2 [_Shade] 2D 2
SetTexture 3 [_LightBuffer] 2D 3
SetTexture 4 [unity_Lightmap] 2D 4
SetTexture 5 [unity_LightmapInd] 2D 5
// 34 instructions, 4 temp regs, 0 temp arrays:
// ALU 17 float, 0 int, 0 uint
// TEX 6 (0 load, 0 comp, 0 bias, 0 grad)
// FLOW 1 static, 0 dynamic
"ps_4_0
eefiecedpjgifnmbhcophfijempgojakjijldgefabaaaaaajiagaaaaadaaaaaa
cmaaaaaapmaaaaaadaabaaaaejfdeheomiaaaaaaahaaaaaaaiaaaaaalaaaaaaa
aaaaaaaaabaaaaaaadaaaaaaaaaaaaaaapaaaaaalmaaaaaaaaaaaaaaaaaaaaaa
adaaaaaaabaaaaaaapapaaaalmaaaaaaabaaaaaaaaaaaaaaadaaaaaaacaaaaaa
ahahaaaalmaaaaaaacaaaaaaaaaaaaaaadaaaaaaadaaaaaaahahaaaalmaaaaaa
adaaaaaaaaaaaaaaadaaaaaaaeaaaaaaapalaaaalmaaaaaaaeaaaaaaaaaaaaaa
adaaaaaaafaaaaaaadadaaaalmaaaaaaafaaaaaaaaaaaaaaadaaaaaaagaaaaaa
apapaaaafdfgfpfaepfdejfeejepeoaafeeffiedepepfceeaaklklklepfdeheo
cmaaaaaaabaaaaaaaiaaaaaacaaaaaaaaaaaaaaaaaaaaaaaadaaaaaaaaaaaaaa
apaaaaaafdfgfpfegbhcghgfheaaklklfdeieefcgaafaaaaeaaaaaaafiabaaaa
fjaaaaaeegiocaaaaaaaaaaaakaaaaaafkaaaaadaagabaaaaaaaaaaafkaaaaad
aagabaaaabaaaaaafkaaaaadaagabaaaacaaaaaafkaaaaadaagabaaaadaaaaaa
fkaaaaadaagabaaaaeaaaaaafkaaaaadaagabaaaafaaaaaafibiaaaeaahabaaa
aaaaaaaaffffaaaafibiaaaeaahabaaaabaaaaaaffffaaaafibiaaaeaahabaaa
acaaaaaaffffaaaafibiaaaeaahabaaaadaaaaaaffffaaaafibiaaaeaahabaaa
aeaaaaaaffffaaaafibiaaaeaahabaaaafaaaaaaffffaaaagcbaaaadpcbabaaa
abaaaaaagcbaaaadhcbabaaaacaaaaaagcbaaaadhcbabaaaadaaaaaagcbaaaad
lcbabaaaaeaaaaaagcbaaaaddcbabaaaafaaaaaagcbaaaadpcbabaaaagaaaaaa
gfaaaaadpccabaaaaaaaaaaagiaaaaacaeaaaaaaefaaaaajpcaabaaaaaaaaaaa
egbabaaaabaaaaaaeghobaaaabaaaaaaaagabaaaaaaaaaaaaaaaaaajbcaabaaa
abaaaaaadkaabaaaaaaaaaaaakiacaiaebaaaaaaaaaaaaaaajaaaaaadbaaaaah
bcaabaaaabaaaaaaakaabaaaabaaaaaaabeaaaaaaaaaaaaaanaaaeadakaabaaa
abaaaaaabbaaaaahbcaabaaaabaaaaaaegbobaaaagaaaaaaegbobaaaagaaaaaa
elaaaaafbcaabaaaabaaaaaaakaabaaaabaaaaaadccaaaalbcaabaaaabaaaaaa
akaabaaaabaaaaaackiacaaaaaaaaaaaahaaaaaadkiacaaaaaaaaaaaahaaaaaa
efaaaaajpcaabaaaacaaaaaaegbabaaaafaaaaaaeghobaaaafaaaaaaaagabaaa
afaaaaaadiaaaaahccaabaaaabaaaaaadkaabaaaacaaaaaaabeaaaaaaaaaaaeb
diaaaaahocaabaaaabaaaaaaagajbaaaacaaaaaafgafbaaaabaaaaaaefaaaaaj
pcaabaaaacaaaaaaegbabaaaafaaaaaaeghobaaaaeaaaaaaaagabaaaaeaaaaaa
diaaaaahicaabaaaacaaaaaadkaabaaaacaaaaaaabeaaaaaaaaaaaebdcaaaaak
hcaabaaaacaaaaaapgapbaaaacaaaaaaegacbaaaacaaaaaajgahbaiaebaaaaaa
abaaaaaadcaaaaajhcaabaaaabaaaaaaagaabaaaabaaaaaaegacbaaaacaaaaaa
jgahbaaaabaaaaaaaoaaaaahdcaabaaaacaaaaaaegbabaaaaeaaaaaapgbpbaaa
aeaaaaaaefaaaaajpcaabaaaacaaaaaaegaabaaaacaaaaaaeghobaaaadaaaaaa
aagabaaaadaaaaaacpaaaaafhcaabaaaacaaaaaaegacbaaaacaaaaaaaaaaaaai
hcaabaaaabaaaaaaegacbaaaabaaaaaaegacbaiaebaaaaaaacaaaaaaefaaaaaj
pcaabaaaacaaaaaaogbkbaaaabaaaaaaeghobaaaaaaaaaaaaagabaaaabaaaaaa
dcaaaaapdcaabaaaacaaaaaahgapbaaaacaaaaaaaceaaaaaaaaaaaeaaaaaaaea
aaaaaaaaaaaaaaaaaceaaaaaaaaaialpaaaaialpaaaaaaaaaaaaaaaadcaaaaak
icaabaaaabaaaaaaakaabaiaebaaaaaaacaaaaaaakaabaaaacaaaaaaabeaaaaa
aaaaiadpdcaaaaakicaabaaaabaaaaaabkaabaiaebaaaaaaacaaaaaabkaabaaa
acaaaaaadkaabaaaabaaaaaaelaaaaafecaabaaaacaaaaaadkaabaaaabaaaaaa
baaaaaahbcaabaaaadaaaaaaegbcbaaaacaaaaaaegacbaaaacaaaaaabaaaaaah
ccaabaaaadaaaaaaegbcbaaaadaaaaaaegacbaaaacaaaaaadcaaaaapdcaabaaa
acaaaaaaegaabaaaadaaaaaaaceaaaaaaaaaaadpaaaaaadpaaaaaaaaaaaaaaaa
aceaaaaaaaaaaadpaaaaaadpaaaaaaaaaaaaaaaaefaaaaajpcaabaaaacaaaaaa
egaabaaaacaaaaaaeghobaaaacaaaaaaaagabaaaacaaaaaadiaaaaahhcaabaaa
acaaaaaaegacbaaaaaaaaaaaegacbaaaacaaaaaadiaaaaaihcaabaaaacaaaaaa
egacbaaaacaaaaaaegiccaaaaaaaaaaaadaaaaaadiaaaaakhcaabaaaacaaaaaa
egacbaaaacaaaaaaaceaaaaaaaaaeaeaaaaaeaeaaaaaeaeaaaaaaaaadiaaaaai
hcaabaaaaaaaaaaaegacbaaaaaaaaaaapgipcaaaaaaaaaaaadaaaaaadgaaaaaf
iccabaaaaaaaaaaadkaabaaaaaaaaaaadcaaaaajhccabaaaaaaaaaaaegacbaaa
aaaaaaaaegacbaaaabaaaaaaegacbaaaacaaaaaadoaaaaab"
}

SubProgram "gles " {
Keywords { "LIGHTMAP_ON" "DIRLIGHTMAP_OFF" "HDR_LIGHT_PREPASS_OFF" }
"!!GLES"
}

SubProgram "glesdesktop " {
Keywords { "LIGHTMAP_ON" "DIRLIGHTMAP_OFF" "HDR_LIGHT_PREPASS_OFF" }
"!!GLES"
}

SubProgram "d3d11_9x " {
Keywords { "LIGHTMAP_ON" "DIRLIGHTMAP_OFF" "HDR_LIGHT_PREPASS_OFF" }
ConstBuffer "$Globals" 160 // 148 used size, 10 vars
Vector 48 [_Color] 4
Vector 112 [unity_LightmapFade] 4
Float 144 [_Cutoff]
BindCB "$Globals" 0
SetTexture 0 [_BumpMap] 2D 1
SetTexture 1 [_MainTex] 2D 0
SetTexture 2 [_Shade] 2D 2
SetTexture 3 [_LightBuffer] 2D 3
SetTexture 4 [unity_Lightmap] 2D 4
SetTexture 5 [unity_LightmapInd] 2D 5
// 34 instructions, 4 temp regs, 0 temp arrays:
// ALU 17 float, 0 int, 0 uint
// TEX 6 (0 load, 0 comp, 0 bias, 0 grad)
// FLOW 1 static, 0 dynamic
"ps_4_0_level_9_3
eefiecedgkhpfgojbokpkjieomnddhoffbdcfmefabaaaaaabmakaaaaaeaaaaaa
daaaaaaalaadaaaabiajaaaaoiajaaaaebgpgodjhiadaaaahiadaaaaaaacpppp
biadaaaagaaaaaaaadaadmaaaaaagaaaaaaagaaaagaaceaaaaaagaaaabaaaaaa
aaababaaacacacaaadadadaaaeaeaeaaafafafaaaaaaadaaabaaaaaaaaaaaaaa
aaaaahaaabaaabaaaaaaaaaaaaaaajaaabaaacaaaaaaaaaaabacppppfbaaaaaf
adaaapkaaaaaaaeaaaaaialpaaaaiadpaaaaaadpfbaaaaafaeaaapkaaaaaeaea
aaaaaaebaaaaaaaaaaaaaaaabpaaaaacaaaaaaiaaaaaaplabpaaaaacaaaaaaia
abaaahlabpaaaaacaaaaaaiaacaaahlabpaaaaacaaaaaaiaadaaaplabpaaaaac
aaaaaaiaaeaaadlabpaaaaacaaaaaaiaafaaaplabpaaaaacaaaaaajaaaaiapka
bpaaaaacaaaaaajaabaiapkabpaaaaacaaaaaajaacaiapkabpaaaaacaaaaaaja
adaiapkabpaaaaacaaaaaajaaeaiapkabpaaaaacaaaaaajaafaiapkaabaaaaac
aaaaadiaaaaaoolaecaaaaadabaaapiaaaaaoelaaaaioekaecaaaaadaaaacpia
aaaaoeiaabaioekaacaaaaadacaacpiaabaappiaacaaaakbecaaaaadadaacpia
aeaaoelaafaioekaebaaaaabacaaapiaajaaaaadaaaaabiaafaaoelaafaaoela
ahaaaaacaaaaabiaaaaaaaiaagaaaaacaaaaabiaaaaaaaiaaeaaaaaeaaaabbia
aaaaaaiaabaakkkaabaappkaafaaaaadadaaciiaadaappiaaeaaffkaafaaaaad
acaachiaadaaoeiaadaappiaagaaaaacacaaaiiaadaapplaafaaaaadadaaadia
acaappiaadaaoelaecaaaaadaeaacpiaaeaaoelaaeaioekaecaaaaadadaacpia
adaaoeiaadaioekaafaaaaadacaaciiaaeaappiaaeaaffkaaeaaaaaeaeaaahia
acaappiaaeaaoeiaacaaoeibaeaaaaaeacaachiaaaaaaaiaaeaaoeiaacaaoeia
apaaaaacaeaacbiaadaaaaiaapaaaaacaeaacciaadaaffiaapaaaaacaeaaceia
adaakkiaacaaaaadacaachiaacaaoeiaaeaaoeibaeaaaaaeaaaacdiaaaaaohia
adaaaakaadaaffkaaeaaaaaeaaaaciiaaaaaaaiaaaaaaaibadaakkkaaeaaaaae
aaaaciiaaaaaffiaaaaaffibaaaappiaahaaaaacaaaaciiaaaaappiaagaaaaac
aaaaceiaaaaappiaaiaaaaadadaacbiaabaaoelaaaaaoeiaaiaaaaadadaaccia
acaaoelaaaaaoeiaaeaaaaaeaaaacdiaadaaoeiaadaappkaadaappkaecaaaaad
aaaaapiaaaaaoeiaacaioekaafaaaaadaaaaahiaabaaoeiaaaaaoeiaafaaaaad
aaaaahiaaaaaoeiaaaaaoekaafaaaaadaaaachiaaaaaoeiaaeaaaakaafaaaaad
adaachiaabaaoeiaaaaappkaaeaaaaaeabaachiaadaaoeiaacaaoeiaaaaaoeia
abaaaaacaaaicpiaabaaoeiappppaaaafdeieefcgaafaaaaeaaaaaaafiabaaaa
fjaaaaaeegiocaaaaaaaaaaaakaaaaaafkaaaaadaagabaaaaaaaaaaafkaaaaad
aagabaaaabaaaaaafkaaaaadaagabaaaacaaaaaafkaaaaadaagabaaaadaaaaaa
fkaaaaadaagabaaaaeaaaaaafkaaaaadaagabaaaafaaaaaafibiaaaeaahabaaa
aaaaaaaaffffaaaafibiaaaeaahabaaaabaaaaaaffffaaaafibiaaaeaahabaaa
acaaaaaaffffaaaafibiaaaeaahabaaaadaaaaaaffffaaaafibiaaaeaahabaaa
aeaaaaaaffffaaaafibiaaaeaahabaaaafaaaaaaffffaaaagcbaaaadpcbabaaa
abaaaaaagcbaaaadhcbabaaaacaaaaaagcbaaaadhcbabaaaadaaaaaagcbaaaad
lcbabaaaaeaaaaaagcbaaaaddcbabaaaafaaaaaagcbaaaadpcbabaaaagaaaaaa
gfaaaaadpccabaaaaaaaaaaagiaaaaacaeaaaaaaefaaaaajpcaabaaaaaaaaaaa
egbabaaaabaaaaaaeghobaaaabaaaaaaaagabaaaaaaaaaaaaaaaaaajbcaabaaa
abaaaaaadkaabaaaaaaaaaaaakiacaiaebaaaaaaaaaaaaaaajaaaaaadbaaaaah
bcaabaaaabaaaaaaakaabaaaabaaaaaaabeaaaaaaaaaaaaaanaaaeadakaabaaa
abaaaaaabbaaaaahbcaabaaaabaaaaaaegbobaaaagaaaaaaegbobaaaagaaaaaa
elaaaaafbcaabaaaabaaaaaaakaabaaaabaaaaaadccaaaalbcaabaaaabaaaaaa
akaabaaaabaaaaaackiacaaaaaaaaaaaahaaaaaadkiacaaaaaaaaaaaahaaaaaa
efaaaaajpcaabaaaacaaaaaaegbabaaaafaaaaaaeghobaaaafaaaaaaaagabaaa
afaaaaaadiaaaaahccaabaaaabaaaaaadkaabaaaacaaaaaaabeaaaaaaaaaaaeb
diaaaaahocaabaaaabaaaaaaagajbaaaacaaaaaafgafbaaaabaaaaaaefaaaaaj
pcaabaaaacaaaaaaegbabaaaafaaaaaaeghobaaaaeaaaaaaaagabaaaaeaaaaaa
diaaaaahicaabaaaacaaaaaadkaabaaaacaaaaaaabeaaaaaaaaaaaebdcaaaaak
hcaabaaaacaaaaaapgapbaaaacaaaaaaegacbaaaacaaaaaajgahbaiaebaaaaaa
abaaaaaadcaaaaajhcaabaaaabaaaaaaagaabaaaabaaaaaaegacbaaaacaaaaaa
jgahbaaaabaaaaaaaoaaaaahdcaabaaaacaaaaaaegbabaaaaeaaaaaapgbpbaaa
aeaaaaaaefaaaaajpcaabaaaacaaaaaaegaabaaaacaaaaaaeghobaaaadaaaaaa
aagabaaaadaaaaaacpaaaaafhcaabaaaacaaaaaaegacbaaaacaaaaaaaaaaaaai
hcaabaaaabaaaaaaegacbaaaabaaaaaaegacbaiaebaaaaaaacaaaaaaefaaaaaj
pcaabaaaacaaaaaaogbkbaaaabaaaaaaeghobaaaaaaaaaaaaagabaaaabaaaaaa
dcaaaaapdcaabaaaacaaaaaahgapbaaaacaaaaaaaceaaaaaaaaaaaeaaaaaaaea
aaaaaaaaaaaaaaaaaceaaaaaaaaaialpaaaaialpaaaaaaaaaaaaaaaadcaaaaak
icaabaaaabaaaaaaakaabaiaebaaaaaaacaaaaaaakaabaaaacaaaaaaabeaaaaa
aaaaiadpdcaaaaakicaabaaaabaaaaaabkaabaiaebaaaaaaacaaaaaabkaabaaa
acaaaaaadkaabaaaabaaaaaaelaaaaafecaabaaaacaaaaaadkaabaaaabaaaaaa
baaaaaahbcaabaaaadaaaaaaegbcbaaaacaaaaaaegacbaaaacaaaaaabaaaaaah
ccaabaaaadaaaaaaegbcbaaaadaaaaaaegacbaaaacaaaaaadcaaaaapdcaabaaa
acaaaaaaegaabaaaadaaaaaaaceaaaaaaaaaaadpaaaaaadpaaaaaaaaaaaaaaaa
aceaaaaaaaaaaadpaaaaaadpaaaaaaaaaaaaaaaaefaaaaajpcaabaaaacaaaaaa
egaabaaaacaaaaaaeghobaaaacaaaaaaaagabaaaacaaaaaadiaaaaahhcaabaaa
acaaaaaaegacbaaaaaaaaaaaegacbaaaacaaaaaadiaaaaaihcaabaaaacaaaaaa
egacbaaaacaaaaaaegiccaaaaaaaaaaaadaaaaaadiaaaaakhcaabaaaacaaaaaa
egacbaaaacaaaaaaaceaaaaaaaaaeaeaaaaaeaeaaaaaeaeaaaaaaaaadiaaaaai
hcaabaaaaaaaaaaaegacbaaaaaaaaaaapgipcaaaaaaaaaaaadaaaaaadgaaaaaf
iccabaaaaaaaaaaadkaabaaaaaaaaaaadcaaaaajhccabaaaaaaaaaaaegacbaaa
aaaaaaaaegacbaaaabaaaaaaegacbaaaacaaaaaadoaaaaabejfdeheomiaaaaaa
ahaaaaaaaiaaaaaalaaaaaaaaaaaaaaaabaaaaaaadaaaaaaaaaaaaaaapaaaaaa
lmaaaaaaaaaaaaaaaaaaaaaaadaaaaaaabaaaaaaapapaaaalmaaaaaaabaaaaaa
aaaaaaaaadaaaaaaacaaaaaaahahaaaalmaaaaaaacaaaaaaaaaaaaaaadaaaaaa
adaaaaaaahahaaaalmaaaaaaadaaaaaaaaaaaaaaadaaaaaaaeaaaaaaapalaaaa
lmaaaaaaaeaaaaaaaaaaaaaaadaaaaaaafaaaaaaadadaaaalmaaaaaaafaaaaaa
aaaaaaaaadaaaaaaagaaaaaaapapaaaafdfgfpfaepfdejfeejepeoaafeeffied
epepfceeaaklklklepfdeheocmaaaaaaabaaaaaaaiaaaaaacaaaaaaaaaaaaaaa
aaaaaaaaadaaaaaaaaaaaaaaapaaaaaafdfgfpfegbhcghgfheaaklkl"
}

SubProgram "opengl " {
Keywords { "LIGHTMAP_ON" "DIRLIGHTMAP_ON" "HDR_LIGHT_PREPASS_OFF" }
Vector 0 [_Color]
Float 1 [_Cutoff]
SetTexture 0 [_BumpMap] 2D
SetTexture 1 [_MainTex] 2D
SetTexture 2 [_Shade] 2D
SetTexture 3 [_LightBuffer] 2D
SetTexture 4 [unity_Lightmap] 2D
SetTexture 5 [unity_LightmapInd] 2D
"!!ARBfp1.0
OPTION ARB_precision_hint_fastest;
# 35 ALU, 6 TEX
PARAM c[6] = { program.local[0..1],
		{ 2, 1, 8, 0.5 },
		{ -0.40824828, -0.70710677, 0.57735026, 3 },
		{ -0.40824831, 0.70710677, 0.57735026 },
		{ 0.81649655, 0, 0.57735026 } };
TEMP R0;
TEMP R1;
TEMP R2;
TEMP R3;
TEMP R4;
TEMP R5;
TEMP R6;
TEX R0, fragment.texcoord[0], texture[1], 2D;
TEX R1.yw, fragment.texcoord[0].zwzw, texture[0], 2D;
TEX R2, fragment.texcoord[4], texture[5], 2D;
MAD R4.xy, R1.wyzw, c[2].x, -c[2].y;
MUL R1.x, R4.y, R4.y;
MAD R1.x, -R4, R4, -R1;
SLT R1.z, R0.w, c[1].x;
ADD R1.x, R1, c[2].y;
RSQ R1.x, R1.x;
RCP R4.z, R1.x;
DP3 R1.y, R4, fragment.texcoord[2];
DP3 R1.x, R4, fragment.texcoord[1];
MAD R3.xy, R1, c[2].w, c[2].w;
DP3_SAT R6.z, R4, c[3];
DP3_SAT R6.x, R4, c[5];
DP3_SAT R6.y, R4, c[4];
MUL R2.xyz, R2.w, R2;
MUL R2.xyz, R2, R6;
DP3 R2.x, R2, c[2].z;
MOV result.color.w, R0;
TEX R5.xyz, R3, texture[2], 2D;
TXP R3.xyz, fragment.texcoord[3], texture[3], 2D;
KIL -R1.z;
TEX R1, fragment.texcoord[4], texture[4], 2D;
MUL R5.xyz, R0, R5;
MUL R1.xyz, R1.w, R1;
MUL R1.xyz, R1, R2.x;
LG2 R2.x, R3.x;
LG2 R2.z, R3.z;
LG2 R2.y, R3.y;
MAD R1.xyz, R1, c[2].z, -R2;
MUL R4.xyz, R5, c[0];
MUL R2.xyz, R4, c[3].w;
MUL R0.xyz, R0, c[0].w;
MAD result.color.xyz, R0, R1, R2;
END
# 35 instructions, 7 R-regs
"
}

SubProgram "d3d9 " {
Keywords { "LIGHTMAP_ON" "DIRLIGHTMAP_ON" "HDR_LIGHT_PREPASS_OFF" }
Vector 0 [_Color]
Float 1 [_Cutoff]
SetTexture 0 [_BumpMap] 2D
SetTexture 1 [_MainTex] 2D
SetTexture 2 [_Shade] 2D
SetTexture 3 [_LightBuffer] 2D
SetTexture 4 [unity_Lightmap] 2D
SetTexture 5 [unity_LightmapInd] 2D
"ps_2_0
; 34 ALU, 7 TEX
dcl_2d s0
dcl_2d s1
dcl_2d s2
dcl_2d s3
dcl_2d s4
dcl_2d s5
def c2, 0.00000000, 1.00000000, 2.00000000, -1.00000000
def c3, -0.40824828, -0.70710677, 0.57735026, 8.00000000
def c4, -0.40824831, 0.70710677, 0.57735026, 0.50000000
def c5, 0.81649655, 0.00000000, 0.57735026, 3.00000000
dcl t0
dcl t1.xyz
dcl t2.xyz
dcl t3
dcl t4.xy
texld r2, t0, s1
texldp r4, t3, s3
mov r0.y, t0.w
mov r0.x, t0.z
texld r0, r0, s0
mov r0.x, r0.w
mad_pp r5.xy, r0, c2.z, c2.w
mul_pp r0.x, r5.y, r5.y
mad_pp r0.x, -r5, r5, -r0
add_pp r0.x, r0, c2.y
rsq_pp r0.x, r0.x
rcp_pp r5.z, r0.x
add_pp r0.x, r2.w, -c1
cmp r0.x, r0, c2, c2.y
mov_pp r0, -r0.x
dp3 r1.x, r5, t1
dp3 r1.y, r5, t2
mad_pp r1.xy, r1, c4.w, c4.w
dp3_pp_sat r6.z, r5, c3
dp3_pp_sat r6.y, r5, c4
dp3_pp_sat r6.x, r5, c5
texld r3, r1, s2
texkill r0.xyzw
texld r1, t4, s4
texld r0, t4, s5
mul_pp r0.xyz, r0.w, r0
mul_pp r0.xyz, r0, r6
mul_pp r1.xyz, r1.w, r1
dp3_pp r0.x, r0, c3.w
mul_pp r0.xyz, r1, r0.x
mul r1.xyz, r2, r3
mul r1.xyz, r1, c0
log_pp r3.x, r4.x
log_pp r3.z, r4.z
log_pp r3.y, r4.y
mad_pp r0.xyz, r0, c3.w, -r3
mul r1.xyz, r1, c5.w
mul r2.xyz, r2, c0.w
mov_pp r0.w, r2
mad_pp r0.xyz, r2, r0, r1
mov_pp oC0, r0
"
}

SubProgram "d3d11 " {
Keywords { "LIGHTMAP_ON" "DIRLIGHTMAP_ON" "HDR_LIGHT_PREPASS_OFF" }
ConstBuffer "$Globals" 160 // 148 used size, 10 vars
Vector 48 [_Color] 4
Float 144 [_Cutoff]
BindCB "$Globals" 0
SetTexture 0 [_BumpMap] 2D 1
SetTexture 1 [_MainTex] 2D 0
SetTexture 2 [_Shade] 2D 2
SetTexture 3 [_LightBuffer] 2D 3
SetTexture 4 [unity_Lightmap] 2D 4
SetTexture 5 [unity_LightmapInd] 2D 5
// 34 instructions, 6 temp regs, 0 temp arrays:
// ALU 19 float, 0 int, 0 uint
// TEX 6 (0 load, 0 comp, 0 bias, 0 grad)
// FLOW 1 static, 0 dynamic
"ps_4_0
eefiecedmkaibbkiiaonkohekmaidaheijkhncjjabaaaaaaieagaaaaadaaaaaa
cmaaaaaaoeaaaaaabiabaaaaejfdeheolaaaaaaaagaaaaaaaiaaaaaajiaaaaaa
aaaaaaaaabaaaaaaadaaaaaaaaaaaaaaapaaaaaakeaaaaaaaaaaaaaaaaaaaaaa
adaaaaaaabaaaaaaapapaaaakeaaaaaaabaaaaaaaaaaaaaaadaaaaaaacaaaaaa
ahahaaaakeaaaaaaacaaaaaaaaaaaaaaadaaaaaaadaaaaaaahahaaaakeaaaaaa
adaaaaaaaaaaaaaaadaaaaaaaeaaaaaaapalaaaakeaaaaaaaeaaaaaaaaaaaaaa
adaaaaaaafaaaaaaadadaaaafdfgfpfaepfdejfeejepeoaafeeffiedepepfcee
aaklklklepfdeheocmaaaaaaabaaaaaaaiaaaaaacaaaaaaaaaaaaaaaaaaaaaaa
adaaaaaaaaaaaaaaapaaaaaafdfgfpfegbhcghgfheaaklklfdeieefcgeafaaaa
eaaaaaaafjabaaaafjaaaaaeegiocaaaaaaaaaaaakaaaaaafkaaaaadaagabaaa
aaaaaaaafkaaaaadaagabaaaabaaaaaafkaaaaadaagabaaaacaaaaaafkaaaaad
aagabaaaadaaaaaafkaaaaadaagabaaaaeaaaaaafkaaaaadaagabaaaafaaaaaa
fibiaaaeaahabaaaaaaaaaaaffffaaaafibiaaaeaahabaaaabaaaaaaffffaaaa
fibiaaaeaahabaaaacaaaaaaffffaaaafibiaaaeaahabaaaadaaaaaaffffaaaa
fibiaaaeaahabaaaaeaaaaaaffffaaaafibiaaaeaahabaaaafaaaaaaffffaaaa
gcbaaaadpcbabaaaabaaaaaagcbaaaadhcbabaaaacaaaaaagcbaaaadhcbabaaa
adaaaaaagcbaaaadlcbabaaaaeaaaaaagcbaaaaddcbabaaaafaaaaaagfaaaaad
pccabaaaaaaaaaaagiaaaaacagaaaaaaefaaaaajpcaabaaaaaaaaaaaegbabaaa
abaaaaaaeghobaaaabaaaaaaaagabaaaaaaaaaaaaaaaaaajbcaabaaaabaaaaaa
dkaabaaaaaaaaaaaakiacaiaebaaaaaaaaaaaaaaajaaaaaadbaaaaahbcaabaaa
abaaaaaaakaabaaaabaaaaaaabeaaaaaaaaaaaaaanaaaeadakaabaaaabaaaaaa
aoaaaaahdcaabaaaabaaaaaaegbabaaaaeaaaaaapgbpbaaaaeaaaaaaefaaaaaj
pcaabaaaabaaaaaaegaabaaaabaaaaaaeghobaaaadaaaaaaaagabaaaadaaaaaa
cpaaaaafhcaabaaaabaaaaaaegacbaaaabaaaaaaefaaaaajpcaabaaaacaaaaaa
egbabaaaafaaaaaaeghobaaaaeaaaaaaaagabaaaaeaaaaaadiaaaaahicaabaaa
abaaaaaadkaabaaaacaaaaaaabeaaaaaaaaaaaebdiaaaaahhcaabaaaacaaaaaa
egacbaaaacaaaaaapgapbaaaabaaaaaaefaaaaajpcaabaaaadaaaaaaegbabaaa
afaaaaaaeghobaaaafaaaaaaaagabaaaafaaaaaadiaaaaahicaabaaaabaaaaaa
dkaabaaaadaaaaaaabeaaaaaaaaaaaebdiaaaaahhcaabaaaadaaaaaaegacbaaa
adaaaaaapgapbaaaabaaaaaaefaaaaajpcaabaaaaeaaaaaaogbkbaaaabaaaaaa
eghobaaaaaaaaaaaaagabaaaabaaaaaadcaaaaapdcaabaaaaeaaaaaahgapbaaa
aeaaaaaaaceaaaaaaaaaaaeaaaaaaaeaaaaaaaaaaaaaaaaaaceaaaaaaaaaialp
aaaaialpaaaaaaaaaaaaaaaadcaaaaakicaabaaaabaaaaaaakaabaiaebaaaaaa
aeaaaaaaakaabaaaaeaaaaaaabeaaaaaaaaaiadpdcaaaaakicaabaaaabaaaaaa
bkaabaiaebaaaaaaaeaaaaaabkaabaaaaeaaaaaadkaabaaaabaaaaaaelaaaaaf
ecaabaaaaeaaaaaadkaabaaaabaaaaaaapcaaaakbcaabaaaafaaaaaaaceaaaaa
olaffbdpdkmnbddpaaaaaaaaaaaaaaaaigaabaaaaeaaaaaabacaaaakccaabaaa
afaaaaaaaceaaaaaomafnblopdaedfdpdkmnbddpaaaaaaaaegacbaaaaeaaaaaa
bacaaaakecaabaaaafaaaaaaaceaaaaaolafnblopdaedflpdkmnbddpaaaaaaaa
egacbaaaaeaaaaaabaaaaaahicaabaaaabaaaaaaegacbaaaafaaaaaaegacbaaa
adaaaaaadcaaaaakhcaabaaaabaaaaaaegacbaaaacaaaaaapgapbaaaabaaaaaa
egacbaiaebaaaaaaabaaaaaabaaaaaahbcaabaaaacaaaaaaegbcbaaaacaaaaaa
egacbaaaaeaaaaaabaaaaaahccaabaaaacaaaaaaegbcbaaaadaaaaaaegacbaaa
aeaaaaaadcaaaaapdcaabaaaacaaaaaaegaabaaaacaaaaaaaceaaaaaaaaaaadp
aaaaaadpaaaaaaaaaaaaaaaaaceaaaaaaaaaaadpaaaaaadpaaaaaaaaaaaaaaaa
efaaaaajpcaabaaaacaaaaaaegaabaaaacaaaaaaeghobaaaacaaaaaaaagabaaa
acaaaaaadiaaaaahhcaabaaaacaaaaaaegacbaaaaaaaaaaaegacbaaaacaaaaaa
diaaaaaihcaabaaaacaaaaaaegacbaaaacaaaaaaegiccaaaaaaaaaaaadaaaaaa
diaaaaakhcaabaaaacaaaaaaegacbaaaacaaaaaaaceaaaaaaaaaeaeaaaaaeaea
aaaaeaeaaaaaaaaadiaaaaaihcaabaaaaaaaaaaaegacbaaaaaaaaaaapgipcaaa
aaaaaaaaadaaaaaadgaaaaaficcabaaaaaaaaaaadkaabaaaaaaaaaaadcaaaaaj
hccabaaaaaaaaaaaegacbaaaaaaaaaaaegacbaaaabaaaaaaegacbaaaacaaaaaa
doaaaaab"
}

SubProgram "gles " {
Keywords { "LIGHTMAP_ON" "DIRLIGHTMAP_ON" "HDR_LIGHT_PREPASS_OFF" }
"!!GLES"
}

SubProgram "glesdesktop " {
Keywords { "LIGHTMAP_ON" "DIRLIGHTMAP_ON" "HDR_LIGHT_PREPASS_OFF" }
"!!GLES"
}

SubProgram "d3d11_9x " {
Keywords { "LIGHTMAP_ON" "DIRLIGHTMAP_ON" "HDR_LIGHT_PREPASS_OFF" }
ConstBuffer "$Globals" 160 // 148 used size, 10 vars
Vector 48 [_Color] 4
Float 144 [_Cutoff]
BindCB "$Globals" 0
SetTexture 0 [_BumpMap] 2D 1
SetTexture 1 [_MainTex] 2D 0
SetTexture 2 [_Shade] 2D 2
SetTexture 3 [_LightBuffer] 2D 3
SetTexture 4 [unity_Lightmap] 2D 4
SetTexture 5 [unity_LightmapInd] 2D 5
// 34 instructions, 6 temp regs, 0 temp arrays:
// ALU 19 float, 0 int, 0 uint
// TEX 6 (0 load, 0 comp, 0 bias, 0 grad)
// FLOW 1 static, 0 dynamic
"ps_4_0_level_9_3
eefiecednkeodfeccdoljpmpkomkabpbbcjcljgjabaaaaaacmakaaaaaeaaaaaa
daaaaaaaneadaaaaeaajaaaapiajaaaaebgpgodjjmadaaaajmadaaaaaaacpppp
eiadaaaafeaaaaaaacaadmaaaaaafeaaaaaafeaaagaaceaaaaaafeaaabaaaaaa
aaababaaacacacaaadadadaaaeaeaeaaafafafaaaaaaadaaabaaaaaaaaaaaaaa
aaaaajaaabaaabaaaaaaaaaaabacppppfbaaaaafacaaapkaaaaaaaeaaaaaialp
aaaaiadpaaaaaadpfbaaaaafadaaapkaaaaaeaeaaaaaaaebaaaaaaaaaaaaaaaa
fbaaaaafaeaaapkaolaffbdpdkmnbddpaaaaaaaaaaaaaaaafbaaaaafafaaapka
omafnblopdaedfdpdkmnbddpaaaaaaaafbaaaaafagaaapkaolafnblopdaedflp
dkmnbddpaaaaaaaabpaaaaacaaaaaaiaaaaaaplabpaaaaacaaaaaaiaabaaahla
bpaaaaacaaaaaaiaacaaahlabpaaaaacaaaaaaiaadaaaplabpaaaaacaaaaaaia
aeaaadlabpaaaaacaaaaaajaaaaiapkabpaaaaacaaaaaajaabaiapkabpaaaaac
aaaaaajaacaiapkabpaaaaacaaaaaajaadaiapkabpaaaaacaaaaaajaaeaiapka
bpaaaaacaaaaaajaafaiapkaabaaaaacaaaaadiaaaaaoolaecaaaaadabaaapia
aaaaoelaaaaioekaecaaaaadaaaacpiaaaaaoeiaabaioekaacaaaaadacaacpia
abaappiaabaaaakbecaaaaadadaacpiaaeaaoelaaeaioekaebaaaaabacaaapia
afaaaaadadaaciiaadaappiaadaaffkaafaaaaadacaachiaadaaoeiaadaappia
aeaaaaaeaaaacdiaaaaaohiaacaaaakaacaaffkaaeaaaaaeaaaaciiaaaaaaaia
aaaaaaibacaakkkaaeaaaaaeaaaaciiaaaaaffiaaaaaffibaaaappiaahaaaaac
aaaaciiaaaaappiaagaaaaacaaaaceiaaaaappiaagaaaaacaaaaaiiaadaappla
afaaaaadadaaadiaaaaappiaadaaoelaecaaaaadaeaacpiaaeaaoelaafaioeka
ecaaaaadadaacpiaadaaoeiaadaioekaafaaaaadaaaaciiaaeaappiaadaaffka
afaaaaadaeaachiaaeaaoeiaaaaappiafkaaaaaeafaadbiaaeaaoekaaaaaoiia
aeaakkkaaiaaaaadafaadciaafaaoekaaaaaoeiaaiaaaaadafaadeiaagaaoeka
aaaaoeiaaiaaaaadaaaaciiaafaaoeiaaeaaoeiaapaaaaacaeaacbiaadaaaaia
apaaaaacaeaacciaadaaffiaapaaaaacaeaaceiaadaakkiaaeaaaaaeacaachia
acaaoeiaaaaappiaaeaaoeibaiaaaaadadaacbiaabaaoelaaaaaoeiaaiaaaaad
adaacciaacaaoelaaaaaoeiaaeaaaaaeaaaacdiaadaaoeiaacaappkaacaappka
ecaaaaadaaaaapiaaaaaoeiaacaioekaafaaaaadaaaaahiaabaaoeiaaaaaoeia
afaaaaadaaaaahiaaaaaoeiaaaaaoekaafaaaaadaaaachiaaaaaoeiaadaaaaka
afaaaaadadaachiaabaaoeiaaaaappkaaeaaaaaeabaachiaadaaoeiaacaaoeia
aaaaoeiaabaaaaacaaaicpiaabaaoeiappppaaaafdeieefcgeafaaaaeaaaaaaa
fjabaaaafjaaaaaeegiocaaaaaaaaaaaakaaaaaafkaaaaadaagabaaaaaaaaaaa
fkaaaaadaagabaaaabaaaaaafkaaaaadaagabaaaacaaaaaafkaaaaadaagabaaa
adaaaaaafkaaaaadaagabaaaaeaaaaaafkaaaaadaagabaaaafaaaaaafibiaaae
aahabaaaaaaaaaaaffffaaaafibiaaaeaahabaaaabaaaaaaffffaaaafibiaaae
aahabaaaacaaaaaaffffaaaafibiaaaeaahabaaaadaaaaaaffffaaaafibiaaae
aahabaaaaeaaaaaaffffaaaafibiaaaeaahabaaaafaaaaaaffffaaaagcbaaaad
pcbabaaaabaaaaaagcbaaaadhcbabaaaacaaaaaagcbaaaadhcbabaaaadaaaaaa
gcbaaaadlcbabaaaaeaaaaaagcbaaaaddcbabaaaafaaaaaagfaaaaadpccabaaa
aaaaaaaagiaaaaacagaaaaaaefaaaaajpcaabaaaaaaaaaaaegbabaaaabaaaaaa
eghobaaaabaaaaaaaagabaaaaaaaaaaaaaaaaaajbcaabaaaabaaaaaadkaabaaa
aaaaaaaaakiacaiaebaaaaaaaaaaaaaaajaaaaaadbaaaaahbcaabaaaabaaaaaa
akaabaaaabaaaaaaabeaaaaaaaaaaaaaanaaaeadakaabaaaabaaaaaaaoaaaaah
dcaabaaaabaaaaaaegbabaaaaeaaaaaapgbpbaaaaeaaaaaaefaaaaajpcaabaaa
abaaaaaaegaabaaaabaaaaaaeghobaaaadaaaaaaaagabaaaadaaaaaacpaaaaaf
hcaabaaaabaaaaaaegacbaaaabaaaaaaefaaaaajpcaabaaaacaaaaaaegbabaaa
afaaaaaaeghobaaaaeaaaaaaaagabaaaaeaaaaaadiaaaaahicaabaaaabaaaaaa
dkaabaaaacaaaaaaabeaaaaaaaaaaaebdiaaaaahhcaabaaaacaaaaaaegacbaaa
acaaaaaapgapbaaaabaaaaaaefaaaaajpcaabaaaadaaaaaaegbabaaaafaaaaaa
eghobaaaafaaaaaaaagabaaaafaaaaaadiaaaaahicaabaaaabaaaaaadkaabaaa
adaaaaaaabeaaaaaaaaaaaebdiaaaaahhcaabaaaadaaaaaaegacbaaaadaaaaaa
pgapbaaaabaaaaaaefaaaaajpcaabaaaaeaaaaaaogbkbaaaabaaaaaaeghobaaa
aaaaaaaaaagabaaaabaaaaaadcaaaaapdcaabaaaaeaaaaaahgapbaaaaeaaaaaa
aceaaaaaaaaaaaeaaaaaaaeaaaaaaaaaaaaaaaaaaceaaaaaaaaaialpaaaaialp
aaaaaaaaaaaaaaaadcaaaaakicaabaaaabaaaaaaakaabaiaebaaaaaaaeaaaaaa
akaabaaaaeaaaaaaabeaaaaaaaaaiadpdcaaaaakicaabaaaabaaaaaabkaabaia
ebaaaaaaaeaaaaaabkaabaaaaeaaaaaadkaabaaaabaaaaaaelaaaaafecaabaaa
aeaaaaaadkaabaaaabaaaaaaapcaaaakbcaabaaaafaaaaaaaceaaaaaolaffbdp
dkmnbddpaaaaaaaaaaaaaaaaigaabaaaaeaaaaaabacaaaakccaabaaaafaaaaaa
aceaaaaaomafnblopdaedfdpdkmnbddpaaaaaaaaegacbaaaaeaaaaaabacaaaak
ecaabaaaafaaaaaaaceaaaaaolafnblopdaedflpdkmnbddpaaaaaaaaegacbaaa
aeaaaaaabaaaaaahicaabaaaabaaaaaaegacbaaaafaaaaaaegacbaaaadaaaaaa
dcaaaaakhcaabaaaabaaaaaaegacbaaaacaaaaaapgapbaaaabaaaaaaegacbaia
ebaaaaaaabaaaaaabaaaaaahbcaabaaaacaaaaaaegbcbaaaacaaaaaaegacbaaa
aeaaaaaabaaaaaahccaabaaaacaaaaaaegbcbaaaadaaaaaaegacbaaaaeaaaaaa
dcaaaaapdcaabaaaacaaaaaaegaabaaaacaaaaaaaceaaaaaaaaaaadpaaaaaadp
aaaaaaaaaaaaaaaaaceaaaaaaaaaaadpaaaaaadpaaaaaaaaaaaaaaaaefaaaaaj
pcaabaaaacaaaaaaegaabaaaacaaaaaaeghobaaaacaaaaaaaagabaaaacaaaaaa
diaaaaahhcaabaaaacaaaaaaegacbaaaaaaaaaaaegacbaaaacaaaaaadiaaaaai
hcaabaaaacaaaaaaegacbaaaacaaaaaaegiccaaaaaaaaaaaadaaaaaadiaaaaak
hcaabaaaacaaaaaaegacbaaaacaaaaaaaceaaaaaaaaaeaeaaaaaeaeaaaaaeaea
aaaaaaaadiaaaaaihcaabaaaaaaaaaaaegacbaaaaaaaaaaapgipcaaaaaaaaaaa
adaaaaaadgaaaaaficcabaaaaaaaaaaadkaabaaaaaaaaaaadcaaaaajhccabaaa
aaaaaaaaegacbaaaaaaaaaaaegacbaaaabaaaaaaegacbaaaacaaaaaadoaaaaab
ejfdeheolaaaaaaaagaaaaaaaiaaaaaajiaaaaaaaaaaaaaaabaaaaaaadaaaaaa
aaaaaaaaapaaaaaakeaaaaaaaaaaaaaaaaaaaaaaadaaaaaaabaaaaaaapapaaaa
keaaaaaaabaaaaaaaaaaaaaaadaaaaaaacaaaaaaahahaaaakeaaaaaaacaaaaaa
aaaaaaaaadaaaaaaadaaaaaaahahaaaakeaaaaaaadaaaaaaaaaaaaaaadaaaaaa
aeaaaaaaapalaaaakeaaaaaaaeaaaaaaaaaaaaaaadaaaaaaafaaaaaaadadaaaa
fdfgfpfaepfdejfeejepeoaafeeffiedepepfceeaaklklklepfdeheocmaaaaaa
abaaaaaaaiaaaaaacaaaaaaaaaaaaaaaaaaaaaaaadaaaaaaaaaaaaaaapaaaaaa
fdfgfpfegbhcghgfheaaklkl"
}

SubProgram "opengl " {
Keywords { "LIGHTMAP_OFF" "DIRLIGHTMAP_OFF" "HDR_LIGHT_PREPASS_ON" }
Vector 0 [_Color]
Float 1 [_Cutoff]
SetTexture 0 [_BumpMap] 2D
SetTexture 1 [_MainTex] 2D
SetTexture 2 [_Shade] 2D
SetTexture 3 [_LightBuffer] 2D
"!!ARBfp1.0
OPTION ARB_precision_hint_fastest;
# 22 ALU, 4 TEX
PARAM c[3] = { program.local[0..1],
		{ 2, 1, 0.5, 3 } };
TEMP R0;
TEMP R1;
TEMP R2;
TEX R0, fragment.texcoord[0], texture[1], 2D;
TEX R1.yw, fragment.texcoord[0].zwzw, texture[0], 2D;
MAD R1.xy, R1.wyzw, c[2].x, -c[2].y;
MUL R1.z, R1.y, R1.y;
MAD R1.z, -R1.x, R1.x, -R1;
SLT R2.x, R0.w, c[1];
ADD R1.z, R1, c[2].y;
RSQ R1.z, R1.z;
RCP R1.z, R1.z;
DP3 R1.w, R1, fragment.texcoord[2];
DP3 R1.z, fragment.texcoord[1], R1;
MAD R1.xy, R1.zwzw, c[2].z, c[2].z;
MOV result.color.w, R0;
KIL -R2.x;
TEX R2.xyz, R1, texture[2], 2D;
TXP R1.xyz, fragment.texcoord[3], texture[3], 2D;
MUL R2.xyz, R0, R2;
MUL R2.xyz, R2, c[0];
MUL R2.xyz, R2, c[2].w;
MUL R0.xyz, R0, c[0].w;
ADD R1.xyz, R1, fragment.texcoord[4];
MAD result.color.xyz, R0, R1, R2;
END
# 22 instructions, 3 R-regs
"
}

SubProgram "d3d9 " {
Keywords { "LIGHTMAP_OFF" "DIRLIGHTMAP_OFF" "HDR_LIGHT_PREPASS_ON" }
Vector 0 [_Color]
Float 1 [_Cutoff]
SetTexture 0 [_BumpMap] 2D
SetTexture 1 [_MainTex] 2D
SetTexture 2 [_Shade] 2D
SetTexture 3 [_LightBuffer] 2D
"ps_2_0
; 23 ALU, 5 TEX
dcl_2d s0
dcl_2d s1
dcl_2d s2
dcl_2d s3
def c2, 0.00000000, 1.00000000, 2.00000000, -1.00000000
def c3, 0.50000000, 3.00000000, 0, 0
dcl t0
dcl t1.xyz
dcl t2.xyz
dcl t3
dcl t4.xyz
texld r1, t0, s1
mov r0.y, t0.w
mov r0.x, t0.z
texld r0, r0, s0
mov r0.x, r0.w
mad_pp r2.xy, r0, c2.z, c2.w
mul_pp r0.x, r2.y, r2.y
mad_pp r0.x, -r2, r2, -r0
add_pp r0.x, r0, c2.y
rsq_pp r0.x, r0.x
rcp_pp r2.z, r0.x
add_pp r0.x, r1.w, -c1
dp3 r3.x, t1, r2
dp3 r3.y, r2, t2
cmp r0.x, r0, c2, c2.y
mov_pp r2, -r0.x
mad_pp r3.xy, r3, c3.x, c3.x
texld r0, r3, s2
texkill r2.xyzw
texldp r2, t3, s3
mul r0.xyz, r1, r0
mul r0.xyz, r0, c0
mul r0.xyz, r0, c3.y
mov_pp r0.w, r1
mul r1.xyz, r1, c0.w
add_pp r2.xyz, r2, t4
mad_pp r0.xyz, r1, r2, r0
mov_pp oC0, r0
"
}

SubProgram "d3d11 " {
Keywords { "LIGHTMAP_OFF" "DIRLIGHTMAP_OFF" "HDR_LIGHT_PREPASS_ON" }
ConstBuffer "$Globals" 128 // 116 used size, 8 vars
Vector 48 [_Color] 4
Float 112 [_Cutoff]
BindCB "$Globals" 0
SetTexture 0 [_BumpMap] 2D 1
SetTexture 1 [_MainTex] 2D 0
SetTexture 2 [_Shade] 2D 2
SetTexture 3 [_LightBuffer] 2D 3
// 23 instructions, 3 temp regs, 0 temp arrays:
// ALU 11 float, 0 int, 0 uint
// TEX 4 (0 load, 0 comp, 0 bias, 0 grad)
// FLOW 1 static, 0 dynamic
"ps_4_0
eefiecedkfmkdnpbdljjcpkhndnbikellcdbccbmabaaaaaaoaaeaaaaadaaaaaa
cmaaaaaaoeaaaaaabiabaaaaejfdeheolaaaaaaaagaaaaaaaiaaaaaajiaaaaaa
aaaaaaaaabaaaaaaadaaaaaaaaaaaaaaapaaaaaakeaaaaaaaaaaaaaaaaaaaaaa
adaaaaaaabaaaaaaapapaaaakeaaaaaaabaaaaaaaaaaaaaaadaaaaaaacaaaaaa
ahahaaaakeaaaaaaacaaaaaaaaaaaaaaadaaaaaaadaaaaaaahahaaaakeaaaaaa
adaaaaaaaaaaaaaaadaaaaaaaeaaaaaaapalaaaakeaaaaaaaeaaaaaaaaaaaaaa
adaaaaaaafaaaaaaahahaaaafdfgfpfaepfdejfeejepeoaafeeffiedepepfcee
aaklklklepfdeheocmaaaaaaabaaaaaaaiaaaaaacaaaaaaaaaaaaaaaaaaaaaaa
adaaaaaaaaaaaaaaapaaaaaafdfgfpfegbhcghgfheaaklklfdeieefcmaadaaaa
eaaaaaaapaaaaaaafjaaaaaeegiocaaaaaaaaaaaaiaaaaaafkaaaaadaagabaaa
aaaaaaaafkaaaaadaagabaaaabaaaaaafkaaaaadaagabaaaacaaaaaafkaaaaad
aagabaaaadaaaaaafibiaaaeaahabaaaaaaaaaaaffffaaaafibiaaaeaahabaaa
abaaaaaaffffaaaafibiaaaeaahabaaaacaaaaaaffffaaaafibiaaaeaahabaaa
adaaaaaaffffaaaagcbaaaadpcbabaaaabaaaaaagcbaaaadhcbabaaaacaaaaaa
gcbaaaadhcbabaaaadaaaaaagcbaaaadlcbabaaaaeaaaaaagcbaaaadhcbabaaa
afaaaaaagfaaaaadpccabaaaaaaaaaaagiaaaaacadaaaaaaefaaaaajpcaabaaa
aaaaaaaaegbabaaaabaaaaaaeghobaaaabaaaaaaaagabaaaaaaaaaaaaaaaaaaj
bcaabaaaabaaaaaadkaabaaaaaaaaaaaakiacaiaebaaaaaaaaaaaaaaahaaaaaa
dbaaaaahbcaabaaaabaaaaaaakaabaaaabaaaaaaabeaaaaaaaaaaaaaanaaaead
akaabaaaabaaaaaaefaaaaajpcaabaaaabaaaaaaogbkbaaaabaaaaaaeghobaaa
aaaaaaaaaagabaaaabaaaaaadcaaaaapdcaabaaaabaaaaaahgapbaaaabaaaaaa
aceaaaaaaaaaaaeaaaaaaaeaaaaaaaaaaaaaaaaaaceaaaaaaaaaialpaaaaialp
aaaaaaaaaaaaaaaadcaaaaakicaabaaaabaaaaaaakaabaiaebaaaaaaabaaaaaa
akaabaaaabaaaaaaabeaaaaaaaaaiadpdcaaaaakicaabaaaabaaaaaabkaabaia
ebaaaaaaabaaaaaabkaabaaaabaaaaaadkaabaaaabaaaaaaelaaaaafecaabaaa
abaaaaaadkaabaaaabaaaaaabaaaaaahbcaabaaaacaaaaaaegbcbaaaacaaaaaa
egacbaaaabaaaaaabaaaaaahccaabaaaacaaaaaaegbcbaaaadaaaaaaegacbaaa
abaaaaaadcaaaaapdcaabaaaabaaaaaaegaabaaaacaaaaaaaceaaaaaaaaaaadp
aaaaaadpaaaaaaaaaaaaaaaaaceaaaaaaaaaaadpaaaaaadpaaaaaaaaaaaaaaaa
efaaaaajpcaabaaaabaaaaaaegaabaaaabaaaaaaeghobaaaacaaaaaaaagabaaa
acaaaaaadiaaaaahhcaabaaaabaaaaaaegacbaaaaaaaaaaaegacbaaaabaaaaaa
diaaaaaihcaabaaaabaaaaaaegacbaaaabaaaaaaegiccaaaaaaaaaaaadaaaaaa
diaaaaakhcaabaaaabaaaaaaegacbaaaabaaaaaaaceaaaaaaaaaeaeaaaaaeaea
aaaaeaeaaaaaaaaaaoaaaaahdcaabaaaacaaaaaaegbabaaaaeaaaaaapgbpbaaa
aeaaaaaaefaaaaajpcaabaaaacaaaaaaegaabaaaacaaaaaaeghobaaaadaaaaaa
aagabaaaadaaaaaaaaaaaaahhcaabaaaacaaaaaaegacbaaaacaaaaaaegbcbaaa
afaaaaaadiaaaaaihcaabaaaaaaaaaaaegacbaaaaaaaaaaapgipcaaaaaaaaaaa
adaaaaaadgaaaaaficcabaaaaaaaaaaadkaabaaaaaaaaaaadcaaaaajhccabaaa
aaaaaaaaegacbaaaaaaaaaaaegacbaaaacaaaaaaegacbaaaabaaaaaadoaaaaab
"
}

SubProgram "gles " {
Keywords { "LIGHTMAP_OFF" "DIRLIGHTMAP_OFF" "HDR_LIGHT_PREPASS_ON" }
"!!GLES"
}

SubProgram "glesdesktop " {
Keywords { "LIGHTMAP_OFF" "DIRLIGHTMAP_OFF" "HDR_LIGHT_PREPASS_ON" }
"!!GLES"
}

SubProgram "d3d11_9x " {
Keywords { "LIGHTMAP_OFF" "DIRLIGHTMAP_OFF" "HDR_LIGHT_PREPASS_ON" }
ConstBuffer "$Globals" 128 // 116 used size, 8 vars
Vector 48 [_Color] 4
Float 112 [_Cutoff]
BindCB "$Globals" 0
SetTexture 0 [_BumpMap] 2D 1
SetTexture 1 [_MainTex] 2D 0
SetTexture 2 [_Shade] 2D 2
SetTexture 3 [_LightBuffer] 2D 3
// 23 instructions, 3 temp regs, 0 temp arrays:
// ALU 11 float, 0 int, 0 uint
// TEX 4 (0 load, 0 comp, 0 bias, 0 grad)
// FLOW 1 static, 0 dynamic
"ps_4_0_level_9_3
eefieceddlheeleanfhpinhfaialechnbgnilgmgabaaaaaafeahaaaaaeaaaaaa
daaaaaaakaacaaaagiagaaaacaahaaaaebgpgodjgiacaaaagiacaaaaaaacpppp
bmacaaaaemaaaaaaacaadeaaaaaaemaaaaaaemaaaeaaceaaaaaaemaaabaaaaaa
aaababaaacacacaaadadadaaaaaaadaaabaaaaaaaaaaaaaaaaaaahaaabaaabaa
aaaaaaaaabacppppfbaaaaafacaaapkaaaaaaaeaaaaaialpaaaaiadpaaaaaadp
fbaaaaafadaaapkaaaaaeaeaaaaaaaaaaaaaaaaaaaaaaaaabpaaaaacaaaaaaia
aaaaaplabpaaaaacaaaaaaiaabaaahlabpaaaaacaaaaaaiaacaaahlabpaaaaac
aaaaaaiaadaaaplabpaaaaacaaaaaaiaaeaaahlabpaaaaacaaaaaajaaaaiapka
bpaaaaacaaaaaajaabaiapkabpaaaaacaaaaaajaacaiapkabpaaaaacaaaaaaja
adaiapkaabaaaaacaaaaadiaaaaaoolaecaaaaadabaaapiaaaaaoelaaaaioeka
ecaaaaadaaaacpiaaaaaoeiaabaioekaacaaaaadacaacpiaabaappiaabaaaakb
aeaaaaaeaaaacdiaaaaaohiaacaaaakaacaaffkaaeaaaaaeaaaaciiaaaaaaaia
aaaaaaibacaakkkaaeaaaaaeaaaaciiaaaaaffiaaaaaffibaaaappiaahaaaaac
aaaaciiaaaaappiaagaaaaacaaaaceiaaaaappiaaiaaaaadadaacbiaabaaoela
aaaaoeiaaiaaaaadadaacciaacaaoelaaaaaoeiaaeaaaaaeaaaacdiaadaaoeia
acaappkaacaappkaebaaaaabacaaapiaecaaaaadaaaaapiaaaaaoeiaacaioeka
afaaaaadaaaaahiaabaaoeiaaaaaoeiaafaaaaadaaaaahiaaaaaoeiaaaaaoeka
afaaaaadaaaachiaaaaaoeiaadaaaakaagaaaaacaaaaaiiaadaapplaafaaaaad
acaaadiaaaaappiaadaaoelaecaaaaadacaacpiaacaaoeiaadaioekaacaaaaad
acaachiaacaaoeiaaeaaoelaafaaaaadadaachiaabaaoeiaaaaappkaaeaaaaae
abaachiaadaaoeiaacaaoeiaaaaaoeiaabaaaaacaaaicpiaabaaoeiappppaaaa
fdeieefcmaadaaaaeaaaaaaapaaaaaaafjaaaaaeegiocaaaaaaaaaaaaiaaaaaa
fkaaaaadaagabaaaaaaaaaaafkaaaaadaagabaaaabaaaaaafkaaaaadaagabaaa
acaaaaaafkaaaaadaagabaaaadaaaaaafibiaaaeaahabaaaaaaaaaaaffffaaaa
fibiaaaeaahabaaaabaaaaaaffffaaaafibiaaaeaahabaaaacaaaaaaffffaaaa
fibiaaaeaahabaaaadaaaaaaffffaaaagcbaaaadpcbabaaaabaaaaaagcbaaaad
hcbabaaaacaaaaaagcbaaaadhcbabaaaadaaaaaagcbaaaadlcbabaaaaeaaaaaa
gcbaaaadhcbabaaaafaaaaaagfaaaaadpccabaaaaaaaaaaagiaaaaacadaaaaaa
efaaaaajpcaabaaaaaaaaaaaegbabaaaabaaaaaaeghobaaaabaaaaaaaagabaaa
aaaaaaaaaaaaaaajbcaabaaaabaaaaaadkaabaaaaaaaaaaaakiacaiaebaaaaaa
aaaaaaaaahaaaaaadbaaaaahbcaabaaaabaaaaaaakaabaaaabaaaaaaabeaaaaa
aaaaaaaaanaaaeadakaabaaaabaaaaaaefaaaaajpcaabaaaabaaaaaaogbkbaaa
abaaaaaaeghobaaaaaaaaaaaaagabaaaabaaaaaadcaaaaapdcaabaaaabaaaaaa
hgapbaaaabaaaaaaaceaaaaaaaaaaaeaaaaaaaeaaaaaaaaaaaaaaaaaaceaaaaa
aaaaialpaaaaialpaaaaaaaaaaaaaaaadcaaaaakicaabaaaabaaaaaaakaabaia
ebaaaaaaabaaaaaaakaabaaaabaaaaaaabeaaaaaaaaaiadpdcaaaaakicaabaaa
abaaaaaabkaabaiaebaaaaaaabaaaaaabkaabaaaabaaaaaadkaabaaaabaaaaaa
elaaaaafecaabaaaabaaaaaadkaabaaaabaaaaaabaaaaaahbcaabaaaacaaaaaa
egbcbaaaacaaaaaaegacbaaaabaaaaaabaaaaaahccaabaaaacaaaaaaegbcbaaa
adaaaaaaegacbaaaabaaaaaadcaaaaapdcaabaaaabaaaaaaegaabaaaacaaaaaa
aceaaaaaaaaaaadpaaaaaadpaaaaaaaaaaaaaaaaaceaaaaaaaaaaadpaaaaaadp
aaaaaaaaaaaaaaaaefaaaaajpcaabaaaabaaaaaaegaabaaaabaaaaaaeghobaaa
acaaaaaaaagabaaaacaaaaaadiaaaaahhcaabaaaabaaaaaaegacbaaaaaaaaaaa
egacbaaaabaaaaaadiaaaaaihcaabaaaabaaaaaaegacbaaaabaaaaaaegiccaaa
aaaaaaaaadaaaaaadiaaaaakhcaabaaaabaaaaaaegacbaaaabaaaaaaaceaaaaa
aaaaeaeaaaaaeaeaaaaaeaeaaaaaaaaaaoaaaaahdcaabaaaacaaaaaaegbabaaa
aeaaaaaapgbpbaaaaeaaaaaaefaaaaajpcaabaaaacaaaaaaegaabaaaacaaaaaa
eghobaaaadaaaaaaaagabaaaadaaaaaaaaaaaaahhcaabaaaacaaaaaaegacbaaa
acaaaaaaegbcbaaaafaaaaaadiaaaaaihcaabaaaaaaaaaaaegacbaaaaaaaaaaa
pgipcaaaaaaaaaaaadaaaaaadgaaaaaficcabaaaaaaaaaaadkaabaaaaaaaaaaa
dcaaaaajhccabaaaaaaaaaaaegacbaaaaaaaaaaaegacbaaaacaaaaaaegacbaaa
abaaaaaadoaaaaabejfdeheolaaaaaaaagaaaaaaaiaaaaaajiaaaaaaaaaaaaaa
abaaaaaaadaaaaaaaaaaaaaaapaaaaaakeaaaaaaaaaaaaaaaaaaaaaaadaaaaaa
abaaaaaaapapaaaakeaaaaaaabaaaaaaaaaaaaaaadaaaaaaacaaaaaaahahaaaa
keaaaaaaacaaaaaaaaaaaaaaadaaaaaaadaaaaaaahahaaaakeaaaaaaadaaaaaa
aaaaaaaaadaaaaaaaeaaaaaaapalaaaakeaaaaaaaeaaaaaaaaaaaaaaadaaaaaa
afaaaaaaahahaaaafdfgfpfaepfdejfeejepeoaafeeffiedepepfceeaaklklkl
epfdeheocmaaaaaaabaaaaaaaiaaaaaacaaaaaaaaaaaaaaaaaaaaaaaadaaaaaa
aaaaaaaaapaaaaaafdfgfpfegbhcghgfheaaklkl"
}

SubProgram "opengl " {
Keywords { "LIGHTMAP_ON" "DIRLIGHTMAP_OFF" "HDR_LIGHT_PREPASS_ON" }
Vector 0 [_Color]
Vector 1 [unity_LightmapFade]
Float 2 [_Cutoff]
SetTexture 0 [_BumpMap] 2D
SetTexture 1 [_MainTex] 2D
SetTexture 2 [_Shade] 2D
SetTexture 3 [_LightBuffer] 2D
SetTexture 4 [unity_Lightmap] 2D
SetTexture 5 [unity_LightmapInd] 2D
"!!ARBfp1.0
OPTION ARB_precision_hint_fastest;
# 33 ALU, 6 TEX
PARAM c[5] = { program.local[0..2],
		{ 8, 2, 1, 0.5 },
		{ 3 } };
TEMP R0;
TEMP R1;
TEMP R2;
TEMP R3;
TEMP R4;
TEX R0, fragment.texcoord[0], texture[1], 2D;
TEX R1.yw, fragment.texcoord[0].zwzw, texture[0], 2D;
MAD R1.xy, R1.wyzw, c[3].y, -c[3].z;
MUL R1.z, R1.y, R1.y;
MAD R1.z, -R1.x, R1.x, -R1;
SLT R2.x, R0.w, c[2];
ADD R1.z, R1, c[3];
RSQ R1.z, R1.z;
RCP R1.z, R1.z;
DP3 R1.w, R1, fragment.texcoord[2];
DP3 R1.z, fragment.texcoord[1], R1;
MAD R3.xy, R1.zwzw, c[3].w, c[3].w;
MOV result.color.w, R0;
TEX R4.xyz, R3, texture[2], 2D;
TEX R1, fragment.texcoord[4], texture[4], 2D;
KIL -R2.x;
TEX R2, fragment.texcoord[4], texture[5], 2D;
TXP R3.xyz, fragment.texcoord[3], texture[3], 2D;
MUL R4.xyz, R0, R4;
MUL R1.xyz, R1.w, R1;
DP4 R1.w, fragment.texcoord[5], fragment.texcoord[5];
MUL R2.xyz, R2.w, R2;
MUL R2.xyz, R2, c[3].x;
RSQ R1.w, R1.w;
RCP R1.w, R1.w;
MAD R1.xyz, R1, c[3].x, -R2;
MAD_SAT R1.w, R1, c[1].z, c[1];
MAD R1.xyz, R1.w, R1, R2;
MUL R2.xyz, R4, c[0];
ADD R1.xyz, R3, R1;
MUL R2.xyz, R2, c[4].x;
MUL R0.xyz, R0, c[0].w;
MAD result.color.xyz, R0, R1, R2;
END
# 33 instructions, 5 R-regs
"
}

SubProgram "d3d9 " {
Keywords { "LIGHTMAP_ON" "DIRLIGHTMAP_OFF" "HDR_LIGHT_PREPASS_ON" }
Vector 0 [_Color]
Vector 1 [unity_LightmapFade]
Float 2 [_Cutoff]
SetTexture 0 [_BumpMap] 2D
SetTexture 1 [_MainTex] 2D
SetTexture 2 [_Shade] 2D
SetTexture 3 [_LightBuffer] 2D
SetTexture 4 [unity_Lightmap] 2D
SetTexture 5 [unity_LightmapInd] 2D
"ps_2_0
; 32 ALU, 7 TEX
dcl_2d s0
dcl_2d s1
dcl_2d s2
dcl_2d s3
dcl_2d s4
dcl_2d s5
def c3, 0.00000000, 1.00000000, 8.00000000, 0.50000000
def c4, 2.00000000, -1.00000000, 3.00000000, 0
dcl t0
dcl t1.xyz
dcl t2.xyz
dcl t3
dcl t4.xy
dcl t5
texld r1, t0, s1
mov r0.y, t0.w
mov r0.x, t0.z
texld r0, r0, s0
mov r0.x, r0.w
mad_pp r2.xy, r0, c4.x, c4.y
mul_pp r0.x, r2.y, r2.y
mad_pp r0.x, -r2, r2, -r0
add_pp r0.x, r0, c3.y
rsq_pp r0.x, r0.x
rcp_pp r2.z, r0.x
add_pp r0.x, r1.w, -c2
cmp r0.x, r0, c3, c3.y
mov_pp r0, -r0.x
dp3 r3.x, t1, r2
dp3 r3.y, r2, t2
mad_pp r2.xy, r3, c3.w, c3.w
texld r4, r2, s2
texkill r0.xyzw
texldp r2, t3, s3
texld r3, t4, s5
texld r0, t4, s4
mul_pp r5.xyz, r0.w, r0
mul r4.xyz, r1, r4
dp4 r0.x, t5, t5
mul_pp r3.xyz, r3.w, r3
mul_pp r3.xyz, r3, c3.z
rsq r0.x, r0.x
rcp r0.x, r0.x
mul r4.xyz, r4, c0
mad_pp r5.xyz, r5, c3.z, -r3
mad_sat r0.x, r0, c1.z, c1.w
mad_pp r0.xyz, r0.x, r5, r3
add_pp r0.xyz, r2, r0
mul r2.xyz, r4, c4.z
mul r1.xyz, r1, c0.w
mov_pp r0.w, r1
mad_pp r0.xyz, r1, r0, r2
mov_pp oC0, r0
"
}

SubProgram "d3d11 " {
Keywords { "LIGHTMAP_ON" "DIRLIGHTMAP_OFF" "HDR_LIGHT_PREPASS_ON" }
ConstBuffer "$Globals" 160 // 148 used size, 10 vars
Vector 48 [_Color] 4
Vector 112 [unity_LightmapFade] 4
Float 144 [_Cutoff]
BindCB "$Globals" 0
SetTexture 0 [_BumpMap] 2D 1
SetTexture 1 [_MainTex] 2D 0
SetTexture 2 [_Shade] 2D 2
SetTexture 3 [_LightBuffer] 2D 3
SetTexture 4 [unity_Lightmap] 2D 4
SetTexture 5 [unity_LightmapInd] 2D 5
// 33 instructions, 4 temp regs, 0 temp arrays:
// ALU 16 float, 0 int, 0 uint
// TEX 6 (0 load, 0 comp, 0 bias, 0 grad)
// FLOW 1 static, 0 dynamic
"ps_4_0
eefiecedcnadcekfgoolkeigkjhhegghlkmidoepabaaaaaaiaagaaaaadaaaaaa
cmaaaaaapmaaaaaadaabaaaaejfdeheomiaaaaaaahaaaaaaaiaaaaaalaaaaaaa
aaaaaaaaabaaaaaaadaaaaaaaaaaaaaaapaaaaaalmaaaaaaaaaaaaaaaaaaaaaa
adaaaaaaabaaaaaaapapaaaalmaaaaaaabaaaaaaaaaaaaaaadaaaaaaacaaaaaa
ahahaaaalmaaaaaaacaaaaaaaaaaaaaaadaaaaaaadaaaaaaahahaaaalmaaaaaa
adaaaaaaaaaaaaaaadaaaaaaaeaaaaaaapalaaaalmaaaaaaaeaaaaaaaaaaaaaa
adaaaaaaafaaaaaaadadaaaalmaaaaaaafaaaaaaaaaaaaaaadaaaaaaagaaaaaa
apapaaaafdfgfpfaepfdejfeejepeoaafeeffiedepepfceeaaklklklepfdeheo
cmaaaaaaabaaaaaaaiaaaaaacaaaaaaaaaaaaaaaaaaaaaaaadaaaaaaaaaaaaaa
apaaaaaafdfgfpfegbhcghgfheaaklklfdeieefceiafaaaaeaaaaaaafcabaaaa
fjaaaaaeegiocaaaaaaaaaaaakaaaaaafkaaaaadaagabaaaaaaaaaaafkaaaaad
aagabaaaabaaaaaafkaaaaadaagabaaaacaaaaaafkaaaaadaagabaaaadaaaaaa
fkaaaaadaagabaaaaeaaaaaafkaaaaadaagabaaaafaaaaaafibiaaaeaahabaaa
aaaaaaaaffffaaaafibiaaaeaahabaaaabaaaaaaffffaaaafibiaaaeaahabaaa
acaaaaaaffffaaaafibiaaaeaahabaaaadaaaaaaffffaaaafibiaaaeaahabaaa
aeaaaaaaffffaaaafibiaaaeaahabaaaafaaaaaaffffaaaagcbaaaadpcbabaaa
abaaaaaagcbaaaadhcbabaaaacaaaaaagcbaaaadhcbabaaaadaaaaaagcbaaaad
lcbabaaaaeaaaaaagcbaaaaddcbabaaaafaaaaaagcbaaaadpcbabaaaagaaaaaa
gfaaaaadpccabaaaaaaaaaaagiaaaaacaeaaaaaaefaaaaajpcaabaaaaaaaaaaa
egbabaaaabaaaaaaeghobaaaabaaaaaaaagabaaaaaaaaaaaaaaaaaajbcaabaaa
abaaaaaadkaabaaaaaaaaaaaakiacaiaebaaaaaaaaaaaaaaajaaaaaadbaaaaah
bcaabaaaabaaaaaaakaabaaaabaaaaaaabeaaaaaaaaaaaaaanaaaeadakaabaaa
abaaaaaabbaaaaahbcaabaaaabaaaaaaegbobaaaagaaaaaaegbobaaaagaaaaaa
elaaaaafbcaabaaaabaaaaaaakaabaaaabaaaaaadccaaaalbcaabaaaabaaaaaa
akaabaaaabaaaaaackiacaaaaaaaaaaaahaaaaaadkiacaaaaaaaaaaaahaaaaaa
efaaaaajpcaabaaaacaaaaaaegbabaaaafaaaaaaeghobaaaafaaaaaaaagabaaa
afaaaaaadiaaaaahccaabaaaabaaaaaadkaabaaaacaaaaaaabeaaaaaaaaaaaeb
diaaaaahocaabaaaabaaaaaaagajbaaaacaaaaaafgafbaaaabaaaaaaefaaaaaj
pcaabaaaacaaaaaaegbabaaaafaaaaaaeghobaaaaeaaaaaaaagabaaaaeaaaaaa
diaaaaahicaabaaaacaaaaaadkaabaaaacaaaaaaabeaaaaaaaaaaaebdcaaaaak
hcaabaaaacaaaaaapgapbaaaacaaaaaaegacbaaaacaaaaaajgahbaiaebaaaaaa
abaaaaaadcaaaaajhcaabaaaabaaaaaaagaabaaaabaaaaaaegacbaaaacaaaaaa
jgahbaaaabaaaaaaaoaaaaahdcaabaaaacaaaaaaegbabaaaaeaaaaaapgbpbaaa
aeaaaaaaefaaaaajpcaabaaaacaaaaaaegaabaaaacaaaaaaeghobaaaadaaaaaa
aagabaaaadaaaaaaaaaaaaahhcaabaaaabaaaaaaegacbaaaabaaaaaaegacbaaa
acaaaaaaefaaaaajpcaabaaaacaaaaaaogbkbaaaabaaaaaaeghobaaaaaaaaaaa
aagabaaaabaaaaaadcaaaaapdcaabaaaacaaaaaahgapbaaaacaaaaaaaceaaaaa
aaaaaaeaaaaaaaeaaaaaaaaaaaaaaaaaaceaaaaaaaaaialpaaaaialpaaaaaaaa
aaaaaaaadcaaaaakicaabaaaabaaaaaaakaabaiaebaaaaaaacaaaaaaakaabaaa
acaaaaaaabeaaaaaaaaaiadpdcaaaaakicaabaaaabaaaaaabkaabaiaebaaaaaa
acaaaaaabkaabaaaacaaaaaadkaabaaaabaaaaaaelaaaaafecaabaaaacaaaaaa
dkaabaaaabaaaaaabaaaaaahbcaabaaaadaaaaaaegbcbaaaacaaaaaaegacbaaa
acaaaaaabaaaaaahccaabaaaadaaaaaaegbcbaaaadaaaaaaegacbaaaacaaaaaa
dcaaaaapdcaabaaaacaaaaaaegaabaaaadaaaaaaaceaaaaaaaaaaadpaaaaaadp
aaaaaaaaaaaaaaaaaceaaaaaaaaaaadpaaaaaadpaaaaaaaaaaaaaaaaefaaaaaj
pcaabaaaacaaaaaaegaabaaaacaaaaaaeghobaaaacaaaaaaaagabaaaacaaaaaa
diaaaaahhcaabaaaacaaaaaaegacbaaaaaaaaaaaegacbaaaacaaaaaadiaaaaai
hcaabaaaacaaaaaaegacbaaaacaaaaaaegiccaaaaaaaaaaaadaaaaaadiaaaaak
hcaabaaaacaaaaaaegacbaaaacaaaaaaaceaaaaaaaaaeaeaaaaaeaeaaaaaeaea
aaaaaaaadiaaaaaihcaabaaaaaaaaaaaegacbaaaaaaaaaaapgipcaaaaaaaaaaa
adaaaaaadgaaaaaficcabaaaaaaaaaaadkaabaaaaaaaaaaadcaaaaajhccabaaa
aaaaaaaaegacbaaaaaaaaaaaegacbaaaabaaaaaaegacbaaaacaaaaaadoaaaaab
"
}

SubProgram "gles " {
Keywords { "LIGHTMAP_ON" "DIRLIGHTMAP_OFF" "HDR_LIGHT_PREPASS_ON" }
"!!GLES"
}

SubProgram "glesdesktop " {
Keywords { "LIGHTMAP_ON" "DIRLIGHTMAP_OFF" "HDR_LIGHT_PREPASS_ON" }
"!!GLES"
}

SubProgram "d3d11_9x " {
Keywords { "LIGHTMAP_ON" "DIRLIGHTMAP_OFF" "HDR_LIGHT_PREPASS_ON" }
ConstBuffer "$Globals" 160 // 148 used size, 10 vars
Vector 48 [_Color] 4
Vector 112 [unity_LightmapFade] 4
Float 144 [_Cutoff]
BindCB "$Globals" 0
SetTexture 0 [_BumpMap] 2D 1
SetTexture 1 [_MainTex] 2D 0
SetTexture 2 [_Shade] 2D 2
SetTexture 3 [_LightBuffer] 2D 3
SetTexture 4 [unity_Lightmap] 2D 4
SetTexture 5 [unity_LightmapInd] 2D 5
// 33 instructions, 4 temp regs, 0 temp arrays:
// ALU 16 float, 0 int, 0 uint
// TEX 6 (0 load, 0 comp, 0 bias, 0 grad)
// FLOW 1 static, 0 dynamic
"ps_4_0_level_9_3
eefiecednhaoojoepglodkagiefggjphmpnkfgadabaaaaaaoaajaaaaaeaaaaaa
daaaaaaaimadaaaanmaiaaaakmajaaaaebgpgodjfeadaaaafeadaaaaaaacpppp
peacaaaagaaaaaaaadaadmaaaaaagaaaaaaagaaaagaaceaaaaaagaaaabaaaaaa
aaababaaacacacaaadadadaaaeaeaeaaafafafaaaaaaadaaabaaaaaaaaaaaaaa
aaaaahaaabaaabaaaaaaaaaaaaaaajaaabaaacaaaaaaaaaaabacppppfbaaaaaf
adaaapkaaaaaaaeaaaaaialpaaaaiadpaaaaaadpfbaaaaafaeaaapkaaaaaeaea
aaaaaaebaaaaaaaaaaaaaaaabpaaaaacaaaaaaiaaaaaaplabpaaaaacaaaaaaia
abaaahlabpaaaaacaaaaaaiaacaaahlabpaaaaacaaaaaaiaadaaaplabpaaaaac
aaaaaaiaaeaaadlabpaaaaacaaaaaaiaafaaaplabpaaaaacaaaaaajaaaaiapka
bpaaaaacaaaaaajaabaiapkabpaaaaacaaaaaajaacaiapkabpaaaaacaaaaaaja
adaiapkabpaaaaacaaaaaajaaeaiapkabpaaaaacaaaaaajaafaiapkaabaaaaac
aaaaadiaaaaaoolaecaaaaadabaaapiaaaaaoelaaaaioekaecaaaaadaaaacpia
aaaaoeiaabaioekaacaaaaadacaacpiaabaappiaacaaaakbecaaaaadadaacpia
aeaaoelaafaioekaebaaaaabacaaapiaajaaaaadaaaaabiaafaaoelaafaaoela
ahaaaaacaaaaabiaaaaaaaiaagaaaaacaaaaabiaaaaaaaiaaeaaaaaeaaaabbia
aaaaaaiaabaakkkaabaappkaafaaaaadadaaciiaadaappiaaeaaffkaafaaaaad
acaachiaadaaoeiaadaappiaagaaaaacacaaaiiaadaapplaafaaaaadadaaadia
acaappiaadaaoelaecaaaaadaeaacpiaaeaaoelaaeaioekaecaaaaadadaacpia
adaaoeiaadaioekaafaaaaadacaaciiaaeaappiaaeaaffkaaeaaaaaeaeaaahia
acaappiaaeaaoeiaacaaoeibaeaaaaaeacaachiaaaaaaaiaaeaaoeiaacaaoeia
acaaaaadacaachiaacaaoeiaadaaoeiaaeaaaaaeaaaacdiaaaaaohiaadaaaaka
adaaffkaaeaaaaaeaaaaciiaaaaaaaiaaaaaaaibadaakkkaaeaaaaaeaaaaciia
aaaaffiaaaaaffibaaaappiaahaaaaacaaaaciiaaaaappiaagaaaaacaaaaceia
aaaappiaaiaaaaadadaacbiaabaaoelaaaaaoeiaaiaaaaadadaacciaacaaoela
aaaaoeiaaeaaaaaeaaaacdiaadaaoeiaadaappkaadaappkaecaaaaadaaaaapia
aaaaoeiaacaioekaafaaaaadaaaaahiaabaaoeiaaaaaoeiaafaaaaadaaaaahia
aaaaoeiaaaaaoekaafaaaaadaaaachiaaaaaoeiaaeaaaakaafaaaaadadaachia
abaaoeiaaaaappkaaeaaaaaeabaachiaadaaoeiaacaaoeiaaaaaoeiaabaaaaac
aaaicpiaabaaoeiappppaaaafdeieefceiafaaaaeaaaaaaafcabaaaafjaaaaae
egiocaaaaaaaaaaaakaaaaaafkaaaaadaagabaaaaaaaaaaafkaaaaadaagabaaa
abaaaaaafkaaaaadaagabaaaacaaaaaafkaaaaadaagabaaaadaaaaaafkaaaaad
aagabaaaaeaaaaaafkaaaaadaagabaaaafaaaaaafibiaaaeaahabaaaaaaaaaaa
ffffaaaafibiaaaeaahabaaaabaaaaaaffffaaaafibiaaaeaahabaaaacaaaaaa
ffffaaaafibiaaaeaahabaaaadaaaaaaffffaaaafibiaaaeaahabaaaaeaaaaaa
ffffaaaafibiaaaeaahabaaaafaaaaaaffffaaaagcbaaaadpcbabaaaabaaaaaa
gcbaaaadhcbabaaaacaaaaaagcbaaaadhcbabaaaadaaaaaagcbaaaadlcbabaaa
aeaaaaaagcbaaaaddcbabaaaafaaaaaagcbaaaadpcbabaaaagaaaaaagfaaaaad
pccabaaaaaaaaaaagiaaaaacaeaaaaaaefaaaaajpcaabaaaaaaaaaaaegbabaaa
abaaaaaaeghobaaaabaaaaaaaagabaaaaaaaaaaaaaaaaaajbcaabaaaabaaaaaa
dkaabaaaaaaaaaaaakiacaiaebaaaaaaaaaaaaaaajaaaaaadbaaaaahbcaabaaa
abaaaaaaakaabaaaabaaaaaaabeaaaaaaaaaaaaaanaaaeadakaabaaaabaaaaaa
bbaaaaahbcaabaaaabaaaaaaegbobaaaagaaaaaaegbobaaaagaaaaaaelaaaaaf
bcaabaaaabaaaaaaakaabaaaabaaaaaadccaaaalbcaabaaaabaaaaaaakaabaaa
abaaaaaackiacaaaaaaaaaaaahaaaaaadkiacaaaaaaaaaaaahaaaaaaefaaaaaj
pcaabaaaacaaaaaaegbabaaaafaaaaaaeghobaaaafaaaaaaaagabaaaafaaaaaa
diaaaaahccaabaaaabaaaaaadkaabaaaacaaaaaaabeaaaaaaaaaaaebdiaaaaah
ocaabaaaabaaaaaaagajbaaaacaaaaaafgafbaaaabaaaaaaefaaaaajpcaabaaa
acaaaaaaegbabaaaafaaaaaaeghobaaaaeaaaaaaaagabaaaaeaaaaaadiaaaaah
icaabaaaacaaaaaadkaabaaaacaaaaaaabeaaaaaaaaaaaebdcaaaaakhcaabaaa
acaaaaaapgapbaaaacaaaaaaegacbaaaacaaaaaajgahbaiaebaaaaaaabaaaaaa
dcaaaaajhcaabaaaabaaaaaaagaabaaaabaaaaaaegacbaaaacaaaaaajgahbaaa
abaaaaaaaoaaaaahdcaabaaaacaaaaaaegbabaaaaeaaaaaapgbpbaaaaeaaaaaa
efaaaaajpcaabaaaacaaaaaaegaabaaaacaaaaaaeghobaaaadaaaaaaaagabaaa
adaaaaaaaaaaaaahhcaabaaaabaaaaaaegacbaaaabaaaaaaegacbaaaacaaaaaa
efaaaaajpcaabaaaacaaaaaaogbkbaaaabaaaaaaeghobaaaaaaaaaaaaagabaaa
abaaaaaadcaaaaapdcaabaaaacaaaaaahgapbaaaacaaaaaaaceaaaaaaaaaaaea
aaaaaaeaaaaaaaaaaaaaaaaaaceaaaaaaaaaialpaaaaialpaaaaaaaaaaaaaaaa
dcaaaaakicaabaaaabaaaaaaakaabaiaebaaaaaaacaaaaaaakaabaaaacaaaaaa
abeaaaaaaaaaiadpdcaaaaakicaabaaaabaaaaaabkaabaiaebaaaaaaacaaaaaa
bkaabaaaacaaaaaadkaabaaaabaaaaaaelaaaaafecaabaaaacaaaaaadkaabaaa
abaaaaaabaaaaaahbcaabaaaadaaaaaaegbcbaaaacaaaaaaegacbaaaacaaaaaa
baaaaaahccaabaaaadaaaaaaegbcbaaaadaaaaaaegacbaaaacaaaaaadcaaaaap
dcaabaaaacaaaaaaegaabaaaadaaaaaaaceaaaaaaaaaaadpaaaaaadpaaaaaaaa
aaaaaaaaaceaaaaaaaaaaadpaaaaaadpaaaaaaaaaaaaaaaaefaaaaajpcaabaaa
acaaaaaaegaabaaaacaaaaaaeghobaaaacaaaaaaaagabaaaacaaaaaadiaaaaah
hcaabaaaacaaaaaaegacbaaaaaaaaaaaegacbaaaacaaaaaadiaaaaaihcaabaaa
acaaaaaaegacbaaaacaaaaaaegiccaaaaaaaaaaaadaaaaaadiaaaaakhcaabaaa
acaaaaaaegacbaaaacaaaaaaaceaaaaaaaaaeaeaaaaaeaeaaaaaeaeaaaaaaaaa
diaaaaaihcaabaaaaaaaaaaaegacbaaaaaaaaaaapgipcaaaaaaaaaaaadaaaaaa
dgaaaaaficcabaaaaaaaaaaadkaabaaaaaaaaaaadcaaaaajhccabaaaaaaaaaaa
egacbaaaaaaaaaaaegacbaaaabaaaaaaegacbaaaacaaaaaadoaaaaabejfdeheo
miaaaaaaahaaaaaaaiaaaaaalaaaaaaaaaaaaaaaabaaaaaaadaaaaaaaaaaaaaa
apaaaaaalmaaaaaaaaaaaaaaaaaaaaaaadaaaaaaabaaaaaaapapaaaalmaaaaaa
abaaaaaaaaaaaaaaadaaaaaaacaaaaaaahahaaaalmaaaaaaacaaaaaaaaaaaaaa
adaaaaaaadaaaaaaahahaaaalmaaaaaaadaaaaaaaaaaaaaaadaaaaaaaeaaaaaa
apalaaaalmaaaaaaaeaaaaaaaaaaaaaaadaaaaaaafaaaaaaadadaaaalmaaaaaa
afaaaaaaaaaaaaaaadaaaaaaagaaaaaaapapaaaafdfgfpfaepfdejfeejepeoaa
feeffiedepepfceeaaklklklepfdeheocmaaaaaaabaaaaaaaiaaaaaacaaaaaaa
aaaaaaaaaaaaaaaaadaaaaaaaaaaaaaaapaaaaaafdfgfpfegbhcghgfheaaklkl
"
}

SubProgram "opengl " {
Keywords { "LIGHTMAP_ON" "DIRLIGHTMAP_ON" "HDR_LIGHT_PREPASS_ON" }
Vector 0 [_Color]
Float 1 [_Cutoff]
SetTexture 0 [_BumpMap] 2D
SetTexture 1 [_MainTex] 2D
SetTexture 2 [_Shade] 2D
SetTexture 3 [_LightBuffer] 2D
SetTexture 4 [unity_Lightmap] 2D
SetTexture 5 [unity_LightmapInd] 2D
"!!ARBfp1.0
OPTION ARB_precision_hint_fastest;
# 32 ALU, 6 TEX
PARAM c[6] = { program.local[0..1],
		{ 2, 1, 8, 0.5 },
		{ -0.40824828, -0.70710677, 0.57735026, 3 },
		{ -0.40824831, 0.70710677, 0.57735026 },
		{ 0.81649655, 0, 0.57735026 } };
TEMP R0;
TEMP R1;
TEMP R2;
TEMP R3;
TEMP R4;
TEMP R5;
TEMP R6;
TEX R0, fragment.texcoord[0], texture[1], 2D;
TEX R1.yw, fragment.texcoord[0].zwzw, texture[0], 2D;
TEX R2, fragment.texcoord[4], texture[5], 2D;
MAD R4.xy, R1.wyzw, c[2].x, -c[2].y;
MUL R1.x, R4.y, R4.y;
MAD R1.x, -R4, R4, -R1;
SLT R1.z, R0.w, c[1].x;
ADD R1.x, R1, c[2].y;
RSQ R1.x, R1.x;
RCP R4.z, R1.x;
DP3 R1.y, R4, fragment.texcoord[2];
DP3 R1.x, R4, fragment.texcoord[1];
MAD R3.xy, R1, c[2].w, c[2].w;
DP3_SAT R6.z, R4, c[3];
DP3_SAT R6.x, R4, c[5];
DP3_SAT R6.y, R4, c[4];
MUL R2.xyz, R2.w, R2;
MUL R2.xyz, R2, R6;
DP3 R2.x, R2, c[2].z;
MOV result.color.w, R0;
TEX R5.xyz, R3, texture[2], 2D;
KIL -R1.z;
TEX R1, fragment.texcoord[4], texture[4], 2D;
TXP R3.xyz, fragment.texcoord[3], texture[3], 2D;
MUL R5.xyz, R0, R5;
MUL R1.xyz, R1.w, R1;
MUL R1.xyz, R1, R2.x;
MUL R4.xyz, R5, c[0];
MAD R1.xyz, R1, c[2].z, R3;
MUL R2.xyz, R4, c[3].w;
MUL R0.xyz, R0, c[0].w;
MAD result.color.xyz, R0, R1, R2;
END
# 32 instructions, 7 R-regs
"
}

SubProgram "d3d9 " {
Keywords { "LIGHTMAP_ON" "DIRLIGHTMAP_ON" "HDR_LIGHT_PREPASS_ON" }
Vector 0 [_Color]
Float 1 [_Cutoff]
SetTexture 0 [_BumpMap] 2D
SetTexture 1 [_MainTex] 2D
SetTexture 2 [_Shade] 2D
SetTexture 3 [_LightBuffer] 2D
SetTexture 4 [unity_Lightmap] 2D
SetTexture 5 [unity_LightmapInd] 2D
"ps_2_0
; 31 ALU, 7 TEX
dcl_2d s0
dcl_2d s1
dcl_2d s2
dcl_2d s3
dcl_2d s4
dcl_2d s5
def c2, 0.00000000, 1.00000000, 2.00000000, -1.00000000
def c3, -0.40824828, -0.70710677, 0.57735026, 8.00000000
def c4, -0.40824831, 0.70710677, 0.57735026, 0.50000000
def c5, 0.81649655, 0.00000000, 0.57735026, 3.00000000
dcl t0
dcl t1.xyz
dcl t2.xyz
dcl t3
dcl t4.xy
texld r2, t0, s1
texldp r4, t3, s3
mov r0.y, t0.w
mov r0.x, t0.z
texld r0, r0, s0
mov r0.x, r0.w
mad_pp r5.xy, r0, c2.z, c2.w
mul_pp r0.x, r5.y, r5.y
mad_pp r0.x, -r5, r5, -r0
add_pp r0.x, r0, c2.y
rsq_pp r0.x, r0.x
rcp_pp r5.z, r0.x
add_pp r0.x, r2.w, -c1
cmp r0.x, r0, c2, c2.y
mov_pp r0, -r0.x
dp3 r1.x, r5, t1
dp3 r1.y, r5, t2
mad_pp r1.xy, r1, c4.w, c4.w
dp3_pp_sat r6.z, r5, c3
dp3_pp_sat r6.y, r5, c4
dp3_pp_sat r6.x, r5, c5
texld r3, r1, s2
texkill r0.xyzw
texld r1, t4, s4
texld r0, t4, s5
mul_pp r0.xyz, r0.w, r0
mul_pp r0.xyz, r0, r6
mul_pp r1.xyz, r1.w, r1
dp3_pp r0.x, r0, c3.w
mul_pp r0.xyz, r1, r0.x
mul r1.xyz, r2, r3
mul r1.xyz, r1, c0
mad_pp r0.xyz, r0, c3.w, r4
mul r1.xyz, r1, c5.w
mul r2.xyz, r2, c0.w
mov_pp r0.w, r2
mad_pp r0.xyz, r2, r0, r1
mov_pp oC0, r0
"
}

SubProgram "d3d11 " {
Keywords { "LIGHTMAP_ON" "DIRLIGHTMAP_ON" "HDR_LIGHT_PREPASS_ON" }
ConstBuffer "$Globals" 160 // 148 used size, 10 vars
Vector 48 [_Color] 4
Float 144 [_Cutoff]
BindCB "$Globals" 0
SetTexture 0 [_BumpMap] 2D 1
SetTexture 1 [_MainTex] 2D 0
SetTexture 2 [_Shade] 2D 2
SetTexture 3 [_LightBuffer] 2D 3
SetTexture 4 [unity_Lightmap] 2D 4
SetTexture 5 [unity_LightmapInd] 2D 5
// 33 instructions, 6 temp regs, 0 temp arrays:
// ALU 18 float, 0 int, 0 uint
// TEX 6 (0 load, 0 comp, 0 bias, 0 grad)
// FLOW 1 static, 0 dynamic
"ps_4_0
eefieceddlfdofemlfgadmbaijgobflegaekihidabaaaaaagmagaaaaadaaaaaa
cmaaaaaaoeaaaaaabiabaaaaejfdeheolaaaaaaaagaaaaaaaiaaaaaajiaaaaaa
aaaaaaaaabaaaaaaadaaaaaaaaaaaaaaapaaaaaakeaaaaaaaaaaaaaaaaaaaaaa
adaaaaaaabaaaaaaapapaaaakeaaaaaaabaaaaaaaaaaaaaaadaaaaaaacaaaaaa
ahahaaaakeaaaaaaacaaaaaaaaaaaaaaadaaaaaaadaaaaaaahahaaaakeaaaaaa
adaaaaaaaaaaaaaaadaaaaaaaeaaaaaaapalaaaakeaaaaaaaeaaaaaaaaaaaaaa
adaaaaaaafaaaaaaadadaaaafdfgfpfaepfdejfeejepeoaafeeffiedepepfcee
aaklklklepfdeheocmaaaaaaabaaaaaaaiaaaaaacaaaaaaaaaaaaaaaaaaaaaaa
adaaaaaaaaaaaaaaapaaaaaafdfgfpfegbhcghgfheaaklklfdeieefcemafaaaa
eaaaaaaafdabaaaafjaaaaaeegiocaaaaaaaaaaaakaaaaaafkaaaaadaagabaaa
aaaaaaaafkaaaaadaagabaaaabaaaaaafkaaaaadaagabaaaacaaaaaafkaaaaad
aagabaaaadaaaaaafkaaaaadaagabaaaaeaaaaaafkaaaaadaagabaaaafaaaaaa
fibiaaaeaahabaaaaaaaaaaaffffaaaafibiaaaeaahabaaaabaaaaaaffffaaaa
fibiaaaeaahabaaaacaaaaaaffffaaaafibiaaaeaahabaaaadaaaaaaffffaaaa
fibiaaaeaahabaaaaeaaaaaaffffaaaafibiaaaeaahabaaaafaaaaaaffffaaaa
gcbaaaadpcbabaaaabaaaaaagcbaaaadhcbabaaaacaaaaaagcbaaaadhcbabaaa
adaaaaaagcbaaaadlcbabaaaaeaaaaaagcbaaaaddcbabaaaafaaaaaagfaaaaad
pccabaaaaaaaaaaagiaaaaacagaaaaaaefaaaaajpcaabaaaaaaaaaaaegbabaaa
abaaaaaaeghobaaaabaaaaaaaagabaaaaaaaaaaaaaaaaaajbcaabaaaabaaaaaa
dkaabaaaaaaaaaaaakiacaiaebaaaaaaaaaaaaaaajaaaaaadbaaaaahbcaabaaa
abaaaaaaakaabaaaabaaaaaaabeaaaaaaaaaaaaaanaaaeadakaabaaaabaaaaaa
efaaaaajpcaabaaaabaaaaaaegbabaaaafaaaaaaeghobaaaaeaaaaaaaagabaaa
aeaaaaaadiaaaaahicaabaaaabaaaaaadkaabaaaabaaaaaaabeaaaaaaaaaaaeb
diaaaaahhcaabaaaabaaaaaaegacbaaaabaaaaaapgapbaaaabaaaaaaaoaaaaah
dcaabaaaacaaaaaaegbabaaaaeaaaaaapgbpbaaaaeaaaaaaefaaaaajpcaabaaa
acaaaaaaegaabaaaacaaaaaaeghobaaaadaaaaaaaagabaaaadaaaaaaefaaaaaj
pcaabaaaadaaaaaaegbabaaaafaaaaaaeghobaaaafaaaaaaaagabaaaafaaaaaa
diaaaaahicaabaaaabaaaaaadkaabaaaadaaaaaaabeaaaaaaaaaaaebdiaaaaah
hcaabaaaadaaaaaaegacbaaaadaaaaaapgapbaaaabaaaaaaefaaaaajpcaabaaa
aeaaaaaaogbkbaaaabaaaaaaeghobaaaaaaaaaaaaagabaaaabaaaaaadcaaaaap
dcaabaaaaeaaaaaahgapbaaaaeaaaaaaaceaaaaaaaaaaaeaaaaaaaeaaaaaaaaa
aaaaaaaaaceaaaaaaaaaialpaaaaialpaaaaaaaaaaaaaaaadcaaaaakicaabaaa
abaaaaaaakaabaiaebaaaaaaaeaaaaaaakaabaaaaeaaaaaaabeaaaaaaaaaiadp
dcaaaaakicaabaaaabaaaaaabkaabaiaebaaaaaaaeaaaaaabkaabaaaaeaaaaaa
dkaabaaaabaaaaaaelaaaaafecaabaaaaeaaaaaadkaabaaaabaaaaaaapcaaaak
bcaabaaaafaaaaaaaceaaaaaolaffbdpdkmnbddpaaaaaaaaaaaaaaaaigaabaaa
aeaaaaaabacaaaakccaabaaaafaaaaaaaceaaaaaomafnblopdaedfdpdkmnbddp
aaaaaaaaegacbaaaaeaaaaaabacaaaakecaabaaaafaaaaaaaceaaaaaolafnblo
pdaedflpdkmnbddpaaaaaaaaegacbaaaaeaaaaaabaaaaaahicaabaaaabaaaaaa
egacbaaaafaaaaaaegacbaaaadaaaaaadcaaaaajhcaabaaaabaaaaaaegacbaaa
abaaaaaapgapbaaaabaaaaaaegacbaaaacaaaaaabaaaaaahbcaabaaaacaaaaaa
egbcbaaaacaaaaaaegacbaaaaeaaaaaabaaaaaahccaabaaaacaaaaaaegbcbaaa
adaaaaaaegacbaaaaeaaaaaadcaaaaapdcaabaaaacaaaaaaegaabaaaacaaaaaa
aceaaaaaaaaaaadpaaaaaadpaaaaaaaaaaaaaaaaaceaaaaaaaaaaadpaaaaaadp
aaaaaaaaaaaaaaaaefaaaaajpcaabaaaacaaaaaaegaabaaaacaaaaaaeghobaaa
acaaaaaaaagabaaaacaaaaaadiaaaaahhcaabaaaacaaaaaaegacbaaaaaaaaaaa
egacbaaaacaaaaaadiaaaaaihcaabaaaacaaaaaaegacbaaaacaaaaaaegiccaaa
aaaaaaaaadaaaaaadiaaaaakhcaabaaaacaaaaaaegacbaaaacaaaaaaaceaaaaa
aaaaeaeaaaaaeaeaaaaaeaeaaaaaaaaadiaaaaaihcaabaaaaaaaaaaaegacbaaa
aaaaaaaapgipcaaaaaaaaaaaadaaaaaadgaaaaaficcabaaaaaaaaaaadkaabaaa
aaaaaaaadcaaaaajhccabaaaaaaaaaaaegacbaaaaaaaaaaaegacbaaaabaaaaaa
egacbaaaacaaaaaadoaaaaab"
}

SubProgram "gles " {
Keywords { "LIGHTMAP_ON" "DIRLIGHTMAP_ON" "HDR_LIGHT_PREPASS_ON" }
"!!GLES"
}

SubProgram "glesdesktop " {
Keywords { "LIGHTMAP_ON" "DIRLIGHTMAP_ON" "HDR_LIGHT_PREPASS_ON" }
"!!GLES"
}

SubProgram "d3d11_9x " {
Keywords { "LIGHTMAP_ON" "DIRLIGHTMAP_ON" "HDR_LIGHT_PREPASS_ON" }
ConstBuffer "$Globals" 160 // 148 used size, 10 vars
Vector 48 [_Color] 4
Float 144 [_Cutoff]
BindCB "$Globals" 0
SetTexture 0 [_BumpMap] 2D 1
SetTexture 1 [_MainTex] 2D 0
SetTexture 2 [_Shade] 2D 2
SetTexture 3 [_LightBuffer] 2D 3
SetTexture 4 [unity_Lightmap] 2D 4
SetTexture 5 [unity_LightmapInd] 2D 5
// 33 instructions, 6 temp regs, 0 temp arrays:
// ALU 18 float, 0 int, 0 uint
// TEX 6 (0 load, 0 comp, 0 bias, 0 grad)
// FLOW 1 static, 0 dynamic
"ps_4_0_level_9_3
eefiecedhidgkadhjiapekdaphcmlneoafanbhciabaaaaaapaajaaaaaeaaaaaa
daaaaaaalaadaaaaaeajaaaalmajaaaaebgpgodjhiadaaaahiadaaaaaaacpppp
ceadaaaafeaaaaaaacaadmaaaaaafeaaaaaafeaaagaaceaaaaaafeaaabaaaaaa
aaababaaacacacaaadadadaaaeaeaeaaafafafaaaaaaadaaabaaaaaaaaaaaaaa
aaaaajaaabaaabaaaaaaaaaaabacppppfbaaaaafacaaapkaaaaaaaeaaaaaialp
aaaaiadpaaaaaadpfbaaaaafadaaapkaaaaaeaeaaaaaaaebaaaaaaaaaaaaaaaa
fbaaaaafaeaaapkaolaffbdpdkmnbddpaaaaaaaaaaaaaaaafbaaaaafafaaapka
omafnblopdaedfdpdkmnbddpaaaaaaaafbaaaaafagaaapkaolafnblopdaedflp
dkmnbddpaaaaaaaabpaaaaacaaaaaaiaaaaaaplabpaaaaacaaaaaaiaabaaahla
bpaaaaacaaaaaaiaacaaahlabpaaaaacaaaaaaiaadaaaplabpaaaaacaaaaaaia
aeaaadlabpaaaaacaaaaaajaaaaiapkabpaaaaacaaaaaajaabaiapkabpaaaaac
aaaaaajaacaiapkabpaaaaacaaaaaajaadaiapkabpaaaaacaaaaaajaaeaiapka
bpaaaaacaaaaaajaafaiapkaabaaaaacaaaaadiaaaaaoolaecaaaaadabaaapia
aaaaoelaaaaioekaecaaaaadaaaacpiaaaaaoeiaabaioekaacaaaaadacaacpia
abaappiaabaaaakbecaaaaadadaacpiaaeaaoelaafaioekaebaaaaabacaaapia
agaaaaacaaaaabiaadaapplaafaaaaadacaaadiaaaaaaaiaadaaoelaecaaaaad
aeaacpiaaeaaoelaaeaioekaecaaaaadacaacpiaacaaoeiaadaioekaafaaaaad
acaaciiaaeaappiaadaaffkaafaaaaadaeaachiaaeaaoeiaacaappiaafaaaaad
acaaciiaadaappiaadaaffkaafaaaaadadaachiaadaaoeiaacaappiaaeaaaaae
aaaacdiaaaaaohiaacaaaakaacaaffkaaeaaaaaeaaaaciiaaaaaaaiaaaaaaaib
acaakkkaaeaaaaaeaaaaciiaaaaaffiaaaaaffibaaaappiaahaaaaacaaaaciia
aaaappiaagaaaaacaaaaceiaaaaappiafkaaaaaeafaadbiaaeaaoekaaaaaoiia
aeaakkkaaiaaaaadafaadciaafaaoekaaaaaoeiaaiaaaaadafaadeiaagaaoeka
aaaaoeiaaiaaaaadaaaaciiaafaaoeiaadaaoeiaaeaaaaaeacaachiaaeaaoeia
aaaappiaacaaoeiaaiaaaaadadaacbiaabaaoelaaaaaoeiaaiaaaaadadaaccia
acaaoelaaaaaoeiaaeaaaaaeaaaacdiaadaaoeiaacaappkaacaappkaecaaaaad
aaaaapiaaaaaoeiaacaioekaafaaaaadaaaaahiaabaaoeiaaaaaoeiaafaaaaad
aaaaahiaaaaaoeiaaaaaoekaafaaaaadaaaachiaaaaaoeiaadaaaakaafaaaaad
adaachiaabaaoeiaaaaappkaaeaaaaaeabaachiaadaaoeiaacaaoeiaaaaaoeia
abaaaaacaaaicpiaabaaoeiappppaaaafdeieefcemafaaaaeaaaaaaafdabaaaa
fjaaaaaeegiocaaaaaaaaaaaakaaaaaafkaaaaadaagabaaaaaaaaaaafkaaaaad
aagabaaaabaaaaaafkaaaaadaagabaaaacaaaaaafkaaaaadaagabaaaadaaaaaa
fkaaaaadaagabaaaaeaaaaaafkaaaaadaagabaaaafaaaaaafibiaaaeaahabaaa
aaaaaaaaffffaaaafibiaaaeaahabaaaabaaaaaaffffaaaafibiaaaeaahabaaa
acaaaaaaffffaaaafibiaaaeaahabaaaadaaaaaaffffaaaafibiaaaeaahabaaa
aeaaaaaaffffaaaafibiaaaeaahabaaaafaaaaaaffffaaaagcbaaaadpcbabaaa
abaaaaaagcbaaaadhcbabaaaacaaaaaagcbaaaadhcbabaaaadaaaaaagcbaaaad
lcbabaaaaeaaaaaagcbaaaaddcbabaaaafaaaaaagfaaaaadpccabaaaaaaaaaaa
giaaaaacagaaaaaaefaaaaajpcaabaaaaaaaaaaaegbabaaaabaaaaaaeghobaaa
abaaaaaaaagabaaaaaaaaaaaaaaaaaajbcaabaaaabaaaaaadkaabaaaaaaaaaaa
akiacaiaebaaaaaaaaaaaaaaajaaaaaadbaaaaahbcaabaaaabaaaaaaakaabaaa
abaaaaaaabeaaaaaaaaaaaaaanaaaeadakaabaaaabaaaaaaefaaaaajpcaabaaa
abaaaaaaegbabaaaafaaaaaaeghobaaaaeaaaaaaaagabaaaaeaaaaaadiaaaaah
icaabaaaabaaaaaadkaabaaaabaaaaaaabeaaaaaaaaaaaebdiaaaaahhcaabaaa
abaaaaaaegacbaaaabaaaaaapgapbaaaabaaaaaaaoaaaaahdcaabaaaacaaaaaa
egbabaaaaeaaaaaapgbpbaaaaeaaaaaaefaaaaajpcaabaaaacaaaaaaegaabaaa
acaaaaaaeghobaaaadaaaaaaaagabaaaadaaaaaaefaaaaajpcaabaaaadaaaaaa
egbabaaaafaaaaaaeghobaaaafaaaaaaaagabaaaafaaaaaadiaaaaahicaabaaa
abaaaaaadkaabaaaadaaaaaaabeaaaaaaaaaaaebdiaaaaahhcaabaaaadaaaaaa
egacbaaaadaaaaaapgapbaaaabaaaaaaefaaaaajpcaabaaaaeaaaaaaogbkbaaa
abaaaaaaeghobaaaaaaaaaaaaagabaaaabaaaaaadcaaaaapdcaabaaaaeaaaaaa
hgapbaaaaeaaaaaaaceaaaaaaaaaaaeaaaaaaaeaaaaaaaaaaaaaaaaaaceaaaaa
aaaaialpaaaaialpaaaaaaaaaaaaaaaadcaaaaakicaabaaaabaaaaaaakaabaia
ebaaaaaaaeaaaaaaakaabaaaaeaaaaaaabeaaaaaaaaaiadpdcaaaaakicaabaaa
abaaaaaabkaabaiaebaaaaaaaeaaaaaabkaabaaaaeaaaaaadkaabaaaabaaaaaa
elaaaaafecaabaaaaeaaaaaadkaabaaaabaaaaaaapcaaaakbcaabaaaafaaaaaa
aceaaaaaolaffbdpdkmnbddpaaaaaaaaaaaaaaaaigaabaaaaeaaaaaabacaaaak
ccaabaaaafaaaaaaaceaaaaaomafnblopdaedfdpdkmnbddpaaaaaaaaegacbaaa
aeaaaaaabacaaaakecaabaaaafaaaaaaaceaaaaaolafnblopdaedflpdkmnbddp
aaaaaaaaegacbaaaaeaaaaaabaaaaaahicaabaaaabaaaaaaegacbaaaafaaaaaa
egacbaaaadaaaaaadcaaaaajhcaabaaaabaaaaaaegacbaaaabaaaaaapgapbaaa
abaaaaaaegacbaaaacaaaaaabaaaaaahbcaabaaaacaaaaaaegbcbaaaacaaaaaa
egacbaaaaeaaaaaabaaaaaahccaabaaaacaaaaaaegbcbaaaadaaaaaaegacbaaa
aeaaaaaadcaaaaapdcaabaaaacaaaaaaegaabaaaacaaaaaaaceaaaaaaaaaaadp
aaaaaadpaaaaaaaaaaaaaaaaaceaaaaaaaaaaadpaaaaaadpaaaaaaaaaaaaaaaa
efaaaaajpcaabaaaacaaaaaaegaabaaaacaaaaaaeghobaaaacaaaaaaaagabaaa
acaaaaaadiaaaaahhcaabaaaacaaaaaaegacbaaaaaaaaaaaegacbaaaacaaaaaa
diaaaaaihcaabaaaacaaaaaaegacbaaaacaaaaaaegiccaaaaaaaaaaaadaaaaaa
diaaaaakhcaabaaaacaaaaaaegacbaaaacaaaaaaaceaaaaaaaaaeaeaaaaaeaea
aaaaeaeaaaaaaaaadiaaaaaihcaabaaaaaaaaaaaegacbaaaaaaaaaaapgipcaaa
aaaaaaaaadaaaaaadgaaaaaficcabaaaaaaaaaaadkaabaaaaaaaaaaadcaaaaaj
hccabaaaaaaaaaaaegacbaaaaaaaaaaaegacbaaaabaaaaaaegacbaaaacaaaaaa
doaaaaabejfdeheolaaaaaaaagaaaaaaaiaaaaaajiaaaaaaaaaaaaaaabaaaaaa
adaaaaaaaaaaaaaaapaaaaaakeaaaaaaaaaaaaaaaaaaaaaaadaaaaaaabaaaaaa
apapaaaakeaaaaaaabaaaaaaaaaaaaaaadaaaaaaacaaaaaaahahaaaakeaaaaaa
acaaaaaaaaaaaaaaadaaaaaaadaaaaaaahahaaaakeaaaaaaadaaaaaaaaaaaaaa
adaaaaaaaeaaaaaaapalaaaakeaaaaaaaeaaaaaaaaaaaaaaadaaaaaaafaaaaaa
adadaaaafdfgfpfaepfdejfeejepeoaafeeffiedepepfceeaaklklklepfdeheo
cmaaaaaaabaaaaaaaiaaaaaacaaaaaaaaaaaaaaaaaaaaaaaadaaaaaaaaaaaaaa
apaaaaaafdfgfpfegbhcghgfheaaklkl"
}

}
	}

#LINE 51

    } 
    Fallback "Diffuse"
}