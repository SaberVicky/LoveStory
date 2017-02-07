//
//  LSUser.swift
//  LoveStory
//
//  Created by songlong on 2016/12/27.
//  Copyright © 2016年 com.Saber. All rights reserved.
//

import UIKit
import FMDB

class LSUser: NSObject {
    var user_userId: String? = ""
    var user_account: String?
    var user_name: String?
    var user_sex: String?
    var user_avator: String?
    var user_birthday: String?
    var user_huanxinAccount: String?
    var user_huanxinPassword: String?
    var user_inviteCode: String?
    var user_coupleAccount: String? = ""
    var user_coupleName: String? = ""
    var user_coupleAvator: String? = ""
    
    public class func userWithDic(dic: [String: String]) -> LSUser {
        let user = LSUser()
        user.user_account = dic["user_account"]
        user.user_userId = dic["user_id"]
        user.user_sex = dic["user_sex"]
        user.user_name = dic["user_name"]
        user.user_avator = dic["user_avator"]
        user.user_birthday = dic["user_birthday"]
        user.user_huanxinAccount = dic["user_huanXinAccount"]
        user.user_huanxinPassword = dic["user_huanXinAccount"]
        user.user_inviteCode = dic["invite_code"]

        return user
    }
    
    public class func user_create_table() {
        let sql = "CREATE TABLE IF NOT EXISTS USER_T (USER_ID TEXT PRIMARY KEY, USER_ACCOUNT TEXT, USER_NAME TEXT, USER_SEX TEXT, USER_AVATOR TEXT, USER_BIRTHDAY TEXT, USER_HUANXIN_ACCOUNT TEXT, USER_HUANXIN_PASSWORD TEXT, USER_INVITE_CODE TEXT, USER_COUPLE_ACCOUNT TEXT, USER_COUPLE_NAME TEXT, USER_COUPLE_AVATOR TEXT)"
        FMDatabaseQueue(path: LSDBManager.dbPath()).inDatabase { (db) in
            if (db?.executeStatements(sql))! {
                LSPrint("创建User表成功")
            } else {
                LSPrint("创建User表失败")
            }
        }
    }
    
    
    public class func currentUser() -> LSUser? {
        var user: LSUser? = nil
        let sql = "SELECT * FROM USER_T"
        FMDatabaseQueue(path: LSDBManager.dbPath()).inDatabase { (db) in
            do {
                let result = try db?.executeQuery(sql, values: nil)
                if (result?.next())! {
                    user = LSUser()
                    user?.user_userId = result?.string(forColumn: "USER_ID")
                    user?.user_account = result?.string(forColumn: "USER_ACCOUNT")
                    user?.user_name = result?.string(forColumn: "USER_NAME")
                    user?.user_sex = result?.string(forColumn: "USER_SEX")
                    user?.user_avator = result?.string(forColumn: "USER_AVATOR")
                    user?.user_birthday = result?.string(forColumn: "USER_BIRTHDAY")
                    user?.user_huanxinAccount = result?.string(forColumn: "USER_HUANXIN_ACCOUNT")
                    user?.user_huanxinPassword = result?.string(forColumn: "USER_HUANXIN_PASSWORD")
                    user?.user_inviteCode = result?.string(forColumn: "USER_INVITE_CODE")
                    user?.user_coupleAccount = result?.string(forColumn: "USER_COUPLE_ACCOUNT")
                    user?.user_coupleName = result?.string(forColumn: "USER_COUPLE_NAME")
                    user?.user_coupleAvator = result?.string(forColumn: "USER_COUPLE_AVATOR")
                }
                result?.close()
            } catch let error as NSError {
                LSPrint(error.localizedDescription)
            }
        }
        return user
    }
    
    public class func user_select(userId: String) -> LSUser? {
        
        var user: LSUser? = nil
        
