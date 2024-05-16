//
//  UserViewModel.swift
//  Pet_BnB
//
//  Created by Jonas Bondesson on 2024-05-15.
//

import Foundation

class UserViewModel: ObservableObject {
    @Published var user: User = User()
    var firebaseHelper = FirebaseHelper()
    
    
    func signUp(name: String, password: String) {
        firebaseHelper.createAccount(name: name, password: password) {userID in
            if let userID = userID {
                print("User created")
            } else {
                print("error creating user")
            }
            
        }
    }
    
    
    
}
