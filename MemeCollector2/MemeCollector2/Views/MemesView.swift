////
//  MemesView.swift
//  MemeCollector2
//
//  Created by Andree Carlsson on 2022-11-04.
//
import SwiftUI
import CoreData

struct MemesView: View {
    
    @Environment(\.managedObjectContext) private var viewContext
    
    var album: Albums
    
    @FetchRequest var memes: FetchedResults<Memes>
    
    @State private var tapedImage: Bool = false
    @State private var selectedMeme = Memes()
    
    @State var showAlert = false
    @State var isDeleting = false
    
    var body: some View {
       
        ZStack {
            Color("BlackHex")
                .ignoresSafeArea()
            
            VStack {
                Text(album.value!)
                    .font(.largeTitle)
                    .fontWeight(.heavy)
                    .foregroundColor(Color("OrangeHex"))
                HStack {
                    PhotoPicker(currentalbum: album)
                    
                   Button(action: {
                       isDeleting.toggle()
                   }, label: {
                       if(isDeleting) {
                           Label("DeleteMode", systemImage: "lock.open.trianglebadge.exclamationmark.fill")
                       } else {
                           
                           Label("DeleteMode", systemImage: "lock.fill")
                       }
                   })
                   .foregroundColor(Color("OrangeHex"))
                   .fontWeight(.heavy)
                }
                .frame(width: 300, height: 20)
                .padding()
           
                VStack {
                    if memes.count > 0 {
                        ScrollView(.vertical) {
                            LazyVGrid (columns: [.init(.adaptive(minimum: 200)), .init(.adaptive(minimum: 200))]) {
                                
                                ForEach(memes, id: \.id) { meme in
                                    
                                    ZStack {
                                        Image(uiImage: UIImage(contentsOfFile: getFileURL(filename: meme.value ?? "")) ?? UIImage())
                                            .resizable()
                                              .scaledToFill()
                                              .frame(width: 180, height: 180, alignment: .center)
                                              .contentShape(Rectangle()) //antar frame ovan och clipped får inte gå utanför den rektangeln. 
                                              .clipped()
                                              .cornerRadius(10)
                                              .shadow(color: Color.primary.opacity(0.3), radius: 1)
                                        
                                            .onTapGesture() {
                                                if(isDeleting)
                                                {
                                                    deleteMeme(delmeme: meme)
                                                } else {
                                                   
                                                    selectedMeme = meme
                                                    tapedImage.toggle()
                                                }
                                            }
                                            .sheet(isPresented: self.$tapedImage) {TappedSubview(currentmeme: $selectedMeme ).presentationDetents([.fraction(0.75)])}
                                        
                                        if(isDeleting)
                                        {
                                            ZStack{
                                                RoundedRectangle(cornerRadius: 25)
                                                    .foregroundColor(Color("BlackHex").opacity(0.7))
                                                  //  .fill(.opacity(0.7))
                                                    .frame(width: 60, height: 60)
                                            }
                                            
                                            Image(systemName: "trash.fill")
                                                .resizable()
                                                .foregroundColor(Color("OrangeHex"))
                                                .cornerRadius(5)
                                                .frame(maxWidth: 30, maxHeight: 30, alignment: .bottomTrailing)
                                        }
                                    }
                                }
                            }
                            .padding(.all, 10)
                        }
                    }
                }
            }
            .background(Color("BlackHex"))
        }
    }
    func deleteMeme(delmeme : Memes) {
        viewContext.delete(delmeme)
        
        do {
            try viewContext.save()
        } catch {
            print(error.localizedDescription)
            
        }
        
        if let imgfilename = delmeme.value {
            /*let pathX = FileManager.default.urls(for: .documentDirectory,
                                                in: .userDomainMask)[0].appendingPathComponent(imgfilename)*/
            
            let groupURL = FileManager.default.containerURL(forSecurityApplicationGroupIdentifier: "group.coredata.toextention")
            
            let path = groupURL!.appendingPathComponent(imgfilename)
            
            
            do {
                try FileManager.default.removeItem(at: path)
                print("Image has been deleted")
            } catch {
                print(error)
            }
        }
    }
}

func getFileURL(filename: String?) -> String {
    
    if(filename == nil)
    {
        return ""
    }
    /*
    let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
    let fileName = filename
    let fileURL = documentsDirectory.appendingPathComponent(fileName!)
     */
    
    let groupURL = FileManager.default.containerURL(forSecurityApplicationGroupIdentifier: "group.coredata.toextention")
    
    let path = groupURL!.appendingPathComponent(filename!)
    
    return path.path
}



