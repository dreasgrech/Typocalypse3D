using System;
using System.Collections.Generic;
using System.Linq;
using UnityEngine;
using System.Collections;

public static class GameSettings
{
    public static float Difficulty { get; set; }
    public static Camera GameCamera { get; set; }
    public static Camera UICamera { get; set; }

    public static int WaveTimeSeconds { get; set; }

    //public static string QualitySetting
    //{
    //    set
    //    {
    //        for (int i = 0; i < QualitySettings.names.Length; i++)
    //        {
    //            var qualityName = QualitySettings.names[i];
    //            if (string.Equals(qualityName, value.Trim(), StringComparison.OrdinalIgnoreCase))
    //            {
    //                QualitySettings.SetQualityLevel(i);
    //            }
    //        }
    //    }
    //    get
    //    {
    //        return QualitySettings.names[QualitySettings.GetQualityLevel()];
    //    }
    //}

    public static Dictionary<string, SecretCode> GameSecrets { get; private set; }
    public static HashSet<SecretCode> ActivatedSecrets { get; private set; }

    static GameSettings()
    {
        ActivatedSecrets = new HashSet<SecretCode>();
        GameSecrets = new Dictionary<string, SecretCode>
                     {
                         //{"gong", SecretCode.FlyingTeapot},
                         {"cedric", SecretCode.RubixCube},
                         {"new game", SecretCode.NewGame},
                         {"wtf", SecretCode.WTF},
                         {"roflcopter", SecretCode.LOL},
                         {"janica", SecretCode.PLess},
                     };
    }

    public static bool IsSecretActivated(SecretCode secret)
    {
        return ActivatedSecrets.Contains(secret);
    }
}