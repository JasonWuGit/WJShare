//
//  ShareManagerQQ.swift
//  KuaiZhanManager
//
//  Created by JasonWu on 7/17/15.
//  Copyright (c) 2015 JasonWu. All rights reserved.
//

import UIKit

class ShareManagerQQ {

    static var callBackKey = "QQ"
    
    init() {
    }
    
    func isQQInstalled() -> Bool {
        
        let url = NSURL(string: "mqqapi://")
        return ShareManager.isInstalledURL(url!)
        
    }
    
    func genShareURLTo(to:Int ,Message message:ShareMessage) -> String {
        
        var shareUrl = "mqqapi://share/to_fri?thirdAppDisplayName=" + ShareManager.base64Encode(ShareManager.appName)!
        shareUrl += "&version=1"
        shareUrl += "&cflag=" + "\(to)" //0代表分享到好友 /1代表分享到空间
        shareUrl += "&callback_type=scheme"
        shareUrl += "&generalpastboard=1"
        shareUrl += "&callback_name=\(ShareManager.callbackSchemeURLDic[ShareManagerQQ.callBackKey]!)"//String(format: "QQ%02llx",("1104618501" as NSString).longLongValue) QQ check this as appID
        shareUrl += "&src_type=app"
        shareUrl += "&shareType=0"
        
        if message.messageType == MessageType.Text { //just share text
            shareUrl += "&file_type=text"
            shareUrl += "&file_data=" + ShareManager.base64Encode(message.messageTitle)!
        } else if message.messageType == MessageType.Image { //share with image
            
            let dataDic = [
                "file_data":message.messageImage!,
                "previewimagedata":message.messageImage!
            ]
            
            ShareManager.setGeneralPasteboardWithKey("com.tencent.mqq.api.apiLargeData", value: dataDic, encoding: SMPboardEncoding.SMPboardEncodingKeyedArchiver)
            
            shareUrl += "&file_type=img"
            shareUrl += "&title=" + ShareManager.base64Encode(message.messageTitle)!
            shareUrl += "&objectlocation=pasteboard"
            shareUrl += "&description=" + ShareManager.base64Encode(message.messageDesc!)!
            
        } else if message.messageType == MessageType.Link { //share with link
            
            let dataDic = ["previewimagedata" : message.messageImage!]
            ShareManager.setGeneralPasteboardWithKey("com.tencent.mqq.api.apiLargeData", value: dataDic, encoding: SMPboardEncoding.SMPboardEncodingKeyedArchiver)
            shareUrl += "&file_type=news"
            shareUrl += "&title=" + ShareManager.base64AndUrlEncode(message.messageTitle)
            shareUrl += "&url=" + ShareManager.base64AndUrlEncode(message.messageLink!)
            shareUrl += "&description=" + ShareManager.base64AndUrlEncode(message.messageDesc!)
            shareUrl += "&objectlocation=pasteboard"
            
        }
        
        return shareUrl
    }
    
    func shareToQQZoneWithMessage(message:ShareMessage, callBack:((Dictionary<String,String> , NSError?)->Void)?) -> Bool {
        
        let isOk = ShareManager.prepareOpenWithCallbackKey(ShareManagerQQ.callBackKey, callback: callBack)
        if isQQInstalled() && isOk{
            
            var shareUrl = genShareURLTo(1,Message: message)
            ShareManager.openURL(NSURL(string:shareUrl)!)
            
            return true
        }
        
        return false
    }
    
    func shareToQQFriendWithMessage(message:ShareMessage, callback:((Dictionary<String,String> , NSError?)->Void)?) -> Bool {
        let isOk = ShareManager.prepareOpenWithCallbackKey(ShareManagerQQ.callBackKey, callback: callback)
        if isQQInstalled() && isOk{
            
            var shareUrl = genShareURLTo(0,Message: message)
            ShareManager.openURL(NSURL(string:shareUrl)!)
            
            return true
        }
        
        return false
    }
    
}
