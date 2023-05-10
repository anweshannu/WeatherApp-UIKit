//
//  LocationManager.swift
//  WeatherApp-UIKit
//
//  Created by Anwesh on 3/30/23.
//

import Foundation
import CoreLocation

class LocationManager: NSObject{
    
    var manager = CLLocationManager()
    private var currentLocation: CLLocation!
    
    func authorizationStatus() -> CLAuthorizationStatus {
        print("Called:- \(#function)\n")
        manager.requestWhenInUseAuthorization()
        var authorizationStatus: CLAuthorizationStatus
        
        if #available(iOS 14, *) {
            authorizationStatus = manager.authorizationStatus
        } else {
            authorizationStatus = CLLocationManager.authorizationStatus()
        }
        
        return authorizationStatus
    }
    
    func isLocationPermissionEnabled() -> Bool{
        var authorizationStatus: CLAuthorizationStatus
        
        if #available(iOS 14, *) {
            authorizationStatus = manager.authorizationStatus
        } else {
            authorizationStatus = CLLocationManager.authorizationStatus()
        }
        
        switch authorizationStatus{
        case .authorizedWhenInUse, .authorizedAlways:
            return true
        default:
            print("Default")
            break
        }
        return false
    }
    
    func isLocationTurnedOn() -> Bool{
        CLLocationManager.locationServicesEnabled()
    }
    
    func getCurrentLocation() -> (String, String)?{
        let lm = CLLocationManager()
        guard let l = lm.location?.coordinate else{return nil}
        return (l.latitude.description, l.longitude.description)
    }
    
}


extension CLAuthorizationStatus{
    
    var description: String {
        switch self {
        case .notDetermined:
         return "notDetermined"
        case .restricted:
            return "restricted"
        case .denied:
            return "denied"
        case .authorizedAlways:
            return "authorizedAlways"
        case .authorizedWhenInUse:
            return "authorizedWhenInUse"
        case .authorized:
            return "authorized"
        @unknown default:
            return "Unknown"
        }
        
    }
}
