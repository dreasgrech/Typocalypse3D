using System;
using System.Collections.Generic;
using UnityEngine;

public class MenuScreenChangedEventArgs<T> : EventArgs 
{
    public T OldScreen { get; set; }
    public T NewScreen { get; set; }

    public MenuScreenChangedEventArgs(T oldScreen, T newScreen)
    {
        OldScreen = oldScreen;
        NewScreen = newScreen;
    }
}

public class MenuManager<T, TK> where TK : MenuScreen where T : struct, IConvertible // T is the enum
{
    public bool ExitFromFirstScreen { get; set; }
    public event EventHandler<EventArgs> OnLastScreenBack;
    public event EventHandler<MenuScreenChangedEventArgs<T>> MenuScreenChanged;

    private readonly Stack<T> screenStates;
    private readonly Dictionary<T, TK> screens;

    public MenuManager(Dictionary<T, TK> menuScreens, bool exitFromFirstScreen)
    {
        ExitFromFirstScreen = exitFromFirstScreen;
        screenStates = new Stack<T>();
        screens = menuScreens;

        HideAllScreens();
    }

    private void HideAllScreens()
    {
        foreach (var screen in screens)
        {
            screen.Value.HideScreen(true);
        }
    }

    public void BackScreen(bool instant = false)
    {
        if (screenStates.Count - 1 <= 0)
        {
            if (OnLastScreenBack != null)
            {
                OnLastScreenBack(this, EventArgs.Empty);
            }

            if (screenStates.Count == 1 && ExitFromFirstScreen)
            {
                HideCurrentScreen(instant);
            }

            return;
        }

        var currentScreen = HideCurrentScreen(instant);

        var newScreen = screenStates.Peek();
        ChangeScreen(newScreen, instant);

        if (MenuScreenChanged != null)
        {
            MenuScreenChanged(this, new MenuScreenChangedEventArgs<T>(currentScreen, newScreen));
        }
    }

    public void ForwardScreen(T newScreenType, bool instant = false)
    {
        // If the current screen is the screen the method caller wants to transition to, just ignore him (he's an idiot anyways)...
        if (screenStates.Count > 0 && screenStates.Peek().Equals(newScreenType))
        {
            return;
        }

        // If we're entering the menu, make sure to hide all screens prior to showing the first one
        if (screenStates.Count == 0)
        {
            HideAllScreens();
        }

        ChangeScreen(newScreenType, instant);

        T currentScreenType = default(T);
        if (screenStates.Count > 0)
        {
            currentScreenType = screenStates.Peek();
            var currentScreen = screens[currentScreenType];
            currentScreen.HideScreen(instant);
        }

        screenStates.Push(newScreenType);

        if (MenuScreenChanged != null)
        {
            MenuScreenChanged(this, new MenuScreenChangedEventArgs<T>(currentScreenType, newScreenType));
        }
    }

    private void ChangeScreen(T newScreenType, bool instant = false)
    {
        var newScreen = screens[newScreenType];
        newScreen.ShowScreen(instant);
    }

    private T HideCurrentScreen(bool instant = false)
    {
        var currentScreen = screenStates.Pop();
        screens[currentScreen].HideScreen(instant);
        return currentScreen;
    }
}