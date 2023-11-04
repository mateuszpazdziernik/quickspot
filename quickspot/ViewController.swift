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
                    
                    //print("latitude: \(latitude), longitude: \(longitude)")
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
    
    func isItTooFar(a:CLLocation, b:CLLocation) -> Bool {
        let distFromCenter:Double = 0.02 // Allowable distance form City Center
        let x1 = a.coordinate.latitude as Double
        let y1 = a.coordinate.longitude as Double
        let x2 = b.coordinate.latitude as Double
        let y2 = b.coordinate.longitude as Double
        
        if (x1-x2>distFromCenter) || (y1-y2>distFromCenter) {return true} else {return false}
    }
    
    func render(_ location: CLLocation) {
        
        let coordinate = CLLocationCoordinate2D(latitude: location.coordinate.latitude,
                                                longitude: location.coordinate.longitude)
        
        let W1:CLLocationDegrees = 51.110369
        let W2:CLLocationDegrees = 17.031031
        let WroCenter = CLLocation(latitude: W1, longitude: W2)
        let WroCoordinate = CLLocationCoordinate2D(latitude: WroCenter.coordinate.latitude,
                                                   longitude: WroCenter.coordinate.longitude)
        
        let span = MKCoordinateSpan(latitudeDelta: 0.013, longitudeDelta: 0.013)
        
        var region:MKCoordinateRegion
        let region1 = MKCoordinateRegion(center: WroCoordinate, span: span)
        let region2 = MKCoordinateRegion(center: coordinate, span: span)
        
        if isItTooFar(a: WroCenter, b: location) {
            region = region1
            print("Focus to WroclawCenter")
        } else {
            region = region2
            print("Focus to User location")
        }
        
        mapView.setRegion(region, animated: true)
    }


}
