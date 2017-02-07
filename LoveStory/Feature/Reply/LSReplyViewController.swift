//
//  LSReplyViewController.swift
//  LoveStory
//
//  Created by songlong on 2017/2/6.
//  Copyright © 2017年 com.Saber. All rights reserved.
//

import UIKit
import SVProgressHUD
import TPKeyboardAvoiding


class LSReplyViewController: UIViewController, UITextFieldDelegate, UITableViewDelegate, UITableViewDataSource {
    
    var publishModel: PublishModel?
    private lazy var replyViewModel = LSReplyViewModel()
    let replyView = UIView()
    let replyTextField = UITextField()
    var tableView = TPKeyboardAvoidingTableView(frame: CGRect.zero, style: .plain)

    override func viewDidLoad() {
        super.viewDidLoad()

        title = "记录"
        setupUI()
        requestData()
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyBoardWillShow), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyBoardWillHide), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }
    

    
    func keyBoardWillHide(note: Notification) {
        
        let userInfo = note.userInfo
        let duration = (userInfo?[UIKeyboardAnimationDurationUserInfoKey] as! NSNumber).doubleValue
        
        let animations:(() -> Void) = {
            
            self.replyView.transform = .identity
        }
        
        if duration > 0 {
            let options : UIViewAnimationOptions = UIViewAnimationOptions(rawValue: 7)
            
            UIView.animate(withDuration: duration, delay: 0, options:options, animations: animations, completion: nil)
        } else {
            animations()
        }
        
    }
    
    func keyBoardWillShow(note: Notification) {
        
        let userInfo = note.userInfo
        let keyBoardBounds = (userInfo?[UIKeyboardFrameEndUserInfoKey] as! NSValue).cgRectValue
        let duration = (userInfo?[UIKeyboardAnimationDurationUserInfoKey] as! NSNumber).doubleValue
        let deltaY = keyBoardBounds.size.height
        
        let animations:(() -> Void) = {
            
            self.replyView.transform = CGAffineTransform(translationX: 0,y: -(CGFloat)(deltaY))
        }
        
        if duration > 0 {
            let options = UIViewAnimationOptions(rawValue: UInt((userInfo?[UIKeyboardAnimationCurveUserInfoKey] as! NSNumber).intValue << 16))
            
            UIView.animate(withDuration: duration, delay: 0, options:options, animations: animations, completion: nil)
        } else {
            animations()
        }
        
        
    }
    
    private func setupUI() {
        
        view.backgroundColor = UIColor(red: 240 / 255.0, green:  240 / 255.0, blue:  240 / 255.0, alpha: 1)
        tableView.register(LSReplyCell.self, forCellReuseIdentifier: "replyCell")
        tableView.backgroundColor = .clear
        tableView.separatorStyle = .none
        tableView.delegate = self
        tableView.dataSource = self
        tableView.estimatedRowHeight = 100
        view.addSubview(tableView)
        tableView.snp.makeConstraints { (make) in
            make.edges.equalTo(0)
        }
        
        replyView.frame = CGRect(x: 0, y: LSHeight - 50 - 64, width: LSWidth, height: 50)
        replyView.backgroundColor = LSMainColor
        
        replyTextField.placeholder = "回复这条记录"
        replyTextField.layer.cornerRadius = 5
        replyTextField.layer.masksToBounds = true
        replyTextField.leftViewMode = .always
        var frame = replyTextField.frame
        frame.size.width = 5
        let tempView = UIView(frame: frame)
        tempView.backgroundColor = .clear
        replyTextField.leftView = tempView
        replyTextField.delegate = self
        replyTextField.returnKeyType = .send
        replyTextField.backgroundColor = UIColor(red: 240 / 255.0, green:  240 / 255.0, blue:  240 / 255.0, alpha: 1)
        replyView.addSubview(replyTextField)
        replyTextField.snp.makeConstraints { (make) in
            make.top.equalTo(5)
            make.bottom.equalTo(-5)
            make.left.equalTo(15)
            make.right.equalTo(-15)
        }
        
        view.addSubview(replyView)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        
        let text = textField.text?.replacingOccurrences(of: " ", with: "")
        if text == "" {
            SVProgressHUD.showError(withStatus: "回复内容不能为空")
            return false
        }
        
        view.endEditing(true)
        LSNetworking.sharedInstance.request(method: .POST, URLString: API_REPLY, parameters: ["user_account": LSUser.currentUser()?.user_account, "publish_id": publishModel?.publish_id, "reply_content": textField.text], success: { (task, responseObject) in
            SVProgressHUD.showSuccess(withStatus: "回复成功")
            self.replyTextField.text = nil
            self.requestData()
            
        }, failure: { (task, error) in
            
        })
        
        return true
    }

    private func requestData() {
        SVProgressHUD.show()
        replyViewModel.loadReplyData(publish_id: (publishModel?.publish_id)!, finished: { (isSuccessed) in
            SVProgressHUD.dismiss()
            if !isSuccessed {
                SVProgressHUD.showError(withStatus: "数据加载失败")
                return
            }
            SVProgressHUD.showSuccess(withStatus: "刷新成功")
            self.tableView.reloadData()
        })
      
    }
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return 1
        } else {
            return replyViewModel.replyList.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "replyCell", for: indexPath) as! LSReplyCell
        if indexPath.section == 0 {
            
            for view in cell.contentView.subviews {
                view.removeFromSuperview()
            }
            
            cell.contentView.backgroundColor = .clear
            cell.backgroundColor = .clear
            
            let tempView = UIView()
            tempView.backgroundColor = .white
            cell.contentView.addSubview(tempView)
            tempView.snp.makeConstraints({ (make) in
                make.top.left.right.equalTo(0)
                make.bottom.equalTo(-10)
            })
            
            let iconView = UIImageView()
            iconView.layer.cornerRadius = 15
            iconView.layer.masksToBounds = true
            iconView.sd_setImage(with: URL(string: (publishModel?.avator_url)!))
            tempView.addSubview(iconView)
            iconView.snp.makeConstraints { (make) in
                make.width.height.equalTo(30)
                make.left.top.equalTo(15)
            }
            
            let timeLabel = UILabel()
            timeLabel.text = publishModel?.time
            timeLabel.font = UIFont.systemFont(ofSize: 12)
            timeLabel.textColor = .lightGray
            tempView.addSubview(timeLabel)
            timeLabel.snp.makeConstraints { (make) in
                make.centerY.equalTo(iconView)
                make.left.equalTo(iconView.snp.right).offset(15)
            }
            
            let contentLabel = UILabel()
            contentLabel.text = publishModel?.content
            contentLabel.textColor = .black
            contentLabel.numberOfLines = 0
            contentLabel.preferredMaxLayoutWidth = LSWidth - 30
            tempView.addSubview(contentLabel)
            contentLabel.snp.makeConstraints { (make) in
                make.top.equalTo(iconView.snp.bottom).offset(15)
                make.left.equalTo(15)
                make.bottom.equalTo(-20)
            }
            
        } else {
            cell.replyModel = replyViewModel.replyList[indexPath.row]
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        if section == 0 {
            return nil
        } else {
            let tempView = UIView(frame: CGRect(x: 0, y: 0, width: LSWidth, height: 51))
            tempView.backgroundColor = .clear
            return tempView
        }
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        if section == 0 {
            return 0
        } else {
            return 51
        }
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        view.endEditing(true)
    }
    
    
}
