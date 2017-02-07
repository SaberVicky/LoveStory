//
//  LSTempChatViewController.swift
//  LoveStory
//
//  Created by songlong on 2017/1/19.
//  Copyright © 2017年 com.Saber. All rights reserved.
//

import UIKit
import HyphenateLite

class LSTempChatViewController: UIViewController {

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        let vc = LSChatViewController(conversationChatter: LSUser.currentUser()?.user_coupleAccount, conversationType: EMConversationTypeChat)
        vc?.title = "聊天"
        navigationController?.pushViewController(vc!, animated: false)
        

    }
}
