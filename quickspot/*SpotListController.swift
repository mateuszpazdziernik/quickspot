//
//  SpotListController.swift
//  quickspot
//
//  Created by Mateusz on 29/11/2022.
//
/*
import UIKit
import FirebaseCore
import FirebaseFirestore
import FirebaseFirestoreSwift

class SpotListController: UITableViewController {
    
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
            spotTableView.delegate = self
            spotTableView.dataSource = self
            spotTableView.register(SpotCell.self, forCellReuseIdentifier: "SpotCell")
            
            // remove separators for empty cells
            spotTableView.tableFooterView = UIView()
            // remove separators from cells
            spotTableView.separatorStyle = .none
        }
        
        
        func loadData() {
            db.collection("spots").getDocuments() { (QuerySnapshot, err) in
                if let err = err {
                    print("Error getting documents : \(err)")
                }
                else {
                    for document in QuerySnapshot!.documents {
                        let documentID = document.documentID
                        let spotTitleLabel = document.documentID
                        print(spotTitleLabel)
                        self.spotArray.append(spotTitleLabel)
                    }
                    self.spotTableView.reloadData()
                }
            }
        }
        
        
        override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            print("Tableview setup \(spotArray.count)")
            return spotArray.count
        }
        
        override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            let cell = spotTableView.dequeueReusableCell(withIdentifier: "SpotCell", for: indexPath) as! SpotCell
            let spot = spotArray[indexPath.row]
            cell.spotTitleLabel.text = spot
            return cell
        }
    }
}
*/
