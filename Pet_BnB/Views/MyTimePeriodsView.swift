//
//  MyTimePeriodsView.swift
//  Pet_BnB
//
//  Created by Jonas Bondesson on 2024-05-28.
//

import SwiftUI

struct MyTimePeriodsView: View {
    @StateObject var viewModel : TimePeriodViewModel
    @State var showTimePeriodSheet: Bool = false
    
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
                                MyPastTimePeriodCardView(viewModel: viewModel, booking: booking)
//                                    BookingCardView(viewModel: viewModel, booking: booking)
                            
                            }
                        }
                    Button(action: {
                        showTimePeriodSheet.toggle()
                    }, label: {
                        Text("Add time period")
                    })
                
                    Spacer()
                }
                .onAppear {
                    viewModel.getTimePeriods()
                }
                .sheet(isPresented: $showTimePeriodSheet, content: {
                    TimePeriodView(vm: viewModel)
                })
            }
        }
    }
}

struct MyTimePeriodCardView : View {
    @ObservedObject var viewModel : TimePeriodViewModel
    var firebaseHelper = FirebaseHelper()
    var booking : Booking
    @State var house : House?
    @State var shadowColor: Color = .secondary
    
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
                        Text("\(booking.fromDate.formatted(date: .numeric, time: .omitted)) - \(booking.toDate.formatted(date: .numeric, time: .omitted))")
                            .font(.headline)
                        HStack {
                            if let confirmed = booking.confirmed {
                                if !confirmed {
                                    Button(action: {
                                        firebaseHelper.confirm(Booking: booking, docID: booking.docID)
                                    }, label: {
                                        Text("Confirm")
                                            .foregroundColor(.green)
                                    })
                                    .buttonStyle(PlainButtonStyle())
                                }
                                Button(action: {
                                    viewModel.firebaseHelper.deny(Booking: booking, docID: booking.docID)
                                }, label: {
                                    Text("Deny")
                                        .foregroundColor(.red)
                                })
                            }
                            Button(action: {}, label: {
                                Text("Remove")
                            })
                            .frame(alignment: .trailing)
                            .buttonStyle(PlainButtonStyle())
//                            if let confirmed = booking.confirmed {
//                                if confirmed {
//                                    Image(systemName: "checkmark")
//                                        .foregroundColor(.green)
//                                } else if !confirmed {
//                                    Image(systemName: "swift")
//                                        .foregroundColor(.orange)
//                                }
//                            }
                        }
                        .font(.subheadline)
                        
                        .foregroundColor(.secondary)
                        
        
                        //                        .foregroundColor(.secondary)
                    }
                    .padding()
                }
            }
            .background(Color.white)
            .cornerRadius(20)
            .shadow(color: viewModel.getShadowColor(from: booking),radius: 5)
            .padding(.vertical, 8)
            .frame(maxWidth: 335, maxHeight: 150)
            //        .frame(height: 150)
            //        }
            .buttonStyle(PlainButtonStyle())
            
            .onAppear() {
                viewModel.firebaseHelper.fetchHouse(byId: booking.houseID) {house in
                    self.house = house
                }
//                self.shadowColor = viewModel.getShadowColor(from: booking)
//                viewModel.getHouseDetails(for: booking) { house in
//                    self.house = house
//                }
            }
        }
        
        .buttonStyle(PlainButtonStyle())
      
    }
        
}

struct MyPastTimePeriodCardView : View {
    @ObservedObject var viewModel : TimePeriodViewModel
    var booking : Booking
    @State var house : House?
    @State var shadowColor: Color = .secondary
    
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
                        Text("\(booking.fromDate.formatted(date: .numeric, time: .omitted)) - \(booking.toDate.formatted(date: .numeric, time: .omitted))")
                            .font(.headline)
                        HStack {
                            
//                            if let confirmed = booking.confirmed {
//                                if confirmed {
//                                    Image(systemName: "checkmark")
//                                        .foregroundColor(.green)
//                                } else if !confirmed {
//                                    Image(systemName: "swift")
//                                        .foregroundColor(.orange)
//                                }
//                            }
                        }
                        .font(.subheadline)
                        
                        .foregroundColor(.secondary)
                        
        
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
