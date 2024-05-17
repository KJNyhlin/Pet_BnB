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
                        
                        AsyncImage(url: URL(string: imageUrl)){ phase in
                            switch phase {
                            case .empty:
                                ProgressView()
                                    .frame(height: 200)
                                    .frame(maxWidth: 335)
                            case .success(let image):
                                image
                                    .resizable()
                                    .aspectRatio(contentMode: .fill)
                                    .frame(height: 200)
                                    .frame(maxWidth: 335)
                                    .clipped()
                            case .failure:
                                Image(systemName: "photo")
                                    .resizable()
                                    .aspectRatio(contentMode: .fill)
                                    .frame(height: 200)
                                    .frame(maxWidth: 335)
                                    .background(Color.gray)
                            @unknown default:
                                Image(systemName: "photo")
                                    .resizable()
                                    .aspectRatio(contentMode: .fill)
                                    .frame(height: 200)
                                    .frame(maxWidth: 335)
                                    .background(Color.gray)
                            }
                        }
                        
                        
                        
                        VStack(alignment: .leading){
                            Text(house.title)
                                .font(.title)
                            if let beds = house.beds,
                               let size = house.size{
                                InformationRow(beds: beds, size: size)
                                    
                            }
                           
           
                            if let streetNR = house.streetNR,
                               let streetName = house.streetName,
                               let city = house.city {
                                AdressView(street: streetName, streetNR: streetNR, city: city)
                            }
                            Text(house.description)
                            Spacer()
                            
                            Menu {
                                Button(role: .destructive, action: {
                                    // Handling för när "Delete" väljs
                                }) {
                                    Label("Delete", systemImage: "trash")
                                        
                                }
                                NavigationLink(destination:CreateHouseView(vm: CreateHouseViewModel(house: vm.house))){
                                    Label("Edit", systemImage: "pencil")
                                }

                            } label: {
                                FilledButtonLabel(text: "Manage")
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
    
    var body: some View{
        
        HStack{
            Text("\(street.capitalized) \(streetNR), \(city)")
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
                title: { Text("\(size) m2") },
                icon: { Image(systemName: "house.fill") }
                
            )
            .padding(.trailing, 10)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(.vertical, 5)
    }
}
    
    
    


#Preview {
    AdressView(street: "Gatan", streetNR: 3, city: "Uppsala")
}
