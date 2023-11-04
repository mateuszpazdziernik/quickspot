import UIKit

import MapKit
import CoreLocation

import FirebaseCore
import FirebaseFirestore
import FirebaseFirestoreSwift

class ViewController: UIViewController, CLLocationManagerDelegate {
    
    var db: Firestore!
    
    let spot: Spot = Spot()
    
    @IBOutlet var mapView: MKMapView!
    let manager = CLLocationManager()
    
    @IBAction func didChangeSegment(_ sender: UISegmentedControl) {
        if sender.selectedSegmentIndex == 0 {self.overrideUserInterfaceStyle = .light}
        else if sender.selectedSegmentIndex == 1 {self.overrideUserInterfaceStyle = .dark}
    }
    
    override func viewDidLoad() {
        self.overrideUserInterfaceStyle = .light
        let settings = FirestoreSettings()
        Firestore.firestore().settings = settings
        db = Firestore.firestore()
        //databaseSync()
        showMarksFromDatabase()
        
        mapView.delegate = self
        mapView.showsCompass = false
        
        super.viewDidLoad()
    }
    
    /*func databaseSync() {
        db.collection("spots").getDocuments() { (querySnapshot, err) in
            if let err = err {
                print("Błąd połączenia z bazą danych: \(err)")
            } else {
                for document in querySnapshot!.documents {
                    print("\(document.documentID) => \(document.data())")
                }
            }
        }
    }*/
    
    func showMarksFromDatabase() {
        db.collection("spots").getDocuments() { [self] (querySnapshot, err) in
            if let err = err {
                print("Error getting locations: \(err)")
            } else {
                for document in querySnapshot!.documents {
                    let annotations = MKPointAnnotation()
                    
                    let latitude = (document.data()["location"] as! GeoPoint).latitude
                    let longitude = (document.data()["location"] as! GeoPoint).longitude
                    
                    let hours = document.data()["hours"] as! String
                    let price = document.data()["price"] as! String
                    let priceArray:Array = price.components(separatedBy: ";")
                    
                    //annotations.title = "\(document.documentID)"
                    annotations.title = "\(priceArray[0]) - \(priceArray[2])"
                    annotations.subtitle = "\(hours)"
                    annotations.coordinate = CLLocationCoordinate2D(latitude: latitude,
                                                                    longitude: longitude)
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
        let defaultLocation = spot.location
        let defaultCoordinate = CLLocationCoordinate2D(
            latitude: defaultLocation.coordinate.latitude,
            longitude: defaultLocation.coordinate.longitude)
        let span = MKCoordinateSpan(latitudeDelta: 0.013, longitudeDelta: 0.013)
        var region: MKCoordinateRegion
        let region1 = MKCoordinateRegion(center: defaultCoordinate, span: span)
        let region2 = MKCoordinateRegion(center: coordinate, span: span)
        
        if spot.isItTooFar(a: defaultLocation, b: location) {
            region = region1
            print("Focus on Default Location")
        } else {
            region = region2
            print("Focus on User location")
        }
        mapView.setRegion(region, animated: true)
    }
}

extension ViewController: MKMapViewDelegate {
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        if annotation is MKUserLocation {
            //let userPin = mapView.view(for: annotation) as? MKPinAnnotationView ?? MKPinAnnotationView(annotation: annotation, reuseIdentifier: nil)
            //userPin.image = UIImage(systemName: "circle.fill")
            //userPin.pinTintColor = UIColor(named: "pinGreen")
            return nil
        }
        var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: "custom")
        if annotationView == nil {
            annotationView = MKAnnotationView(annotation: annotation, reuseIdentifier: "custom")
            annotationView?.canShowCallout = true
            annotationView?.rightCalloutAccessoryView
        } else {
            annotationView?.annotation = annotation
        }
        switch annotation.title {
        case "userlocation":
            annotationView?.image = UIImage(named:"spotPin")
        default:
            annotationView?.image = UIImage(named:"spotPin")
        }
        return annotationView
    }
}
