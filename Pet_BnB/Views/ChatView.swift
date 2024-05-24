//
//  ChatView.swift
//  Pet_BnB
//
//  Created by Kristian Thun on 2024-05-22.
//

import SwiftUI

struct ChatView: View {
    @StateObject var vm: ChatViewModel
        
    var body: some View {
        
        VStack{
            
            ScrollViewReader { proxy in
                List{
                    ForEach(vm.messages){ message in
                        
                        MessageView(message: message, fromLoggedIn: vm.fromLoggedInUser(id: message.senderID))
                            .listRowSeparator(.hidden)
                            .id(message.id)
                    }
                }
                .listStyle(.plain)
                .onChange(of: vm.messages){
                    proxy.scrollTo(vm.messages.last?.id)
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
    
    }
}

struct MessageView: View{
    var message: Message
    var fromLoggedIn: Bool
    
    var body: some View{
        HStack{
            Text(message.text)
                .padding()
                .background(fromLoggedIn ? .blue : AppColors.mainAccent)
                .cornerRadius(20)
                .padding(fromLoggedIn ? .leading : .trailing, 50)
            
            
        }
        .frame(maxWidth: .infinity, alignment: fromLoggedIn ? .trailing : .leading)
        
        //   .padding()
    }
}

struct MessageInputView: View {
    @Binding var messageInput: String
    var sendAction: () -> Void
    var body: some View {
        HStack(){
            //       EntryFields(placeHolder: "Message", promt: "", field: $messageInput)
            TextField("Message", text: $messageInput, axis: .vertical)
                .padding(EdgeInsets(top: 0, leading: 20, bottom: 0, trailing: 20))
            
                .lineLimit(5)
                .frame(maxWidth: .infinity)
                .padding(10)
            //    .background(.regularMaterial)
                .overlay(
                    RoundedRectangle(cornerRadius: 25.0)
                        .stroke(AppColors.mainAccent, lineWidth: 3)
                )
            
            Button(action: {
                sendAction()
                
            }, label: {
                Text("Send")
                    .padding()
                    .background()
                    .cornerRadius(10)
                
            })
            
        }
        //.background()
        //.background(.regularMaterial)
        //.padding(.horizontal)
    }
}

//#Preview {
//    ChatView(vm: ChatViewModel(toUserID: "2", chat: Chat(participants: ["1","2"], unReadMessagesCount: ["1":1, "2": 2], messages: [Message(senderID: "1", text: "Hello", isRead: ["1":true, "2":false]),Message(senderID: "2", text: "Godbye", isRead: ["1":false, "2":true])])))
//}
