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
    let storage = Storage.storage()
    
    
    func saveHouse(uiImage: UIImage, house: House){
        guard let imageData = uiImage.jpegData(compressionQuality: 0.5) else {
            print("Failed convert image")
            return
        }
        let uuid = UUID()
        let storageRef = storage.reference()
        let imageRef = storageRef.child("houses/\(uuid.uuidString).jpg")
        imageRef.putData(imageData, metadata: nil){ metadata, error in
            if let error = error{
                print("Error uploading image: \(error)")
                return
            } else {
                print("Image uploaded successfully.")
                imageRef.downloadURL { url, error in
                    let houseWithImage = House(title: house.title, description: house.description, imageURL: url?.absoluteString)
                    do{
                        let houseData = try Firestore.Encoder().encode(houseWithImage)
                        self.db.collection("houses").addDocument(data: houseData){ error in
                            if let error = error{
                                print("Error saving to firestore")
                            } else{
                                print("saving succesfully")
                            }
                        }
                        
                    } catch {
                        print("error encoding house object")
                    }
                    
                    
                }
            }
        }
            
    }

}
