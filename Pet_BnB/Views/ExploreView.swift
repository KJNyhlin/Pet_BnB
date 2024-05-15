//
//  ExploreView.swift
//  Pet_BnB
//
//  Created by Jonas Bondesson on 2024-05-15.
//

import SwiftUI

struct ExploreView: View {
    @EnvironmentObject var firebaseHelper: FirebaseHelper
    @State private var searchText: String = ""
    
    var filteredHouses: [House] {
        if searchText.isEmpty {
            return firebaseHelper.houses
        } else {
            return firebaseHelper.houses.filter { $0.title.lowercased().contains(searchText.lowercased()) }
        }
    }
        
    var body: some View {
        VStack(spacing: 14) {
            HStack {
                    Image(systemName: "magnifyingglass")
                            .foregroundColor(Color(red: 0.2, green: 0.2, blue: 0.2))
                            .padding(.leading, 16)
                    TextField("Search", text: $searchText)
                            .padding(14)
            }
                    .background(Color(.white))
                    .cornerRadius(40)
                    .padding(.horizontal)
                    .padding(.top)
                    .shadow(radius: 5)
                
            ScrollView {
                        VStack(spacing: 10) {
                            ForEach(filteredHouses) { house in
                                HouseCardView(house: house)
                            }
                        }
                        .padding(.horizontal)
            }
        }
        .onAppear {
                firebaseHelper.fetchHouses()
        }
    }
}

struct HouseCardView: View {
    var house: House
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            if let imageURL = house.imageURL, let url = URL(string: imageURL) {
                AsyncImage(url: url) { phase in
                    switch phase {
                    case .empty:
                        ProgressView()
                            .frame(height: 200)
                            .frame(maxWidth: .infinity)
                    case .success(let image):
                        image
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(height: 200)
                            .frame(maxWidth: .infinity)
                            .clipped()
                    case .failure:
                        Image(systemName: "photo")
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(height: 200)
                            .frame(maxWidth: .infinity)
                            .background(Color.gray)
                    @unknown default:
                        Image(systemName: "photo")
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(height: 200)
                            .frame(maxWidth: .infinity)
                            .background(Color.gray)
                    }
                }
            } else {
                Image(systemName: "photo")
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(height: 200)
                    .frame(maxWidth: .infinity)
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
}

#Preview {
    ExploreView().environmentObject(FirebaseHelper())
}
