//
//  BookingView.swift
//  Pet_BnB
//
//  Created by Jonas Bondesson on 2024-05-27.
//

import SwiftUI

struct BookingView: View {

    var firebaseHelper = FirebaseHelper()
    @Environment(\.dismiss) var dismiss
    var house: House?
    var booking: Booking
    @State var showAlert = false
    var body: some View {
        VStack {
            HouseDetailView( houseId: booking.houseID, firebaseHelper: firebaseHelper, booked: true, showMyOwnHouse: false)
            Text("\(booking.fromDate.formatted(date: .numeric, time: .omitted)) - \(booking.toDate.formatted(date: .numeric, time: .omitted))")
            if let confirmed = booking.confirmed {
                if booking.toDate > Date.now  && !confirmed{
                    Button(action: {
                        showAlert.toggle()
                    }, label: {
                        FilledButtonLabel(text: "Cancel Reservation")
                    })
                    .frame(width: 200)
                }
            }
        }
        .alert("Do you want cancel this reservation?", isPresented: $showAlert) {
            
            Button("No", role: .cancel) {}
            Button("Yes", role: .none) {
                firebaseHelper.unbook(booking: booking) {success in
                    if success {
                        dismiss()
                    }
                }
            }
        }
    }
}
