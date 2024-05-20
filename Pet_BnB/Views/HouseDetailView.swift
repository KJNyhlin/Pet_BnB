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
                        VStack (alignment: .leading, spacing: 8) {
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
                            }
                            VStack(alignment: .leading, spacing: 8) {
                                Text(house.title)
                                    .font(.title)
                                    //.fontWeight(.bold)
                                    .padding(.horizontal, 20)
                                
                                Text("For rent: Date missing")
                                    .font(.subheadline)
                                    .padding(.horizontal, 20)
                                
                                Text("\(house.streetName) \(house.streetNR) , \(house.zipCode) \(house.city)")
                                    .font(.footnote)
                                    .fontWeight(.bold)
                                    .padding(.horizontal, 20)
                                
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
                                .padding(.horizontal, 20)                                
                                
                                Text(house.description)
                                    .font(.subheadline)
                                    .fixedSize(horizontal: false, vertical: true)
                                    .padding(.horizontal, 20)
                            }
                            .padding(.horizontal, 15)
                            //  .padding([.leading, .trailing], 20)
                            .padding(.top, 8)
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

#Preview {
    HouseDetailView(houseId: "1", firebaseHelper: FirebaseHelper())
}
