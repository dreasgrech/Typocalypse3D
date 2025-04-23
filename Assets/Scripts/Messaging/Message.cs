
/*
* Base class for messages sent through the messenger
*/
public abstract class Message 
{
	public string listenerType;
	public string functionName;

    protected Message(string type)
	{
		listenerType = type;
		
		// function name for MessageMyMessage becomes _MyMessage()
		functionName = "_" + GetType().ToString().Substring(7);
	}

    protected void Send()
    {
		// actually send the message
		Messenger.instance.Send(this);
    }
}