//
//  Cart.swift
//  Pods
//
//  Created by Mehmet Salih Aslan on 12/09/2017.
//
//

import ObjectMapper

class Cart: Mappable {
    
    var items: [Product]!
    
    init(items: [Product]) {
        self.items = items
    }
    
    required init?(map: Map) {}
    
    func mapping(map: Map) {
        items               <- map["items"]
    }
    
}
