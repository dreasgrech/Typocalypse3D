using System;
using System.Collections.Generic;
using System.Linq;
using UnityEngine;
using Random = System.Random;

public class SBag<T>
{
    public bool Circular { get; set; }
    public bool HasMore { get { return currentElements.Count > 0; } }
    public int TotalCount { get { return originalElements.Count; } }

    private List<T> currentElements;
    private readonly List<T> originalElements;

    public SBag(IEnumerable<T> collection, bool circular = true)
    {
        Circular = circular;
        originalElements = collection.ToList();
        currentElements = new List<T>(originalElements);
    }

    public T GetElement(IEnumerable<T> whichIsNot, Func<T, T, bool> areEqualComparer)
    {
        if (Circular && currentElements.Count == 0)
        {
            currentElements = new List<T>(originalElements);
        }

        var w = whichIsNot.ToList();

        //var filtered = currentElements.Where(cu => !w.Any(w2 => cu.Equals(w2))).ToList();
        var filtered = currentElements.Where(cu => !w.Any(w2 => areEqualComparer(cu, w2))).ToList();

        // there's nothing available to return
        if (filtered.Count == 0)
        {
            Debug.LogWarning("Returning null because there's nothing we can use?");
            return default(T);
        }

        return Fetch(filtered);
    }

    public T GetElement()
    {
        if (Circular && currentElements.Count == 0)
        {
            currentElements = new List<T>(originalElements);
        }

        return Fetch(currentElements);
    }

    private Random r = new Random();
    private T Fetch(List<T> currentElementsSubset)
    {
        if (currentElementsSubset.Count == 0)
        {
            return default(T);
        }

        // get a random number in the range of the given set
        var random = r.Next(0, currentElementsSubset.Count-1);

        // take the element at that index
        var element = currentElementsSubset[random];

        // find the index of that element from the current set of elements
        var properIndex = currentElements.Select((v, i) => new {ce = v, index = i}).First(t => t.ce.Equals(element)).index;

        // remove that element from the current set of elements
        currentElements.RemoveAt(properIndex);

        return element;
    }
}