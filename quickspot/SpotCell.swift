//
//  SpotCell.swift
//  quickspot
//
//  Created by Mateusz on 03/12/2022.
//

import Foundation
import UIKit
import Firebase
import FirebaseCore
import FirebaseFirestore
import FirebaseFirestoreSwift

class SpotCell: UITableViewCell {
    @IBOutlet weak var spotTitleLabel: UILabel!
    

    var db: Firestore!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        db = Firestore.firestore()
        addSubview(spotTitleLabel)
    }


    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
