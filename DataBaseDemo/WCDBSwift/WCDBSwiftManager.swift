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
    
    private let dataBase: Database
    
    private override init() {
        
        // 初始化数据库
        let dataBasePath = NSSearchPathForDirectoriesInDomains(
            FileManager.SearchPathDirectory.documentDirectory,
            FileManager.SearchPathDomainMask.userDomainMask,
            true).last! + "/DataBase.DB"
        
        dataBase = Database(withPath: dataBasePath)
        
        super.init()
    }
}

extension WCDBSwiftManager {
    
    /// 关闭数据库
    func closeDataBase(completed: ( () -> Void )?) {
        dataBase.close {
            try? dataBase.removeFiles()
            completed?()
        }
    }
    
    /// 创建表
    func create<T: TableCodable>(table: T.Type) {
        do {
            try dataBase.create(table: "\(table.self)", of: table)
        } catch {
            debugPrint("create table [\(table.self)] error \(error.localizedDescription)")
        }
    }
    
    /// 插入
    func insertTable<T: TableCodable>(objects: [T]) {
        do {
            try dataBase.insert(objects: objects, intoTable: "\(T.self)")
        } catch {
            debugPrint("insert table [\(T.self)] error \(error.localizedDescription)")
        }
    }
    
    /// 修改
    func update<T: TableCodable>(object: T, propertys:[PropertyConvertible], condition: Condition?){
        do {
            try dataBase.update(table: "\(T.self)", on: propertys, with: object, where: condition, orderBy: nil, limit: nil, offset: nil)
        } catch {
            debugPrint("update table [\(T.self)] error \(error.localizedDescription)")
        }
    }
    
    /// 删除
    func delete<T: TableCodable>(table: T.Type = T.self, condition: Condition?) {
        do {
            try dataBase.delete(fromTable: "\(table.self)", where: condition, orderBy: nil, limit: nil, offset: nil)
        } catch {
            debugPrint("delete table [\(table.self)] error \(error.localizedDescription)")
        }
    }
    
    /// 查询当个对象
    func queryObject<T: TableCodable>(propertys: [PropertyConvertible], condition: Condition?, orderList: [OrderBy]?, limit: Limit?, offset: Offset?) -> T? {
        do {
            let object: T? = try dataBase.getObject(on: propertys, fromTable: "\(T.self)", where: condition, orderBy: orderList, offset: offset)
            return object
        } catch {
            debugPrint("queryObject [\(T.self)] error \(error.localizedDescription)")
        }
        return nil
    }
    
    /// 查询列表
    func queryList<T: TableCodable>(propertys: [PropertyConvertible], condition: Condition?, orderList: [OrderBy]?, limit: Limit?, offset: Offset?) -> [T]? {
        do {
            let allObjects: [T] = try dataBase.getObjects(on: propertys, fromTable: "\(T.self)", where: condition, orderBy: orderList, limit: limit, offset: offset)
            return allObjects
        } catch {
            debugPrint("queryList [\(T.self)] error \(error.localizedDescription)")
        }
        return nil
    }
}
