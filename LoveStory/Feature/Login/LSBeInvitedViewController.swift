//
//  LSBeInvitedViewController.swift
//  LoveStory
//
//  Created by songlong on 2017/1/20.
//  Copyright © 2017年 com.Saber. All rights reserved.
//

import UIKit
import SVProgressHUD

class LSBeInvitedViewController: UIViewController {
    
    var textfield : UITextField!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "匹配等待"
        setupUI()
    }

    private func setupUI() {
        view.backgroundColor = UIColor(red: 243 / 255.0, green: 239 / 255.0, blue: 230 / 255.0, alpha: 1)
        
        let stepIcon = UIImageView(image: UIImage(named: "ln_reg_indicator_3"))
        view.addSubview(stepIcon)
        stepIcon.snp.makeConstraints { (make) in
            make.centerY.equalTo(35)
            make.centerX.equalTo(view)
        }
        
        
        let infoLabel = UILabel()
        infoLabel.textAlignment = .center
        infoLabel.text = "在下方填写另一半发给你的邀请码\n一起开通LoveStory吧"
        infoLabel.font = UIFont.systemFont(ofSize: 13)
        infoLabel.textColor = .lightGray
        infoLabel.numberOfLines = 2
        view.addSubview(infoLabel)
        infoLabel.snp.makeConstraints { (make) in
            make.centerX.equalTo(view)
            make.top.equalTo(70)
        }
        
        textfield = UITextField()
        textfield.textColor = .red
        textfield.backgroundColor = .white
        textfield.font = UIFont.systemFont(ofSize: 25)
        textfield.textAlignment = .center
        textfield.placeholder = "请输入邀请码"
        view.addSubview(textfield)
        textfield.snp.makeConstraints { (make) in
            make.centerX.left.equalTo(view)
            make.height.equalTo(70)
            make.top.equalTo(infoLabel.snp.bottom).offset(70)
        }
        
        let commitButton = UIButton()
        commitButton.addTarget(self, action: #selector(clickCommit), for: .touchUpInside)
        commitButton.layer.cornerRadius = 5
        commitButton.layer.masksToBounds = true
        commitButton.setTitleColor(.white, for: .normal)
        commitButton.setTitle("提交", for: .normal)
        commitButton.backgroundColor = LSMainColor
        view.addSubview(commitButton)
        commitButton.snp.makeConstraints { (make) in
            make.centerX.equalTo(view)
            make.left.equalTo(20)
            make.top.equalTo(textfield.snp.bottom).offset(35)
            make.height.equalTo(50)
        }
    }
    
    func clickCommit() {
        
        if textfield.text == "" {
            SVProgressHUD.showError(withStatus: "请输入邀请码")
            return
        }
        
        SVProgressHUD.show()
        let params = ["user_account": LSUser.currentUser()?.user_account, "inviteCode": textfield.text]
        LSNetworking.sharedInstance.request(method: .GET, URLString: API_GET_PAIR, parameters: params, success: { (task, responseObject) in
            SVProgressHUD.dismiss()
            let dic = responseObject as! NSDictionary
            let ret : NSInteger = dic["ret"] as! NSInteger
            let msg: String = dic["msg"] as! String
            ret==1 ? SVProgressHUD.showSuccess(withStatus: "匹配成功") : SVProgressHUD.showError(withStatus: msg)
            if ret == 1 {
                let userDic = dic["data"] as! NSDictionary
                let user = LSUser.currentUser()
                user?.user_coupleAccount = userDic["couple_account"] as? String
                user?.user_coupleName = userDic["couple_name"] as? String
                user?.user_coupleAvator = userDic["couple_avator"] as? String
                user?.user_update()
                self.pairSuccess()
            }
        }, failure: { (task, error) in
            SVProgressHUD.dismiss()
        })
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
    
    private func pairSuccess() {
        LSPrint("哇咔咔，匹配流程全部完成！")
        LSChatManager.chatLogin()
        UIApplication.shared.keyWindow?.rootViewController = CustomTabBarViewController()
    }
    
}
