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
    
    var body: some View {
        NavigationStack{
            VStack{
                Form{
                    PhotosPicker(selection: $vm.imageSelection, matching: .images){
                        if let image = vm.image{
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

                    
                    
                    Section(header: Text("Information")){
                        NewHouseFormRowView(rowTitle: "Title", rowValue: $vm.title)
                        NewHouseFormRowView(rowTitle: "Beds", rowValue: $vm.beds, keyboardType: .numberPad)
                        NewHouseFormRowView(rowTitle: "m²", rowValue: $vm.size, keyboardType: .numberPad)

                    }
                    Section(header: Text("Adress")) {
                        NewHouseFormRowView(rowTitle: "Street", rowValue: $vm.streetName)
                        NewHouseFormRowView(rowTitle: "Number", rowValue: $vm.streetNR, keyboardType: .numberPad)
                        NewHouseFormRowView(rowTitle: "Zip code", rowValue: $vm.zipCode, keyboardType: .numberPad)
                        NewHouseFormRowView(rowTitle: "City", rowValue: $vm.city)
                        
                    }
                    
                    Section(header: Text("Description")){
                        TextEditor(text: $vm.description)
                            .frame(minHeight: 100)
                        Button(action: {
                            vm.saveHouse(){ success in
                                if success{
                                    DispatchQueue.main.async {
                                        self.presentationMode.wrappedValue.dismiss()
                                    }
                                }
                            }
                        }, label: {
                            FilledButtonLabel(text: "Save")
                                .padding(.vertical, 10)
                                .padding(.horizontal, 30)
                               
                        })
                        .disabled(vm.savingInProgress)
                    }
                }
            }
            .navigationTitle(vm.house == nil ? "Create House": "Edit House")
        }
        
    }
}

struct NewHouseFormRowView: View{
    var rowTitle: String
    @Binding var rowValue: String
    var keyboardType: UIKeyboardType = .default
    
    var body: some View{
        HStack{
            Text("\(rowTitle):")
                .bold()
            TextField(rowTitle, text: $rowValue)
                .keyboardType(keyboardType)
        }
    }
}

//#Preview {
//    CreateHouseView()
//}
