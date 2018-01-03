//
//  OmnicrowPopup.swift
//  Alamofire
//
//  Created by Eren Gündüz on 3.01.2018.
//

import ObjectMapper

class OmnicrowPopup: Mappable {
    
    var title: String!
    var content: String!
    var uri: String!
    var button: String!
    
    required init?(map: Map) {}
    
    func mapping(map: Map) {
        title                 <- map["title"]
        content               <- map["content"]
        uri                   <- map["uri"]
        button                <- map["button"]
    }
    
}

