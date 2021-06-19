//
//  AlamofireNetworkRequest.swift
//  GetPostRequests
//
//  Created by Егор Шкарин on 19.06.2021.
//

import Foundation
import Alamofire

class AlamofireNetworkRequest {
    
    static func sendRequest(url: String) {
        guard let url = URL(string: url) else { return }
        // Зарпрос с алмофаер
        AF.request(url).validate().responseJSON { response in
            switch response.result {
            case .success(let value):
                print(value)
            case .failure(let error):
                print(error)
            }
        }
    }
}
