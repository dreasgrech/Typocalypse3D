using UnityEngine;
using System.Collections;

/// <summary>
/// TODO: needs to be renamed to MessagePowerupContainerTyped
/// </summary>
public class MessagePowerupTyped : Message
{
    public CratePowerupBehaviour CratePowerup { get; private set; }
    public bool WasPowerupDestroyed { get; private set; }
    public string PowerupWord { get; private set; }
    public bool ShouldPlayerShoot { get; set; }

    // Use this for initialization
    public MessagePowerupTyped(CratePowerupBehaviour cratePowerup, bool wasPowerupDestroyed, string powerupWord, bool shouldPlayerShoot) : base("game")
    {
        CratePowerup = cratePowerup;
        WasPowerupDestroyed = wasPowerupDestroyed;
        PowerupWord = powerupWord;
        ShouldPlayerShoot = shouldPlayerShoot;
        Send();
    }
}

public class MessageC4Typed : Message
{
    /*
    public C4Behaviour c4Powerup { get; private set; }
    public bool WasPowerupDestroyed { get; private set; }
    public string PowerupWord { get; private set; }
    public bool ShouldPlayerShoot { get; set; }
    */
    public string Text { get; set; }
    // Use this for initialization
    public MessageC4Typed(string text) : base("game")
    {
        Text = text;
        Send();
    }
}