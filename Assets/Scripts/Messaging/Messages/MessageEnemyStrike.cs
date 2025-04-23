
public class MessageEnemyStrike : Message {

	public IEnemy Enemy;

	public MessageEnemyStrike(IEnemy enemy) : base("game") {
		Enemy = enemy;

        Send();
	}

}


