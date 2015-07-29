//
//  ViewController.swift
//  KuaiZhanManager
//
//  Created by JasonWu on 7/16/15.
//  Copyright (c) 2015 JasonWu. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    var sm:WJShareMessage
    
    init() {
        
        sm = WJShareMessage(messageType: WJMessageType.Link, title: "测试")
        sm.messageImage = NSData(data:  UIImagePNGRepresentation(UIImage(named: "logo-2")))
        sm.messageDesc = "image Description"
        sm.messageLink = "http://www.baidu.com"
        
        super.init(nibName: nil, bundle: nil)
        
    }

    required init(coder aDecoder: NSCoder) {
        
        sm = WJShareMessage(messageType: WJMessageType.Link, title: "测试")
        sm.messageImage = NSData(data:  UIImagePNGRepresentation(UIImage(named: "logo-2")))
        sm.messageDesc = "image Description"
        sm.messageLink = "http://www.baidu.com"
        
        super.init(coder: aDecoder)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        //在这里写入申请号的app id
        WJShareManager.connectWithWeiboAppID("2537818686")
        WJShareManager.connectWithWechatAppID("wxca350ac7c9b54c50")
        WJShareManager.connectWithQQAppID("1104618501")

        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func QQZoneShareTouch(sender: AnyObject) {
        
        let shareQQ = WJShareManagerQQ()
        shareQQ.shareToQQZoneWithMessage(sm) { (dic :Dictionary<String, String>, error :NSError?) -> Void in
            
            NSLog("\(dic)")
        }

    }

    @IBAction func QQFriendShareTouch(sender: AnyObject) {
        
        let shareQQ = WJShareManagerQQ()
        shareQQ.shareToQQFriendWithMessage(sm) { (dic :Dictionary<String, String>, error :NSError?) -> Void in
            
            NSLog("\(dic)")
        }

        
    }
    @IBAction func wechatShareTouch(sender: AnyObject) {
        
        let shareWeChat = WJShareManagerWeChat()
        shareWeChat.shareToWeChatFriendsWithMessage(sm) { (dic :Dictionary<String, String>, error :NSError?) -> Void in
            NSLog("\(dic)")
        }

        
    }
    @IBAction func weiboShareTouch(sender: AnyObject) {
        
        let shareSina = WJShareManagerSina()
        shareSina.shareToWeiboWithMessage(sm) { (dic :Dictionary<String, String>, error :NSError?) -> Void in
            NSLog("\(dic)")
        }

    }
    
        
        
//        let authData = [
//            "app_id" : "1104618501" ,
//            "app_name" : "KuaiZhanManager" ,
//            "client_id" : "1104618501" ,
//            "response_type" : "token" ,
//            "scope" : "get_user_info" ,
//            "sdkp" : "i" ,
//            "sdkv" : "2.9" ,
//            "status_machine" : UIDevice.currentDevice().model ,
//            "status_os" : UIDevice.currentDevice().systemVersion ,
//            "status_version" : UIDevice.currentDevice().systemVersion
//        ]
        

}

