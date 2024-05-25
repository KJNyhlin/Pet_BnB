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
    var toUserID: String
    private var db = Firestore.firestore()
    private var listenerRegistration: ListenerRegistration?
    var lastMessageDateString = ""
    
  //  var isChatNew = false
    
    @Published var messageInput: String = ""
    
    init(toUserID: String, chat: Chat? = nil) {
        self.toUserID = toUserID
        self.chat = chat
        
        if let chatID = chat?.id {
            setupMessageListener(chatID: chatID)
        } else {
            if let loggedInUser = firebaseHelper.getUserID(){
                fetchChat(participants: [toUserID, loggedInUser])
            }
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
            print("FetchChat called!!!!")
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
                   // print(chatID)
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
    
    func setupMessageListener(chatID: String) {
        listenerRegistration = db.collection("chats").document(chatID).collection("messages")
            .order(by: "timestamp", descending: false)
            .addSnapshotListener { (querySnapshot, error) in
                guard let documents = querySnapshot?.documents else {
                    print("No documents")
                    return
                }
                self.markMessageAsRead(chatID: chatID)
                self.messages = documents.compactMap { queryDocumentSnapshot -> Message? in
                    return try? queryDocumentSnapshot.data(as: Message.self)
                }
            }
    }
    
    func removeListener() {
        listenerRegistration?.remove()
        listenerRegistration = nil
    }
    
    
    func sendMessage(chatID: String, text: String, senderID: String, reciverID: String) {
        print("InSendMessage")
        let newMessage = Message(senderID: senderID, timestamp: Timestamp(), text: text, isRead: [:])
    
        let chatRef = db.collection("chats").document(chatID)
        try? chatRef.collection("messages").addDocument(from: newMessage)
        // Update the last message and timestamp
        chatRef.updateData([
            "lastMessage": text,
            "lastMessageTimeStamp": Timestamp(),
            "unreadMessagesCount.\(reciverID)": FieldValue.increment(Int64(1))
        ])
        
        // Add the message to the subcollection

        
        // Update unread message count for other participants

//        chatRef.updateData(["unreadMessagesCount.\(reciverID)": FieldValue.increment(Int64(1))
//        ])
    }
    
    func getChat(participants: [String]) async -> Chat?{
        let sortedParticipants = sort(array: participants)
        
        do {
            let querySnapshot = try await db.collection("chats").whereField("participants", isEqualTo: sortedParticipants)
            .getDocuments()
          for document in querySnapshot.documents {
              let chat = try document.data(as: Chat.self)
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
        let userID = firebaseHelper.getUserID()
        if userID == userID{
            return userID == id
        }
        //User is nog logged in this should not be possible
        return false
    }
    
    func markMessageAsRead(chatID: String){
        let chatRef = db.collection("chats").document(chatID)
        if let userID = firebaseHelper.getUserID(){
            chatRef.updateData(["unreadMessagesCount.\(userID)": 0]) { error in
                if let error = error{
                    print("Error marking as read! \(error)")
                }
            }
//            let messagesRef = chatRef.collection("messages")
//            messagesRef.whereField("isRead.\(userID)", isEqualTo: false).getDocuments { snapshot, error in
//                if let snapshot = snapshot {
//                    for document in snapshot.documents {
//                        let messageRef = messagesRef.document(document.documentID)
//                        messageRef.updateData([
//                            "isRead.\(userID)": true
//                        ])
//                    }
//                }
//            }
        }

    }
    func isSame(string1: String, String2: String) -> Bool {
        let same = string1 == String2
        lastMessageDateString = string1
        
        return same
    }
    func getDateString(timeStamp: Timestamp) -> String {
        let date = timeStamp.dateValue()
        let dateFormatter = DateFormatter()
        let calendar = Calendar.current
        dateFormatter.locale = Locale.current
        
        if calendar.isDateInToday(date){
            //dateFormatter.dateFormat = "today"
            return "today"

        } else if calendar.isDateInYesterday(date)  {
            return "yesterday"
        } else if let daysAgo = calendar.dateComponents([.day], from: date, to: Date()).day, daysAgo <= 7 {
            // if days ago is within a week print the name of the day
            dateFormatter.dateFormat = "EEEE"
        } else{
            dateFormatter.dateFormat = "yyyy-MM-dd"
        }
       
        return dateFormatter.string(from: date)
    }
    
    func getTime(from timestamp: Timestamp) -> String{
        let date = timestamp.dateValue()
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale.current
        dateFormatter.dateFormat = "HH:mm"
        return dateFormatter.string(from: date)
        
    }
    
}


