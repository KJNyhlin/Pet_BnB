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
    @EnvironmentObject var profileViewModel : ProfileViewModel
    
    var body: some View {
        NavigationStack {
            VStack {
                personalInfoView()
                    
                    
                Button("Create account") {
                    showSheet = true
                }
                Spacer()
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

struct personalInfoView : View {
    @EnvironmentObject var profileViewModel : ProfileViewModel
    var body: some View {
        VStack {
            HStack(spacing: 0) {
                Image(systemName: "person.circle")
                    .frame(width: 150, height: 150)
                    .scaledToFill()
                    .padding(.leading, 20)
                    
                    .offset(y: -20)
                    
                VStack {
                    
                    Text("First Name:")
                        .font(.caption)
                        .frame(width: 250, alignment: .leading)
                        .padding(.leading, 20)
                    
                    Text("\(profileViewModel.firstName)")
                        .padding(EdgeInsets(top: 0, leading: 20, bottom: 0, trailing: 0))
                        .frame(width: 200, height: 40, alignment: .leading)
                        .overlay(
                            RoundedRectangle(cornerRadius: 25.0)
                                .stroke(AppColors.mainAccent, lineWidth: 3)
                        )
                    
                    
                    Text("Surname:")
                        .font(.caption)
                        .frame(width: 250, alignment: .leading)
                        .padding(.leading, 20)
                        .padding(.top, 2)
                    
                    Text("\(profileViewModel.surName)")
                        .padding(EdgeInsets(top: 0, leading: 20, bottom: 0, trailing: 0))
                        .frame(width: 200, height: 40, alignment: .leading)
                        .overlay(
                            RoundedRectangle(cornerRadius: 25.0)
                                .stroke(AppColors.mainAccent, lineWidth: 3)
                        )
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                
                
            }
        }
        .frame(maxWidth: .infinity)
        .frame(height: 250)
        
    }
}

#Preview {
    ProfileView()
        .environmentObject(SignUpViewModel())
}
