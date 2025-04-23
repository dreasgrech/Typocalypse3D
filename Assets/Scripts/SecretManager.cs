using UnityEngine;
using System.Collections;

public class SecretManager : MonoBehaviour
{
    public GameObject flyingTeapot;
    public GameObject rubixCube;

    public GameObject grenades;

	// Use this for initialization
	void Start () {
        flyingTeapot.SetActive(false);
        rubixCube.SetActive(false);
	}

    public void HandleSecrets()
    {
        foreach (var activatedSecret in GameSettings.ActivatedSecrets)
        {
            switch (activatedSecret)
            {
                case SecretCode.FlyingTeapot: FlyingTeapotSecret(); break;
                case SecretCode.RubixCube: RubixCubeSecret(); break;
            }
        }
    }

    private void FlyingTeapotSecret()
    {
        HideGrenades();
        flyingTeapot.SetActive(true);
    }

    private void RubixCubeSecret()
    {
        HideGrenades();
        rubixCube.SetActive(true);
    }

    private void HideGrenades()
    {
        grenades.SetActive(false);
    }
}
