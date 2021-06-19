//
//  WebsiteDescription.swift
//  GetPostRequests
//
//  Created by Егор Шкарин on 17.06.2021.
//

import Foundation

struct WebsiteDescription: Decodable {
    let websiteDescription: String
    let websiteName: String
    let courses: [Course]
}
