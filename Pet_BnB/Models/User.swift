//
//  User.swift
//  Pet_BnB
//
//  Created by Jonas Bondesson on 2024-05-15.
//

import Foundation
import FirebaseFirestore

struct User {
    @DocumentID var docID : String?
    var firstName: String?
    var surName: String?
    var pet: Pet?
}
