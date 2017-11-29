//
//  OmnicrowEventName.swift
//  Pods
//
//  Created by Mehmet Salih Aslan on 12/09/2017.
//
//

import Foundation

public enum OmnicrowEventName {
    case item(id: String)
    case category(path: String)
    case cart(items: [OmnicrowProduct])
    case purchase(id: String, totalPrice: Double, items: [OmnicrowProduct])
    case beacon(major: String, minor: String)
}
