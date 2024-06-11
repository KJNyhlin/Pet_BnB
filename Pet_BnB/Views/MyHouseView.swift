//
//  MyHouseView.swift
//  Pet_BnB
//
//  Created by Jonas Bondesson on 2024-05-15.
//

import SwiftUI

struct MyHouseView: View {
    @StateObject var vm = MyHouseViewModel()
    @Binding var path: NavigationPath
    @EnvironmentObject var authManager: AuthManager
    
    var body: some View {
        VStack(){
            if let house = vm.house{
                TabBarView(selectedTab: $vm.selectedTab)
                TabViewBody(vm: vm, house: house)
            } else {
                Spacer()
                NavigationLink(value: ""){
                    FilledButtonLabel(text:"Create House")
                        .frame(maxWidth: 200)
                }
                Spacer()
            }
            
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
    }
}

struct TabViewBody: View {
    @ObservedObject var vm: MyHouseViewModel
    var house: House
    @State var tabID = UUID()
    
    var body: some View {
        TabView(selection: $vm.selectedTab) {
            HouseView(vm: vm, house: house)
                .tag(0)
                .id(tabID)
            MyTimePeriodsView(viewModel: TimePeriodViewModel(house: house))
                .tag(1)
            PetsView(vm: PetsViewModel(pet: nil, house: house))
                .tag(2)
        }
        .onAppear{
            tabID = UUID()
        }
        .tabViewStyle(.page(indexDisplayMode: .never))
    }
}

struct TabBarView: View {
    @Binding var selectedTab: Int
    @Namespace var namespace
    var tabBarNames = ["House", "Time periods", "Pets"]
    var body: some View {
        GeometryReader { geometry in
            HStack(alignment: .center) {
                ForEach(Array(zip(self.tabBarNames.indices, self.tabBarNames)), id: \.0) { index, name in
                    TabBarItem(selectedTab: self.$selectedTab, namespace: namespace.self, tabBarItemName: name, tab: index)
                        .frame(width: geometry.size.width / CGFloat(self.tabBarNames.count))
                }
            }
            .frame(maxWidth: .infinity)
        }
        .frame(height: 40)
    }
}

struct TabBarItem : View {
    @Binding var selectedTab: Int
    let namespace: Namespace.ID
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
                        .matchedGeometryEffect(id: "underline", in: namespace, properties: .frame)
                } else {
                    Color.clear
                        .frame(height: 2)
                }
            }
            .frame(maxWidth: .infinity)
            .animation(.spring(), value: self.selectedTab)
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
                } label: {
                    FilledButtonLabel(text: "Manage")
                }
            }
            .alert(isPresented: $showingDeleteAlert) {
                Alert(title: Text("Delete House"), message: Text("Are you sure you want to delete this house?"), primaryButton: .destructive(Text("Delete")) {
                    vm.deleteHouse()
                }, secondaryButton: .cancel())
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
