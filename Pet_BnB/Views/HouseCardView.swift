//
//  HouseCardView.swift
//  Pet_BnB
//
//  Created by Maida on 2024-05-17.
//

import SwiftUI

struct HouseCardView: View {
    var house: House
    @EnvironmentObject var firebaseHelper: FirebaseHelper
    
    var body: some View {
        NavigationLink(destination: HouseDetailView(houseId: house.id ?? "", firebaseHelper: firebaseHelper)) {
            VStack(alignment: .leading, spacing: 0) {
                if let imageURL = house.imageURL, let url = URL(string: imageURL) {
                    AsyncImage(url: url) { phase in
                        switch phase {
                        case .empty:
                            ProgressView()
                                .frame(height: 200)
                                .frame(maxWidth: 335)
                        case .success(let image):
                            image
                                .resizable()
                                .aspectRatio(contentMode: .fill)
                                .frame(height: 200)
                                .frame(maxWidth: 335)
                                .clipped()
                        case .failure:
                            Image(systemName: "photo")
                                .resizable()
                                .aspectRatio(contentMode: .fill)
                                .frame(height: 200)
                                .frame(maxWidth: 335)
                                .background(Color.gray)
                        @unknown default:
                            Image(systemName: "photo")
                                .resizable()
                                .aspectRatio(contentMode: .fill)
                                .frame(height: 200)
                                .frame(maxWidth: 335)
                                .background(Color.gray)
                        }
                    }
                } else {
                    Image(systemName: "photo")
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(height: 200)
                        .frame(maxWidth: 335)
                        .background(Color.gray)
                }
                VStack(alignment: .leading, spacing: 8) {
                    Text(house.title)
                        .font(.headline)
                    Text(house.description)
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                }
                .padding()
            }
            .background(Color.white)
            .cornerRadius(20)
            .shadow(radius: 5)
            .padding(.vertical, 8)
        }
        .buttonStyle(PlainButtonStyle())
    }
}
