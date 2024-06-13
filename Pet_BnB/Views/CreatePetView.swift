//
//  CreatePetView.swift
//  Pet_BnB
//
//  Created by Kristian Thun on 2024-05-20.
//

import SwiftUI
import PhotosUI

struct CreatePetView: View {
    @ObservedObject var vm: PetsViewModel
    @Environment(\.presentationMode) var presentationMode
    @EnvironmentObject var authManager: AuthManager
    var pet: Pet?

    @State private var isImagePickerPresented = false
    @State private var isSaving = false
    @State private var showAlert = false
    @State private var imagePosition = CGSize.zero
    @State private var lastImagePosition = CGSize.zero
    @State private var imageScale: CGFloat = 1.0
    @State private var lastImageScale: CGFloat = 1.0
    @State private var isImageLoading = true
    @State private var newRule: String = ""
    @State private var editingRuleIndex: Int?

    @FocusState private var isNameFocused: Bool
    @FocusState private var isDescriptionFocused: Bool

    var body: some View {
        VStack {
            VStack {
                ZStack {
                    if let image = vm.image, !isImageLoading {
                        GeometryReader { geometry in
                            Image(uiImage: image)
                                .resizable()
                                .aspectRatio(contentMode: .fill)
                                .offset(x: self.imagePosition.width, y: self.imagePosition.height)
                                .scaleEffect(self.imageScale)
                                .frame(width: geometry.size.width, height: geometry.size.height)
                                .clipShape(Circle())
                                .gesture(
                                    DragGesture()
                                        .onChanged { value in
                                            self.imagePosition = CGSize(width: value.translation.width + self.lastImagePosition.width, height: value.translation.height + self.lastImagePosition.height)
                                        }
                                        .onEnded { _ in
                                            self.lastImagePosition = self.imagePosition
                                        }
                                )
                                .gesture(
                                    MagnificationGesture()
                                        .onChanged { value in
                                            self.imageScale = value * self.lastImageScale
                                        }
                                        .onEnded { _ in
                                            self.lastImageScale = self.imageScale
                                        }
                                )
                                .clipped()
                        }
                        .frame(width: 150, height: 150)
                    } else if isImageLoading {
                        ProgressView() // Visa en laddningsindikator medan bilden laddas
                            .frame(width: 150, height: 150)
                    } else {
                        Image(systemName: "pawprint.fill")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 100, height: 100)
                            .padding()
                    }
                    Circle()
                        .stroke(AppColors.mainAccent, lineWidth: 3)
                        .frame(width: 150, height: 150)
                }
                .onTapGesture {
                    isImagePickerPresented = true
                }
                .padding(.top, 20)
                ScrollView {
                    VStack {
                        EntryFields(placeHolder: "Name", promt: "", field: $vm.name)
                            .focused($isNameFocused) // Sätt fokus på namnfältet

                        Picker("Species", selection: $vm.selectedSpices) {
                            ForEach(vm.speciesOptions, id: \.self) { specie in
                                Text(specie)
                            }
                        }
                        .tint(.black)
                        .frame(maxWidth: .infinity)
                        .pickerStyle(MenuPickerStyle())
                        .overlay(
                            RoundedRectangle(cornerRadius: 25.0)
                                .stroke(AppColors.mainAccent, lineWidth: 3)
                        )

                        TextEditor(text: $vm.description)
                            .focused($isDescriptionFocused)
                            .frame(maxWidth: .infinity, minHeight: 170, maxHeight: 400)
                            .padding()
                            .overlay(
                                RoundedRectangle(cornerRadius: 25.0)
                                    .stroke(AppColors.mainAccent, lineWidth: 3)
                            )
                            .padding(.vertical)

                        Section(header: Text("Pet Rules:")) {
                            ForEach(Array(vm.informationArray.enumerated()), id: \.element) { index, rule in
                                HStack {
                                    Image(systemName: "pawprint.fill")
                                        .foregroundColor(.yellow)
                                    if editingRuleIndex == index {
                                        TextField("Edit Rule", text: $newRule, onCommit: {
                                            vm.informationArray[index] = newRule
                                            newRule = ""
                                            editingRuleIndex = nil
                                        })
                                            .textFieldStyle(RoundedBorderTextFieldStyle())
                                    } else {
                                        Text(rule)
                                        Spacer()
                                        Button(action: {
                                            newRule = rule
                                            editingRuleIndex = index
                                        }) {
                                        Image(systemName: "pencil")
                                            .foregroundColor(.blue)
                                        }
                                    }
                                    Button(action: {
                                        deleteRule(at: IndexSet(integer: index))
                                    }) {
                                    Image(systemName: "trash")
                                        .foregroundColor(.red)
                                    }
                                }
                            }
                            HStack {
                                Image(systemName: "pawprint.fill")
                                    .foregroundColor(.yellow)
                                TextField("New Rule", text: $newRule)
                                Button(action: addRule) {
                                    Image(systemName: "plus.circle.fill")
                                        .foregroundColor(.yellow)
                                }
                            }
                            .padding()
                            .overlay(
                                RoundedRectangle(cornerRadius: 25.0)
                                    .stroke(AppColors.mainAccent, lineWidth: 3)
                                    .frame(height: 40)
                            )
                        }
                        .padding(.horizontal)
                        
                        Spacer()
                    }
                    .padding(.leading, 5)
                    .padding(.trailing, 5)
                    .padding(.vertical, 20)
                }
                
                Button(action: {
                    hideKeyboard()
                    isSaving = true
                    Task {
                        if let selectedImage = vm.image {
                            let croppedImage = cropImage(image: selectedImage, scale: self.imageScale, position: self.imagePosition, frameSize: CGSize(width: 150, height: 150))
                            vm.uploadPetImage(croppedImage) { url in
                                vm.imageURL = url
                                vm.savePet { success in
                                    if success {
                                        isSaving = false
                                        DispatchQueue.main.async {
                                            self.presentationMode.wrappedValue.dismiss()
                                        }
                                    }
                                }
                            }
                        } else {
                            vm.savePet { success in
                                if success {
                                    isSaving = false
                                    DispatchQueue.main.async {
                                        self.presentationMode.wrappedValue.dismiss()
                                    }
                                }
                            }
                        }
                    }
                }, label: {
                    if isSaving {
                        ProgressView() // Visar en laddningsindikator under sparprocessen
                    } else {
                        FilledButtonLabel(text: "Save")
                    }
                })
            }
            .frame(maxWidth: .infinity)
            .padding(.horizontal, 80)
            .padding(.vertical, 20)
            .onAppear {
                if let pet = pet {
                    vm.name = pet.name
                    vm.selectedSpices = pet.species
                    vm.description = pet.description ?? ""
                    vm.imageURL = pet.imageURL
                    vm.informationArray = pet.information
                    vm.loadImageFromURL(pet.imageURL ?? "") {
                        self.isImageLoading = false
                    }
                    vm.pet = pet
                } else {
                    self.isImageLoading = false // Ställ in till false om ingen bild ska laddas
                }
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                    self.isNameFocused = true
                }
            }
            .photosPicker(isPresented: $isImagePickerPresented, selection: $vm.imageSelection, matching: .images, photoLibrary: .shared())
            .onChange(of: vm.imageSelection) { newValue in
                if newValue != nil {
                    self.isImageLoading = true // Starta laddning när en ny bild väljs
                    loadImageData()
                }
            }
            .alert(isPresented: $showAlert) {
                Alert(
                    title: Text("Don't you want to save your changes?"),
                    message: Text("You have unsaved changes."),
                    primaryButton: .destructive(Text("Discard changes")) {
                        self.presentationMode.wrappedValue.dismiss()
                    },
                    secondaryButton: .default(Text("Save")) {
                        isSaving = true
                        Task {
                            if let selectedImage = vm.image {
                                let croppedImage = cropImage(image: selectedImage, scale: self.imageScale, position: self.imagePosition, frameSize: CGSize(width: 150, height: 150))
                                vm.uploadPetImage(croppedImage) { url in
                                    vm.imageURL = url
                                    vm.savePet { success in
                                        if success {
                                            isSaving = false
                                            DispatchQueue.main.async {
                                                self.presentationMode.wrappedValue.dismiss()
                                            }
                                        }
                                    }
                                }
                            } else {
                                vm.savePet { success in
                                    if success {
                                        isSaving = false
                                        DispatchQueue.main.async {
                                            self.presentationMode.wrappedValue.dismiss()
                                        }
                                    }
                                }
                            }
                        }
                    }
                )
            }
            .navigationBarBackButtonHidden(true)
            .navigationBarItems(leading: Button(action: {
                if vm.hasUnsavedChanges(pet: pet, imagePosition: imagePosition, imageScale: imageScale) {
                    showAlert = true
                } else {
                    self.presentationMode.wrappedValue.dismiss()
                }
            }) {
                Image(systemName: "chevron.left")
                    .foregroundColor(.blue)
            })
            .toolbar {
                ToolbarItemGroup(placement: .keyboard) {
                    Spacer()
                    Button("Done") {
                        hideKeyboard()
                    }
                }
            }
            .navigationTitle("My Pet")
        }
        .onChange(of: authManager.loggedIn){ oldValue, newValue in
            if !newValue {
                presentationMode.wrappedValue.dismiss()
            }
        }
    }

    private func hideKeyboard() {
        isNameFocused = false
        isDescriptionFocused = false
    }

    private func cropImage(image: UIImage, scale: CGFloat, position: CGSize, frameSize: CGSize) -> UIImage {
        let renderer = UIGraphicsImageRenderer(size: frameSize)
        let croppedImage = renderer.image { context in
            context.cgContext.translateBy(x: frameSize.width / 2, y: frameSize.height / 2)
            context.cgContext.scaleBy(x: scale, y: scale)
            context.cgContext.translateBy(x: -frameSize.width / 2 + position.width / scale, y: -frameSize.height / 2 + position.height / scale)
            image.draw(in: CGRect(origin: .zero, size: frameSize))
        }
        return croppedImage
    }
    
    private func addRule() {
        guard !newRule.isEmpty else { return }
        if let editingIndex = editingRuleIndex {
            vm.informationArray[editingIndex] = newRule
            editingRuleIndex = nil
        } else {
            vm.informationArray.append(newRule)
        }
        newRule = ""
    }

    private func deleteRule(at offsets: IndexSet) {
        vm.informationArray.remove(atOffsets: offsets)
    }
    
    private func loadImageData() {
        Task {
            do {
                guard let selectedPhoto = vm.imageSelection else {
                    print("No photo selected")
                    return
                }
                let imageData = try await selectedPhoto.loadTransferable(type: Data.self)
                DispatchQueue.main.async {
                    if let imageData = imageData {
                        self.vm.image = UIImage(data: imageData)
                        self.isImageLoading = false
                    }
                }
            } catch {
                print("Error loading image data: \(error)")
            }
        }
    }
}


//#Preview {
//    CreatePetView(vm: CreatePetViewModel(pet: Pet(name: "Rufus", species: "Dog"), house: House(title: "", description: "", beds: 1, size: 1, streetName: "", streetNR: 1, city: "", zipCode: 1, ownerID: "")))
//}
