//
//  Spots.swift
//  Snacktacular
//
//  Created by Joseph on 3/29/19.
//  Copyright © 2019 John Gallaugher. All rights reserved.
//

import Foundation
import Firebase

class Spots {
    var spotArray = [Spot]()
    var db: Firestore!
    
    init() {
        db = Firestore.firestore()
    }
    
    func loadData(completed: @escaping () -> ()) {
        db.collection("spots").addSnapshotListener { (QuerySnapshot, error) in
            guard error == nil else {
                return completed()
            }
            self.spotArray = []
            for document in QuerySnapshot!.documents {
                let spot = Spot(dictionary: document.data())
                spot.documentID = eodument.documentID
                self.spotArray.appent(spot)
            }
            completed()
        }
    }
}
