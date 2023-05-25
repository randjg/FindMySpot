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
    
    @Binding var isShowing: Bool
    
    @ObservedObject private var locationManager = LocationManager()
    @State private var region = MKCoordinateRegion.defaultRegion
    @State private var cancellable: AnyCancellable?
    @State private var longitude: Double = 0.0
    @State private var latitude: Double = 0.0
    @State private var annotations: [MKPointAnnotation] = []
    @State private var isPark = true
    @State private var buttonTitle = "PARK HERE"
    @State private var showAlert = false
    @State private var inputText = ""
    @State private var savedText = ""
    
    private let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "EEEE, MMM d"
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
                .padding(.leading, 16)
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
                            .foregroundColor(Color(hex: "004197"))
                            .frame(width: 393, height: 120)
                            .shadow(radius: 15)
                            
                            VStack {
                                Text("\(dateFormatter.string(from: Date()))\(daySuffix(from: Date()))")
                                    .font(.title2)
                                .padding(.top, -50)
                                .foregroundColor(.white)
                            }
                        }
                        
                        ZStack {
                            RoundedRectangle(cornerRadius: 10)
                            .foregroundColor(.white)
                            .frame(width: 393, height: 100)
                            .padding(.top, 70)
                            .shadow(radius: 15)
                            
                            HStack {
                                TextField("Floor", text: $inputText)
                                    .padding(.all)
                                    .frame(width: 100, height: 50)
                                    .background(Color(hex: "EFEFF0"))
                                    .cornerRadius(10)
                                    .foregroundColor(.black)
                                    .padding(.top, 60)
                                
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
                                        .font(.title2)
                                        .fontWeight(.bold)
                                        .frame(width: 200, height: 16)
                                        .padding()
                                        .background(Color(hex: "00214E"))
                                        .foregroundColor(.white)
                                        .cornerRadius(10)
                                }
                                .alert(isPresented: $showAlert){
                                    Alert(title: Text("FINISHED"),
                                          message: Text("Click follow coordinate button on the top left to Park again"),
                                          dismissButton: .default(Text("OK")))
                                }
                            .padding(.top, 60)
                            }
                        }
                    }

                }
                .ignoresSafeArea()
            }
        }
        .navigationBarBackButtonHidden(true)
        .onAppear{
            loadCoordinates()
                
        }
    }
        
    func daySuffix(from date: Date) -> String {
        let calendar = Calendar.current
        let dayOfMonth = calendar.component(.day, from: date)
        
        switch dayOfMonth {
        case 1, 21, 31:
            return "st"
        case 2, 22:
            return "nd"
        case 3, 23:
            return "rd"
        default:
            return "th"
        }
    }
    
    private func saveCoordinates(){
        let location = locationManager.currentLocation
        UserDefaults.standard.set(location?.coordinate.latitude, forKey: "Latitude")
        UserDefaults.standard.set(location?.coordinate.longitude, forKey: "Longitude")
        loadCoordinates()
        
        UserDefaults.standard.set(inputText, forKey: "SavedString")
        retrieveSavedString()
    }
    
    private func retrieveSavedString(){
        if let savedString = UserDefaults.standard.string(forKey: "SavedString"){
            savedText = savedString
            print(savedText)
        } else {
            savedText = ""
        }
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
        
        if UserDefaults.standard.value(forKey: "SavedString") is String{
            UserDefaults.standard.removeObject(forKey: "SavedString")
            savedText = ""
            inputText = ""
            print(savedText)
        }
        showAlert = true
    }
        
}

extension Color {
    init(hex: String) {
        let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&int)
        let a, r, g, b: UInt64
        switch hex.count {
        case 3: // RGB (12-bit)
            (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6: // RGB (24-bit)
            (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8: // ARGB (32-bit)
            (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default:
            (a, r, g, b) = (1, 1, 1, 0)
        }

        self.init(
            .sRGB,
            red: Double(r) / 255,
            green: Double(g) / 255,
            blue:  Double(b) / 255,
            opacity: Double(a) / 255
        )
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView(isShowing: .constant(true))
    }
}
