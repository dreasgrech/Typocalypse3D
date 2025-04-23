using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using UnityEngine;
using System.Collections;

public enum EnemyTextState
{
    Normal
}

/*
public class OnEnemyWordTypedEventArgs : EventArgs
{
    public IEnemy Enemy { get; set; }
    public bool WasEnemyKilled { get; set; }

    public OnEnemyWordTypedEventArgs(IEnemy enemy, bool wasEnemyKilled)
    {
        Enemy = enemy;
        WasEnemyKilled = wasEnemyKilled;
    }
}
*/

public enum WordType
{
    Enemy,
    Powerup,
    C4Explosive
}

public class TextManipulation : StateMachine<EnemyTextState>
{
    public float fontSize;
    public Color InactiveColor;
    public Color ActiveColor;
    public Transform wordParent;
    public Transform wordPositionMarkerStart;
    public Transform wordPositionMarkerEnd;
    public WordType wordType;
    public int ActiveCharacterIndex { get; private set; }
    public GameObject wordContainer;

    /*
    public int WordsLeft
    {
        get
        {
            return words.Count;
        }
    }*/
    public Stack<string> WordsLeft { get; set; }

    public Vector3 WordPosition
    {
        //get { return wordPositionMarkerStart.position; }
        get { return currentWord.transform.position; }
    }

    public string Text { get; private set; }
    public GameObject currentWord { get; private set; }
    private int totalCharacters;
    private IEnemy zombie;
    private GameObject mainCamera;
    private PlayerBehaviour player;
    private float currentWordStartingPositionDistanceToPlayer;
    private float? currentWordHeightPosition;
    private bool wordComingDownFromTheSky;
    private EnemiesWordsHUDBehaviour enemiesWordsHudBehaviour;

    private GameObject currentWordContainer;
    private UILabel currentWordLabel;
    private UITexture currentWordTexture;

    private const float wordLetterSpacing = 1f;

    private bool initiated;

    public GameObject UseNextWord()
    {
        if (!initiated) // Because of the race condition I had with the Start() and this UseNextWord(), I have to use this shit boolean to represent my "Start()"
        {
            InactiveColor = InactiveColor.ChangeAlpha(1);
            ActiveColor = ActiveColor.ChangeAlpha(1);

            player = GameObject.FindWithTag("Player").GetComponent<PlayerBehaviour>();
            mainCamera = GameObject.FindGameObjectWithTag("MainCamera");
            zombie = (IEnemy) transform.GetComponent(typeof (IEnemy));

            Messenger.instance.Listen("game", gameObject);
            Messenger.instance.Listen("typing", gameObject);

            CurrentState = EnemyTextState.Normal;
            initiated = true;
        }

        enemiesWordsHudBehaviour = GameObject.FindGameObjectWithTag("EnemiesWords").GetComponent<EnemiesWordsHUDBehaviour>();
        if (WordsLeft == null || WordsLeft.Count < 1)
        {
            Debug.LogWarning("No words were set, or there are no words left");
            return null;
        }

        var newWord = WordsLeft.Pop();

        ActiveCharacterIndex = 0;

        Text = newWord;

        // Create the text!
        currentWord = new GameObject();//FlyingText.GetObjects(Text);
        currentWord.SetActive(false);

        currentWordContainer = (GameObject) Instantiate(wordContainer);
        currentWordLabel = enemiesWordsHudBehaviour.Create(Text, currentWordContainer, currentWord.transform);
        currentWordLabel.enabled = true;
        currentWordLabel.color = InactiveColor;
        currentWordLabel.color = currentWordLabel.color.ChangeAlpha(1);
        currentWordLabel.name = Text;

        var mapped10position = GetMapped10Position();

        currentWordTexture = currentWordContainer.GetComponentInChildren<UITexture>();
        if (currentWordTexture != null)
        {
            var textSize = currentWordLabel.font.CalculatePrintedSize(currentWordLabel.text, false, UIFont.SymbolStyle.None)*currentWordLabel.font.size;

            var textCenterX = textSize.x/2f;
            var firstLetterPosition = currentWordTexture.transform.localPosition.ReplaceX(currentWordTexture.transform.localPosition.x - textCenterX);

            var newTexturePosition = firstLetterPosition.ReplaceX(firstLetterPosition.x - 30);
            currentWordTexture.transform.localPosition = newTexturePosition;
            var powerupTexture = GetComponent<CratePowerupBehaviour>().PowerupBehaviour.hudTexture;
            currentWordTexture.mainTexture = powerupTexture;
            currentWordTexture.MakePixelPerfect();
        }

        currentWord.transform.parent = wordParent;

        var deltaY = 20;

        // Start at the starting position high up
        currentWord.transform.position = wordPositionMarkerStart.position + new Vector3(0, deltaY);

        var interpolateTo = currentWordHeightPosition ?? InterpolationMethods.Lerp(wordPositionMarkerEnd.position.y, wordPositionMarkerStart.position.y, mapped10position);

        wordComingDownFromTheSky = true;
        StartCoroutine(HomelessMethods.Interpolate(deltaY, interpolateTo, 0.5f, InterpolationMethods.Hermite, f =>
        {
            if (currentWord == null)
            {
                return;
            }

            currentWord.transform.position = new Vector3(currentWord.transform.position.x, f, currentWord.transform.position.z);
        }, () =>
        {
            wordComingDownFromTheSky = false;
        }));

        return currentWord;
    }

