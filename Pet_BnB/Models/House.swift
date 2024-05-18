//
//  House.swift
//  Pet_BnB
//
//  Created by Jonas Bondesson on 2024-05-15.
//

import Foundation
import FirebaseFirestoreSwift


struct House: Identifiable, Codable {
    @DocumentID var id: String?
    var title: String
    var description: String
    var imageURL: String?
    var beds: Int
    var city: String
    var ownerID: String
    var size: Int
    var streetNR: Int
    var streetName: String
    var zipCode: String
}
