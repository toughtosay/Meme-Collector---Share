//
//  ShareViewController.swift
//  MemeCollectorShare
//
//  Created by Andree Carlsson on 2022-12-19.
//

import UIKit
import Social
import Foundation

import MobileCoreServices
import CoreData

class ShareViewController: SLComposeServiceViewController {
    //var coreDataExtension = CoreData()
    //class ShareViewController: UIViewController {
    let persistenceController = PersistenceController.shared
    
    //@Environment(\.managedObjectContext) var viewContext
    
    /*
     @FetchRequest(
     sortDescriptors: [NSSortDescriptor(keyPath: \Albums.value, ascending: true)],
     animation: .default)
     */
    private var allalbums = [Albums]()  //FetchedResults<Albums>
    
    
    var selectedRow : Int?
    
    override func isContentValid() -> Bool {
        // Do validation of contentText and/or NSExtensionContext attachments here
        return true
    }
    
    override func didSelectPost() {
        
        print("{o}didSelectPost")
        
        // This is called after the user selects Post. Do the upload of contentText and/or NSExtensionContext attachments.
        
        // Inform the host that we're done, so it un-blocks its UI. Note: Alternatively you could call super's -didSelectPost, which will similarly complete the extension context.
        if let content = extensionContext!.inputItems.first as? NSExtensionItem {
           
            
            //Here we are checking the content Types. kUTTypeMovie and kUTTypeImage are the standard types for video and image respectively
            let contentTypes = [kUTTypeImage as? String, kUTTypeURL as? String]
            if let contents = content.attachments as? [NSItemProvider] {
                for attachment in contents {
                    for contentType in contentTypes {
                        if attachment.hasItemConformingToTypeIdentifier(contentType!) {
                            attachment.loadItem(forTypeIdentifier: contentType!, options: nil) { data, error in
                                
                                /* let content = extensionContext!.inputItems[0] as! NSExtensionItem
                                 
                                 let contentTypeImage = kUTTypeImage as String
                                 //let contentTypeImage = "public.jpeg" //kUTTypeImage as String
                                 
                                 print(content.attachments)
                                 
                                 for attachment in content.attachments as! [NSItemProvider] {
                                 print("{o} SHARE1")
                                 if attachment.hasItemConformingToTypeIdentifier(contentTypeImage) {
                                 print("{o} SHARE2")
                                 attachment.loadItem(forTypeIdentifier: contentTypeImage, options: nil) { data, error in */
                                print("{o} SHARE3")
                                print("{o}Rådata in: \(String(describing: data))")
                                if error == nil {
                                    let someUrl = data as? URL
                                    
                                    let someData = data as? Data
                                    
                                    
                                    var shareimage : UIImage?
                                    
                                    if(someUrl != nil)
                                    {
                                        print("{o}URL - > ShareImage: \(String(describing: someUrl))")
                                        shareimage = UIImage(data: try! Data(contentsOf: someUrl!))
                                    }
                                    if(someData != nil)
                                    {
                                        print("{o}Data - > ShareImage: \(String(describing: someUrl))")
                                        shareimage = UIImage(data: someData!)
                                    }
                                    
                                    if(shareimage != nil)
                                    {
                                        print("{o}ShareImage = \(String(describing: shareimage))")
                                        
                                        let filename = UUID().uuidString
                                        
                                        // SPARA FIL
                                        /*let pathX = FileManager.default.urls(for: .documentDirectory,
                                         in: .userDomainMask)[0].appendingPathComponent(filename)*/
                                        
                                        let groupURL = FileManager.default.containerURL(forSecurityApplicationGroupIdentifier: "group.coredata.toextention")
                                        
                                        let path = groupURL!.appendingPathComponent(filename)
                                        
                                        try? shareimage!.pngData()!.write(to: path)
                                        print("{o}Sparar till PATH : \(String(describing: path))")
                                        
                                        
                                        let meme = Memes(context: self.persistenceController.container.viewContext)
                                        meme.value = filename
                                        print("{o}Filename: \(String(describing: filename))")
                                        meme.addToAlbums(self.allalbums[self.selectedRow!])
                                        
                                        do {
                                            try PersistenceController.shared.save()
                                        } catch {
                                            print(error.localizedDescription)
                                        }
                                    }
                                    
                                } else {
                                    print("**SHARE ERROR**")
                                    print(error ?? "Error")
                                }
                                self.extensionContext!.completeRequest(returningItems: [], completionHandler: nil)
                            }
                        }
                    }
                }
            }
        }
    }
                override func configurationItems() -> [Any]! {
                    // To add configuration options via table cells at the bottom of the sheet, return an array of SLComposeSheetConfigurationItem here.
                    
                    let fetchRequest: NSFetchRequest<Albums> = Albums.fetchRequest()
                    do {
                        // Peform Fetch Request
                        allalbums = try persistenceController.container.viewContext.fetch(fetchRequest)
                    } catch {
                        print("{o}Unable to Fetch saker, (\(error))")
                    }
                    
                    var albumsItems = [SLComposeSheetConfigurationItem]()
                    
                    for (index, alb) in allalbums.enumerated() {
                        print("{o}Album i loopen: \(index)")
                        
                        let item = SLComposeSheetConfigurationItem()
                        if(selectedRow == index)
                        {
                            item?.title = "                      -> \(alb.value ?? "") <-"
                        } else {
                            item?.title = "\(alb.value ?? "")"
                        }
                        item?.value = alb.value ?? ""
                        item?.tapHandler = {
                            print("{o}Taphalder!")
                            
                            self.selectedRow = index
                            print("{o}Valde plats: \(index)")
                            self.reloadConfigurationItems()
                        }
                        
                        albumsItems.append(item!)
                        
                    }
                    return albumsItems
                    
                }
            }
            
        
    

