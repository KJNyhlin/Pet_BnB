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
    @Published var pets: [Pet]?
    
    init(house: House, pets: [Pet]?) {
        self.house = house
        self.pets = pets
    }
    
}
