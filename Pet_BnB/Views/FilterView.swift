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
    
    var body: some View {
        VStack {
            HStack {
                Text("Filter")
                    .font(.largeTitle)
                    .padding()
                Spacer()
                Button("Done") {
                    isPresented = false
                }
                .padding()
            }

            Form {
                Section(header: Text("Number of Beds")) {
                    Stepper(value: $minBeds, in: 1...maxBeds) {
                        Text("Minimum \(minBeds) beds")
                    }
                    Stepper(value: $maxBeds, in: minBeds...150) {
                        Text("Maximum \(maxBeds) beds")
                    }
                }
                Section(header: Text("Size (in sqm)")) {
                    Stepper(value: $minSize, in: 10...maxSize, step: 10) {
                        Text("Minimum \(minSize) sqm")
                    }
                    Stepper(value: $maxSize, in: minSize...1000, step: 10) {
                        Text("Maximum \(maxSize) sqm")
                    }
                }
            }
            Spacer()
        }
    }
}
