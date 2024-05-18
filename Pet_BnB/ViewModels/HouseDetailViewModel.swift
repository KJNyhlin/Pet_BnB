//
//  HouseDetailViewModel.swift
//  Pet_BnB
//
//  Created by Maida on 2024-05-16.
//

import Foundation
import Combine

class HouseDetailViewModel: ObservableObject {
    @Published var house: House?
    private var firebaseHelper: FirebaseHelper
    private var cancellables = Set<AnyCancellable>()
    
    init(firebaseHelper: FirebaseHelper) {
        self.firebaseHelper = firebaseHelper
    }
    
    func fetchHouse(byId id: String) {
        firebaseHelper.fetchHouse(byId: id) { [weak self] house in
            DispatchQueue.main.async {
                self?.house = house
            }
        }
    }
}
