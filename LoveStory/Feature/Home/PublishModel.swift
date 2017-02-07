//
//  PublishModel.swift
//  LoveStory
//
//  Created by songlong on 2017/1/11.
//  Copyright © 2017年 com.Saber. All rights reserved.
//

import UIKit

class PublishModel: NSObject {
    
    var time: String?
    var avator_url: String?
    var content: String?
    var reply_count: Int? = 0
    var publish_id: Int? = 0
    
    init(dict: [String: AnyObject]) {
        super.init()
        time = dict["time"] as? String
        content = dict["content"] as? String
        
        let timeString = Double(time!)
        let date = Date(timeIntervalSince1970: timeString!)
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy年MM月dd日 HH:mm"
        time = formatter.string(from: date)
        
        avator_url = dict["avator"] as? String
        reply_count = dict["reply_count"] as? Int
        publish_id = dict["publish_id"] as? Int
    }
}
