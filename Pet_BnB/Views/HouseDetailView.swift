//
//  HouseDetailView.swift
//  Pet_BnB
//
//  Created by Maida on 2024-05-16.
//


import SwiftUI
import MapKit
import CoreLocation

struct HouseDetailView: View {
    @StateObject private var viewModel: HouseDetailViewModel
    var houseId: String
    @State var showBookings: Bool = false
    @State private var region = MKCoordinateRegion()
    
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
                            VStack(alignment: .leading, spacing: 10) {
                                Text(house.title)
                                    .font(.title)
                                
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
                                
                                Text("\(house.streetName) \(house.streetNR) , \(house.zipCode) \(house.city)")
                                    .font(.caption)
                                    .bold()
                                
                                Text(house.description)
                                    .fixedSize(horizontal: false, vertical: true)
                                
                            }
                            .padding()
                            .padding(.horizontal, 5)
                            .padding(.top, -10)
                            
                            Rectangle()
                                .fill(AppColors.mainAccent)
                                .frame(width: UIScreen.main.bounds.width * 0.9, height: 0.4)
                                .padding(.vertical, 5)
                                .padding(.horizontal)
                            
                            Text("Location")
                                .font(.headline)
                                .padding(.bottom, -10)
                                .padding(.leading, -173)
                                .padding(.top, 7)
                    
                            if let latitude = house.latitude, let longitude = house.longitude {
                                MapView(coordinate: CLLocationCoordinate2D(latitude: latitude, longitude: longitude))
                                    .frame(height: 300)
                                    .cornerRadius(10)
                                    .padding()
                            }
                            
                            Rectangle()
                                .fill(AppColors.mainAccent)
                                .frame(width: UIScreen.main.bounds.width * 0.9, height: 0.5)
                                .padding(.vertical, 5)
                                .padding(.horizontal)
                            