    void Normal_Update()
    {
        if (currentWord != null)
        {
            var mapped10position = GetMapped10Position();
            if (!wordComingDownFromTheSky)
            {
                currentWordHeightPosition = InterpolationMethods.Lerp(wordPositionMarkerEnd.position.y, wordPositionMarkerStart.position.y, mapped10position);
                currentWord.transform.position = new Vector3(currentWord.transform.position.x, currentWordHeightPosition.Value, currentWord.transform.position.z);
            }

            if (currentWordContainer != null)
            {
                if (Time.timeScale != 0)
                {
                    var depth = Convert.ToInt32(InterpolationMethods.Lerp(100f, 0f, mapped10position));

                    if (currentWordLabel != null)
                    {
                        currentWordLabel.depth = depth;
                        currentWordLabel.transform.position = currentWordLabel.transform.position.ReplaceZ(mapped10position);
                    }

                    if (currentWordTexture != null)
                    {
                        currentWordTexture.depth = depth;
                        currentWordTexture.transform.position = currentWordTexture.transform.position.ReplaceZ(mapped10position);
                    }
                }

                if (wordType == WordType.Enemy)
                {
                    var newLabelScale = Mathf.Lerp(32f, 25f, mapped10position);
                    if (currentWordLabel != null)
                    {
                        currentWordLabel.transform.localScale = new Vector3(newLabelScale, newLabelScale);
                    }
                }
            }

            ColorString(ActiveCharacterIndex);
        }
    }

    /// <summary>
    /// Returns a 0..1 number of the current position of the enemy as it approaches the player
    /// </summary>
    /// <returns></returns>
    public float GetMapped10Position()
    {
        var hardCodedStartedPositionZ = 21.84133f;
        var zDistanceToPlayer = Mathf.Abs(transform.position.z - player.transform.position.z);
        return HomelessMethods.Map(zDistanceToPlayer, 0, hardCodedStartedPositionZ, 0, 1);
    }

    public void SetWords(IEnumerable<string> wordCollection)
    {
        WordsLeft = new Stack<string>(wordCollection.Select(word => word.ToLower()));
    }

    void DestroyCurrentWordContainer()
    {
        if (currentWordContainer == null || currentWordContainer.transform == null)
        {
            return;
        }

        // I can't just do Destroy(currentWordContainer); because that will throw this exception:
        // "Destroying GameObjects immediately is not permitted during physics trigger/contact or animation event callbacks. You must use Destroy instead."
        foreach (Transform wordContainerTransform in currentWordContainer.transform)
        {
            if (wordContainerTransform != null)
            {
                Destroy(wordContainerTransform.gameObject);
            }
        }

        Destroy(currentWordContainer);

        if (currentWord != null)
        {
            Destroy(currentWord);
        }

        Destroy(currentWordContainer);
    }

    /// <summary>
    /// When we recieve a message that another word has been completed, we start from scratch with our word
    /// </summary>
    /// <param name="message"></param>
	private void _WordCompleted(MessageWordCompleted message)
	{
        if (message.Word == Text)
        {
            return;
        }

        ActiveCharacterIndex = 0;
	}

    /// <summary>
    /// When we recieve a message that another word has been completed, we start from scratch with our word
    /// </summary>
    /// <param name="message"></param>
	private void _PowerupTyped(MessagePowerupTyped message)
	{
        ActiveCharacterIndex = 0;
	}

