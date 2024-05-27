//
//  HouseDetailView.swift
//  Pet_BnB
//
//  Created by Maida on 2024-05-16.
//


import SwiftUI

struct HouseDetailView: View {
    @StateObject private var viewModel: HouseDetailViewModel
    var houseId: String
    @State var showBookings: Bool = false
    
    init(houseId: String, firebaseHelper: FirebaseHelper) {
        _viewModel = StateObject(wrappedValue: HouseDetailViewModel(firebaseHelper: firebaseHelper))
        self.houseId = houseId
    }
    
    var body: some View {
        ZStack {
            ScrollView {
                    if let house = viewModel.house {
                        VStack () {
                            if let imageUrl = house.imageURL, let url = URL(string: imageUrl) {
                                AsyncImage(url: url) { phase in
                                    switch phase {
                                    case .empty:
                                        ProgressView()
                                            .frame(height: 300)
                                            .frame(maxWidth: 400)
                                    case .success(let image):
                                        image
                                            .resizable()
                                            .aspectRatio(contentMode: .fill)
                                            .frame(height: 300)
                                            .frame(maxWidth: 400)
                                            .clipped()
                                    case .failure:
                                        Image(systemName: "photo")
                                            .resizable()
                                            .aspectRatio(contentMode: .fill)
                                            .frame(height: 300)
                                            .frame(maxWidth: 400)
                                            .background(Color.gray)
                                    @unknown default:
                                        Image(systemName: "photo")
                                            .resizable()
                                            .aspectRatio(contentMode: .fill)
                                            .frame(height: 300)
                                            .frame(maxWidth: 400)
                                            .background(Color.gray)
                                    }
                                }
                            }
                            VStack(alignment: .leading, spacing: 8) {
                                Text(house.title)
                                    .font(.title)
                                
                                Text("\(house.streetName) \(house.streetNR) , \(house.zipCode) \(house.city)")
                                    .font(.footnote)
                                    .fontWeight(.bold)
                                
                                HStack {
                                    Label(
                                        title: { Text("\(house.beds) st") },
                                        icon: { Image(systemName: "bed.double") }
                                    )
                                    .padding(.trailing, 10)
                                    
                                    Label(
                                        title: { Text("\(house.size) m²") },
                                        icon: { Image(systemName: "house.fill") }
                                    )
                                    .padding(.trailing, 10)
                                }
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .padding(.vertical, 5)
                                
                                Text(house.description)
                                    .fixedSize(horizontal: false, vertical: true)
                             
                            }
                            .padding()
                            .padding(.horizontal, 5)
                            .padding(.top, -10)
                        }
                    } else {
                        ProgressView()
                            .onAppear {
                                viewModel.fetchHouse(byId: houseId)
                            }
                    }
                }

            VStack {
                Spacer()
                HStack {
                    Spacer()
                    Button(action: {
                        // Lägg till funktion för bokning
                        showBookings.toggle()
                    })
                    {
                        FilledButtonLabel(text: "Book")
                            .frame(maxWidth: 80)
                            //.fontWeight(.bold)
                    }
                    .padding([.bottom, .trailing], 30)
                    .sheet(isPresented: $showBookings, content: {
                        if let house = viewModel.house {
                            BookingsList(viewModel: viewModel, house: house)
                        }
                    })
                }
            }
        }
    }
}




#Preview {
    HouseDetailView(houseId: "1", firebaseHelper: FirebaseHelper())
}

struct BookingsList: View {
    @StateObject var viewModel : HouseDetailViewModel
    var house : House
    @State var showAlert : Bool = false
    @State var startDate = Date.now
    var body: some View {
        //        DatePicker("Select period", selection: $startDate, displayedComponents: .date)
        //            .datePickerStyle(.graphical)
        VStack {
            BookingCalendarView(viewModel: viewModel)
            ForEach(viewModel.bookings) {booking in
                if viewModel.showBookingsForMonth(booking: booking) {
                    
                    HStack {
                        Text("\(booking.fromDate.formatted(date: .numeric, time: .omitted)) - \(booking.toDate.formatted(date: .numeric, time: .omitted))")
                        if booking.renterID == nil {
                            Image(systemName: viewModel.checkIfChecked(booking: booking) ? "checkmark.square" : "square")
                                .onTapGesture {
                                    
                                    viewModel.setBookingID(booking: booking)
                                }
                        }
                    }
                    
                }
            }
            Button(action: {
                showAlert.toggle()
            }, label: {
                FilledButtonLabel(text: "Book")
                    .frame(width: 100)
                    
            })
            .disabled(viewModel.selectedBookingID == "")
        }
        .alert("Do you want to reserv the time period?", isPresented: $showAlert) {
            
            Button("No", role: .cancel) {}
            Button("Yes", role: .none) {
                
                if let houseID = house.id
                {
                    viewModel.bookHouse(houseID: houseID)
                }
            }
        }
    }
}


struct BookingCalendarView: View{
    
    
    
    @ObservedObject var viewModel: HouseDetailViewModel
    
    var body: some View{
        VStack{
            CalendarHeader(date: $viewModel.date, viewModel: viewModel)
                .frame(maxWidth: .infinity)
                .foregroundColor(.black)
                
            CalendarBodyView(days: $viewModel.daysInMonth, viewModel: viewModel)
                .padding(10)
            
        }
    }
}


struct CalendarBodyView: View{
    
    
    
    @Binding var days: [Date]
    var dateManager = DateManager()
    var viewModel: HouseDetailViewModel
    
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
                CalendarDayView(dayNumber: dayNumber, bookings: viewModel.bookings, date: day, viewModel: viewModel)
                    
            }
        }
    }
}

struct CalendarDayView: View {
    var dayNumber: Int
    var bookings: [Booking]
    var date: Date
    @State var bookingColor = Color.blue
    @ObservedObject var viewModel: HouseDetailViewModel
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
                                    print("fromDate: \(booking.fromDate)")
                                print("SelectedDate: \(date)")
                                    viewModel.setBookingID(booking: booking)
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
                            print("!!!")
                                viewModel.setBookingID(booking: booking)
                            }
                            
                    }
                    
                    else if (booking.fromDate.startOfDay ... booking.toDate).contains(date.startOfDay) {
                        viewModel.getColor(from: booking)
                            .onTapGesture {
                            print("!!!")
                                viewModel.setBookingID(booking: booking)
                            }
                            
                    }
                    Text("")
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                        
                        
                    
                }
                
                Text("\(dayNumber)")
                    .font(.caption)
                    .bold()
            }
        }
        .frame( height: 30)
//        .padding(8)
//        .border(Color.black)
//        .clipShape(/*@START_MENU_TOKEN@*/Circle()/*@END_MENU_TOKEN@*/)
        
        
    }
}

struct CalendarHeader: View {
    @Binding var date: Date
    @ObservedObject var viewModel: HouseDetailViewModel
    
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

