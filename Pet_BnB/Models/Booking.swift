//
//  Booking.swift
//  Pet_BnB
//
//  Created by Jonas Bondesson on 2024-05-15.
//

import Foundation
import FirebaseFirestore

struct Booking: Identifiable, Decodable, Encodable {
    var id = UUID()
    @DocumentID var docID: String?
    var houseID: String
    var renterID: String?
    var fromDate: Date
    var toDate: Date
    var pet: Pet?
    
    
}
