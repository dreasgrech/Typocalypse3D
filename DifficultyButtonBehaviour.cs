using UnityEngine;

public class DifficultyButtonBehaviour : MonoBehaviour
{
    public float difficulty;

    private void OnClick() {
        new MessageDifficultyButtonPressed(difficulty);
    }
}