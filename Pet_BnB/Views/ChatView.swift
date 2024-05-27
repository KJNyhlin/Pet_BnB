//
//  ChatView.swift
//  Pet_BnB
//
//  Created by Kristian Thun on 2024-05-22.
//

import SwiftUI

struct ChatView: View {
    @StateObject var vm: ChatViewModel
    // @EnvironmentObject var chatListVM: ChatsListViewModel
    @State private var scrollTarget: String?
    
    
    var body: some View {
        
        VStack{
//            if let toUser = vm.toUser{
//                ChatHeader(toUser: toUser)
//            }
            
            ScrollViewReader { proxy in
                List{
                    
                    ForEach(vm.messages){ message in
                        
                        
                        MessageView(message: message, fromLoggedIn: vm.fromLoggedInUser(id: message.senderID), dateString: vm.getDateString(timeStamp: message.timestamp),timeString:vm.getTime(from: message.timestamp), vm:vm)
                            .listRowSeparator(.hidden)
                            .id(message.id)
                            .onAppear{
                                if message == vm.messages.first{
                                    vm.loadMoreMessages()
                                }
                            }
                        
                    }
                }
                .listStyle(.plain)
                .onChange(of: vm.messages){
                    if vm.isFirstLoad{
                        proxy.scrollTo(vm.messages.last?.id)
                        scrollTarget = vm.messages.first?.id
                    } else {
                        proxy.scrollTo(scrollTarget, anchor: .top)
                        scrollTarget = vm.messages.first?.id
                    }
                }
                
            }
            VStack{
                MessageInputView(messageInput: $vm.messageInput, sendAction: vm.sendMessage)
            }
        }
        .padding()
        .onDisappear {
            vm.removeListener()
        }
        .toolbar{
            ToolbarItem(placement: .principal){
                if let toUser = vm.toUser{
                    ChatHeader(toUser: toUser)
                }
            }
        }
        
        
    }
}

struct ChatHeader: View {
    var toUser: User
    var body: some View {
        HStack{
            if let url = toUser.imageURL{
                AsyncImage(url: URL(string: url)) { phase in
                    let size:CGFloat = 30
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
            Text(toUser.firstName ?? "No name")
                .font(.footnote)
                .bold()
        }
    }
}

struct MessageView: View{
    var message: Message
    var fromLoggedIn: Bool
    var dateString: String
    var timeString: String
    var vm: ChatViewModel

    
    var body: some View{
        VStack{
            if !vm.sameAsLastString(string: dateString){
                Text(dateString)
                    .font(.caption2)
            }
            
            HStack{
                VStack(alignment: fromLoggedIn ? .trailing : .leading){
                    Text(message.text)
                        .padding(.horizontal)
                        .padding(.vertical, 5)
                        .background(fromLoggedIn ? AppColors.mainAccent : Color(.systemGray6))
                        .cornerRadius(20)
          
                    Text(timeString)
                        .font(.caption2)
                    
                }
                .padding(fromLoggedIn ? .leading : .trailing, 50)
   
            }
            .frame(maxWidth: .infinity, alignment: fromLoggedIn ? .trailing : .leading)
        }
    }
}

struct MessageInputView: View {
    @Binding var messageInput: String
    var sendAction: () -> Void
    var body: some View {
        HStack(){
            TextField("Message", text: $messageInput, axis: .vertical)
                .padding(EdgeInsets(top: 0, leading: 10, bottom: 0, trailing: 10))
                .lineLimit(5)
                .frame(maxWidth: .infinity)

            
            Button(action: {
                sendAction()
                
            }, label: {
                Image(systemName: messageInput.isEmpty ? "stop.circle.fill" : "arrow.up.circle.fill")
                    .font(.title)
                    .contentTransition(.symbolEffect(.replace))
            })
        }
        .padding(10)
        .overlay(
            RoundedRectangle(cornerRadius: 25.0)
                .stroke(AppColors.mainAccent, lineWidth: 3)
        )
    }
}

//#Preview {
//    ChatView(vm: ChatViewModel(toUserID: "2", chat: Chat(participants: ["1","2"], unReadMessagesCount: ["1":1, "2": 2], messages: [Message(senderID: "1", text: "Hello", isRead: ["1":true, "2":false]),Message(senderID: "2", text: "Godbye", isRead: ["1":false, "2":true])])))
//}
