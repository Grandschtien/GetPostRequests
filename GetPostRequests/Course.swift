//
//  Course.swift
//  GetPostRequests
//
//  Created by Егор Шкарин on 17.06.2021.
//

import Foundation

struct Course: Decodable {
    
    let id: Int?
    let name: String?
    let link: String?
    let imageUrl: String?
    let numberOfLessons: Int?
    let numberOfTests: Int?
}
