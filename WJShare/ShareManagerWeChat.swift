//
//  ShareManagerWeChat.swift
//  KuaiZhanManager
//
//  Created by JasonWu on 7/21/15.
//  Copyright (c) 2015 JasonWu. All rights reserved.
//

import UIKit

class ShareManagerWeChat{
    
    static var callbackKey = "WeChat"
    
    func isWeChatInstalled() -> Bool {
        let url = NSURL(string:"weixin://")
        return ShareManager.isInstalledURL(url!)
    }
    
    
    //0---session   1---friends   2---favorite
    func genShareUrlTo(to:Int, message:ShareMessage) -> String {
        
        var dic : Dictionary<String, AnyObject> = [
            "result" : "1",
            "returnFromApp" : "0",
            "scene" : "\(to)",
            "sdkver" : "1.5",
            "command" : "1010"
        ]
        
        if message.messageType == MessageType.Text { //text
            
            dic["command"] = "1020"
            dic["title"] = message.messageTitle
            
        } else if message.messageType == MessageType.Image { //image
            
            dic["fileData"] = message.messageImage!
            dic["thumbData"] = message.messageImage!
            dic["objectType"] = "2"
            
        } else if message.messageType == MessageType.Link {
            
            dic["description"] = message.messageDesc!
            dic["mediaUrl"] = message.messageLink!
            dic["objectType"] = "5"
            dic["thumbData"] = message.messageImage!
            dic["title"] = message.messageTitle
            
        }
        let callbackURL:String = ShareManager.callbackSchemeURLDic[ShareManagerWeChat.callbackKey]!
        let data = NSPropertyListSerialization.dataWithPropertyList([ callbackURL :dic], format: NSPropertyListFormat.BinaryFormat_v1_0, options: 0, error: nil)
        
        UIPasteboard.generalPasteboard().setData(data!, forPasteboardType: "content")
        
        let url = "weixin://app/\(callbackURL)/sendreq/?"
        
        return url
    }
    
    func shareToWeChatFriendsWithMessage(message:ShareMessage, callback:((Dictionary<String,String> , NSError?)->Void)?) -> Bool {
        
        let isOk = ShareManager.prepareOpenWithCallbackKey(ShareManagerWeChat.callbackKey, callback: callback)
        if isWeChatInstalled() && isOk {
            
            let shareUrl = genShareUrlTo(1, message: message)
            ShareManager.openURL(NSURL(string: shareUrl)!)
            
            return true
        }
        
        return false
    }
    
   
}
