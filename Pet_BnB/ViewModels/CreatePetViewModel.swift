//
//  CreatePetViewModel.swift
//  Pet_BnB
//
//  Created by Kristian Thun on 2024-05-20.
//

import Foundation
import SwiftUI

class CreatePetViewModel: ObservableObject{
    @Published var house: House
    @Published var pet: Pet? {
        didSet {
            if let pet = pet {
                self.name = pet.name
                self.selectedSpices = pet.species
                self.description = pet.description ?? ""
                self.informationArray = pet.information
            } else {
                self.name = ""
                self.selectedSpices = "Dog"
                self.description = ""
                self.informationArray = []
            }
        }
    }
    @Published var selectedSpices = "Dog"
    @Published var informationArray: [String] = []
    let speciesOptions = ["Dog", "Cat", "Rabbit"]
    let firebaseHelper = FirebaseHelper()
    
    @Published var name: String = ""
    @Published var species: String = ""
    @Published var description: String = ""
    
    init(pet: Pet?, house: House) {
        self.pet = pet
//        if let pet = pet{
//            self.pet = pet
//            self.name = pet.name
//            self.selectedSpices = pet.species
//            self.informationArray = pet.information
//            if let description = pet.description{
//                self.description = description
//            }
//
//        }
        self.house = house

    }
    func savePet(completion: @escaping (Bool) -> Void){
        if !isValuesSet(){
            return
        }
        if house.pets == nil{
            house.pets = []
        }
        if let pet = pet{
            print("This is the edit pet save and replace")
            if let index = house.pets?.firstIndex(where: { $0.id == pet.id }){
                house.pets?[index].name = name
                house.pets?[index].species = selectedSpices
                house.pets?[index].information = informationArray
                house.pets?[index].description = description
                
            }
            
        } else {
            
            house.pets?.append(Pet(name: name, species: selectedSpices, information: informationArray, description: description))
            
            }
            
//            do {
//                let petsData = try house.pets?.map { try JSONEncoder().encode($0) } ?? []
//                let petsDict = try petsData.map { try JSONSerialization.jsonObject(with: $0) }
//                if let houseID = house.id{
//                    print(house)
//                    firebaseHelper.update(houseId: houseID, with: ["pets": petsDict]){ success in
//                        completion(success)
//                        
//                        //                    if success{
//                        //                        completion(success)
//                        //                    } else{
//                        //                        print("Could not save!!!")
//                        //                        completion(success)
//                        //                    }
//                        
//                    }
//                }
//            } catch {
//                print("Error encoding pets: \(error)")
//                completion(false)
//            }
//        savePetsToFirebase() { success in
//            completion(success)
//        }
        if let houseID = house.id,
           let pets = house.pets {
            firebaseHelper.save(pets: pets, toHouseId: houseID){ success in
                completion(success)
            }

        }
        else{
            completion(false)
        }
        

        
    }
    
    func savePetsToFirebase( completion: @escaping (Bool) -> Void){
        do {
            let petsData = try house.pets?.map { try JSONEncoder().encode($0) } ?? []
            let petsDict = try petsData.map { try JSONSerialization.jsonObject(with: $0) }
            if let houseID = house.id{
                print(house)
                firebaseHelper.update(houseId: houseID, with: ["pets": petsDict]){ success in
                    completion(success)
                }
            }
        } catch {
            print("Error encoding pets: \(error)")
            completion(false)
        }
        
    }
    
    func save(pets: [Pet], toHouseId houseID: String, completion: @escaping (Bool) -> Void){
        do {
            let petsData = try pets.map { try JSONEncoder().encode($0) }
            let petsDict = try petsData.map { try JSONSerialization.jsonObject(with: $0) }
            firebaseHelper.update(houseId: houseID, with: ["pets": petsDict]){ success in
                completion(success)
            }
        } catch {
            print("Error encoding pets: \(error)")
            completion(false)
        }
        
    }
    

    
    func isValuesSet() -> Bool{
        if !name.isEmpty{
            return true
        }
        return false
    }
    
    func deletePet(at offsets: IndexSet) {
        house.pets?.remove(atOffsets: offsets)
        if let houseID = house.id,
           let pets = house.pets{
            
            firebaseHelper.save(pets: pets, toHouseId: houseID){ success in
                
            }
        }
        
       
      //  pets.remove(atOffsets: offsets)
    }
    
    
//    func addInformation(information: String){
////        let lastEmpty = informationArray.last?.isEmpty
////        if let lastEmpty = lastEmpty{
////            if !lastEmpty{
////                informationArray.append("")
////            }
////        }
//        informationArray.append(information)
//    }
//    
//    func deleteInformation(at offsets: IndexSet) {
//        informationArray.remove(atOffsets: offsets)
//    }
}
