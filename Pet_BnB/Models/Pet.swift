//
//  Pet.swift
//  Pet_BnB
//
//  Created by Jonas Bondesson on 2024-05-15.
//

import Foundation
import FirebaseFirestore

struct Pet: Decodable, Encodable, Identifiable {
    var id: String?
    var name: String
    var species: String
    var information: [String] = []
}
