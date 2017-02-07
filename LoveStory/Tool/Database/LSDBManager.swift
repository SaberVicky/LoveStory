//
//  LSDBManager.swift
//  LoveStory
//
//  Created by songlong on 2017/1/19.
//  Copyright © 2017年 com.Saber. All rights reserved.
//

import UIKit
import FMDB

class LSDBManager: NSObject {
    
    public class func dbPath() -> String {
        let paths = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)
        let docsDir = paths[0] as String
        let databasePath = docsDir.appending("/lovestory.db")
        return databasePath
    }
    
    public class func dbinit() {
        var db = FMDatabase(path: dbPath())
        if !(db?.open())! {
            db = nil
            return
        }
        
        LSPrint("数据库创建成功")
        LSUser.user_create_table()
    }
}
