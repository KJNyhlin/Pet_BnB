//
//  BookingView.swift
//  Pet_BnB
//
//  Created by Jonas Bondesson on 2024-05-27.
//

import SwiftUI

struct BookingView: View {
    @StateObject var viewModel = BookingsViewModel()
    var house: House?
    var booking: Booking
    var body: some View {
//        Text("")
        
        HouseDetailView( houseId: booking.houseID, firebaseHelper: viewModel.firebaseHelper, booked: true, showMyOwnHouse: false)
        Text("\(booking.fromDate.formatted(date: .numeric, time: .omitted)) - \(booking.toDate.formatted(date: .numeric, time: .omitted))")
        if booking.toDate > Date.now {
            Button(action: {
                viewModel.firebaseHelper.unbook(booking: booking)
            }, label: {
                FilledButtonLabel(text: "unbook")
            })
            .frame(width: 100)
        }
    }
}
//
//#Preview {
//    BookingView()
//}
