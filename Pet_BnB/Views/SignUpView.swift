//
//  SignUpView.swift
//  Pet_BnB
//
//  Created by Jonas Bondesson on 2024-05-15.
//

import SwiftUI

struct SignUpView: View {
    
    @State var email : String = ""
    @State var password : String = ""
    
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
                    .border(Color.black)
                }
                .border(Color.black)
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
                            TextFields(email: $email, password: $password)
                                
                                
                            SignUpButtons(email: $email, password: $password)
                            Spacer()
                            Text("Terms & Conditions Apply*")
                                .font(.system(size: 12))
                            
                            
                        }
                        .padding(.top, 20)
                        
                    }
                }
                .border(Color.black)
                
                
                
                
                
            }
            
        }
    }
}
struct SignUpButtons: View {
    @EnvironmentObject var userViewModel : UserViewModel
    @Binding var email: String
    @Binding var password: String
    var body: some View {
        Button(action: {
            if email.isEmpty && password.isEmpty {
                return
            } else {
                userViewModel.signUp(name: email, password: password)
            }
        }) {
                Text("Sign up")
            
//                                .overlay(
//                                    RoundedRectangle(cornerRadius: 25.0)
//
////                                        .foregroundColor(AppColors.mainAccent)
//                                )
        }
        .padding(.top, 30)
        Button(action: {
            
        }) {
            Text("or sign in here")
                .foregroundColor(.black)
                
        }
        .padding(.top, 20)
    }
}

struct TextFields : View {
    @Binding var email: String
    @Binding var password: String
    
    var body: some View {
        Text("Enter email:")
            .font(.system(size: 16))
            .frame(width: 300, alignment: .leading)
            .padding(.leading, 30)
            
        TextField(text: $email) {
            
        }
        .frame(width: 300, height: 40)
        .overlay(
            RoundedRectangle(cornerRadius: 25.0)
                .stroke(AppColors.mainAccent, lineWidth: 3)
        )
        Text("Create password")
            .font(.system(size: 16))
            .padding(.top, 10)
            .frame(width: 300, alignment: .leading)
            .padding(.leading, 30)
        TextField(text: $password) {
            
        }
        .frame(width: 300, height: 40)
        .overlay(
            RoundedRectangle(cornerRadius: 25.0)
                .stroke(AppColors.mainAccent, lineWidth: 3)
        )
    }
}

#Preview {
    SignUpView()
}
