//
//  NaviSelectionViewController.swift
//  quickspot
//
//  Created by Mateusz on 18/04/2023.
//

import UIKit
import CoreLocation

class NaviSelectionViewController: UIViewController{
    
    var location:CLLocation = CLLocation(latitude: 0, longitude: 0)
    var street:String = ""
    var dist:Double = 0
    var hours:String = ""
    var priceArray:Array<String> = []
    
    @IBOutlet weak var streetLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var spotDesc: UILabel!
    @IBOutlet weak var buttonG: UIButton!
    @IBOutlet weak var buttonA: UIButton!
    
    func appleMapRedirect() {
        let destURL = String("http://maps.apple.com/?ll=\(location.coordinate.latitude),\(location.coordinate.longitude)&q=Parkomat")
        print(destURL)
        if let url = URL(string: destURL) {
        UIApplication.shared.open(url)
        }
    }
    
    func googleMapRedirect(){
        let destURL = String("https://www.google.com/maps/search/?api=1&query=\(location.coordinate.latitude)%2C\(location.coordinate.longitude)")
        print(destURL)
        if let url = URL(string: destURL) {
        UIApplication.shared.open(url)
        }
    }
    
    override func viewDidLoad() {
        let formatter = NumberFormatter()
        formatter.minimumFractionDigits = 2
        formatter.maximumFractionDigits = 2
        super.viewDidLoad()
        
        buttonG.addAction(UIAction(title: "", handler: {(_) in self.googleMapRedirect()}), for: .touchUpInside)
        buttonA.addAction(UIAction(title: "", handler: {(_) in self.appleMapRedirect()}), for: .touchUpInside)
        
        
        streetLabel.text = "ul. \(street)"
        spotDesc.text = """
        
        
        Dystans: \(formatter.string(for: dist/1000)!) km
        
        Godziny otwarcia:
        Pierwsza godzina postoju:
        Druga godzina postoju:
        Trzecia godzina postoju:
        Każda kolejna godzina:
        
        Pokaż trasę w:
        """
        priceLabel.text = """
        
        
        
        
        \(hours)
        \(priceArray[0])
        \(priceArray[1])
        \(priceArray[2])
        \(priceArray[3])
        
        
        """
    }
}
