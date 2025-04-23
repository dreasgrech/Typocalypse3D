using System.Collections.Generic;
using System.Linq;
using UnityEngine;
using System.Collections;

/*
 * Currently unused
 */
public class SniperAimable : MonoBehaviour
{
    public Renderer[] modelsToColor;

    private IEnumerable<Material> materials;

	// Use this for initialization
	void Start ()
	{
	    materials = from model in modelsToColor select model.material;
	}

    public void ChangeCelShadingEffect(Color outline, Color? inner = null)
    {
        foreach (var material in materials)
        {
            material.SetColor("_OutlineColor", outline);
            material.SetColor("_Color", inner ?? Color.white);
            
        }
    }
}
