using System.Collections.Generic;
using System.Linq;
using UnityEngine;
using System.Collections;

public class LandmineLightFlicker : MonoBehaviour, ISniperPowerupClickable
{
    public float startingInterval;
    public Light landmineLight;
    public GameObject explosion;
    public Light explosionLight;
    public GameObject model;
    //public AudioSource explosionSound;
    public CentralLogicScript centralLogicScript;
    public Camera mainCamera;
    public BodyPartsExplosion bodyPartsExplosion;

    private bool lightState;
    private IEnumerable<Material> modelPartsMaterials;
    private Dictionary<Material, Color> originalMaterialColours;

	// Use this for initialization
	IEnumerator Start () {
        explosion.SetActive(false);

	    modelPartsMaterials = from Transform childTransform in model.transform select childTransform.GetComponent<MeshRenderer>().material;
	    originalMaterialColours = modelPartsMaterials.ToDictionary(material => material, material => material.GetColor("_Color"));

        while (true)
        {
            yield return new WaitForSeconds(startingInterval);
            landmineLight.gameObject.SetActive(!landmineLight.gameObject.activeSelf);
        }
	}

    private void OnCollisionEnter(Collision other)
    {
        // when an enemy is killed by a crate, he needs to be removed from central logic
       if (!other.gameObject.name.Contains("Terrain") && !other.gameObject.name.Contains("Landmine") && !other.gameObject.name.Contains("Blood Stain"))
       {
           var groundItemWatcher = other.gameObject.GetComponentInChildren<GroundItemWatcher>();
           if (groundItemWatcher == null)
           {
               StartCoroutine(Explode(other.gameObject));
           }
       }
    }

    private void WoundNearbyEnemies()
    {
        Collider[] colliders = Physics.OverlapSphere(transform.position, 6f);
        foreach (Collider hit in colliders)
        {
            if (hit.transform.parent == null)
            {
                continue;
            }

            var component = hit.transform.parent.GetCustomComponent<IEnemy>();
            if (component != null)
            {
                centralLogicScript.KillEnemy(component, EnemyDiedReason.LandmineArea, Vector3.zero);
            }
        }
    }

    private IEnumerator Explode(GameObject enemyCollided)
    {
            iTween.ShakePosition(mainCamera.transform.gameObject, new Hashtable
                                                                  {
                                                                      {"amount", new Vector3(0.2f, 0.2f, 0.0f)},
                                                                      {"time", 1},
                                                                      {"ignoretimescale", true}
                                                                  });
        explosion.SetActive(true);
        Destroy(model);

        if (enemyCollided != null && enemyCollided.transform.parent != null)
        {
            var component = enemyCollided.transform.parent.GetCustomComponent<IEnemy>();
            if (component != null)
            {
                var bodyPartsExplosionClone = (GameObject)Instantiate(bodyPartsExplosion.gameObject);
                bodyPartsExplosionClone.SetActive(true);
                bodyPartsExplosionClone.GetComponent<BodyPartsExplosion>().GoBoom(component.Position);

                centralLogicScript.KillEnemy(component, EnemyDiedReason.Landmine, Vector3.zero);
            }
        }

        // We need to wound nearby enemies since the mine has exploded
        WoundNearbyEnemies();

        audio.Play();
        var time = 0.1f;
        explosionLight.enabled = true;
        yield return new WaitForSeconds(time);
        explosionLight.enabled = false;
        yield return new WaitForSeconds(time);
        Destroy(GetComponent<BoxCollider>());

        // Wait for the fog to clear before destroying ourselves
        yield return new WaitForSeconds(10f);
        Destroy(gameObject);
    }

    public void HitBySniperPowerup(Vector3 hitWorldPosition)
    {
        StartCoroutine(Explode(null));
    }

    public void ChangeCelShadingEffect(Color outline, Color? inner = null)
    {
        if (transform == null || modelPartsMaterials == null)
        {
            return;
        }
        return;

        foreach (var modelPartsMaterial in modelPartsMaterials)
        {
            if (modelPartsMaterial != null)
            {
                modelPartsMaterial.SetColor("_OutlineColor", outline);
                modelPartsMaterial.SetColor("_Color", inner ?? originalMaterialColours[modelPartsMaterial]);
            }
        }
    }
}
