//
//  ExploreView.swift
//  Pet_BnB
//
//  Created by Jonas Bondesson on 2024-05-15.
//

import SwiftUI

struct ExploreView: View {
    var body: some View {
        Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
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
        }
        .background(Color.white)
        .cornerRadius(20)
        .shadow(radius: 5)
        .padding(.vertical, 8)
    }
}

#Preview {
    ExploreView()
}
