using System.Collections.Generic;
using UnityEngine;
using System.Collections;

public class ShuffleBag<T>
{
    private List<T> data;

    private T currentItem;
    private int currentPosition = -1;

    private int Capacity
    {
        get { return data.Capacity; }
    }

    public int Size
    {
        get { return data.Count; }
    }

    public ShuffleBag()
    {
        data = new List<T>();
    }

    public void Add(T item, int amount)
    {
        for (int i = 0; i < amount; i++)
        {
            data.Add(item);
        }

        currentPosition = Size - 1;
    }

    public T Next()
    {
        if (currentPosition < 1)
        {
            currentPosition = Size - 1;
            currentItem = data[0];

            return currentItem;
        }

        var pos = Random.Range(0, currentPosition);

        currentItem = data[pos];
        data[pos] = data[currentPosition];
        data[currentPosition] = currentItem;
        currentPosition--;

        return currentItem;
    }
}