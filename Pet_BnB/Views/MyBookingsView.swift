//
//  MyBookingsView.swift
//  Pet_BnB
//
//  Created by Jonas Bondesson on 2024-05-15.
//

import SwiftUI

struct MyBookingsView: View {
    @StateObject var viewModel = MyBookingViewModel()
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 0){
                    
                    Section(header: Text("My bookings")
                        .font(.title)
                        .fontWeight(.bold)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding()) {
                            
                            
                            ForEach (viewModel.myBookings){ booking in
                                BookingCardView(viewModel: viewModel, booking: booking)
                            }
                        }
                    Section(header: Text("My history")
                        .font(.title)
                        .fontWeight(.bold)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding()) {
                            
                            
                            ForEach (viewModel.myBookingHistory){ booking in
                                
                                    BookingCardView(viewModel: viewModel, booking: booking)
                            
                            }
                        }
                    Spacer()
                }
                .onAppear {
                    viewModel.getBookings()
                }
            }
        }
    }
}



struct BookingCardView : View {
    @ObservedObject var viewModel : MyBookingViewModel
    var booking : Booking
    @State var house : House?
    
    var body: some View {
        NavigationLink(destination: BookingView(house: house, booking: booking)) {
            VStack(alignment: .leading, spacing: 0) {
                HStack {
                    ZStack {
                        
                        HStack {
                            
                            
                            SwipableImageView2(
                                houseImageURL: house?.imageURL ?? "",
                                petImageURL: house?.pets?.first?.imageURL ?? "",
                                height: 100,
                                width: 100
                            )
                            
                            VStack(alignment: .leading, spacing: 8) {
                                Text(house?.title ?? "")
                                    .font(.headline)
                                HStack {
                                    Label(
                                        title: { Text("\(house?.beds ?? 0) st") },
                                        icon: { Image(systemName: "bed.double") }
                                    )
                                    .padding(.trailing, 10)
                                    
                                    Label(
                                        title: { Text("\(house?.size ?? 0) m²") },
                                        icon: { Image(systemName: "house.fill") }
                                    )
                                }
                                .font(.subheadline)
                                .foregroundColor(.secondary)
                                
                                Text("\(booking.fromDate.formatted(date: .numeric, time: .omitted)) - \(booking.toDate.formatted(date: .numeric, time: .omitted))")
                                    .font(.subheadline)
                                //                        .foregroundColor(.secondary)
                            }
                            .padding()
                        }
                        if let confirmed = booking.confirmed {
                            if !confirmed && booking.toDate > Date.now {
                                Text("Not Yet Confirmed")
                                    .background(AppColors.mainAccent)
                                    .font(.system(size: 14))
                                    .frame(maxWidth: .infinity, alignment: .leading)
                                    .rotationEffect(.degrees(-45.0))
                                    .offset(x: -40, y: -80)
                                    
                            }
                        }
                    }
                }
            }
            .background(Color.white)
            .cornerRadius(20)
            .shadow(color: booking.toDate > Date.now ? viewModel.getShadowColor(from: booking) : .secondary,radius: 5)
            .padding(.vertical, 8)
            .frame(maxWidth: 335, maxHeight: 150)
            //        .frame(height: 150)
            //        }
            .buttonStyle(PlainButtonStyle())
            
            .onAppear() {
                viewModel.getHouseDetails(for: booking) { house in
                    self.house = house
                }
            }
        }
        
        .buttonStyle(PlainButtonStyle())
      
    }
        
}

#Preview {
    MyBookingsView()
}
