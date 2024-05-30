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
    @Published var toUser: User?
    var firebaseHelper = FirebaseHelper()
    var toUserID: String
    private var db = Firestore.firestore()
    private var listenerRegistration: ListenerRegistration?
    var lastMessageDateString = ""
    private var lastDocument: DocumentSnapshot?
    @Published var isFirstLoad = true
    
    @Published var messageInput: String = ""
    
    init(toUserID: String, chat: Chat? = nil, toUser: User? = nil) {
        self.toUserID = toUserID
        self.chat = chat
        self.toUser = toUser
        
        if let chatID = chat?.id {
            setupMessageListener(chatID: chatID)
            
        } else {
            if let loggedInUser = firebaseHelper.getUserID(){
                fetchChat(participants: [toUserID, loggedInUser])
                loadToUser()
            }
        }
    }
    deinit{
        removeListener()
    }
    
    func sendMessage() -> Void {
        if messageInput.isEmpty{
            return
        }
        saveMessageToFirebase()
        messageInput = ""
    }
    
    func loadToUser(){
        Task {
            firebaseHelper.loadUserInfo(userID:toUserID){ user in
                if let user = user{
                    self.toUser = user
                    
                } else {
                    print("no to user found")
                }
                
            }
            
        }
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
            .order(by: "timestamp", descending: true)
            .limit(to: 10)
            .addSnapshotListener { (querySnapshot, error) in
                guard let documents = querySnapshot?.documents else {
                    print("No documents")
                    return
                }
                self.lastDocument = documents.last
                self.markMessageAsRead(chatID: chatID)
                let newMessages = documents.compactMap { queryDocumentSnapshot -> Message? in
                    return try? queryDocumentSnapshot.data(as: Message.self)
                }
                if !self.messages.isEmpty{
                    var messagesToInsert: [Message] = []
                    for message in newMessages{
                        if !self.messages.contains(message){
                            messagesToInsert.append(message)
                        } else{
                            break
                        }
                    }
                    self.messages.insert(contentsOf: messagesToInsert, at: 0)
                } else {
                    self.messages = newMessages
                }
                
                //self.messages = messages.reversed()

                print("First messages setup!")
            }
    }
    
    func loadMoreMessages(){
        if let chatID = chat?.id{
            isFirstLoad = false
            lastMessageDateString = ""
            var query = db.collection("chats").document(chatID).collection("messages")
                .order(by: "timestamp", descending: true)
                .limit(to: 10)
            if let lastDocument = lastDocument{
                query = query.start(afterDocument: lastDocument)
            }
            query.getDocuments { snapshot, error in
                guard let documents = snapshot?.documents else{
                    print("No documents")
                    return
                }
                if let lastDoc = documents.last {
                    self.lastDocument = lastDoc
                }
                let fetchedMessages = documents.compactMap{ documentSnapshot -> Message? in
                    return try? documentSnapshot.data(as: Message.self)
                    
                }
                //let reversedfetchedMessages = fetchedMessages.reversed()
                DispatchQueue.main.async{
                    //self.messages.insert(contentsOf: reversedfetchedMessages, at: 0)
                    self.messages += fetchedMessages
                    print("More messages fetched!")
                }
                
            }
        }
        
        
    }
    
    func removeListener() {
        listenerRegistration?.remove()
        listenerRegistration = nil
    }
    
    func startListener() {
        if let chat = chat{
            if let chatid = chat.id{
                if listenerRegistration == nil{
                    setupMessageListener(chatID: chatid)
                }
            }
        }
    }
    
    func isLoggedIn() -> Bool{
        if firebaseHelper.getUserID() != nil {
            return true
        }
        return false
    }
    
    
    func sendMessage(chatID: String, text: String, senderID: String, reciverID: String) {
        print("InSendMessage")
        let newMessage = Message(senderID: senderID, timestamp: Timestamp(), text: text, isRead: [:])
        
        let chatRef = db.collection("chats").document(chatID)
        // Add the message to the subcollection
        try? chatRef.collection("messages").addDocument(from: newMessage)
        // Update the last message and timestamp, Update unread message count for other participants
        chatRef.updateData([
            "lastMessage": text,
            "lastMessageTimeStamp": Timestamp(),
            "unreadMessagesCount.\(reciverID)": FieldValue.increment(Int64(1))
        ])
        
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
                    print("Error marking read! \(error)")
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
    func sameAsLastString(string: String) -> Bool {
        let same = string == lastMessageDateString
        lastMessageDateString = string
        
        return same
    }
    
    func dateStringChanged(string: String) -> Bool {
        let changed = string != lastMessageDateString
        lastMessageDateString = string
        
        return changed
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


