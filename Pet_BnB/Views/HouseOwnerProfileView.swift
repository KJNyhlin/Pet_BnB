//
//  HouseOwnerProfileView.swift
//  Pet_BnB
//
//  Created by Maida on 2024-05-27.
//

import SwiftUI

struct HouseOwnerProfileView: View {
    var user: User

    
    var body: some View {
        VStack {
            HStack(spacing: 0) {
                VStack {
                    ZStack {
                        AsyncImageView(imageUrl: user.imageURL, maxWidth: 150, height: 150, isCircle: true)
                            .padding(.leading)

                    }
                    
                    Text("First Name")
                        .font(.caption)
                        .frame(width: 250, alignment: .leading)
                        .padding(.leading, 50)
                    
                    Text(user.firstName ?? "No name")
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
                    
                    Text(user.surName ?? "No surname")
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
                    
                    TextEditor(text: .constant(user.aboutMe ?? "No information available"))
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

        .navigationTitle("Host")
        .navigationBarTitleDisplayMode(.inline)
        .frame(maxWidth: .infinity)
        .padding(.top, -60)
    }
}

#Preview {
    HouseOwnerProfileView(user: User(firstName: "John", surName: "Doe", aboutMe: "Hello, I'm John!"))
}
