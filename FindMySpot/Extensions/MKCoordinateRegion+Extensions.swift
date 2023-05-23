//
//  MKCoordinateRegion+Extensions.swift
//  FindMySpot
//
//  Created by Randy Julian on 23/05/23.
//

import Foundation
import MapKit

extension MKCoordinateRegion{
    
    static var defaultRegion: MKCoordinateRegion{
        MKCoordinateRegion(center: CLLocationCoordinate2D.init(latitude: 106.65263729686647, longitude: -6.302040697670588), latitudinalMeters: 100, longitudinalMeters: 100)
    }
}
