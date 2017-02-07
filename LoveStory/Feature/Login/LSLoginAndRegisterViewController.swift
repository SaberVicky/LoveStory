//
//  LSLoginViewController.swift
//  LoveStory
//
//  Created by songlong on 2016/12/27.
//  Copyright © 2016年 com.Saber. All rights reserved.
//

import UIKit
import SnapKit
import SVProgressHUD
import HyphenateLite

class LSLoginAndRegisterViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
    
    var pageControl : UIPageControl!
    
    var firstIcon: UIImageView!
    var secondIcon: UIImageView!
    var thirdIcon: UIImageView!
    var forthIcon: UIImageView!
    
    let dataList = [["top": "情侣专属", "bottom": "直属于你和你的另一半的私密空间"],
                    ["top": "私密聊天", "bottom": "用最平凡的文字说出动人的语言"],
                    ["top": "记录生活", "bottom": "记录你们日常生活中的每一个时刻"],
                    ["top": "更多", "bottom": "快乐彼此，不再让你孤单"]]
    let imgList = ["start-up-1", "start-up-2", "start-up-3", "start-up-4"]
    
    var count = 0
    
    lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = UIScreen.main.bounds.size
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0
        layout.scrollDirection = .horizontal
        let collectionView = UICollectionView(frame: UIScreen.main.bounds, collectionViewLayout: layout)
        collectionView.isPagingEnabled = true
        collectionView.backgroundColor = .clear
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.bounces = false
        return collectionView
    }()
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if count == 0 {
            if LSUser.isRegisteredNotPaired() {
                let nav = CustionNavigationViewController(rootViewController: LSInviteViewController())
                present(nav, animated: false, completion: nil)
                count = count + 1
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
    }
    
    private func setupUI() {
        
        view.backgroundColor = .lightGray
        
        forthIcon = UIImageView(image: UIImage(named: imgList[3]))
        forthIcon.frame = UIScreen.main.bounds
        view.addSubview(forthIcon)
        
        thirdIcon = UIImageView(image: UIImage(named: imgList[2]))
        thirdIcon.frame = UIScreen.main.bounds
        view.addSubview(thirdIcon)
        
        secondIcon = UIImageView(image: UIImage(named: imgList[1]))
        secondIcon.frame = UIScreen.main.bounds
        view.addSubview(secondIcon)
        
        firstIcon = UIImageView(image: UIImage(named: imgList[0]))
        firstIcon.frame = UIScreen.main.bounds
        view.addSubview(firstIcon)
        
        let tempView = UIView(frame: UIScreen.main.bounds)
        tempView.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.2)
        view.addSubview(tempView)
        
        collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "loginCell")
        view.addSubview(collectionView)
        
        pageControl = UIPageControl()
        pageControl.currentPageIndicatorTintColor = .white
        pageControl.pageIndicatorTintColor = .lightGray
        pageControl.numberOfPages = dataList.count
        view.addSubview(pageControl)
        pageControl.snp.makeConstraints { (make) in
            make.centerX.equalTo(view)
            make.bottom.equalTo(-66)
        }
        
        let registerButton = UIButton()
        registerButton.addTarget(self, action: #selector(clickRegister), for: .touchUpInside)
        registerButton.setTitle("注册", for: .normal)
        registerButton.setTitleColor(.white, for: .normal)
        registerButton.backgroundColor = .green
        registerButton.layer.cornerRadius = 5
        registerButton.layer.masksToBounds = true
        view.addSubview(registerButton)
        registerButton.snp.makeConstraints { (make) in
            make.centerX.equalTo(self.view).offset(-UIScreen.main.bounds.size.width / 4)
            make.height.equalTo(50)
            make.width.equalTo(self.view).multipliedBy(0.45)
            make.bottom.equalTo(self.view).offset(-10)
        }
        
        let loginButton = UIButton()
        loginButton.addTarget(self, action: #selector(clickLogin), for: .touchUpInside)
        loginButton.setTitle("登录", for: .normal)
        loginButton.setTitleColor(.lightGray, for: .normal)
        loginButton.backgroundColor = .white
        loginButton.layer.cornerRadius = 5
        loginButton.layer.masksToBounds = true
        view.addSubview(loginButton)
        loginButton.snp.makeConstraints { (make) in
            make.centerX.equalTo(self.view).offset(UIScreen.main.bounds.size.width / 4)
            make.height.equalTo(50)
            make.width.equalTo(self.view).multipliedBy(0.45)
            make.bottom.equalTo(self.view).offset(-10)
        }
        
    }
    
    func clickLogin() {
        let vc = LSLoginViewController()
        let nav = CustionNavigationViewController(rootViewController: vc)
        self.present(nav, animated: true, completion: nil)
    }
    
    func clickRegister() {
        let vc = LSRegisterViewController()
        let nav = CustionNavigationViewController(rootViewController: vc)
        self.present(nav, animated: true, completion: nil)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return  dataList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "loginCell", for: indexPath)
        
        cell.backgroundColor = .clear
        cell.contentView.backgroundColor = .clear
        
        for view in cell.contentView.subviews {
            view.removeFromSuperview()
        }
        
        let topLabel = UILabel()
        
        topLabel.text = dataList[indexPath.item]["top"]
        topLabel.textColor = .white
        topLabel.font = UIFont.systemFont(ofSize: 14)
        cell.contentView.addSubview(topLabel)
        topLabel.snp.makeConstraints { (make) in
            make.centerX.equalTo(cell.contentView)
            make.bottom.equalTo(-130)
        }
        
        let bottomLabel = UILabel()
        
        bottomLabel.text = dataList[indexPath.item]["bottom"]
        bottomLabel.textColor = .white
        bottomLabel.font = UIFont.systemFont(ofSize: 13)
        cell.contentView.addSubview(bottomLabel)
        bottomLabel.snp.makeConstraints { (make) in
            make.centerX.equalTo(cell.contentView)
            make.top.equalTo(topLabel.snp.bottom).offset(5)
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didEndDisplaying cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        
        pageControl.currentPage = (collectionView.indexPathsForVisibleItems.first?.item)!
    }

    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        firstIcon.alpha = 1 - scrollView.contentOffset.x / LSWidth
        secondIcon.alpha = 1 - abs(scrollView.contentOffset.x - 1 * LSWidth) / LSWidth
        thirdIcon.alpha = 1 - abs(scrollView.contentOffset.x - 2 * LSWidth) / LSWidth
        forthIcon.alpha = 1 - abs(scrollView.contentOffset.x - 3 * LSWidth) / LSWidth
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
}




