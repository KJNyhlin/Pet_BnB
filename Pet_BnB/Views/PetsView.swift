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
        VStack {
            if let pets = vm.house.pets, !pets.isEmpty {
                List {
                    ForEach(pets) { pet in

                        NavigationLink(value: pet){
                            PetRowView(pet: pet)
                                
                        }
                    }
                    .onDelete(perform: vm.deletePet)
                }
            } else {
                Text("No pets added")
                Text("Please add a pet")
            }

            Spacer()
            VStack(alignment: .trailing) {
 
                NavigationLink(value: 0){
                    FilledButtonLabel(text: "Add Pet")
                        .frame(maxWidth: 100)
                }
            }
        }
        .navigationDestination(for: Pet.self ){ pet in
            CreatePetView(vm: vm, pet: pet)
        }
        .navigationDestination(for: Int.self ){ pet in
            CreatePetView(vm: vm, pet: nil)
        }
    }
}

struct PetRowView: View {
    var pet: Pet

    var body: some View {
        HStack {
            AsyncImageView(imageUrl: pet.imageURL, maxWidth: 50, height: 50, isCircle: true)
            VStack(alignment: .leading) {
                Text(pet.name)
                    .font(.title3)
                Text(pet.species)
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
            }
            Spacer()
        }
        .frame(maxWidth: .infinity)
        .padding()
    }
}


//#Preview {
//    PetsView(vm:PetsViewModel(pets: [Pet(name: "Fläcken", species: "Hund")]))
//}
