
//
//  AlbumRowsView.swift
//  MemeCollector2
//
//  Created by Andree Carlsson on 2022-11-02.
//
import SwiftUI
struct AlbumsListView: View {
    
    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \Albums.value, ascending: true)],
        animation: .default)
    
 
    private var albums: FetchedResults<Albums>
  
    var body: some View {
        
        ZStack {
            Color("BlackHex")
                .ignoresSafeArea()
            
            if(albums.count > 0)
            {
                List {
                    ForEach(albums) { album in
                        HStack{
                            NavigationLink {
                                
                                let memesFetchRequest =
                                    FetchRequest<Memes>(sortDescriptors: [NSSortDescriptor(keyPath: \Memes.value, ascending: true)],
                                    predicate: NSPredicate(format: "%K CONTAINS[cd] %@", #keyPath(Memes.albums), album), animation: .default)
                                
                                MemesView(album: album, memes: memesFetchRequest)
                                   
                            } label: {
                                
                                Label(album.value ?? "", systemImage: "photo.on.rectangle.angled")
                                    .fontWeight(.bold)
                                    .font(.system(size: 20))
                                    .foregroundColor(  Color("BlackHex"))
                                    .multilineTextAlignment(.leading)
                            }
                            .padding(10)
                            
                        }
                        .listRowBackground(  Color("OrangeHex"))
                    }
                    .onDelete(perform: delete(offsets:))
                }
                .scrollContentBackground(.hidden)
            }
        }
        .background(Color.red)
    }

    private func delete(offsets: IndexSet) {
        withAnimation {
            offsets.forEach { offset in
                let category = albums[offset]
                do {
                    try PersistenceController.shared.delete(category)
                } catch {
                    print(error.localizedDescription)
                }
            }
        }
    }
}


//Modifirerad preview, kom ihåg! Även structen är till för detta.
struct AlbumsListView_Previews: PreviewProvider {
    static var previews: some View {
        AlbumsListView().environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
    }
}



