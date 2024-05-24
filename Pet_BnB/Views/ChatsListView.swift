//
//  ChatsListView.swift
//  Pet_BnB
//
//  Created by Kristian Thun on 2024-05-23.
//

import SwiftUI


struct ChatsListView: View {
    //   @StateObject var vm: ChatsListViewModel = ChatsListViewModel()
    @EnvironmentObject var vm: ChatsListViewModel
    
    var body: some View {
        VStack{
            NavigationStack{
                
                List{
                    ForEach(vm.chats){ chat in
                        if let toUser = vm.getUserFrom(chat: chat),
                           let toUserID = toUser.docID{
                            NavigationLink(destination: ChatView(vm: ChatViewModel(toUserID: toUserID, chat: chat))){
                                ChatListRow(chat: chat, user: toUser, hasUnreadMessages: vm.hasUnReadMessages(chat: chat), timeString: vm.getDateString(timeStamp: chat.lastMessageTimeStamp))
                            }
                        }
                    }
                    
                }
                .navigationTitle("Messages")
                .navigationBarTitleDisplayMode(.inline)
            }
            
            
        }
        
    }
}

struct ChatListRow: View{
    var chat: Chat
    var user: User?
    var hasUnreadMessages: Bool
    var timeString: String
    var body: some View{
        HStack{
            Image(systemName: "circle.fill")
                .font(.system(size: 8))
                .foregroundColor(AppColors.mainAccent)
                .opacity(hasUnreadMessages ? 100 : 0)
            Image(systemName: "person.circle")
                
            VStack(alignment: .leading){
                //            if let name = user?.firstName{
                
                
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

#Preview {
    ChatsListView()
}
