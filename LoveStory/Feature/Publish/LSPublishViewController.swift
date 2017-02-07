//
//  LSPublishViewController.swift
//  LoveStory
//
//  Created by songlong on 2016/12/29.
//  Copyright © 2016年 com.Saber. All rights reserved.
//

import UIKit
import SnapKit
import SVProgressHUD
import Qiniu

class LSPublishViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    var toolBar: UIView!
    var editTextView = UITextView()
    var imgSelectButton = UIButton()
    var recordSoundButton = UIButton()
    var recordVideoButton = UIButton()
    var publishImgUrl: String?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor(red: 240 / 255.0, green:  240 / 255.0, blue:  240 / 255.0, alpha: 1)
        title = "新建"
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "发布", style: .plain, target: self, action: #selector(LSPublishViewController.publish))
        setupUI()
        
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyBoardWillShow), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyBoardWillHide), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
        
    }
    
    func keyBoardWillShow(note: Notification) {
        
    
        let durationT = 0.25
        let deltaY = 216
        let animations:(() -> Void) = {
            
            self.toolBar.transform = CGAffineTransform(translationX: 0,y: -(CGFloat)(deltaY)-30)
        }
        
        
        let options : UIViewAnimationOptions = UIViewAnimationOptions(rawValue: 7)
        
        UIView.animate(withDuration: durationT, delay: 0, options:options, animations: animations, completion: nil)
    }
    
    func keyBoardWillHide() {
        
    }

    func publish() {
        
        let account = LSUser.currentUser()?.user_account
        
        var params: [String : String?]
        
        if publishImgUrl != nil {
            params = ["user_account": account, "publish_text" : editTextView.text, "img_url": publishImgUrl]
        } else {
            params = ["user_account": account, "publish_text" : editTextView.text]
        }
        
        
         
        LSNetworking.sharedInstance.request(method: .GET, URLString: API_PUBLISH, parameters: params, success: { (task, responseObject) in
            
            SVProgressHUD.showSuccess(withStatus: "发布成功")
            
        }, failure: { (task, error) in
            
            SVProgressHUD.showError(withStatus: "发布失败")
        })
    }
    
    func setupUI() {
        
        
        
        editTextView.backgroundColor = .lightGray
        editTextView.font = UIFont.systemFont(ofSize: 18)
        editTextView.autocorrectionType = .no
        editTextView.autocapitalizationType = .none
        
        
        imgSelectButton.setTitle("选择图片", for: .normal)
        imgSelectButton.setTitleColor(.black, for: .normal)
        imgSelectButton.addTarget(self, action: #selector(LSPublishViewController.gotoImageLibrary), for: .touchUpInside)
        
        recordSoundButton.setTitle("录音", for: .normal)
        recordSoundButton.setTitleColor(.black, for: .normal)
        recordSoundButton.addTarget(self, action: #selector(LSPublishViewController.gotoRecord), for: .touchUpInside)
        
        recordVideoButton.setTitle("录像", for: .normal)
        recordVideoButton.setTitleColor(.black, for: .normal)
        recordVideoButton.addTarget(self, action: #selector(LSPublishViewController.gotoRecordVideo), for: .touchUpInside)
        
        view.addSubview(editTextView)
        view.addSubview(imgSelectButton)
        view.addSubview(recordSoundButton)
        view.addSubview(recordVideoButton)
        
        editTextView.snp.makeConstraints { (make) in
            make.top.left.right.equalTo(0)
            make.height.equalTo(self.view).multipliedBy(0.5)
        }
        
        imgSelectButton.snp.makeConstraints { (make) in
            make.centerX.equalTo(self.view)
            make.top.equalTo(editTextView.snp.bottom).offset(20)
        }
        
        recordSoundButton.snp.makeConstraints { (make) in
            make.centerX.equalTo(self.view)
            make.top.equalTo(imgSelectButton.snp.bottom).offset(20)
        }
        
        recordVideoButton.snp.makeConstraints { (make) in
            make.centerX.equalTo(self.view)
            make.top.equalTo(recordSoundButton.snp.bottom).offset(20)
        }
        
        toolBar = UIView(frame: CGRect(x: 0, y: LSHeight - 30 - 66, width: LSWidth, height: 30))
        toolBar.backgroundColor = .black
        view.addSubview(toolBar)
    }
    
    func gotoRecordVideo() {
        navigationController?.pushViewController(LSRecordVideoViewController(), animated: true)
    }
    
    func gotoRecord() {
        navigationController?.pushViewController(LSRecordSoundViewController(), animated: true)
    }
    
    func gotoImageLibrary() {
        if UIImagePickerController.isSourceTypeAvailable(.photoLibrary) {
            let imgPicker = UIImagePickerController()
            imgPicker.sourceType = .photoLibrary
            imgPicker.delegate = self
            present(imgPicker, animated: true, completion: nil)
        } else {
            let alert = UIAlertController(title: "", message: nil, preferredStyle: .alert)
            present(alert, animated: true, completion: nil)
        }
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        picker.dismiss(animated:true, completion:nil)
        
        let img = info[UIImagePickerControllerOriginalImage] as? UIImage
        let icon = UIImageView(image: img)
        view.addSubview(icon)
        icon.snp.makeConstraints { (make) in
            make.top.left.equalTo(0)
            make.width.height.equalTo(UIScreen.main.bounds.size.width / 2)
        }
        
        LSNetworking.sharedInstance.request(method: .GET, URLString: API_GET_QINIU_PARAMS, parameters: nil, success: { (task, responseObject) in
            
            let config = QNConfiguration.build({ (builder) in
                builder?.setZone(QNZone.zone1())
            })
            
            let dic = responseObject as! NSDictionary
            let token : String = dic["token"] as! String
            let key : String = dic["key"] as! String
            self.publishImgUrl = dic["img_url"] as? String
            
            let option = QNUploadOption(progressHandler: { (key, percent) in
                LSPrint("percent = \(percent)")
            })
            
            let upManager = QNUploadManager(configuration: config)
            upManager?.putFile(self.getImagePath(image: img!), key: key, token: token, complete: { (info, key, resp) in
                if (info?.isOK)! {
                    LSPrint("上传成功")
                    
                    self.publish()
                } else {
                    SVProgressHUD.showError(withStatus: "上传失败")
                    LSPrint("上传失败")
                }
                LSPrint(info)
                LSPrint(resp)
            }, option: option)
            
            
        }, failure: { (task, error) in
            
            print(error)
        })
        
        
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
    

    
    func getImagePath(image: UIImage) -> String {
        var data: Data?
        
//        if UIImagePNGRepresentation(image) == nil {
//            data = UIImageJPEGRepresentation(image, 0.3)
//        } else {
//            data = UIImagePNGRepresentation(image)
//        }
        
        data = UIImageJPEGRepresentation(image, 0.3)
        
        let documentsPath = NSHomeDirectory().appending("/Documents")
        let manager = FileManager.default
        
        do {
            try manager.createDirectory(at: URL(string: documentsPath)!, withIntermediateDirectories: true, attributes: nil)
        } catch let error as NSError {
            LSPrint(error.localizedDescription)
        }
        
        let path = documentsPath.appending("/theImage.jpg")
        manager.createFile(atPath: path, contents: data, attributes: nil)
        return path
    }
    
}
