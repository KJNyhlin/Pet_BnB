//
//  Pet_BnBApp.swift
//  Pet_BnB
//
//  Created by Kristian Thun on 2024-05-14.
//

import SwiftUI
import FirebaseCore

class AppDelegate: NSObject, UIApplicationDelegate {
  func application(_ application: UIApplication,
                   didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
    FirebaseApp.configure()

    return true
  }
}

@main
struct Pet_BnBApp: App {
    
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    @StateObject var firebaseHelper = FirebaseHelper()
    @StateObject var signUpViewModel = SignUpViewModel()
    @StateObject var profileViewModel = ProfileViewModel()
    @StateObject var authManager = AuthManager.sharedAuth
    @StateObject var chatListViewModel = ChatsListViewModel()
   // @StateObject var navigationPath = NavigationPath()
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(firebaseHelper)
                .environmentObject(signUpViewModel)
                .environmentObject(profileViewModel)
                .environmentObject(authManager)
                .environmentObject(chatListViewModel)
        }
    }
}
