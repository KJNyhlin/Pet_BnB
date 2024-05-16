//
//  CreateHouseView.swift
//  Pet_BnB
//
//  Created by Kristian Thun on 2024-05-15.
//

import SwiftUI
import PhotosUI

struct CreateHouseView: View {
    @StateObject var vm = CreateHouseViewModel()
    @EnvironmentObject var firebaseHelper: FirebaseHelper
    @Environment(\.presentationMode) var presentationMode
    
    
    var body: some View {
        NavigationStack{
            VStack{
                
                Form{
                    Section(header: Text("Information")){
                        TextField("Title", text: $vm.title)
                        HStack{
                            PhotosPicker(selection: $vm.imageSelection, matching: .images){
                                Label(title: {
                                    Text("Image")
                                }, icon:{
                                    Image(systemName: "photo")
                                })
                                
                            }
                            Spacer()
                            if let image = vm.image{
                                Image(uiImage: image)
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 40, height: 40)
                            }else {
                                Text("No image")
                            }
                            
                        }
                    }
                    Section(header: Text("Description")){
                        TextEditor(text: $vm.description)
                            .frame(minHeight: 100)
                    }
                }
                Button(action: {
                    if vm.saveHouse(){
                        presentationMode.wrappedValue.dismiss()
                    }
                 
                   
                }, label: {
                    FilledButtonLabel(text: "Save")
                        .padding(.vertical, 10)
                        .padding(.horizontal, 30)
                       
                })
            }
            .navigationTitle("Create House")
        }
        
    }
}

#Preview {
    CreateHouseView()
}
