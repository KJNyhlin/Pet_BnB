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
    let auth = Auth.auth()
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
    

//    func saveHouse(uiImage: UIImage, title: String, description: String, beds: Int, size: Int, StreetName: String, streetNr: Int, city: String, zipCode: Int){
//
//        guard let imageData = uiImage.jpegData(compressionQuality: 0.5) else {
//            print("Failed convert image")
//            return
//        }
//        
//        guard let ownerID = auth.currentUser?.uid else {
//            print("Not logged in!")
//            return
//        }
//        
//        let uuid = UUID()
//        let storageRef = storage.reference()
//        let imageRef = storageRef.child("houses/\(uuid.uuidString).jpg")
//        //let ownerID = self.auth.currentUser?.uid
//        
//        imageRef.putData(imageData, metadata: nil){ metadata, error in
//            if let error = error{
//                print("Error uploading image: \(error)")
//                return
//            } else {
//                print("Image uploaded successfully.")
//                imageRef.downloadURL { url, error in
//                    let ownerID = self.auth.currentUser?.uid
//                    //Create house
//                    let house = House(title: title, description: description, imageURL: url?.absoluteString,
//                                      beds: beds, size: size, streetName: StreetName, streetNR: streetNr, city: city, zipCode: zipCode, ownerID: ownerID)
//                    
//                    do{
//                        let houseData = try Firestore.Encoder().encode(house)
//                        self.db.collection("houses").addDocument(data: houseData){ error in
//                            if let error = error{
//                                print("Error saving to firestore")
//                            } else{
//                                print("saving succesfully")
//                            }
//                        }
//                        
//                    } catch {
//                        print("error encoding house object")
//                    }
//                }
//            }
//        }
//    }
    
    func saveHouse(uiImage: UIImage, title: String, description: String, beds: Int, size: Int, StreetName: String, streetNr: Int, city: String, zipCode: Int,  completion: @escaping (Bool) -> Void){
        
        guard let imageData = uiImage.jpegData(compressionQuality: 0.5) else {
            print("Failed convert image")
            completion(false)
            return
        }
        
        guard let ownerID = auth.currentUser?.uid else {
            print("Not logged in!")
            completion(false)
            return
        }
        
        //        let uuid = UUID()
        //        let storageRef = storage.reference()
        //        let imageRef = storageRef.child("houses/\(uuid.uuidString).jpg")
        //        //let ownerID = self.auth.currentUser?.uid
        //
        //        imageRef.putData(imageData, metadata: nil){ metadata, error in
        //            if let error = error{
        //                print("Error uploading image: \(error)")
        //                return
        //            } else {
        uploadImage(uiImage: uiImage){ urlString in
            if let urlString = urlString{
                print("Image uploaded successfully.")
                let ownerID = self.auth.currentUser?.uid
                let house = House(title: title, description: description, imageURL: urlString,
                                  beds: beds, size: size, streetName: StreetName, streetNR: streetNr, city: city, zipCode: zipCode, ownerID: ownerID)
                do{
                    let houseData = try Firestore.Encoder().encode(house)
                    self.db.collection("houses").addDocument(data: houseData){ error in
                        if let error = error{
                            print("Error saving to firestore")
                            completion(false)
                        } else{
                            print("saving succesfully")
                            completion(true)
                        }
                    }
                    
                } catch {
                    completion(false)
                    print("error encoding house object")
                }
            } else{
                completion(false)
            }
        }
    }
                
//                imageRef.downloadURL { url, error in
//                    let ownerID = self.auth.currentUser?.uid
//                    //Create house
//                    let house = House(title: title, description: description, imageURL: url?.absoluteString,
//                                      beds: beds, size: size, streetName: StreetName, streetNR: streetNr, city: city, zipCode: zipCode, ownerID: ownerID)
//                    
//                    do{
//                        let houseData = try Firestore.Encoder().encode(house)
//                        self.db.collection("houses").addDocument(data: houseData){ error in
//                            if let error = error{
//                                print("Error saving to firestore")
//                            } else{
//                                print("saving succesfully")
//                            }
//                        }
//                        
//                    } catch {
//                        print("error encoding house object")
//                    }
//                }
//            }
            //       }
    //}
    
