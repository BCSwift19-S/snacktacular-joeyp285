//
//  Photo.swift
//  Snacktacular
//
//  Created by Joseph on 4/16/19.
//  Copyright © 2019 John Gallaugher. All rights reserved.
//

import Foundation
import Firebase

class Photo {
    var image: UIImage
    var description: String
    var postedBy: String
    var date: Date
    var documentUUID: String // universal unique identifier
    
    var dictionary: [String: Any] {
        return ["description":description, "postedBy":postedBy,"date":date]
    }
    
    init(image: UIImage, description: String, postedBy: String, date: Date, documentUUID: String) {
        self.image = image
        self.description = description
        self.postedBy = postedBy
        self.date = date
        self.documentUUID = documentUUID
    }
    
    convenience init() {
        let postedBy = Auth.auth().currentUser?.email ?? "unknow user"
        self.init(image: UIImage(), description: "", postedBy: postedBy, date: Date(), documentUUID: "")
    }
    
    convenience init(dictionary: [String: Any]) {
        let description = dictionary["description"] as! String? ?? ""
        let postedBy = dictionary["postedBy"] as! String? ?? ""
        let date = dictionary["date"] as! Date? ?? Date()
        self.init(image: UIImage(), description: description, postedBy: postedBy, date: date, documentUUID: "")
    }
    
    func saveData(spot: Spot, completed: @escaping (Bool) -> ()) {
        let db = Firestore.firestore()
        let storage = Storage.storage()
        
        guard let photoData = self.image.jpegData(compressionQuality: 0.5) else {
            print("ERROR")
            return completed(false)
        }
        let uploadMetadata = StorageMetadata()
        uploadMetadata.contentType = "image/jpeg"
        documentUUID = UUID().uuidString
        let storageRef = storage.reference().child(spot.documentID).child(self.documentUUID)
        let uploadTask = storageRef.putData(photoData, metadata: uploadMetadata) {
            metaData, error in
            guard error == nil else {
                print("error during .putdata storage upload")
                return
            }
            print("Upload worked!")
        }
        uploadTask.observe(.success) { (snapshot) in
            let dataToSave = self.dictionary
            let ref = db.collection("spots").document(spot.documentID).collection("photos").document(self.documentUUID)
            ref.setData(dataToSave) { (error) in
                if let error = error {
                    print("ERROR")
                    completed(false)
                } else {
                    print("Document updated with ref ID")
                    completed(true)
                }
            }
        }
        
        uploadTask.observe(.failure) { (snapshot) in
            if let error = snapshot.error {
                print("ERROR")
            }
            return completed(false)
        }
        
        
    }
}
    



