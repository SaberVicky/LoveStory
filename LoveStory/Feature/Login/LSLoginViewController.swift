//
//  LSLoginViewController.swift
//  LoveStory
//
//  Created by songlong on 2017/1/19.
//  Copyright © 2017年 com.Saber. All rights reserved.
//

import UIKit
import SnapKit
import SVProgressHUD
import TPKeyboardAvoiding

class LSLoginViewController: UIViewController, UITextFieldDelegate {
    
    private var accountTextField: UITextField!
    private var passwordTextField: UITextField!
 
    override func viewDidLoad() {
        super.viewDidLoad()

        title = "登录"
        setupUI()
    }
    
    private func setupUI() {
        
        view.backgroundColor = UIColor(red: 243 / 255.0, green: 239 / 255.0, blue: 230 / 255.0, alpha: 1)
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "登录", style: .plain, target: self, action: #selector(clickLogin))
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "取消", style: .plain, target: self, action: #selector(clickCancel))
        
        let scrollView = TPKeyboardAvoidingScrollView(frame: UIScreen.main.bounds)
        scrollView.isScrollEnabled = false
        scrollView.backgroundColor = view.backgroundColor
        view.addSubview(scrollView)
        
        accountTextField = UITextField(frame: CGRect(x: 0, y: 20, width: UIScreen.main.bounds.size.width, height: 45))
        accountTextField.autocorrectionType = .no
        accountTextField.clearButtonMode = .whileEditing
        accountTextField.autocapitalizationType = .none
        accountTextField.backgroundColor = .white
        accountTextField.placeholder = "请输入账号"
        scrollView.addSubview(accountTextField)
        accountTextField.leftViewMode = .always
        var frame = accountTextField.frame
        frame.size.width = frame.size.height
        let tempView = UIView(frame: frame)
        let icon = UIImageView(image: UIImage(named: "ln_login_avtar_icon"))
        tempView.addSubview(icon)
        icon.snp.makeConstraints { (make) in
            make.top.left.equalTo(13)
            make.bottom.right.equalTo(-13)
        }
        accountTextField.leftView = tempView
        
        passwordTextField = UITextField(frame: CGRect(x: 0, y: 66, width: UIScreen.main.bounds.size.width, height: 45))
        passwordTextField.delegate = self
        passwordTextField.isSecureTextEntry = true
        passwordTextField.autocorrectionType = .no
        passwordTextField.clearButtonMode = .whileEditing
        passwordTextField.autocapitalizationType = .none
        passwordTextField.backgroundColor = .white
        passwordTextField.placeholder = "请输入密码"
        scrollView.addSubview(passwordTextField)
        passwordTextField.leftViewMode = .always
        var frame2 = passwordTextField.frame
        frame2.size.width = frame2.size.height
        let tempView2 = UIView(frame: frame2)
        let icon2 = UIImageView(image: UIImage(named: "ln_login_pwd_icon"))
        tempView2.addSubview(icon2)
        icon2.snp.makeConstraints { (make) in
            make.top.left.equalTo(13)
            make.bottom.right.equalTo(-13)
        }
        passwordTextField.leftView = tempView2
    }
    
    func clickCancel() {
        view.endEditing(true)
        dismiss(animated: true, completion: nil)
    }

    func clickLogin() {
        
        view.endEditing(true)
        
        if accountTextField.text == "" {
            SVProgressHUD.showError(withStatus: "请输入账号")
            return
        }
        
        if passwordTextField.text == "" {
            SVProgressHUD.showError(withStatus: "请输入密码")
            return
        }
        
        SVProgressHUD.show()
        LSNetworking.sharedInstance.request(method: .POST, URLString: API_LOGIN, parameters: ["user_account": accountTextField.text, "user_password" : passwordTextField.text], success: { (task, responseObject) in
            SVProgressHUD.dismiss()
            
            let dic = responseObject as! NSDictionary
            let ret : NSInteger = dic["ret"] as! NSInteger
            ret==1 ? SVProgressHUD.showSuccess(withStatus: "登录成功") : SVProgressHUD.showError(withStatus: "登录失败")
            if ret==1 {
                self.loginSuccess()
            }
            
        }, failure: { (task, error) in
            SVProgressHUD.dismiss()
            SVProgressHUD.showError(withStatus: "登录失败")
        })
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
    
    private func loginSuccess() {
        
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        clickLogin()
        return true
    }

}
