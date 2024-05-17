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
    let auth = Auth.auth()
    
    
    func getUserID()-> String? {
        return auth.currentUser?.uid
    }

    func createAccount(name: String, password: String, completion: @escaping (String?)-> Void) {
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
    
    func signIn(email: String, password: String) {
        auth.signIn(withEmail: email, password: password) {result, error in
            if let error = error {
                print("Error signing in: \(error)")
            } else {
                guard let userID = result?.user.uid else {return}
                self.loadUserInfo(userID: userID) {user in
                    print("\(user)")
                
                }
            }
        }
    }
    
    func signOut() {
        do {
            try auth.signOut()
        } catch {
            print("error signing out")
        }
    }
    
    func loadUserInfo(userID: String, completion: @escaping (User?)-> Void) {
        
        db.collection("users").document(userID).getDocument {document, error in
            if let error = error {
                print("Error loading userinfo: \(error)")
                completion(nil)
            } else if let document = document {
                do {
                    let user = try document.data(as: User.self)
                    
                    completion(user)
                } catch {
                    print("Error loading user")
                    completion(nil)
                }
            }
        }
        
    }
    
    func savePersonalInfoToDB( firstName: String, surName: String) {
        
        guard let userID = auth.currentUser?.uid else {return}
        let userInfo = User(firstName: firstName, surName: surName)
        
        do {
            try db.collection("users").document(userID).setData(from: userInfo) {error in
            }
            } catch {
                print("Error")
        }
        
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

