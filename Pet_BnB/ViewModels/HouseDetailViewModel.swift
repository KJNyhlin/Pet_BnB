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
    @Published var selectedBookingID: String = ""
    
    
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
                        print("we get new bookings")
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
    
    func bookHouse(houseID: String) {
        
        if selectedBookingID != "" {
                self.firebaseHelper.bookPeriod(houseID: houseID, docID: selectedBookingID)
            }
        selectedBookingID = ""
        
    }
    
    func getColor(from booking: Booking) -> Color {
        if let bookingID = booking.docID {
            if bookingID == selectedBookingID {
                return AppColors.mainAccent
            }
        }
        if booking.renterID != nil {
            return AppColors.inactive
        } else {
            return AppColors.freeBookingColor
        }
    }
    
    func setBookingID(booking: Booking) {
        if booking.renterID == nil {
            if let docID = booking.docID {
                if self.selectedBookingID == docID {
                    self.selectedBookingID = ""
                } else {
                    self.selectedBookingID = docID
                }
            }
        }
    }
    
    func checkIfChecked(booking: Booking) -> Bool {
        if let docID = booking.docID {
            return docID == self.selectedBookingID
        } else {
            return false
        }
    }
    
    func showBookingsForMonth(booking: Booking) -> Bool {
        return date.isDateInMonth(date: booking.fromDate, selectedMonth: date) || date.isDateInMonth(date: booking.toDate, selectedMonth: date) 
    }
    
    
//    func daysInMonth(for date: Date) -> [Date] {
//        guard let monthInterval = Calendar.current.dateInterval(of: .month, for: date),
//              let monthStart = monthInterval.start else { return []}
//         var dates = [Date]()
//        for day in 0..< Calendar.current.range(of: .day, in: .month, for: monthStart)!.count
//    }
    
}
