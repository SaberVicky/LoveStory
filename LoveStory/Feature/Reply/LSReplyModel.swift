//
//  LSReplyModel.swift
//  LoveStory
//
//  Created by songlong on 2017/2/6.
//  Copyright © 2017年 com.Saber. All rights reserved.
//

import UIKit

class LSReplyModel: NSObject {
    var time: String?
    var avator_url: String?
    var content: String?
    var account: String?
    
    init(dict: [String: AnyObject]) {
        super.init()
        time = dict["time"] as? String
        content = dict["content"] as? String
        
        let timeString = Double(time!)
        let date = Date(timeIntervalSince1970: timeString!)
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy年MM月dd日 HH:mm"
        time = formatter.string(from: date)
        
//        avator_url = dict["avator"] as? String
        avator_url = "http://ojae83ylm.bkt.clouddn.com/19343a60e16c11e69e6a5254005b67a6.png"
        account = dict["account"] as? String
    }
}
