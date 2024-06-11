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
    @State private var showFilter: Bool = false
    @State private var minBeds: Int = 1
    @State private var maxBeds: Int = 150
    @State private var minSize: Int = 10
    @State private var maxSize: Int = 1000
    @State private var selectedAnimalType: String = "All"
    @State var path = NavigationPath()
    
    let animalTypes = ["All", "Bird", "Cat", "Dog", "Fish", "Rabbit", "Reptile", "Other"]
    
    var isFilterActive: Bool {
        return minBeds > 1 || maxBeds < 150 || minSize > 10 || maxSize < 1000 || selectedAnimalType != "All"
    }
    
    var filteredHouses: [House] {
        firebaseHelper.houses.filter { house in
            let matchesSearchText = searchText.isEmpty ||
            house.title.lowercased().contains(searchText.lowercased()) ||
            house.city.lowercased().contains(searchText.lowercased()) ||
            house.description.lowercased().contains(searchText.lowercased()) ||
            house.pets?.contains { $0.species.lowercased().contains(searchText.lowercased()) } ?? false
            let matchesBeds = house.beds >= minBeds && house.beds <= maxBeds
            let matchesSize = house.size >= minSize && house.size <= maxSize
            let matchesAnimalType = selectedAnimalType == "All" || (house.pets?.contains { $0.species.lowercased() == selectedAnimalType.lowercased() } ?? false)
            return matchesSearchText && matchesBeds && matchesSize && matchesAnimalType
        }
    }
    
    var body: some View {
        NavigationStack(path: $path) {
            VStack(spacing: 14) {
                HStack {
                    Image(systemName: "magnifyingglass")
                        .foregroundColor(Color(red: 0.2, green: 0.2, blue: 0.2))
                        .padding(.leading, 16)
                    TextField("Search city or keyword", text: $searchText)
                        .padding(14)
                    
                    Button(action: {
                        showFilter.toggle()
                    }) {
                        Image(systemName: "slider.horizontal.3")
                            .foregroundColor(isFilterActive ? Color(red: 248/256, green: 187/256, blue: 1/256) : Color(red: 0.2, green: 0.2, blue: 0.2))
                            .padding(.trailing, 16)
                    }
                    .sheet(isPresented: $showFilter) {
                        FilterView(isPresented: $showFilter, minBeds: $minBeds, maxBeds: $maxBeds, minSize: $minSize, maxSize: $maxSize, selectedAnimalType: $selectedAnimalType, animalTypes: animalTypes)
                    }
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
                                .environmentObject(firebaseHelper)
                        }
                    }
                    .padding(.horizontal)
                }
                .navigationDestination(for: User.self ){ user in
                    HouseOwnerProfileView(user: user)
                }
                .navigationDestination(for: String.self){ houseID in
                    HouseDetailView(houseId: houseID, firebaseHelper: firebaseHelper, booked: false, showMyOwnHouse: false)
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
