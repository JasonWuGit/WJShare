//
//  WJShareManagerSina.swift
//  WJShareDemo
//
//  Created by JasonWu on 7/29/15.
//  Copyright (c) 2015 JasonWu. All rights reserved.
//

import UIKit

class WJShareManagerSina {
    
    static let callbackKey = "weibo"
    
    func isWeiBoInstalled() -> Bool {
        let url = NSURL(string: "weibosdk://request")
        return WJShareManager.isInstalledURL(url!)
    }
    
    
    func shareToWeiboWithMessage(message:WJShareMessage, callback:((Dictionary<String,String> , NSError?)->Void)?) -> Bool {
        
        let isOK = WJShareManager.prepareOpenWithCallbackKey(WJShareManagerSina.callbackKey, callback: callback)
        if isWeiBoInstalled() && isOK {
            
            //diction isn't anyobject so we use nsdictionary
            var dic:NSDictionary = [:]
            
            if message.messageType == WJMessageType.Text {
                
                dic = [
                    "__class" : "WBMessageObject",
                    "text" : message.messageTitle
                ]
                
            } else if message.messageType == WJMessageType.Image {
                
                dic = [
                    "__class" : "WBMessageObject",
                    "text" : message.messageTitle ,
                    "imageObject" : NSDictionary(object: message.messageImage!, forKey: "imageData")
                ]
                
            } else if message.messageType == WJMessageType.Link {
                
                var mediaObj:NSDictionary = NSDictionary(dictionary: [
                    "__class" : "WBWebpageObject" ,
                    "description" : message.messageDesc! ,
                    "objectID" : "identifier1" ,
                    "thumbnailData" : message.messageImage! ,
                    "title" : message.messageTitle ,
                    "webpageUrl" : message.messageLink!
                    
                    ])
                
                dic = [
                    
                    "__class" : "WBMessageObject" ,
                    "mediaObject" : mediaObj
                ]
                
                
            }
            
            let uuid = NSUUID().UUIDString
            let transferObjectDic:NSDictionary = [
                "__class" : "WBSendMessageToWeiboRequest" ,
                "message" : dic ,
                "requestID" : uuid
            ]
            
            
            let transferObject = NSKeyedArchiver.archivedDataWithRootObject(transferObjectDic)
            let messageArray:Array< NSDictionary > = [
                
                ["transferObject" : transferObject],
                ["userInfo" : NSKeyedArchiver.archivedDataWithRootObject([:])],
                
                ["app" : NSKeyedArchiver.archivedDataWithRootObject([
                    "appKey" : WJShareManager.appIDDic[WJShareManagerSina.callbackKey]!,
                    "bundleID" : WJShareManager.bundleID
                    ])]
                
            ]
            
            UIPasteboard.generalPasteboard().items = messageArray
            let urlStr = "weibosdk://request?id=\(uuid)&sdkversion=003013000"
            
            
            WJShareManager.openURL(NSURL(string: urlStr)!)
            return true
        }
        
        return false
    }
    

   
}
