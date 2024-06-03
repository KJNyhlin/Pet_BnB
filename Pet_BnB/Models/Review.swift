//
//  Rating.swift
//  Pet_BnB
//
//  Created by Jonas Bondesson on 2024-05-30.
//

import Foundation
import FirebaseFirestore

struct Review: Encodable, Decodable, Identifiable {
    @DocumentID var docID : String?
    var id = UUID()
    var bookingID : String
    var userID : String
    var rating : Int
    var title : String?
    var text: String?
    var date: Date = Date.now
    
}
