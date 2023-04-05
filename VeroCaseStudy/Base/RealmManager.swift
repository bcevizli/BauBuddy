//
//  RealmManager.swift
//  VeroCaseStudy
//
//  Created by Adem Burak Cevizli on 5.04.2023.
//

import Foundation
import RealmSwift

class RealmManager {
    let realm = try! Realm()
    
    func save(on itemObject: Items?) {
        if let itemObject = itemObject {
            let item = Items()
            item.task = itemObject.task
            item.title = itemObject.title
            item.desc = itemObject.desc
            item.colorCode = itemObject.colorCode
            realm.beginWrite()
            realm.add(item)
            try! realm.commitWrite()
            
        }
    }
    
    func deleteAll() {
        realm.beginWrite()
        realm.deleteAll()
        try! realm.commitWrite()
    }
    
    func fetch() -> [Items]? {
        var itemArray: [Items] = []
        let items = realm.objects(Items.self)
        items.forEach { itemObject in
            let item = Items()
            item.task = itemObject.task
            item.title = itemObject.title
            item.desc = itemObject.desc
            item.colorCode = itemObject.colorCode
            itemArray.append(item)
        }
       return itemArray
    }
}
