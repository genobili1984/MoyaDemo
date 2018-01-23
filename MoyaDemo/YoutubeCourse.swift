//
//  YoutubeCourse.swift
//  MoyaDemo
//
//  Created by mao on 1/23/18.
//  Copyright © 2018 sungrow. All rights reserved.
//

import Foundation
import ObjectMapper

class YoutubeCourses: Mappable {
    var courses: [YoutubeCourse]?
    
    required init?(map: Map) {
    }
    
    func mapping(map: Map) {
        courses <- map["courses"]
    }
}

class YoutubeCourse: Mappable {
    var name: String?
    var duration: String?
    var number: Int?
    var url: String?
    var link :String?
    
    required init?(map: Map) {
    }
    
    func mapping(map: Map) {
        name <- map["name"]
        duration <- map["duration"]
        number <- map["number"]
        url <- map["imageUrl"]
        link <- map["link"]
    }
}
