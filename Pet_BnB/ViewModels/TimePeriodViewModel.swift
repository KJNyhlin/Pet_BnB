//
//  TimePeriodViewModel.swift
//  Pet_BnB
//
//  Created by Jonas Bondesson on 2024-05-23.
//

import Foundation
import Combine
import SwiftUI

class TimePeriodViewModel: ObservableObject {
    @Published var startDate : Date? = nil
    @Published var endDate : Date? = nil
    @Published var myTimePeriods : [Booking] = []
    @Published var myPastTimePeriods : [Booking] = []
    @Published var allMyTimePeriods : [Booking] = []
    @Published var house : House
    let firebaseHelper = FirebaseHelper()
    @Published var date: Date
    @Published var daysInMonth: [Date]
    var dateManager = DateManager()
    @Published var bookingColor : Color = Color.blue
    @Published var selectedBookingID: String = ""
    @Published var renterInfo: [String: User] = [:]
    
    init(house: House, date: Date = Date()) {
        self.house = house
        self.date = date.startDateOfMonth
        self.daysInMonth = dateManager.getDaysOfMonth(from: date)
    }
    
    func saveTimePeriod() {
        guard let userID = firebaseHelper.getUserID() else {return}
        
        if let houseID = house.id,
           let startDate = self.startDate?.formattedForBooking,
           let endDate = self.endDate?.formattedForBooking {
            let newBooking = Booking(houseID: houseID, fromDate: startDate, toDate: endDate)
            firebaseHelper.save(TimePeriod: newBooking, for: house)
            self.startDate = nil
            self.endDate = nil
        }
    }
    
    func getTimePeriods() {
        if let houseID = house.id {
            self.firebaseHelper.getTimePeriodsFor(houseID: houseID) {bookings in
                if let bookings = bookings {
                    self.myTimePeriods.removeAll()
                    self.myPastTimePeriods.removeAll()
                    self.allMyTimePeriods.removeAll()
                    self.allMyTimePeriods.append(contentsOf: bookings)
                    for booking in bookings {
                        if booking.toDate < Date.now {
                            self.myPastTimePeriods.append(booking)
                        } else {
                            self.myTimePeriods.append(booking)
                        }
                    }
                    self.myTimePeriods.sort() {booking1, booking2 in
                        booking1.fromDate < booking2.fromDate
                    }
                    self.myPastTimePeriods.sort() {booking1, booking2 in
                        booking1.fromDate < booking2.fromDate
                    }
                    self.allMyTimePeriods.sort() {booking1, booking2 in
                        booking1.fromDate < booking2.fromDate
                    }
                    self.fetchRenterInfo()
                }
            }
        }
    }
    
    func fetchRenterInfo() {
        renterInfo.removeAll()
        for myTimePeriod in myTimePeriods {
            if let renterID = myTimePeriod.renterID {
                firebaseHelper.loadUserInfo(userID: renterID) {renter in
                    if let renter = renter {
                        self.renterInfo[renterID] = renter
                    }
                }
            }
        }
    }
    
    func loadRenterInfo(renterID: String?) -> User? {
        if let renterID = renterID {
            return self.renterInfo[renterID]
        }
        return nil
    }
    
    func setDates(date: Date) {
        if startDate == nil && checkIfDateContainsBooking(date: date){
            startDate = date
            endDate = date
        } else if startDate == date {
            startDate = nil
            endDate = nil
        } else if endDate == date {
            endDate = nil
        } else if let startDate = self.startDate {
            if compareDates(date1: startDate, date2: date) && checkIfDateContainsBooking(date: date) && checkIfBookingIsInRange(date: date) {
                self.endDate = date
            }
        }
    }
    
    func compareDates(date1: Date, date2: Date) -> Bool {
        return date1 < date2
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
    
    func getShadowColor(from: Booking) -> Color {
        if from.toDate < Date.now {
            return .secondary
        } else if let confirmed = from.confirmed {
            if confirmed {
                return AppColors.freeBookingColor
            } else {
                return AppColors.mainAccent
            }
        } else {
            return .secondary
        }
    }
    
    func setBookingID(booking: Booking) {
        if booking.renterID == nil {
            if let docID = booking.docID {
                if self.selectedBookingID == docID {
                    self.selectedBookingID = ""
                    print("SelectedID: \(selectedBookingID)")
                } else {
                    self.selectedBookingID = docID
                    print("SelectedID: \(selectedBookingID)")
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
    
    func checkIfDateContainsBooking(date: Date) -> Bool {
        for myTimePeriod in myTimePeriods {
            let fromDate = myTimePeriod.fromDate.formattedForStartDate
            let toDate = myTimePeriod.toDate.formattedForEndDate
            if (fromDate ... toDate).contains(date) {
                return false
            }
        }
        return true
    }
    
    func checkIfBookingIsInRange(date: Date) -> Bool {
        if let startDate = self.startDate {
            for myTimePeriod in myTimePeriods {
                if (startDate.startOfDay ... date.formattedForEndDate).contains(myTimePeriod.fromDate) || (startDate.startOfDay ... date.formattedForEndDate).contains(myTimePeriod.fromDate) {
                    return false
                }
            }
            return true
        } else {
            return true
        }
    }
    
}

