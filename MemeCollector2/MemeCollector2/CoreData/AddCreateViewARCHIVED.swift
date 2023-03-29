//
//  addAndCreate.swift
//  MemeCollector2
//
//  Created by Andree Carlsson on 2022-09-30.
//

import SwiftUI

struct AddCreateViewARCHIVED: View {
    
    @Environment(\.presentationMode) var presentationmode
  
    var colorBlack = #colorLiteral(red: 0.2235294118, green: 0.2156862745, blue: 0.1960784314, alpha: 1)
    var colorOrange = #colorLiteral(red: 0.8352941176, green: 0.6784313725, blue: 0.3254901961, alpha: 1)
    @State var isShowing = false
    
    var body: some View {
        
        ZStack{
            Color(colorBlack)
                .ignoresSafeArea()
            
            VStack {
                Image("smallLogo")
                    .resizable()
                    .frame(width: 300, height: 150)
                    .imageScale(.large)
                    .foregroundColor(.black)
                Spacer()
            }
            .padding(.top, 350)
            
            VStack {
                
                ButtonWithLabel(label: "Existing Album", image: "plus", action: {
                })
                ButtonWithLabel(label: "Create new Album", image: "square.grid.3x1.folder.badge.plus", action: {
                    isShowing = true
                })
                .fullScreenCover(isPresented: $isShowing, content: CreateNewAlbum.init)
            }
            .padding(.top, 500)
            .padding(20)
            Spacer()
                
            
            ZStack(alignment: .topLeading){
                Color.clear
                Button(action: {
                    presentationmode.wrappedValue.dismiss()
                    
                }, label: {
                    Text("Back")
                })
                
            }
            .padding()
        }
    }
}


struct addAndCreate_Previews: PreviewProvider {
    static var previews: some View {
        AddCreateViewARCHIVED()
    }
}
