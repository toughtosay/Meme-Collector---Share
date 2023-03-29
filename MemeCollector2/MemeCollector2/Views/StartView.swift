//
//  ContentView.swift
//  MemeCollector2
//
//  Created by Andree Carlsson on 2022-09-23.
//

import SwiftUI
import PhotosUI

struct StartView: View {
    
    @State private var showingSheet = false
    @State var isShowing = false
    
    var body: some View {
        
        ZStack{
            Color("BlackHex")
                .ignoresSafeArea()
            
            VStack {
                Image("Logo")
                    .resizable()
                    .frame(width: 380, height: 180)
                    .imageScale(.large)
                    .foregroundColor(Color("BlackHex"))
                
                Spacer()
            }
            .padding(.top, 80)
            
            VStack {
                ButtonWithLabel(label: "Create new Album",
                                image: "square.grid.3x1.folder.badge.plus",
                                action: {
                    
                    showingSheet.toggle()
                })
                .sheet(isPresented: $showingSheet) {
                    CreateNewAlbum() .presentationDetents([.fraction(0.30)])}
                
                ButtonOne(title: "My Albums",
                          action: {
                    isShowing.toggle()
                    
                })
                .fullScreenCover(isPresented: $isShowing, content: UserAlbums.init)
            }
            .padding(.top, 500)
            .padding(20)
            
            Spacer()
        }
        .accentColor(.red)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        StartView()
    }
}
