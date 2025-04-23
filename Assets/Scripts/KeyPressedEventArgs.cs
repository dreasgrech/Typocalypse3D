using UnityEngine;
using System.Collections;
using System.Collections.Generic;
using System;
using System.IO;
using System.Linq;

public class KeyPressedEventArgs : EventArgs
{
	public char Key { get; set; }

	public KeyPressedEventArgs(char key) {
		Key = key;
	}
}

public class NumberKeyPressedEventArgs : EventArgs
{
	public int Number { get; set; }

	public NumberKeyPressedEventArgs(int number)
	{
	    Number = number;
	}
}

public class SecretUnlockedEventArgs : EventArgs
{
    public SecretCode Secret { get; set; }

    public SecretUnlockedEventArgs(SecretCode secret)
	{
	    Secret = secret;
	}
}