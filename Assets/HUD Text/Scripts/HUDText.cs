//--------------------------------------------
//            NGUI: HUD Text
// Copyright © 2012 Tasharen Entertainment
//--------------------------------------------

using System;
using System.Globalization;
using System.Linq;
using UnityEngine;
using System.Collections.Generic;

/// <summary>
/// HUD text creates temporary on-screen text entries that are perfect for damage, effects, and messages.
/// </summary>

[AddComponentMenu("NGUI/Examples/HUD Text")]
public class HUDText : MonoBehaviour
{
	protected class Entry
	{
		public float time;			// Timestamp of when this entry was added
		public float stay = 0f;		// How long the text will appear to stay stationary on the screen
		public float offset = 0f;	// How far the object has moved based on time
		public float val = 0f;		// Optional value (used for damage)
		public UILabel label;		// Label on the game object
		public bool floatUpNextFrame;		// Label on the game object

		public float movementStart { get { return time + stay; } }
	}

	/// <summary>
	/// Sorting comparison function.
	/// </summary>

	static int Comparison (Entry a, Entry b)
	{
		if (a.movementStart < b.movementStart) return -1;
		if (a.movementStart > b.movementStart) return 1;
		return 0;
	}

	/// <summary>
	/// Font that will be used to create labels.
	/// </summary>

	public UIFont font;

	/// <summary>
	/// Effect applied to the text.
	/// </summary>

	public UILabel.Effect effect = UILabel.Effect.None;

	/// <summary>
	/// Curve used to move entries with time.
	/// </summary>

	public AnimationCurve offsetCurve = new AnimationCurve(new Keyframe[] { new Keyframe(0f, 0f), new Keyframe(3f, 40f) });

	/// <summary>
	/// Curve used to fade out entries with time.
	/// </summary>

	public AnimationCurve alphaCurve = new AnimationCurve(new Keyframe[] { new Keyframe(1f, 1f), new Keyframe(3f, 0f) });

	/// <summary>
	/// Curve used to scale the entries.
	/// </summary>

	public AnimationCurve scaleCurve = new AnimationCurve(new Keyframe[] { new Keyframe(0f, 0f), new Keyframe(0.25f, 1f) });

	List<Entry> mList = new List<Entry>();
	List<Entry> mUnused = new List<Entry>();

	int counter = 0;

	/// <summary>
	/// Whether some HUD text is visible.
	/// </summary>

	public bool isVisible { get { return mList.Count != 0; } }

	/// <summary>
	/// Create a new entry, reusing an old entry if necessary.
	/// </summary>

	Entry Create (float time)
	{
		// See if an unused entry can be reused
		if (mUnused.Count > 0)
		{
			Entry ent = mUnused[mUnused.Count - 1];
			mUnused.RemoveAt(mUnused.Count - 1);
		    ent.time = time;
			ent.label.depth = NGUITools.CalculateNextDepth(gameObject);
			NGUITools.SetActive(ent.label.gameObject, true);
			ent.offset = 0f;
			mList.Add(ent);
			return ent;
		}
		
		// New entry
		Entry ne = new Entry {time = time, label = NGUITools.AddWidget<UILabel>(gameObject)};
	    ne.label.name = counter.ToString();
		ne.label.effectStyle = effect;
		ne.label.font = font;

		// Make it small so that it's invisible to start with
		ne.label.cachedTransform.localScale = new Vector3(0.01f, 0.01f, 0.01f);
		mList.Add(ne);
		++counter;
		return ne;
	}

	/// <summary>
	/// Delete the specified entry, adding it to the unused list.
	/// </summary>

	void Delete (Entry ent)
	{
		mList.Remove(ent);
		mUnused.Add(ent);
		NGUITools.SetActive(ent.label.gameObject, false);
	}

    void LogIfCombo(string text)
    {
        if (name.Trim().ToLowerInvariant() == "combo")
        {
            Debug.Log(text);
        }
    }

    public void ResetCounter()
    {
        for (int i = mList.Count; i > 0; )
        {
            Entry ent = mList[--i];

            // If the entry has already started floating upwards, we don't want't to alter it's position anymore
            if (ent.offset > 0)
            {
                continue;
            }

            ent.floatUpNextFrame = true;
        }
    }

