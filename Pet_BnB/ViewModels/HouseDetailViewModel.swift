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
    @Published var bookings = [Booking]()
    
    init(firebaseHelper: FirebaseHelper) {
        self.firebaseHelper = firebaseHelper
    }
    
    func fetchHouse(byId id: String) {
        firebaseHelper.fetchHouse(byId: id) { [weak self] house in
            DispatchQueue.main.async {
                self?.house = house
                if let houseID = house?.id {
                    self?.firebaseHelper.getTimePeriodsFor(houseID: houseID) {bookings in
                        
                        if let bookings = bookings {
//                            print("\(bookings.count)")
                            self?.bookings.removeAll()
                            for booking in bookings {
//                                print("Booking: \(booking)")
                                self?.bookings.append(booking)
                                
                            }
                            print("Bookings: \(self?.bookings)")
                        }
                    }
                }
            }
        }
    }
    
    func bookHouse(houseID: String, booking: Booking) {
        if booking.renterID == nil {
            if let bookingID = booking.docID {
                self.firebaseHelper.bookPeriod(houseID: houseID, docID: bookingID)
            }
        }
    }
    
}
