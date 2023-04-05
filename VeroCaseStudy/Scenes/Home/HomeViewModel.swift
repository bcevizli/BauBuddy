//
//  HomeViewModel.swift
//  VeroCaseStudy
//
//  Created by Adem Burak Cevizli on 31.03.2023.
//

import Foundation
import Alamofire

class HomeViewModel {
    
    func loadJsonData(completion: @escaping ([Items]) -> Void) {
        let url = URL(string: "https://api.baubuddy.de/dev/index.php/v1/tasks/select")
        var taskUrlRequest: URLRequest!
        do {
            var urlRequest = try URLRequest(url: url!, method: .get)
            urlRequest.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
            taskUrlRequest = urlRequest
            
        }
        catch {
            print(error.localizedDescription)
        }
        
        AF.request(taskUrlRequest, interceptor: BaseRequestInterceptor()).response { response in
            
            print("Response Data \(response.debugDescription)")
            if let data = response.data {
                guard let jsonObject = try? JSONDecoder().decode([Items].self, from: response.data!) else {
                    return
                }
                completion(jsonObject)
            }
        }
    }
    func login(completion: @escaping () -> Void) {
        
        let parameters: [String:Any] = [
            "username": "365",
            "password": "1"
        ]
        
        let url = URL(string: "https://api.baubuddy.de/index.php/login")
        
        do {
            
            var urlRequest = try? URLRequest(url: url!, method: .post)
            
            urlRequest?.setValue("Basic QVBJX0V4cGxvcmVyOjEyMzQ1NmlzQUxhbWVQYXNz", forHTTPHeaderField: "Authorization")
            urlRequest?.setValue("application/json", forHTTPHeaderField: "Content-Type")
            
            let encoding: ParameterEncoding = JSONEncoding.default
            
            let request = try encoding.encode(urlRequest!, with: parameters)
            
            AF.request(request, interceptor: BaseRequestInterceptor()).response { response in
                print("Response Data \(response.debugDescription)")
                if let data = response.data {
                    guard let jsonObject = try? JSONDecoder().decode(Result.self, from: data) else {
                        return
                    }
                    
                    token = jsonObject.oauth.access_token
                    completion()
                }
            }
        }
        catch {
            print(error.localizedDescription)
        }
    }
}
