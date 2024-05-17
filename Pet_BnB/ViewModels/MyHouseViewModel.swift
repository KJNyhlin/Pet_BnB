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
  //  @Published var houseImage: UIImage? = nil
    
    
    init(house: House? = nil) {
        //downloadHouse()
//        let loggedInUserID = firebaseHelper.getLoggedInUserID()
//        if let loggedInUserID = loggedInUserID {
//            firebaseHelper.fetchHouse(withOwner: loggedInUserID){ myHouse in
//                self.house = myHouse
////                if let imageString = house?.imageURL {
////                    self.firebaseHelper.downloadImage(from: imageString){ image in
////                        self.houseImage = image
////
////                    }
////                }
//            }
//        }
    }
    
    func downloadHouse(){
        let loggedInUserID = firebaseHelper.getLoggedInUserID()
        if let loggedInUserID = loggedInUserID {
            firebaseHelper.fetchHouse(withOwner: loggedInUserID){ myHouse in
                self.house = myHouse
                print("This is the image URL \(self.house?.imageURL)")
            }
        }
    }
    
}
