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
        
        var shareUrl = "mqqapi://share/to_fri?thirdAppDisplayName=" + WJShareManager.base64Encode(WJShareManager.appName)!
        shareUrl += "&version=1"
        shareUrl += "&cflag=" + "\(to)" //0代表分享到好友 /1代表分享到空间
        shareUrl += "&callback_type=scheme"
        shareUrl += "&generalpastboard=1"
        shareUrl += "&callback_name=\(WJShareManager.callbackSchemeURLDic[WJShareManagerQQ.callBackKey]!)"//String(format: "QQ%02llx",("1104618501" as NSString).longLongValue) QQ check this as appID
        shareUrl += "&src_type=app"
        shareUrl += "&shareType=0"
        
        if message.messageType == WJMessageType.Text { //just share text
            shareUrl += "&file_type=text"
            shareUrl += "&file_data=" + WJShareManager.base64Encode(message.messageTitle)!
        } else if message.messageType == WJMessageType.Image { //share with image
            
            let dataDic = [
                "file_data":message.messageImage!,
                "previewimagedata":message.messageImage!
            ]
            
            WJShareManager.setGeneralPasteboardWithKey("com.tencent.mqq.api.apiLargeData", value: dataDic, encoding: SMPboardEncoding.SMPboardEncodingKeyedArchiver)
            
            shareUrl += "&file_type=img"
            shareUrl += "&title=" + WJShareManager.base64Encode(message.messageTitle)!
            shareUrl += "&objectlocation=pasteboard"
            shareUrl += "&description=" + WJShareManager.base64Encode(message.messageDesc!)!
            
        } else if message.messageType == WJMessageType.Link { //share with link
            
            let dataDic = ["previewimagedata" : message.messageImage!]
            WJShareManager.setGeneralPasteboardWithKey("com.tencent.mqq.api.apiLargeData", value: dataDic, encoding: SMPboardEncoding.SMPboardEncodingKeyedArchiver)
            shareUrl += "&file_type=news"
            shareUrl += "&title=" + WJShareManager.base64AndUrlEncode(message.messageTitle)
            shareUrl += "&url=" + WJShareManager.base64AndUrlEncode(message.messageLink!)
            shareUrl += "&description=" + WJShareManager.base64AndUrlEncode(message.messageDesc!)
            shareUrl += "&objectlocation=pasteboard"
            
        }
        
        return shareUrl
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
