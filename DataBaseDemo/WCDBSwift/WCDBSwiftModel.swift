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
