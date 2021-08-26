//
//  ViewController.swift
//  DataBaseDemo
//
//  Created by syc on 2021/8/25.
//

import UIKit
import WCDBSwift

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.view.backgroundColor = UIColor.white
        
        
        print("==== create ====")
        WCDBSwiftManager.shared.create(table: WCDBSwiftStructModel.self)
        WCDBSwiftManager.shared.create(table: WCDBSwiftClassModel.self)
        
        print("==== query ====")
        self.queryObj()
        self.queryList()

        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.5) {
            print("==== insert ====")
            self.insert()
            self.queryObj()
            self.queryList()
            self.queryCount()
        }

        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 1) {
            print("==== update ====")
            self.update()
            self.queryList()
        }

        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 1.5) {
            print("==== delete ====")
            self.delete()
            self.queryList()
        }

        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 2) {
            print("==== drop ====")
            self.drop()
        }
    }
    
    
    /// 增
    func insert(){
        let structModel1 = WCDBSwiftStructModel(identifier: 11, description: "struct desc 1", name: "struct haha 1")
        let structModel2 = WCDBSwiftStructModel(identifier: 22, description: "struct desc 2", name: "struct haha 2")
        let structModel3 = WCDBSwiftStructModel(identifier: 33, description: "struct desc 3", name: "struct haha 3")
        let classModel = WCDBSwiftClassModel()
        classModel.identifier = 123
        classModel.description = "class desc"
        classModel.name = "class haha"
        
        // 增
        // inser table xx values(..)
        WCDBSwiftManager.shared.insertTable(objects: [structModel1, structModel2, structModel3])
        WCDBSwiftManager.shared.insertTable(objects: [classModel])
    }
    
    /// 删
    func delete(){
        // delete table xx where name = 'delete'
        let condition = WCDBSwiftStructModel.Properties.name == "delete"
        WCDBSwiftManager.shared.delete(table: WCDBSwiftStructModel.self, condition: condition)
    }
    
    /// 改
    func update(){
        // update table xx name='delete' where id=22
        
        let structModel2 = WCDBSwiftStructModel(identifier: 44, description: "struct desc 2 -> 4", name: "delete")
        let propertys: [Property] = WCDBSwiftStructModel.Properties.all
        let condition = WCDBSwiftStructModel.Properties.name.like("%haha 2")
        
        WCDBSwiftManager.shared.update(object: structModel2, propertys: propertys, condition: condition)
    }
    
    /// 查 count
    func queryCount(){
        // select count(*) from table where id > 1 order by id desc
        let propertys: [Property] = [WCDBSwiftStructModel.Properties.any.count().as(WCDBSwiftStructModel.Properties.identifier)]
        let condition = WCDBSwiftStructModel.Properties.identifier > 1
        
        let obj: WCDBSwiftStructModel? = WCDBSwiftManager.shared.queryObject(propertys: propertys, condition: condition, orderList: nil, limit: nil, offset: nil)
        print("obj.id (count) = \(obj?.identifier)")
    }
    
    /// 查
    func queryObj(){
        // select id, name from table where id = 123
        let propertys: [Property] = [WCDBSwiftClassModel.Properties.identifier.asProperty(), WCDBSwiftClassModel.Properties.name.asProperty()]
        let condition = WCDBSwiftClassModel.Properties.identifier == 123
        let obj: WCDBSwiftClassModel? = WCDBSwiftManager.shared.queryObject(propertys: propertys, condition: condition, orderList: nil, limit: nil, offset: nil)
        print("obj.id = \(obj?.identifier)")
        print("obj.name = \(obj?.name)")
        print("obj.desc = \(obj?.description)")
    }
    
    /// 查
    func queryList(){
        // select * from table where id > 1 order by id desc
        let propertys: [Property] = WCDBSwiftStructModel.Properties.all
        let condition = WCDBSwiftStructModel.Properties.identifier > 1
        let order: OrderBy = WCDBSwiftStructModel.Properties.identifier.asOrder(by: .descending)
        
        let list: [WCDBSwiftStructModel]? = WCDBSwiftManager.shared.queryList(propertys: propertys, condition: condition, orderList: [order], limit: nil, offset: nil)
        
        for item in list ?? [] {
            print("item.id = \(item.identifier)")
            print("item.name = \(item.name)")
            print("item.desc = \(item.description)")
        }
    }
    
    func drop(){
        WCDBSwiftManager.shared.closeDataBase {
            print("drop database")
        }
    }
}

