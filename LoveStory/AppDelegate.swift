//
//  AppDelegate.swift
//  LoveStory
//
//  Created by songlong on 2016/12/26.
//  Copyright © 2016年 com.Saber. All rights reserved.
//

import UIKit
import SVProgressHUD
import HyphenateLite
import UserNotifications
import FMDB


@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, UNUserNotificationCenterDelegate, EMChatManagerDelegate {
    
//    lazy var player: AVAudioPlayer? = {
//        var player: AVAudioPlayer? = nil
//        do {
//            let path = Bundle.main.path(forResource: "sound", ofType: "wav")
//            player = try AVAudioPlayer(contentsOf: URL(string: path!)!)
//        } catch let error as NSError {
//            LSPrint(error)
//        }
//        return player
//    }()

    var window: UIWindow?
    var isFore = true

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        application.applicationIconBadgeNumber = 0
        setupFMDB()
        
        LSChatManager.chatInit()
        setupAPNS(application: application)
        EMClient.shared().chatManager.add(self, delegateQueue: nil)
        setupAppearance()
        
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.backgroundColor = .white;
        
        let user = LSUser.currentUser()
        if user?.user_coupleAccount != "" && user != nil {
            LSChatManager.chatLogin()
            
            window?.rootViewController = CustomTabBarViewController()
        } else {
            window?.rootViewController = LSLoginAndRegisterViewController()
        }
        window?.makeKeyAndVisible()
        
        return true
    }
    
    //发起本地推送
    func messagesDidReceive(_ aMessages: [Any]!) {
        
        let soundID = SystemSoundID(kSystemSoundID_Vibrate)
        AudioServicesPlaySystemSound(soundID)
        
        for message in aMessages {
            let message = message as! EMMessage
            LSPrint(message)
            
        }
        
        if isFore {
            return
        }
        
        LSPrint("收到了消息")
        let content = UNMutableNotificationContent()
        content.title = "Introduction to Notifications"
        content.subtitle = "Session 707"
        content.body = "Woah! These new notifications look amazing! Don’t you agree?"
        content.badge = 1
        content.sound = UNNotificationSound.default()
        
        let triger4 = UNTimeIntervalNotificationTrigger(timeInterval: 0.1, repeats: false)
        let requestId = "sampleRequest"
        let request = UNNotificationRequest(identifier: requestId, content: content, trigger: triger4)
        UNUserNotificationCenter.current().add(request, withCompletionHandler: {
            (error) in
            
        })
    }
    
    private func setupAPNS(application: UIApplication) {

        //注册APNS
        let notifiCenter = UNUserNotificationCenter.current()
        notifiCenter.delegate = self
        let types = UNAuthorizationOptions(arrayLiteral: [.alert, .badge, .sound])
        notifiCenter.requestAuthorization(options: types, completionHandler: { (flag, error) in
            if flag {
                LSPrint("注册APNS成功")
            }else{
                LSPrint("注册APNS失败")
            }
            
        })
        application.registerForRemoteNotifications()
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        
        let userInfo = response.notification.request.content.userInfo
        LSPrint("userInfo10:\(userInfo)")
        completionHandler()
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        
        let userInfo = notification.request.content.userInfo
        LSPrint("userInfo10:\(userInfo)")
        completionHandler([.sound,.alert])
    }
    
    
    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        LSPrint(error)
    }
    
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        EMClient.shared().bindDeviceToken(deviceToken)
    }
    
    private func setupAppearance() {
        SVProgressHUD.setMinimumDismissTimeInterval(1.5)
        UINavigationBar.appearance().tintColor = .white
        UITextField.appearance().tintColor = LSMainColor
        UITabBar.appearance().tintColor = LSMainColor
    }
    
   
    
    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
        EMClient.shared().applicationDidEnterBackground(application)
        isFore = false
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
        EMClient.shared().applicationWillEnterForeground(application)
        isFore = true
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }

    
    func setupFMDB() {
        LSDBManager.dbinit()
    }

}

