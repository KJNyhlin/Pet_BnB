//
//  ChatsListViewModel.swift
//  Pet_BnB
//
//  Created by Kristian Thun on 2024-05-23.
//

import Foundation
import FirebaseFirestore
import FirebaseFirestoreSwift

class ChatsListViewModel: ObservableObject{
    @Published var chats: [Chat] {
        didSet{
            totalUnreadMessages(chats: chats)
        }
    }
    var firebaseHelper = FirebaseHelper()
    private var listenerRegistration: ListenerRegistration?
    private var db = Firestore.firestore()
    @Published var chatParticipants: [String: User] = [:]
    @Published var unreadCount = 0
    
    init(chats: [Chat] = [], firebaseHelper: FirebaseHelper = FirebaseHelper(), listenerRegistration: ListenerRegistration? = nil) {
        self.chats = chats
        self.firebaseHelper = firebaseHelper
        self.listenerRegistration = listenerRegistration
      
        setupChatsListener()
    }
    
    private func setupChatsListener() {
        if listenerRegistration != nil {
            return
        }
        
        if let loggedInUserId = firebaseHelper.getUserID(){
            listenerRegistration = db.collection("chats").whereField("participants", arrayContains: loggedInUserId)
                .order(by: "lastMessageTimeStamp", descending: false)
                .addSnapshotListener { (querySnapshot, error) in
                    guard let documents = querySnapshot?.documents else {
                        print("No documents")
                        return
                    }
                   
                    //print(documents)
             
                    self.chats = documents.compactMap { queryDocumentSnapshot -> Chat? in
                        return try? queryDocumentSnapshot.data(as: Chat.self)
                    }
                    
               //     self.totalUnreadMessages(chats: self.chats)            //self.totalUnreadMessages(chat: <#T##Chat#>)
                    self.fetchParticipantNames()
                }
            print("listener setup")
        }

    }
    
    private func fetchParticipantNames() {
        for chat in chats {
            for participant in chat.participants {
                if chatParticipants[participant] == nil { // Fetch only if not already fetched
                    db.collection("users").document(participant).getDocument { documentSnapshot, error in
                        if let document = documentSnapshot, document.exists {
                            if let user = try? document.data(as: User.self) {
                                DispatchQueue.main.async {
                                    self.chatParticipants[participant] = user
                                    print(self.chatParticipants)
                                }
                            }
                        }
                    }
                }
            }
        }
    }
    
    func getUserFrom(chat: Chat) -> User?{
        if let loggedInUserID = firebaseHelper.getUserID(){
            for userID in chat.participants{
                if userID != loggedInUserID{
                    return chatParticipants[userID]
                }
            }
            
        }
        return nil
    }
    func hasUnReadMessages(chat: Chat) -> Bool{
        if let userID = firebaseHelper.getUserID(){
            if let unread = chat.unreadMessagesCount[userID]{
                return unread > 0
            }
        }
        return false
    }
    func totalUnreadMessages(chats: [Chat]){
        var count = 0
        if let userID = firebaseHelper.getUserID(){
            for chat in chats{
                if let unread = chat.unreadMessagesCount[userID]{
                   count += unread
                }
            }
        }
        unreadCount = count
        print("Unread count = \(unreadCount)")
    }
}
