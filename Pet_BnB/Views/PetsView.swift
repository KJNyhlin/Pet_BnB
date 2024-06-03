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
                     //   NavigationLink(destination: CreatePetView(vm: vm, pet: pet)) {
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
            //    NavigationLink(destination: CreatePetView(vm: vm, pet: nil)) {
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
            if let imageURL = pet.imageURL, let url = URL(string: imageURL) {
                AsyncImage(url: url) { phase in
                    switch phase {
                    case .empty:
                        ProgressView()
                            .frame(width: 50, height: 50)
                    case .success(let image):
                        image
                            .resizable()
                            .scaledToFill()
                            .frame(width: 50, height: 50)
                            .clipShape(Circle())
                            .clipped()
                    case .failure:
                        Image(systemName: "photo")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 50, height: 50)
                            .padding(.horizontal)
                    @unknown default:
                        Image(systemName: "photo")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 50, height: 50)
                            .padding(.horizontal)
                    }
                }
            } else {
                Image(systemName: "photo")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 50, height: 50)
                    .padding(.horizontal)
            }
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
