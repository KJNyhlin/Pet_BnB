//
//  CreateHouseView.swift
//  Pet_BnB
//
//  Created by Kristian Thun on 2024-05-15.
//

import SwiftUI

struct CreateHouseView: View {
    @State private var title = ""
    @State private var description = ""
    @EnvironmentObject var firebaseHelper: FirebaseHelper
    
    
    var body: some View {
        NavigationStack{
            VStack{
                
                
                Form{
                    Section(header: Text("Information")){
                        TextField("Title", text: $title)
                        HStack{
                            Text("Images")
                        }
                        
                    }
                    Section(header: Text("Description")){
                        TextEditor(text: $description)
                            .frame(minHeight: 100)
                    }
                    
                }
                Button(action: {
                    if !title.isEmpty && !description.isEmpty{
                        let house = House(title: title, description: description)
                        firebaseHelper.save(house: house)
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
