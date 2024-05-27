//
//  Chat.swift
//  Pet_BnB
//
//  Created by Kristian Thun on 2024-05-22.
//

import Foundation
import FirebaseFirestore
import FirebaseFirestoreSwift

struct Chat: Encodable, Decodable, Identifiable{
    @DocumentID var id: String?
    var participants: [String]
    var lastMessage: String
    var lastMessageTimeStamp: Timestamp
    var unreadMessagesCount: [String: Int]
  //  var messages: [Message] = []
    
}

