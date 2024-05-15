//
//  Pet.swift
//  Pet_BnB
//
//  Created by Jonas Bondesson on 2024-05-15.
//

import Foundation
import FirebaseFirestore

struct Pet {
    @DocumentID var docID: String?
    var name: String
    var species: String
}
