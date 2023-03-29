////
//  UserAlbums.swift
//  MemeCollector2
//
//  Created by Andree Carlsson on 2022-10-11.
//

import SwiftUI

struct UserAlbums: View {
    @Environment(\.presentationMode) var presentationmode
    
    @State var showingSheet = false
    @State var isShowing = false
    
    var body: some View {
        
        NavigationStack {
            ZStack {
                Color("BlackHex")
                    .ignoresSafeArea()
                
                VStack {
                    Image("Logo")
                        .resizable()
                        .frame(width: 280, height: 130)
                        .imageScale(.large)
                        .foregroundColor(.black)
                    Spacer()
                }
                .padding(.top, 70)
                
                VStack {
                    ButtonWithLabel(label: "Create new Album", image: "square.grid.3x1.folder.badge.plus", action: {
                        
                        showingSheet.toggle()
                        
                    })
                    .frame(maxHeight: 300)
                    .sheet(isPresented: $showingSheet) {
                        CreateNewAlbum().presentationDetents([.fraction(0.30)]) }
                }
                .padding(20)
                .padding(.top, -170)
                
                ZStack(alignment: .topLeading){
                    Color.clear
                    Button(action: {
                        presentationmode.wrappedValue.dismiss()
                        
                    }, label: {
                        Image(systemName: "chevron.backward")
                            .foregroundColor(  Color("OrangeHex"))
                    })
                    
                    HStack {
                        AlbumsListView()
                    }
                    .background(Color("BlackHex"))
                    .frame(maxHeight: 400)
                    .padding(.top, 350)
                    
                }
                .padding()
            }
        }
    }
}
struct UserAlbums_Previews: PreviewProvider {
    static var previews: some View {
        UserAlbums().environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
    }
}


