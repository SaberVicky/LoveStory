//
//  LSRegisterViewController.swift
//  LoveStory
//
//  Created by songlong on 2017/1/19.
//  Copyright © 2017年 com.Saber. All rights reserved.
//

import UIKit
import TPKeyboardAvoiding
import SVProgressHUD
import Qiniu

class LSRegisterViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextFieldDelegate {
    
    private var scrollView: UIScrollView!
    private var accountTextField: UITextField!
    private var passwordTextField: UITextField!
    private var nickNameTextField: UITextField!
    private var birthTextField: UITextField!
    private var maleBtn: UIButton!
    private var femaleBtn: UIButton!
    private var photoButton: UIButton!
    
    private var count = 0
    private var imgUrl: String?
    private var localImagePath: String?
    private var userDic: [String: String]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "注册"
        setupUI()
    }
    
    private func setupUI() {
        view.backgroundColor = UIColor(red: 243 / 255.0, green: 239 / 255.0, blue: 230 / 255.0, alpha: 1)
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "注册", style: .plain, target: self, action: #selector(clickRegister))
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "取消", style: .plain, target: self, action: #selector(clickCancel))
        
        scrollView = TPKeyboardAvoidingScrollView(frame: UIScreen.main.bounds)
        scrollView.isScrollEnabled = false
        scrollView.backgroundColor = view.backgroundColor
        view.addSubview(scrollView)
        
        let stepIcon = UIImageView(image: UIImage(named: "ln_reg_indicator_1"))
        scrollView.addSubview(stepIcon)
        stepIcon.snp.makeConstraints { (make) in
            make.centerY.equalTo(35)
            make.centerX.equalTo(scrollView)
        }
        
        let topView = UIView(frame: CGRect(x: 0, y: 70, width: UIScreen.main.bounds.size.width, height: 70))
        topView.backgroundColor = .white
        scrollView.addSubview(topView)
        
        photoButton = UIButton()
        photoButton.layer.cornerRadius = 30
        photoButton.layer.masksToBounds = true
        photoButton.addTarget(self, action: #selector(clickPhoto), for: .touchUpInside)
        photoButton.setBackgroundImage(UIImage(named:"ln_photo_pick"), for: .normal)
        topView.addSubview(photoButton)
        photoButton.snp.makeConstraints { (make) in
            make.centerY.equalTo(topView)
            make.height.width.equalTo(60)
            make.left.equalTo(20)
        }
        
        let photoLabel = UILabel()
        photoLabel.text = "头像"
        photoLabel.textColor = .black
        topView.addSubview(photoLabel)
        photoLabel.snp.makeConstraints { (make) in
            make.centerY.equalTo(topView)
            make.left.equalTo(photoButton.snp.right).offset(10)
        }
        
        maleBtn = UIButton()
        maleBtn.addTarget(self, action: #selector(clickMale), for: .touchUpInside)
        maleBtn.setImage(UIImage(named: "register_m"), for: .normal)
        maleBtn.setImage(UIImage(named: "register_m_selected"), for: .selected)
        topView.addSubview(maleBtn)
        maleBtn.snp.makeConstraints { (make) in
            make.left.equalTo(photoLabel.snp.right).offset(20)
            make.centerY.equalTo(topView)
        }
        
        let maleLabel = UILabel()
        maleLabel.text = "男"
        maleLabel.textColor = .black
        topView.addSubview(maleLabel)
        maleLabel.snp.makeConstraints { (make) in
            make.centerY.equalTo(topView)
            make.left.equalTo(maleBtn.snp.right).offset(5)
        }
        
        femaleBtn = UIButton()
        femaleBtn.addTarget(self, action: #selector(clickFemale), for: .touchUpInside)
        femaleBtn.setImage(UIImage(named: "register_f"), for: .normal)
        femaleBtn.setImage(UIImage(named: "register_f_selected"), for: .selected)
        topView.addSubview(femaleBtn)
        femaleBtn.snp.makeConstraints { (make) in
            make.left.equalTo(maleLabel.snp.right).offset(40)
            make.centerY.equalTo(topView)
        }
        
        let femaleLabel = UILabel()
        femaleLabel.text = "女"
        femaleLabel.textColor = .black
        topView.addSubview(femaleLabel)
        femaleLabel.snp.makeConstraints { (make) in
            make.centerY.equalTo(topView)
            make.left.equalTo(femaleBtn.snp.right).offset(5)
        }
        
        
        accountTextField = UITextField(frame: CGRect(x: 0, y: 141, width: UIScreen.main.bounds.size.width, height: 50))
        accountTextField.autocorrectionType = .no
        accountTextField.clearButtonMode = .whileEditing
        accountTextField.autocapitalizationType = .none
        accountTextField.placeholder = "账号"
        accountTextField.backgroundColor = .white
        accountTextField.leftViewMode = .always
        var frame = accountTextField.frame
        frame.size.width = frame.size.height
        let tempView = UIView(frame: frame)
        let icon = UIImageView(image: UIImage(named: "ln_login_email_icon"))
        tempView.addSubview(icon)
        icon.snp.makeConstraints { (make) in
            make.center.equalTo(tempView)
            make.width.equalTo(16)
            make.height.equalTo(13)
        }
        accountTextField.leftView = tempView
        scrollView.addSubview(accountTextField)
        
        passwordTextField = UITextField(frame: CGRect(x: 0, y: 192, width: UIScreen.main.bounds.size.width, height: 50))
        passwordTextField.backgroundColor = .white
        passwordTextField.autocorrectionType = .no
        passwordTextField.isSecureTextEntry = true
        passwordTextField.clearButtonMode = .whileEditing
        passwordTextField.autocapitalizationType = .none
        passwordTextField.placeholder = "密码 (6~20字)"
        passwordTextField.leftViewMode = .always
        var frame2 = passwordTextField.frame
        frame2.size.width = frame2.size.height
        let tempView2 = UIView(frame: frame2)
        let icon2 = UIImageView(image: UIImage(named: "ln_login_pwd_icon"))
        tempView2.addSubview(icon2)
        icon2.snp.makeConstraints { (make) in
            make.center.equalTo(tempView2)
            make.width.equalTo(15)
            make.height.equalTo(18)
        }
        passwordTextField.leftView = tempView2
        scrollView.addSubview(passwordTextField)
        
        nickNameTextField = UITextField(frame: CGRect(x: 0, y: 243, width: UIScreen.main.bounds.size.width, height: 50))
        nickNameTextField.backgroundColor = .white
        nickNameTextField.delegate = self
        nickNameTextField.autocorrectionType = .no
        nickNameTextField.clearButtonMode = .whileEditing
        nickNameTextField.autocapitalizationType = .none
        nickNameTextField.placeholder = "昵称"
        nickNameTextField.leftViewMode = .always
        nickNameTextField.returnKeyType = .done
        var frame3 = passwordTextField.frame
        frame3.size.width = frame3.size.height
        let tempView3 = UIView(frame: frame3)
        let icon3 = UIImageView(image: UIImage(named: "ln_login_avtar_icon"))
        tempView3.addSubview(icon3)
        icon3.snp.makeConstraints { (make) in
            make.center.equalTo(tempView3)
            make.width.equalTo(15)
            make.height.equalTo(18)
        }
        nickNameTextField.leftView = tempView3
        scrollView.addSubview(nickNameTextField)
        
        birthTextField = UITextField(frame: CGRect(x: 0, y: 294, width: UIScreen.main.bounds.size.width, height: 50))
        birthTextField.isUserInteractionEnabled = false
        birthTextField.backgroundColor = .white
        birthTextField.placeholder = "生日"
        birthTextField.leftViewMode = .always
        var frame4 = birthTextField.frame
        frame4.size.width = frame4.size.height
        let tempView4 = UIView(frame: frame4)
        let icon4 = UIImageView(image: UIImage(named: "ln_login_birthday"))
        tempView4.addSubview(icon4)
        icon4.snp.makeConstraints { (make) in
            make.center.equalTo(tempView4)
            make.width.equalTo(56.0 / 3)
            make.height.equalTo(18)
        }
        birthTextField.leftView = tempView4
        scrollView.addSubview(birthTextField)
        
        let birthdayBtn = UIButton(frame: CGRect(x: 0, y: 294, width: LSWidth, height: 50))
        birthdayBtn.addTarget(self, action: #selector(clickBirthday), for: .touchUpInside)
        scrollView.addSubview(birthdayBtn)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        view.endEditing(true)
        return true
    }
    
    func clickBirthday() {
        view.endEditing(true)
        LSDatePickerView.showInView(view: view, completion: {
            (year, month, day) in

            let date = "\(year!)\(month!)\(day!)"
            self.birthTextField.text = date
        })
    }
    
    func clickMale() {
        if !maleBtn.isSelected {
            maleBtn.isSelected = true
            femaleBtn.isSelected = false
        }
    }
    
    func clickFemale() {
        if !femaleBtn.isSelected {
            femaleBtn.isSelected = true
            maleBtn.isSelected = false
        }
    }
    
    func clickPhoto() {
        
        let alertVC = UIAlertController(title: "拍个头像吧", message: nil, preferredStyle: .actionSheet)
        let actionOne = UIAlertAction(title: "拍摄照片", style: .default, handler: { (action) in
            let imagePicker = LSCustomImagePickerViewController()
            imagePicker.delegate = self
            imagePicker.allowsEditing = true
            imagePicker.sourceType = .camera
            self.present(imagePicker, animated: true, completion: nil)
        })
        let actionTwo = UIAlertAction(title: "从相册中选取", style: .default, handler: { (action) in
            let imagePicker = LSCustomImagePickerViewController()
            imagePicker.delegate = self
            imagePicker.allowsEditing = true
            imagePicker.sourceType = .photoLibrary
            self.present(imagePicker, animated: true, completion: nil)
        })
        let actionThree = UIAlertAction(title: "取消", style: .cancel, handler: nil)
        alertVC.addAction(actionOne)
        alertVC.addAction(actionTwo)
        alertVC.addAction(actionThree)
        
        if count > 0 {
            let actionFour = UIAlertAction(title: "清除图片", style: .default, handler: { (action) in
                self.count = 0
                self.localImagePath = nil
                self.photoButton.setBackgroundImage(UIImage(named:"ln_photo_pick"), for: .normal)
            })
            alertVC.addAction(actionFour)
        }
        
        present(alertVC, animated: true, completion: nil)
    }
    
    
    
    func clickCancel() {
        view.endEditing(true)
        dismiss(animated: true, completion: nil)
    }
    
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        picker.dismiss(animated: true, completion: nil)
        
        var data: Data?
        
        let image = info[UIImagePickerControllerEditedImage] as? UIImage
        data = UIImageJPEGRepresentation(image!, 0.3)
        
        let documentsPath = NSHomeDirectory().appending("/Documents")
        let manager = FileManager.default
        
        do {
            try manager.createDirectory(at: URL(string: documentsPath)!, withIntermediateDirectories: true, attributes: nil)
        } catch let error as NSError {
            LSPrint(error.localizedDescription)
        }
        
        let path = documentsPath.appending("/userAvator.jpg")
        localImagePath = path
        manager.createFile(atPath: path, contents: data, attributes: nil)
        
        let newImage = UIImage(contentsOfFile: path)
        photoButton.setBackgroundImage(newImage, for: .normal)
        count = count + 1
    }
    
    //点击注册
    func clickRegister() {
        view.endEditing(true)
        
        
        if count == 0 {
            SVProgressHUD.showError(withStatus: "请选择头像")
            return
        }
        
        if !maleBtn.isSelected && !femaleBtn.isSelected {
            SVProgressHUD.showError(withStatus: "请选择性别")
            return
        }
        
        if accountTextField.text == "" {
            SVProgressHUD.showError(withStatus: "请输入账号")
            return
        }
        
        if passwordTextField.text == "" {
            SVProgressHUD.showError(withStatus: "请输入密码")
            return
        }
        
        if nickNameTextField.text == "" {
            SVProgressHUD.showError(withStatus: "请输入昵称")
            return
        }
        
        if birthTextField.text == "" {
            SVProgressHUD.showError(withStatus: "请选择生日")
            return
        }
        
        uploadPhoto()
    }
    
    //上传头像
    private func uploadPhoto() {
        
        SVProgressHUD.show()
        LSNetworking.sharedInstance.request(method: .GET, URLString: API_GET_QINIU_PARAMS, parameters: nil, success: { (task, responseObject) in
            SVProgressHUD.dismiss()
            let config = QNConfiguration.build({ (builder) in
                builder?.setZone(QNZone.zone1())
            })
            
            let dic = responseObject as! NSDictionary
            let token : String = dic["token"] as! String
            let key : String = dic["key"] as! String
            self.imgUrl = dic["img_url"] as? String
            
            let option = QNUploadOption(progressHandler: { (key, percent) in
                LSPrint("percent = \(percent)")
            })
            
            let upManager = QNUploadManager(configuration: config)
            SVProgressHUD.show()
            upManager?.putFile(self.localImagePath, key: key, token: token, complete: { (info, key, resp) in
                SVProgressHUD.dismiss()
                if (info?.isOK)! {
                    LSPrint("上传头像成功")
                    self.toRegister()
                    
                } else {
                    LSPrint("上传头像失败")
                }
                LSPrint(info)
                LSPrint(resp)
            }, option: option)
            
            
        }, failure: { (task, error) in
            SVProgressHUD.dismiss()
            LSPrint(error)
        })
    }
    
    private func toRegister() {
        SVProgressHUD.show()
        let sex = maleBtn.isSelected ? "m" : "f"
        let account = accountTextField.text!
        let password = passwordTextField.text!
        let birthday = birthTextField.text!
        let name = nickNameTextField.text!
        self.userDic = ["user_sex": sex, "user_account": account, "user_password": password, "user_birthday": birthday, "user_huanXinAccount": account, "user_huanXinPassword": account, "user_name": name, "user_avator": imgUrl!]
        
        LSNetworking.sharedInstance.request(method: .POST, URLString: API_REGISTER, parameters: self.userDic, success: { (task, responseObject) in
            SVProgressHUD.dismiss()
            
            let dic = responseObject as! NSDictionary
            let ret : NSInteger = dic["ret"] as! NSInteger
            ret==1 ? SVProgressHUD.showSuccess(withStatus: "注册成功") : SVProgressHUD.showError(withStatus: "注册失败")
            if ret==1 {
                let inviteCode = dic["inviteCode"] as! Int
                let user_id = dic["user_id"] as! Int
                self.userDic?["invite_code"] = "\(inviteCode)"
                self.userDic?["user_id"] = "\(user_id)"
                
                if LSChatManager.chatRegister(account: self.accountTextField.text!) {
                    self.registerSuccess()
                }
            }
            
        }, failure: { (task, error) in
            SVProgressHUD.dismiss()
            SVProgressHUD.showError(withStatus: "注册失败")
        })
    }
    
    private func registerSuccess() {
        LSPrint("恭喜你完成所有注册流程")
        let user = LSUser.userWithDic(dic: self.userDic!)
        user.user_add()
        let vc = LSInviteViewController()
        let nav = CustionNavigationViewController(rootViewController: vc)
        present(nav, animated: true, completion: nil)
    }
    
}
