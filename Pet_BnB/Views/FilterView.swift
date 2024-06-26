//
//  FilterView.swift
//  Pet_BnB
//
//  Created by Maida on 2024-05-22.
//

import SwiftUI

struct FilterView: View {
    @Binding var isPresented: Bool
    @Binding var minBeds: Int
    @Binding var maxBeds: Int
    @Binding var minSize: Int
    @Binding var maxSize: Int
    @State private var isBedsFilterOn: Bool = false
    @State private var isSizeFilterOn: Bool = false
    @Binding var selectedAnimalType: String
    let animalTypes: [String]
    
    var body: some View {
        ZStack {
            VStack {
                HStack {
                    Text("Add Search Criteria")
                        .font(.title.bold())
                        .padding()
                    Spacer()
                    Button("Done") {
                        isPresented = false
                    }
                    .padding()
                }
                
                Form {
                    Section(header: Text("Number of Beds")) {
                        Toggle(isOn: $isBedsFilterOn) {
                            Text("Beds Filter")
                        }
                        .padding(.bottom, 5)
                        
                        if isBedsFilterOn {
                            Stepper(value: $minBeds, in: 1...maxBeds) {
                                Text("Minimum \(minBeds) beds")
                            }
                            Stepper(value: $maxBeds, in: minBeds...150) {
                                Text("Maximum \(maxBeds) beds")
                            }
                        }
                    }
                    Section(header: Text("Size (in sqm)")) {
                        Toggle(isOn: $isSizeFilterOn) {
                            Text("Size Filter")
                        }
                        .padding(.bottom, 5)
                        
                        if isSizeFilterOn {
                            Stepper(value: $minSize, in: 10...maxSize, step: 10) {
                                Text("Minimum \(minSize) sqm")
                            }
                            Stepper(value: $maxSize, in: minSize...1000, step: 10) {
                                Text("Maximum \(maxSize) sqm")
                            }
                        }
                    }
                    Section(header: Text("Animal Type")) {
                        Picker("Animal Type", selection: $selectedAnimalType) {
                            ForEach(animalTypes, id: \.self) { type in
                                Text(type).tag(type)
                            }
                        }
                            .pickerStyle(WheelPickerStyle())
                            .frame(height: 120)
                    }
                }
                .background(Color(UIColor.systemGray6))
                .cornerRadius(10)
                .shadow(radius: 5)
                .padding()
                
                Spacer()
            }
        }
            .onChange(of: isBedsFilterOn) { newValue in
               if !newValue {
                   minBeds = 1
                   maxBeds = 150
               }
           }
           .onChange(of: isSizeFilterOn) { newValue in
               if !newValue {
                   minSize = 10
                   maxSize = 1000
               }
           }
           .onChange(of: selectedAnimalType) { newValue in
           }
           .onAppear {
                isBedsFilterOn = minBeds > 1 || maxBeds < 150
                isSizeFilterOn = minSize > 10 || maxSize < 1000
        }
    }
}
