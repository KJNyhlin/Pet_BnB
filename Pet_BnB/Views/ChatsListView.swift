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
       //     Image(systemName: "person.circle")
            if let url = user?.imageURL{
                AsyncImage(url: URL(string: url)) { phase in
                    var size:CGFloat = 40
                    switch phase {
                    case .empty:
                        ProgressView()
                            .frame(height: size)
                            .frame(maxWidth: size)
                    case .success(let image):
                        image
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(height: size)
                            .frame(maxWidth: size)
                            .clipShape(Circle())
                    case .failure:
                        Image(systemName: "person.circle")
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(height: size)
                            .frame(maxWidth: size)
                            .background(Color.gray)
                    @unknown default:
                        Image(systemName: "person.circle")
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(height: size)
                            .frame(maxWidth: size)
                            .background(Color.gray)
                    }
                }
            }
           
                
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
