using System.Collections.Generic;
using UnityEngine;
using System.Collections;

public interface IEnemy : IHUDTextEnabled
{
    bool Dead { get; }
    string Text { get; set;  }
    Vector3 Position { get; }
    Vector3 WordPosition { get; }
    Stack<string> WordsLeft { get; }

    EnemySettings Settings { get; }
    bool WillKeyMatch(char key);
    bool ShouldDieImmediately(EnemyDiedReason reason);
    void ApplyDamage(EnemyDiedReason howTheEnemyDied, int bulletsFired, Vector3 hitWorldPosition);
    void SetWords(IEnumerable<string> words);
    void Obliterate();
    void HighlightWord();
    void StopWalking();
}