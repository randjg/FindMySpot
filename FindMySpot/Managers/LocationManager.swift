//
//  LocationManager.swift
//  FindMySpot
//
//  Created by Randy Julian on 23/05/23.
//

import Foundation
import CoreLocation

class LocationManager: NSObject, ObservableObject {
    
    let locationManager = CLLocationManager()
    @Published var location: CLLocation?
    @Published var currentLocation: CLLocation?
    @Published var userHeading: CLHeading?
    
    override init() {
        super.init()
        
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.distanceFilter = kCLDistanceFilterNone
        locationManager.requestAlwaysAuthorization()
        locationManager.startUpdatingLocation()
        locationManager.startUpdatingHeading()
        locationManager.delegate = self
    }
    
}

extension LocationManager: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else { return }
        
        
//        DispatchQueue.main.async {
//            self.location = location
//        }
//        DispatchQueue.main.async {
//            self.currentLocation = location
////            self.locationManager.stopUpdatingLocation()
//        }
        self.currentLocation = location
        
        
//        locationManager.stopUpdatingLocation()
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error, didUpdateHeading newHeading: CLHeading) {
        userHeading = newHeading
        
        print("LocationManager error: \(error.localizedDescription)")
    }
    
}

