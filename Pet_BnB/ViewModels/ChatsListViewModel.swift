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
    @Published var chats: [Chat]
    var firebaseHelper = FirebaseHelper()
    private var listenerRegistration: ListenerRegistration?
    private var db = Firestore.firestore()
    @Published var chatParticipants: [String: User] = [:]
    
    init(chats: [Chat] = [], firebaseHelper: FirebaseHelper = FirebaseHelper(), listenerRegistration: ListenerRegistration? = nil) {
        self.chats = chats
        self.firebaseHelper = firebaseHelper
        self.listenerRegistration = listenerRegistration
      
        setupChatsListener()
    }
    
    private func setupChatsListener() {
        if let loggedInUserId = firebaseHelper.getUserID(){
            listenerRegistration = db.collection("chats").whereField("participants", arrayContains: loggedInUserId)
                .order(by: "lastMessageTimeStamp", descending: false)
                .addSnapshotListener { (querySnapshot, error) in
                    guard let documents = querySnapshot?.documents else {
                        print("No documents")
                        return
                    }
                   
                    print(documents)
                    
                    
                    self.chats = documents.compactMap { queryDocumentSnapshot -> Chat? in
                        return try? queryDocumentSnapshot.data(as: Chat.self)
                    }
                    self.fetchParticipantNames()
                }
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
}
