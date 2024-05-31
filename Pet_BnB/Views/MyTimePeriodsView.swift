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
                    Text("My Time Periods")
                        .font(.title)
                        .fontWeight(.bold)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding()
                    
//                    Section(header: Text("My Time Periods")
//                        .font(.title)
//                        .fontWeight(.bold)
//                        .frame(maxWidth: .infinity, alignment: .leading)
//                        .padding()) {
//                            
//                            
                            ForEach (viewModel.myTimePeriods){ booking in

                                MyTimePeriodCardView(viewModel: viewModel, booking: booking, renter: viewModel.loadRenterInfo(renterID: booking.renterID))
                            }
//                        }
                    Text("My Past Time Periods")
                        .font(.title)
                        .fontWeight(.bold)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding()
                            
                            
                            ForEach (viewModel.myPastTimePeriods){ booking in
                                MyTimePeriodCardView(viewModel: viewModel, booking: booking)
//                                MyPastTimePeriodCardView(viewModel: viewModel, booking: booking)
//                                    BookingCardView(viewModel: viewModel, booking: booking)
                            
                            }
                        
                    Button(action: {
                        showTimePeriodSheet.toggle()
                    }, label: {
                        Text("Add time period")
                    })
                
                    Spacer()
                }
                .navigationBarHidden(true)
                .onAppear {
                    viewModel.getTimePeriods()
                }
                .sheet(isPresented: $showTimePeriodSheet, content: {
                    TimePeriodView(vm: viewModel)
                        .presentationDetents([.medium])
                })
            }
        }
    }
}

struct MyTimePeriodCardView : View {
    @ObservedObject var viewModel : TimePeriodViewModel
    var firebaseHelper = FirebaseHelper()
    
    var booking : Booking
//    @Binding var renter : User?
    @State var house : House?
    @State var shadowColor: Color = .secondary
    @State var imageURL : String?
    @State var renterFirstName: String = ""
    var renter : User?
    
    var body: some View {
            VStack(alignment: .leading, spacing: 0) {
                if let confirmed = booking.confirmed {
                    if booking.toDate > Date.now {
                        Text(!confirmed && booking.toDate > Date.now ? "Not Yet Confirmed" : "Confirmed")
                            .frame(maxWidth: .infinity, alignment: .top)
                            .padding(.horizontal, 2)
                            .background(viewModel.getShadowColor(from: booking))
                            .font(.system(size: 14))
                    }
                }
                HStack() {
                    VStack(spacing: 0) {
                        
                            if let user = renter {
                                NavigationLink(destination: HouseOwnerProfileView(user: user)) {
                                    VStack {
                                        if let userImageURL = user.imageURL, let imageURL = URL(string: userImageURL) {
                                            AsyncImage(url: imageURL) { phase in
                                                switch phase {
                                                case .empty:
                                                    ProgressView()
                                                        .frame(width: 80 ,height: 80)
                                                    //                                            .frame(maxWidth: .infinity)
                                                case .success(let image):
                                                    image
                                                        .resizable()
                                                        .aspectRatio(contentMode: .fill)
                                                        .frame(width: 80 ,height: 80)
                                                    //                                            .frame(maxWidth: .infinity)
                                                        .clipShape(Circle())
                                                        .clipped()
                                                        .padding(.horizontal)
                                                    
                                                case .failure:
                                                    Image(systemName: "photo")
                                                        .resizable()
                                                        .aspectRatio(contentMode: .fill)
                                                        .frame(width: 80 ,height: 80)
                                                    //                                            .frame(maxWidth: .infinity)
                                                        .background(Color.gray)
                                                @unknown default:
                                                    Image(systemName: "photo")
                                                        .resizable()
                                                        .aspectRatio(contentMode: .fill)
                                                        .frame(width: 80 ,height: 80)
                                                    //                                            .frame(maxWidth: .infinity)
                                                        .background(Color.gray)
                                                }
                                            }
                                            
                                            Text(renterFirstName)
                                                .font(.system(size: 12))
                                                
                                        }
                                    }
                            }
                        } else {
                            Rectangle()
                                .foregroundColor(AppColors.inactive)
                                .frame(width: 100, height: 100)
                                
                        }
                    }
                    
                    VStack(alignment: .leading, spacing: 8) {
                        HStack {
                            Text("\(booking.fromDate.formatted(date: .numeric, time: .omitted)) - \(booking.toDate.formatted(date: .numeric, time: .omitted))")
                                .font(.headline)
                                .frame(maxWidth: .infinity, maxHeight: .infinity)
                            if let renterID = booking.renterID, booking.toDate > Date.now {
                                NavigationLink(destination: ChatView(vm:ChatViewModel(toUserID: renterID))){
                                    Image(systemName: "envelope.fill")
                                    //.font(.largeTitle)
                                        .padding(.vertical)
                                        .foregroundColor(AppColors.mainAccent)
                                }
                            }
                        }
                        HStack {
                            if booking.fromDate > Date.now {
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
                                Button(action: {
                                    viewModel.firebaseHelper.remove(timePeriod: booking)
                                }, label: {
                                    Text("Remove")
                                })
                                .frame(alignment: .trailing)
                                .buttonStyle(PlainButtonStyle())
                            }
                        }
                        .frame(maxWidth: .infinity)
                        .font(.subheadline)
                        
                        .foregroundColor(.secondary)
                        
                    }
                    .frame(maxWidth: .infinity)
                    .padding()
                }
            }
            .frame( width: 335)
            .background(Color.white)
            .cornerRadius(20)
            .shadow(color: viewModel.getShadowColor(from: booking),radius: 5)
            .padding(.vertical, 8)

            .buttonStyle(PlainButtonStyle())
            
            .onAppear() {
                viewModel.firebaseHelper.fetchHouse(byId: booking.houseID) {house in
                    self.house = house
                }
                if let renterID = booking.renterID {
                    viewModel.firebaseHelper.loadUserInfo(userID: renterID) {user in
                        self.imageURL = user?.imageURL
                        if let user = user {
                            if let firstName = user.firstName {
                                self.renterFirstName = firstName
                            }
                        }
                    }
                }

            }
        .buttonStyle(PlainButtonStyle())
    }
}


//#Preview {
//    MyTimePeriodsView()
//}
