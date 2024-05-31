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
                        if let image = user.imageURL {
                            AsyncImage(url: URL(string: image)) { phase in
                                let size: CGFloat = 150
                                switch phase {
                                case .empty:
                                    ProgressView()
                                        .frame(height: size)
                                        .frame(maxWidth: size)
                                case .success(let image):
                                    image
                                        .resizable()
                                        .aspectRatio(contentMode: .fill)
                                        .frame(height: size)
                                        .frame(maxWidth: size)
                                        .clipShape(Circle())
                                        .overlay(
                                            Circle()
                                                .stroke(AppColors.mainAccent, lineWidth: 2)
                                        )
                                case .failure:
                                    Image(systemName: "person.circle")
                                        .resizable()
                                        .aspectRatio(contentMode: .fill)
                                        .frame(height: size)
                                        .frame(maxWidth: size)
                                        .background(Color.gray)
                                        .clipShape(Circle())
                                        .overlay(
                                            Circle()
                                                .stroke(AppColors.mainAccent, lineWidth: 2)
                                        )
                                @unknown default:
                                    Image(systemName: "person.circle")
                                        .resizable()
                                        .aspectRatio(contentMode: .fill)
                                        .frame(height: size)
                                        .frame(maxWidth: size)
                                        .background(Color.gray)
                                        .clipShape(Circle())
                                        .overlay(
                                            Circle()
                                                .stroke(AppColors.mainAccent, lineWidth: 2)
                                        )
                                }
                            }
                            .padding(.leading)
                        }
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
