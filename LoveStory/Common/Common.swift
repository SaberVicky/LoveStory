//
//  Common.swift
//  LoveStory
//
//  Created by songlong on 2016/12/26.
//  Copyright © 2016年 com.Saber. All rights reserved.
//

// 目的：提供全局共享属性或者方法，类似于 pch 文件
import UIKit


let LSWidth = UIScreen.main.bounds.size.width
let LSHeight = UIScreen.main.bounds.size.height
let LSMainColor = UIColor.purple


func LSPrint<T>(_ message: T,
              file: String = #file,
              method: String = #function,
              line: Int = #line)
{
    #if DEBUG
        print("\((file as NSString).lastPathComponent)[\(line)], \(method): \(message)")
    #endif
}
