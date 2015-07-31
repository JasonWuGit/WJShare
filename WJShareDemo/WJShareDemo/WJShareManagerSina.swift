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
    
    func genDictionary(message:WJShareMessage) -> Dictionary<String, AnyObject> {
        
        func genTextDictionary(text:String) -> Dictionary<String, AnyObject> {
            let dic = [
                "__class" : "WBMessageObject",
                "text" : text
            ]
            
            return dic
        }
        
        func genImageDictionary(message:WJShareMessage) -> Dictionary<String, AnyObject> {
            
            let dic = [
                    "__class" : "WBMessageObject",
                    "text" : message.messageTitle ,
                    "imageObject" : NSDictionary(object: message.messageImage!, forKey: "imageData")
                ]
            
            return dic
        }
        
        func genLinkDictionary(message:WJShareMessage) -> Dictionary<String, AnyObject> {
            
            let mediaObj:NSDictionary = NSDictionary(dictionary: [
                "__class" : "WBWebpageObject" ,
                "description" : message.messageDesc! ,
                "objectID" : "identifier1" ,
                "thumbnailData" : message.messageImage! ,
                "title" : message.messageTitle ,
                "webpageUrl" : message.messageLink!
                
                ])
            
            let dic = [
                    "__class" : "WBMessageObject" ,
                    "mediaObject" : mediaObj
                ]
            
            return dic
        }
        
        var dic = Dictionary<String, AnyObject>()
        
        switch (message.messageType) {
        case .Text:
            dic = genTextDictionary(message.messageTitle)
        case .Image:
            dic = genImageDictionary(message)
        case .Link:
            dic = genLinkDictionary(message)
        }
        
        return dic
        
    }
    
    
    func shareToWeiboWithMessage(message:WJShareMessage, callback:((Dictionary<String,String> , NSError?)->Void)?) -> Bool {
        
        let isOK = WJShareManager.prepareOpenWithCallbackKey(WJShareManagerSina.callbackKey, callback: callback)
        if isWeiBoInstalled() && isOK {
            
            //diction isn't anyobject so we use nsdictionary
            
            let uuid = NSUUID().UUIDString
            let transferObjectDic:NSDictionary = [
                "__class" : "WBSendMessageToWeiboRequest" ,
                "message" : genDictionary(message) ,
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
