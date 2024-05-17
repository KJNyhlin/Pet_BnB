//
//  HouseViewModel.swift
//  Pet_BnB
//
//  Created by Jonas Bondesson on 2024-05-15.
//

import Foundation
import SwiftUI

class MyHouseViewModel: ObservableObject{
    @Published var house: House? = nil
    let firebaseHelper = FirebaseHelper()
    init(house: House? = nil) {

    }
    
    func downloadHouse(){
        let loggedInUserID = firebaseHelper.getLoggedInUserID()
        if let loggedInUserID = loggedInUserID {
            firebaseHelper.fetchHouse(withOwner: loggedInUserID){ myHouse in
                self.house = myHouse
                
            }
        }
    }
    
    func deleteHouse(){
        if let houseToDelete = house{
            firebaseHelper.delete(house: houseToDelete)
            house = nil
        }
        
    }
    
    
}
