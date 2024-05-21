//
//  CreatePetView.swift
//  Pet_BnB
//
//  Created by Kristian Thun on 2024-05-20.
//

import SwiftUI

struct CreatePetView: View {
    @StateObject var vm: CreatePetViewModel
    @Environment(\.presentationMode) var presentationMode
    @State var infromationSheetShown = false
    var body: some View {
        VStack{
            Image(systemName: "pawprint.fill")
                .resizable()
                .scaledToFit()
                .frame(width: 200, height: 200)
                .padding()
            
            EntryFields(placeHolder: "Name", promt: "", field: $vm.name)
            
            // EntryFields(placeHolder: "Spiecies", promt: "", field: $vm.name)
            
            Picker("Spices", selection: $vm.selectedSpices){
                ForEach(vm.speciesOptions, id: \.self){ specie in
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
            
            
            
            
            ScrollView{
                Button(action: {
                    // vm.addInformation()
                    infromationSheetShown = true
                }, label: {
                    Label(
                        title: { Text("Information \(vm.informationArray.count)") },
                        icon: { Image(systemName: "plus") }
                    )
                    .frame(maxWidth: .infinity)
                    .padding(10)
                    .overlay(
                        RoundedRectangle(cornerRadius: 25.0)
                            .stroke(AppColors.mainAccent, lineWidth: 3)
                    )
                    .padding(.vertical)
                })
                VStack{
                    ForEach(0..<vm.informationArray.count, id: \.self){ index in
                        EntryFields(placeHolder: "Text", promt: "", field: $vm.informationArray[index])
                    }
                    Spacer()
                    
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .border(.black)
            }
            
            
            
            Button(action: {
                Task{
                    vm.savePet(){ success in
                        if success{
                            DispatchQueue.main.async {
                                self.presentationMode.wrappedValue.dismiss()
                            }
                        }
                    }
                }
                
            }, label: {
                FilledButtonLabel(text: "Save")
            })
            
        }
        .frame(maxWidth: .infinity)
        .padding(.horizontal, 80)
        .padding(.vertical ,20)
        .sheet(isPresented: $infromationSheetShown) {
            InformationSheet(vm: vm, isPresented: $infromationSheetShown)
        }
        
    }
}

struct InformationSheet: View {
    @ObservedObject var vm: CreatePetViewModel
    //@Binding var informationArray: [String]
    @Binding var isPresented: Bool
    @State private var inputText: String = ""
    var body: some View {
        VStack{
            
            HStack(){
                EntryFields(placeHolder: "Information", promt: "", field: $inputText )
                    .multilineTextAlignment(.leading)
                
                Button("Add"){
                    if inputText.isEmpty{
                        return
                    }else{
                        vm.addInformation(information: inputText)
                        inputText = ""
                    }
                    
                }
                
            }
            .padding(.top, 40)
            List{
                ForEach(Array(vm.informationArray.enumerated()), id: \.element) { index, information in
                    PetInformationRow(vm: vm, arrayID: index, information: information)
            }
                .onDelete(perform: vm.deleteInformation)

            
            }
        }
    }
}

struct PetInformationRow: View {
    @ObservedObject var vm: CreatePetViewModel
    var arrayID: Int
    var information: String

    var body: some View {
        HStack{
            Image(systemName: "circle.fill")
                .foregroundColor(AppColors.mainAccent)
            Text(information)
        }
        
    }
}




#Preview {
    CreatePetView(vm: CreatePetViewModel(pet: Pet(name: "Rufus", species: "Dog"), house: House(title: "", description: "", beds: 1, size: 1, streetName: "", streetNR: 1, city: "", zipCode: 1, ownerID: "")))
}
