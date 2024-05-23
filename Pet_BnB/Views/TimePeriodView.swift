//
//  TimePeriodView.swift
//  Pet_BnB
//
//  Created by Jonas Bondesson on 2024-05-23.
//

import SwiftUI

struct TimePeriodView: View {
    @StateObject var vm : TimePeriodViewModel
    var body: some View {
        Section {
            addTimePeriod(vm: vm)
        }
}

struct addTimePeriod : View {
    @ObservedObject var vm : TimePeriodViewModel
    var body: some View {
        VStack {
            Text("Select a time period for others to book")
            DatePicker(selection: $vm.startDate, in: Date.now..., displayedComponents: .date) {
                    Text("Select a date")
                }
            
            
            DatePicker(selection: $vm.endDate, in: Date.now..., displayedComponents: .date) {
                    Text("Select a date")
                }
            Button(action: {
                vm.saveTimePeriod(startDate: vm.startDate, endDate: vm.endDate, house: vm.house)
                
                
            }, label: {
                Text("Save")
            })
            
        }
    }
    }
}

//
//#Preview {
//    TimePeriodView()
//}
