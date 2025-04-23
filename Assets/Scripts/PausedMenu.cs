using System;
using System.Linq;
using UnityEngine;
using System.Collections;

public class PausedMenu : MonoBehaviour
{
    public UIButton resumeButton;
    public UIButton restartButton;
    public UIButton controlsButton;
    public UIButton optionsButton;
    public UIButton quitButton;
    public UIButton controlsBackButton;

    public UIPanel mainPanel;
    public UIPanel controlsPanel;
    public UITexture backgroundTexture;

    public float pausedVolume = 0.2f;
    public bool IsPaused { get; private set; }
    public bool CanWePause { get;  set; }
    public NoiseEffect cameraNoiseEffect;
    public AudioSource musicAudio;

    public UIPanel enemyWordsPanel;
    public UIPanel commonOverlayPanel;
    public UIPanel notificationsPanel;

    public GameObject hudPanel;
    public BlurEffect blurEffect;
    public GrayscaleEffect grayscaleEffect;
    public GameObject uiCamera;
    public UITexture powerupRightBoxesTexture;
    public SlowTimePowerup slowTimePowerup;

    private UIPanel pausedPanel;

    private float beforePauseVolume;
    private bool isTransitioning;
    private object transitioningLock = new object();
    private float originalGameMusicVolume;

    public event EventHandler<EventArgs> PausedMenuHidden;
    public event EventHandler<EventArgs> PausedMenuShown;

    private MenuManager<PausedMenuScreens, PausedMenuScreen> menuManager;
    private GameObject[] backButtons;
	void Start()
	{
	    originalGameMusicVolume = musicAudio.volume;

	    CanWePause = false;
	    var pausedScreens = FindObjectsOfType(typeof (PausedMenuScreen)).Cast<PausedMenuScreen>().ToDictionary(screen => screen.screenType);
        menuManager = new MenuManager<PausedMenuScreens, PausedMenuScreen>(pausedScreens, true);
        menuManager.MenuScreenChanged += menuManager_MenuScreenChanged;
        menuManager.OnLastScreenBack += menuManager_OnLastScreenBack;

	    pausedPanel = GetComponent<UIPanel>();
	    UIEventListener.Get(resumeButton.gameObject).onClick += go => menuManager.BackScreen();
        UIEventListener.Get(restartButton.gameObject).onClick += go =>
        {
            HideMenu();
            //Application.LoadLevel(Application.loadedLevelName);
            Application.LoadLevel("Two_original"); // It wasn't finding the level when I used Application.loadedLevelName...
        };

	    UIEventListener.Get(quitButton.gameObject).onClick += go => Application.LoadLevel("StartMenu");
	    UIEventListener.Get(controlsButton.gameObject).onClick += go => menuManager.ForwardScreen(PausedMenuScreens.ControlsScreen);
	    UIEventListener.Get(optionsButton.gameObject).onClick += go => menuManager.ForwardScreen(PausedMenuScreens.OptionsScreen);

	    backButtons = GameObject.FindGameObjectsWithTag("BackButton");
	    foreach (GameObject backButton in backButtons)
	    {
	        UIEventListener.Get(backButton).onClick += go => menuManager.BackScreen();
	    }

	    pausedPanel.alpha = 0;
        controlsBackButton.gameObject.SetActive(false);
	}

    void menuManager_OnLastScreenBack(object sender, System.EventArgs e)
    {
        HideMenu();
    }

    private float lastCheckedHudPowerupsPanelAlpha;
    void menuManager_MenuScreenChanged(object sender, MenuScreenChangedEventArgs<PausedMenuScreens> e)
    {
        cameraNoiseEffect.enabled = true;
        if (IsPaused)
        {
            if (e.NewScreen == PausedMenuScreens.ScreenshotModeScreen)
            {
                //uiCamera.SetActive(false);
                blurEffect.enabled = false;
                commonOverlayPanel.enabled = false;
            }

            if (e.OldScreen == PausedMenuScreens.ScreenshotModeScreen)
            {
                //uiCamera.SetActive(true);
                blurEffect.enabled = true;
                commonOverlayPanel.enabled = true;
            }


            if (e.NewScreen == PausedMenuScreens.ControlsScreen)
            {
                lastCheckedHudPowerupsPanelAlpha = powerupRightBoxesTexture.alpha;
                powerupRightBoxesTexture.alpha = 1;
                backgroundTexture.enabled = false;
                controlsBackButton.gameObject.SetActive(true);
                hudPanel.SetActive(true);
            }

            if (e.OldScreen == PausedMenuScreens.ControlsScreen)
            {
                powerupRightBoxesTexture.alpha = lastCheckedHudPowerupsPanelAlpha;
                backgroundTexture.enabled = true;
                controlsBackButton.gameObject.SetActive(false);
                hudPanel.SetActive(false);
            }
        }
    }

    private float originalPowerupBoxesAlpha;
    public void ShowMenu()
    {
        if (IsPaused || !CanWePause || slowTimePowerup.Active)
        {
            return;
        }

        lock (transitioningLock)
        {
            notificationsPanel.alpha = 0;
            grayscaleEffect.effectAmount = 1;
            blurEffect.enabled = true;
            hudPanel.SetActive(false);
            enemyWordsPanel.alpha = 0;
            cameraNoiseEffect.enabled = true;
            Screen.lockCursor = false;
            IsPaused = true;

            Time.timeScale = 0;
            pausedPanel.alpha = 1;
            commonOverlayPanel.alpha = 1;

            musicAudio.volume = originalGameMusicVolume*0.3f;
        }

        menuManager.ForwardScreen(PausedMenuScreens.MainScreen, true);
        originalPowerupBoxesAlpha = powerupRightBoxesTexture.alpha;
        powerupRightBoxesTexture.alpha = 0f;

        if (PausedMenuShown != null)
        {
            PausedMenuShown(this, EventArgs.Empty);
        }
    }

    private void HideMenu()
    {
        lock (transitioningLock)
        {
            notificationsPanel.alpha = 1;
            grayscaleEffect.effectAmount = 0;
            blurEffect.enabled = false;
            hudPanel.SetActive(true);
            enemyWordsPanel.alpha = 1;
            cameraNoiseEffect.enabled = false;
            isTransitioning = true;
            IsPaused = false;

            pausedPanel.alpha = 0;
            commonOverlayPanel.alpha = 0;
            Time.timeScale = 1;
            musicAudio.volume = originalGameMusicVolume;

            isTransitioning = false;
        }

        powerupRightBoxesTexture.alpha = originalPowerupBoxesAlpha;

        Screen.lockCursor = true;

        if (PausedMenuHidden != null)
        {
            PausedMenuHidden(this, EventArgs.Empty);
        }
    }

    private void Update()
    {
        if (Input.GetKeyDown("escape")|| Input.GetKeyDown("joystick button 9") /* START on PS3 Rock Band 3 Guitar */)
        {
            if (IsPaused)
            {
                menuManager.BackScreen();
            } else
            {
                ShowMenu();
            }
        }

        if (IsPaused && Input.GetKeyDown(KeyCode.KeypadEnter))
        {
            menuManager.ForwardScreen(PausedMenuScreens.ScreenshotModeScreen);
        }
    }

    /*
     * https://github.com/dreasgrech/Typocalypse3D/issues/115
     */

    void FadePanel(UIPanel panel, bool fadeIn)
    {
        float start = fadeIn ? 0 : 1, end = fadeIn ? 1 : 0;

        StartCoroutine(HomelessMethods.Interpolate(start, end, 1, InterpolationMethods.Lerp, f =>
        {
            panel.alpha = f;
        }));
    }
}