                            if let owner = viewModel.houseOwner {
                                VStack {
                                    Text("Meet your Host")
                                        .font(.title2)
                                        .padding(.bottom, 8)
                                        .padding(.top, -4)
                                    
                                    NavigationLink(destination: HouseOwnerProfileView(user: owner)) {
                                        if let url = owner.imageURL {
                                            AsyncImage(url: URL(string: url)) { phase in
                                                let size: CGFloat = 100
                                                switch phase {
                                                case .empty:
                                                    ProgressView()
                                                        .frame(width: size, height: size)
                                                case .success(let image):
                                                    image
                                                        .resizable()
                                                        .aspectRatio(contentMode: .fill)
                                                        .frame(width: size, height: size)
                                                        .clipShape(Circle())
                                                        .overlay(
                                                            Circle()
                                                                .stroke(AppColors.mainAccent, lineWidth: 2)
                                                        )
                                                case .failure:
                                                    Image(systemName: "person.circle")
                                                        .resizable()
                                                        .aspectRatio(contentMode: .fill)
                                                        .frame(width: size, height: size)
                                                        .background(Color.gray)
                                                        .clipShape(Circle())
                                                        .overlay(
                                                            Circle()
                                                                .stroke(AppColors.mainAccent, lineWidth: 2)
                                                        )
                                                @unknown default:
                                                    Image(systemName: "person.circle")
                                                        .resizable()
                                                        .aspectRatio(contentMode: .fill)
                                                        .frame(width: size, height: size)
                                                        .background(Color.gray)
                                                        .clipShape(Circle())
                                                        .overlay(
                                                            Circle()
                                                                .stroke(AppColors.mainAccent, lineWidth: 2)
                                                        )
                                                }
                                            }
                                            .padding(.bottom, 10)
                                        }
                                    }
                                    
                                    Text("\(owner.firstName ?? "First Name") \(owner.surName ?? "Last Name")")
                                        .font(.title3)
                                        .bold()
                                        .padding(.bottom, 5)
                                    
                                    Text(owner.aboutMe ?? "No description available")
                                        .font(.body)
                                        .multilineTextAlignment(.center)
                                        .padding(.horizontal)
                                }
                                .padding()
                                
                                Rectangle()
                                    .fill(AppColors.mainAccent)
                                    .frame(width: UIScreen.main.bounds.width * 0.9, height: 0.4)
                                    .padding(.vertical)
                                    .padding(.horizontal)
                            }
                            if let pets = house.pets {
                                VStack {
                                    Text("Meet the Pet")
                                        .font(.title2)
                                    
                                    ForEach(pets) { pet in
                                        VStack {
                                            if let petImageURL = pet.imageURL, let petURL = URL(string: petImageURL) {
                                                AsyncImage(url: petURL) { phase in
                                                    let size: CGFloat = 100
                                                    switch phase {
                                                    case .empty:
                                                        ProgressView()
                                                            .frame(width: size, height: size)
                                                    case .success(let image):
                                                        image
                                                            .resizable()
                                                            .aspectRatio(contentMode: .fill)
                                                            .frame(width: size, height: size)
                                                            .clipShape(Circle())
                                                            .overlay(
                                                                Circle()
                                                                    .stroke(AppColors.mainAccent, lineWidth: 2)
                                                            )
                                                    case .failure:
                                                        Image(systemName: "pawprint.circle")
                                                            .resizable()
                                                            .aspectRatio(contentMode: .fill)
                                                            .frame(width: size, height: size)
                                                            .background(Color.gray)
                                                            .clipShape(Circle())
                                                            .overlay(
                                                                Circle()
                                                                    .stroke(AppColors.mainAccent, lineWidth: 2)
                                                            )
                                                    @unknown default:
                                                        Image(systemName: "pawprint.circle")
                                                            .resizable()
                                                            .aspectRatio(contentMode: .fill)
                                                            .frame(width: size, height: size)
                                                            .background(Color.gray)
                                                            .clipShape(Circle())
                                                            .overlay(
                                                                Circle()
                                                                    .stroke(AppColors.mainAccent, lineWidth: 2)
                                                            )
                                                    }
                                                }
                                                .padding(.bottom, 10)
                                                .padding(.top, -10)
                                            }
                                            
                                            Text(pet.name)
                                                .font(.title3)
                                                .bold()
                                                .padding(.bottom, 5)
                                            
                                            Text(pet.species)
                                                .font(.subheadline)
                                                .padding(.bottom, 5)
                                            
                                            Text(pet.description ?? "No description available")
                                                .font(.body)
                                                .multilineTextAlignment(.center)
                                                .padding(.horizontal)
                                        }
                                        .padding()
                                        .padding(.top,-5)
                                        
                                        Rectangle()
                                            .fill(AppColors.mainAccent)
                                            .frame(width: UIScreen.main.bounds.width * 0.9, height: 0.4)
                                            .padding(.vertical, 10)
                                            .padding(.horizontal)
                                    }
                                }
                            }
                        }
                        
                    } else {
                        ProgressView()
                            .onAppear {
                                viewModel.fetchHouse(byId: houseId)
                            }
                    }
                VStack(alignment: .center){
                    Text("Booking instructions")
                        .font(.headline)
                        .padding(.bottom, 5)
                        .padding(.leading, -173)

                    Text("To book a stay at this house, follow these steps:")
                        .font(.footnote)
                        .padding(.bottom, 5)
                        .padding(.leading, -50)
                        .foregroundColor(.gray)

                    VStack(alignment: .leading, spacing: 10) {
                        Text("1. Browse through the house details and pictures to make sure it meets your requirements.")
                        Text("2. Click on the 'Book' button at the bottom of the screen to book.")
                        Text("3. Check the availability calendar to find suitable dates for your stay.")
                        Text("4. Choose a period.")
                        Text("5. Click on the 'Book' button to confirm.")
                        Text("If you have any questions or need further assistance, feel free to contact the host.")
                    }
                    .font(.body)
                    .padding()
                    .background(Color.gray.opacity(0.1))
                    .cornerRadius(8)
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding()
                .padding(.horizontal, 5)
                .padding(.top, -10)
                
                Rectangle()
                    .fill(AppColors.mainAccent)
                    .frame(width: UIScreen.main.bounds.width * 0.9, height: 0.4)
                    .padding(.vertical, 10)
                    .padding(.horizontal)
                
                VStack(alignment: .center){
                    Text("Cancellation policy")
                    .font(.headline)
                    .padding(.bottom, 7)
                    .padding(.leading, -173)

                Text("This reservation is non-refundable. Once a booking has been confirmed, it is binding and no refunds or changes will be made. We thank you for your understanding and look forward to welcoming you.")
                    .font(.footnote)
                    .foregroundColor(.gray)
                    .multilineTextAlignment(.leading)
                    .padding(.bottom, 60)
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding()
                .padding(.horizontal, 5)
                .padding(.top, -10)
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
                    .toolbar{
                        if let house = viewModel.house,
                           let houseId = house.id{
                            NavigationLink(destination: ChatView(vm:ChatViewModel(toUserID: house.ownerID))){
                                Image(systemName: "envelope.fill")
                                    //.font(.largeTitle)
                                    .padding()
                                    .foregroundColor(AppColors.mainAccent)
                            }
                        }
                    }
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

struct MapView: UIViewRepresentable {
    var coordinate: CLLocationCoordinate2D

    func makeUIView(context: Context) -> MKMapView {
        MKMapView(frame: .zero)
    }

    func updateUIView(_ uiView: MKMapView, context: Context) {
        let annotation = MKPointAnnotation()
        annotation.coordinate = coordinate
        uiView.addAnnotation(annotation)

        let region = MKCoordinateRegion(
            center: coordinate,
            span: MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
        )
        uiView.setRegion(region, animated: true)
    }
}
