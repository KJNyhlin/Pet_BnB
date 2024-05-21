//
//  PetsViewModel.swift
//  Pet_BnB
//
//  Created by Kristian Thun on 2024-05-20.
//

import Foundation

class PetsViewModel: ObservableObject {
    //var houseID: String
    @Published var house: House
  //  @Published var pets: [Pet] = []
    var firebaseHelper = FirebaseHelper()
    
    init(house: House, pets: [Pet]?) {
        self.house = house
//        if let pets = pets {
//            self.pets = pets
//        }
        
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
}
