using UnityEngine;
using System.Collections;

public interface ISniperPowerupClickable
{
    void HitBySniperPowerup(Vector3 hitWorldPosition);
    void ChangeCelShadingEffect(Color outline, Color? inner = null);
}
