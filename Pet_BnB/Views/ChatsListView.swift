//
//  ChatsListView.swift
//  Pet_BnB
//
//  Created by Kristian Thun on 2024-05-23.
//

import SwiftUI


struct ChatsListView: View {
    @StateObject var vm: ChatsListViewModel = ChatsListViewModel()
    
    
    var body: some View {
        VStack{
            NavigationStack{
                List{
                    ForEach(vm.chats){ chat in
                        if let toUser = vm.getUserFrom(chat: chat),
                           let toUserID = toUser.docID{
                            NavigationLink(destination: ChatView(vm: ChatViewModel(toUserID: toUserID, chat: chat))){
                                ChatListRow(chat: chat, user: vm.getUserFrom(chat: chat), hasUnreadMessages: vm.hasUnReadMessages(chat: chat))
                            }
                        }
                    }
                }
                

            }
        }
    }
}

struct ChatListRow: View{
    var chat: Chat
    var user: User?
    var hasUnreadMessages: Bool
    var body: some View{
        HStack{
            Image(systemName: "circle.fill")
                .font(.footnote)
                .foregroundColor(AppColors.mainAccent)
                .opacity(hasUnreadMessages ? 100 : 0)

            VStack(alignment: .leading){
                //            if let name = user?.firstName{
                
                
                
                Text(user?.firstName ?? "No name")
                    .bold()
                //            } else {
                //                Text("No name")
                //                    .bold()
                //            }
                Text(chat.lastMessage)
            }
        }
    }
}

#Preview {
    ChatsListView()
}
