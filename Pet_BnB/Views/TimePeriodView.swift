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
        VStack {
            TabView {
                TimePeriodsCalendarView(viewModel: vm)
            }
            .tabViewStyle(.page(indexDisplayMode: .always))
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
    @ObservedObject var viewModel: TimePeriodViewModel
    
    var body: some View {
        VStack{
            ZStack{
                ForEach(bookings) {booking in
                    if (booking.fromDate.startOfDay ... booking.toDate).contains(date.startOfDay) {
                        viewModel.getColor(from: booking)
                            .clipShape(
                                date.startOfDay == booking.fromDate.startOfDay ?
                                    .rect(
                                        topLeadingRadius: 25.0,
                                        bottomLeadingRadius: 25.0
                                    ) :
                                    date.startOfDay == booking.toDate.startOfDay ?
                                    .rect(
                                        bottomTrailingRadius: 25.0,
                                        topTrailingRadius: 25.0
                                    )
                                :
                                        .rect()
                            )
                            .onTapGesture {
                                if date > Date.now.startOfDay {
                                    viewModel.setDates(date: date)
                                }
                            }
                    }
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
                    .foregroundColor(date.startOfDay == Date.now.startOfDay ? .blue : .black)
                    .background(date.startOfDay <= Date.now.startOfDay ? AppColors.pastDays : Color.clear)
                    .onTapGesture {
                        if date.startOfDay > Date.now.startOfDay {
                            viewModel.setDates(date: date)
                        }
                    }
            }
        }
        .frame( height: 30)
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
