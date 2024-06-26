//
//  ProfileView.swift
//  Pet_BnB
//
//  Created by Jonas Bondesson on 2024-05-15.
//

import SwiftUI
import PhotosUI

struct ProfileView: View {
    @State var showSheet = false
    @EnvironmentObject var signUpViewModel: SignUpViewModel
    @EnvironmentObject var profileViewModel: ProfileViewModel
    @EnvironmentObject var chatListViewModel: ChatsListViewModel
    @Environment(\.dismiss) var dismiss
    @EnvironmentObject var authManager: AuthManager
    
    var body: some View {
        NavigationStack {
            VStack {
                personalInfoView()
                Spacer()
                
                Button("Create account") {
                    showSheet = true
                }
                .opacity(profileViewModel.checkIfUserIsLoggedIn() ? 0.0 : 1.0)
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
                        chatListViewModel.removeListener()
                        
                    }, label: {
                        Image(systemName: "rectangle.portrait.and.arrow.right")
                    })
                }
            }
        }
        .sheet(isPresented: $showSheet, onDismiss: {
            signUpViewModel.savePersonalInfoToDB()
            profileViewModel.getUserDetails()
        }, content: {
            SignUpView()
        })
        .sheet(isPresented: $profileViewModel.editMode, onDismiss: {
            profileViewModel.getUserDetails()
        }, content: {
            editPersonalInfo()
        })
        .onAppear {
            profileViewModel.getUserDetails()
            
        }
        .onChange(of: authManager.loggedIn){ oldVlaue, newValue in
            if newValue {
                profileViewModel.getUserDetails()
                
                
            }
        }
        
    }
}

struct editPersonalInfo: View {
    @EnvironmentObject var profileViewModel: ProfileViewModel
    
    var body: some View {
        VStack {
            HStack(spacing: 0) {
                VStack {
                    ZStack {
                        if let image = profileViewModel.image {
                            Image(uiImage: image)
                                .resizable()
                                .aspectRatio(contentMode: .fill)
                                .frame(width: 150, height: 150)
                                .clipShape(Circle())
                                .clipped()
                        } else {
                            Image(systemName: "person.crop.circle.fill.badge.plus")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 150, height: 150)
                        }
                        Circle()
                            .stroke(AppColors.mainAccent, lineWidth: 2)
                            .frame(width: 150, height: 150)
                    }
                    .padding(.leading)
                    .onTapGesture {
                        profileViewModel.showImagePicker = true
                    }
                    
                    Text("First Name")
                        .font(.caption)
                        .frame(width: 250, alignment: .leading)
                        .padding(.leading, 50)
                    
                    TextField("First Name", text: $profileViewModel.editFirstName)
                        .padding(EdgeInsets(top: 0, leading: 15, bottom: 0, trailing: 0))
                        .frame(width: 200, height: 40, alignment: .leading)
                        .overlay(
                            RoundedRectangle(cornerRadius: 25.0)
                                .stroke(AppColors.mainAccent, lineWidth: 2)
                        )
                    
                    Text("Surname")
                        .font(.caption)
                        .frame(width: 250, alignment: .leading)
                        .padding(.leading, 50)
                        .padding(.top, 2)
                    
                    TextField("Surname", text: $profileViewModel.editSurName)
                        .padding(EdgeInsets(top: 0, leading: 15, bottom: 0, trailing: 0))
                        .frame(width: 200, height: 40, alignment: .leading)
                        .overlay(
                            RoundedRectangle(cornerRadius: 25.0)
                                .stroke(AppColors.mainAccent, lineWidth: 2)
                        )
                    Text("About Me")
                        .font(.caption)
                        .frame(width: 250, alignment: .leading)
                        .padding(.leading, -50)
                        .padding(.top, 2)
                    
                    TextEditor(text: $profileViewModel.editAboutMe)
                        .padding(EdgeInsets(top: 0, leading: 10, bottom: 0, trailing: 0))
                        .frame(width: 300, height: 160, alignment: .leading)
                        .overlay(
                            RoundedRectangle(cornerRadius: 25.0)
                                .stroke(AppColors.mainAccent, lineWidth: 2)
                        )
                }
                .frame(maxWidth: .infinity)
            }
        }
        .frame(maxWidth: .infinity)
        .frame(height: 600)
        
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
            profileViewModel.editAboutMe = profileViewModel.aboutMe
        }
        .photosPicker(isPresented: $profileViewModel.showImagePicker, selection: $profileViewModel.imageSelection, matching: .images, photoLibrary: .shared())
    }
}



struct personalInfoView: View {
    @EnvironmentObject var profileViewModel: ProfileViewModel
    
    var body: some View {
        VStack {
            HStack(spacing: 0) {
                VStack {
                    ZStack {
                        if let image = profileViewModel.image {
                            Image(uiImage: image)
                                .resizable()
                                .aspectRatio(contentMode: .fill)
                                .frame(width: 150, height: 150)
                                .clipShape(Circle())
                                .clipped()
                        } else {
                            Image("Logo")
                                .resizable()
                                .aspectRatio(contentMode: .fill)
                                .frame(width: 150, height: 150)
                                .clipShape(Circle())
                                .clipped()
                        }
                        Circle()
                            .stroke(AppColors.mainAccent, lineWidth: 3)
                            .frame(width: 150, height: 150)
                    }
                    .padding(.leading)
                    
                    Text("First Name")
                        .font(.caption)
                        .frame(width: 250, alignment: .leading)
                        .padding(.leading, 50)
                    
                    Text("\(profileViewModel.firstName)")
                        .padding(EdgeInsets(top: 0, leading: 15, bottom: 0, trailing: 0))
                        .frame(width: 200, height: 40, alignment: .leading)
                        .overlay(
                            RoundedRectangle(cornerRadius: 25.0)
                                .stroke(AppColors.mainAccent, lineWidth: 3)
                        )
                    
                    Text("Surname")
                        .font(.caption)
                        .frame(width: 250, alignment: .leading)
                        .padding(.leading, 50)
                        .padding(.top, 2)
                    
                    Text("\(profileViewModel.surName)")
                        .padding(EdgeInsets(top: 0, leading: 15, bottom: 0, trailing: 0))
                        .frame(width: 200, height: 40, alignment: .leading)
                        .overlay(
                            RoundedRectangle(cornerRadius: 25.0)
                                .stroke(AppColors.mainAccent, lineWidth: 3)
                        )
                    Text("About Me")
                        .font(.caption)
                        .frame(width: 250, alignment: .leading)
                        .padding(.leading, -50)
                        .padding(.top, 2)
                    
                    TextEditor(text: .constant(profileViewModel.aboutMe))
                        .padding(EdgeInsets(top: 0, leading: 10, bottom: 0, trailing: 0))
                        .frame(width: 300, height: 160, alignment: .leading)
                        .overlay(
                            RoundedRectangle(cornerRadius: 25.0)
                                .stroke(AppColors.mainAccent, lineWidth: 3)
                        )
                }
                .frame(maxWidth: .infinity)
            }
        }
        .frame(maxWidth: .infinity)
        .frame(height: 610)
    }
}

#Preview {
    ProfileView()
        .environmentObject(SignUpViewModel())
        .environmentObject(ProfileViewModel())
}
