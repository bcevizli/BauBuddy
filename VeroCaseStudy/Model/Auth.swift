//
//  Auth.swift
//  VeroCaseStudy
//
//  Created by Adem Burak Cevizli on 31.03.2023.
//

import Foundation

struct Auth: Decodable {
    
    let access_token: String
}
struct Result: Decodable {
    let oauth: Auth
}
