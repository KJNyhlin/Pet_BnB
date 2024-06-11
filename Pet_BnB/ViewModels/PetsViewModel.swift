//
//  CreatePetViewModel.swift
//  Pet_BnB
//
//  Created by Kristian Thun on 2024-05-20.
//

import Foundation
import SwiftUI
import PhotosUI
import FirebaseStorage

class PetsViewModel: ObservableObject {
    @Published var house: House
    @Published var pet: Pet? {
        didSet {
            if let pet = pet {
                self.name = pet.name
                self.selectedSpices = pet.species
                self.description = pet.description ?? ""
                self.informationArray = pet.information
                if let imageURL = pet.imageURL {
                    loadImageFromURL(imageURL)
                }
            } else {
                self.name = ""
                self.selectedSpices = "Dog"
                self.description = ""
                self.informationArray = []
                self.image = nil
            }
        }
    }
    @Published var selectedSpices = "Dog"
    @Published var informationArray: [String] = []
    let speciesOptions = ["Dog", "Cat", "Rabbit", "Fish", "Bird", "Reptile", "Other"]
    let firebaseHelper = FirebaseHelper()
    @Published var image: UIImage?
    @Published var showImagePicker: Bool = false
    @Published var imageSelection: PhotosPickerItem? = nil {
        didSet {
            loadImageData()
        }
    }

    @Published var name: String = ""
    @Published var species: String = ""
    @Published var description: String = ""
    @Published var imageURL: String?

    init(pet: Pet?, house: House) {
        self.pet = pet
        self.house = house
        if let pet = pet {
            self.name = pet.name
            self.selectedSpices = pet.species
            self.description = pet.description ?? ""
            self.informationArray = pet.information
            if let imageURL = pet.imageURL {
                loadImageFromURL(imageURL)
            }
        }
    }

    func savePet(completion: @escaping (Bool) -> Void) {
        if !isValuesSet() {
            return
        }
        if house.pets == nil {
            house.pets = []
        }
        if let pet = pet {
            if let index = house.pets?.firstIndex(where: { $0.id == pet.id }) {
                house.pets?[index].name = name
                house.pets?[index].species = selectedSpices
                house.pets?[index].information = informationArray
                house.pets?[index].description = description
                house.pets?[index].imageURL = imageURL
            }
        } else {
            let newPet = Pet(name: name, species: selectedSpices, imageURL: imageURL, information: informationArray, description: description)
            house.pets?.append(newPet)
            self.pet = newPet // Uppdatera pet till den nyss skapade
        }
        
        if let houseID = house.id, let pets = house.pets {
            firebaseHelper.save(pets: pets, toHouseId: houseID) { success in
                completion(success)
            }
        } else {
            completion(false)
        }
    }

    func isValuesSet() -> Bool {
        return !name.isEmpty
    }

    func deletePet(at offsets: IndexSet) {
        house.pets?.remove(atOffsets: offsets)
        if let houseID = house.id, let pets = house.pets {
            firebaseHelper.save(pets: pets, toHouseId: houseID) { success in
                
            }
        }
    }

    func loadImageData() {
        Task {
            do {
                guard let selectedPhoto = imageSelection else {
                    print("No photo selected")
                    return
                }
                let imageData = try await selectedPhoto.loadTransferable(type: Data.self)
                DispatchQueue.main.async {
                    if let imageData = imageData {
                        self.image = UIImage(data: imageData)
                    }
                }
            } catch {
                print("Error loading image data: \(error)")
            }
        }
    }

    func loadImageFromURL(_ imageURL: String) {
        firebaseHelper.downloadImage(from: imageURL) { [weak self] image in
            DispatchQueue.main.async {
                self?.image = image
            }
        }
    }

    func uploadPetImage(_ image: UIImage, completion: @escaping (String?) -> Void) {
        guard let imageData = image.jpegData(compressionQuality: 0.8) else {
            completion(nil)
            return
        }

        let storageRef = Storage.storage().reference().child("pet_images/\(UUID().uuidString).jpg")
        storageRef.putData(imageData, metadata: nil) { metadata, error in
            if let error = error {
                print("Error uploading image: \(error)")
                completion(nil)
                return
            }
            storageRef.downloadURL { url, error in
                if let error = error {
                    print("Error getting download URL: \(error)")
                    completion(nil)
                } else {
                    completion(url?.absoluteString)
                }
            }
        }
    }
    func clearFields(){
        selectedSpices = "Dog"
        informationArray = []
        pet = nil

        image = nil
        showImagePicker = false
        imageSelection = nil


        name = ""
        species = ""
        description = ""
        imageURL =  nil
    }
}



