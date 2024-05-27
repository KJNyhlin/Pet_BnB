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
    var pet: Pet?

    @State private var isImagePickerPresented = false
    @State private var isSaving = false
    @State private var showAlert = false
    @State private var imagePosition = CGSize.zero
    @State private var lastImagePosition = CGSize.zero
    @State private var imageScale: CGFloat = 1.0
    @State private var lastImageScale: CGFloat = 1.0

    @FocusState private var isNameFocused: Bool
    @FocusState private var isDescriptionFocused: Bool

    var body: some View {
        VStack {
            VStack {
                ZStack {
                    if let image = vm.image {
                        GeometryReader { geometry in
                            Image(uiImage: image)
                                .resizable()
                                .aspectRatio(contentMode: .fit)
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
                                .padding(.leading, 20)
                        }
                        .frame(width: 150, height: 150)
                    } else {
                        Image(systemName: "pawprint.fill")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 100, height: 100)
                            .padding()
                    }
                }
                .onTapGesture {
                    isImagePickerPresented = true
                }
                .padding(.top, 20) // Lägger till toppmarginal för att undvika statusfältet

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
                    .frame(maxWidth: .infinity, minHeight: 200, maxHeight: 400)
                    .padding()
                    .overlay(
                        RoundedRectangle(cornerRadius: 25.0)
                            .stroke(AppColors.mainAccent, lineWidth: 3)
                    )
                    .padding(.vertical)

                Spacer()

                Button(action: {
                    hideKeyboard() // Lägg till för att minimera tangentbordet innan sparandet
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
                        ProgressView() // Visa en laddningsindikator under sparprocessen
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
                    vm.loadImageFromURL(pet.imageURL ?? "")
                    vm.pet = pet // Tilldela pet för att redigera
                }
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                    self.isNameFocused = true // Sätt fokus på namnfältet efter en kort fördröjning
                }
            }
            .photosPicker(isPresented: $isImagePickerPresented, selection: $vm.imageSelection, matching: .images, photoLibrary: .shared())
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
}

extension PetsViewModel {
    func hasUnsavedChanges(pet: Pet?, imagePosition: CGSize, imageScale: CGFloat) -> Bool {
        guard let pet = pet else {
            return name.isEmpty == false || description.isEmpty == false || selectedSpices != "Dog" || image != nil
        }
        return name != pet.name ||
               selectedSpices != pet.species ||
               description != pet.description ||
               (image != nil && imageURL != pet.imageURL) ||
               imagePosition != .zero || imageScale != 1.0
    }
}

//
//struct InformationSheet: View {
//    @ObservedObject var vm: CreatePetViewModel
//    //@Binding var informationArray: [String]
//    @Binding var isPresented: Bool
//    @State private var inputText: String = ""
//    var body: some View {
//        VStack{
//            
//            HStack(){
//                EntryFields(placeHolder: "Information", promt: "", field: $inputText )
//                    .multilineTextAlignment(.leading)
//                
//                Button("Add"){
//                    if inputText.isEmpty{
//                        return
//                    }else{
//                        vm.addInformation(information: inputText)
//                        inputText = ""
//                    }
//                    
//                }
//                
//            }
//            .padding(.top, 40)
//            List{
//                ForEach(Array(vm.informationArray.enumerated()), id: \.element) { index, information in
//                    PetInformationRow(vm: vm, arrayID: index, information: information)
//                }
//                .onDelete(perform: vm.deleteInformation)
//                
//                
//            }
//        }
//    }
//}
//
//struct PetInformationRow: View {
//    @ObservedObject var vm: CreatePetViewModel
//    var arrayID: Int
//    var information: String
//    
//    var body: some View {
//        HStack{
//            Image(systemName: "circle.fill")
//                .foregroundColor(AppColors.mainAccent)
//            Text(information)
//        }
//        
//    }
//}

//#Preview {
//    CreatePetView(vm: CreatePetViewModel(pet: Pet(name: "Rufus", species: "Dog"), house: House(title: "", description: "", beds: 1, size: 1, streetName: "", streetNR: 1, city: "", zipCode: 1, ownerID: "")))
//}
