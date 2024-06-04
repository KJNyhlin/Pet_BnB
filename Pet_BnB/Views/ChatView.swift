//
//  ChatView.swift
//  Pet_BnB
//
//  Created by Kristian Thun on 2024-05-22.
//

import SwiftUI

struct ChatView: View {
    @StateObject var vm: ChatViewModel
    @State private var scrollTarget: String?
    @Environment(\.dismiss) var dismiss
    
    
    var body: some View {
        
        VStack{
            ScrollViewReader { proxy in
                List{
                    ForEach(vm.messages){ message in
                        MessageView(message: message, fromLoggedIn: vm.fromLoggedInUser(id: message.senderID), dateString: vm.getDateString(timeStamp: message.timestamp),timeString:vm.getTime(from: message.timestamp), vm:vm)
                            .listRowSeparator(.hidden)
                            .onAppear{
                                if message == vm.messages.last{
                                    vm.loadMoreMessages()
                                }
                            }
                            .flippedUpsideDown()
                    }
                }
                .listStyle(.plain)
                .flippedUpsideDown()
            }
            VStack{
                MessageInputView(messageInput: $vm.messageInput, sendAction: vm.sendMessage)
            }
        }
        .padding()
        .onAppear{
            if vm.isLoggedIn(){
                vm.startListener()
            } else{
                dismiss()
            }
            
        }
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
        NavigationLink(destination: HouseOwnerProfileView(user: toUser)) {
            HStack{
                AsyncImageView(imageUrl: toUser.imageURL, maxWidth: 30, height: 30, isCircle: true)
                Text(toUser.firstName ?? "No name")
                    .font(.footnote)
                    .bold()
            }
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
            if vm.dateStringChanged(string: dateString){
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

struct FlippedUpsideDown: ViewModifier {
    func body(content: Content) -> some View {
        content
            .rotationEffect(.degrees(180))
            .scaleEffect(x: -1, y: 1, anchor: .center)
    }
}
extension View{
    func flippedUpsideDown() -> some View{
        self.modifier(FlippedUpsideDown())
    }
}

//#Preview {
//    ChatView(vm: ChatViewModel(toUserID: "2", chat: Chat(participants: ["1","2"], unReadMessagesCount: ["1":1, "2": 2], messages: [Message(senderID: "1", text: "Hello", isRead: ["1":true, "2":false]),Message(senderID: "2", text: "Godbye", isRead: ["1":false, "2":true])])))
//}
