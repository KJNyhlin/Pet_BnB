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
    @State var messageStackPath = NavigationPath()
    @State var houseStackPath = NavigationPath()

    
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
                .protected()
                
                NavigationStack(path: $houseStackPath){
                    MyHouseView(path: $houseStackPath)
                        .navigationDestination(for: House.self ){ house in
                            CreateHouseView(vm: CreateHouseViewModel(house: house))
                        }
                        .navigationDestination(for: String.self ){ _ in
                            CreateHouseView(vm: CreateHouseViewModel(house: nil))
                        }

                }
                
                .tabItem {Label(
                    title: { Text("My house") },
                    icon: { Image(systemName: "house") }
                ) }
                
                
                NavigationStack(path: $messageStackPath){
                    ChatsListView(path: $messageStackPath)
                        .navigationDestination(for: User.self ){ user in
                            HouseOwnerProfileView(user: user)
                        }
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
                .protected()
                //.environmentObject(chatVM)
            }
            .tint(AppColors.mainAccent)
            
        }
        .onChange(of: messageStackPath){
            print(messageStackPath)
        }
        .onChange(of: authManager.loggedIn){ oldState, newState in
            print("Loggin changed!!!!!")
            if !newState{
                print(messageStackPath)
                resetNavigationStacks()
               print(messageStackPath)
            }
            print(authManager.loggedIn)
            
        }
        //.padding()
    }
    func resetNavigationStacks(){
        messageStackPath = NavigationPath()
        houseStackPath = NavigationPath()
    }
}

#Preview {
    ContentView()
        .environmentObject(FirebaseHelper()
            )
}
