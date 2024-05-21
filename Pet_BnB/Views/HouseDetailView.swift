//
//  HouseDetailView.swift
//  Pet_BnB
//
//  Created by Maida on 2024-05-16.
//


import SwiftUI

struct HouseDetailView: View {
    @StateObject private var viewModel: HouseDetailViewModel
    var houseId: String
    
    init(houseId: String, firebaseHelper: FirebaseHelper) {
        _viewModel = StateObject(wrappedValue: HouseDetailViewModel(firebaseHelper: firebaseHelper))
        self.houseId = houseId
    }
    
    var body: some View {
        ZStack {
            ScrollView {
                VStack(alignment: .leading) {
                    if let house = viewModel.house {
                        if let imageUrl = house.imageURL, let url = URL(string: imageUrl) {
                            AsyncImage(url: url) { phase in
                                switch phase {
                                case .empty:
                                    ProgressView()
                                        .frame(height: 300)
                                        .frame(maxWidth: .infinity)
                                case .success(let image):
                                    image
                                        .resizable()
                                        .aspectRatio(contentMode: .fill)
                                        .frame(height: 300)
                                        .frame(maxWidth: .infinity)
                                        .clipped()
                                case .failure:
                                    Image(systemName: "photo")
                                        .resizable()
                                        .aspectRatio(contentMode: .fill)
                                        .frame(height: 300)
                                        .frame(maxWidth: .infinity)
                                        .background(Color.gray)
                                @unknown default:
                                    Image(systemName: "photo")
                                        .resizable()
                                        .aspectRatio(contentMode: .fill)
                                        .frame(height: 300)
                                        .frame(maxWidth: .infinity)
                                        .background(Color.gray)
                                }
                            }
                        } else {
                            Image(systemName: "photo")
                                .resizable()
                                .aspectRatio(contentMode: .fill)
                                .frame(height: 300)
                                .frame(maxWidth: .infinity)
                                .background(Color.gray)
                        }
                        VStack(alignment: .leading, spacing: 8) {
                            Text(house.title)
                                .font(.system(size: 26, weight: .bold))
                                .fontWeight(.bold)
                                .padding([.leading, .trailing], 10)
                            
                            Text("★ 4.91")
                                .font(.subheadline)
                                .padding([.leading, .trailing], 10)
                            
                            Text("Address ")
                                .font(.footnote)
                                .fontWeight(.bold)
                                .padding([.leading, .trailing], 10)
                            
                            Text("City • beds • sqm ")
                                .font(.footnote)
                                .padding([.leading, .trailing], 10)
                            
                            Text(house.description)
                                .font(.system(size: 16, weight: .regular))
                                .fixedSize(horizontal: false, vertical: true)
                                .padding([.leading, .trailing, .bottom], 10)
                            Text("Time periods")
                                .font(.system(size: 16, weight: .regular))
                            
                            ForEach(viewModel.bookings) {booking in
                                HStack {
                                    Text("\(booking.fromDate.formatted(date: .numeric, time: .omitted)) - \(booking.toDate.formatted(date: .numeric, time: .omitted))")
                                    if booking.renterID == nil {
                                        Button(action: {
                                            if let houseID = house.id,
                                               let bookingID = booking.docID
                                            {
                                                viewModel.bookHouse(houseID: houseID, booking: booking)
                                            }
                                        }, label: {
                                            
                                            Text("Book")
                                        })
                                    }
                                }
                            }
                            
//                            BookingsList(viewModel: viewModel)
                        }
                        .padding([.leading, .trailing], 20)
                        .padding(.top, -2)
                    } else {
                        ProgressView()
                            .onAppear {
                                viewModel.fetchHouse(byId: houseId)
                            }
                            .padding(.top, 50)
                    }
                }
            }
            
            VStack {
                Spacer()
                HStack {
                    Spacer()
                    Button(action: {
                        // Lägg till funktion för bokning
                    })
                    {
                        FilledButtonLabel(text: "Book")
                            .frame(maxWidth: 80)
                            //.fontWeight(.bold)
                    }
                    .padding([.bottom, .trailing], 30)
                }
            }
        }
    }
}

struct BookingsList : View {
    @StateObject var viewModel : HouseDetailViewModel
    var body: some View {
        VStack {
            Text("Time periods")
                .font(.system(size: 16, weight: .regular))
            if let bookings = viewModel.house?.bookings {
                List(bookings) {
                    Text("\($0.id)")
                }
            }
            
        }
    }
}


#Preview {
    HouseDetailView(houseId: "1", firebaseHelper: FirebaseHelper())
}
