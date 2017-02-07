//
//  PublishViewModel.swift
//  LoveStory
//
//  Created by songlong on 2017/1/11.
//  Copyright © 2017年 com.Saber. All rights reserved.
//

import UIKit

class PublishViewModel: NSObject {
    lazy var publishList = [PublishModel]()
    
    func loadPublishData(finished: @escaping (_ isSuccessed: Bool) -> ()) {

        LSNetworking.sharedInstance.request(method: .GET, URLString: API_GET_PUBLISH, parameters: ["user_account": LSUser.currentUser()?.user_account], success: { (task, responseObject) in
            
            let dic = responseObject as! NSDictionary
            
            guard let array = dic["data"] as? [[String: AnyObject]] else {
                finished(false)
                return
            }
            
            var dataList = [PublishModel]()
            
            for dict in array {
                dataList.append(PublishModel(dict: dict))
            }
            
            self.publishList = dataList
            
            finished(true)
            
            
        }, failure: { (task, error) in
            finished(false)
        })
        
    }
    
    
}
