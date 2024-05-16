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
        NavigationStack{
            VStack{
                if myHouse == nil {
                    Text("No house created")
                    NavigationLink(destination: CreateHouseView()) {
                        FilledButtonLabel(text:"Create House")
                            .frame(maxWidth: 200)
                    }
                }else{
                    Text("Well, Show the house!")
                }
                
            }
        }
    }
}

#Preview {
    MyHouseView()
}
