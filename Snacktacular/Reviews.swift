//
//  Reviews.swift
//  Snacktacular
//
//  Created by Joseph on 4/16/19.
//  Copyright © 2019 John Gallaugher. All rights reserved.
//

import Foundation
import Firebase

class Reviews {
    var reviewArray: [Review] = []
    var db: Firestore!
    
    init() {
        db = Firestore.firestore()
    }
    
    func loadData(spot: Spot, completed: @escaping () -> ()) {
        
        guard spot.documentID != "" else {
            return
        }
    db.collection("spots").document(spot.documentID).collection("reviews").addSnapshotListener { (QuerySnapshot, error) in
        guard error == nil else {
            return completed()
        }
        self.reviewArray = []
        for document in QuerySnapshot!.documents {
            let review = Review(dictionary: document.data())
            review.documentID = document.documentID
            self.reviewArray.append(review)
        }
        completed()
        }
    }
}
