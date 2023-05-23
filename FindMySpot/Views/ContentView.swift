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
    @State private var isPark = true
    @State private var buttonTitle = "PARK HERE"
    
    private let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "EEEE, MMM d YYYY"
        return formatter
    }()

    private func setCurrentLocation(){
        cancellable = locationManager.$location.sink{
            location in
            region = MKCoordinateRegion(center: location?.coordinate ?? CLLocationCoordinate2D(), latitudinalMeters: 400, longitudinalMeters: 400)
        }
    }
    
    var body: some View {
        
        @State var coordinate = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
        
        VStack{
            
            HStack {
                Text("FindMySpot")
                    .font(.largeTitle)
                .bold()
                .padding(.leading, 20)
                Spacer()
            }
            
            ZStack {
            if locationManager.location == nil {
                MapView(coordinate: CLLocationCoordinate2D(latitude: latitude, longitude: longitude), annotationTitle: "Parking Location")
                    .frame(width: 370, height: 570)
                    .padding(.top, -140)
            } else {
                Text("Locating user location...")
            }
            
                VStack {
                    Spacer()
                    ZStack {
                        ZStack {
                            RoundedRectangle(cornerRadius: 10)
                                .foregroundColor(.blue)
                            .frame(width: 393, height: 120)
                            .shadow(radius: 15)
                            
                            VStack {
                                Text("\(dateFormatter.string(from: Date()))")
                                    .font(.title2)
                                .padding(.top, -50)
                            }
                        }
                        
                        ZStack {
                            RoundedRectangle(cornerRadius: 10)
                                .foregroundColor(.white)
                            .frame(width: 393, height: 100)
                            .padding(.top, 70)
                        .shadow(radius: 10)
                            
                            Button(action: {
                                if isPark && buttonTitle == "PARK HERE"{
                                    buttonTitle = "FINISHED"
                                    saveCoordinates()
                                } else{
                                    buttonTitle = "PARK HERE"
                                    removeSavedCoordinate()
                                }
                            }) {
                                Text(buttonTitle)
                                    .font(.title)
                                    .fontWeight(.bold)
                                    .frame(width: 340, height: 16)
                                    .padding()
                                    .background(Color.blue)
                                    .foregroundColor(.white)
                                    .cornerRadius(10)
                            }
                            .padding(.top, 45)
                        }
                    }

                }
                .ignoresSafeArea()
            }    
        }
        .onAppear{
            loadCoordinates()
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
    }
    
    private func removeSavedCoordinate(){
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
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
