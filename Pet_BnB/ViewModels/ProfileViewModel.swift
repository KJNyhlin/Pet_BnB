//
//  ProfileViewModel.swift
//  Pet_BnB
//
//  Created by Jonas Bondesson on 2024-05-17.
//

import Foundation
import PhotosUI
import SwiftUI
import FirebaseStorage

class ProfileViewModel: ObservableObject {
    @Published var user = User()
    let firebaseHelper = FirebaseHelper()
    @Published var firstName: String = ""
    @Published var surName: String = ""
    @Published var editMode: Bool = false
    @Published var editFirstName: String = ""
    @Published var editSurName: String = ""
    @Published var image: UIImage?
    @Published var showImagePicker: Bool = false
    @Published var imageSelection: PhotosPickerItem? = nil {
        didSet {
            loadImageData()
        }
    }

    func getUserDetails() {
        guard let userID = firebaseHelper.getUserID() else { return }
        firebaseHelper.loadUserInfo(userID: userID) { user in
            if let user = user {
                self.firstName = user.firstName ?? ""
                self.surName = user.surName ?? ""
                if let imageURL = user.imageURL {
                    self.loadImageFromURL(imageURL)
                }
            }
        }
    }

    func signOut() {
        firebaseHelper.signOut()
        firstName = ""
        surName = ""
        image = nil
    }

    func checkIfUserIsLoggedIn() -> Bool {
        return firebaseHelper.getUserID() != nil
    }

    func saveUserInfoToDB() {
        guard let userID = firebaseHelper.getUserID() else { return }
        if checkForChanges() {
            firebaseHelper.savePersonalInfoToDB(firstName: self.editFirstName, surName: self.editSurName)
            self.firstName = self.editFirstName
            self.surName = self.editSurName
        }
        if let image = image {
            saveImageToDB(image: image, userID: userID)
        }
    }

    func checkForChanges() -> Bool {
        return self.firstName != self.editFirstName || self.surName != self.editSurName
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
                    if let imageData = imageData {
                        self.image = UIImage(data: imageData)
                        self.saveImageToDB(image: UIImage(data: imageData)!, userID: self.firebaseHelper.getUserID()!)
                    }
                }
            } catch {
                print("Error loading image data: \(error)")
            }
        }
    }

    func loadImageFromURL(_ imageURL: String) {
        guard let url = URL(string: imageURL) else { return }
        Task {
            do {
                let (data, _) = try await URLSession.shared.data(from: url)
                DispatchQueue.main.async {
                    self.image = UIImage(data: data)
                }
            } catch {
                print("Error loading image from URL: \(error)")
            }
        }
    }

    func saveImageToDB(image: UIImage, userID: String) {
        guard let imageData = image.jpegData(compressionQuality: 0.8) else { return }
        firebaseHelper.uploadImage(uiImage: image) { [weak self] urlString in
            if let urlString = urlString {
                self?.firebaseHelper.saveImageURLToDB(userID: userID, imageURL: urlString)
            }
        }
    }
}

