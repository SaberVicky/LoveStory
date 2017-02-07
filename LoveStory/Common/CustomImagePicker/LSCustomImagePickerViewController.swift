//
//  LSCustomImagePickerViewController.swift
//  LoveStory
//
//  Created by songlong on 2017/1/19.
//  Copyright © 2017年 com.Saber. All rights reserved.
//

import UIKit

class LSCustomImagePickerViewController: UIImagePickerController {

    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationBar.setBackgroundImage(UIImage(color: LSMainColor), for: .default)
        self.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.white]

        // Do any additional setup after loading the view.
    }

    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }


}
