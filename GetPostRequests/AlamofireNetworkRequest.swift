//
//  AlamofireNetworkRequest.swift
//  GetPostRequests
//
//  Created by Егор Шкарин on 19.06.2021.
//

import Foundation
import Alamofire

class AlamofireNetworkRequest {
    
    static var onProgress: ((Double)->())?
    static var completed:((String)->())?
    
    
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
    
    static func downloadImage(url: String, completion: @escaping (_ image: UIImage)->()) {
        AF.request(url).responseData { (responseData) in
            switch responseData.result {
            case .success(let data):
                guard let image = UIImage(data: data) else { return }
                completion(image)
            case .failure(let error):
                print(error)
            }
        }
    }
    static func downloadLargeImage(url: String, completion: @escaping (_ image: UIImage)-> ()) {
        guard let url = URL(string: url) else { return }
        
        AF.request(url).validate().downloadProgress{  progress in
            print("totalUnitCount: \n", progress.totalUnitCount)
            print("completed unit count \n", progress.completedUnitCount)
            print("fractionCOmpleted", progress.fractionCompleted)
            print("localizedDescripyion", progress.localizedDescription ?? "")
            self.onProgress?(progress.fractionCompleted)
            self.completed?(progress.localizedDescription)
        }.response { response in
            guard let data = response.data, let image = UIImage(data: data) else {return}
            DispatchQueue.main.async {
                completion(image)
            }
        }
    }
    
    static func postRequest(url: String, completion: @escaping ([Course])->()) {
        guard let url = URL(string: url) else {
            return
        }
        let userData: [String: Any] = ["name":"Our first iOS apps",
                                         "link":"https://swiftbook.ru/contents/our-first-applications/",
                                         "imageUrl":"https://swiftbook.ru/wp-content/uploads/2018/03/2-courselogo.jpg",
                                         "number_of_lessons":20,
                                         "number_of_tests":10 ]
        AF.request(url, method: .post, parameters: userData).responseJSON { responseJSON in
            guard let statusCode = responseJSON.response?.statusCode else { return }
            print(statusCode)
            
            switch responseJSON.result {
            case .success(let value):
                print(value)
                guard let jsonObject = value as? [String: Any],
                      let course = Course(json: jsonObject) else
                {return}
                var courses = [Course]()
                courses.append(course)
                completion(courses)
                
            case .failure(let error):
                print(error)
            }
        }
    }
    static func putRequest(url: String, completion: @escaping ([Course])->()) {
        guard let url = URL(string: url) else {
            return
        }
        let userData: [String: Any] = ["name":"Our second iOS apps",
                                         "link":"https://swiftbook.ru/contents/our-first-applications/",
                                         "imageUrl":"https://swiftbook.ru/wp-content/uploads/2018/03/2-courselogo.jpg",
                                         "number_of_lessons":20,
                                         "number_of_tests":10 ]
        AF.request(url, method: .put, parameters: userData).responseJSON { responseJSON in
            guard let statusCode = responseJSON.response?.statusCode else { return }
            print(statusCode)
            
            switch responseJSON.result {
            case .success(let value):
                print(value)
                guard let jsonObject = value as? [String: Any],
                      let course = Course(json: jsonObject) else
                {return}
                var courses = [Course]()
                courses.append(course)
                completion(courses)
                
            case .failure(let error):
                print(error)
            }
        }
    }
}
