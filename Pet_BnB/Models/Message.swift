//
//  Message.swift
//  Pet_BnB
//
//  Created by Kristian Thun on 2024-05-22.
//

import Foundation
import FirebaseFirestoreSwift

struct Message{
    @DocumentID var id: String?
    var senderID: String
    var timestamp = Date()
    var text: String
    var isRead: [String: Bool]
    
}
