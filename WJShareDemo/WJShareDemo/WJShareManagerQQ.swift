//
//  WJShareManagerQQ.swift
//  WJShareDemo
//
//  Created by JasonWu on 7/29/15.
//  Copyright (c) 2015 JasonWu. All rights reserved.
//

import UIKit

class WJShareManagerQQ {
    
    static var callBackKey = "QQ"
    
    init() {
    }
    
    func isQQInstalled() -> Bool {
        
        let url = NSURL(string: "mqqapi://")
        return WJShareManager.isInstalledURL(url!)
        
    }
    
    func genShareURLTo(to:Int ,Message message:WJShareMessage) -> String {
        
        
        func genBasicShareURL(to:Int) -> String {
            
            var basicURL = "mqqapi://share/to_fri?thirdAppDisplayName=" + WJShareManager.base64Encode(WJShareManager.appName)!
            basicURL += "&version=1"
            basicURL += "&cflag=" + "\(to)" //0代表分享到好友 /1代表分享到空间
            basicURL += "&callback_type=scheme"
            basicURL += "&generalpastboard=1"
            basicURL += "&callback_name=\(WJShareManager.callbackSchemeURLDic[WJShareManagerQQ.callBackKey]!)"//QQ check this as appID
            basicURL += "&src_type=app"
            basicURL += "&shareType=0"

            return basicURL
        }
        
        func genTextShareURL(text:String) -> String {
            
            let textShareURL = "&file_type=text&file_data=" + WJShareManager.base64Encode(message.messageTitle)!
            
            return textShareURL
        }
        
        func genImageShareURL(message:WJShareMessage) -> String {
            
            let dataDic = [
                "file_data":message.messageImage!,
                "previewimagedata":message.messageImage!
            ]
            
            WJShareManager.setGeneralPasteboardWithKey("com.tencent.mqq.api.apiLargeData", value: dataDic, encoding: SMPboardEncoding.SMPboardEncodingKeyedArchiver)
            
            let imageShareURL = "&file_type=img&title=" + WJShareManager.base64Encode(message.messageTitle)! + "&objectlocation=pasteboard&description=" + WJShareManager.base64Encode(message.messageDesc!)!
            
            return imageShareURL
        }
        
        func genLinkShareURL(message:WJShareMessage) -> String {
            
            let dataDic = ["previewimagedata" : message.messageImage!]
            WJShareManager.setGeneralPasteboardWithKey("com.tencent.mqq.api.apiLargeData", value: dataDic, encoding: SMPboardEncoding.SMPboardEncodingKeyedArchiver)
            
            var linkShareURL = "&file_type=news&title=" + WJShareManager.base64AndUrlEncode(message.messageTitle)
            linkShareURL += "&url=" + WJShareManager.base64AndUrlEncode(message.messageLink!)
            linkShareURL += "&description=" + WJShareManager.base64AndUrlEncode(message.messageDesc!)
            linkShareURL += "&objectlocation=pasteboard"
            
            return linkShareURL
        }
        
        var shareURL = genBasicShareURL(to)
        
        switch (message.messageType) {
            
        case .Text:
            shareURL += genTextShareURL(message.messageTitle)
        case .Image:
            shareURL += genImageShareURL(message)
        case .Link:
            shareURL += genLinkShareURL(message)
        }
        
        return shareURL
    }
    
    func shareToQQZoneWithMessage(message:WJShareMessage, callBack:((Dictionary<String,String> , NSError?)->Void)?) -> Bool {
        
        let isOk = WJShareManager.prepareOpenWithCallbackKey(WJShareManagerQQ.callBackKey, callback: callBack)
        if isQQInstalled() && isOk{
            
            var shareUrl = genShareURLTo(1,Message: message)
            WJShareManager.openURL(NSURL(string:shareUrl)!)
            
            return true
        }
        
        return false
    }
    
    func shareToQQFriendWithMessage(message:WJShareMessage, callback:((Dictionary<String,String> , NSError?)->Void)?) -> Bool {
        let isOk = WJShareManager.prepareOpenWithCallbackKey(WJShareManagerQQ.callBackKey, callback: callback)
        if isQQInstalled() && isOk{
            
            var shareUrl = genShareURLTo(0,Message: message)
            WJShareManager.openURL(NSURL(string:shareUrl)!)
            
            return true
        }
        
        return false
    }
    

   
}
