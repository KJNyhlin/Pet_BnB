//
//  TimePeriodView.swift
//  Pet_BnB
//
//  Created by Jonas Bondesson on 2024-05-23.
//

import SwiftUI

struct TimePeriodView: View {
    @StateObject var vm : TimePeriodViewModel
//    @State var date = Date.now
//    @State private var dates: Set<DateComponents> = []

    
    var body: some View {
        VStack {
            TabView {
               TimePeriodsCalendarView(viewModel: vm)
//                DatePicker("Select date", selection: $date, displayedComponents: .date)
//                    .datePickerStyle(.graphical)
                    
//                addTimePeriod(vm: vm)
                
            }
            .tabViewStyle(.page(indexDisplayMode: .always))
//            BookingList(vm: vm)
            Button(action: {
                vm.saveTimePeriod()
            }, label: {
                FilledButtonLabel(text: "Create Time Period")
                    .frame(width: 200)
            })
            .disabled(vm.startDate == nil)
            
        }
        .onAppear {
            vm.getTimePeriods()
        }
    }
        
}

struct addTimePeriod : View {
    @ObservedObject var vm : TimePeriodViewModel
    var body: some View {
        VStack {
            
//            Text("Select a time period for others to book")
//            DatePicker(selection: $vm.startDate, in: Date.now..., displayedComponents: .date) {
//                    Text("Select a date")
//                }
//            
//            
//            DatePicker(selection: $vm.endDate, in: Date.now..., displayedComponents: .date) {
//                    Text("Select a date")
//                }
//            Button(action: {
//                vm.saveTimePeriod(startDate: vm.startDate, endDate: vm.endDate, house: vm.house)
//                
//                
//            }, label: {
//                Text("Save")
//            })
            
        }
    }
    }


struct BookingList : View {
    @ObservedObject var vm : TimePeriodViewModel
    
    var body: some View {
        ScrollView {
            ForEach(vm.allMyTimePeriods) {timePeriod in
                AddTimePeriodCard(vm: vm, timePeriod: timePeriod)
//                Text("timePeriod.houseID")
                
            }
//            ForEach(vm.myPastTimePeriods) {timePeriod in
//                HStack {
//                    Text("\(timePeriod.fromDate.formatted(date: .numeric, time: .omitted)) - \(timePeriod.toDate.formatted(date: .numeric, time: .omitted))")
//                    if timePeriod.renterID == nil {
//                        Button(action: {
//                            vm.firebaseHelper.remove(timePeriod: timePeriod, for: vm.house)
//                        }, label: {
//                            Image(systemName: "trash")
//                        })
//                    }
//                }
//                
//            }
            
        }
    }
}

struct TimePeriodsCalendarView: View{
    
    
    
    @ObservedObject var viewModel: TimePeriodViewModel
    
    var body: some View{
        VStack{
            TimePeriodsCalendarHeader(date: $viewModel.date, viewModel: viewModel)
                .frame(maxWidth: .infinity)
                .foregroundColor(.black)
                
            TimePeriodsCalendarBodyView(days: $viewModel.daysInMonth, viewModel: viewModel)
                .padding(10)
            
        }
    }
}


struct TimePeriodsCalendarBodyView: View{
    
    
    
    @Binding var days: [Date]
    var dateManager = DateManager()
    var viewModel: TimePeriodViewModel
    
    let columns = Array(repeating: GridItem(.flexible(), spacing: 0), count: 7)
    var body: some View{
        LazyVGrid(columns: columns, spacing: 0) {
            Text("Mo")
            Text("Tu")
            Text("We")
            Text("Th")
            Text("Fr")
            Text("Sa")
            Text("Su")
            ForEach(0..<dateManager.getFirstWeekdayIndex(from: days), id: \.self) { _ in
                Spacer()
            }
            ForEach(days, id: \.self) { day in
                let dayNumber = Calendar.current.component(.day, from: day)
                TimePeriodsCalendarDayView(dayNumber: dayNumber, bookings: viewModel.allMyTimePeriods, date: day.formattedForBooking, viewModel: viewModel)
                    
            }
        }
    }
}

struct TimePeriodsCalendarDayView: View {
    var dayNumber: Int
    var bookings: [Booking]
    var date: Date
    
