
public class MessageWordCompleted : Message {

    //public IEnemy Enemy { get; set; }
    public WordType WordType { get; set; }
    public object Entity { get; set; }
    public bool WasEnemyKilled { get; set; }
    public string Word { get; set; }

	public MessageWordCompleted(WordType wordType, object entity, bool wasEnemyKilled, string word) : base("game")
	{
	    WordType = wordType;
	    Entity = entity;
	    WasEnemyKilled = wasEnemyKilled;
	    Word = word;

	    Send();
	}
}

