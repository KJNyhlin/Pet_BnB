//
//  Pet.swift
//  Pet_BnB
//
//  Created by Jonas Bondesson on 2024-05-15.
//

import Foundation
import FirebaseFirestore

struct Pet: Decodable, Encodable, Identifiable {
    var id = UUID().uuidString
    var name: String
    var species: String
    var imageURL: String?
    var information: [String] = []
    var description: String?
}
