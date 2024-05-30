//
//  ContentView.swift
//  Pet_BnB
//
//  Created by Kristian Thun on 2024-05-14.
//

import SwiftUI
import FirebaseCore
import FirebaseFirestore

struct ContentView: View {
    @StateObject var chatVM = ChatsListViewModel()
    
    var db = Firestore.firestore()
    var body: some View {
        
        VStack {
            TabView {
                ExploreView().tabItem { Label(
                    title: { Text("Explore") },
                    icon: { Image(systemName: "magnifyingglass") }
                ) }
                MyBookingsView().tabItem { Label(
                    title: { Text("My Bookings") },
                    icon: { Image(systemName: "calendar") }
                ) }
                MyHouseView().tabItem {Label(
                    title: { Text("My house") },
                    icon: { Image(systemName: "house") }
                ) }
                ChatsListView().tabItem { Label(
                    title: { Text("Messages") },
                    icon: { Image(systemName: "bubble") }
                ) }
                .badge(chatVM.unreadCount)
                .environmentObject(chatVM)
                
               
                ProfileView().tabItem { Label(
                    title: { Text("Profile") },
                    icon: { Image(systemName: "person.crop.circle") }
                ) }
                .environmentObject(chatVM)
            }
            .tint(AppColors.mainAccent)
            
        }
        //.padding()
    }
}

#Preview {
    ContentView()
        .environmentObject(FirebaseHelper()
            )
}
