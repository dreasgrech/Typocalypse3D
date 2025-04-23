using UnityEngine;
using System.Collections;

public class GlobalBloodSquirter : MonoBehaviour
{
    public GameObject[] blood;
    public Texture[] bloodTextures;
    public GameObject bloodStainPrefab;

    private void Start()
    {
    }

    public void Squirt(Vector3 position, int numberOfStains, float stainsRadius) {
        var randomBlood = blood.GetRandomElement();

        randomBlood.SetActive(false);
        var newBlood = (GameObject)Instantiate(randomBlood, position, Quaternion.identity);
        newBlood.transform.parent = transform;
        newBlood.AddComponent<SelfDestruct>();
        newBlood.SetActive(true);

        StartStainSplatter(position, numberOfStains, stainsRadius);
    }

    private void StartStainSplatter(Vector3 hitPosition, int total, float stainsRadius)
    {
        CreateStain(hitPosition, Vector3.zero);
        for (int i = 0; i < total - 1; i++)
        {
            var random = Random.insideUnitSphere * stainsRadius;
            var offset = new Vector3(random.x, 0, random.z);
            CreateStain(hitPosition, offset);
        }
    }

    private GameObject CreateStain(Vector3 position, Vector3 offset)
    {
        position = position.ReplaceY(0.22f);
        var stainTexture = bloodTextures.GetRandomElement();
        var bloodStainObject = (GameObject)Instantiate(bloodStainPrefab);
        bloodStainObject.transform.parent = transform;
        bloodStainObject.transform.rotation = Quaternion.Euler(0, Random.Range(0, 360), 0);
        bloodStainObject.transform.position = position + offset;
        var material = bloodStainObject.GetComponent<MeshRenderer>().material;
        material.mainTexture = stainTexture;
        var color = material.GetColor("_Color");
         StartCoroutine(HomelessMethods.Interpolate(1f, 0f, 20f, Mathf.Lerp, i => material.SetColor("_Color", color.ChangeAlpha(i)),() => Destroy(bloodStainObject)));

        return bloodStainObject;
    }
}
