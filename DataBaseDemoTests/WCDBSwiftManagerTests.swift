//
//  WCDBSwiftManagerTests.swift
//  DataBaseDemoTests
//
//  Created by syc on 2021/8/25.
//

import XCTest
import WCDBSwift
@testable import DataBaseDemo

class WCDBSwiftManagerTests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        
        WCDBSwiftManager.shared.create(table: WCDBSwiftStructModel.self)
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        
        WCDBSwiftManager.shared.closeDataBase(completed: nil)
    }
    
    /// 增
    func testInsert(){
        let structModel1 = WCDBSwiftStructModel(identifier: 11, description: "struct desc 1", name: "struct haha 1")
        let structModel2 = WCDBSwiftStructModel(identifier: 22, description: "struct desc 2", name: "struct haha 2")
        let structModel3 = WCDBSwiftStructModel(identifier: 33, description: "struct desc 3", name: "struct haha 3")
        WCDBSwiftManager.shared.insertTable(objects: [structModel1, structModel2, structModel3])
        
        // 查
        let propertys: [Property] = WCDBSwiftStructModel.Properties.all
        let order: OrderBy = WCDBSwiftStructModel.Properties.identifier.asOrder(by: .descending)
        let list: [WCDBSwiftStructModel]? = WCDBSwiftManager.shared.queryList(propertys: propertys, condition: nil, orderList: [order], limit: nil, offset: nil)
        assert(list?.count == 3)
    }
    
    /// 改
    func testUpdate(){
        let structModel2 = WCDBSwiftStructModel(identifier: 44, description: "struct desc 2 -> 4", name: "delete")
        let updatePropertys: [Property] = WCDBSwiftStructModel.Properties.all
        let updateCondition = WCDBSwiftStructModel.Properties.name.like("%haha 2")
        WCDBSwiftManager.shared.update(object: structModel2, propertys: updatePropertys, condition: updateCondition)
        
        // 查
        let propertys: [Property] = WCDBSwiftStructModel.Properties.all
        let condition = WCDBSwiftStructModel.Properties.identifier > 33
        let order: OrderBy = WCDBSwiftStructModel.Properties.identifier.asOrder(by: .descending)
        let obj: WCDBSwiftStructModel? = WCDBSwiftManager.shared.queryObject(propertys: propertys, condition: condition, orderList: [order], limit: nil, offset: nil)
        assert(obj?.identifier == 44)
        assert(obj?.description == "struct desc 2 -> 4")
        assert(obj?.name == "delete")
    }
    
    /// 删
    func testDelete(){
        let deleteCondition = WCDBSwiftStructModel.Properties.name == "delete"
        WCDBSwiftManager.shared.delete(table: WCDBSwiftStructModel.self, condition: deleteCondition)
        
        // 查
        let propertys: [Property] = WCDBSwiftStructModel.Properties.all
        let condition = deleteCondition
        let order: OrderBy = WCDBSwiftStructModel.Properties.identifier.asOrder(by: .descending)
        let list: [WCDBSwiftStructModel]? = WCDBSwiftManager.shared.queryList(propertys: propertys, condition: condition, orderList: [order], limit: nil, offset: nil)
        assert(list?.count == 0)
    }
}
