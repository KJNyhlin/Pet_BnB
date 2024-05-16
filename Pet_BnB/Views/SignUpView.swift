//
//  SignUpView.swift
//  Pet_BnB
//
//  Created by Jonas Bondesson on 2024-05-15.
//

import SwiftUI

struct SignUpView: View {
    @EnvironmentObject var signUpViewModel :SignUpViewModel
    
    var body: some View {
        ZStack {
            AppColors.mainAccent.edgesIgnoringSafeArea(.top)
//                .ignoresSafeArea()
            VStack(spacing: 0) {
                VStack() {
                    Image("Logo")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 100)
                        .clipShape(Circle())
                        .padding(.top, 50)
                        
                    VStack(spacing: 0) {
                        Text("Welcome!")
                            .foregroundColor(.white)
                            .font(.system(size: 48))
                            .fontWeight(.bold)
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .padding(.horizontal, 40)
                        
                        
                        Text("Join now")
                            .foregroundColor(.white)
                            .font(.system(size: 32))
                            .fontWeight(.bold)
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .padding(.horizontal, 40)
                            
                    }
                    .padding(.bottom, 20)
//                    .border(Color.black)
                }
//                .border(Color.black)
                VStack() {
                    ZStack {
                        Rectangle()
                            .foregroundColor(.white)
                        
                            .clipShape(
                                .rect(
                                    topLeadingRadius: 50,
                                    topTrailingRadius: 50
                                ))
                        
                        VStack(spacing: 0) {
//                            TextFields()
                            if signUpViewModel.accountCreated {
                                EnterPersonalInfo()
                            } else {
                                SignUp()
                            }
                            
                        }
                        .padding(.top, 20)
                        
                    }
                }
//                .border(Color.black)
                
                
                
                
                
            }
            
        }
    }
}

struct SignUp: View {
    @EnvironmentObject var signUpViewModel : SignUpViewModel
    
    var body: some View {
        EntryFields(placeHolder: "Enter email", promt: "", field: $signUpViewModel.email)
        EntryFields(placeHolder: "Enter password", promt: "", field: $signUpViewModel.password, isSecure: true)
        EntryFields(placeHolder: "Confirm password", promt: "", field: $signUpViewModel.confirmPassword, isSecure: true)
        SignUpButtons()
        Spacer()
        Text("Terms & Conditions Apply*")
            .font(.system(size: 12))
    }
}

struct SignUpButtons: View {
    @EnvironmentObject var userViewModel : SignUpViewModel

    var body: some View {
        Button(action: {
            userViewModel.signUp(name: userViewModel.email, password: userViewModel.password)
        }) {
                Text("Sign up")
            
//                                .overlay(
//                                    RoundedRectangle(cornerRadius: 25.0)
//
////                                        .foregroundColor(AppColors.mainAccent)
//                                )
        }
        .padding(.top, 30)
        .disabled(!userViewModel.signUpAllFieldsComplete())
        Button(action: {
            
        }) {
            Text("or sign in here")
                .foregroundColor(.black)
                
        }
        .padding(.top, 20)
    }
}

struct EntryFields : View {
    var placeHolder : String
    var promt: String
    @Binding var field: String
    var isSecure: Bool = false
    var body: some View {
        VStack {
            if isSecure {
                SecureField(placeHolder, text: $field)
                    .textInputAutocapitalization(.never)
                    .frame(width: 250, height: 40)
                    .padding(EdgeInsets(top: 0, leading: 20, bottom: 0, trailing: 0))
                    .overlay(
                        RoundedRectangle(cornerRadius: 25.0)
                            .stroke(AppColors.mainAccent, lineWidth: 3)
                    )
            } else {
                TextField(placeHolder, text: $field)
                    .textInputAutocapitalization(.never)
                    .frame(width: 250, height: 40)
                    .padding(EdgeInsets(top: 0, leading: 20, bottom: 0, trailing: 0))
                    .overlay(
                        RoundedRectangle(cornerRadius: 25.0)
                            .stroke(AppColors.mainAccent, lineWidth: 3)
                    )
            }
            Text(promt)
                .fixedSize(horizontal: false, vertical: true)
                .font(.caption)
                .frame(width: 250, alignment: .leading)
                .foregroundColor(.gray)
        }
    }
}

struct EnterPersonalInfo : View {
    @EnvironmentObject var signUpViewModel : SignUpViewModel
    
    var body: some View {
        EntryFields(placeHolder: "Firstname", promt: "", field: $signUpViewModel.firstName)
        EntryFields(placeHolder: "Surname", promt: "", field: $signUpViewModel.surName)
        Button("Save") {
            signUpViewModel.savePersonalInfoToDB()
        }
    }
}

//struct TextFields : View {
//    @EnvironmentObject var userViewModel : UserViewModel
//
//    
//    var body: some View {
////        Text("Enter email:")
////            .font(.system(size: 16))
////            .frame(width: 300, alignment: .leading)
////            .padding(.leading, 30)
////            
//            
//        TextField("Enter email", text: $userViewModel.email) {
//            
//        }
//        .frame(width: 250, height: 40)
//        .padding(EdgeInsets(top: 0, leading: 20, bottom: 0, trailing: 0))
//        .overlay(
//            RoundedRectangle(cornerRadius: 25.0)
//                .stroke(AppColors.mainAccent, lineWidth: 3)
//        )
//        .padding()
//        
////        Text("Create password")
////            .font(.system(size: 16))
////            .padding(.top, 10)
////            .frame(width: 300, alignment: .leading)
////            .padding(.leading, 30)
//        SecureField("Create password", text: $userViewModel.password) {
//            
//        }
//        
//        .frame(width: 250, height: 40)
//        .padding(EdgeInsets(top: 0, leading: 20, bottom: 0, trailing: 0))
//        .overlay(
//            RoundedRectangle(cornerRadius: 25.0)
//                .stroke(AppColors.mainAccent, lineWidth: 3)
//        )
//        .padding(.bottom)
////        Text("Confim password")
////            .font(.system(size: 16))
////            .padding(.top, 10)
////            .frame(width: 300, alignment: .leading)
////            .padding(.leading, 30)
//        SecureField("Confirm password", text: $userViewModel.confirmPassword) {
//            
//        }
//        
//        .frame(width: 250, height: 40)
//        .padding(EdgeInsets(top: 0, leading: 20, bottom: 0, trailing: 0))
//        .overlay(
//            RoundedRectangle(cornerRadius: 25.0)
//                .stroke(AppColors.mainAccent, lineWidth: 3)
//        )
//        
//    }
//}



#Preview {
    SignUpView()
        .environmentObject(SignUpViewModel())
}
