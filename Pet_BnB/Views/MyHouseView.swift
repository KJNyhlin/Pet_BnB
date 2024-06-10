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
    @Binding var path: NavigationPath
    @EnvironmentObject var authManager: AuthManager

    
    
    var body: some View {
        VStack(){
        //    NavigationStack{
            if let house = vm.house{
                TabBarView(selectedTab: $vm.selectedTab)
                //                .border(Color.black)

                TabViewBody(vm: vm, house: house)
            } else {
                Spacer()
                NavigationLink(value: ""){
                    FilledButtonLabel(text:"Create House")
                        .frame(maxWidth: 200)
                }
                Spacer()
            }

//                TabView(selection: $vm.selectedTab) {
//
//
//                    
//                    if let house = vm.house {
//                        HouseView(vm: vm, house: house).tag(0)
////                        HouseDetailView(houseId: vm.house?.id ?? "", firebaseHelper: FirebaseHelper(), booked: false, showMyOwnHouse: true).tag(0)
//
//                        //                    TimePeriodView(vm: TimePeriodViewModel(house: house)).tag(1)
//                        MyTimePeriodsView(viewModel: TimePeriodViewModel(house: house)).tag(1)
//                        //                    PetsView(vm:PetsViewModel(pet: nil, house: house)).tag(2)
//                        PetsView(vm: PetsViewModel(pet: nil, house: house)).tag(2)
//                        //                    SignUpView().tag(2)
//                    } else {
//                        NavigationLink(value: ""){
//                            FilledButtonLabel(text:"Create House")
//                                .frame(maxWidth: 200)
//                        }
//                    }
//                    
//                }
     //           .tabViewStyle(.page(indexDisplayMode: .never))

//                Spacer()
                
            //}
        }.onChange(of: authManager.loggedIn){ oldValue, newValue in
            if !newValue {
                vm.selectedTab = 0
            }
        }


        
        
        .onAppear{
            print("Triggers on appear in MYHouse")
            vm.downloadHouse()

            
        }
        .onChange(of: authManager.loggedIn){ oldValue, newValue in
            if newValue{
                vm.downloadHouse()
            } else {
                vm.house = nil
            }
            
        }
//        .border(Color.black)
    }
}

struct TabViewBody: View {
    @ObservedObject var vm: MyHouseViewModel
    var house: House
    @State var tabID = UUID()
    
    var body: some View {
        TabView(selection: $vm.selectedTab) {


            
        //    if let house = vm.house {
                HouseView(vm: vm, house: house).tag(0)
                    .id(tabID)
//                        HouseDetailView(houseId: vm.house?.id ?? "", firebaseHelper: FirebaseHelper(), booked: false, showMyOwnHouse: true).tag(0)

                //                    TimePeriodView(vm: TimePeriodViewModel(house: house)).tag(1)
                MyTimePeriodsView(viewModel: TimePeriodViewModel(house: house)).tag(1)
                //                    PetsView(vm:PetsViewModel(pet: nil, house: house)).tag(2)
                PetsView(vm: PetsViewModel(pet: nil, house: house)).tag(2)
                //                    SignUpView().tag(2)
//            } else {
//                NavigationLink(value: ""){
//                    FilledButtonLabel(text:"Create House")
//                        .frame(maxWidth: 200)
//                }
//            }
            
        }
        .onAppear{
            tabID = UUID()
        }
        .tabViewStyle(.page(indexDisplayMode: .never))
    }
}

struct TabBarView: View {
    @Binding var selectedTab: Int
    var tabBarNames = ["House", "Time periods", "Pets"]
    var body: some View {
        GeometryReader { geometry in
//            ScrollView(.horizontal, showsIndicators: false) {
                HStack(alignment: .center) {
                    ForEach(Array(zip(self.tabBarNames.indices, self.tabBarNames)), id: \.0) { index, name in
                        TabBarItem(selectedTab: self.$selectedTab, tabBarItemName: name, tab: index)
                            .frame(width: geometry.size.width / CGFloat(self.tabBarNames.count))
//                            .border(Color.blue)
                    }
                    
                    


            }
            
            .frame(maxWidth: .infinity)
        }
        .frame(height: 40)
    }
}

struct TabBarItem : View {
    @Binding var selectedTab: Int
    var tabBarItemName: String
    var tab: Int
    var body: some View {
        Button(action: {
            self.selectedTab = tab
        }, label: {
            VStack {
                Spacer()
                Text(tabBarItemName)
                    .frame(maxWidth: .infinity)
                if selectedTab == tab {
                    AppColors.mainAccent
                        .frame(height: 2)
                } else {
                    Color.clear
                        .frame(height: 2)
                }
                
            }
            .frame(maxWidth: .infinity)
            
        })

        .buttonStyle(PlainButtonStyle())
        
        
    }
}

struct HouseView : View {
    @State var showingDeleteAlert: Bool = false
    @ObservedObject var vm : MyHouseViewModel
    var house: House
    var body: some View {
        if let houseID = house.id {
            VStack {
                ScrollView {
                    HouseDetailView(houseId: houseID, firebaseHelper: FirebaseHelper(), booked: false, showMyOwnHouse: true)
                }
                Menu {
                    Button(role: .destructive, action: {

                        showingDeleteAlert = true
                    }
                    ) {
                        Label("Delete", systemImage: "trash")
                        
                    }

                    NavigationLink(value: house){
                        Label("Edit", systemImage: "pencil")
                    }

                    
                }

                
                
            label: {
                FilledButtonLabel(text: "Manage")
            }
                
            .alert(isPresented: $showingDeleteAlert) {
                Alert(title: Text("Delete House"), message: Text("Are you sure you want to delete this house?"), primaryButton: .destructive(Text("Delete")) {
                    vm.deleteHouse()
                }, secondaryButton: .cancel())
            }
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
////
//
//#Preview {
//    AdressView(street: "Gatan", streetNR: 3, city: "Uppsala")
//}