    /// <summary>
    /// When we recieve a message that another word has been completed, we start from scratch with our word
    /// </summary>
    /// <param name="message"></param>
	private void _C4Typed(MessageC4Typed message)
	{
        ActiveCharacterIndex = 0;
	}

	private void _KeyPressed(MessageKeyPressed msg)
	{
        if (String.IsNullOrEmpty(Text))
        {
            // We have no text, so just return.
            return;
        }

        if (ActiveCharacterIndex >= Text.Length)
        {
            return;
        }

        if (WillKeyMatch(Convert.ToChar(msg.Key)))
        {
           ++ActiveCharacterIndex;

            if (ActiveCharacterIndex == Text.Length)
            {
                //// Inform the others that a word has been fully typed in
                var noWordsLeft = WordsLeft.Count < 1;
                if (wordType == WordType.Powerup)
                {
                    // Powerup!
                    new MessagePowerupTyped(GetComponent<CratePowerupBehaviour>(), noWordsLeft, Text, true);
                }
                else if (wordType == WordType.C4Explosive)
                {
                    new MessageC4Typed(Text);
                }
                else
                {
                    // It's an enemy
                    new MessageWordCompleted(WordType.Enemy, zombie, noWordsLeft, Text);
                }
            }
        }
	}

    public bool WillKeyMatch(char key)
    {
        if (String.IsNullOrEmpty(Text) || ActiveCharacterIndex > Text.Length)
        {
            return false;
        }

        if (ActiveCharacterIndex >= Text.Length)
        {
            return false;
        }

        return Text[ActiveCharacterIndex] == key;
    }

    public void DestroyWord(bool shouldTextureFly, Action textureArrivedAtPosition = null)
    {
        if (currentWordContainer == null)
        {
            return;
        }

        const float fadeoutTime = 0.3f;
        var labelOnContainer = currentWordContainer.GetComponentInChildren<UILabel>();
        if (Time.timeScale == 1)
        {
            StartCoroutine(HomelessMethods.Interpolate(1f, 0f, fadeoutTime, InterpolationMethods.Lerp, f =>
            {
                if (labelOnContainer != null)
                {
                    labelOnContainer.alpha = f;
                }
            }, () =>
            {
                if (labelOnContainer != null)
                {
                    Destroy(labelOnContainer);
                }
            }));
        }
        else
        {
            if (labelOnContainer != null)
            {
                Destroy(labelOnContainer);
            }
        }

        currentWordTexture = currentWordContainer.GetComponentInChildren<UITexture>();
        if (currentWordTexture != null)
        {
            var iconPosition = GetComponent<CratePowerupBehaviour>().PowerupBehaviour.iconCenterPosition;
            if (shouldTextureFly && iconPosition != Vector2.zero)
            {
                var texturePosition = currentWordTexture.transform.position;
                StartCoroutine(HomelessMethods.Interpolate(texturePosition, new Vector3(iconPosition.x, iconPosition.y, currentWordTexture.transform.position.z), 0.3f, Vector3.Lerp, vector3 =>
                {
                    if (currentWordTexture != null)
                    {
                        currentWordTexture.transform.position = vector3;
                    }
                }, () =>
                {
                    if (textureArrivedAtPosition != null)
                    {
                        textureArrivedAtPosition();
                    }

                    Destroy(currentWordTexture);
                }));
            }
            else
            {
                StartCoroutine(HomelessMethods.Interpolate(1f, 0f, fadeoutTime, InterpolationMethods.Lerp, f =>
                {
                    currentWordTexture.alpha = f;
                }, () =>
                {
                    if (textureArrivedAtPosition != null)
                    {
                        textureArrivedAtPosition();
                    }

                    Destroy(currentWordTexture);
                    DestroyCurrentWordContainer();
                }));
            }

            return;
        }

        DestroyCurrentWordContainer();
    }

    public void TurnToRed()
    {
        ActiveCharacterIndex = Text.Length;
    }

    private void ColorString(int characterIndex)
    {
        string activeString = Text.Substring(0, characterIndex),
               inactiveString = Text.Substring(characterIndex);

        var formattedString = String.Format("[{0}]{1}[-]{2}", HomelessMethods.ToHex(ActiveColor), activeString, inactiveString);
        currentWordLabel.text = formattedString;
    }
}
