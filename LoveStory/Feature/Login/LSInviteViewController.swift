//
//  LSInviteViewController.swift
//  LoveStory
//
//  Created by songlong on 2017/1/20.
//  Copyright © 2017年 com.Saber. All rights reserved.
//

import UIKit

class LSInviteViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        title = "匹配信息"
        setupUI()
    }
    
    private func setupUI() {
        view.backgroundColor = UIColor(red: 243 / 255.0, green: 239 / 255.0, blue: 230 / 255.0, alpha: 1)
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "退出", style: .plain, target: self, action: #selector(clickQuit))
        
        let stepIcon = UIImageView(image: UIImage(named: "ln_reg_indicator_2"))
        view.addSubview(stepIcon)
        stepIcon.snp.makeConstraints { (make) in
            make.centerY.equalTo(35)
            make.centerX.equalTo(view)
        }
        
        let infoLabel = UILabel()
        infoLabel.text = "LoveStory是情侣两人玩的应用\n邀请你的另一半，以匹配开通"
        infoLabel.textAlignment = .center
        infoLabel.font = UIFont.systemFont(ofSize: 13)
        infoLabel.textColor = .lightGray
        infoLabel.numberOfLines = 2
        view.addSubview(infoLabel)
        infoLabel.snp.makeConstraints { (make) in
            make.centerX.equalTo(view)
            make.top.equalTo(70)
        }
        
        let toInviteBtn = UIButton()
        toInviteBtn.addTarget(self, action: #selector(clickToInvite), for: .touchUpInside)
        toInviteBtn.setTitleColor(.white, for: .normal)
        toInviteBtn.layer.cornerRadius = 5
        toInviteBtn.layer.masksToBounds = true
        toInviteBtn.setTitle("邀请另一半", for: .normal)
        toInviteBtn.backgroundColor = LSMainColor
        view.addSubview(toInviteBtn)
        toInviteBtn.snp.makeConstraints { (make) in
            make.centerX.equalTo(view)
            make.left.equalTo(20)
            make.top.equalTo(infoLabel.snp.bottom).offset(70)
            make.height.equalTo(50)
        }
        
        let beInvitedBtn = UIButton()
        beInvitedBtn.addTarget(self, action: #selector(clickBeInvited), for: .touchUpInside)
        beInvitedBtn.layer.cornerRadius = 5
        beInvitedBtn.layer.masksToBounds = true
        beInvitedBtn.setTitleColor(.white, for: .normal)
        beInvitedBtn.setTitle("我已经被邀请", for: .normal)
        beInvitedBtn.backgroundColor = LSMainColor
        view.addSubview(beInvitedBtn)
        beInvitedBtn.snp.makeConstraints { (make) in
            make.centerX.equalTo(view)
            make.left.equalTo(20)
            make.top.equalTo(toInviteBtn.snp.bottom).offset(35)
            make.height.equalTo(50)
        }
    }
    
    func clickToInvite() {
        navigationController?.pushViewController(LSToInviteViewController(), animated: true)
    }
    
    func clickBeInvited() {
        navigationController?.pushViewController(LSBeInvitedViewController(), animated: true)
    }
    
    func clickQuit() {
        
        let alert = UIAlertController(title: "退出后您将断开该账号的连接！", message: nil, preferredStyle: .actionSheet)
        let action1 = UIAlertAction(title: "确定退出", style: .destructive, handler: {
            (action) in
            self.dismiss(animated: true, completion: nil)
            LSUser.currentUser()?.user_delete()
        })
        let action2 = UIAlertAction(title: "取消", style: .cancel, handler: nil)
        alert.addAction(action1)
        alert.addAction(action2)
        present(alert, animated: true, completion: nil)
    }
}
