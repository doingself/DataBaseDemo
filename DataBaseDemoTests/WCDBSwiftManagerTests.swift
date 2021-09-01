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
        
        do {
            try WCDBSwiftManager.shared.begin()
            
            try WCDBSwiftManager.shared.insert(objects: [structModel1])
            try WCDBSwiftManager.shared.insert(objects: [structModel2])
            try WCDBSwiftManager.shared.insert(objects: [structModel3])
            
            try WCDBSwiftManager.shared.commit()
        } catch {
            try? WCDBSwiftManager.shared.rollback()
        }
        
        // 查
        let propertys: [Property] = WCDBSwiftStructModel.Properties.all
        let order: OrderBy = WCDBSwiftStructModel.Properties.identifier.asOrder(by: .descending)
        let list: [WCDBSwiftStructModel]? = WCDBSwiftManager.shared.queryList(propertys: propertys, condition: nil, orderList: [order], limit: nil, offset: nil)
        XCTAssert(list?.count == 3)
    }
    
    /// 改
    func testUpdate(){
        let structModel2 = WCDBSwiftStructModel(identifier: 44, description: "struct desc 2 -> 4", name: "delete")
        let updatePropertys: [Property] = WCDBSwiftStructModel.Properties.all
        let updateCondition = WCDBSwiftStructModel.Properties.name.like("%haha 2")
        WCDBSwiftManager.shared.updateCatch(object: structModel2, propertys: updatePropertys, condition: updateCondition)
        
        // 查
        let propertys: [Property] = WCDBSwiftStructModel.Properties.all
        let condition = WCDBSwiftStructModel.Properties.identifier > 33
        let order: OrderBy = WCDBSwiftStructModel.Properties.identifier.asOrder(by: .descending)
        let obj: WCDBSwiftStructModel? = WCDBSwiftManager.shared.queryObject(propertys: propertys, condition: condition, orderList: [order], limit: nil, offset: nil)
        XCTAssert(obj?.identifier == 44)
        XCTAssert(obj?.description == "struct desc 2 -> 4")
        XCTAssert(obj?.name == "delete")
    }
    
    /// 删
    func testDelete(){
        let deleteCondition = WCDBSwiftStructModel.Properties.name == "delete"
        WCDBSwiftManager.shared.deleteCatch(table: WCDBSwiftStructModel.self, condition: deleteCondition)
        
        // 查
        let propertys: [Property] = WCDBSwiftStructModel.Properties.all
        let condition = deleteCondition
        let order: OrderBy = WCDBSwiftStructModel.Properties.identifier.asOrder(by: .descending)
        let list: [WCDBSwiftStructModel]? = WCDBSwiftManager.shared.queryList(propertys: propertys, condition: condition, orderList: [order], limit: nil, offset: nil)
        XCTAssert(list?.count == 0)
    }
}
