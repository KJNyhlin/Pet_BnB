//
//  House.swift
//  Pet_BnB
//
//  Created by Jonas Bondesson on 2024-05-15.
//

import Foundation
import FirebaseFirestore
import FirebaseFirestoreSwift


struct House: Identifiable, Codable, Hashable, Equatable{
//    static func == (lhs: House, rhs: House) -> Bool {
//        lhs.id == rhs.id
//    }
    
    @DocumentID var id: String?
    var title: String
    var description: String
    var imageURL: String?
    var beds: Int
    var size: Int
    var streetName: String
    var streetNR: Int
    var city: String
    var zipCode: Int
    var ownerID: String
    var pets: [Pet]?
    var bookings: [Booking]?
    var latitude: Double?
    var longitude: Double?
}
