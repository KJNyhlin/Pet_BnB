//
//  BookingViewModel.swift
//  Pet_BnB
//
//  Created by Jonas Bondesson on 2024-05-15.
//

import Foundation
import SwiftUI

class MyBookingViewModel : ObservableObject {
    
    @Published var myBookings: [Booking] = []
    @Published var myBookingHistory: [Booking] = []
    @Published var house : House?
    var firebaseHelper = FirebaseHelper()
    
    func getBookings() {
        
        firebaseHelper.getMyBookings() { myBookings in
            if let myBookings = myBookings {
                self.myBookings.removeAll()
                self.myBookingHistory.removeAll()
                for booking in myBookings {
                    if booking.toDate >= Date.now {
                        self.myBookings.append(booking)
                    } else {
                        self.myBookingHistory.append(booking)
                    }
                }
                
            }
            
        }
    }
    
    func getHouseDetails(for booking: Booking, completion: @escaping (House?) -> Void) {
        firebaseHelper.fetchHouse(byId: booking.houseID) { house in
            if let house = house {
                completion(house)
            }
        }
        completion(nil)
    }
    func getShadowColor(from: Booking) -> Color {
        if let confirmed = from.confirmed {
            if confirmed {
                return AppColors.freeBookingColor
            } else {
                return AppColors.mainAccent
            }
        } else {
            return .secondary
        }
    }
    
//    func save(review: Review) {
//        if let house = self.house {
//            firebaseHelper.save(rating: review, for: house)
//            
//            self.house!.totalRatingPoints += review.rating
//            self.house!.numberOfReviews += 1
//            }
//    }
}
