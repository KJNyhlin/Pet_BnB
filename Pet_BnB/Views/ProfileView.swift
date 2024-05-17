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
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        NavigationStack {
            VStack {
                personalInfoView()
//                    .border(Color.black)
                    Spacer()
                    
                Button("Create account") {
                    showSheet = true
                }
                .opacity(profileViewModel.checkIfUserIsLoggedIn() ? 0.0 : 1.0)
//                .disabled(profileViewModel.checkIfUserIsLoggedIn())
                Spacer()
            }
            
            .toolbar {
                if profileViewModel.checkIfUserIsLoggedIn() {
                    ToolbarItem(placement: .topBarTrailing) {
                        Button(action: {
                            profileViewModel.editMode.toggle()
                        }, label: {
                            Image(systemName: "pencil")
                        })
                    }
                }
                ToolbarItem(placement: .topBarTrailing) {
                    Button(action: {
                        profileViewModel.signOut()
                    }, label: {
                        Image(systemName: "rectangle.portrait.and.arrow.right")
                    })
                }
            }
        }
        
//        .sheet(isPresented: $showSheet, onDismiss: {
//            signUpViewModel.savePersonalInfoToDB
//            profileViewModel.getUserDetails()
//        }, content: {
//            SignUpView()
//        })
        .sheet(isPresented: $showSheet, onDismiss: {
            signUpViewModel.savePersonalInfoToDB()
            profileViewModel.getUserDetails()
//            if profileViewModel.checkForChanges() {
//                profileViewModel.getUserDetails()
//            }
        }, content: {
            SignUpView()
            
        })
        .sheet(isPresented: $profileViewModel.editMode, onDismiss: {
//            if profileViewModel.checkForChanges() {
//                profileViewModel.getUserDetails()
//            }
        }, content: {
            editPersonalInfo()
            
        })
        .onAppear {
            profileViewModel.getUserDetails()
        }
    }
        
}

struct editPersonalInfo: View {
    @EnvironmentObject var profileViewModel : ProfileViewModel
    var body: some View {
        VStack {
            HStack(spacing: 0) {
                VStack {
                    Image("Logo")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 150, height: 150)
                    
                        .padding(.leading, 20)
                    Text("First Name:")
                        .font(.caption)
                        .frame(width: 250, alignment: .leading)
                        .padding(.leading, 50)
                    
                    TextField("First Name", text: $profileViewModel.editFirstName)
                        .padding(EdgeInsets(top: 0, leading: 20, bottom: 0, trailing: 0))
                        .frame(width: 200, height: 40, alignment: .leading)
                        .overlay(
                            RoundedRectangle(cornerRadius: 25.0)
                                .stroke(AppColors.mainAccent, lineWidth: 3)
                        )
                    
                    
                    Text("Surname:")
                        .font(.caption)
                        .frame(width: 250, alignment: .leading)
                        .padding(.leading, 50)
                        .padding(.top, 2)
                    
                    TextField("First Name", text: $profileViewModel.editSurName)
                        .padding(EdgeInsets(top: 0, leading: 20, bottom: 0, trailing: 0))
                        .frame(width: 200, height: 40, alignment: .leading)
                        .overlay(
                            RoundedRectangle(cornerRadius: 25.0)
                                .stroke(AppColors.mainAccent, lineWidth: 3)
                        )
                    
                }
                .frame(maxWidth: .infinity)
                
                
            }
        }
        .frame(maxWidth: .infinity)
        .frame(height: 300)
        //        .border(Color.black)
        HStack {
            Button(action: {
                profileViewModel.saveUserInfoToDB()
                
                profileViewModel.editMode.toggle()
                
            }, label: {
                FilledButtonLabel(text: "Save")
                    .frame(width: 100)
            })
            Button(action: {
                
                profileViewModel.editMode.toggle()
                
            }, label: {
                FilledButtonLabel(text: "Cancel")
                    .frame(width: 100)
            })
        }
        .onAppear {
            profileViewModel.editFirstName = profileViewModel.firstName
            profileViewModel.editSurName = profileViewModel.surName
        }
    }
}

struct personalInfoView : View {
    @EnvironmentObject var profileViewModel : ProfileViewModel
    
    var body: some View {
        VStack {
            HStack(spacing: 0) {
                VStack {
                    Image("Logo")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 150, height: 150)
                    
                        .padding(.leading, 20)
                    Text("First Name:")
                        .font(.caption)
                        .frame(width: 250, alignment: .leading)
                        .padding(.leading, 50)
                    
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
                        .padding(.leading, 50)
                        .padding(.top, 2)
                    
                    Text("\(profileViewModel.surName)")
                        .padding(EdgeInsets(top: 0, leading: 20, bottom: 0, trailing: 0))
                        .frame(width: 200, height: 40, alignment: .leading)
                        .overlay(
                            RoundedRectangle(cornerRadius: 25.0)
                                .stroke(AppColors.mainAccent, lineWidth: 3)
                        )
                    
                }
                .frame(maxWidth: .infinity)
                
                
            }
        }
        .frame(maxWidth: .infinity)
        .frame(height: 300)
        //        .border(Color.black)
        
    }
}

#Preview {
    ProfileView()
        .environmentObject(SignUpViewModel())
        .environmentObject(ProfileViewModel())
}
