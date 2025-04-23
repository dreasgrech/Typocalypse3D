using System.Globalization;
using System.Text;
using UnityEngine;
using System.Collections;
using System.Collections.Generic;
using System;
using System.IO;
using System.Linq;

public enum SecretCode
{
    NewGame,
    FlyingTeapot,
    RubixCube,
    WTF,
    LOL,
    PLess
}

public class KeyManager : MonoBehaviour
{
    public event EventHandler<KeyPressedEventArgs> AlphabeticalKeyPressed;
    public event EventHandler<KeyPressedEventArgs> AnyKeyPressed;
    public event EventHandler<NumberKeyPressedEventArgs> NumberPressed;
    public event EventHandler<SecretUnlockedEventArgs> SecretUnlocked;

    private readonly HashSet<char> alphabeticalKeySet = new HashSet<char>
                                                            {
                                                                'a', 'b', 'c', 'd', 'e', 'f', 'g', 'h', 'i', 'j', 'k', 'l', 'm', 'n', 'o',
                                                                'p', 'q', 'r', 's', 't', 'u', 'v', 'w', 'x', 'y', 'z'
                                                            };

    private Dictionary<string, int> secretsCurrentMatches = new Dictionary<string, int>();

    //private string lastCharPress;

    private void Start()
    {
        secretsCurrentMatches = new Dictionary<string, int>();
        foreach (var registeredSecret in GameSettings.GameSecrets)
        {
            secretsCurrentMatches.Add(registeredSecret.Key, -1);
        }
    }

    private void Update()
    {
        /*
        Debug.Log("lastCharPress: " + lastCharPress);
        if (!String.IsNullOrEmpty(lastCharPress) && Input.GetKeyUp(lastCharPress))
        {
            lastCharPress = String.Empty;
        }
         * */
    }

    private char lastCharPressed;
    private void OnGUI()
    {
        var e = Event.current;

        if (e.isKey)
        {
            HandleSecretCodeInput(e.character);

            var character = Char.ToLower(e.character);

            if (AnyKeyPressed != null)
            {
                AnyKeyPressed(this, new KeyPressedEventArgs(character));
            }

            if (alphabeticalKeySet.Contains(character) && AlphabeticalKeyPressed != null)
            {
                // It's a letter key.
                AlphabeticalKeyPressed(this, new KeyPressedEventArgs(character));
            }

            int numberKey;
            bool isKeyNumeric = int.TryParse(character.ToString(CultureInfo.InvariantCulture), out numberKey);
            if (isKeyNumeric && NumberPressed != null)
            {
                // It's number key.
                NumberPressed(this, new NumberKeyPressedEventArgs(numberKey));
            }
        }
    }

    void HandleSecretCodeInput(char character)
    {
            var currenyCharacterASCII = Encoding.ASCII.GetBytes(character.ToString(CultureInfo.InvariantCulture))[0];
            if (currenyCharacterASCII != 0)
            {
                var buffer = new List<string>(secretsCurrentMatches.Keys);
                foreach (var secretCode in buffer)
                {
                    if (secretsCurrentMatches[secretCode] >= secretCode.Length - 1)
                    {
                        // This code has alreaady been activated, so skip it
                        continue;
                    }

                    if (secretCode[secretsCurrentMatches[secretCode] + 1] == character)
                    {
                        // Succesful character match
                        secretsCurrentMatches[secretCode]++;
                    }
                    else
                    {
                        secretsCurrentMatches[secretCode] = -1; // reset
                    }

                    if (secretsCurrentMatches[secretCode] == secretCode.Length - 1)
                    {
                        // Activated a secret!

                        var secret = GameSettings.GameSecrets[secretCode];
                        GameSettings.ActivatedSecrets.Add(secret);

                        if (SecretUnlocked != null)
                        {
                            SecretUnlocked(this, new SecretUnlockedEventArgs(secret));
                        }
                    }
                }
            }

            if (currenyCharacterASCII != 0 && lastCharPressed != character)
            {
                lastCharPressed = character;
            }

        
    }
}