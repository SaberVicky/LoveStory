//
//  LSReplyViewModel.swift
//  LoveStory
//
//  Created by songlong on 2017/2/6.
//  Copyright © 2017年 com.Saber. All rights reserved.
//

import UIKit

class LSReplyViewModel: NSObject {
    
    lazy var replyList = [LSReplyModel]()
    
    func loadReplyData(publish_id: Int, finished: @escaping (_ isSuccessed: Bool) -> ()) {
        
        LSNetworking.sharedInstance.request(method: .GET, URLString: API_GET_REPLY, parameters: ["publish_id": publish_id], success: { (task, responseObject) in
            
            let dic = responseObject as! NSDictionary
            
            guard let array = dic["data"] as? [[String: AnyObject]] else {
                finished(false)
                return
            }
            
            var dataList = [LSReplyModel]()
            
            for dict in array {
                dataList.append(LSReplyModel(dict: dict))
            }
            
            self.replyList = dataList
            
            finished(true)
            
            
        }, failure: { (task, error) in
            finished(false)
        })
        
    }
}
