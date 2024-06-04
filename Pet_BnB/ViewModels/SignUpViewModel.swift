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
    @Published var showSpinner: Bool = false
    @Published var signIn: Bool = false
    @Published var aboutMe: String = ""
    @Published var errorMessage = ""
    
    
    func signUp(name: String, password: String, completion: @escaping(Bool) -> Void)  {
        if signUpAllFieldsComplete(){
            self.showSpinner = true
            firebaseHelper.createAccount(name: name, password: password) {userID, error in
                if let error = error {
                    self.errorMessage = error.localizedDescription
                    print("error creating user")
                    self.accountCreated = false
                    self.showSpinner = false
                    completion(false)
                } else if let userID = userID {
                    self.accountCreated = true
                    self.showSpinner = false
                    completion(true)
                }
                
            }
        }
    }
    
    func signIn(email: String, password: String , completion: @escaping (Bool) -> Void) {
        firebaseHelper.signIn(email: email, password: password){ success, error in
            if let error = error {
                self.errorMessage = error.localizedDescription
                completion(false)
            } else {
                completion(success)
            }
        }
    }
    
    func getUserDetails(userID: String) {
        
    }
    
    func savePersonalInfoToDB() {
        if accountCreated {
            firebaseHelper.savePersonalInfoToDB(firstName: firstName, surName: surName, aboutMe: aboutMe)
        } else {
            print("Dismiss without saving personalData")
        }
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
