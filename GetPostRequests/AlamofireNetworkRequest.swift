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
}
