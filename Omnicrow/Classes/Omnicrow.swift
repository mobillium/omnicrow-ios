//
//  Omnicrow.swift
//  Pods
//
//  Created by Mehmet Salih Aslan on 12/09/2017.
//
//

import Foundation
import CoreLocation
import CoreBluetooth

public class Omnicrow: NSObject {
    
    public static let shared = Omnicrow()
    
    var beaconRegion: CLBeaconRegion!
    var locationManager: CLLocationManager!
    var lastBeacon: CLBeacon?
    var lastRegion: CLBeaconRegion?
    let beaconUUID = "8aa10000-0a46-115f-d94e-5a966a3ddbb7"
    let beaconId = "POI"
    
    var appId: String!
    var isSandbox = false
    var userDefaults = UserDefaults(suiteName: "com.mobillium.omnicrow")
    
    var uuid: String? {
        let defaults = Omnicrow.shared.userDefaults
        if let uuid = defaults?.string(forKey: "OmnicrowAnalyticsUuid") {
            return uuid
        } else {
            let uuid = UUID().uuidString
            defaults?.set(uuid, forKey: "OmnicrowAnalyticsUuid")
            defaults?.synchronize()
            return uuid
        }
    }
    
    var version: String? {
        return Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString") as? String
    }

    public static func logEvent(_ eventName: OmnicrowEventName) {
        WebService.logEvent(eventName)
    }
    
    public static func registerPush(_ deviceToken: String) {
        WebService.request(WebService.Path.registerPush, parameters: ["token": deviceToken])
    }
    
    public func setUserId(_ id: String?) {
        let defaults = Omnicrow.shared.userDefaults
        defaults?.set(id, forKey: "OmnicrowAnalyticsUserId")
        defaults?.synchronize()
    }
    
    public func logOut() {
        let defaults = Omnicrow.shared.userDefaults
        defaults?.removeObject(forKey: "OmnicrowAnalyticsUserId")
        defaults?.synchronize()
    }
    
    public func active() {
        if let appId = Bundle.main.object(forInfoDictionaryKey: "OmnicrowAppID") as? String {
            Omnicrow.shared.appId = appId
        } else {
            fatalError("PaparaAppId should be set.")
        }
        
        if let isSandbox = Bundle.main.object(forInfoDictionaryKey: "OmnicrowSandbox") as? Bool, isSandbox {
            Omnicrow.shared.isSandbox = isSandbox
        } else {
            // Nothing sandbox optional
        }
        
        if Omnicrow.shared.isSandbox {
            beaconRegion = CLBeaconRegion(proximityUUID: UUID(uuidString: beaconUUID)!, identifier: beaconId)
            
            locationManager = CLLocationManager()
            locationManager.delegate = self
            locationManager.requestAlwaysAuthorization()
            locationManager.startRangingBeacons(in: beaconRegion)
        }
    }
    
}

extension Omnicrow: CLLocationManagerDelegate {
    
    public func locationManager(_ manager: CLLocationManager, didEnterRegion region: CLRegion) {
        if let enteredRegion = region as? CLBeaconRegion {
            if lastRegion?.major != enteredRegion.major || lastRegion?.minor != enteredRegion.minor {
                self.lastRegion = enteredRegion
                Omnicrow.logEvent(OmnicrowEventName.beacon(major: String(describing: enteredRegion.major), minor: String(describing: enteredRegion.minor)))
            }
        }
    }

    public func locationManager(_ manager: CLLocationManager, didRangeBeacons beacons: [CLBeacon], in region: CLBeaconRegion) {
        if let beacon = beacons.first {
            if lastBeacon?.major != beacon.major || lastBeacon?.minor != beacon.minor {
                self.lastBeacon = beacon
                Omnicrow.logEvent(OmnicrowEventName.beacon(major: String(describing: beacon.major), minor: String(describing: beacon.minor)))
            }
        }
    }
    
}
