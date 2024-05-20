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
        NavigationView {
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
                                HouseCardView(house: house)                                .environmentObject(firebaseHelper)
                            }
                        }
                        .padding(.horizontal)
            }
        }
        .onAppear {
                firebaseHelper.fetchHouses()
        }
        .navigationBarHidden(true)
        }
    }
}


#Preview {
    ExploreView().environmentObject(FirebaseHelper())
}
