//
//  MyBookingsView.swift
//  Pet_BnB
//
//  Created by Jonas Bondesson on 2024-05-15.
//

import SwiftUI

struct MyBookingsView: View {
    @StateObject var viewModel = MyBookingViewModel()
    @EnvironmentObject var authManager: AuthManager
    var body: some View {

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
            .onChange(of: authManager.loggedIn){ oldValue, newValue in
                if newValue{
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
        
        NavigationLink(value: BookingNavigation(booking: booking, house: house)){
            VStack(alignment: .leading, spacing: 0) {
                VStack(alignment: .leading, spacing: 0) {
                    if let confirmed = booking.confirmed {
                        if booking.toDate > Date.now {
                            Text(!confirmed && booking.toDate > Date.now ? "Not Yet Confirmed" : "Confirmed")
                                .frame(maxWidth: .infinity, alignment: .top)
                                .padding(.horizontal, 2)
                                .background(viewModel.getShadowColor(from: booking))
                                .font(.system(size: 14))
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
                                
                            }
                            .padding()
                            if booking.fromDate < Date.now && !booking.rated {
                                Button(action: {
                                    showAddRating.toggle()
                                    
                                }, label: {
                                    Image(systemName: "star.bubble.fill")
                                        .font(.system(size: 20))
                                        .foregroundColor(AppColors.mainAccent)
                                        .padding(.trailing, 20)
                                })
                            }
                        }
                    }
                }
            }
            .background(Color.white)
            .cornerRadius(20)
            .shadow(color: booking.toDate > Date.now ? viewModel.getShadowColor(from: booking) : .secondary,radius: 5)
            .padding(.vertical, 8)
            .frame(maxWidth: 335, maxHeight: 150)
            
            .buttonStyle(PlainButtonStyle())
            
            .onAppear() {
                viewModel.getHouseDetails(for: booking) { house in
                    self.house = house
                }
            }
            
            .sheet(isPresented: $showAddRating, content: {
                if let house = house {
                    if let docID = booking.docID {
                        AddReviewSheet(viewModel: viewModel, house: house, bookingID: docID)
                            .presentationDetents([.medium])
                    }
                }
            })
            
        }
        .buttonStyle(PlainButtonStyle())
    }
}

struct AddReviewSheet : View {
    @ObservedObject var viewModel: MyBookingViewModel
    @Environment(\.dismiss) var dismiss
    var house: House
    var bookingID: String
    @State var rating = 0
    @State var title: String = ""
    @State var text: String = ""
    var body: some View {
        VStack {
            Text("Add Review")
                .font(.title)
                .padding(.vertical, 30)
            RatingStarsView(rating: $rating)
                .padding()
            TextField("Title", text: $title)
            
                .padding( 10)
                .overlay(
                    RoundedRectangle(cornerRadius: 25.0)
                        .stroke(AppColors.mainAccent, lineWidth: 2)
                )
                .padding(.horizontal, 40)
            TextField("Review", text: $text, axis: .vertical)
            
                .padding( 10)
                .overlay(
                    RoundedRectangle(cornerRadius: 25.0)
                        .stroke(AppColors.mainAccent, lineWidth: 2)
                )
                .padding(.horizontal, 40)
            Spacer()
            HStack {
                Button(action: {
                    if let userID = viewModel.firebaseHelper.getUserID() {
                        let review = Review(bookingID: bookingID, userID: userID, rating: rating, title: title, text: text)
                        viewModel.firebaseHelper.save(rating: review, for: house) {success in
                            if success {
                                dismiss()
                            }
                        }
                    }
                }, label: {
                    FilledButtonLabel(text: "Save")
                        .frame(width: 150)
                })
                Button(action: {
                    dismiss()
                }, label: {
                    FilledButtonLabel(text: "Cancel")
                        .frame(width: 150)
                })
            }
        }
    }
}

struct RatingStarsView : View {
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
    RatingStarsView(rating: .constant(4))
}
