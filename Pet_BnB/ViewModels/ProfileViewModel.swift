//
//  ProfileViewModel.swift
//  Pet_BnB
//
//  Created by Jonas Bondesson on 2024-05-17.
//

import Foundation

class ProfileViewModel : ObservableObject{
    
    @Published var user = User()
    var firebaseHelper = FirebaseHelper()
    @Published var firstName: String = ""
    @Published var surName: String = ""
    
    func getUserDetails() {
        guard let userID = firebaseHelper.getUserID() else {return}
        firebaseHelper.loadUserInfo(userID: userID) {user in
            if let user = user {
                print("hello")
                self.firstName = user.firstName ?? ""
                self.surName = user.surName ?? ""
            }
        }
    }
    
    func signOut() {
        firebaseHelper.signOut()
        firstName = ""
        surName = ""
    }
    
}
