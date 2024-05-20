//
//  AsyncImageView.swift
//  Pet_BnB
//
//  Created by Kristian Thun on 2024-05-18.
//

import SwiftUI

struct AsyncImageView: View {
    let imageUrl: String
    let maxWidth: CGFloat
    
    init(imageUrl: String, maxWidth: CGFloat = .infinity){
        self.imageUrl = imageUrl
        self.maxWidth = maxWidth
    }
    
    var body: some View {
       
        AsyncImage(url: URL(string: imageUrl)) { phase in
            switch phase {
            case .empty:
                ProgressView()
                    .frame(height: 200)
                    .frame(maxWidth: maxWidth)
            case .success(let image):
                image
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(height: 300)
                    .frame(maxWidth: maxWidth)
                    .clipped()
            case .failure:
                Image(systemName: "photo")
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(height: 200)
                    .frame(maxWidth: maxWidth)
                    .background(Color.gray)
            @unknown default:
                Image(systemName: "photo")
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(height: 200)
                    .frame(maxWidth: maxWidth)
                    .background(Color.gray)
            }
        }
    }
}

//#Preview {
//    AsyncImageView()
//}
