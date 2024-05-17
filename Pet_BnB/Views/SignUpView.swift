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
                            if signUpViewModel.accountCreated {
                                EnterPersonalInfo()
                                    .transition(.slide)
                            } else if signUpViewModel.showSpinner {
                                ShowSpinner()
                                    .transition(.slide)
                            } else if signUpViewModel.signIn  {
                                SignIn()
                                    .transition(.scale)
                            } else {
                                SignUp()
                                    .transition(.scale)
//                                EnterPersonalInfo()
                            }
                            
                        }
                        .padding(.top, 20)
                        
                    }
                }
            }
            .onAppear {
                signUpViewModel.signIn = false
            }
        }
    }
}

struct ShowSpinner: View {
    var body: some View {
        ProgressView()
            .progressViewStyle(.circular)
            .scaleEffect(2.0, anchor: .center)
            .onAppear {
                DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
                          
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
    @EnvironmentObject var signUpViewModel : SignUpViewModel

    var body: some View {
        Button(action: { withAnimation() {
            signUpViewModel.signUp(name: signUpViewModel.email, password: signUpViewModel.password)
        }
        }, label: {
          FilledButtonLabel(text: "Sign up")
                .frame(width: 100)
        })
        .padding(.top, 30)
        .disabled(!signUpViewModel.signUpAllFieldsComplete())
        Button(action: { withAnimation() {
            signUpViewModel.signIn = true
        }
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
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        VStack {
            Text("Please enter your personal information")
                .font(.system(size: 24))
            EntryFields(placeHolder: "Firstname", promt: "", field: $signUpViewModel.firstName)
            EntryFields(placeHolder: "Surname", promt: "", field: $signUpViewModel.surName)
            Button(action: {
                signUpViewModel.savePersonalInfoToDB()
                dismiss()
            }, label: {
                FilledButtonLabel(text: "Save")
                    .frame(width: 100)
            })
            Button(action: {
                signUpViewModel.firstName = ""
                signUpViewModel.surName = ""
                signUpViewModel.savePersonalInfoToDB()
                dismiss()
                    
            }, label: {
              FilledButtonLabel(text: "Skip")
                    .frame(width: 100)
            })
        }
    }
}

struct SignIn : View {
    @EnvironmentObject var signInViewModel : SignUpViewModel
    var body: some View {
        
            VStack {
                Button(action: { withAnimation() {
                    signInViewModel.signIn = false
                }}, label: {
                    Image(systemName: "chevron.backward")
                })
                .fontWeight(.bold)
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.leading, 40)
                .padding(.top, 10)
                Text("Sign In")
                    .font(.title)
                
                EntryFields(placeHolder: "Email", promt: "", field: $signInViewModel.email)
                EntryFields(placeHolder: "Password", promt: "", field: $signInViewModel.password, isSecure: true)
                Button(action: {
                    signInViewModel.signIn(email: signInViewModel.email, password: signInViewModel.password)
                }, label: {
                    FilledButtonLabel(text: "Sign In")
                        .frame(width: 100)
                })
                Spacer()
            }
            .onAppear {
                signInViewModel.email = ""
                signInViewModel.password = ""
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
