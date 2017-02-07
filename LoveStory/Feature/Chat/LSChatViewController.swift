//
//  LSChatViewController.swift
//  LoveStory
//
//  Created by songlong on 2017/1/18.
//  Copyright © 2017年 com.Saber. All rights reserved.
//

import UIKit
import HyphenateLite

class LSChatViewController: EaseMessageViewController, EaseMessageViewControllerDataSource {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.dataSource = self
        let btn = UIButton(frame: CGRect(x: 0, y: 0, width: 100, height: 40))
        btn.addTarget(self, action: #selector(LSChatViewController.popToHome), for: .touchUpInside)
        btn.backgroundColor = LSMainColor
        navigationController?.navigationBar.addSubview(btn)
        navigationController?.interactivePopGestureRecognizer?.isEnabled = false
        showRefreshHeader = true
        
    }
    
    
    
    
    
    func popToHome() {
        self.tabBarController?.selectedIndex = 0
    }
    
    func messageViewController(_ viewController: EaseMessageViewController!, modelFor message: EMMessage!) -> IMessageModel! {
    
        let user = LSUser.currentUser()
        
        var model: IMessageModel? = nil
        model = EaseMessageModel(message: message)
        if  message.direction == EMMessageDirectionSend {
            model?.avatarURLPath = user?.user_avator
            model?.nickname = user?.user_name
        } else {
            model?.avatarURLPath = user?.user_coupleAvator
            model?.nickname = user?.user_coupleName
        }

        return model!
    }
}
