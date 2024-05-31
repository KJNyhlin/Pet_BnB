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
import SwiftUI

class FirebaseHelper: ObservableObject {

    let db = Firestore.firestore()
    let storage = Storage.storage()
    let auth = Auth.auth()
    @Published var houses = [House]()
    private var authManager = AuthManager.sharedAuth

    func getUserID() -> String? {
        return auth.currentUser?.uid
    }

    func createAccount(name: String, password: String, completion: @escaping (String?) -> Void) {
        auth.createUser(withEmail: name, password: password) { result, error in
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
    
    func signIn(email: String, password: String, completion: @escaping (Bool) -> Void)  {
        auth.signIn(withEmail: email, password: password) { result, error in
            if let error = error {
                print("Error signing in: \(error)")
                completion(false)
            } else {
                guard let userID = result?.user.uid else {
                    completion(false)
                    return
                }
                self.loadUserInfo(userID: userID) { user in
                    completion(true)
                    print("\(user)")
                    self.authManager.set(loggedIn: true)
                }
            }
        }
    }
    
    func signOut() {
        do {
            try auth.signOut()
            authManager.set(loggedIn: false)
        } catch {
            print("error signing out")
        }
    }
    
    func loadUserInfo(userID: String, completion: @escaping (User?) -> Void) {
        db.collection("users").document(userID).getDocument { document, error in
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
    
    func savePersonalInfoToDB(firstName: String, surName: String, aboutMe: String) {
        guard let userID = auth.currentUser?.uid else { return }
        let userInfo = User(firstName: firstName, surName: surName, aboutMe: aboutMe)
        
        do {
            try db.collection("users").document(userID).setData(from: userInfo) { error in }
        } catch {
            print("Error")
        }
    }

    func saveImageURLToDB(userID: String, imageURL: String) {
        db.collection("users").document(userID).updateData(["imageURL": imageURL]) { error in
            if let error = error {
                print("Error updating imageURL: \(error)")
            }
        }
    }

    
    
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
        uploadImage(uiImage: uiImage){ urlString in
            if let urlString = urlString {
                print("Image uploaded successfully.")
                
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
                // No houses found
                completion(nil)
                return
            }
            
            // If we get here we found houses we for now return only the first one
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
    
    func updateHouse(houseID: String, house: House, completion: @escaping (Bool) -> Void){
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
    }
    
    func update(houseId: String, with values: [String: Any], completion: @escaping (Bool) -> Void){
        db.collection("houses").document(houseId).updateData(values){ error in
            if let error = error{
                print("Error saving values to house \(error)")
                completion(false)
            } else {
                print("Values updated!")
                completion(true)
            }
        }
    }
    func save(pets: [Pet], toHouseId houseID: String, completion: @escaping (Bool) -> Void){
        do {
            let petsData = try pets.map { try JSONEncoder().encode($0) }
            let petsDict = try petsData.map { try JSONSerialization.jsonObject(with: $0) }
            update(houseId: houseID, with: ["pets": petsDict]){ success in
                completion(success)
            }
        } catch {
            print("Error encoding pets: \(error)")
            completion(false)
        }
        
    }
    
    
    
    
    
    func deleteImage(atUrl url: String){
        let storageRef = Storage.storage().reference(forURL: url)
        storageRef.delete(){ error in
            
        }
    }
    
    func delete(house: House){
        if let url = house.imageURL{
            deleteImage(atUrl: url)
        }
        if let id = house.id{
            db.collection("houses").document(id).delete { error in
                if let error = error {
                    print("Error deleting document: \(error.localizedDescription)")
                } else {
                    print("Document successfully deleted")
                }
            }
        }
    }
    
    
    func uploadImage(uiImage: UIImage, completion: @escaping (String?) -> Void) {
        guard let imageData = uiImage.jpegData(compressionQuality: 0.5) else {
            print("Failed to convert image")
            completion(nil)
            return
        }
        
        let uuid = UUID()
        let storageRef = storage.reference()
        let imageRef = storageRef.child("profile_images/\(uuid.uuidString).jpg")
        
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
    
    
    func save(TimePeriod: Booking, for house: House) {
            if let houseID = house.id {
                do {
//                    try db.collection("houses").document(houseID).collection("bookings").addDocument(from: booking)
                    try db.collection("bookings").addDocument(from: TimePeriod)
                } catch {
                    print("Error writing to bookings for house")
                }
            }
        }
    
    func getTimePeriodsFor(houseID: String, completion: @escaping ([Booking]?) -> Void) {
        var bookings = [Booking]()
//        db.collection("houses").document(houseID).collection("bookings").addSnapshotListener {snapshot, error in
            db.collection("bookings").whereField("houseID", isEqualTo: houseID).addSnapshotListener {snapshot, error in
            if let error = error {
                print("Error loading bookings: \(error)")
                completion(nil)
            } else {
                guard let documents = snapshot?.documents else {
                    completion(nil)
                    return
                }
                bookings.removeAll()
                for document in documents {
                    do {
                        let booking = try document.data(as: Booking.self)
                        bookings.append(booking)
                    } catch {
                        print("Error decode booking")
                        completion(nil)
                    }
                }
                completion(bookings)
                
            }
        }
//        db.collection("houses").document(houseID).collection("bookings").getDocuments() {snapshot, error in
//            if let error = error {
//                print("Error loading bookings: \(error)")
//                completion(nil)
//            } else {
//                if let documents = snapshot?.documents {
//                    for document in documents {
//                        print("\(document)")
//                        do {
//                            let booking = try document.data(as: Booking.self)
//                            bookings.append(booking)
//                        } catch {
//                            print("Error converting document")
//                            completion(nil)
//                        }
//                    }
//                    completion(bookings)
//                }
//            }
//        }
    }

//    func reservPeriod(houseID: String, docID: String) {
//        if let userID = getUserID() {
//            self.db.collection("bookings").document(docID).updateData( ["reservedID": userID])
//        }
//    }
    
    func bookPeriod(houseID: String, docID: String?) {
        if let userID = getUserID(), let docID = docID {
//            self.db.collection("houses").document(houseID).collection("bookings").document(docID).updateData( ["renterID": userID])
            self.db.collection("bookings").document(docID).updateData( ["renterID": userID, "confirmed": false])
        }
    }
    
    func confirm(Booking: Booking, docID: String?) {
        if let userID = getUserID(), let docID = docID  {
            self.db.collection("bookings").document(docID).updateData(["confirmed": true])
        }
    }
    
    func deny(Booking: Booking, docID: String?) {
        if let userID = getUserID(), let docID = docID  {
            self.db.collection("bookings").document(docID).updateData(["renterID" : nil, "confirmed": nil])
        }
    }
    
    
    func remove(timePeriod: Booking) {
        if timePeriod.renterID == nil {
            if let docID = timePeriod.docID{
//                db.collection("houses").document(houseID).collection("bookings").document(docID).delete()
                db.collection("bookings").document(docID).delete()
            }
        }
    }
    
    func getMyBookings(completion: @escaping ([Booking]?) -> Void) {
        guard let userID = getUserID() else {return}
        var myBookings = [Booking]()
        db.collection("bookings").whereField("renterID", isEqualTo: userID).getDocuments() { snapshot, error in
            if let error = error {
                print("Error getting my bookings: \(error)")
                completion(nil)
            } else {
                if let snapshot = snapshot {
                    for document in snapshot.documents {
                        do {
                            let booking = try document.data(as: Booking.self)
                            myBookings.append(booking)
                        } catch {
                            print("Error converting booking")
                            completion(nil)
                        }
                    }
                    completion(myBookings)
                } else {
                    completion(nil)
                }
            }
        }
        
    }
    
    

    func unbook(booking: Booking) {
        if let docID = booking.docID {
            db.collection("bookings").document(docID).updateData(["renterID" : nil, "reservedID": nil])
        }
    }
    
    func getRenterInfo(renterID: String, completion : @escaping (User?) -> Void) {
        db.collection("users").document(renterID).getDocument() { document, error in
            if let error = error {
                print("Error getting renterInfo: \(error)")
                completion(nil)
            } else {
                do {
                    let renter = try document?.data(as: User.self)
                    completion(renter)
                } catch {
                    print("Error setting document")
                    completion(nil)
                }
            }
        }
    }
              

    func fetchUser(byId userId: String, completion: @escaping (User?) -> Void) {
            db.collection("users").document(userId).getDocument { snapshot, error in
                guard let snapshot = snapshot, snapshot.exists else {
                    print("Error fetching user: \(error?.localizedDescription ?? "Unknown error")")
                    completion(nil)
                    return
                }
                
                do {
                    let user = try snapshot.data(as: User.self)
                    completion(user)
                } catch {
                    print("Error decoding user: \(error.localizedDescription)")
                    completion(nil)
                }
            }
        }
    

    
    func fetchPet(byId id: String, completion: @escaping (Result<Pet, Error>) -> Void) {
          let db = Firestore.firestore()
          db.collection("pets").document(id).getDocument { (document, error) in
              if let document = document, document.exists {
                  do {
                      let pet = try document.data(as: Pet.self)
                      completion(.success(pet))
                  } catch {
                      completion(.failure(error))
                  }
              } else if let error = error {
                  completion(.failure(error))
              } else {
                  completion(.failure(NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "Pet not found"])))
              }
          }
      }
}

