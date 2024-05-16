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

class FirebaseHelper: ObservableObject {
    
    func createAccount(name: String, password: String, completion: @escaping (String?)-> Void) {
        let auth = Auth.auth()
        
        auth.createUser(withEmail: name, password: password) {result, error in
            if let error = error {
                print("Error sign up: \(error)")
                completion(nil)
            } else {
                guard let userID = result?.user.uid else {
                    completion(nil)
                    return
                }
                completion(userID)
            }
            
        }
        
    }
    
    func savePersonalInfoToDB( firstName: String, surName: String) {
        let db = Firestore.firestore()
        let auth = Auth.auth()
        guard let userID = auth.currentUser?.uid else {return}
        
        db.collection("users").document(userID).setData(
            ["firstName:": firstName,
             "surName:": surName
            ]
        )
        
    }
    
}
