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
    @State var booked: Bool
    @State var showReviewSheet: Bool = false
    var showMyOwnHouse: Bool
    
    init(houseId: String, firebaseHelper: FirebaseHelper, booked: Bool, showMyOwnHouse: Bool) {
        _viewModel = StateObject(wrappedValue: HouseDetailViewModel(firebaseHelper: firebaseHelper))
        self.houseId = houseId
        self.booked = booked
        self.showMyOwnHouse = showMyOwnHouse
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
                                    Image(systemName: "star.fill")
                                        .foregroundColor(AppColors.mainAccent)
                                    if let rating = house.getAverageRating() {
                                        Text("\(rating, specifier: "%.1f")")
                                            .foregroundColor(AppColors.mainAccent)
                                        Button(action: {
                                            showReviewSheet.toggle()
                                        }, label: {
                                            Text("Read reviews")
                                        })
                                    } else {
                                        Text("No ratings yet")
                                            .foregroundColor(AppColors.mainAccent)
                                    }
                                }
                                    .font(.caption)
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
                                
                                Button(action: {
                                    if let latitude = house.latitude, let longitude = house.longitude {
                                        openMapsForDirections(latitude: latitude, longitude: longitude)
                                    }
                                }) {
                                    Text("\(house.streetName) \(house.streetNR) , \(house.zipCode) \(house.city)")
                                        .font(.caption)
                                        .bold()
                                }
                                
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
                            
                            if let latitude = house.latitude, let longitude = house.longitude {
                                if latitude != 0.0 && longitude != 0.0 {
                                    Text("Location")
                                        .font(.headline)
                                        .padding(.leading, -173)
                                        .padding(.top, 7)
                                        .padding(.bottom, 1)
                                    
                                    Text("Where you’ll be")
                                        .font(.footnote)
                                        .padding(.leading, -172)
                                        .foregroundColor(.gray)
                                        .padding(.bottom, -12)
                            
                                    if let latitude = house.latitude, let longitude = house.longitude {
                                        MapView(coordinate: CLLocationCoordinate2D(latitude: latitude, longitude: longitude))
                                            .frame(height: 280)
                                            .frame(width: 355)
                                            .cornerRadius(10)
                                            .padding()
                                    }
                                    
                                    if let latitude = viewModel.house?.latitude, let longitude = viewModel.house?.longitude {
                                        Button("Get directions") {
                                            openMapsForDirections(latitude: latitude, longitude: longitude)
                                        }
                                            .font(.footnote)
                                            .frame(maxWidth: 110)
                                            .foregroundColor(.white)
                                            .padding(.vertical, 7)
                                            .background(AppColors.mainAccent)
                                            .cornerRadius(20)
                                            .fontWeight(.bold)
                                            .padding(.leading, -179)
                                            .padding(.top, -10)
                                    }
                            
                                    Rectangle()
                                        .fill(AppColors.mainAccent)
                                        .frame(width: UIScreen.main.bounds.width * 0.9, height: 0.4)
                                        .padding(.vertical, 5)
                                        .padding(.horizontal)
                                }
                            }
                            
                            if let owner = viewModel.houseOwner {
                                VStack {
                                    Text("Meet your Host")
                                        .font(.title2)
                                        .padding(.bottom, 8)
                                        .padding(.top, -4)
                                    
                                  //  NavigationLink(destination: HouseOwnerProfileView(user: owner)) {
                                    NavigationLink(value: owner) {
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
                                                .padding(.bottom, 5)
                                            
                                            Section(header: Text("Pet Rules:")) {
                                                ForEach(pet.information, id: \.self) { rule in
                                                    HStack {
                                                        Image(systemName: "pawprint.fill")
                                                            .foregroundColor(.yellow)
                                                        Text(rule)
                                                    }
                                                }
                                            }
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
                    if !booked {
                        if !showMyOwnHouse {
                            Button(action: {
                                // Lägg till funktion för bokning
                                showBookings.toggle()
                            })
                            {
                                FilledButtonLabel(text: "Reserv")
                                    .frame(maxWidth: 80)
                                //.fontWeight(.bold)
                            }
                            .padding([.bottom, .trailing], 30)
                            
                            .sheet(isPresented: $showBookings, onDismiss: {
                                viewModel.selectedBooking = nil
                                viewModel.selectedBookingID = ""
                            } ,content: {
                                if let house = viewModel.house {
                                    BookingsList(viewModel: viewModel, house: house)
                                        .presentationDetents([.medium])
                                }
                            })
                        } else {
                            Text("")
                        }
                    }
                    
                }
                .sheet(isPresented: $showReviewSheet, content: {
                    ReadReviewSheet(viewModel: viewModel, houseId: houseId)
                })
                .toolbar{
                    if let house = viewModel.house,
                       let houseId = house.id, !showMyOwnHouse{
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
    
    func openMapsForDirections(latitude: Double, longitude: Double) {
            let destinationCoordinate = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
            let placemark = MKPlacemark(coordinate: destinationCoordinate)
            let mapItem = MKMapItem(placemark: placemark)
            mapItem.name = "Destination"
            mapItem.openInMaps(launchOptions: [MKLaunchOptionsDirectionsModeKey: MKLaunchOptionsDirectionsModeDriving])
        }
}

struct ReadReviewSheet: View {
    @ObservedObject var viewModel : HouseDetailViewModel
    var houseId: String
    @State var selectedUser: User? = nil
    
    var body: some View {
        ScrollView {
            VStack {
                if selectedUser == nil {
                    ForEach(viewModel.reviews) {review in
                        reviewCardView(review: review, user: viewModel.loadReviewerInfo(reviewerID: review.userID), selectedUser: $selectedUser)
                        
                            .padding(.horizontal, 20)
                        
                    }
                    .transition(.slide)
                } else if let user = selectedUser {
                    ReviewProfileView(user: user, selectedUser: $selectedUser)
                        
                        .transition(.slide)
                    }
                
            }
            
            .onAppear() {
                viewModel.getReviews(houseID: houseId)
                
            }
        }
        .padding(.vertical, 50)
    }
}

struct ReviewProfileView: View {
    var user: User
    @Binding var selectedUser: User?
    var body: some View {
        VStack {
            Image(systemName: "chevron.left")
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.leading, 20)
                .foregroundColor(AppColors.mainAccent)
                .onTapGesture { withAnimation() {
                    
                    selectedUser = nil
                }
                }
            
            HouseOwnerProfileView(user: user)
                .padding(.top, 60)
                
        }
        
    }
}

struct reviewCardView : View {
    var review: Review
    var user: User?
    @Binding var selectedUser: User?
    var body: some View {
        
            if let user = user {
                VStack {
                    HStack {
                        
//                        NavigationLink(destination: HouseOwnerProfileView(user: user)) { //Funkar inte än, väntar på kristians lösning
                            Text("\(user.firstName ?? "Unknown user")")
                                .font(.caption)
                                .padding(.leading, 20)
                                .onTapGesture {
                                    selectedUser = user
                                    //------------------------------------------------------------------------
                                }
//                        }
                        Text("\(review.date.formatted(date: .numeric, time: .omitted))")
                            .font(.caption)
                            .foregroundColor(.gray)
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding([.leading, .top], 10)
                    RatingStars(totalStars: 5, rating: review.rating)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.leading, 20)
                        .padding(.top, 5)
                    if let title = review.title, let text = review.text {
                        if text != "" && title != "" {
                            Text(title)
                                .font(.system(size: 16))
                                .fontWeight(.bold)
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .padding([.horizontal, .top], 20)
                            
                            Text(text)
                                .font(.system(size: 14))
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .padding([.horizontal, .bottom], 20)
                        } else {
                            Text("No written review.")
                                .font(.system(size: 16))
                                .fontWeight(.bold)
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .padding(.horizontal, 20)
                                .padding(.top, 5)
                        }
                    }
                }
                .frame(maxWidth: .infinity ,minHeight: 80)
                .background(Color.white)
                .cornerRadius(20)
                .shadow(radius: 5)
                .padding(.vertical, 8)
            }
        }
    
}

struct RatingStars : View {
    var totalStars: Int
    var rating: Int
    
    var offColor = Color.gray
    var onColor = Color.yellow
    
    var body: some View {
        HStack {
            ForEach(1..<totalStars + 1, id: \.self) { number in
                Image(systemName: "star.fill")
                    .foregroundStyle(number > rating ? offColor : onColor)
            }
        }
    }
}

//
//
//#Preview {
//    HouseDetailView(houseId: "1", firebaseHelper: FirebaseHelper(),booked: false)
//}

struct BookingsList: View {
    @StateObject var viewModel : HouseDetailViewModel
    @Environment(\.dismiss) var dismiss
    var house : House
    @State var showAlert : Bool = false
    @State var startDate = Date.now
    var body: some View {

        VStack {
            BookingCalendarView(viewModel: viewModel)
            
            Text("Selcted period: \(viewModel.selectedBooking?.fromDate.formatted(date: .numeric, time: .omitted) ?? "") - \(viewModel.selectedBooking?.toDate.formatted(date: .numeric, time: .omitted) ?? "")")
                .opacity(viewModel.selectedBooking == nil ? 0.0 : 1.0)
                
            
            Button(action: {
                showAlert.toggle()
            }, label: {
                FilledButtonLabel(text: "Reserv")
                    .frame(width: 100)
                    
            })
            .disabled(viewModel.selectedBookingID == "")
        }
        .alert("Do you want to reserv the time period? Host will have to confirm it.", isPresented: $showAlert) {
            
            Button("No", role: .cancel) {}
            Button("Yes", role: .none) {
                
                if let houseID = house.id
                {
                    if viewModel.selectedBookingID != "" {
//                        viewModel.bookHouse(houseID: houseID)
                        viewModel.firebaseHelper.bookPeriod(houseID: houseID, docID: viewModel.selectedBookingID) {success in
                            if success {
                                dismiss()
                            }
                            
                        }
                    }
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
        .foregroundColor(date.startOfDay == Date.now.startOfDay ? .blue : .black)
        .background(date.startOfDay <= Date.now.startOfDay ? AppColors.pastDays : Color.clear)
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
