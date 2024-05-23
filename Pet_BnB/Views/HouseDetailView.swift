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
                    if let house = viewModel.house {
                        VStack () {
                            if let imageUrl = house.imageURL, let url = URL(string: imageUrl) {
                                AsyncImage(url: url) { phase in
                                    switch phase {
                                    case .empty:
                                        ProgressView()
                                            .frame(height: 300)
                                            .frame(maxWidth: 400)
                                    case .success(let image):
                                        image
                                            .resizable()
                                            .aspectRatio(contentMode: .fill)
                                            .frame(height: 300)
                                            .frame(maxWidth: 400)
                                            .clipped()
                                    case .failure:
                                        Image(systemName: "photo")
                                            .resizable()
                                            .aspectRatio(contentMode: .fill)
                                            .frame(height: 300)
                                            .frame(maxWidth: 400)
                                            .background(Color.gray)
                                    @unknown default:
                                        Image(systemName: "photo")
                                            .resizable()
                                            .aspectRatio(contentMode: .fill)
                                            .frame(height: 300)
                                            .frame(maxWidth: 400)
                                            .background(Color.gray)
                                    }
                                }
                            }
                            VStack(alignment: .leading, spacing: 8) {
                                Text(house.title)
                                    .font(.title)
                                
                                Text("\(house.streetName) \(house.streetNR) , \(house.zipCode) \(house.city)")
                                    .font(.footnote)
                                    .fontWeight(.bold)
                                
                                HStack {
                                    Label(
                                        title: { Text("\(house.beds) st") },
                                        icon: { Image(systemName: "bed.double") }
                                    )
                                    .padding(.trailing, 10)
                                    
                                    Label(
                                        title: { Text("\(house.size) m²") },
                                        icon: { Image(systemName: "house.fill") }
                                    )
                                    .padding(.trailing, 10)
                                }
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .padding(.vertical, 5)
                                
                                Text(house.description)
                                    .fixedSize(horizontal: false, vertical: true)
                              
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
                            }
                            .padding()
                            .padding(.horizontal, 5)
                            .padding(.top, -10)
                        }
                    } else {
                        ProgressView()
                            .onAppear {
                                viewModel.fetchHouse(byId: houseId)
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
