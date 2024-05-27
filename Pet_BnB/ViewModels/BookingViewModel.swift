//
//  BookingViewModel.swift
//  Pet_BnB
//
//  Created by Jonas Bondesson on 2024-05-15.
//

import Foundation

class BookingViewModel : ObservableObject {
    
    @Published var myBookings: [Booking] = []
    @Published var house : House?
    var firebaseHelper = FirebaseHelper()
    
    func getBookings() {
        firebaseHelper.getMyBookings() { myBookings in
            if let myBookings = myBookings {
                self.myBookings = myBookings
            }
            
        }
    }
    
    func getHouseDetails(for booking: Booking, completion: @escaping (House?) -> Void) {
        firebaseHelper.fetchHouse(byId: booking.houseID) { house in
            if let house = house {
                print("\(house.title)")
                completion(house)
            }
        }
        completion(nil)
    }
}
