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
        ZStack{
            Color.secondary
                .ignoresSafeArea()
 
            VStack{
                Spacer()
                VStack{
  //                  if let chat = vm.chat{
                    
                    List{
                        ForEach(vm.messages){ message in
                            //            Text(message.text)
                            MessageView(message: message, fromLoggedIn: vm.fromLoggedInUser(id: message.senderID))
                            //                    }
                        }
                    }
                    .listStyle(.plain)
                    .frame(maxHeight: .infinity)
                    
                }
                MessageInputView(messageInput: $vm.messageInput, sendAction: vm.sendMessage)
            }
            .padding()

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
            
        }
        .frame(maxWidth: .infinity, alignment: fromLoggedIn ? .trailing : .leading)
        .border(.orange)
     //   .padding()
    }
}

struct MessageInputView: View {
    @Binding var messageInput: String
    var sendAction: () -> Void
    var body: some View {
        HStack(){
     //       EntryFields(placeHolder: "Message", promt: "", field: $messageInput)
            TextField("Message", text: $messageInput)
                .padding(EdgeInsets(top: 0, leading: 20, bottom: 0, trailing: 20))
                .frame(maxWidth: .infinity)
                .padding(10)
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
        //.padding(.horizontal)
    }
}

//#Preview {
//    ChatView(vm: ChatViewModel(toUserID: "2", chat: Chat(participants: ["1","2"], unReadMessagesCount: ["1":1, "2": 2], messages: [Message(senderID: "1", text: "Hello", isRead: ["1":true, "2":false]),Message(senderID: "2", text: "Godbye", isRead: ["1":false, "2":true])])))
//}
