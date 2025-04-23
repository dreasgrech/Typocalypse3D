using System.Reflection;
using System.Text;
using UnityEngine;
using System;
using System.Linq;
using System.Collections.Generic;

[AddComponentMenu("Library/Messenger")]
public class Messenger : MonoBehaviour {

    /*
    * Script to manage updating components when certain game events happen - for 
    * instance when cars are spawned, deleted, etc
    */
    Dictionary<string, List<GameObject>> listeners;

    // spew debug info to console for each message
    public bool showDebug = false;

    public static Messenger instance;
    public static Messenger use;

    /**
    * Adds a listener for a particular type of message
    */
    public void Listen(string listenerType, GameObject go)
    {
        if (!listeners.ContainsKey(listenerType))
        {
            listeners.Add(listenerType, new List<GameObject>());
        }

        var list = listeners[listenerType];

        if (!list.Contains(go))
        {
           list.Add(go); 
        }
    }

    public void Send(Message message)
    {
        if (listeners.ContainsKey(message.listenerType))
        {
            // get our list (will be null if unknown type or no listeners registered)
            var list = listeners[message.listenerType];

            for (var i = 0; i < list.Count; ++i)
            {
                var listener = list[i];
                if (listener != null)
                {
                    listener.SendMessage(message.functionName, message, SendMessageOptions.DontRequireReceiver);
                } else
                {
                    // scrub nulls
                    list.RemoveAt(i);
                    i--;
                }
            }
        }
        
        if (showDebug)
        {
            var type = message.GetType();
            var fis = type.GetFields();

            // loop all of our fields
            var data = new StringBuilder();
            foreach (FieldInfo fi in fis)
            {
                var value = fi.GetValue(message) ?? "NULL";
                data.AppendLine(String.Format("{0}: {1}", fi.Name, value));
            }

            // build up a list of recipients
            string sentTo = String.Empty;
            var total = 0;
            if (listeners.ContainsKey(message.listenerType))
            {
                var list = listeners[message.listenerType];
                sentTo = String.Join(", ", list.Select(go => go.name).ToArray());

                total = list.Count;
            }

            Debug.Log(String.Format("MSG {0} ({1}) sent to {2} objects\n{3}\n{4}",
                message.functionName,
                message.listenerType,
                total,
                sentTo,
                data));
				
        }
    }

    private void Awake()
    {
        listeners = new Dictionary<string, List<GameObject>>();
        // make the instance available if one isn't already
        if (instance == null)
        {
            instance = this;
            use = this;
        }
        else
        {
            Destroy(gameObject);
        }

        DontDestroyOnLoad(this);
    }

    /**
    * Register implicitly with this instead of gameObject
    */
    private void Listen(string listenerType, Component component)
    {
        Listen(listenerType, component.gameObject);
    }

    /**
    * Removes a listener for the specified type of message
    */
    private void StopListen(string listenerType, GameObject go)
    {
        if (listeners.ContainsKey(listenerType))
        {
            var list = listeners[listenerType];
            list.Remove(go);
        }
    }

}
