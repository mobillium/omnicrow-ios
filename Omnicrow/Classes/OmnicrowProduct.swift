//
//  OmnicrowProduct.swift
//  Pods
//
//  Created by Mehmet Salih Aslan on 12/09/2017.
//
//

import ObjectMapper

public class OmnicrowProduct: Mappable {
    
    var id: String!
    var quantity: Int!
    var price: Double!
    
    public init(id: String, quantity: Int, price: Double) {
        self.id = id
        self.quantity = quantity
        self.price = price
    }
    
    required public init?(map: Map) {}
    
    public func mapping(map: Map) {
        id                  <- map["id"]
        quantity            <- map["quantity"]
        price               <- map["price"]
    }
    
}
