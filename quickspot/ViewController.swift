//
//  ViewController.swift
//  quickspot
//
//  Created by Mateusz on 02/11/2022.
//

import UIKit

import MapKit
import CoreLocation

import FirebaseCore
import FirebaseFirestore
import FirebaseFirestoreSwift

class ViewController: UIViewController, CLLocationManagerDelegate {
    
    var db: Firestore!
    
    @IBOutlet var mapView: MKMapView!
    let manager = CLLocationManager()

    override func viewDidLoad() {
        if #available(iOS 13.0, *) {
            self.overrideUserInterfaceStyle = .dark //dark theme
        }
        
        let settings = FirestoreSettings()
        Firestore.firestore().settings = settings
        db = Firestore.firestore()
        //databaseSync()
        showMarksFromDatabase()
        
        super.viewDidLoad()
    }
    
    func databaseSync() {
        db.collection("spots").getDocuments() { (querySnapshot, err) in
            if let err = err {
                print("Błąd połączenia z bazą danych: \(err)")
            } else {
                for document in querySnapshot!.documents {
                    print("\(document.documentID) => \(document.data())")
                }
            }
        }
    }
    
    func showMarksFromDatabase() {
        //let annotations = MKPointAnnotation()
        db.collection("spots").getDocuments() { [self] (querySnapshot, err) in
            if let err = err {
                print("Error getting locations: \(err)")
            } else {
                for document in querySnapshot!.documents {
                    let annotations = MKPointAnnotation()
                    //print("\(document.documentID) => \(document.data())")
                    //annotations.title = document.data()["price"] as? String
                    
                    let latitude = (document.data()["location"] as! GeoPoint).latitude
                    let longitude = (document.data()["location"] as! GeoPoint).longitude
                    
                    print("latitude: \(latitude), longitude: \(longitude)")
                    //annotations.coordinate = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
                    annotations.coordinate = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
                    mapView.addAnnotation(annotations)
                }
            }
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        manager.desiredAccuracy = kCLLocationAccuracyBest
        manager.delegate = self
        manager.requestWhenInUseAuthorization()
        manager.startUpdatingLocation()
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.first {
            manager.stopUpdatingLocation()
            
            render(location)
        }
    }
    
    func render(_ location: CLLocation) {
        
        let coordinate = CLLocationCoordinate2D(latitude: location.coordinate.latitude,
                                               longitude: location.coordinate.longitude)
        
        let span = MKCoordinateSpan(latitudeDelta: 0.013, longitudeDelta: 0.013)
        
        let region = MKCoordinateRegion(center: coordinate,
                                        span: span)
        
        mapView.setRegion(region, animated: true)
    }


}
