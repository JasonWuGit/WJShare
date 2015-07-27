//
//  ShareManager.swift
//  KuaiZhanManager
//
//  Created by JasonWu on 7/16/15.
//  Copyright (c) 2015 JasonWu. All rights reserved.
//

import UIKit

enum SMPboardEncoding {
    case SMPboardEncodingKeyedArchiver
    case SMPboardEncodingPropertyListSerialization
}

enum ShareToType {
    case ShareToQQ
    case ShareToQQZone
}

enum MessageType {
    case Text
    case Image
    case Link
}

struct ShareMessage {
    var messageType:MessageType
    var messageTitle:String //if messageType=Text then title is text what you want to share
    var messageImage:NSData?
    var messageDesc:String?
    var messageLink:String?//if messageType = Link then link is must not empty
    
    init(messageType type:MessageType, title:String) {
        messageType = type
        messageTitle = title
    }
    
}

class ShareManager {
    
    static let appName: String = NSBundle.mainBundle().infoDictionary!["CFBundleName"] as! String
    static var callBackDic = Dictionary< String, (Dictionary<String,String>, NSError?)->Void >()
    static let bundleID = NSBundle.mainBundle().infoDictionary!["CFBundleIdentifier"] as! String
    static var appIDDic:Dictionary<String,String> = [:]
    static var callbackSchemeURLDic:Dictionary<String, String> = [:]
    
    // MARK: - Connect
    
    class func connectWithQQAppID(appid:String) {
        appIDDic[ShareManagerQQ.callBackKey] = appid
        let scheme = String(format: "QQ%02llx",("1104618501" as NSString).longLongValue).uppercaseString
        callbackSchemeURLDic[ShareManagerQQ.callBackKey] = scheme
        
        NSLog("请添加 \(scheme) 到scheme URL 中")
    }
    
    class func connectWithWeiboAppID(appid:String) {
        appIDDic[ShareManagerSina.callbackKey] = appid
        callbackSchemeURLDic[ShareManagerQQ.callBackKey] = "wb\(appid)"
        
        NSLog("请添加 wb\(appid) 到scheme URL 中")
    }
    
    class func connectWithWechatAppID(appid:String) {
        appIDDic[ShareManagerWeChat.callbackKey] = appid
        callbackSchemeURLDic[ShareManagerWeChat.callbackKey] = appid
        
        NSLog("请添加 \(appid) 到scheme URL 中")
    }
    
    // MARK: - Open URL
    
    class func isInstalledURL(url:NSURL) -> Bool {
        return UIApplication.sharedApplication().canOpenURL(url)
    }
    
    class func openURL(url:NSURL) {
        UIApplication.sharedApplication().openURL(url)
    }
    
    class func prepareOpenWithCallbackKey(key:String, callback:((Dictionary<String,String> , NSError?)->Void)?) -> Bool {
        
        if let appid = appIDDic[key] {
            
            if let handler = callback {
                ShareManager.callBackDic[key] = handler
            } else {
                ShareManager.callBackDic[key] = nil
            }

            return true
        }
        
        NSLog("请连接app id")
        
        return false
    }
    
    //MARK: - Decode and Encode
    
    class func base64Encode(input:String) -> String? {
        let data = input.dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: false)
        return data?.base64EncodedStringWithOptions(NSDataBase64EncodingOptions(rawValue: 0))
    }
    
    class func base64Decode(input:String) -> String? {
        let data = NSData(base64EncodedString: input, options:NSDataBase64DecodingOptions(rawValue: 0))
        return String( NSString(data: data!, encoding: NSUTF8StringEncoding)!)
    }
    
    class func base64AndUrlEncode(input:String)->String {
        let str = ShareManager.base64Encode(input)
        return str!.stringByAddingPercentEncodingWithAllowedCharacters(NSCharacterSet.URLHostAllowedCharacterSet())!
    }
    
    class func urlDecode(input:String)->String {
       return input.stringByReplacingOccurrencesOfString("+", withString: " ", options: NSStringCompareOptions.LiteralSearch, range: nil).stringByReplacingPercentEscapesUsingEncoding(NSUTF8StringEncoding)!
    }
    
    //MARK: - PastBoard
    
    class func setGeneralPasteboardWithKey(key:String, value:Dictionary<String,NSData>, encoding:SMPboardEncoding) {
        
        var data: NSData
        var error: NSErrorPointer
        
        switch encoding {
        case .SMPboardEncodingKeyedArchiver:
            data = NSKeyedArchiver.archivedDataWithRootObject(value)
        case .SMPboardEncodingPropertyListSerialization:
            data = NSPropertyListSerialization.dataWithPropertyList(value, format: NSPropertyListFormat.BinaryFormat_v1_0, options: 0, error: nil)!
        }
        
        
        UIPasteboard.generalPasteboard().setData(data, forPasteboardType: key)
        
    }
    
    //MARK: - CallBack
    
    class func analysisUrl(url:NSURL) -> Dictionary<String, String> {
        
        var returnedDic = Dictionary<String, String>()
        let strings = url.query?.componentsSeparatedByString("&")
        
        if let strs = strings {
            for string in strs {
                
                let range = string.rangeOfString("=")
                if !range!.isEmpty {
                    returnedDic[string.substringToIndex(range!.startIndex)] = string.substringFromIndex(range!.endIndex)
                }
                
            }
        }
        
        return returnedDic
    }
    
    class func handleCallBackURL(url:NSURL) {
        
        let closure = { (url:NSURL) -> (dic:Dictionary<String,String>, error:NSError?) in
            
            let dic = ShareManager.analysisUrl(url)
            if let errorStr = dic["error"] {
                let error = NSError(domain: errorStr, code: -1, userInfo: nil)
                
                return (dic,error)
            }
            
            return (dic, nil)
        }
        
        
        if url.scheme!.hasPrefix("QQ") {
            if let callBack = ShareManager.callBackDic[ShareManagerQQ.callBackKey] {
                let result = closure(url)
                callBack(result.dic, result.error)
            }
            
        } else if url.scheme!.hasPrefix("wx") {
            if let callBack = ShareManager.callBackDic[ShareManagerWeChat.callbackKey] {
                let result = closure(url)
                callBack(result.dic, result.error)
            }
        } else if url.scheme!.hasPrefix("wb") {
            if let callBack = ShareManager.callBackDic[ShareManagerSina.callbackKey] {
                let result = closure(url)
                callBack(result.dic, result.error)
            }

        }
        
    }
    
    //MARK: - ShareMessage
    
    
   
}
