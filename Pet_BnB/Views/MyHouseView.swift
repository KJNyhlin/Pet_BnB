//
//  MyHouseView.swift
//  Pet_BnB
//
//  Created by Jonas Bondesson on 2024-05-15.
//

import SwiftUI

struct MyHouseView: View {
    //var myHouse: House?
    @StateObject var vm = MyHouseViewModel()
    @State private var showingDeleteAlert = false
    var body: some View {
        NavigationStack{
            VStack{
                if vm.house == nil {
                    Text("No house created")
                    
                    NavigationLink(destination: CreateHouseView(vm: CreateHouseViewModel(house: nil))) {
                        FilledButtonLabel(text:"Create House")
                            .frame(maxWidth: 200)
                    }
                }else{
                    if let house = vm.house,
                       let imageUrl = vm.house?.imageURL
                    {
                        AsyncImageView(imageUrl: imageUrl)
                        
                        VStack(alignment: .leading){
                            Text(house.title)
                                .font(.title)
            
                            InformationRow(beds: house.beds, size: house.size)
                                
                            AdressView(street: house.streetName, streetNR: house.streetNR, city: house.city, zipCode: house.zipCode)
         
                            Text(house.description)
                            Spacer()
                            
                            Menu {
                                Button(role: .destructive, action: {
                                    //vm.deleteHouse()
                                    showingDeleteAlert = true
                                }
                                ) {
                                    Label("Delete", systemImage: "trash")
                                    
                                }
                                NavigationLink(destination:CreateHouseView(vm: CreateHouseViewModel(house: vm.house))){
                                    Label("Edit", systemImage: "pencil")
                                }
                                
                            } label: {
                                FilledButtonLabel(text: "Manage")
                            }
                            .alert(isPresented: $showingDeleteAlert) {
                                Alert(title: Text("Delete House"), message: Text("Are you sure you want to delete this house?"), primaryButton: .destructive(Text("Delete")) {
                                    vm.deleteHouse()
                                }, secondaryButton: .cancel())
                            }
                            
                        }
                        .padding()
                        
                        
                    }
                    Spacer()
                }
                
            }
            .onAppear{
                vm.downloadHouse()
            }
        }
    }
}

struct AdressView:View {
    var street: String
    var streetNR: Int
    var city: String
    var zipCode: Int
    
    var body: some View{
        
        HStack{
            Text("\(street.capitalized) \(streetNR), \(zipCode) \(city)")
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .font(.caption)
        .padding(.vertical, 5)
        .bold()
    }
}

struct InformationRow: View{
    var beds: Int
    var size: Int
    
    var body: some View{
        HStack{
            Label(
                title: { Text("\(beds) st") },
                icon: { Image(systemName: "bed.double") }
                
            )
            .padding(.trailing, 10)
            
            Label(
                title: { Text("\(size) m²") },
                icon: { Image(systemName: "house.fill") }
                
            )
            .padding(.trailing, 10)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(.vertical, 5)
    }
}

//#Preview {
//    AdressView(street: "Gatan", streetNR: 3, city: "Uppsala")
//}
