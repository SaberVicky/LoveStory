//
//  LSChatManager.swift
//  LoveStory
//
//  Created by songlong on 2017/1/22.
//  Copyright © 2017年 com.Saber. All rights reserved.
//

import UIKit
import HyphenateLite

class LSChatManager: NSObject {
    
    public class func chatRegister(account: String) -> Bool {
        let error = EMClient.shared().register(withUsername: account, password: HuanXinPassword)
        if error == nil {
            LSPrint("注册环信成功")
            return true
    
        } else {
            LSPrint("注册环信失败")
            return false
        }
    }

    public class func chatInit() {
        let option = EMOptions.init(appkey: "1143170105178612#lovestory")
        option?.apnsCertName = "lovestoryTest"
        let error = EMClient.shared().initializeSDK(with: option)
        if error == nil {
            LSPrint("环信初始化成功")
        } else {
            LSPrint("环信初始化失败")
        }
    }
    
    public class func chatLogin() {
        let user = LSUser.currentUser()
        
        let error = EMClient.shared().login(withUsername: user?.user_account, password: HuanXinPassword)
        if error == nil {
            LSPrint("登录成功")
            EMClient.shared().setApnsNickname(user?.user_name)
            EMClient.shared().pushOptions.displayStyle = EMPushDisplayStyle(rawValue: 1)
            if EMClient.shared().updatePushOptionsToServer() != nil {
                LSPrint("更换推送样式失败")
            } else {
                LSPrint("更换推送样式成功")
            }
        } else {
            LSPrint("登录失败")
        }
    }
}