//    func saveHouse(uiImage: UIImage, title: String, description: String, beds: Int, size: Int, StreetName: String, streetNr: Int, city: String, zipCode: Int, completion: @escaping (Bool) -> Void) {
//        // Implementera din kod för att spara ett hus asynkront
//        // Anropa completion(true) om lyckad, annars completion(false)
//    }

//    func uploadImage(uiImage: UIImage, completion: @escaping (String?) -> Void) {
//        // Implementera din kod för att ladda upp en bild och returnera URL-strängen
//        // Anropa completion(urlString) om lyckad, annars completion(nil)
//    }

    func updateHouse(houseID: String, house: House, with valuesChanged: [String], completion: @escaping (Bool) -> Void) {
        // Implementera din kod för att uppdatera ett hus asynkront
        // Anropa completion(true) om lyckad, annars completion(false)
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
    
    func fetchHouse(withOwner ownerID: String, completion: @escaping (House?) -> Void) {
        db.collection("houses").whereField("ownerID", isEqualTo: ownerID).getDocuments { snapshot, error in
            if let error = error {
                print("Error getting documents: \(error)")
                completion(nil)
                return
            }
            
            guard let documents = snapshot?.documents, !documents.isEmpty else {
                // Inga hus hittades med det angivna ägare-ID:et
                completion(nil)
                return
            }
            
            // Om vi når hit betyder det att det finns minst ett hus med rätt ägare-ID
            // Vi tar bara det första huset som matchar kriterierna
            do {
                let document = documents[0]
                let house = try document.data(as: House.self)
                completion(house)
            } catch {
                print("Error decoding house data: \(error)")
                completion(nil)
            }
        }
    }
    
    func getLoggedInUserID() -> String?{
        return auth.currentUser?.uid
    }
    
    func downloadImage(from url: String, completion: @escaping (UIImage?) -> Void) {
        guard let storageUrl = URL(string: url) else {
            print("Error creating URL from string")
            completion(nil)
            return
        }
        let storageRef = Storage.storage().reference(forURL: url)
        
        storageRef.getData(maxSize: 1 * 2024 * 2024) { data, error in
            if let error = error {
                print("Error downloading image: \(error)")
                completion(nil)
                return
            }
            
            guard let imageData = data, let image = UIImage(data: imageData) else {
                print("Error converting data to UIImage")
                completion(nil)
                return
            }
            print("Image is fine returned from DownloadImage")
            completion(image)
        }
    }
    
    func updateHouse(houseID: String, house: House, with values: [String: Any], completion: @escaping (Bool) -> Void){
        do{
            let houseData = try Firestore.Encoder().encode(house)
            print(houseData)
            db.collection("houses").document(houseID).updateData(houseData){ error in
                if let error = error{
                    print("Error updating document \(error)")
                    completion(false)
                } else{
                    print("Document updated!")
                    completion(true)
                }
            }
            
        } catch {
            print("error encoding house object")
            completion(false)
        }
//        
//        
//        db.collection("houses").document(houseID).updateData(values){ error in
//            if let error = error {
//                print("Error updating document \(error)")
//            } else {
//                print("Document updated!")
//            }
//        }
    }
    
    func deleteImage(atUrl url: String){
        
    }
    
    func uploadImage(uiImage: UIImage, completion: @escaping (String?) -> Void) {
        guard let imageData = uiImage.jpegData(compressionQuality: 0.5) else {
            print("Failed to convert image")
            completion(nil)
            return
        }
        
        let uuid = UUID()
        let storageRef = storage.reference()
        let imageRef = storageRef.child("houses/\(uuid.uuidString).jpg")
        
        imageRef.putData(imageData, metadata: nil) { metadata, error in
            if let error = error {
                print("Error uploading image: \(error)")
                completion(nil)
                return
            } else {
                print("Image uploaded successfully.")
                imageRef.downloadURL { url, error in
                    if let error = error {
                        print("Error getting image download URL: \(error)")
                        completion(nil)
                    } else {
                        completion(url?.absoluteString)
                    }
                }
            }
        }
    }

}