        let sql = "SELECT * FROM USER_T WHERE USER_ID = '\(userId)'"
        FMDatabaseQueue(path: LSDBManager.dbPath()).inDatabase { (db) in
            do {
                let result = try db?.executeQuery(sql, values: nil)
                if (result?.next())! {
                    user = LSUser()
                    user?.user_userId = result?.string(forColumn: "USER_ID")
                    user?.user_account = result?.string(forColumn: "USER_ACCOUNT")
                    user?.user_name = result?.string(forColumn: "USER_NAME")
                    user?.user_sex = result?.string(forColumn: "USER_SEX")
                    user?.user_avator = result?.string(forColumn: "USER_AVATOR")
                    user?.user_birthday = result?.string(forColumn: "USER_BIRTHDAY")
                    user?.user_huanxinAccount = result?.string(forColumn: "USER_HUANXIN_ACCOUNT")
                    user?.user_huanxinPassword = result?.string(forColumn: "USER_HUANXIN_PASSWORD")
                    user?.user_inviteCode = result?.string(forColumn: "USER_INVITE_CODE")
                    user?.user_coupleAccount = result?.string(forColumn: "USER_COUPLE_ACCOUNT")
                    user?.user_coupleName = result?.string(forColumn: "USER_COUPLE_NAME")
                    user?.user_coupleAvator = result?.string(forColumn: "USER_COUPLE_AVATOR")
                }
                result?.close()
            } catch let error as NSError {
                LSPrint(error.localizedDescription)
            }
        }
        return user
    }
    
    func user_add() {
        let sql = "INSERT INTO USER_T (USER_ID, USER_ACCOUNT, USER_NAME, USER_SEX, USER_AVATOR, USER_BIRTHDAY, USER_HUANXIN_ACCOUNT, USER_HUANXIN_PASSWORD, USER_INVITE_CODE, USER_COUPLE_ACCOUNT, USER_COUPLE_NAME, USER_COUPLE_AVATOR) VALUES ('\(user_userId!)', '\(user_account!)', '\(user_name!)', '\(user_sex!)', '\(user_avator!)', '\(user_birthday!)', '\(user_huanxinAccount!)', '\(user_huanxinPassword!)', '\(user_inviteCode!)', '\(user_coupleAccount!)', '\(user_coupleName!)', '\(user_coupleAvator!)')"
        FMDatabaseQueue(path: LSDBManager.dbPath()).inDatabase { (db) in
            do {
                try db?.executeUpdate(sql, values: nil)
                LSPrint("添加用户成功")
            } catch let error as NSError {
                LSPrint("添加用户失败")
                LSPrint(error.localizedDescription)
            }
        }
    }
    
    func user_delete() {
        let sql = "DELETE FROM USER_T WHERE USER_ID = '\(user_userId!)'"
        FMDatabaseQueue(path: LSDBManager.dbPath()).inDatabase { (db) in
            do {
                try db?.executeUpdate(sql, values: nil)
                LSPrint("删除用户成功")
            } catch let error as NSError {
                LSPrint("删除用户失败")
                LSPrint(error.localizedDescription)
            }
        }
    }
    
    func user_update() {
        let sql = "UPDATE USER_T SET USER_ACCOUNT = '\(user_account!)', USER_NAME = '\(user_name!)', USER_SEX = '\(user_sex!)', USER_AVATOR = '\(user_avator!)', USER_BIRTHDAY = '\(user_birthday!)', USER_HUANXIN_ACCOUNT = '\(user_huanxinAccount!)', USER_HUANXIN_PASSWORD = '\(user_huanxinPassword!)', USER_INVITE_CODE = '\(user_inviteCode!)', USER_COUPLE_ACCOUNT = '\(user_coupleAccount!)', USER_COUPLE_NAME = '\(user_coupleName!)', USER_COUPLE_AVATOR = '\(user_coupleAvator!)' WHERE USER_ID = '\(user_userId!)'"
        FMDatabaseQueue(path: LSDBManager.dbPath()).inDatabase { (db) in
            do {
                try db?.executeUpdate(sql, values: nil)
                LSPrint("更新用户成功")
            } catch let error as NSError {
                LSPrint("更新用户失败")
                LSPrint(error.localizedDescription)
            }
        }
    }
    
    class func isRegisteredNotPaired() -> Bool {
        let user = LSUser.currentUser()
        if ((user?.user_coupleAccount) != nil) && (user?.user_coupleAccount == "") {
            return true
        } else {
            return false
        }
    }
}
