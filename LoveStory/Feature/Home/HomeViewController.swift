//
//  HomeViewController.swift
//  LoveStory
//
//  Created by songlong on 2016/12/26.
//  Copyright © 2016年 com.Saber. All rights reserved.
//

import UIKit
import SVProgressHUD
import SnapKit

class HomeViewController: UITableViewController {
    
    private lazy var publishViewModel = PublishViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor(red: 240 / 255.0, green:  240 / 255.0, blue:  240 / 255.0, alpha: 1)
        tableView.refreshControl = UIRefreshControl()
        tableView.refreshControl?.addTarget(self, action: #selector(HomeViewController.requestData), for: .valueChanged)
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "新建", style: .plain, target: self, action: #selector(HomeViewController.create))
        tableView.register(LSPublishTextCell.self, forCellReuseIdentifier: "homeCell")
        tableView.separatorStyle = .none
        tableView.estimatedRowHeight = 100
        requestData()
    }
    
    func create() {
        navigationController?.pushViewController(LSPublishViewController(), animated: true)
    }
    
    func requestData() {
        SVProgressHUD.show()
        publishViewModel.loadPublishData { (isSuccessed) in
            SVProgressHUD.dismiss()
            self.tableView.refreshControl?.endRefreshing()
            if !isSuccessed {
                SVProgressHUD.showError(withStatus: "数据加载失败")
                return
            }
            SVProgressHUD.showSuccess(withStatus: "刷新成功")
            self.tableView.reloadData()
        }
    }
    
    // MARK: -
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return publishViewModel.publishList.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "homeCell", for: indexPath) as! LSPublishTextCell
        cell.publishModel = publishViewModel.publishList[indexPath.row]
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = LSReplyViewController()
        vc.publishModel = publishViewModel.publishList[indexPath.row]
        navigationController?.pushViewController(vc, animated: true)
    }
    
}
