//
//  Encodable.swift
//  VeroCaseStudy
//
//  Created by Adem Burak Cevizli on 31.03.2023.
//

import Foundation

extension Encodable {
    func toDictionary(_ encoder: JSONEncoder = JSONEncoder()) -> [String: Any] {
        let data = try! encoder.encode(self)
        let object = try! JSONSerialization.jsonObject(with: data)
        guard let json = object as? [String: Any] else {
            return [:]
        }
        return json
    }
}
