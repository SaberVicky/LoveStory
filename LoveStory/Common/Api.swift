
//
//  Api.swift
//  LoveStory
//
//  Created by songlong on 2016/12/27.
//  Copyright © 2016年 com.Saber. All rights reserved.
//

import Foundation

let onlineHost = "http://www.youjinshuichan.com:8080/"
let testHost = "http://127.0.0.1:8080/"

#if DEBUG
let BASE_URL = onlineHost
#else
let BASE_URL = onlineHost
#endif

//注册接口
let API_REGISTER = "register"
//登录接口
let API_LOGIN = "login"
//发布接口
let API_PUBLISH = "publish"
//获取发布信息接口
let API_GET_PUBLISH = "get_publish"
//获取上传图片参数
let API_GET_QINIU_PARAMS = "request_qiniu_params"
//请求匹配接口
let API_GET_PAIR = "pair"
//刷新匹配情侣信息接口
let API_GET_USER_INFO = "get_user_info"
//获取回复信息接口
let API_GET_REPLY = "get_reply"
//回复接口
let API_REPLY = "reply"


//环信用户密码
let HuanXinPassword = "111111"
