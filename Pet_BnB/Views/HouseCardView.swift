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
                SwipableImageView(
                    houseImageURL: house.imageURL,
                    petImageURL: house.pets?.first?.imageURL
                )
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
            .frame(maxWidth: 335)
        }
        .buttonStyle(PlainButtonStyle())
    }
}
