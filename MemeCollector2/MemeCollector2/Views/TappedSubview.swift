//
//  UserTapedSubview.swift
//  MemeCollector2
//
//  Created by Andree Carlsson on 2022-11-27.
//

import SwiftUI

struct TappedSubview: View {
    @Environment(\.managedObjectContext) private var viewContext
    @Environment(\.presentationMode) var presentationmode
    
    @Binding var currentmeme : Memes

    @State private var showDeleteAlert = false
    
    var body: some View {
        ZStack() {
            Color("BlackHex")
                .ignoresSafeArea()
            
            VStack {
                Image(uiImage: UIImage(contentsOfFile: getFileURL(filename: currentmeme.value)) ?? UIImage())
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .cornerRadius(10)
                    .shadow(color: Color.primary.opacity(0.3), radius: 1)
                    .padding()
                
                ZStack(alignment: .bottom) {
                    Color.clear
                    
                    HStack {
                        Button(action: {
                            showDeleteAlert = true
                        }) {
                            Label("Delete", systemImage: "trash.fill")
                        }
                        .alert("Are you sure you want to delete?", isPresented: $showDeleteAlert) {
                            Button("Cancel", role: .cancel) {
                                
                            }
                            Button("Delete", role: .destructive) {
                                deleteMeme()
                                presentationmode.wrappedValue.dismiss()
                            }
                        }
                        ShareLink(item: Image(uiImage: UIImage(contentsOfFile: getFileURL(filename: currentmeme.value)) ?? UIImage())
                            .resizable(),
                                  
                                  subject: Text(""),
                                  message: Text("Sent from MemeCollector - IOS app"),
                                  preview: SharePreview("", image: Image(uiImage: UIImage(contentsOfFile: getFileURL(filename: currentmeme.value)) ?? UIImage()) .resizable()))

                    }
                    .foregroundColor(Color("OrangeHex"))
                    .bold()
                }
                .frame(width: 200, height: 20)
                .padding(.bottom, 20)
            }
        }
    }
    
    func deleteMeme() {
        viewContext.delete(currentmeme)
        
        do {
            try viewContext.save()
        } catch {
            print(error.localizedDescription)
            
        }
        
        if let imgfilename = currentmeme.value {
            let pathX = FileManager.default.urls(for: .documentDirectory,
                                                in: .userDomainMask)[0].appendingPathComponent(imgfilename)
            
            let groupURL = FileManager.default.containerURL(forSecurityApplicationGroupIdentifier: "group.coredata.toextention")
            
            let path = groupURL!.appendingPathComponent(imgfilename)
            
            
            do {
                try FileManager.default.removeItem(at: path)
                print("Image has been deleted")
            } catch {
                print(error)
            }
        }
        
        // Gå tillbaka
        
    }
    
}


struct UserTapedSubview_Previews: PreviewProvider {
    static var previews: some View {
        TappedSubview(currentmeme: .constant(Memes()))
    }
}
