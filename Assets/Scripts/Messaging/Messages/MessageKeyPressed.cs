
public class MessageKeyPressed : Message {

	public string Key;

	public MessageKeyPressed(string key) : base("typing") {
		Key = key;

	    Send();
	}
}