	/// <summary>
	/// Add a new scrolling text entry.
	/// </summary>
	public void Add (object obj, Color c, float stayDuration, string format = null, Func<int, bool> shouldShowText = null)
	{
		if (!enabled) return;

		float time = Time.realtimeSinceStartup;
		bool isNumeric = false;
		float val = 0f;

		if (obj is float)
		{
			isNumeric = true;
			val = (float)obj;
		}
		else if (obj is int)
		{
			isNumeric = true;
			val = (int)obj;
		}

        if (isNumeric)
        {
            //if (val == 0f) return;

            for (int i = mList.Count; i > 0;)
            {
                Entry ent = mList[--i];
                //if (ent.time + 1 < time) 
                if (ent.time + stayDuration < time)
                {
                    //continue;
                }

                if (ent.offset > 0)
                {
                    continue;
                }

                if (ent.val != 0f)
                {
                    // agrech: in here I'm resetting the time if the value is being updated
                    ent.time = time;
                    ent.val += val;

                    var number = Mathf.RoundToInt(ent.val);
                    if (shouldShowText != null)
                    {
                        var shouldWe = shouldShowText(number);
                        if (!shouldWe)
                        {
                            //return;
                        }
                    }

                    var numberString = number.ToString(CultureInfo.InvariantCulture);
                    ent.label.text = string.IsNullOrEmpty(format) ? numberString : string.Format(format, numberString);
                    return;
                }
            }
        }

		// Create a new entry
		Entry ne = Create(time);
		ne.stay = stayDuration;
		ne.label.color = c;
		ne.val = val;

	    string value = string.IsNullOrEmpty(format) ? obj.ToString() : string.Format(format, obj);
        if (isNumeric)
        {
            var num = Mathf.RoundToInt(ne.val).ToString(CultureInfo.InvariantCulture);
            value = string.IsNullOrEmpty(format) ? num : string.Format(format, num);
        }

	    ne.label.text = value;

		// Sort the list
		mList.Sort(Comparison);
	}

	/// <summary>
	/// Disable all labels when this script gets disabled.
	/// </summary>
	void OnDisable()
	{
		for (int i = mList.Count; i > 0; )
		{
			Entry ent = mList[--i];
			if (ent.label != null) ent.label.enabled = false;
			else mList.RemoveAt(i);
		}
	}

	/// <summary>
	/// Update the position of all labels, as well as update their size and alpha.
	/// </summary>

	void Update ()
	{
		float time = Time.realtimeSinceStartup;

		Keyframe[] offsets = offsetCurve.keys;
		Keyframe[] alphas = alphaCurve.keys;
		Keyframe[] scales = scaleCurve.keys;

		float offsetEnd = offsets[offsets.Length - 1].time;
		float alphaEnd = alphas[alphas.Length - 1].time;
		float scalesEnd = scales[scales.Length - 1].time;
		float totalEnd = Mathf.Max(scalesEnd, Mathf.Max(offsetEnd, alphaEnd));

		// Adjust alpha and delete old entries
		for (int i = mList.Count; i > 0; )
		{
			Entry ent = mList[--i];
            if (ent.floatUpNextFrame)
            {
               ent.stay = time - ent.time;
               ent.floatUpNextFrame = false;
            }

			float currentTime = time - ent.movementStart;

			ent.offset = offsetCurve.Evaluate(currentTime);
			ent.label.alpha = alphaCurve.Evaluate(currentTime);

			// Make the label scale in
			float s = scaleCurve.Evaluate(time - ent.time) * ent.label.font.size;
			if (s < 0.001f) s = 0.001f;
			ent.label.cachedTransform.localScale = new Vector3(s, s, s);

			// Delete the entry when needed
			if (currentTime > totalEnd) Delete(ent);
			else ent.label.enabled = true;
		}

		float offset = 0f;

		// Move the entries
		for (int i = mList.Count; i > 0; )
		{
			Entry ent = mList[--i];
			offset = Mathf.Max(offset, ent.offset);
		    ent.label.cachedTransform.localPosition = new Vector3(0f, offset, 0f);
			offset += Mathf.Round(ent.label.cachedTransform.localScale.y);
		}
	}
}
