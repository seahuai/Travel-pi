//
//  AppDelegate.swift
//  旅行派
//
//  Created by 张思槐 on 16/10/23.
//  Copyright © 2016年 zhangsihuai. All rights reserved.
//

import UIKit
import SVProgressHUD

var EMisLogin: Bool = false

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, EMChatManagerDelegate, EMClientDelegate, EMContactManagerDelegate {

    var window: UIWindow?
    private lazy var mapManager: BMKMapManager = {
        let manager = BMKMapManager()
        return manager
        
    }()

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        SVProgressHUD.setDefaultStyle(.dark)
        let globalColor = UIColor(colorLiteralRed: 27/255, green: 166/255, blue: 197/255, alpha: 1)
        UITabBar.appearance().tintColor = globalColor
        UINavigationBar.appearance().tintColor = globalColor
        //MARK:百度地图SDK初始化
        let ret = mapManager.start("Fc4Ej7HrDAzFzGH9x2STZrQPBmfVitgy", generalDelegate: nil)
        if ret {
            print("授权成功")
        }else{
            print("授权失败")
        }
        
        //MARK:环信SDK初始化
        let options = EMOptions(appkey: "1146161129115990#travelpi")
        options?.apnsCertName = nil
        let error = EMClient.shared().initializeSDK(with: options)
        if error == nil{
            print("环信初始化成功")
        }else{
            print(error!.errorDescription)
        }
        
        EMClient.shared().add(self)
        EMClient.shared().chatManager.add(self)
        EMClient.shared().contactManager.add(self)
        
        
        //MARK:友盟分享
        
        //微信 wxdc1e388c3822c80b
        //QQ:
        /*
         如appID：100424468 
         1、tencent100424468
         2、QQ05fc5b14
         */
        
        /*微博
         App Key：2613235658
         App Secret：eabfe16da6079e5a15ce37349f7f3416
         */
        
        UMSocialManager.default().umSocialAppkey = "58a29f082ae85b1f8d000b35"
        UMSocialGlobal.shareInstance().isUsingHttpsWhenShareContent = false
        //微信
        if UMSocialManager.default().setPlaform(.wechatSession, appKey: "wxdc1e388c3822c80b", appSecret: "3baf1193c85774b3fd9d18447d76cab0", redirectURL: "http://mobile.umeng.com/social"){
            print("微信分享注册成功")
        }else{
            print("微信分享注册失败")
        }
        
        if UMSocialManager.default().setPlaform(.wechatTimeLine, appKey: "wxdc1e388c3822c80b", appSecret: "3baf1193c85774b3fd9d18447d76cab0", redirectURL: "http://mobile.umeng.com/social"){
            print("微信分享注册成功")
        }else{
            print("微信分享注册失败")
        }
        //QQ
        if UMSocialManager.default().setPlaform(.QQ, appKey: "100424468", appSecret: nil, redirectURL: "http://mobile.umeng.com/social"){
            print("QQ分享注册成功")
        }else{
            print("QQ分享注册失败")
        }
        //微博
        if UMSocialManager.default().setPlaform(.sina, appKey: "2613235658", appSecret: "eabfe16da6079e5a15ce37349f7f3416", redirectURL: "http://mobile.umeng.com/social"){
            print("微博分享注册成功")
        }else{
            print("微博分享注册失败")
        }
        
        
        
        return true
    }
    
    func application(_ application: UIApplication, handleOpen url: URL) -> Bool {
        let result = UMSocialManager.default().handleOpen(url)
        if !result{
            print("回调失败\(url)")
        }
        return true
    }
    
    //MARK:消息监听
    func messagesDidReceive(_ aMessages: [Any]!) {
        //处理badgeValue等
//        ProfileViewController.shared.newMessage = true
        Account.shared.newMessage = true
    }
    
    //MARK:好友申请监听
    func friendRequestDidReceive(fromUser aUsername: String!, message aMessage: String!) {
        let request = friendRequest(userId: aUsername, reason: aMessage)
//        ProfileViewController.shared.newRequest = true
        Account.shared.newRequest = true
        Account.shared.friendRequests.append(request)
    }
    
    //MARK:自动登录相关
    func autoLoginDidCompleteWithError(_ aError: EMError!) {
        if aError == nil{
            EMisLogin = true
        }else{
            EMisLogin = false
        }
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        EMClient.shared().applicationDidEnterBackground(application)
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        EMClient.shared().applicationWillEnterForeground(application)
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }

}