//    func toRegister() {
//        view.endEditing(true)
//
//        SVProgressHUD.show()
//        LSNetworking.sharedInstance.request(method: .POST, URLString: API_REGISTER, parameters: ["user_account": accountTextField.text, "user_password" : passwordTextField.text], success: { (task, responseObject) in
//            SVProgressHUD.dismiss()
//
//            let dic = responseObject as! NSDictionary
//            let ret : NSInteger = dic["ret"] as! NSInteger
//            ret==1 ? SVProgressHUD.showSuccess(withStatus: "注册成功") : SVProgressHUD.showError(withStatus: "注册失败")
//            if ret==1 {
//                self.backToLogin()
//                let error = EMClient.shared().register(withUsername: self.accountTextField.text, password: HuanXinPassword)
//                if error == nil {
//                    LSPrint("注册环信成功")
//                } else {
//                    LSPrint("注册环信失败")
//                }
//            }
//
//        }, failure: { (task, error) in
//            SVProgressHUD.dismiss()
//            SVProgressHUD.showError(withStatus: "注册失败")
//        })
//    }
//
//    func clickLogin() {
//        view.endEditing(true)
//
//        SVProgressHUD.show()
//        LSNetworking.sharedInstance.request(method: .POST, URLString: API_LOGIN, parameters: ["user_account": accountTextField.text, "user_password" : passwordTextField.text], success: { (task, responseObject) in
//            SVProgressHUD.dismiss()
//
//            let dic = responseObject as! NSDictionary
//            let ret : NSInteger = dic["ret"] as! NSInteger
//            ret==1 ? SVProgressHUD.showSuccess(withStatus: "登录成功") : SVProgressHUD.showError(withStatus: "登录失败")
//            if ret==1 {
//                LSGlobal.setUserAccount(account: self.accountTextField.text)
//                self.loginSuccess()
//            }
//
//        }, failure: { (task, error) in
//            SVProgressHUD.dismiss()
//            SVProgressHUD.showError(withStatus: "登录失败")
//        })
//    }
//
//    func loginSuccess() {
//
//        loginHuanXin()
//
//        UIApplication.shared.keyWindow?.rootViewController = CustomTabBarViewController()
//    }
//
//    private func loginHuanXin() {
//
//        let error = EMClient.shared().login(withUsername: accountTextField.text, password: HuanXinPassword)
//        if error == nil {
//            LSPrint("登录成功")
//            EMClient.shared().setApnsNickname("张老师")
//        } else {
//            LSPrint("登录失败")
//        }
//    }
//}

