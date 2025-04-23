using UnityEngine;
using System.Collections;

public enum PausedMenuScreens
{
    None,
    MainScreen,
    ControlsScreen,
    OptionsScreen,
    ScreenshotModeScreen
}

public class PausedMenuScreen : MenuScreen
{
    public PausedMenuScreens screenType;
}
