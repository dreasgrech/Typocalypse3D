using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using UnityEngine;
using System.Collections;

public static class HomelessMethods {

    public static T GetRandomElement<T>(this IList<T> elements)
    {
        return elements.ElementAt(UnityEngine.Random.Range(0, elements.Count));
    }

    public static string ToHex(this Color32 color)
    {
        return color.r.ToString("X2") + color.g.ToString("X2") + color.b.ToString("X2");
    }
    
    public static Color ChangeAlpha(this Color color, float alpha)
    {
        return new Color(color.r, color.g, color.b, alpha);
    }

    public static T GetRandomWeightedElement<T>(this IEnumerable<IWeighable> entities)
    {
        var entitiesList = entities.ToList();
        var weightSum = entitiesList.Sum(entity => entity.Weight);
        var random = UnityEngine.Random.Range(0, weightSum);
        var sum = 0f;

        foreach (var powerup in entitiesList)
        {
            sum += powerup.Weight;
            if (sum > random)
            {
                return (T)powerup;
            }
        }

        throw new Exception("An entity must always be chosen");
    }

    public static void SetLayerRecursively(GameObject go, int layerNumber)
    {
        foreach (Transform trans in go.GetComponentsInChildren<Transform>(true))
        {
            trans.gameObject.layer = layerNumber;
        }
    }

    public static void Shuffle<T>(this IList<T> list) {
        int n = list.Count;
        while (n > 1) {
            int k = (UnityEngine.Random.Range(0, n) % n);
            n--;
            T value = list[k];
            list[k] = list[n];
            list[n] = value;
        }
    }
    public static void ChangeAnimationSpeed(this Animation animation, float newSpeed) {
		foreach (AnimationState state in animation) {
		    state.speed = newSpeed;
		}
	}

    public static string TransposeString(string text, int index1, int index2)
    {
        var sb = new StringBuilder(text);
        var index1Cache = text[index1];
        sb[index1] = sb[index2];
        sb[index2] = index1Cache;

        return sb.ToString();
    }

    public static IEnumerator InvokeInSeconds<T>(float time, Action<T> invoke, T parameter)
    {
        yield return new WaitForSeconds(time);
        invoke(parameter);
    }

    /// <summary>
    /// Lets you get custom class from components (like custom interfaces)
    /// </summary>
    /// <typeparam name="T"></typeparam>
    /// <param name="transform"></param>
    /// <returns></returns>
    public static T GetCustomComponent<T>(this Transform transform) where T : class
    {
        return transform.GetComponent(typeof (T)) as T;
    }

    public static IEnumerator InvokeInSeconds(float time, Action invoke)
    {
        yield return new WaitForSeconds(time);
        invoke();
    }

    public static IList<T> Swap<T>(this IList<T> list, int indexA, int indexB)
    {
        T tmp = list[indexA];
        list[indexA] = list[indexB];
        list[indexB] = tmp;
        return list;
    }

    public static float Map(float s, float a1, float a2, float b1, float b2)
    {
        return b1 + (s-a1)*(b2-b1)/(a2-a1);
    }

    public static Vector3 ReplaceY(this Vector3 vector3, float value)
    {
        return new Vector3(vector3.x, value, vector3.z);
    }

    public static Vector3 ReplaceX(this Vector3 vector3, float value)
    {
        return new Vector3(value, vector3.y, vector3.z);
    }

    public static Vector3 ReplaceZ(this Vector3 vector3, float value)
    {
        return new Vector3(vector3.x, vector3.y, value);
    }

    //private static float lastRealTime = 0f;
    public static IEnumerator Interpolate<T>(T start, T end, float time, Func<T, T, float, T> interpolate, Action<T> step, Action callback = null)
    {
        /*
            iTween.ValueTo(new GameObject(), iTween.Hash("from", start, "to", end, "time", time, "onUpdate", (Action<object>) (value => step((T) value)), "ignoretimescale", true, "oncomplete", (Action<object>) (value =>
            {
                if(callback != null)
                {
                    callback();
                }
            })));

        yield return null;
        */

        float i = 0.0f, rate = (float) (1.0/time);
        while (i < 1.0)
        {
            i += Time.deltaTime*rate;
            step(interpolate(start, end, i));
            yield return null; 
        }

        if (callback != null)
        {
            callback();
        }
    }

    public static IEnumerator LerpOne(float start, float end, float time, Action<float> step, Action callback = null)
    {
        var i = 0.0f;
        var rate = 1.0/time;
        while (i < 1.0)
        {
            i += (float) (Time.deltaTime*rate);
            step(Mathf.Lerp(start, end, i));
            yield return null; 
        }

        if (callback != null)
        {
            callback();
        }
    }
}
