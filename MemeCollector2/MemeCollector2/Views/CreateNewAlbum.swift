//
//  createNewAlbum.swift
//  MemeCollector2
//
//  Created by Andree Carlsson on 2022-09-30.
//

import SwiftUI

struct CreateNewAlbum: View {
    @Environment(\.presentationMode) var presentationmode
    @Environment(\.managedObjectContext) private var viewContext
    
    @State private var newAlbum = ""
    
    var body: some View {
        ZStack{
            Color("BlackHex")
                .ignoresSafeArea()
            
            VStack {
                
                TextField("Name", text: $newAlbum)
                    .accentColor(.black)
                    .font(.headline)
                    .preferredColorScheme(.light)
                    .foregroundColor(Color("BlackHex"))
                    .fontWeight(.regular)
                    .padding()
                    .background(Color("OrangeHex"))
                    .cornerRadius(10)
                    .background(RoundedRectangle(cornerRadius: 10, style: .continuous)
                        .stroke(Color("FrameColor"), lineWidth: 5.0))
                
                    .limitText($newAlbum, to: 14)
            }
            .padding(40)
            VStack {
                ButtonOne(title: "Create",
                          action: {
                    if(newAlbum == "") {
                        return
                    }
                    save()
                    
                    presentationmode.wrappedValue.dismiss()
                })
            }
            .padding(.top, 140)
            .padding(130)
            Spacer()
        }
    }
    func save() {
        
        let albums = Albums(context: viewContext)
        albums.value = newAlbum
        do {
            try PersistenceController.shared.save()
        } catch {
            print(error.localizedDescription)
            
        }
    }
    
    struct createNewAlbum_Previews: PreviewProvider {
        static var previews: some View {
            CreateNewAlbum()
        }
    }
}
extension View {
    func limitText(_ text: Binding<String>, to characterLimit: Int) -> some View {
        self
            .onChange(of: text.wrappedValue) { _ in
                text.wrappedValue = String(text.wrappedValue.prefix(characterLimit))
            }
    }
}
