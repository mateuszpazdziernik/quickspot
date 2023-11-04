//
//  Spot.swift
//  quickspot
//
//  Created by Mateusz on 08/01/2023.
//

import CoreLocation
import Foundation

//default location
let latitude:CLLocationDegrees = 51.110369
let longitude:CLLocationDegrees = 17.031031

struct Spot: Identifiable {
    let id = UUID()
    var firestoreID:String = "default_ID"
    var location:CLLocation = CLLocation(latitude: latitude, longitude: longitude)
    var hours:String = "default_hours"
    var price:Array<Any> 
    var street:String = "default_street"
    var distance:Int
    
    func isItTooFar(a:CLLocation, b:CLLocation) -> Bool {
        let distFromCenter:Double = 0.02 // Allowable distance form City Center
        let x1 = a.coordinate.latitude as Double
        let y1 = a.coordinate.longitude as Double
        let x2 = b.coordinate.latitude as Double
        let y2 = b.coordinate.longitude as Double
        
        if (x1-x2>distFromCenter) || (y1-y2>distFromCenter) {return true} else {return false}
    }
    
    init() {
        firestoreID = "default_ID"
        location = CLLocation(latitude: latitude, longitude: longitude)
        price = []
        street = "default_street"
        distance = 0
    }
    
    init(firestoreID: String, location: CLLocation, hours:String, price: Array<Any>, street: String, distance: Int) {
        self.firestoreID = firestoreID
        self.location = location
        self.price = price
        self.street = street
        self.distance = distance
        self.hours = hours
    }
}
