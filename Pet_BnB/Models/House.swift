//
//  House.swift
//  Pet_BnB
//
//  Created by Jonas Bondesson on 2024-05-15.
//

import Foundation
import FirebaseFirestore

struct House: Codable {
    @DocumentID var docID: String?
    var title: String
    var description: String
    var imageURL : String?
    
}
