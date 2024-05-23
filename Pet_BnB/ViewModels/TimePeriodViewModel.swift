//
//  TimePeriodViewModel.swift
//  Pet_BnB
//
//  Created by Jonas Bondesson on 2024-05-23.
//

import Foundation

class TimePeriodViewModel: ObservableObject {
    @Published var startDate = Date.now
    @Published var endDate = Date.now
    @Published var myTimePeriods = [Booking]()
    @Published var house : House
    let firebaseHelper = FirebaseHelper()
    
    init(house: House) {
        self.house = house
    }
    
    func saveTimePeriod(startDate: Date, endDate: Date, house: House) {
            guard let userID = firebaseHelper.getUserID() else {return}
            
            if let houseID = house.id {
                let newBooking = Booking(houseID: houseID, fromDate: startDate, toDate: endDate)
                firebaseHelper.save(booking: newBooking, for: house)
            }
            
        }
}
