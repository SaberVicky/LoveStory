//
//  LSToInviteViewController.swift
//  LoveStory
//
//  Created by songlong on 2017/1/20.
//  Copyright © 2017年 com.Saber. All rights reserved.
//

import UIKit
import SVProgressHUD

class LSToInviteViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        title = "匹配等待"
        setupUI()
    }
    
    private func setupUI() {
        view.backgroundColor = UIColor(red: 243 / 255.0, green: 239 / 255.0, blue: 230 / 255.0, alpha: 1)
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "刷新", style: .plain, target: self, action: #selector(clickRefresh))
        
        let stepIcon = UIImageView(image: UIImage(named: "ln_reg_indicator_3"))
        view.addSubview(stepIcon)
        stepIcon.snp.makeConstraints { (make) in
            make.centerY.equalTo(35)
            make.centerX.equalTo(view)
        }
        
        
        let infoLabel = UILabel()
        infoLabel.textAlignment = .center
        infoLabel.text = "通知另一半注册LoveStory，并填写下面的邀请码\n你俩就可以开通LoveStory了"
        infoLabel.font = UIFont.systemFont(ofSize: 13)
        infoLabel.textColor = .lightGray
        infoLabel.numberOfLines = 2
        view.addSubview(infoLabel)
        infoLabel.snp.makeConstraints { (make) in
            make.centerX.equalTo(view)
            make.top.equalTo(70)
        }

        let codeLabel = UILabel()
        codeLabel.text = LSUser.currentUser()?.user_inviteCode
        codeLabel.textColor = .red
        codeLabel.textAlignment = .center
        codeLabel.backgroundColor = .white
        codeLabel.font = UIFont.systemFont(ofSize: 50)
        view.addSubview(codeLabel)
        codeLabel.snp.makeConstraints { (make) in
            make.centerX.left.equalTo(view)
            make.height.equalTo(70)
            make.top.equalTo(infoLabel.snp.bottom).offset(70)
        }
        
        let refreshButton = UIButton()
        refreshButton.addTarget(self, action: #selector(clickRefresh), for: .touchUpInside)
        refreshButton.layer.cornerRadius = 5
        refreshButton.layer.masksToBounds = true
        refreshButton.setTitleColor(.white, for: .normal)
        refreshButton.setTitle("对方已添加邀请码", for: .normal)
        refreshButton.backgroundColor = LSMainColor
        view.addSubview(refreshButton)
        refreshButton.snp.makeConstraints { (make) in
            make.centerX.equalTo(view)
            make.left.equalTo(20)
            make.top.equalTo(codeLabel.snp.bottom).offset(35)
            make.height.equalTo(50)
        }
    }

    func clickRefresh() {
        
        SVProgressHUD.show()
        LSNetworking.sharedInstance.request(method: .GET, URLString: API_GET_USER_INFO, parameters: ["user_account": LSUser.currentUser()?.user_account], success: { (task, responseObject) in
            SVProgressHUD.dismiss()
            let dic = responseObject as! NSDictionary
            let ret : NSInteger = dic["ret"] as! NSInteger
            if ret == 1 {
                
                SVProgressHUD.showSuccess(withStatus: "关联成功")
                
                let user = LSUser.currentUser()
                user?.user_coupleAccount = dic["couple_account"] as? String
                user?.user_coupleName = dic["couple_name"] as? String
                user?.user_coupleAvator = dic["couple_avator"] as? String
                user?.user_update()
                self.pairSuccess()
            } else {
                SVProgressHUD.showError(withStatus: "仍未关联情侣")
            }
            
        }, failure: { (task, error) in
            SVProgressHUD.dismiss()
            
        })
    }
   
    private func pairSuccess(){
        LSPrint("哇咔咔，匹配流程全部完成！")
        LSChatManager.chatLogin()
        UIApplication.shared.keyWindow?.rootViewController = CustomTabBarViewController()
    }
}
