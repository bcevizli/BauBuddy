//
//  User.swift
//  VeroCaseStudy
//
//  Created by Adem Burak Cevizli on 31.03.2023.
//

import Foundation

class User: Codable {
    let username: String
    let password: String
    
    enum CodingKeys: String, CodingKey {
        case username = "username"
        case password = "password"
    }
    
    init(username: String, password: String) {
        self.username = username
        self.password = password
    }
}
