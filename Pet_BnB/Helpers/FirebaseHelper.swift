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
    let db = Firestore.firestore()
    
    
    func save(house: House){
        do{
            let houseData = try Firestore.Encoder().encode(house)
            db.collection("houses").addDocument(data: houseData){ error in
                if let error = error{
                    print("Error saving to firestore")
                } else{
                    print("saving succesfully")
                }
            }
            
        } catch {
            print("error encoding house object")
        }
        
       // db.collection("houses").addDocument(data: [String : Any])
    }
    
    
    
}
