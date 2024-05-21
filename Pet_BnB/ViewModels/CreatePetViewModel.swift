//
//  CreatePetViewModel.swift
//  Pet_BnB
//
//  Created by Kristian Thun on 2024-05-20.
//

import Foundation
import SwiftUI

class CreatePetViewModel: ObservableObject{
    var house: House
    @Published var pet: Pet?
    @Published var selectedSpices = "Dog"
    @Published var informationArray: [String] = []
    let speciesOptions = ["Dog", "Cat", "Rabbit"]
    let firebaseHelper = FirebaseHelper()
    
    @Published var name: String = ""
    @Published var species: String = ""
    
    init(pet: Pet?, house: House) {
        if let pet = pet{
            self.pet = pet
            self.name = pet.name
            self.selectedSpices = pet.species
            self.informationArray = pet.information
        }
        self.house = house

    }
    func savePet(completion: @escaping (Bool) -> Void){
        if !isValuesSet(){
            return
        }
        
        if let pet = pet{
            print("This is the edit pet save and replace")
            if let index = house.pets?.firstIndex(where: { $0.id == pet.id }){
                house.pets?[index].name = name
                house.pets?[index].species = selectedSpices
                house.pets?[index].information = informationArray
                
            }
            
        } else {
            
            house.pets?.append(Pet(name: name, species: selectedSpices, information: informationArray))
            
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
        savePetsToFirebase() { success in
            completion(success)
        }

        
    }
    
    func savePetsToFirebase(completion: @escaping (Bool) -> Void){
        do {
            let petsData = try house.pets?.map { try JSONEncoder().encode($0) } ?? []
            let petsDict = try petsData.map { try JSONSerialization.jsonObject(with: $0) }
            if let houseID = house.id{
                print(house)
                firebaseHelper.update(houseId: houseID, with: ["pets": petsDict]){ success in
                    completion(success)
                    
                    //                    if success{
                    //                        completion(success)
                    //                    } else{
                    //                        print("Could not save!!!")
                    //                        completion(success)
                    //                    }
                    
                }
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
    
    func addInformation(information: String){
//        let lastEmpty = informationArray.last?.isEmpty
//        if let lastEmpty = lastEmpty{
//            if !lastEmpty{
//                informationArray.append("")
//            }
//        }
        informationArray.append(information)
    }
    
    func deleteInformation(at offsets: IndexSet) {
        informationArray.remove(atOffsets: offsets)
    }
}
