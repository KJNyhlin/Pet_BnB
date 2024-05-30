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
    @Published var selectedTab: Int = 0
//    @Published var startDate = Date.now
//    @Published var endDate = Date.now
//    @Published var myTimePeriods = [Booking]()
    
    init(house: House? = nil) {

    }
    
    func downloadHouse(){
        let loggedInUserID = firebaseHelper.getLoggedInUserID()
        if let loggedInUserID = loggedInUserID {
            firebaseHelper.fetchHouse(withOwner: loggedInUserID){ myHouse in
                self.house = myHouse
//                if let houseID = myHouse?.id {
//                    self.firebaseHelper.getTimePeriodsFor(houseID: houseID) {bookings in
//                        if let bookings = bookings {
//                            self.myTimePeriods.removeAll()
//                            self.myTimePeriods.append(contentsOf: bookings)
//                        }
//                    }
//                }
            }
        }
    }
    
    func deleteHouse(){
        if let houseToDelete = house{
            firebaseHelper.delete(house: houseToDelete)
            house = nil
        }
        
    }
//    
//    func getHouse() -> House {
//        if let house = house {
//            return house
//        }
//    }
    
//    func saveTimePeriod(startDate: Date, endDate: Date) {
//            guard let userID = firebaseHelper.getUserID() else {return}
//            guard let house = house else {return}
//            if let houseID = house.id {
//                let newBooking = Booking(houseID: houseID, fromDate: startDate, toDate: endDate)
//                firebaseHelper.save(booking: newBooking, for: house)
//            }
//            
//        }
    
    
}