    @State var bookingColor = Color.blue
    @ObservedObject var viewModel: TimePeriodViewModel
    var body: some View {
        VStack{
            ZStack{
                ForEach(bookings) {booking in
                    
//                    if Calendar.current.isDate(date, inSameDayAs: booking.fromDate) {
                    if date.startOfDay == booking.fromDate.startOfDay {
                        viewModel.getColor(from: booking)
                            .clipShape(
                                .rect(
                                    topLeadingRadius: 25.0,
                                    bottomLeadingRadius: 25.0
                                ))
                            
                            .onTapGesture {
                                print("!")
                                //                                    viewModel.setBookingID(booking: booking)
                                if date > Date.now.startOfDay {
                                    viewModel.setDates(date: date)
                                }
                            }
                    
                            
//                    } else if Calendar.current.isDate(date, inSameDayAs: booking.toDate) {
                    } else if date.startOfDay == booking.toDate.startOfDay {
                        viewModel.getColor(from: booking)
                            .clipShape(
                                .rect(
                                    bottomTrailingRadius: 25.0,
                                    topTrailingRadius: 25.0
                                ))
                            .onTapGesture {
                            print("!!")
//                                viewModel.setBookingID(booking: booking)
                                viewModel.setDates(date: date)
                            }
                            
                    }
                    
                    else if (booking.fromDate.startOfDay ... booking.toDate).contains(date.startOfDay) {
                        viewModel.getColor(from: booking)
                            .onTapGesture {
                            print("!!!")
//                                viewModel.setBookingID(booking: booking)
                                viewModel.setDates(date: date)
                            }
                            
                    }
//                    Text("")
//                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                        
                        
                    
                }
                if let startDate = viewModel.startDate {
                    if Calendar.current.isDate(startDate, inSameDayAs: date) {
                        Color.green
                    }
                }
                if let endDate = viewModel.endDate {
                    if Calendar.current.isDate(endDate, inSameDayAs: date) {
                        Color.green
                    }
                }
                if let startDate = viewModel.startDate, let endDate = viewModel.endDate {
                    if (startDate ... endDate).contains(date) {
                        Color.green
                    }
                }
                Text("\(dayNumber)")
                    .font(.caption)
                    .bold()
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
//                    .border(Color.black)
                    .foregroundColor(date.startOfDay == Date.now.startOfDay ? .blue : .black)
                    .background(date.startOfDay <= Date.now.startOfDay ? AppColors.pastDays : Color.clear)
                    .onTapGesture {
                        
                        viewModel.setDates(date: date)
                    }
            }
        }
        .frame( height: 30)
//        .padding(8)
//        .border(Color.black)
//        .clipShape(/*@START_MENU_TOKEN@*/Circle()/*@END_MENU_TOKEN@*/)
        
        
    }
}

struct TimePeriodsCalendarHeader: View {
    @Binding var date: Date
    @ObservedObject var viewModel: TimePeriodViewModel
    
    var body: some View {
        HStack{
            Button(action: {
                viewModel.previousMonth()
                
            }, label: {
                Image(systemName: "chevron.left")
            })
            .padding()
            
            Text(date.monthName)
                .frame(width: 150)
            
            Button(action: {
                viewModel.nextMonth()
                
            }, label: {
                Image(systemName: "chevron.right")
            })
            .padding()
        }
    }
}

struct AddTimePeriodCard : View {
    @ObservedObject var vm : TimePeriodViewModel
    var timePeriod : Booking
    var body: some View {
        HStack {
            Text("\(timePeriod.fromDate.formatted(date: .numeric, time: .omitted)) - \(timePeriod.toDate.formatted(date: .numeric, time: .omitted))")
            if timePeriod.renterID == nil {
                Button(action: {
                    vm.firebaseHelper.remove(timePeriod: timePeriod)
                }, label: {
                    Image(systemName: "trash")
                })
            }
        }
        .frame(width: 300, height: 80)
        .background(Color.white)
        
        .cornerRadius(20)
        .shadow(radius: 5)
        
        .padding(.vertical, 8)

        .buttonStyle(PlainButtonStyle())
    }
}




//
//#Preview {
//    TimePeriodView()
//}
