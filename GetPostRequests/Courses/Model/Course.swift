//
//  Course.swift
//  GetPostRequests
//
//  Created by Егор Шкарин on 17.06.2021.
//

import Foundation

//struct Course: Decodable {
//
//    let id: Int?
//    let name: String?
//    let link: String?
//    let imageUrl: String?
//    let numberOfLessons: Int?
//    let numberOfTests: Int?
//}


struct Course: Decodable {
    
    let id: Int?
    let name: String?
    let link: String?
    let imageUrl: String?
    let numberOfLessons: Int?
    let numberOfTests: Int?
    
    init?(json: [String: Any]) {
        self.id = json["id"] as? Int
        self.name = json["name"] as? String
        self.link = json["link"] as? String
        self.imageUrl = json["imageUrl"] as? String
        self.numberOfLessons = json["number_of_lessons"] as? Int
        self.numberOfTests = json["number_of_tests"] as? Int
    }
}
