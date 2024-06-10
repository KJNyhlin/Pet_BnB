//
//  HouseDetailViewModel.swift
//  Pet_BnB
//
//  Created by Maida on 2024-05-16.
//

import Foundation
import Combine
import SwiftUI
//import CoreLocation
import MapKit

class HouseDetailViewModel: ObservableObject {
    @Published var house: House?
    @Published var houseOwner: User?
    @Published var housePet: Pet?
     var firebaseHelper: FirebaseHelper
    private var cancellables = Set<AnyCancellable>()
    @Published var bookings = [Booking]()
    @Published var date: Date
    @Published var daysInMonth: [Date]
    var dateManager = DateManager()
    @Published var bookingColor : Color = Color.blue
    @Published var selectedBookingID: String = ""
    @Published var selectedBooking: Booking?
    @Published var rating: Double?
    @Published var reviews: [Review] = []
    @Published var reviewerInfo: [String: User] = [:]
    
    
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
                if let ownerId = house?.ownerID {
                    self?.fetchHouseOwner(byId: ownerId)
                }
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
                    selectedBooking = nil
                } else {
                    self.selectedBookingID = docID
                    selectedBooking = booking
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
    
    func fetchHouseOwner(byId ownerId: String) {
          //  firebaseHelper.fetchUser(byId: ownerId) { [weak self] user in
        firebaseHelper.loadUserInfo(userID: ownerId) { [weak self] user in
                DispatchQueue.main.async {
                    self?.houseOwner = user
                }
            }
        }
    
    
    private func fetchHousePet(byId id: String) {
            firebaseHelper.fetchPet(byId: id) { [weak self] result in
                switch result {
                case .success(let pet):
                    DispatchQueue.main.async {
                        self?.housePet = pet
                    }
                case .failure(let error):
                    print("Error fetching house pet: \(error.localizedDescription)")
                }
            }
        }
    
    
    func getReviews(houseID: String) {
        self.reviews.removeAll()
        firebaseHelper.fetchReviews(houseID: houseID) {reviews in
            self.reviews.removeAll()
            
            self.reviews.append(contentsOf: reviews)
            self.reviews.sort{review1, review2 in
                review1.date > review2.date
            }
            self.fetchReviewerInfo()
        }
    }
    
    func fetchReviewerInfo() {
        self.reviewerInfo.removeAll()
        for review in self.reviews {
          //  firebaseHelper.getRenterInfo(renterID: review.userID) {reviewer in
            firebaseHelper.loadUserInfo(userID: review.userID) {reviewer in
                if let reviewer = reviewer {
                    self.reviewerInfo[review.userID] = reviewer
                }
            }
        }
    }
    
    func loadReviewerInfo(reviewerID: String) -> User? {
        
            return self.reviewerInfo[reviewerID]
        
        
    }
    
    func openMapsForDirections(latitude: Double, longitude: Double) {
            let destinationCoordinate = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
            let placemark = MKPlacemark(coordinate: destinationCoordinate)
            let mapItem = MKMapItem(placemark: placemark)
            mapItem.name = "Destination"
            mapItem.openInMaps(launchOptions: [MKLaunchOptionsDirectionsModeKey: MKLaunchOptionsDirectionsModeDriving])
        }
    
    
    
}
