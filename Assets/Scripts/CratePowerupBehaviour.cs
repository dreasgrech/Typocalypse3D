using System;
using System.Collections.Generic;
using UnityEngine;
using System.Collections;

public enum PowerupContainerDestroyedReason
{
    PlayerTypedWord,
    ColliderImpact,
}

public class CratePowerupBehaviour : MonoBehaviour, ISniperPowerupClickable, IHUDTextEnabled
{
    public Rigidbody crateRigidBody;
    public PowerupBoxCollider crateCollider;
    public Collider[] flagColliders;
    public Light overheadSpotlight;
    public GameObject explosion;
    public GameObject box;
    public InteractiveCloth cloth;
    public GameObject hudTextPrefab;
    public Transform scorePosition;
    public Color scoreColor;

    public event EventHandler<EnemyDestroyedPowerupEventArgs> OnEnemyDestroyedPowerup;

    public BasePowerup PowerupBehaviour { get; private set; }

    private TextManipulation textManipulation;
    private HUDText scoreHUDText;
    private Material meshRendererMaterial;
    private Color originalMeshRendererMaterial;

    private void Awake()
    {
        textManipulation = transform.GetComponent<TextManipulation>();
        var meshRenderer = GetComponentInChildren<MeshRenderer>();
        meshRendererMaterial = meshRenderer.material;
        originalMeshRendererMaterial = meshRendererMaterial.GetColor("_Color");

        // When the collider is hit by an enemy, we destroy the powerup
        crateCollider.OnColliderHit += (sender, args) =>
        {
            StartCoroutine(Deactivate(PowerupContainerDestroyedReason.ColliderImpact));

            if (OnEnemyDestroyedPowerup != null)
            {
                Debug.Log("CratePowerupBehaviour: " + args.EnemyHit);
                OnEnemyDestroyedPowerup(this, new EnemyDestroyedPowerupEventArgs(PowerupBehaviour, this, args.EnemyHit));
            }
        };

        AddScoreHUDText();
    }

    private void AddScoreHUDText()
    {
        //new UITexture().shader = Shader.Find("Unlit - Transparent Colored")
        var root = GameObject.FindGameObjectWithTag("HUDText").transform;
        var hudText = NGUITools.AddChild(root.gameObject, hudTextPrefab);
        hudText.name = "Powerup HudText";
        scoreHUDText = hudText.GetComponent<HUDText>();
        var uiFollowTarget = hudText.AddComponent<UIFollowTarget>();
        uiFollowTarget.target = scorePosition;
        uiFollowTarget.gameCamera = GameSettings.GameCamera;
        uiFollowTarget.uiCamera = GameSettings.UICamera;
    }

    public void ShowScore(int score)
    {
        //var color = textManipulation.WordsLeft > 0 ?  Color.yellow : Color.blue;
        scoreHUDText.Add(score, scoreColor, 0f);
    }

    /// <summary>
    /// Activate the powerup
    /// </summary>
    public void SetWords(BasePowerup powerupBehaviour)
    {
        PowerupBehaviour = powerupBehaviour;
        /*
        var clothMaterial = cloth.GetComponent<ClothRenderer>().materials[0];
        clothMaterial.mainTexture = powerupBehaviour.BannerTexture;
        clothMaterial.color = powerupBehaviour.BannerColor;
        */
        StartCoroutine(Activate());
    }

    public void UseNextWord()
    {
        textManipulation.UseNextWord();
    }

    /// <summary>
    /// Returns a boolean value indicating whether the given key will match our current string
    /// </summary>
    public bool WillKeyMatch(char key)
    {
        return textManipulation.WillKeyMatch(key);
    }

    /// <summary>
    /// Bring the box in with the helicopter
    /// </summary>
    /// <param name="words"></param>
    /// <returns></returns>
    private IEnumerator Activate()
    {
        var helicopterArrivalTime = 2f;
        audio.volume = 1;
        //StartCoroutine(HomelessMethods.Interpolate(0f, 1f, helicopterArrivalTime, InterpolationMethods.Lerp, i => audio.volume = i));
        // Drop the crate
        crateRigidBody.isKinematic = false;

        // Wait for two seconds before dropping down the text
        //yield return new WaitForSeconds(2f);
        textManipulation.SetWords(new[] {PowerupBehaviour.wordToUse});
        textManipulation.UseNextWord();
        yield return null;
    }

    /// <summary>
    /// Explode the box
    /// </summary>
    /// <returns></returns>
    public IEnumerator Deactivate(PowerupContainerDestroyedReason reason, Action powerupTextureCallback = null)
    {
        var shouldTextureFly = reason == PowerupContainerDestroyedReason.PlayerTypedWord && PowerupBehaviour.CurrentTotalCollectedLevels <= PowerupBehaviour.MaxLevels;
        textManipulation.DestroyWord(shouldTextureFly, () =>
        {
            if (powerupTextureCallback != null)
            {
                powerupTextureCallback();
            }
        });
        StartCoroutine(HomelessMethods.Interpolate(overheadSpotlight.intensity, 0f, 0.6f, InterpolationMethods.Lerp, f => { overheadSpotlight.intensity = f; }));

        box.SetActive(false);
        explosion.SetActive(true);

        foreach (var collider1 in flagColliders)
        {
            DestroyObject(collider1);
        }

        yield return new WaitForSeconds(0.3f);

        if (crateCollider != null)
        {
            Destroy(crateCollider.GetComponent<Rigidbody>());
            Destroy(crateCollider.GetComponent<BoxCollider>());
        }

        yield return new WaitForSeconds(3f);
        if (transform != null && gameObject != null)
        {
            Destroy(gameObject);
        }

        Destroy(scoreHUDText);
        yield return null;
    }

    public void HitBySniperPowerup(Vector3 hitWorldPosition)
    {
        new MessagePowerupTyped(this, textManipulation.WordsLeft.Count < 1, textManipulation.Text, false);
    }

    public void ChangeCelShadingEffect(Color outline, Color? inner = null)
    {
            meshRendererMaterial.SetColor("_OutlineColor", outline);
            meshRendererMaterial.SetColor("_Color", inner ?? originalMeshRendererMaterial);
    }
}

public class EnemyDestroyedPowerupEventArgs : EventArgs
{
    public BasePowerup Powerup { get; private set; }
    public CratePowerupBehaviour CratePowerupBehaviour { get; set; }
    public IEnemy EnemyHit { get; private set; }

    public EnemyDestroyedPowerupEventArgs(BasePowerup powerup, CratePowerupBehaviour cratePowerupBehaviour, IEnemy enemyHit)
    {
        Powerup = powerup;
        CratePowerupBehaviour = cratePowerupBehaviour;
        EnemyHit = enemyHit;
    }
}

public class PowerupFirstActivationEventsArgs : EventArgs
{
    public BasePowerup Powerup { get; private set; }

    public PowerupFirstActivationEventsArgs(BasePowerup powerup)
    {
        Powerup = powerup;
    }
}