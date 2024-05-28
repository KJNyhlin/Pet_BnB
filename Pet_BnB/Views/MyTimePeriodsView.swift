//
//  MyTimePeriodsView.swift
//  Pet_BnB
//
//  Created by Jonas Bondesson on 2024-05-28.
//

import SwiftUI

struct MyTimePeriodsView: View {
    @StateObject var viewModel : TimePeriodViewModel
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 0){
                    
                    Section(header: Text("My Time Periods")
                        .font(.title)
                        .fontWeight(.bold)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding()) {
                            
                            
                            ForEach (viewModel.myTimePeriods){ booking in
//                                BookingCardView(viewModel: viewModel, booking: booking)
                                MyTimePeriodCardView(viewModel: viewModel, booking: booking)
                            }
                        }
                    Section(header: Text("My Past Time Periods")
                        .font(.title)
                        .fontWeight(.bold)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding()) {
                            
                            
                            ForEach (viewModel.myPastTimePeriods){ booking in
                                MyTimePeriodCardView(viewModel: viewModel, booking: booking)
//                                    BookingCardView(viewModel: viewModel, booking: booking)
                            
                            }
                        }
                    Spacer()
                }
                .onAppear {
                    viewModel.getTimePeriods()
                }
            }
        }
    }
}

struct MyTimePeriodCardView : View {
    @ObservedObject var viewModel : TimePeriodViewModel
    var booking : Booking
    @State var house : House?
    
    var body: some View {
        NavigationLink(destination: BookingView(house: house, booking: booking)) {
            VStack(alignment: .leading, spacing: 0) {
                
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
            }
            .background(Color.white)
            .cornerRadius(20)
            .shadow(radius: 5)
            .padding(.vertical, 8)
            .frame(maxWidth: 335, maxHeight: 150)
            //        .frame(height: 150)
            //        }
            .buttonStyle(PlainButtonStyle())
            
            .onAppear() {
                viewModel.firebaseHelper.fetchHouse(byId: booking.houseID) {house in
                    self.house = house
                }
//                viewModel.getHouseDetails(for: booking) { house in
//                    self.house = house
//                }
            }
        }
        
        .buttonStyle(PlainButtonStyle())
      
    }
        
}

//#Preview {
//    MyTimePeriodsView()
//}
