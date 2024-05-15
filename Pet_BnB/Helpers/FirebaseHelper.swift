//
//  FirebaseHelper.swift
//  Pet_BnB
//
//  Created by Jonas Bondesson on 2024-05-15.
//

import Foundation
import Firebase
import FirebaseAuth
import FirebaseFirestore
import FirebaseStorage
import FirebaseFirestoreSwift

class FirebaseHelper: ObservableObject {
    @Published var houses = [House]()
        private var db = Firestore.firestore()
        
        func fetchHouses() {
            db.collection("houses").addSnapshotListener { (querySnapshot, error) in
                guard let documents = querySnapshot?.documents else {
                    print("No documents")
                    return
                }
                
                self.houses = documents.compactMap { queryDocumentSnapshot -> House? in
                    return try? queryDocumentSnapshot.data(as: House.self)
                }
            }
        }
}

