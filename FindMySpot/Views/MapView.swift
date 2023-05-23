//
//  MapView.swift
//  FindMySpot
//
//  Created by Randy Julian on 23/05/23.
//

import SwiftUI
import MapKit

struct MapView: UIViewRepresentable{
    
    @EnvironmentObject var locationManager: LocationManager
    var location: CLLocation?
    var coordinate: CLLocationCoordinate2D
    var annotationTitle: String
    
    func makeUIView(context: Context) -> MKMapView {
        let mapView = MKMapView()
        mapView.showsUserLocation = true
        mapView.layer.cornerRadius = 10
        mapView.clipsToBounds = true
        return mapView
    }
    
    func updateUIView(_ uiView: MKMapView, context: Context) {
        
        uiView.showsCompass = true
        uiView.showsUserLocation = true
        
        if let userTrackingButton = uiView.subviews.first(where: { $0 is MKUserTrackingButton }) as? MKUserTrackingButton {
            userTrackingButton.frame = CGRect(origin: CGPoint(x: 16, y: 16), size: CGSize(width: 30, height: 30))
        } else {
            let userTrackingButton = MKUserTrackingButton(mapView: uiView)
            userTrackingButton.frame = CGRect(origin: CGPoint(x: 16, y: 16), size: CGSize(width: 30, height: 30))
            uiView.addSubview(userTrackingButton)
        }
        
        let region = MKCoordinateRegion(center: coordinate, latitudinalMeters: 600, longitudinalMeters: 600)
        uiView.setRegion(region, animated: true)
        
        uiView.removeAnnotations(uiView.annotations)
        
        let annotation = MKPointAnnotation()
        annotation.coordinate = coordinate
        annotation.title = annotationTitle
        uiView.addAnnotation(annotation)
    }
    
}

