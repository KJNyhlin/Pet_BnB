//
//  Booking.swift
//  Pet_BnB
//
//  Created by Jonas Bondesson on 2024-05-15.
//

import Foundation
import FirebaseFirestore

struct Booking: Identifiable, Decodable, Encodable, Hashable {
    var id = UUID()
    @DocumentID var docID: String?
    var houseID: String
    var renterID: String?
    var fromDate: Date
    var toDate: Date
    var pet: Pet?
    var confirmed: Bool?
    var rated: Bool = false
    
    
}
