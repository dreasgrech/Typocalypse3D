using UnityEngine;
using System.Collections;

public class EnemiesWordsHUDBehaviour : MonoBehaviour
{
    public UIFont font;
    public Color enemyWordColor;
    public GameObject fontPrefab;

    public UILabel Create(string text, GameObject wordContainer, Transform target)
    {
        wordContainer.transform.parent = transform;
        wordContainer.transform.localScale = Vector3.one;
        var label = wordContainer.GetComponentInChildren<UILabel>();

        label.supportEncoding = true;
        label.text = text;
        label.MakePixelPerfect();
        //label.transform.localScale = new Vector3(28, 28);

        //var follow = label.gameObject.AddComponent<UIFollowTarget>();
        var follow = wordContainer.gameObject.AddComponent<UIFollowTarget>();
        follow.target = target;
        follow.gameCamera = GameSettings.GameCamera;
        follow.uiCamera = GameSettings.UICamera;

        return label;
    }

    public UILabel Create(string text, Transform target)
    {
        var wordGameObject = (GameObject)Instantiate(fontPrefab);
        wordGameObject.transform.parent = transform;
        var label = wordGameObject.GetComponent<UILabel>();
        label.supportEncoding = true;
        label.text = text;
        label.MakePixelPerfect();
        label.transform.localScale = new Vector3(28, 28);

        var follow = label.gameObject.AddComponent<UIFollowTarget>();
        follow.target = target;
        follow.gameCamera = GameSettings.GameCamera;
        follow.uiCamera = GameSettings.UICamera;

        return label;
    }
}
