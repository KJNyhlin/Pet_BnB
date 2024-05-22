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
    @State private var showAddPeriodSheet = false
    
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

                                .bold()
                           
//                            VStack{
//                                Text("Pets:")
//                                    .font(.subheadline)
//                                ScrollView{
//                                    VStack(alignment: .leading){
//
//                                        PetsView(vm: PetsViewModel(pets: house.pets))
//                                    }
//                                }
//                            }
//                            .padding(.vertical)
//                            

                            TimePeriodList(vm: vm)

                            Spacer()
                            
                            Menu {
                                Button(role: .destructive, action: {
                                    //vm.deleteHouse()
                                    showingDeleteAlert = true
                                }
                                ) {
                                    Label("Delete", systemImage: "trash")
                                    
                                }
                                if let house = vm.house{
    
                                    NavigationLink(destination:CreateHouseView(vm: CreateHouseViewModel(house: vm.house))){
                                        Label("Edit", systemImage: "pencil")
                                    }

                                    NavigationLink(destination:PetsView(vm: CreatePetViewModel(pet: nil, house: house))){
                                        Label("Pets", systemImage: "pawprint.fill")
                                    }
                                }

                                Button(action: {
//                                    vm.saveTimePeriod()
                                    showAddPeriodSheet.toggle()
                                }, label: {
                                    Text("Add period")
                                })

                                
                            } label: {
                                FilledButtonLabel(text: "Manage")
                            }
                            .alert(isPresented: $showingDeleteAlert) {
                                Alert(title: Text("Delete House"), message: Text("Are you sure you want to delete this house?"), primaryButton: .destructive(Text("Delete")) {
                                    vm.deleteHouse()
                                }, secondaryButton: .cancel())
                            }
                            .sheet(isPresented: $showAddPeriodSheet, content: {
                                AddPeriodSheet(vm: vm, showAddPeriodSheet: $showAddPeriodSheet)
                            })
                            
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

struct  TimePeriodList : View {
    @StateObject var vm : MyHouseViewModel
    var body: some View {
        List(vm.myTimePeriods) {
            Text("\($0.fromDate.formatted(date: .numeric, time: .omitted)) - \($0.toDate.formatted(date: .numeric, time: .omitted))")
        }
    }
}

struct AddPeriodSheet: View {
    @StateObject var vm : MyHouseViewModel
    @State var startDate = Date.now
    @State var endDate = Date.now
    @Binding var showAddPeriodSheet : Bool
    
    var body: some View {
        VStack {
            Text("Select a time period for others to book")
            DatePicker(selection: $startDate, in: Date.now..., displayedComponents: .date) {
                    Text("Select a date")
                }
            
            
            DatePicker(selection: $endDate, in: Date.now..., displayedComponents: .date) {
                    Text("Select a date")
                }
            Button(action: {
                vm.saveTimePeriod(startDate: startDate, endDate: endDate)
                showAddPeriodSheet.toggle()
                
            }, label: {
                Text("Save")
            })
            
        }
    }
}

//#Preview {
//    AdressView(street: "Gatan", streetNR: 3, city: "Uppsala")
//}
