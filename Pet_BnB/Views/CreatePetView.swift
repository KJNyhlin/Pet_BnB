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
   

    
    var body: some View {
        VStack{
            Image(systemName: "pawprint.fill")
                .resizable()
                .scaledToFit()
                .frame(width: 200, height: 200)
            
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
            Spacer()
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
        
    }
}

//#Preview {
//    CreatePetView(vm: CreatePetViewModel(pet: nil))
//}
