//
//  AlamofireNetworkRequest.swift
//  GetPostRequests
//
//  Created by Егор Шкарин on 19.06.2021.
//

import Foundation
import Alamofire

class AlamofireNetworkRequest {
    
    static func sendRequest(url: String, completion: @escaping ([Course])->()) {
        guard let url = URL(string: url) else { return }
        // Зарпрос с алмофаер
        AF.request(url).validate().responseJSON { response in
            switch response.result {
            case .success(let value):
                let courses = getArray(from: value)!
                DispatchQueue.main.async {
                    completion(courses)
                }
                
            case .failure(let error):
                print(error)
            }
        }
    }
    static func getArray(from jsonArray: Any) -> [Course]? {
        guard let jsonArray = jsonArray as? Array<[String: Any]> else { return nil }
        
        return jsonArray.compactMap{Course(json: $0)}
    }
    
    static func responseData(url: String) {
        AF.request(url).responseData { responseData in
            switch responseData.result {
            case .success(let data):
                guard let string = String(data: data, encoding: .utf8) else {
                    return
                }
                print(string)
            case .failure(let error):
                print(error)
            }
        }
    }
    
    static func responseString(url: String) {
        AF.request(url).responseString { responseString in
            switch responseString.result {
            case .success(let string):
                print(string)
            case .failure(let error):
                print(error)
            }
        }
    }
    
    static func response(url: String) {
        AF.request(url).response { response in
            guard
                let data = response.data,
                let string = String(data: data, encoding: .utf8)
            else { return }
            
            print(string)
        }
    }
}
