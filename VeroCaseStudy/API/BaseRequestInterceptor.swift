//
//  BaseRequestInterceptor.swift
//  VeroCaseStudy
//
//  Created by Adem Burak Cevizli on 31.03.2023.
//

import Alamofire
import Foundation

var token = "400d79c9dee7a81fe83d899d995a869584e531f4"

class BaseRequestInterceptor: RequestInterceptor {
    
    enum ApiResponse<T> {
        case success(T)
        case error(ClientError)
    }
    
    enum ClientError: Error{
        case invalidUrl
        case networkError
        case jsonSerializationError(reason: Swift.Error)
        case invalidJsonData
        case noDataReceived
        case cannotParseJson
        case httpError(status: Int)
    }
    
    
    func adapt(_ urlRequest: URLRequest, for session: Session, completion: @escaping (ApiResponse<URLRequest>) -> Void) {
        var adaptedRequest = urlRequest
        adaptedRequest.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        completion(.success(adaptedRequest))
    }
}
