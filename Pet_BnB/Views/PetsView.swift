//
//  PetsView.swift
//  Pet_BnB
//
//  Created by Kristian Thun on 2024-05-20.
//

import SwiftUI

struct PetsView: View {
    @StateObject var vm: PetsViewModel
    var body: some View {
        VStack{
            if let pets = vm.house.pets{
                ForEach(pets) { pet in
                    PetRowView(pet: pet)
                }
            } else{
                Text("No pets added")
                Text("Please add a pet")
            }

           Spacer()
            VStack(alignment: .trailing){
                NavigationLink(destination: CreatePetView(vm:CreatePetViewModel(pet: nil, house: vm.house))){
                    
                    
                    FilledButtonLabel(text: "Add Pet")
                        .frame(maxWidth: 100)
                }
            }

        }
    }
}

struct PetRowView:View{
    var pet: Pet
    
    var body: some View{
        HStack{
            Image(systemName: "photo")
                .resizable()
                .frame(maxWidth: 50, maxHeight: 50)
                .padding(.horizontal)
            VStack(alignment: .leading){
                Text(pet.name)
                    .font(.title)
                Text(pet.species)
                    .font(.title3)
                    .foregroundStyle(.secondary)
            }
            Spacer()
        }
        .frame(maxWidth: .infinity)
        .padding()
        .border(.black)
        .padding()
        
    }
}

//#Preview {
//    PetsView(vm:PetsViewModel(pets: [Pet(name: "Fläcken", species: "Hund")]))
//}
