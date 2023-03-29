//
//  PhotoPicker.swift
//  MemeCollector2
//
//  Created by Andree Carlsson on 2022-10-01.
//
import SwiftUI
import PhotosUI
import CoreData

struct PhotoPicker: View {
    
    @Environment(\.managedObjectContext) private var viewContext
    @Environment(\.presentationMode) var presentationmode
    @Environment(\.dismiss) private var dismiss
    
    @State var selectedItems = [PhotosPickerItem]()
    @State var selectedImages = [UIImage]()
    
    var currentalbum : Albums?
    
    var body: some View {
        
        ZStack {
            Color("BlackHex")
                .ignoresSafeArea()
            PhotosPicker(selection: $selectedItems, matching: .any(of: [.images, .screenshots])) {
                
                Label("Add Memes!", systemImage: "plus.app" )
                    .fontWeight(.heavy)
                    .frame(height: 50)
                    .foregroundColor((Color("OrangeHex")))
            }
        }
        .onChange(of: selectedItems) { newValues in
            presentationmode.wrappedValue.dismiss()
            
            Task {
                selectedImages = []
                for value in newValues {
                    if let imageData = try? await value.loadTransferable(type: Data.self), let image = UIImage(data:imageData) {
                        selectedImages.append(image)
                        let imgfilename = UUID().uuidString
                       /* let pathX = FileManager.default.urls(for: .documentDirectory,
                                                            in: .userDomainMask)[0].appendingPathComponent(imgfilename)*/
                        
                        
                        let groupURL = FileManager.default.containerURL(forSecurityApplicationGroupIdentifier: "group.coredata.toextention")
                        
                        let path = groupURL!.appendingPathComponent(imgfilename)
                        
                        
                        try? imageData.write(to: path)
                        
                        guard let currentalbum = currentalbum else { return }
                        saveMeme(imgfilename: imgfilename, album: currentalbum, viewContext: viewContext)
                        
                    }
                    
                }
            }
        }
    }
}

func saveMeme(imgfilename: String, album: Albums, viewContext: NSManagedObjectContext) {
    
    let meme = Memes(context: viewContext)
    meme.value = imgfilename
    meme.addToAlbums(album)
    do {
        try PersistenceController.shared.save()
    } catch {
        print(error.localizedDescription)
    }
}
