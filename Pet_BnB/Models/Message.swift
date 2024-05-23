//
//  Message.swift
//  Pet_BnB
//
//  Created by Kristian Thun on 2024-05-22.
//

import Foundation
import FirebaseFirestore
import FirebaseFirestoreSwift

struct Message: Identifiable, Encodable, Decodable{
    @DocumentID var id: String?
    var senderID: String
    var timestamp: Timestamp
    var text: String
    var isRead: [String: Bool]
    
}
