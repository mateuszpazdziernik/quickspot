//
//  SpotList.swift
//  quickspot
//
//  Created by Mateusz on 03/12/2022.
//

import UIKit
import Foundation
import Firebase
import FirebaseCore
import FirebaseFirestore
import FirebaseFirestoreSwift


class SpotTableViewController: UITableViewController {

    @IBOutlet var spotTableView: UITableView!

    var spotArray: [String] = []
    var documents: [DocumentSnapshot] = []

    var db: Firestore!

    override func viewDidLoad() {
        super.viewDidLoad()
        db = Firestore.firestore()
        configureTableView()
        loadData()
        
        func configureTableView() {
            tableView.delegate = self
            tableView.dataSource = self
            tableView.register(SpotCell.self, forCellReuseIdentifier: "SpotCell")
            
            // remove separators for empty cells
            tableView.tableFooterView = UIView()
            // remove separators from cells
            tableView.separatorStyle = .none
        }
        
        /*
        func loadData() {
            db.collection("spots").getDocuments() { (QuerySnapshot, err) in
                if let err = err {
                    print("Error getting documents : \(err)")
                }
                else {
                    //let docCount = QuerySnapshot?.documents.count
                    for document in QuerySnapshot!.documents {
                        let documentID = document.documentID
                        print("\(document.documentID) => \(document.data())")
                        let spotTitleLabel = documentID
                    }
                    self.tableView.reloadData()
                }
            }
        }*/
        
        func loadData() {
            db.collection("spots").getDocuments() { (QuerySnapshot, err) in
                if let err = err {
                    print("Error getting documents : \(err)")
                }
                else {
                    for document in QuerySnapshot!.documents {
                        let documentID = document.documentID
                        let spotTitleLabel:String = "title" //document.data()["price"] as! String
                        self.spotArray.append(spotTitleLabel)
                        print("\(document.documentID) => \(document.data())")
                    }
                    self.tableView.reloadData()
                }
            }
        }
        
        
    }


    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print("Tableview setup \(spotArray.count)")
        return spotArray.count
    }

/*
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SpotCell", for: indexPath) as! SpotCell

        let spot = spotArray[indexPath.row]

        print("Spot is populated \(spotArray)")

        return cell
    }*/
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SpotCell", for: indexPath) as! SpotCell
        let spot = spotArray[indexPath.row]
        cell.spotTitleLabel.text = spot
        return cell
    }

}
