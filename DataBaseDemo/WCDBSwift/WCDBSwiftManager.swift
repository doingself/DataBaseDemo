//
//  WCDBSwiftManager.swift
//  DataBaseDemo
//
//  Created by syc on 2021/8/25.
//

import Foundation
import WCDBSwift

/// WCDBSwift 数据库 工具类
class WCDBSwiftManager: NSObject {
    static let shared = WCDBSwiftManager()
    
    private let database: Database
    
    private override init() {
        
        Database.globalTrace { (err: Error) in
            print("WCDBSwift err: \(err)")
        }
        Database.globalTrace { (sql: String) in
            print("WCDBSwift sql: \(sql)")
        }
        Database.globalTrace { tag, dict, num in
            print("WCDBSwift tag: \(tag ?? -1); num: \(num); dict: \(dict)")
        }
        
        // 初始化数据库
        let dataBasePath = NSSearchPathForDirectoriesInDomains(
            FileManager.SearchPathDirectory.documentDirectory,
            FileManager.SearchPathDomainMask.userDomainMask,
            true).last! + "/DataBase.DB"
        
        database = Database(withPath: dataBasePath)
        
        super.init()
    }
}

extension WCDBSwiftManager {
    /// 删除数据库
    func removeDataBase(){
        self.closeDataBase { [weak self] in
            try? self?.database.removeFiles()
        }
    }
    
    /// 关闭数据库
    func closeDataBase(completed: ( () -> Void )?) {
        database.close {
            completed?()
        }
    }
    
    /// 创建表
    func create<T: TableCodable>(table: T.Type) {
        do {
            try database.create(table: "\(table.self)", of: table)
        } catch {
            debugPrint("create table [\(table.self)] error \(error.localizedDescription)")
        }
    }
    
    
    /**
     获取事务, 多线程
     let transaction = getTransaction()
     DispatchQueue.main.async {
         transaction.begin()
         ...
         transaction.commit()
     }
     */
    func getTransaction() throws -> Transaction {
        let transaction: Transaction = try database.getTransaction()
        return transaction
    }
    
    /// 开始事务
    func begin() throws {
        try database.begin()
    }
    /// 提交事务
    func commit() throws {
        try database.commit()
    }
    /// 回滚事务
    func rollback() throws {
        try database.rollback()
    }
    
    /// 插入
    func insert<T: TableCodable>(objects: [T]) throws {
        try database.insert(objects: objects, intoTable: "\(T.self)")
    }
    
    /// 插入
    func insertCatch<T: TableCodable>(objects: [T]) {
        do {
            try insert(objects: objects)
        } catch {
            debugPrint("insert table [\(T.self)] error \(error.localizedDescription)")
        }
    }
    
    /// 修改
    func update<T: TableCodable>(object: T, propertys:[PropertyConvertible], condition: Condition?) throws {
        try database.update(table: "\(T.self)", on: propertys, with: object, where: condition, orderBy: nil, limit: nil, offset: nil)
    }
    
    /// 修改
    func updateCatch<T: TableCodable>(object: T, propertys:[PropertyConvertible], condition: Condition?){
        do {
            try update(object: object, propertys: propertys, condition: condition)
        } catch {
            debugPrint("update table [\(T.self)] error \(error.localizedDescription)")
        }
    }
    
    /// 删除
    func delete<T: TableCodable>(table: T.Type, condition: Condition?) throws {
        try database.delete(fromTable: "\(table.self)", where: condition, orderBy: nil, limit: nil, offset: nil)
    }
    
    /// 删除
    func deleteCatch<T: TableCodable>(table: T.Type = T.self, condition: Condition?) {
        do {
            try delete(table: table, condition: condition)
        } catch {
            debugPrint("delete table [\(table.self)] error \(error.localizedDescription)")
        }
    }
    
    /// 查询当个对象
    func queryObject<T: TableCodable>(propertys: [PropertyConvertible], condition: Condition?, orderList: [OrderBy]?, limit: Limit?, offset: Offset?) -> T? {
        do {
            let object: T? = try database.getObject(on: propertys, fromTable: "\(T.self)", where: condition, orderBy: orderList, offset: offset)
            return object
        } catch {
            debugPrint("queryObject [\(T.self)] error \(error.localizedDescription)")
        }
        return nil
    }
    
    /// 查询列表
    func queryList<T: TableCodable>(propertys: [PropertyConvertible], condition: Condition?, orderList: [OrderBy]?, limit: Limit?, offset: Offset?) -> [T]? {
        do {
            let allObjects: [T] = try database.getObjects(on: propertys, fromTable: "\(T.self)", where: condition, orderBy: orderList, limit: limit, offset: offset)
            return allObjects
        } catch {
            debugPrint("queryList [\(T.self)] error \(error.localizedDescription)")
        }
        return nil
    }
}
