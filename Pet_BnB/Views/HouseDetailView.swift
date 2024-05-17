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
        ScrollView {
            if let house = viewModel.house {
                VStack(alignment: .leading) {
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
                    
                    VStack(alignment: .leading, spacing: 16) {
                        Text(house.title)
                            .font(.largeTitle)
                            .fontWeight(.bold)
                        
                        Text(house.description)
                            .font(.body)
                    }
                    .padding()
                }
            } else {
                ProgressView()
                    .onAppear {
                        viewModel.fetchHouse(byId: houseId)
                    }
            }
        }
        //.navigationTitle(viewModel.house?.title ?? "Loading...")
        .navigationBarTitleDisplayMode(.inline)
    }
}

#Preview {
    HouseDetailView(houseId: "1", firebaseHelper: FirebaseHelper())
}
