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
            NavigationLink(value: house.id ?? ""){
            VStack(alignment: .leading, spacing: 0) {
                SwipableImageView(
                    houseImageURL: house.imageURL,
                    petImageURL: house.pets?.first?.imageURL
                )
                VStack(alignment: .leading, spacing: 8) {
                    Text(house.title)
                        .font(.headline)
                    HStack {
                        Image(systemName: "star.fill")
                            .foregroundColor(AppColors.mainAccent)
                            .font(.system(size: 12))
                        if let rating = house.getAverageRating() {
                            Text("\(rating, specifier: "%.1f")")
                                .foregroundColor(AppColors.mainAccent)
                                .font(.system(size: 12))
                        } else {
                            Text("No ratings yet")
                                .foregroundColor(AppColors.mainAccent)
                                .font(.system(size: 12))
                        }
                    }
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
                    }
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                                        
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

    }
}
