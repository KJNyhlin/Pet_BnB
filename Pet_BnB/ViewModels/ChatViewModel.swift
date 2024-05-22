//
//  ChatViewModel.swift
//  Pet_BnB
//
//  Created by Kristian Thun on 2024-05-22.
//

import Foundation
import FirebaseFirestore
import FirebaseFirestoreSwift


class ChatViewModel: ObservableObject{
    @Published var chat: Chat?
    
    var firebaseHelper = FirebaseHelper()
    var toUserID: String
    private var db = Firestore.firestore()
  //  var isChatNew = false
    
    @Published var messageInput: String = ""
    
    init(toUserID: String, chat: Chat? = nil) {
        self.toUserID = toUserID
        self.chat = chat
//        if let chat = chat{
//            self.chat = chat
//        }else{
//            self.chat = createNewChat(toUserID: toUserID)
//            
//        }
    }
    
//    func createNewChat(toUserID: String) -> Chat?{
////
//        guard let loggedInUserID = firebaseHelper.getUserID() else{
//            return nil
//        }
//        let chat = Chat(participants: [loggedInUserID,toUserID], unReadMessagesCount: [loggedInUserID: 0, toUserID : 0])
//        return chat
//            
//    }
    
    func sendMessage() -> Void {
        print("Send message: \(messageInput)")
        saveMessageToFirebase()
    }
    
    func saveMessageToFirebase(){
        if let userID = firebaseHelper.getUserID(){
            if let chat = chat{
                print("Chat exists update its list")
            } else{
                createChat(senderID: userID){ chatID in
                    print(chatID)
                    if let chatID = chatID{

                        self.sendMessage(chatID: chatID, text: self.messageInput, senderID: userID, reciverID: self.toUserID)
                    }
               
                }
            }
        }
        
        
    }
    
    func createChat(senderID: String, compleation: @escaping (String?) -> Void){
        var newChat = Chat(participants: [senderID, toUserID], lastMessage: messageInput, lastMessageTimeStamp: Timestamp(), unreadMessagesCount:[senderID:0])
        do{
            let ref = try db.collection("chats").addDocument(from: newChat)
            compleation(ref.documentID)
        } catch {
            print("error creating chat!")
            compleation(nil)
        }
        
        
    }
    
    func sendMessage(chatID: String, text: String, senderID: String, reciverID: String) {
        print("InSendMessage")
        let newMessage = Message(senderID: senderID, timestamp: Timestamp(), text: text, isRead: [:])
    
        let chatRef = db.collection("chats").document(chatID)
        
        // Update the last message and timestamp
        chatRef.updateData([
            "lastMessage": text,
            "lastMessageTimestamp": Timestamp()
        ])
        
        // Add the message to the subcollection
        try? chatRef.collection("messages").addDocument(from: newMessage)
        
        // Update unread message count for other participants
        chatRef.updateData([
            "unreadMessagesCount.\(reciverID)": FieldValue.increment(Int64(1))
        ])
    }
    
}
