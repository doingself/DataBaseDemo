//
//  WCDBSwiftModel.swift
//  DataBaseDemo
//
//  Created by syc on 2021/8/25.
//

import Foundation
import WCDBSwift

struct WCDBSwiftStructModel: TableCodable {
    
    var identifier: Int?
    var description: String?
    var name: String?
    
    enum CodingKeys: String, CodingTableKey {
        typealias Root = WCDBSwiftStructModel
        static let objectRelationalMapping = TableBinding(CodingKeys.self)
        
        case identifier
        case description
        case name
    }
    
}


class WCDBSwiftClassModel: TableCodable {
    
    var identifier: Int?
    var description: String?
    var name: String?
    
    enum CodingKeys: String, CodingTableKey {
        typealias Root = WCDBSwiftClassModel
        
        static let objectRelationalMapping = TableBinding(CodingKeys.self)
        
        case identifier
        case description
        case name
    }
    
}


/// 模板 model
struct TemplateModel: TableCodable {
    
    var identifier: Int?
    var description: String?
    var name: String?
    
    enum CodingKeys: String, CodingTableKey {
        typealias Root = TemplateModel
        static let objectRelationalMapping = TableBinding(CodingKeys.self)
        
        case identifier = "id"
        case description
        case name
        
        /// 列约束
        static var columnConstraintBindings: [TemplateModel.CodingKeys : ColumnConstraintBinding]? {
            return [
                identifier: ColumnConstraintBinding(
                    isPrimary:  true, // 是否主键
                    orderBy: nil, // 主键时, 存储的排序方式
                    isAutoIncrement: false, // 主键自增
                    onConflict: nil, // 主键冲突后处理
                    isNotNull: true, // 是否可空
                    isUnique: true, // 是否唯一
                    defaultTo:  nil // 默认值
                ),
                name: ColumnConstraintBinding(defaultTo: ColumnDef.DefaultType.text("name"))
            ]
        }
        
        /// 索引
        static var indexBindings: [IndexBinding.Subfix : IndexBinding]? {
            return [
                "_uniqueIndex": IndexBinding(isUnique: true, indexesBy: identifier)
            ]
        }
        
        /// 表约束
        static var tableConstraintBindings: [String : TableConstraintBinding]? {
            /*
            MultiPrimaryBinding: 联合主键约束
            MultiUniqueBinding: 联合唯一约束
            CheckBinding: 检查约束
            ForeignKeyBinding: 外键约束
            */
            return nil
        }
        static var virtualTableBinding: VirtualTableBinding? {
            return nil
        }
        
    }
    
}
