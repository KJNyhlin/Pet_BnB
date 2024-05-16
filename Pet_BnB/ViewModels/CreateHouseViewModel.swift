//
//  CreateHouseViewModel.swift
//  Pet_BnB
//
//  Created by Kristian Thun on 2024-05-15.
//

import Foundation
import SwiftUI
import PhotosUI

class CreateHouseViewModel: ObservableObject{
    @Published var title = ""
    @Published var description = ""
    let firebaseHelper = FirebaseHelper()

    @Published var image: UIImage?

    @Published var imageSelection: PhotosPickerItem? = nil {
          didSet {
              loadImageData()
          }
      }
    
    func saveHouse() -> Bool{
        if !title.isEmpty && !description.isEmpty && image != nil{
            let house = House(title: title, description: description)
            if let image = image{
                firebaseHelper.saveHouse(uiImage: image, house: house)
                // Only returns true if the house is created for now not if is saved properly
                return true
            }
        }
        return false
    }
    
    func loadImageData() {
        Task {
            do {
                guard let selectedPhoto = imageSelection else {
                    print("No photo selected")
                    return
                }
                let imageData = try await selectedPhoto.loadTransferable(type: Data.self)
                DispatchQueue.main.async {
                  //  self.selectedPhotoData = imageData
                    if let imageData = imageData{
                        self.image = UIImage(data: imageData)
                    }
                    
                }
                
            } catch {
                print("Error loading image data: \(error)")
            }
        }
    }
    
    
}
