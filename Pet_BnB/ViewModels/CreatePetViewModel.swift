//
//  CreatePetViewModel.swift
//  Pet_BnB
//
//  Created by Kristian Thun on 2024-05-20.
//

import Foundation

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
        } else {
            
            house.pets?.append(Pet(name: name, species: selectedSpices))
            
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
