//
//  CustomTabBarViewController.swift
//  LoveStory
//
//  Created by songlong on 2016/12/26.
//  Copyright © 2016年 com.Saber. All rights reserved.
//

import UIKit
import HyphenateLite

class CustomTabBarViewController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupAllChildViewControllers()
    }

    private func setupAllChildViewControllers() {
        setupChildViewController(vc: HomeViewController(), title: "首页", imgName: "tabbar_home", selectedImgName: "tabbar_home_highlighted")
        
        setupChildViewController(vc: LSTempChatViewController(), title: "聊天", imgName: "tabbar_chat", selectedImgName: "tabbar_chat_highlighted")
        setupChildViewController(vc: LSMineViewController(), title: "我", imgName: "tabbar_profile", selectedImgName: "tabbar_profile_highlighted")
    }
    
    private func setupChildViewController(vc: UIViewController, title: String, imgName: String, selectedImgName: String) {
        vc.title = title;
        vc.tabBarItem.image = UIImage(named: imgName)
        vc.tabBarItem.selectedImage = UIImage(named: selectedImgName)
        let nav = CustionNavigationViewController(rootViewController: vc)
        addChildViewController(nav)
    }
    

    
}

