//
//  MyBookingsView.swift
//  Pet_BnB
//
//  Created by Jonas Bondesson on 2024-05-15.
//

import SwiftUI

struct MyBookingsView: View {
    @StateObject var viewModel = MyBookingViewModel()
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 0){
                    
                    Section(header: Text("My bookings")
                        .font(.title)
                        .fontWeight(.bold)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding()) {
                            
                            
                            ForEach (viewModel.myBookings){ booking in
                                BookingCardView(viewModel: viewModel, booking: booking)
                            }
                        }
                    Section(header: Text("My history")
                        .font(.title)
                        .fontWeight(.bold)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding()) {
                            
                            
                            ForEach (viewModel.myBookingHistory){ booking in
                                
                                    BookingCardView(viewModel: viewModel, booking: booking)
                            
                            }
                        }
                    Spacer()
                }
                .onAppear {
                    viewModel.getBookings()
                }
            }
        }
    }
}



struct BookingCardView : View {
    @ObservedObject var viewModel : MyBookingViewModel
    var booking : Booking
    @State var house : House?
    @State var showAddRating: Bool = false
    
    var body: some View {
        NavigationLink(destination: BookingView(house: house, booking: booking)) {
            VStack(alignment: .leading, spacing: 0) {
                VStack(alignment: .leading, spacing: 0) {
                    if let confirmed = booking.confirmed {
                        if booking.toDate > Date.now {
                            Text(!confirmed && booking.toDate > Date.now ? "Not Yet Confirmed" : "Confirmed")
                            //                        .frame(width: 150)
                                .frame(maxWidth: .infinity, alignment: .top)
                                .padding(.horizontal, 2)
                                .background(viewModel.getShadowColor(from: booking))
                                .font(.system(size: 14))
                            //
                            //                            .rotationEffect(.degrees(-45.0))
                            ////                            .offset(x: -40, y: -80)
                            //                            .offset(x:-125)
                            
                        }
                    }
                }
                HStack {
                    ZStack {
                        
                        HStack {
                            
                            
                            SwipableImageView2(
                                houseImageURL: house?.imageURL ?? "",
                                petImageURL: house?.pets?.first?.imageURL ?? "",
                                height: 100,
                                width: 100
                            )
                            
                            VStack(alignment: .leading, spacing: 8) {
                                Text(house?.title ?? "")
                                    .font(.headline)
                                HStack {
                                    Label(
                                        title: { Text("\(house?.beds ?? 0) st") },
                                        icon: { Image(systemName: "bed.double") }
                                    )
                                    .padding(.trailing, 10)
                                    
                                    Label(
                                        title: { Text("\(house?.size ?? 0) m²") },
                                        icon: { Image(systemName: "house.fill") }
                                    )
                                }
                                .font(.subheadline)
                                .foregroundColor(.secondary)
                                
                                Text("\(booking.fromDate.formatted(date: .numeric, time: .omitted)) - \(booking.toDate.formatted(date: .numeric, time: .omitted))")
                                    .font(.subheadline)
                                //                        .foregroundColor(.secondary)
                            }
                            .padding()
                            if booking.fromDate < Date.now && !booking.rated {
                                Button(action: {
                                    showAddRating.toggle()
                                    
                                }, label: {
                                    Text("Add review")
                                })
                            }
                        }
//                        if let confirmed = booking.confirmed {
//                            if !confirmed && booking.toDate > Date.now {
//                                Text("Not Yet Confirmed")
//                                    .background(AppColors.mainAccent)
//                                    .font(.system(size: 14))
//                                    .frame(maxWidth: .infinity, alignment: .leading)
//                                    .rotationEffect(.degrees(-45.0))
//                                    .offset(x: -40, y: -80)
//                                    
//                            }
//                        }
                    }
                }
            }
            .background(Color.white)
            .cornerRadius(20)
            .shadow(color: booking.toDate > Date.now ? viewModel.getShadowColor(from: booking) : .secondary,radius: 5)
            .padding(.vertical, 8)
            .frame(maxWidth: 335, maxHeight: 150)
            //        .frame(height: 150)
            //        }
            .buttonStyle(PlainButtonStyle())
            
            .onAppear() {
                viewModel.getHouseDetails(for: booking) { house in
                    self.house = house
                }
            }
            .sheet(isPresented: $showAddRating, content: {
                if let house = house {
                    if let docID = booking.docID {
                        AddReview(viewModel: viewModel, house: house, bookingID: docID)
                            .presentationDetents([.medium])
                    }
                }
            })
        }
        
        .buttonStyle(PlainButtonStyle())
      
    }
        
}

struct AddReview : View {
    @ObservedObject var viewModel: MyBookingViewModel
    var house: House
    var bookingID: String
    @State var rating = 0
    @State var title: String = ""
    @State var text: String = ""
    var body: some View {
        VStack {
            Rating(rating: $rating)
            TextField("Title", text: $title)
            TextField("Review", text: $text)
            HStack {
                Button(action: {
                    if let userID = viewModel.firebaseHelper.getUserID() {
                        let review = Review(bookingID: bookingID, userID: userID, rating: rating, title: title, text: text)
                        viewModel.firebaseHelper.save(rating: review, for: house)
                    }
                }, label: {
                    FilledButtonLabel(text: "Save")
                        .frame(width: 150)
                })
                Button(action: {}, label: {
                    FilledButtonLabel(text: "Cancel")
                        .frame(width: 150)
                })
            }
        }
    }
}

struct Rating : View {
    @Binding var rating: Int

    var label = ""
    var maximumRating = 5

    var offImage: Image?
    var onImage = Image(systemName: "star.fill")

    var offColor = Color.gray
    var onColor = Color.yellow
    
    var body: some View {
        HStack {
            ForEach(1..<maximumRating + 1, id: \.self) { number in
                Button {
                    rating = number
                } label: {
                    image(for: number)
                        .foregroundStyle(number > rating ? offColor : onColor)
                }
            }
        }
    }
    
    func image(for number: Int) -> Image {
        if number > rating {
            offImage ?? onImage
        } else {
            onImage
        }
    }
}


#Preview {
//    MyBookingsView()
    Rating(rating: .constant(4))
}
