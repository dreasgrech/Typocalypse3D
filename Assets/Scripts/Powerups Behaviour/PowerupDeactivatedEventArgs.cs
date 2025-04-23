using System;

public class PowerupDeactivatedEventArgs : EventArgs
{
    public BasePowerup DeactivatedPowerup { get; private set; }

    public PowerupDeactivatedEventArgs(BasePowerup deactivatedPowerup)
    {
        DeactivatedPowerup = deactivatedPowerup;
    }
}