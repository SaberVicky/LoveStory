//
//  LSRecordVideoViewController.swift
//  LoveStory
//
//  Created by songlong on 2017/1/12.
//  Copyright © 2017年 com.Saber. All rights reserved.
//

import UIKit
import MobileCoreServices
import AVFoundation
import Qiniu
import SVProgressHUD

class LSRecordVideoViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    var videoUrl: String!
    var publishVideoUrl: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "发布", style: .plain, target: self, action: #selector(LSRecordVideoViewController.publish))

        // Do any additional setup after loading the view.
        view.backgroundColor = .purple
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            let availableTypes = UIImagePickerController.availableMediaTypes(for: .camera)
            
            if (availableTypes?.contains(kUTTypeMovie as String))! {
                let picker = UIImagePickerController()
                picker.sourceType = .camera
                picker.delegate = self
                picker.mediaTypes = [kUTTypeMovie as String]
                present(picker, animated: true, completion: nil)
            } else {
                let alert = UIAlertController(title: "", message: nil, preferredStyle: .alert)
                present(alert, animated: true, completion: nil)
            }
            
        }
    }

   
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        picker.dismiss(animated: true, completion: nil)
        let url = info[UIImagePickerControllerMediaURL] as! URL
        videoUrl = url.absoluteString
        
        let icon = UIImageView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.size.width / 2, height: UIScreen.main.bounds.size.width / 2))
        icon.getVideoImage(url: videoUrl)
        view.addSubview(icon)
        
        let btn = UIButton(frame: icon.frame)
        btn.backgroundColor = .clear
        btn.addTarget(self, action: #selector(LSRecordVideoViewController.playVideo), for: .touchUpInside)
        btn.setBackgroundImage(UIImage(named: "playIcon"), for: .normal)
        view.addSubview(btn)
    }
    
    func playVideo() {
        let vc = LSVideoPlayerViewController()
        vc.videoUrl = videoUrl
        present(vc, animated: true, completion: nil)
        
    }
    
    func publish() {
        LSNetworking.sharedInstance.request(method: .GET, URLString: API_GET_QINIU_PARAMS, parameters: ["type" : "video"], success: { (task, responseObject) in
            
            let config = QNConfiguration.build({ (builder) in
                builder?.setZone(QNZone.zone1())
            })
            
            let dic = responseObject as! NSDictionary
            let token : String = dic["token"] as! String
            let key : String = dic["key"] as! String
            self.publishVideoUrl = dic["img_url"] as? String
            
            let option = QNUploadOption(progressHandler: { (key, percent) in
                LSPrint("percent = \(percent)")
            })
            
            var path = self.videoUrl
            path = path?.replacingOccurrences(of: "file:///private/", with: "")
            
            let upManager = QNUploadManager(configuration: config)
            upManager?.putFile(path, key: key, token: token, complete: { (info, key, resp) in
                if (info?.isOK)! {
                    
                    SVProgressHUD.showSuccess(withStatus: "上传成功")
                    
                } else {
            
                    SVProgressHUD.showError(withStatus: "上传失败")
                }
                LSPrint(info)
                LSPrint(resp)
            }, option: option)
            
            
        }, failure: { (task, error) in
            
            print(error)
        })
    }
}

extension UIImageView {
    
    func getVideoImage(url: String) {
        DispatchQueue.global().async {
            let asset = AVURLAsset(url: URL(string: url)!)
            let generator = AVAssetImageGenerator(asset: asset)
            generator.appliesPreferredTrackTransform = true
            let time = CMTimeMakeWithSeconds(0.0, 600)
            var actualTime: CMTime = CMTimeMake(0, 0)
            var image:CGImage?
            do {
                try image = generator.copyCGImage(at: time, actualTime: &actualTime)
            } catch let error as NSError {
                LSPrint(error)
            }
            DispatchQueue.main.async {
                self.image = UIImage(cgImage: image!)
                
            }
        }
    }
}
