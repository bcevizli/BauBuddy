//
//  Items.swift
//  VeroCaseStudy
//
//  Created by Adem Burak Cevizli on 30.03.2023.
//

import Foundation
import RealmSwift

@objcMembers
class Items: Object, Decodable {
    
    dynamic var task: String
    dynamic var title: String
    dynamic var desc: String
    dynamic var colorCode: String
    
    enum CodingKeys: String, CodingKey {
        case task, title, colorCode
        case desc = "description"
    }
}
