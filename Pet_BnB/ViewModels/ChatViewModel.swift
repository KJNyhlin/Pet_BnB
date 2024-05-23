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
    @Published var messages: [Message] = []
    var firebaseHelper = FirebaseHelper()
  //  var toUserID: String
    private var db = Firestore.firestore()
    private var listenerRegistration: ListenerRegistration?
  //  var isChatNew = false
    
    @Published var messageInput: String = ""
    
    init(toUserID: String, chat: Chat? = nil) {
        self.toUserID = toUserID
        self.chat = chat
        if let loggedInUser = firebaseHelper.getUserID(){
            fetchChat(participants: [toUserID, loggedInUser])
        }
        
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
        saveMessageToFirebase()
        messageInput = ""
    }
    
    func fetchChat(participants: [String]){
        Task{
            if let fetchedChat = await getChat(participants: participants){
                DispatchQueue.main.async {
                    self.chat = fetchedChat
        //            print(self.chat)
                    if let chatID = self.chat?.id {
                        self.setupMessageListener(chatID: chatID)
                    }
                    
                }
            }
        }
    }
    
    func saveMessageToFirebase(){
        if let userID = firebaseHelper.getUserID(){
            if let chat = chat,
               let chatID = chat.id{
                sendMessage(chatID: chatID, text: messageInput, senderID: userID, reciverID: toUserID)
            } else{
                createChat(senderID: userID){ chatID in
                    print(chatID)
                    if let chatID = chatID{
                        self.setupMessageListener(chatID: chatID)
                        self.sendMessage(chatID: chatID, text: self.messageInput, senderID: userID, reciverID: self.toUserID)
                    }
               
                }
            }
        }
    }
    
    func createChat(senderID: String, compleation: @escaping (String?) -> Void){
        let newChat = Chat(participants: [senderID, toUserID], lastMessage: messageInput, lastMessageTimeStamp: Timestamp(), unreadMessagesCount:[senderID:0])
        do{
            let ref = try db.collection("chats").addDocument(from: newChat)
            compleation(ref.documentID)
        } catch {
            print("error creating chat!")
            compleation(nil)
        }
    }
    
    private func setupMessageListener(chatID: String) {
        listenerRegistration = db.collection("chats").document(chatID).collection("messages")
            .order(by: "timestamp", descending: false)
            .addSnapshotListener { (querySnapshot, error) in
                guard let documents = querySnapshot?.documents else {
                    print("No documents")
                    return
                }
               
                self.messages = documents.compactMap { queryDocumentSnapshot -> Message? in
                    return try? queryDocumentSnapshot.data(as: Message.self)
                }
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
        chatRef.updateData(["unreadMessagesCount.\(reciverID)": FieldValue.increment(Int64(1))
        ])
    }
    
    func getChat(participants: [String]) async -> Chat?{
        let sortedParticipants = sort(array: participants)
       // var test = ["NcXIPqzGOsdUk7MFthFDFg5wpCn1", "1SQkGlReCERsA9HdawiEXbZR2j93"]
        
        do {
            let querySnapshot = try await db.collection("chats").whereField("participants", isEqualTo: sortedParticipants)
            .getDocuments()
          for document in querySnapshot.documents {
              var chat = try document.data(as: Chat.self)
             // print(chat)
              return chat
          }
        } catch {
          print("Error getting documents: \(error)")
        }
        return nil
    }
    func sort(array: [String]) -> [String]{
        return array.sorted()
    }
    
    func fromLoggedInUser(id: String)-> Bool{
        var userID = firebaseHelper.getUserID()
        if userID == userID{
            return userID == id
        }
        //User is nog logged in this should not be possible
        return false
    }
    
}
