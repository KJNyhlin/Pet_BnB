//
//  MyHouseView.swift
//  Pet_BnB
//
//  Created by Jonas Bondesson on 2024-05-15.
//

import SwiftUI

struct MyHouseView: View {
    var myHouse: House?
    var body: some View {
        VStack{
            if myHouse == nil {
                Text("No house created")
                Button(action: {
                    
                }, label: {
                    FilledButtonLabel(text:"Create House")
                        
                })
                
            }else{
                Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
            }
            
        }
    }
}

#Preview {
    MyHouseView()
}
