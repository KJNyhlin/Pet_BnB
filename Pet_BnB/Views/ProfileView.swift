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
    var body: some View {
        Button("Create account") {
            showSheet = true
        }
        .sheet(isPresented: $showSheet, onDismiss: signUpViewModel.savePersonalInfoToDB, content: {
            SignUpView()
        })
    }
        
}

#Preview {
    ProfileView()
        .environmentObject(SignUpViewModel())
}
