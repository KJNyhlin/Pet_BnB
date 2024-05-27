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
                    if !vm.chats.isEmpty{
                        ForEach(vm.chats){ chat in
                            if let toUser = vm.getUserFrom(chat: chat),
                               let toUserID = toUser.docID{
                                NavigationLink(destination: ChatView(vm: ChatViewModel(toUserID: toUserID, chat: chat, toUser: toUser))){
                                    ChatListRow(chat: chat, user: toUser, hasUnreadMessages: vm.hasUnReadMessages(chat: chat), timeString: vm.getDateString(timeStamp: chat.lastMessageTimeStamp))
                                    
                                }
                            }
                        }
                    } else{
                        Text("No messages found!")
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
    
    @State private var navigateToProfile: Bool = false
    
    var body: some View{
        HStack{
            Image(systemName: "circle.fill")
                .font(.system(size: 8))
                .foregroundColor(AppColors.mainAccent)
                .opacity(hasUnreadMessages ? 100 : 0)

            NavigationLink(destination: HouseOwnerProfileView(user: user!), isActive: $navigateToProfile) {
                            EmptyView()
                        }.hidden()
                        
            Button(action: {
                navigateToProfile = true
            }) {
                            if let url = user?.imageURL{
                                AsyncImage(url: URL(string: url)) { phase in
                                    let size:CGFloat = 40
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
                                            .overlay(
                                                Circle()
                                                    .stroke(AppColors.mainAccent, lineWidth: 1)
                                            )
                                    case .failure:
                                        Image(systemName: "person.circle")
                                            .resizable()
                                            .aspectRatio(contentMode: .fill)
                                            .frame(height: size)
                                            .frame(maxWidth: size)
                                            .background(Color.gray)
                                            .overlay(
                                                Circle()
                                                    .stroke(AppColors.mainAccent, lineWidth: 1)
                                            )
                                    @unknown default:
                                        Image(systemName: "person.circle")
                                            .resizable()
                                            .aspectRatio(contentMode: .fill)
                                            .frame(height: size)
                                            .frame(maxWidth: size)
                                            .background(Color.gray)
                                            .overlay(
                                                Circle()
                                                    .stroke(AppColors.mainAccent, lineWidth: 1)
                                            )
                                    }
                                }
                                .padding(.leading, -50)
                                
                            } else {
                                Image(systemName: "person.circle")
                                    .resizable()
                                    .aspectRatio(contentMode: .fill)
                                    .frame(height: 40)
                                    .frame(maxWidth: 40)
                                //.background(Color.gray)
                                    .padding(.trailing, 5)
                                    .overlay(
                                        Circle()
                                            .stroke(AppColors.mainAccent, lineWidth: 1)
                                    )
                            }
                        }
                        .buttonStyle(PlainButtonStyle())
            
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
        .padding(.leading, -200)
    }
}

#Preview {
    ChatsListView()
}
