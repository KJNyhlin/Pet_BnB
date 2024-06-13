//
//  CreateHouseView.swift
//  Pet_BnB
//
//  Created by Kristian Thun on 2024-05-15.
//

import SwiftUI
import PhotosUI
import MapKit
import CoreLocation
import CoreLocationUI

struct CreateHouseView: View {
    @StateObject var vm: CreateHouseViewModel
    @EnvironmentObject var firebaseHelper: FirebaseHelper
    @Environment(\.presentationMode) var presentationMode
    let locationManager = LocationManager()

    @FocusState private var focusedField: Field?
    @State private var showAlert = false
    @State private var isSaving = false

    enum Field {
        case title, beds, size, streetName, streetNR, zipCode, city, description, latitude, longitude
    }

    var body: some View {

            VStack {
                Form {
                    PhotosPicker(selection: $vm.imageSelection, matching: .images) {
                        if let image = vm.image {
                            Image(uiImage: image)
                                .resizable()
                                .scaledToFit()
                                .frame(maxWidth: .infinity, maxHeight: 200)
                        } else {
                            Image(systemName: "photo.badge.plus")
                                .resizable()
                                .scaledToFit()
                                .frame(maxWidth: .infinity, maxHeight: 200)
                        }
                    }

                    Section(header: Text("Information")) {
                        NewHouseFormRowView(rowTitle: "Title", rowValue: $vm.title)
                            .focused($focusedField, equals: .title)
                        NewHouseFormRowView(rowTitle: "Beds", rowValue: $vm.beds, keyboardType: .numberPad)
                            .focused($focusedField, equals: .beds)
                        NewHouseFormRowView(rowTitle: "m²", rowValue: $vm.size, keyboardType: .numberPad)
                            .focused($focusedField, equals: .size)
                    }
                    Section(header: Text("Address")) {
                        NewHouseFormRowView(rowTitle: "Street", rowValue: $vm.streetName)
                            .focused($focusedField, equals: .streetName)
                        NewHouseFormRowView(rowTitle: "Number", rowValue: $vm.streetNR, keyboardType: .numberPad)
                            .focused($focusedField, equals: .streetNR)
                        NewHouseFormRowView(rowTitle: "Zip code", rowValue: $vm.zipCode, keyboardType: .numberPad)
                            .focused($focusedField, equals: .zipCode)
                        NewHouseFormRowView(rowTitle: "City", rowValue: $vm.city)
                            .focused($focusedField, equals: .city)
                    }
                    
                    Section(header: Text("Location")) {
                        
                        if let lat = vm.latitude, let lng = vm.longitude {
                            let startPosition = MapCameraPosition.region(
                                MKCoordinateRegion(
                                    center: CLLocationCoordinate2D(latitude: lat, longitude: lng),
                                    span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01)
                                )
                            )
                            houseMap(vm: vm, position: startPosition, locations: [Location(id: UUID(), latitude: lat, longitude: lng)], noLocation: false)
                                .frame(height: 150)
                        } else {
                            let startPosition = MapCameraPosition.userLocation(fallback: .automatic)
                            houseMap( vm: vm, position: startPosition, locations: [], noLocation: true)
                                .frame(height: 150)
                        }

                    }

                    Section(header: Text("Description")) {
                        TextEditor(text: $vm.description)
                            .frame(minHeight: 100)
                            .focused($focusedField, equals: .description)
                        Button(action: {
                            saveHouse()
                        }, label: {
                            FilledButtonLabel(text: "Save")
                                .padding(.vertical, 10)
                                .padding(.horizontal, 30)
                        })
                        .disabled(vm.savingInProgress)
                    }
                }
            }
            .navigationTitle(vm.house == nil ? "Create House" : "Edit House")
            .toolbar {
                ToolbarItemGroup(placement: .keyboard) {
                    Spacer()
                    Button("Done") {
                        focusedField = nil
                    }
                }
            }
            .navigationBarBackButtonHidden(true)
            .navigationBarItems(leading: Button(action: {
                if vm.hasUnsavedChanges() {
                    showAlert = true
                } else {
                    self.presentationMode.wrappedValue.dismiss()
                }
            }) {
                Image(systemName: "chevron.left")
                    .foregroundColor(.blue)
            })
            .alert(isPresented: $showAlert) {
                Alert(
                    title: Text("Don't you want to save your changes?"),
                    message: Text("You have unsaved changes."),
                    primaryButton: .destructive(Text("Discard changes")) {
                        self.presentationMode.wrappedValue.dismiss()
                    },
                    secondaryButton: .default(Text("Save")) {
                        saveHouse()
                    }
                )
 
        }
            .onAppear() {
                    locationManager.startLocationUpdates()
            }

    }

    private func saveHouse() {
        hideKeyboard()
        isSaving = true
        vm.saveHouse() { success in
            if success {
                isSaving = false
                DispatchQueue.main.async {
                    self.presentationMode.wrappedValue.dismiss()
                }
            } else {
                vm.saveing(inProgress: false)
            }
        }
    }

    private func hideKeyboard() {
        focusedField = nil
    }
}

struct NewHouseFormRowView: View {
    var rowTitle: String
    @Binding var rowValue: String
    var keyboardType: UIKeyboardType = .default

    @FocusState private var isFocused: Bool

    var body: some View {
        HStack {
            Text("\(rowTitle):")
                .bold()
            TextField(rowTitle, text: $rowValue)
                .keyboardType(keyboardType)
                .focused($isFocused)
        }
    }
}




//#Preview {
//    CreateHouseView()
//}


struct houseMap: View {

    @ObservedObject var vm: CreateHouseViewModel
    @State var position: MapCameraPosition
    @State var locations : [Location]
    var noLocation: Bool
    
    var body: some View {
        MapReader { proxy in
            Map(initialPosition: position) {
                ForEach(locations) { location in
                        Marker("", coordinate: CLLocationCoordinate2D(latitude: location.latitude, longitude: location.longitude))
                    }
                
            }
            .onTapGesture {position in
                if let coordinate = proxy.convert(position, from: .local) {
                    let newLocation = Location(id: UUID(), latitude: coordinate.latitude, longitude: coordinate.longitude)
                    locations.removeAll()
                        locations.append(newLocation)
                    vm.latitude = coordinate.latitude
                    vm.longitude = coordinate.longitude
                            }
                
            }
            
        }
        
    }
}

struct Location: Codable, Equatable, Identifiable {
    let id: UUID
    var latitude: Double
    var longitude: Double
}

