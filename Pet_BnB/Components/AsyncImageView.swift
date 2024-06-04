//
//  AsyncImageView.swift
//  Pet_BnB
//
//  Created by Kristian Thun on 2024-05-18.
//

import SwiftUI
struct AsyncImageView: View {
    let imageUrl: String?
    let maxWidth: CGFloat
    let height: CGFloat
    let isCircle: Bool
    let isAnimal: Bool
    
    init(imageUrl: String?, maxWidth: CGFloat = .infinity, height: CGFloat = .infinity, isCircle: Bool = false, isAnimal: Bool = false) {
        self.imageUrl = imageUrl
        self.maxWidth = maxWidth
        self.height = height
        self.isCircle = isCircle
        self.isAnimal = isAnimal
    }
    
    var body: some View {
       
        if let imageUrl = imageUrl {
            AsyncImage(url: URL(string: imageUrl)) { phase in
                switch phase {
                case .empty:
                    ProgressView()
                        .frame(height: height)
                        .frame(maxWidth: maxWidth)
                    
                case .success(let image):

                    if isCircle {
                        image
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .clipShape(Circle())
                            //.frame(height: height)
                            .frame(width: maxWidth, height: height)
                            .overlay(
                                Circle()
                                    .stroke(AppColors.mainAccent, lineWidth: 1)
                            )
                    } else {
                        image
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(width: maxWidth, height: height)
                    }

      
                case .failure:
                    Image(systemName: "photo")
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(height: height)
                        .frame(maxWidth: maxWidth)
                        .background(Color.gray)
                @unknown default:
                    Image(systemName: "photo")
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(height: height)
                        .frame(maxWidth: maxWidth)
                        .background(Color.gray)
                }
            }
        } else {
            if isCircle{
                Image(systemName: isAnimal ? "pawprint.circle" : "person.circle")
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .clipShape(Circle())
                    .frame(height: height)
                    .frame(maxWidth: maxWidth)
//                    .background(Color.gray)
                
            } else {
                Image(systemName: "photo")
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(height: height)
                    .frame(maxWidth: maxWidth)
        //            .background(Color.gray)
            }

        }
        

    }
}





//#Preview {
//    AsyncImageView()
//}
