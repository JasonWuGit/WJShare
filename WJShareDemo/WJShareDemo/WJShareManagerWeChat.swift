//
//  WJShareManagerWeChat.swift
//  WJShareDemo
//
//  Created by JasonWu on 7/29/15.
//  Copyright (c) 2015 JasonWu. All rights reserved.
//

import UIKit

class WJShareManagerWeChat {
    
    
    static var callbackKey = "WeChat"
    
    func isWeChatInstalled() -> Bool {
        let url = NSURL(string:"weixin://")
        return WJShareManager.isInstalledURL(url!)
    }
    
    
    //0---session   1---friends   2---favorite
    func genShareUrlTo(to:Int, message:WJShareMessage) -> String {
        
        var dic : Dictionary<String, AnyObject> = [
            "result" : "1",
            "returnFromApp" : "0",
            "scene" : "\(to)",
            "sdkver" : "1.5",
            "command" : "1010"
        ]
        
        if message.messageType == WJMessageType.Text { //text
            
            dic["command"] = "1020"
            dic["title"] = message.messageTitle
            
        } else if message.messageType == WJMessageType.Image { //image
            
            dic["fileData"] = message.messageImage!
            dic["thumbData"] = message.messageImage!
            dic["objectType"] = "2"
            
        } else if message.messageType == WJMessageType.Link {
            
            dic["description"] = message.messageDesc!
            dic["mediaUrl"] = message.messageLink!
            dic["objectType"] = "5"
            dic["thumbData"] = message.messageImage!
            dic["title"] = message.messageTitle
            
        }
        let callbackURL:String = WJShareManager.callbackSchemeURLDic[WJShareManagerWeChat.callbackKey]!
        let data = NSPropertyListSerialization.dataWithPropertyList([ callbackURL :dic], format: NSPropertyListFormat.BinaryFormat_v1_0, options: 0, error: nil)
        
        UIPasteboard.generalPasteboard().setData(data!, forPasteboardType: "content")
        
        let url = "weixin://app/\(callbackURL)/sendreq/?"
        
        return url
    }
    
    func shareToWeChatFriendsWithMessage(message:WJShareMessage, callback:((Dictionary<String,String> , NSError?)->Void)?) -> Bool {
        
        let isOk = WJShareManager.prepareOpenWithCallbackKey(WJShareManagerWeChat.callbackKey, callback: callback)
        if isWeChatInstalled() && isOk {
            
            let shareUrl = genShareUrlTo(1, message: message)
            WJShareManager.openURL(NSURL(string: shareUrl)!)
            
            return true
        }
        
        return false
    }
    

   
}
