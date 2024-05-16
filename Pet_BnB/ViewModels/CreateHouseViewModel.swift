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
    @Published var imageURL: String?
    @Published var beds = ""
    @Published var size = ""
    @Published var streetName = ""
    @Published var streetNR = ""
    @Published var city = ""
    let firebaseHelper = FirebaseHelper()

    @Published var image: UIImage?

    @Published var imageSelection: PhotosPickerItem? = nil {
          didSet {
              loadImageData()
          }
      }
    
    func saveHouse() -> Bool{
        if checkAllInfoSet(){

            if let image = image,
               let bedsInt = Int(beds),
               let sizeInt = Int(size),
               let streetNRInt = Int(streetNR)
            {
                firebaseHelper.saveHouse(uiImage: image, title: title, description: description, beds: bedsInt, size: sizeInt, StreetName: streetName, streetNr: streetNRInt, city: city)
                // Only returns true if the house is created for now not if is saved properly
                return true
            }
        }
        return false
    }
    
    func checkAllInfoSet() -> Bool{
        if !title.isEmpty && !description.isEmpty && image != nil && !beds.isEmpty && !size.isEmpty && !streetName.isEmpty && !streetNR.isEmpty && !city.isEmpty {
            return true
        }
        return  false
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
