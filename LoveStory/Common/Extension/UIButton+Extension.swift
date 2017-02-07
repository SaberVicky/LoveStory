
//
//  UIButton+Extension.swift
//  LoveStory
//
//  Created by songlong on 2016/12/27.
//  Copyright © 2016年 com.Saber. All rights reserved.
//

import UIKit

extension UIButton {
    convenience init(title: String, color: UIColor, imgName: String?) {
        self.init()
        setTitle(title, for: .normal)
        setTitleColor(color, for: .normal)
        setBackgroundImage(UIImage(named: imgName!), for: .normal)
        sizeToFit()
    }
}
