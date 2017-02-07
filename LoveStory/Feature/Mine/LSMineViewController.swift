//
//  LSMineViewController.swift
//  LoveStory
//
//  Created by songlong on 2017/1/13.
//  Copyright © 2017年 com.Saber. All rights reserved.
//

import UIKit
import AVFoundation

class LSMineViewController: UITableViewController {
    
    private let dataSource: [[[String: String]]] = [
                                            [["name": "个人资料", "img": "setting-1"]],
                                            
                                            [["name": "关于我们", "img": "setting-8"],
                                             ["name": "给个好评", "img": "setting-7"],
                                             ["name": "帮助中心", "img": "setting-6"]],
                                            
                                            [["name": "退出登录", "img": "setting-11"]]
                                           ]

    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView = UITableView(frame: UIScreen.main.bounds, style: .grouped)
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "MineCell")
        
//        获取网络资源时长
//        let audioAsset = AVURLAsset.init(url: URL(string: "http://ojae83ylm.bkt.clouddn.com/232fcad6d8a511e6b1045254005b67a6.mov")!)
//        let audioDuration = audioAsset.duration
//        let seconds = CMTimeGetSeconds(audioDuration)
//        LSPrint(seconds)
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        
        return dataSource.count
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return dataSource[section].count
    }

    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MineCell", for: indexPath)
        cell.selectionStyle = .none
        cell.accessoryType = .disclosureIndicator
        cell.textLabel?.text = dataSource[indexPath.section][indexPath.row]["name"]
        cell.imageView?.image = UIImage(named: dataSource[indexPath.section][indexPath.row]["img"]!)
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        
        if indexPath.section == 0 {
            let vc = LSProfileViewController()
            vc.title = dataSource[indexPath.section][indexPath.row]["name"]
            navigationController?.pushViewController(vc, animated: true)
        }
        
        if indexPath.section == 2 {
            clickLogout()
        }
        
    }
    
    private func clickLogout() {
        
        let alert = UIAlertController(title: "确定退出？", message: nil, preferredStyle: .alert)
        let actionYes = UIAlertAction(title: "退出", style: .destructive, handler: {
            (action) in
            LSUser.currentUser()?.user_delete()
            exit(0)
        })
        let actionNo = UIAlertAction(title: "取消", style: .cancel, handler: nil)
        alert.addAction(actionYes)
        alert.addAction(actionNo)
        present(alert, animated: true, completion: nil)
    }
}
