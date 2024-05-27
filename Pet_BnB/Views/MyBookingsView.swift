//
//  MyBookingsView.swift
//  Pet_BnB
//
//  Created by Jonas Bondesson on 2024-05-15.
//

import SwiftUI

struct MyBookingsView: View {
    @StateObject var viewModel = BookingViewModel()
    var body: some View {
        VStack {
            ForEach (viewModel.myBookings){ booking in
                BookingCardView(viewModel: viewModel, booking: booking)
            }
        }
        .onAppear {
            viewModel.getBookings()
        }
    }
}


struct BookingCardView : View {
    var viewModel : BookingViewModel
    var booking: Booking
    @State var house : House?
    
    
    var body: some View {
        VStack {
            if let house = house {
                Text("\(house.title)")
            }
        }
        .onAppear() {
            viewModel.firebaseHelper.fetchHouse(byId: booking.houseID) {house in
                self.house = house
            }
        }
    }
}

#Preview {
    MyBookingsView()
}
