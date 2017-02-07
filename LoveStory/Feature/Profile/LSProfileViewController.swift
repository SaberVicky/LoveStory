//
//  LSProfileViewController.swift
//  LoveStory
//
//  Created by songlong on 2017/1/19.
//  Copyright © 2017年 com.Saber. All rights reserved.
//

import UIKit

class LSProfileViewController: UITableViewController {

    private let dataList: [[String]] = [["更改头像", "昵称", "性别", "生日"], ["解除关系"]];
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        view.backgroundColor = .white
        tableView = UITableView(frame: UIScreen.main.bounds, style: .grouped)
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "ProfileCell")
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        
        return dataList.count
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return dataList[section].count
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ProfileCell", for: indexPath)
        cell.accessoryType = .disclosureIndicator
        cell.textLabel?.text = dataList[indexPath.section][indexPath.row]
        return cell
    }
}
