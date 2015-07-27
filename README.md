# WJShare
本人在做ios开发的时候通常都会遇见一个需求那就是要求实现分享功能虽然不需要所有的社交平台但是基本的社交平台还是需要的比如说QQ、微信、微博等这些都是基本的要求。于是在我们便要去各个平台的开发者中心下载sdk然后集成到自己的app中，有时候就连SDK都会比我们的App都要大。
然而在用oc开发iOS的时候还有OpenShare可以使用，但是最近swift的发展迅速。本人也在用swift开发公司项目的时候，要求实现分享功能同时老大也要求不要使用SDK于是本人硬着头皮就研究了OpenShare终于完成了swift版本的OpenShare。由于swift和oc的语法相差比较大所以使用的方式也是不太一样，另有不足之处还请多多指出
# 功能
当前版本只实现了比较简单的功能:
* QQ空间和QQ好友的文本分享，图片分享和链接分享
* 微信朋友圈的分享文本分享，图片分享和链接分享
* 微博的分享文本分享，图片分享和链接分享

当然更加多的功能会在后续中添加
# 如何使用
在将文件添加到你的项目中后，就可以使用了:
#### 链接appID
使用shareManager的类方法
    
    class func connectWithWeiboAppID(appid:String) //链接微博的appid
    class func connectWithQQAppID(appid:String) //链接QQ的appID
    class func connectWithWechatAppID(appid:String) //链接微信的appID
    
运行后在控制台得到提示:

![image](https://github.com/JasonWuGit/WJShare/blob/master/Image/schemeURL.png)
#### 添加Scheme URL
将从控制台得到的URL添加到项目的info.plist中

![image](https://github.com/JasonWuGit/WJShare/blob/master/Image/plist.png)
#### 分享
构造Message

    sm = ShareMessage(messageType: MessageType.Link, title: "测试") //消息的title
    sm.messageImage = NSData(data:  UIImagePNGRepresentation(UIImage(named: "logo-2"))) //消息的图片
    sm.messageDesc = "image Description" //消息的描述
    sm.messageLink = "http://www.baidu.com" //链接消息时的链接
    
调用方法进行分享

    let shareQQ = ShareManagerQQ()
    shareQQ.shareToQQZoneWithMessage(sm) { (dic :Dictionary<String, String>, error :NSError?) -> Void in
        NSLog("\(dic)")
    }
    


