//
//  ContentView.swift
//  FindMySpot
//
//  Created by Randy Julian on 23/05/23.
//

import SwiftUI
import MapKit
import Combine
import Foundation
import CoreLocation

struct ContentView: View {
    
    @ObservedObject private var locationManager = LocationManager()
    @State private var region = MKCoordinateRegion.defaultRegion
    @State private var cancellable: AnyCancellable?
    @State private var longitude: Double = 0.0
    @State private var latitude: Double = 0.0
    @State private var annotations: [MKPointAnnotation] = []
//    @State private var distance: CLLocationDistance = 0
//    @State private var travelTime: TimeInterval = 0
//    @State private var instructions: [String] = []

    private func setCurrentLocation(){
        cancellable = locationManager.$location.sink{
            location in
            region = MKCoordinateRegion(center: location?.coordinate ?? CLLocationCoordinate2D(), latitudinalMeters: 200, longitudinalMeters: 200)
        }
    }
    
    var body: some View {
        
        @State var coordinate = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
        
//        VStack{
//            if locationManager.location != nil {
//                Map(coordinateRegion: $region, interactionModes: .all, showsUserLocation: true, userTrackingMode: nil)
//                    .accentColor(Color(.systemPink))
//            } else{
//                Text("Locating user location..")
//            }
//        }
//            .onAppear{
//                setCurrentLocation()
//            }
        
        VStack{
            if locationManager.location == nil {
//                MapView(location: locationManager.currentLocation)
                MapView(coordinate: CLLocationCoordinate2D(latitude: latitude, longitude: longitude), annotationTitle: "Parking Location")
                    .frame(height: 300)
                    .padding()
            } else {
                Text("Locating user location...")
            }

            if let location = locationManager.currentLocation{
                Text("Latitude: \(location.coordinate.latitude)")
                Text("Longitude: \(location.coordinate.longitude)")
            }
            
            Button("Save Coordinates"){
                saveCoordinates()
            }
            
            Button("Remove Coordinates"){
                removeSavedCoordinate()
            }
            
            Text("Saved Latitude: \(latitude)")
            Text("Saved Longitude: \(longitude)")
            
        }
        .onAppear{
            loadCoordinates()
//            print(longitude)
//            print(latitude)
        }
    }
        
    private func saveCoordinates(){
        let location = locationManager.currentLocation
        UserDefaults.standard.set(location?.coordinate.latitude, forKey: "Latitude")
        UserDefaults.standard.set(location?.coordinate.longitude, forKey: "Longitude")
        loadCoordinates()
    }
    
    private func loadCoordinates(){
        
        if let savedLongitude = UserDefaults.standard.value(forKey: "Longitude") as? Double{
            longitude = savedLongitude
            print("Saved longitude: \(longitude)")
        }
        if let savedLatitude = UserDefaults.standard.value(forKey: "Latitude") as? Double{
            latitude = savedLatitude
            print("Saved latitude: \(latitude)")
        }

//        calculateDirection(savedLatitude: latitude, savedLongitude: longitude)
    }
    
    private func removeSavedCoordinate(){
//        annotations.removeAll()
        
        if UserDefaults.standard.value(forKey: "Longitude") is Double{
            UserDefaults.standard.removeObject(forKey: "Longitude")
            longitude = 0.0
            print("Saved longitude: \(longitude)")
        }
        if UserDefaults.standard.value(forKey: "Latitude") is Double{
            UserDefaults.standard.removeObject(forKey: "Latitude")
            latitude = 0.0
            print("Saved latitude: \(latitude)")
        }
//
//        loadCoordinates()
    }
    
//    private func calculateDirection(savedLatitude: Double, savedLongitude: Double){
//        // ajg
//        let savedLocation = CLLocation(latitude: savedLatitude, longitude: savedLongitude)
//        let currentLocation = locationManager.currentLocation ?? CLLocation()
//
//        let geocoder = CLGeocoder()
//
//        geocoder.reverseGeocodeLocation(savedLocation) {
//            (placemarks, error) in
//            guard let placemark = placemarks?.first else { return }
//
//            let sourcePlacemark = MKPlacemark(placemark: placemark)
//            let destinationPlacemark = MKPlacemark(coordinate: currentLocation.coordinate)
//
//            let sourceMapItem = MKMapItem(placemark: sourcePlacemark)
//            let destinationMapItem = MKMapItem(placemark: destinationPlacemark)
//
//            let directionRequest = MKDirections.Request()
//            directionRequest.source = sourceMapItem
//            directionRequest.destination = destinationMapItem
//            directionRequest.transportType = .walking
//
//            let directions = MKDirections(request: directionRequest)
//            directions.calculate { (response, error) in
//                guard let route = response?.routes.first else { return }
//
//                let distance = route.distance
//                let travelTime = route.expectedTravelTime
////                let instructions = route.steps.map { $0.instructions }
//
//                print("Distance: \(distance) meters")
//                print("Travel Time: \(travelTime/60) minutes")
////                print("Instructions: \(instructions)")
//            }
//        }
//
//    }
    
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
