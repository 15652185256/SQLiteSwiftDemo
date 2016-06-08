//
//  ViewController.swift
//  SQLiteSwiftDemo
//
//  Created by 赵晓东 on 16/6/8.
//  Copyright © 2016年 ZXD. All rights reserved.
//

import UIKit
import SQLite

class ViewController: UIViewController {
    
    var db:Connection! = nil //数据库
    let users = Table("users")//表
    let id = Expression<Int64>("id")
    let name  = Expression<String>("name")
    let email = Expression<String>("email")

    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        let documentsFoler = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)[0]
        let dbPath = documentsFoler.stringByAppendingString("/db.sqlite3")
        
        //print(dbPath)
        
        //do try catch 错误处理模式
        do {
            self.db = try Connection(dbPath)
            //            try db.run(self.users.create(block: { (t) in
            //                t.column(self.id,primaryKey:true)
            //                t.column(self.name)
            //                t.column(self.email)
            //            }))
            
            try db.run(self.users.create { t in
                t.column(self.id,primaryKey:true)
                t.column(self.name)
                t.column(self.email)
                })
        } catch {
            print(error)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func insertClick(sender: AnyObject) {
        do {
            let insert = self.users.insert(name <- "王鹤" , email <- "123456@qq.com")
            try db.run(insert)
        } catch {
            print(error)
        }
    }
    
    @IBAction func deleteClick(sender: AnyObject) {
        do {
            let strongX = users.filter(id == 2)
            try db.run(strongX.delete())
        } catch {
            print(error)
        }
    }

    @IBAction func updateClick(sender: AnyObject) {
        do {
            let strongX = users.filter(id == 1)
            try db.run(strongX.update(name <- name.replace("王鹤", with: "张玉龙")))
        } catch {
            print(error)
        }
    }
    
    @IBAction func seleteClick(sender: AnyObject) {
        do {
            for user in try db.prepare(users) {
                print("id:\(user[id]) name:\(user[name]) email:\(user[email])")
            }
        } catch {
            print(error)
        }
    }
    
}

