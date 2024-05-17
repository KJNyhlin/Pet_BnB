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

    let db = Firestore.firestore()
    let storage = Storage.storage()
    @Published var houses = [House]()
    
    

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
        
    func fetchHouses() {
            db.collection("houses").addSnapshotListener { (querySnapshot, error) in
                if let error = error {
                    print("Error getting documents: \(error)")
                    return
                }
                
                guard let documents = querySnapshot?.documents else {
                    print("No documents")
                    return
                }
                
                self.houses = documents.compactMap { queryDocumentSnapshot -> House? in
                    let result = try? queryDocumentSnapshot.data(as: House.self)
                    print("House: \(String(describing: result))")
                    return result
                }
            }
        }
        
        func fetchHouse(byId id: String, completion: @escaping (House?) -> Void) {
            db.collection("houses").document(id).getDocument { document, error in
                if let document = document, document.exists {
                    let house = try? document.data(as: House.self)
                    completion(house)
                } else {
                    print("House doesn't exist")
                    completion(nil)
                }
            }
        }

}

