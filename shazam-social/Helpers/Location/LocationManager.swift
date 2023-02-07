//
//  LocationManager.swift
//  shazam-social
//
//  Created by Brandon Wong on 2/3/23.
//

import Foundation
import CoreLocation

/**
 Requests the user's location.
 */
class LocationManager: NSObject, ObservableObject, CLLocationManagerDelegate {
    let manager = CLLocationManager()

    @Published var location: CLLocationCoordinate2D?

    override init() {
        super.init()
        manager.delegate = self
    }

    func requestLocation() {
        manager.requestLocation()
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
         print("error: \(error.localizedDescription)")
    }

    // Runs if authorization status changes.
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if status == .authorizedWhenInUse || status == .authorizedAlways {
            self.manager.startUpdatingLocation()
        } else {
            self.manager.requestWhenInUseAuthorization()
        }
    }

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        location = locations.first?.coordinate
    }
}
