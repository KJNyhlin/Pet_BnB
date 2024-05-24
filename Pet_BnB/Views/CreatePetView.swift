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

    var body: some View {
        VStack {
            HStack(spacing: 0) {
                VStack {
                    ZStack {
                        if let image = vm.image {
                            Image(uiImage: image)
                                .resizable()
                                .aspectRatio(contentMode: .fill)
                                .frame(width: 150, height: 150)
                                .clipShape(Circle())
                                .clipped()
                                .padding(.leading, 20)
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

                    EntryFields(placeHolder: "Name", promt: "", field: $vm.name)

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
                        .frame(maxWidth: .infinity, minHeight: 200, maxHeight: 400)
                        .padding()
                        .overlay(
                            RoundedRectangle(cornerRadius: 25.0)
                                .stroke(AppColors.mainAccent, lineWidth: 3)
                        )
                        .padding(.vertical)

                    Spacer()

                    Button(action: {
                        isSaving = true
                        Task {
                            if let selectedImage = vm.image {
                                vm.uploadPetImage(selectedImage) { url in
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
                                    vm.uploadPetImage(selectedImage) { url in
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
                    if vm.hasUnsavedChanges(pet: pet) {
                        showAlert = true
                    } else {
                        self.presentationMode.wrappedValue.dismiss()
                    }
                }) {
                    Image(systemName: "chevron.left")
                        .foregroundColor(.blue)
                })
            }
        }
    }
}

extension PetsViewModel {
    func hasUnsavedChanges(pet: Pet?) -> Bool {
        guard let pet = pet else {
            return false
        }
        return name != pet.name ||
               selectedSpices != pet.species ||
               description != pet.description ||
               image != nil && imageURL != pet.imageURL
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
