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
    
    @EnvironmentObject var authManager: AuthManager
    @State var messageStackPath = NavigationPath()
    @State var houseStackPath = NavigationPath()
    @State var bookingStackPath = NavigationPath()
    
    var db = Firestore.firestore()
    var body: some View {
        
        VStack {
            TabView {
                
                ExploreView().tabItem { Label(
                    title: { Text("Explore") },
                    icon: { Image(systemName: "magnifyingglass") }
                ) }
                MyBookingsTabView(path: $bookingStackPath)

                MyHouseTabView(path: $houseStackPath)

                ChatListTabView(path: $messageStackPath)

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
        bookingStackPath = NavigationPath()
    }
}


struct MyBookingsTabView: View {
    @Binding var path: NavigationPath
    
    var body: some View {
        NavigationStack(path: $path) {
            MyBookingsView()
                .navigationDestination(for: BookingNavigation.self) { bookingNav in
                    BookingView(house: bookingNav.house, booking: bookingNav.booking)
                }
                .navigationDestination(for: User.self){ user in
                    HouseOwnerProfileView(user: user)
                }
        }
            .tabItem { Label(
            title: { Text("My Bookings") },
            icon: { Image(systemName: "calendar") }
        ) }
        .protected()
    }
}

struct MyHouseTabView: View {
    @Binding var path: NavigationPath
    
    var body: some View {
        NavigationStack(path: $path){
            MyHouseView(path: $path)
                .navigationDestination(for: House.self ){ house in
                    CreateHouseView(vm: CreateHouseViewModel(house: house))
                }
                .navigationDestination(for: String.self ){ _ in
                    CreateHouseView(vm: CreateHouseViewModel(house: nil))
                }
                .navigationDestination(for: User.self){ user in
                    HouseOwnerProfileView(user: user)
                }

        }.tabItem {Label(
            title: { Text("My house") },
            icon: { Image(systemName: "house") }
        ) }
        .protected()

    }
}

struct ChatListTabView: View {
    @Binding var path: NavigationPath
    @EnvironmentObject var chatVM: ChatsListViewModel
    
    var body: some View {
        NavigationStack(path: $path){
            ChatsListView(path: $path)
                .navigationDestination(for: User.self ){ user in
                    HouseOwnerProfileView(user: user)
                }
        }
        .protected()
        .tabItem { Label(
            title: { Text("Messages") },
            icon: { Image(systemName: "bubble") }
        ) }
        .badge(chatVM.unreadCount)
        .environmentObject(chatVM)
    }
}


#Preview {
    ContentView()
        .environmentObject(FirebaseHelper()
            )
}

