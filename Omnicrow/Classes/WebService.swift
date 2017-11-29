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
        return Omnicrow.shared.isSandbox ? "https://dev.tubitak.mobillium.com" : "https://tubitak.mobillium.com"
    }
    
    enum Path: String {
        case item           = "/api/event/item"
        case category       = "/api/event/category"
        case cart           = "/api/event/cart"
        case purchase       = "/api/event/purchase"
        case beacon         = "/api/event/beacon"
        case registerPush   = "/api/device"
    }
    
    class func logEvent(_ eventName: OmnicrowEventName) {
        var parameters: [String: Any] = [:]
        var urlPath = WebService.Path.item
        switch eventName {
        case .item(let id):
            urlPath = .item
            parameters["id"] = id
        case .category(let path):
            urlPath = .category
            parameters["path"] = path
        case .cart(let items):
            urlPath = .cart
            for (index, item) in items.enumerated() {
                parameters["items[\(index)][id]"] = item.id
                parameters["items[\(index)][quantity]"] = item.quantity
                parameters["items[\(index)][price]"] = item.price
            }
        case .purchase(let id, let totalPrice, let items):
            urlPath = .purchase
            parameters["id"] = id
            parameters["total"] = totalPrice
            for (index, item) in items.enumerated() {
                parameters["items[\(index)][id]"] = item.id
                parameters["items[\(index)][quantity]"] = item.quantity
                parameters["items[\(index)][price]"] = item.price
            }
        case .beacon(let major, let minor):
            urlPath = .beacon
            parameters["major"] = major
            parameters["minor"] = minor
        }
        WebService.request(urlPath, parameters: parameters)
    }
    
    class func request(_ path: Path, parameters: [String: Any]) {
        let defaults = Omnicrow.shared.userDefaults
        var params = parameters
        if let userId: String = defaults?.string(forKey: "OmnicrowAnalyticsUserId") {
            params["user-id"] = userId
        }
        
        params["version"] = Omnicrow.shared.version
        
        params["uuid"] = Omnicrow.shared.uuid
        params["platform"] = "ios"
        
        print("URL:")
        print(baseUrl+path.rawValue)
        print("params:")
        print(params)
        
        Alamofire.request(baseUrl+path.rawValue, method: .post, parameters: params, encoding: URLEncoding.default, headers: nil)
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
                    print("Response Tubitak: Success")
                }
                
                // Failure
                if response.result.isFailure {
                    print("Response Tubitak: Success")
                }
        }
    }
    
}
