//
//  HouseDetailViewModel.swift
//  Pet_BnB
//
//  Created by Maida on 2024-05-16.
//

import Foundation
import Combine
import SwiftUI

class HouseDetailViewModel: ObservableObject {
    @Published var house: House?
    private var firebaseHelper: FirebaseHelper
    private var cancellables = Set<AnyCancellable>()
    @Published var bookings = [Booking]()
    @Published var date: Date
    @Published var daysInMonth: [Date]
    var dateManager = DateManager()
    @Published var bookingColor : Color = Color.blue
    
    
    init(firebaseHelper: FirebaseHelper, date: Date = Date()) {
        self.firebaseHelper = firebaseHelper
        self.date = date.startDateOfMonth
        self.daysInMonth = dateManager.getDaysOfMonth(from: date)
    }
    func previousMonth(){
        
        if let newDate = date.previousMonth(){
            date = newDate
            daysInMonth = dateManager.getDaysOfMonth(from: date)
        }
    }
    
    func nextMonth(){
        if let newDate = date.nextMonth(){
            date = newDate
            daysInMonth = dateManager.getDaysOfMonth(from: date)
        }
    }
    
    
    func fetchHouse(byId id: String) {
        firebaseHelper.fetchHouse(byId: id) { [weak self] house in
            DispatchQueue.main.async {
                self?.house = house
                if let houseID = house?.id {
                    self?.firebaseHelper.getTimePeriodsFor(houseID: houseID) {bookings in
                        
                        if let bookings = bookings {
                            self?.bookings.removeAll()
                            for booking in bookings {
                                self?.bookings.append(booking)
                            }
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
    
    func getColor(from booking: Booking) -> Color {
        if booking.renterID != nil {
            return AppColors.inactive
        } else {
            return AppColors.mainAccent
        }
    }
    
//    func daysInMonth(for date: Date) -> [Date] {
//        guard let monthInterval = Calendar.current.dateInterval(of: .month, for: date),
//              let monthStart = monthInterval.start else { return []}
//         var dates = [Date]()
//        for day in 0..< Calendar.current.range(of: .day, in: .month, for: monthStart)!.count
//    }
    
}
