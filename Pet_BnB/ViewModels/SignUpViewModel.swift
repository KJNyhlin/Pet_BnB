//
//  UserViewModel.swift
//  Pet_BnB
//
//  Created by Jonas Bondesson on 2024-05-15.
//

import Foundation

class SignUpViewModel: ObservableObject {
    @Published var user: User = User()
    var firebaseHelper = FirebaseHelper()
    
    @Published var email: String = ""
    @Published var password: String = ""
    @Published var confirmPassword: String = ""
    
    @Published var firstName: String = ""
    @Published var surName: String = ""
    @Published var accountCreated: Bool = false
    
    
    func signUp(name: String, password: String) {
        if signUpAllFieldsComplete(){
            firebaseHelper.createAccount(name: name, password: password) {userID in
                if let userID = userID {
                    print("User created")
                    self.accountCreated = true
                } else {
                    print("error creating user")
                    self.accountCreated = false
                }
                
            }
        }
    }
    
    func savePersonalInfoToDB() {
        firebaseHelper.savePersonalInfoToDB(firstName: firstName, surName: surName)
    }
    
    func passwordMatch() -> Bool {
        password == confirmPassword
    }
    
    func emailFormat() -> Bool {
        let emailTest = NSPredicate(format: "SELF MATCHES %@",
                                    "^([a-zA-Z0-9_\\-\\.]+)@((\\[[0-9]{1,3}\\.[0-9]{1,3}\\.[0-9]{1,3}\\.)|(([a-zA-Z0-9\\-]+\\.)+))([a-zA-Z]{2,4}|[0-9]{1,3})(\\]?)$")
        return emailTest.evaluate(with: email)
    }
    
    func signUpAllFieldsComplete() -> Bool {
        if !passwordMatch() || !emailFormat() || password.isEmpty {
            return false
        } else {
            return true
        }
    }
    
//    func enterPersonalInfoComplete() -> Bool {
//        return firstName.isEmpty || surName.isEmpty
//    }
    
}
