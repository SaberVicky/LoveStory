//
//  LSRecordSoundViewController.swift
//  LoveStory
//
//  Created by songlong on 2017/1/12.
//  Copyright © 2017年 com.Saber. All rights reserved.
//

import UIKit
import AVFoundation
import Qiniu
import SVProgressHUD

class LSRecordSoundViewController: UIViewController {
    
    let player = AVPlayer(url: URL(string: "http://ojae83ylm.bkt.clouddn.com/28466c0ed87411e6b1045254005b67a6.caf")!)
    var audioRecorder:AVAudioRecorder!
    var audioPlayer:AVAudioPlayer!
    var theSoundUrl: String?
    var publishSoundUrl: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        setupAV()
        setupUI()
    }

    func setupAV() {
        let recordSettings = [AVSampleRateKey : NSNumber(value: Float(44100.0)),//声音采样率
            AVFormatIDKey : NSNumber(value: Int32(kAudioFormatMPEG4AAC)),//编码格式
            AVNumberOfChannelsKey : NSNumber(value: 1),//采集音轨
            AVEncoderAudioQualityKey : NSNumber(value: Int32(AVAudioQuality.max.rawValue))]//音频质量
        
        let audioSession = AVAudioSession.sharedInstance()
        do {
            try audioSession.setCategory(AVAudioSessionCategoryPlayAndRecord)
            try audioRecorder = AVAudioRecorder(url: self.directoryURL()!, settings: recordSettings)
        } catch let error as NSError {
            LSPrint(error.localizedDescription)
        }
    }
    
    func setupUI() {
        let startBtn = UIButton()
        startBtn.setTitle("开始录音", for: .normal)
        startBtn.setTitleColor(.black, for: .normal)
        startBtn.addTarget(self, action: #selector(LSRecordSoundViewController.startRecord), for: .touchUpInside)
        
        let stopBtn = UIButton()
        stopBtn.setTitle("停止录音", for: .normal)
        stopBtn.setTitleColor(.black, for: .normal)
        stopBtn.addTarget(self, action: #selector(LSRecordSoundViewController.stopRecord), for: .touchUpInside)
        
        let playBtn = UIButton()
        playBtn.setTitle("开始播放", for: .normal)
        playBtn.setTitleColor(.black, for: .normal)
        playBtn.addTarget(self, action: #selector(LSRecordSoundViewController.playRecord), for: .touchUpInside)
        
        let pauseBtn = UIButton()
        pauseBtn.setTitle("暂停播放", for: .normal)
        pauseBtn.setTitleColor(.black, for: .normal)
        pauseBtn.addTarget(self, action: #selector(LSRecordSoundViewController.pauseRecord), for: .touchUpInside)
        
        view.addSubview(startBtn)
        view.addSubview(stopBtn)
        view.addSubview(playBtn)
        view.addSubview(pauseBtn)
        
        startBtn.snp.makeConstraints { (make) in
            make.top.equalTo(20)
            make.centerX.equalTo(self.view)
        }
        
        stopBtn.snp.makeConstraints { (make) in
            make.top.equalTo(startBtn.snp.bottom).offset(20)
            make.centerX.equalTo(self.view)
        }
        
        playBtn.snp.makeConstraints { (make) in
            make.top.equalTo(stopBtn.snp.bottom).offset(20)
            make.centerX.equalTo(self.view)
        }
        
        pauseBtn.snp.makeConstraints { (make) in
            make.top.equalTo(playBtn.snp.bottom).offset(20)
            make.centerX.equalTo(self.view)
        }
    }
    
    func startRecord() {
        if !audioRecorder.isRecording {
            let audioSession = AVAudioSession.sharedInstance()
            do {
                try audioSession.setActive(true)
                audioRecorder.record()
                LSPrint("record!")
            } catch let error as NSError {
                LSPrint(error.localizedDescription)
            }
        }
    }
    
    func stopRecord() {
        audioRecorder.stop()
        let audioSession = AVAudioSession.sharedInstance()
        do {
            try audioSession.setActive(false)
            LSPrint("stop!")
        } catch let error as NSError {
            LSPrint(error.localizedDescription)
        }
        
        
        uploadSound()
    }
    
    func playRecord() {
        
        
        player.play()
        
        if !audioRecorder.isRecording {
            do {
                try audioPlayer = AVAudioPlayer(contentsOf: audioRecorder.url)
                audioPlayer.play()
                LSPrint("play!!")
            } catch let error as NSError {
                LSPrint(error.localizedDescription)
            }
        }
    }
    
    func pauseRecord() {
        if !audioRecorder.isRecording {
            do {
                try audioPlayer = AVAudioPlayer(contentsOf: audioRecorder.url)
                audioPlayer.pause()
                LSPrint("pause!!")
            } catch let error as NSError {
                LSPrint(error.localizedDescription)
            }
        }
    }

    func directoryURL() -> URL? {
        //根据时间设置存储文件名
//        let currentDateTime = NSDate()
//        let formatter = DateFormatter()
//        formatter.dateFormat = "ddMMyyyyHHmmss"
//        let recordingName = formatter.string(from: currentDateTime as Date)+".caf"
//        print(recordingName)
        
        let recordingName = "theSound.caf"
        
        let fileManager = FileManager.default
        let urls = fileManager.urls(for: .documentDirectory, in: .userDomainMask)
        let documentDirectory = urls[0] as NSURL
        let soundURL = documentDirectory.appendingPathComponent(recordingName)//将音频文件名称追加在可用路径上形成音频文件的保存路径
        
        theSoundUrl = soundURL?.absoluteString
        let index = theSoundUrl?.index((theSoundUrl?.startIndex)!, offsetBy: 7)
        theSoundUrl = theSoundUrl?.substring(from: index!)
        LSPrint(theSoundUrl)
        return soundURL
    }

    
    func uploadSound() {
        LSNetworking.sharedInstance.request(method: .GET, URLString: API_GET_QINIU_PARAMS, parameters: ["type" : "sound"], success: { (task, responseObject) in
            
            let config = QNConfiguration.build({ (builder) in
                builder?.setZone(QNZone.zone1())
            })
            
            let dic = responseObject as! NSDictionary
            let token : String = dic["token"] as! String
            let key : String = dic["key"] as! String
            self.publishSoundUrl = dic["img_url"] as? String
            
            let option = QNUploadOption(progressHandler: { (key, percent) in
                LSPrint("percent = \(percent)")
            })
            
            let upManager = QNUploadManager(configuration: config)
            upManager?.putFile(self.theSoundUrl, key: key, token: token, complete: { (info, key, resp) in
                if (info?.isOK)! {
                
                    SVProgressHUD.showSuccess(withStatus: "上传成功")
                    self.publish()
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
    
    func publish() {
        
    }
}
