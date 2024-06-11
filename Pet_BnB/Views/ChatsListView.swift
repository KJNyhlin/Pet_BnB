//
//  ChatsListView.swift
//  Pet_BnB
//
//  Created by Kristian Thun on 2024-05-23.
//

import SwiftUI


struct ChatsListView: View {
    
    @EnvironmentObject var vm: ChatsListViewModel
    @EnvironmentObject var authManager: AuthManager
    @Binding var path: NavigationPath
    
    var body: some View {
        VStack{
            List{
                if !vm.chats.isEmpty{
                    ForEach(vm.chats){ chat in
                        if let toUser = vm.getUserFrom(chat: chat){
                            NavigationLink(value: chat){
                                ChatListRow(chat: chat, user: toUser, hasUnreadMessages: vm.hasUnReadMessages(chat: chat), timeString: vm.getDateString(timeStamp: chat.lastMessageTimeStamp), path: $path)
                            }
                            .listRowInsets(EdgeInsets(top: 10, leading: 5, bottom: 10, trailing: 10))
                        }
                    }
                }
                else{
                    Text("No messages found!")
                }
            }
            .navigationDestination(for: Chat.self){ chat in
                if let toUser = vm.getUserFrom(chat: chat),
                   let toUserID = toUser.docID{
                    ChatView(vm: ChatViewModel(toUserID: toUserID, chat: chat, toUser: toUser))
                }
            }
            .navigationTitle("Messages")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}

struct ChatListRow: View{
    var chat: Chat
    var user: User?
    var hasUnreadMessages: Bool
    var timeString: String
    @Binding var path: NavigationPath
    
    @State private var navigateToProfile: Bool = false
    
    var body: some View{
        HStack{
            Image(systemName: "circle.fill")
                .font(.system(size: 8))
                .foregroundColor(AppColors.mainAccent)
                .opacity(hasUnreadMessages ? 100 : 0)
            
            Button(action: {
                if let user = user{
                    path.append(user)
                }
                
            }) {
                AsyncImageView(imageUrl: user?.imageURL, maxWidth: 40, height: 40, isCircle: true)
            }
            .buttonStyle(PlainButtonStyle())
            
            VStack(alignment: .leading){
                HStack{
                    Text(user?.firstName ?? "No name")
                        .bold()
                    Spacer()
                    Text(timeString)
                        .foregroundColor(.secondary)
                        .font(.subheadline)
                }
                
                Text(chat.lastMessage)
                    .font(.subheadline)
                    .lineLimit(2)
                    .foregroundColor(.secondary)
            }
        }
    }
}
