//
//  WebService.swift
//  Pods
//
//  Created by Mehmet Salih Aslan on 12/09/2017.
//
//

import Alamofire
import ObjectMapper

class WebService {
    
    static var baseUrl: String {
        return OmnicrowAnalytics.shared.isSandbox ? "https://dev.tubitak.mobillium.com" : "https://tubitak.mobillium.com"
    }
    
    enum Path: String {
        case item       = "/api/event/item"
        case category   = "/api/event/category"
        case cart       = "/api/event/cart"
        case purchase   = "/api/event/purchase"
        case beacon     = "/api/event/beacon"
    }
    
    class func request(_ eventName: OmnicrowEventName) {
        
        var url = baseUrl
        
        var parameters = [String: Any]()
        switch eventName {
        case .item(let id):
            url += Path.item.rawValue
            parameters["id"] = id
        case .category(let path):
            url += Path.category.rawValue
            parameters["path"] = path
        case .cart(let items):
            url += Path.cart.rawValue
            for (index, item) in items.enumerated() {
                parameters["items[\(index)][id]"] = item.id
                parameters["items[\(index)][quantity]"] = item.quantity
                parameters["items[\(index)][price]"] = item.price
            }
        case .purchase(let id, let totalPrice, let items):
            url += Path.purchase.rawValue
            parameters["id"] = id
            parameters["total"] = totalPrice
            for (index, item) in items.enumerated() {
                parameters["items[\(index)][id]"] = item.id
                parameters["items[\(index)][quantity]"] = item.quantity
                parameters["items[\(index)][price]"] = item.price
            }
        case .beacon(let major, let minor):
            url += Path.beacon.rawValue
            parameters["major"] = major
            parameters["minor"] = minor
        }
        
//        var header = [String: String]()
//        header["appId"] = TubitakAnalytics.shared.appId
        
        let defaults = UserDefaults.standard

        if let userId: String = defaults.string(forKey: "OmnicrowAnalyticsUserId") {
            parameters["user-id"] = userId
        }
        
        if let version: String = defaults.string(forKey: "OmnicrowAnalyticsAppVersion") {
            parameters["version"] = version
        }

        parameters["uuid"] = OmnicrowAnalytics.shared.uuid
        parameters["platform"] = "ios"
        
        print("Path: \(url)")
        print("Parameters:")
        print(parameters)
        
        Alamofire.request(url, method: .post, parameters: parameters, encoding: URLEncoding.default, headers: nil)
            .validate()
            .responseData(completionHandler: { (response) in
                if let value = response.result.value {
                    if let json = String(data: value, encoding: .utf8) {
                        print("\nResponse Tubitak JSON: \(json)")
                    }
                }
            })
            .responseJSON { response in
                
                // Success
                if response.result.isSuccess {
                    

                }
                
                // Failure
                if response.result.isFailure {

                    
                }
        }
    }
    
}
