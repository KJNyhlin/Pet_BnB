//
//  CreateHouseView.swift
//  Pet_BnB
//
//  Created by Kristian Thun on 2024-05-15.
//

import SwiftUI
import PhotosUI

struct CreateHouseView: View {
    @StateObject var vm: CreateHouseViewModel
    @EnvironmentObject var firebaseHelper: FirebaseHelper
    @Environment(\.presentationMode) var presentationMode

    @FocusState private var focusedField: Field?
    @State private var showAlert = false
    @State private var isSaving = false

    enum Field {
        case title, beds, size, streetName, streetNR, zipCode, city, description
    }

    var body: some View {

            VStack {
                Form {
                    PhotosPicker(selection: $vm.imageSelection, matching: .images) {
                        if let image = vm.image {
                            Image(uiImage: image)
                                .resizable()
                                .scaledToFit()
                                .frame(maxWidth: .infinity, maxHeight: 200)
                        } else {
                            Image(systemName: "photo.badge.plus")
                                .resizable()
                                .scaledToFit()
                                .frame(maxWidth: .infinity, maxHeight: 200)
                        }
                    }

                    Section(header: Text("Information")) {
                        NewHouseFormRowView(rowTitle: "Title", rowValue: $vm.title)
                            .focused($focusedField, equals: .title)
                        NewHouseFormRowView(rowTitle: "Beds", rowValue: $vm.beds, keyboardType: .numberPad)
                            .focused($focusedField, equals: .beds)
                        NewHouseFormRowView(rowTitle: "m²", rowValue: $vm.size, keyboardType: .numberPad)
                            .focused($focusedField, equals: .size)
                    }
                    Section(header: Text("Address")) {
                        NewHouseFormRowView(rowTitle: "Street", rowValue: $vm.streetName)
                            .focused($focusedField, equals: .streetName)
                        NewHouseFormRowView(rowTitle: "Number", rowValue: $vm.streetNR, keyboardType: .numberPad)
                            .focused($focusedField, equals: .streetNR)
                        NewHouseFormRowView(rowTitle: "Zip code", rowValue: $vm.zipCode, keyboardType: .numberPad)
                            .focused($focusedField, equals: .zipCode)
                        NewHouseFormRowView(rowTitle: "City", rowValue: $vm.city)
                            .focused($focusedField, equals: .city)
                    }

                    Section(header: Text("Description")) {
                        TextEditor(text: $vm.description)
                            .frame(minHeight: 100)
                            .focused($focusedField, equals: .description)
                        Button(action: {
                            saveHouse()
                        }, label: {
                            FilledButtonLabel(text: "Save")
                                .padding(.vertical, 10)
                                .padding(.horizontal, 30)
                        })
                        .disabled(vm.savingInProgress)
                    }
                }
            }
            .navigationTitle(vm.house == nil ? "Create House" : "Edit House")
            .toolbar {
                ToolbarItemGroup(placement: .keyboard) {
                    Spacer()
                    Button("Done") {
                        focusedField = nil
                    }
                }
            }
            .navigationBarBackButtonHidden(true)
            .navigationBarItems(leading: Button(action: {
                if vm.hasUnsavedChanges() {
                    showAlert = true
                } else {
                    self.presentationMode.wrappedValue.dismiss()
                }
            }) {
                Image(systemName: "chevron.left")
                    .foregroundColor(.blue)
            })
            .alert(isPresented: $showAlert) {
                Alert(
                    title: Text("Don't you want to save your changes?"),
                    message: Text("You have unsaved changes."),
                    primaryButton: .destructive(Text("Discard changes")) {
                        self.presentationMode.wrappedValue.dismiss()
                    },
                    secondaryButton: .default(Text("Save")) {
                        saveHouse()
                    }
                )
 
        }
    }

    private func saveHouse() {
        hideKeyboard()
        isSaving = true
        vm.saveHouse() { success in
            if success {
                isSaving = false
                DispatchQueue.main.async {
                    self.presentationMode.wrappedValue.dismiss()
                }
            } else {
                vm.saveing(inProgress: false)
            }
        }
    }

    private func hideKeyboard() {
        focusedField = nil
    }
}

struct NewHouseFormRowView: View {
    var rowTitle: String
    @Binding var rowValue: String
    var keyboardType: UIKeyboardType = .default

    @FocusState private var isFocused: Bool

    var body: some View {
        HStack {
            Text("\(rowTitle):")
                .bold()
            TextField(rowTitle, text: $rowValue)
                .keyboardType(keyboardType)
                .focused($isFocused)
        }
    }
}

extension CreateHouseViewModel {
    func hasUnsavedChanges() -> Bool {
        return !title.isEmpty || !beds.isEmpty || !size.isEmpty || !streetName.isEmpty || !streetNR.isEmpty || !zipCode.isEmpty || !city.isEmpty || !description.isEmpty || image != nil
    }
}

//#Preview {
//    CreateHouseView()
//}
