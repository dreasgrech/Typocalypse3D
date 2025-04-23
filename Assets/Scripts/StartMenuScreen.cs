using UnityEngine;
using System.Collections;

public enum MainMenuStates
{
    None,
    NewGameScreen,
    DifficultyScreen,
    CreditsScreen,
    OptionsScreen,
    GameSelectionScreen,
}

public class StartMenuScreen : MenuScreen
{
    public MainMenuStates screenType;
}
