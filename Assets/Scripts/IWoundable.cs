using System.Collections;
using UnityEngine;

public interface IWoundable
{
    IEnumerator DoWoundRoutine(Animation modelAnimation);
    float TimeForNextWordToAppearAfterWounded { get; }
}