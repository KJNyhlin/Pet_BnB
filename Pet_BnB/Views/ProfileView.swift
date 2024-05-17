//
//  ProfileView.swift
//  Pet_BnB
//
//  Created by Jonas Bondesson on 2024-05-15.
//

import SwiftUI

struct ProfileView: View {
    @State var showSheet = false
    @EnvironmentObject var signUpViewModel : SignUpViewModel
    @StateObject var profileViewModel = ProfileViewModel()
    
    var body: some View {
        NavigationStack {
            VStack {
                Text("\(profileViewModel.firstName)")
                Text("\(profileViewModel.surName)")
                Button("Create account") {
                    showSheet = true
                }
            }
            
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button(action: {
                        profileViewModel.signOut()
                    }, label: {
                        Image(systemName: "rectangle.portrait.and.arrow.right")
                    })
                }
            }
        }
        
        .sheet(isPresented: $showSheet, onDismiss: signUpViewModel.savePersonalInfoToDB, content: {
            SignUpView()
        })
        .onAppear {
            profileViewModel.getUserDetails()
        }
    }
        
}

#Preview {
    ProfileView()
        .environmentObject(SignUpViewModel())
}
