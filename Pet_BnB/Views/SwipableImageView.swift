//
//  SwipableImageView.swift
//  Pet_BnB
//
//  Created by Maida on 2024-05-23.
//

import SwiftUI

struct SwipableImageView: View {
    var houseImageURL: String?
    var petImageURL: String?
    
    var body: some View {
        TabView {
            if let houseImageURL = houseImageURL, let houseURL = URL(string: houseImageURL) {
                AsyncImage(url: houseURL) { phase in
                    switch phase {
                    case .empty:
                        ProgressView()
                            .frame(height: 200)
                            .frame(maxWidth: .infinity)
                    case .success(let image):
                        image
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(height: 200)
                            .frame(maxWidth: .infinity)
                            .clipped()
                    case .failure:
                        Image(systemName: "photo")
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(height: 200)
                            .frame(maxWidth: .infinity)
                            .background(Color.gray)
                    @unknown default:
                        Image(systemName: "photo")
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(height: 200)
                            .frame(maxWidth: .infinity)
                            .background(Color.gray)
                    }
                }
            }
            
            if let petImageURL = petImageURL, let petURL = URL(string: petImageURL) {
                AsyncImage(url: petURL) { phase in
                    switch phase {
                    case .empty:
                        ProgressView()
                            .frame(height: 200)
                            .frame(maxWidth: .infinity)
                    case .success(let image):
                        image
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(height: 200)
                            .frame(maxWidth: .infinity)
                            .clipped()
                    case .failure:
                        Image(systemName: "photo")
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(height: 200)
                            .frame(maxWidth: .infinity)
                            .background(Color.gray)
                    @unknown default:
                        Image(systemName: "photo")
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(height: 200)
                            .frame(maxWidth: .infinity)
                            .background(Color.gray)
                    }
                }
            } else {
                Image(systemName: "photo")
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(height: 200)
                    .frame(maxWidth: .infinity)
                    .background(Color.gray)
            }
        }
        .tabViewStyle(PageTabViewStyle())
        .frame(height: 200)
    }
}

struct SwipableImageView2: View {
    var houseImageURL: String?
    var petImageURL: String?
    var height: CGFloat
    var width: CGFloat
    
    var body: some View {
        TabView {
            if let houseImageURL = houseImageURL, let houseURL = URL(string: houseImageURL) {
                AsyncImage(url: houseURL) { phase in
                    switch phase {
                    case .empty:
                        ProgressView()
                            .frame(height: height)
                            .frame(maxWidth: .infinity)
                    case .success(let image):
                        image
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(height: height)
                            .frame(maxWidth: .infinity)
                            .clipped()
                    case .failure:
                        Image(systemName: "photo")
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(height: height)
                            .frame(maxWidth: .infinity)
                            .background(Color.gray)
                    @unknown default:
                        Image(systemName: "photo")
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(height: height)
                            .frame(maxWidth: .infinity)
                            .background(Color.gray)
                    }
                }
            }
            
            if let petImageURL = petImageURL, let petURL = URL(string: petImageURL) {
                AsyncImage(url: petURL) { phase in
                    switch phase {
                    case .empty:
                        ProgressView()
                            .frame(height: height)
                            .frame(maxWidth: .infinity)
                    case .success(let image):
                        image
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(height: height)
                            .frame(maxWidth: .infinity)
                            .clipped()
                    case .failure:
                        Image(systemName: "photo")
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(height: height)
                            .frame(maxWidth: .infinity)
                            .background(Color.gray)
                    @unknown default:
                        Image(systemName: "photo")
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(height: height)
                            .frame(maxWidth: .infinity)
                            .background(Color.gray)
                    }
                }
            } else {
                Image(systemName: "photo")
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(height: height)
                    .frame(maxWidth: .infinity)
                    .background(Color.gray)
            }
        }
        .tabViewStyle(PageTabViewStyle())
        .frame(width: width, height: height)
    }
}
