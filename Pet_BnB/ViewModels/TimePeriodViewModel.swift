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
    @Published var myTimePeriods = [Booking]()
    @Published var house : House
    let firebaseHelper = FirebaseHelper()
    @Published var date: Date
    @Published var daysInMonth: [Date]
    var dateManager = DateManager()
    @Published var bookingColor : Color = Color.blue
    @Published var selectedBookingID: String = ""
    
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
            firebaseHelper.save(booking: newBooking, for: house)
            self.startDate = nil
            self.endDate = nil
        }
        
    }
    
    func getTimePeriods() {
        if let houseID = house.id {
            self.firebaseHelper.getTimePeriodsFor(houseID: houseID) {bookings in
                if let bookings = bookings {
                    self.myTimePeriods.removeAll()
                    self.myTimePeriods.append(contentsOf: bookings)
                }
            }
        }
    }
    
    func setDates(date: Date) {
        if startDate == nil && checkPressed(date: date){
            startDate = date
            endDate = date
        } else if startDate == date {
            startDate = nil
            endDate = nil
        } else if endDate == date {
            endDate = nil
        } else if let startDate = self.startDate {
            if compareDates(date1: startDate, date2: date) && checkPressed(date: date) && checkIfBookingIsInRange(date: date) {
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
    
    func checkPressed(date: Date) -> Bool {
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
    
    
    
        
//        func checkEndDate(date: Date) -> Bool {
//            for myTimePeriod in myTimePeriods {
//                print(myTimePeriod)
//                print(date)
//                let fromDate = Calendar.current.startOfDay(for: myTimePeriod.fromDate)
//                guard let correctDate = Calendar.current.date(byAdding: .day, value: 1, to: myTimePeriod.toDate) else { return false }
//                let toDate = Calendar.current.startOfDay(for: correctDate)
//                
//                print(correctDate)
//                if (fromDate ... myTimePeriod.toDate).contains(date) {
//                    
//                    return false
//                }
//                
//            }
//            return true
//            
//            
//        }
    }

