using System.Linq;
using UnityEngine;
using System.Collections;

public class MenuPanelBehaviour : MonoBehaviour
{
	public Transform menuCamera;
    public WebPlayerStreamer webPlayerStreamer;
    public KeyManager KeyManager;

    public UIButton newGameButton;
    public UIButton optionsButton;
    public UIButton creditsButton;
    public UIButton enduranceButton;

    public UIButton normalDifficultyButton;
    public UIButton hardDifficultyButton;
    public UIButton insaneDifficulty;

    public NoiseEffect cameraNoiseEffect;

    private MenuManager<MainMenuStates, StartMenuScreen> menuManager;

	void Start ()
	{
	    var buttons = FindObjectsOfType(typeof (UIButton)).Cast<UIButton>();
	    foreach (var button in buttons)
	    {
	        UIButton button1 = button;
	        UIEventListener.Get(button.gameObject).onHover += (go, state) =>
	        {
                if (state)
                {
                    UICamera.selectedObject = button1.gameObject;
                }
	        };
	    }

	    Time.timeScale = 1;
        Screen.lockCursor = false; // so that we have access to the mouse

        /*
	    var labels = GameObject.FindObjectsOfType(typeof (UILabel)).Cast<UILabel>();
	    foreach (var uiLabel in labels)
	    {
	        uiLabel.text = "LOL " + uiLabel.text + " LOL";
	    }
         */

        GameSettings.ActivatedSecrets.Clear();
	    KeyManager.SecretUnlocked += (sender, args) => StartCoroutine(KeyManager_SecretUnlocked(sender, args));

	    var startMenuScreens = FindObjectsOfType(typeof (StartMenuScreen)).Cast<StartMenuScreen>().ToDictionary(screen => screen.screenType);
        menuManager = new MenuManager<MainMenuStates, StartMenuScreen>(startMenuScreens, false);
	    menuManager.OnLastScreenBack += (sender, args) => Application.Quit();

	    var backButtons = GameObject.FindGameObjectsWithTag("BackButton");
	    foreach (GameObject backButton in backButtons)
	    {
	        UIEventListener.Get(backButton).onClick += go => menuManager.BackScreen();
	    }

        UIEventListener.Get(creditsButton.gameObject).onClick += go => menuManager.ForwardScreen(MainMenuStates.CreditsScreen);
	    UIEventListener.Get(newGameButton.gameObject).onClick += go => menuManager.ForwardScreen(MainMenuStates.GameSelectionScreen);
	    UIEventListener.Get(optionsButton.gameObject).onClick += go => menuManager.ForwardScreen(MainMenuStates.OptionsScreen);
	    UIEventListener.Get(enduranceButton.gameObject).onClick += go => menuManager.ForwardScreen(MainMenuStates.DifficultyScreen);

	    UIEventListener.Get(normalDifficultyButton.gameObject).onClick += go => SelectDifficulty(85);
	    UIEventListener.Get(hardDifficultyButton.gameObject).onClick += go => SelectDifficulty(95);
	    UIEventListener.Get(insaneDifficulty.gameObject).onClick += go => SelectDifficulty(100);

        menuManager.ForwardScreen(MainMenuStates.NewGameScreen);
	}

    IEnumerator KeyManager_SecretUnlocked(object sender, SecretUnlockedEventArgs e)
    {
        Debug.Log("Unlocked secret: " + e.Secret);
        audio.Play();
        yield return new WaitForSeconds(5);

        if (e.Secret == SecretCode.NewGame)
        {
            SelectDifficulty(75);
        }
    }

    private void SelectDifficulty(float difficulty)
    {
        // Since we've chosen the difficulty, load the new level
        GameSettings.Difficulty = difficulty;
        cameraNoiseEffect.enabled = false;
        webPlayerStreamer.LoadLevel("Two_original");
    }

    private void Update()
    {
        if (Input.GetKeyDown("escape"))
        {
            menuManager.BackScreen();
        }
    }
void OnKey (KeyCode key)
{
    Debug.Log("Key: " + key);
}
}
