using System;
using System.Collections.Generic;
using Assets.Scripts;
using UnityEngine;
using System.Collections;

public class KongregateBrainAPI : MonoBehaviour
{
    /*
     * ?debug_level=4
     * 
     * Read before publishing: http://developers.kongregate.com/docs/single-player/statistics-api-tips
     */

    public KongregateAPI kongregateApi;
    public UITexture kongregateTexture;
    public UILabel kongregatePlayerNameLabel;

    public KongregateUserInfo UserInfo { get; set; }

    private void Start()
    {
        if (KongregateAPI.InEditor)
        {
            Debug.Log("Not using Kongregate API because currently we're in the editor");
            return;
        }

        kongregateApi.InitiateAPI(info =>
                                      {
                                          if (info.IsGuest)
                                          {
                                              Debug.Log("Guest playing atm");
                                              return;
                                          }

                                          Debug.Log("User ID: " + info.UserId);
                                          Debug.Log("Username : " + info.Username);

                                          ShowImage(info.Username);
                                      });
    }

    private void ShowImage(string username)
    {
        if (GlobalVariables.KongregateUserInfo != null)
        {
            if (GlobalVariables.KongregateUserInfo.AvatarTexture != null)
            {
                kongregateTexture.mainTexture = GlobalVariables.KongregateUserInfo.AvatarTexture;
            }

            if (GlobalVariables.KongregateUserInfo.Username != null)
            {
                kongregatePlayerNameLabel.text = GlobalVariables.KongregateUserInfo.Username;
            }

            return;
        }

        kongregateApi.QueryUserInfo(username, info =>
        {
            if (info == null)
            {
                return;
            }

            UserInfo = info;
            GlobalVariables.KongregateUserInfo = info;

            kongregatePlayerNameLabel.text = info.Username;
            kongregateApi.DownloadTexture(info.AvatarUrl, t => kongregateApi.DownloadTexture(UserInfo.AvatarUrl, texture =>
            {
                kongregateTexture.mainTexture = texture;
                GlobalVariables.KongregateUserInfo.AvatarTexture = texture;
            }));
        });
    }
}
