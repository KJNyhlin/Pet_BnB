//
//  AuthManager.swift
//  Pet_BnB
//
//  Created by Kristian Thun on 2024-05-29.
//

import Foundation
import Firebase
import FirebaseAuth
import FirebaseFirestore
import FirebaseStorage
import FirebaseFirestoreSwift
import SwiftUI

class AuthManager: ObservableObject {
    static let sharedAuth = AuthManager()
    let auth = Auth.auth()
    @Published var loggedIn: Bool
    
    private init(){
        if (auth.currentUser?.uid) != nil{
            loggedIn = true
        } else {
            loggedIn = false
        }
    }
    
    func set(loggedIn: Bool){
        
        self.loggedIn = loggedIn
        print(self.loggedIn)
    }
    
}

struct ProtectedViewModifier: ViewModifier {
    @EnvironmentObject var authManager: AuthManager

    func body(content: Content) -> some View {
        content
            .overlay(
                Group {
                    if !authManager.loggedIn {
                        SignUpView()
                    }
                }
                
            )
    }
        
}

extension View {
    func protected() -> some View {
        self.modifier(ProtectedViewModifier())
    }
}
