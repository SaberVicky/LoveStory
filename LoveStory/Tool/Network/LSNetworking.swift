//
//  LSNetworking.swift
//  LoveStory
//
//  Created by songlong on 2016/12/27.
//  Copyright © 2016年 com.Saber. All rights reserved.
//

import UIKit
import AFNetworking

enum LSRequestMethod: String {
    case GET = "GET"
    case POST = "POST"
}

class LSNetworking: AFHTTPSessionManager {
    
    static let sharedInstance: LSNetworking = {
        let tools = LSNetworking(baseURL: URL(string: BASE_URL))
        tools.responseSerializer.acceptableContentTypes = NSSet(objects: "application/json", "text/json", "text/javascript", "text/plain", "text/html") as? Set<String>
        return tools
    }()
    
    
    func request(method: LSRequestMethod, URLString: String, parameters: Any?, success: ((URLSessionDataTask, AnyObject?) -> Void)?, failure: ((URLSessionDataTask?, Error) -> Void)?) {
        
        if (method == .GET) {
            get(URLString, parameters: parameters, progress: { (progress) in
                
            }, success: { (task, responseObject) in
                if responseObject != nil {
                    success!(task, responseObject as AnyObject?)
                }
            }, failure: { (task, error) in
                failure!(nil, error)
            })
        } else {
            post(URLString, parameters: parameters, progress: { (progress) in
                
            }, success: { (task, responseObject) in
                if responseObject != nil {
                    success!(task, responseObject as AnyObject?)
                }
            }, failure: { (task, error) in
                failure!(nil, error)
            })
        }
        
    }

}


