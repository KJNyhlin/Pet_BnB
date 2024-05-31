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
    @EnvironmentObject var chatVM: ChatsListViewModel
    @EnvironmentObject var authManager: AuthManager
    @State var navigationPath = NavigationPath()

    
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
                NavigationStack(path: $navigationPath){
                    ChatsListView(path: $navigationPath)
                }
                .tabItem { Label(
                    title: { Text("Messages") },
                    icon: { Image(systemName: "bubble") }
                ) }
                .badge(chatVM.unreadCount)
                .environmentObject(chatVM)
                
               
                ProfileView().tabItem { Label(
                    title: { Text("Profile") },
                    icon: { Image(systemName: "person.crop.circle") }
                ) }
                //.environmentObject(chatVM)
            }
            .tint(AppColors.mainAccent)
            
        }
        .onChange(of: navigationPath){
            print(navigationPath)
        }
        .onChange(of: authManager.loggedIn){ oldState, newState in
            print("Loggin changed!!!!!")
            if !newState{
                print(navigationPath)
                resetNavigationStacks()
               print(navigationPath)
            }
            print(authManager.loggedIn)
            
        }
        //.padding()
    }
    func resetNavigationStacks(){
        navigationPath = NavigationPath()
    }
}

#Preview {
    ContentView()
        .environmentObject(FirebaseHelper()
            )
}
