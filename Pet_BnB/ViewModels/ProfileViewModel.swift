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
    @Published var editMode: Bool = false
    @Published var editFirstName: String = ""
    @Published var editSurName: String = ""
    
    func getUserDetails() {
        guard let userID = firebaseHelper.getUserID() else {return}
        firebaseHelper.loadUserInfo(userID: userID) {user in
            if let user = user {
                print("\(user.firstName)")
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
    
    func checkIfUserIsLoggedIn()-> Bool {
        if let userID = firebaseHelper.getUserID() {
            return true
        } else {
            return false
        }
    }
    
    func saveUserInfoToDB() {
        guard let userID = firebaseHelper.getUserID() else {return}
        if checkForChanges() {
            firebaseHelper.savePersonalInfoToDB(firstName: self.editFirstName, surName: self.editSurName)
            self.firstName = self.editFirstName
            self.surName = self.editSurName
        }
    }
    
    func checkForChanges()-> Bool {
        print("check: \(self.firstName != self.editFirstName || self.surName != self.editSurName) ")
        return self.firstName != self.editFirstName || self.surName != self.editSurName
    }
}
