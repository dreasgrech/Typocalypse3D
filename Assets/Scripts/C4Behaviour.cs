using System;
using UnityEngine;
using System.Collections;

public class C4Behaviour : MonoBehaviour
{
    public Camera mainCamera;
    public GameObject explosion;
    public CentralLogicScript centralLogicScript;
    public GameObject model;
    public Light explosionLight;

    public event EventHandler<EventArgs> OnDetonated;

    public TextManipulation TextManipulation { get; set; }

    // Use this for initialization
    void Awake()
    {
        TextManipulation = GetComponent<TextManipulation>();
    }

    void _C4Typed(MessageC4Typed message)
    {
        if (message.Text != TextManipulation.Text)
        {
            return;
        }

        if (OnDetonated != null)
        {
            OnDetonated(this, EventArgs.Empty);
        }

        StartCoroutine(Explode());
    }

    private IEnumerator Explode()
    {
        iTween.ShakePosition(mainCamera.transform.gameObject, new Hashtable
                                                              {
                                                                  {"amount", new Vector3(0.2f, 0.2f, 0.0f)},
                                                                  {"time", 1},
                                                                  {"ignoretimescale", true}
                                                              });
        explosion.SetActive(true);
        Destroy(model);
        TextManipulation.DestroyWord(false);

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
                centralLogicScript.KillEnemy(component, EnemyDiedReason.C4Area, Vector3.zero);
            }
        }
    }
}