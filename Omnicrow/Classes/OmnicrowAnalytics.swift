//
//  OmnicrowAnalytics.swift
//  Pods
//
//  Created by Mehmet Salih Aslan on 12/09/2017.
//
//

import Foundation
import CoreLocation
import CoreBluetooth

public class OmnicrowAnalytics: NSObject {
    
    public static let shared = OmnicrowAnalytics()
    
    var beaconRegion: CLBeaconRegion!
    var locationManager: CLLocationManager!
    var lastBeacon: CLBeacon?
    var lastRegion: CLBeaconRegion?
    let beaconUUID = "8aa10000-0a46-115f-d94e-5a966a3ddbb7"
    let beaconId = "POI"
    
    var appId: String!
    var isSandbox = false
    
    var uuid: String {
        let defaults = UserDefaults.standard
        if let uuid = defaults.string(forKey: "OmnicrowAnalyticsUuid") {
            return uuid
        } else {
            let uuid = UUID().uuidString
            defaults.set(uuid, forKey: "OmnicrowAnalyticsUuid")
            defaults.synchronize()
            return uuid
        }
    }
    
    public static func logEvent(_ eventName: OmnicrowEventName) {
        WebService.logEvent(eventName)
    }
    
    public static func registerPush(_ deviceToken: String) {
        WebService.request(WebService.Path.registerPush, parameters: ["token": deviceToken])
    }
    
    public func setUserId(_ id: String?) {
        let defaults = UserDefaults.standard
        defaults.set(id, forKey: "OmnicrowAnalyticsUserId")
        defaults.synchronize()
    }
    
    public func setVersion(_ version: String?) {
        let defaults = UserDefaults.standard
        defaults.set(version, forKey: "OmnicrowAnalyticsAppVersion")
        defaults.synchronize()
    }
    
    public func logOut() {
        let defaults = UserDefaults.standard
        defaults.removeObject(forKey: "OmnicrowAnalyticsUserId")
        defaults.synchronize()
    }
    
    public func active() {
        if let appId = Bundle.main.object(forInfoDictionaryKey: "OmnicrowAppID") as? String {
            OmnicrowAnalytics.shared.appId = appId
        } else {
            fatalError("PaparaAppId should be set.")
        }
        
        if let isSandbox = Bundle.main.object(forInfoDictionaryKey: "OmnicrowSandbox") as? Bool, isSandbox {
            OmnicrowAnalytics.shared.isSandbox = isSandbox
        } else {
            // Nothing sandbox optional
        }
        
        if OmnicrowAnalytics.shared.isSandbox {
            beaconRegion = CLBeaconRegion(proximityUUID: UUID(uuidString: beaconUUID)!, identifier: beaconId)
            
            locationManager = CLLocationManager()
            locationManager.delegate = self
            locationManager.requestAlwaysAuthorization()
            locationManager.startRangingBeacons(in: beaconRegion)
        }
    }
    
}

extension OmnicrowAnalytics: CLLocationManagerDelegate {
    
    public func locationManager(_ manager: CLLocationManager, didEnterRegion region: CLRegion) {
        if let enteredRegion = region as? CLBeaconRegion {
            if lastRegion?.major != enteredRegion.major || lastRegion?.minor != enteredRegion.minor {
                self.lastRegion = enteredRegion
                OmnicrowAnalytics.logEvent(OmnicrowEventName.beacon(major: String(describing: enteredRegion.major), minor: String(describing: enteredRegion.minor)))
            }
        }
    }

    public func locationManager(_ manager: CLLocationManager, didRangeBeacons beacons: [CLBeacon], in region: CLBeaconRegion) {
        if let beacon = beacons.first {
            if lastBeacon?.major != beacon.major || lastBeacon?.minor != beacon.minor {
                self.lastBeacon = beacon
                OmnicrowAnalytics.logEvent(OmnicrowEventName.beacon(major: String(describing: beacon.major), minor: String(describing: beacon.minor)))
            }
        }
    }
    
}
