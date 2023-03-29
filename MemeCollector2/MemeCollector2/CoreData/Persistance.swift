//
//  Persistance.swift
//  MemeCollector2
//
//  Created by Andree Carlsson on 2022-10-25.
//

import Foundation
import CoreData


// MARK: Vår manuellt uppsatta persistenscontroller. Sätter upp BasicFunktinerna som containers.
struct PersistenceController {
    static let shared = PersistenceController()
    
    
   // Hela denna "Previewstruct lade jag till själv för att försöka få igång preview"
    static var preview: PersistenceController = {
        let result = PersistenceController(inMemory: true)
        let viewContext = result.container.viewContext
        for _ in 0..<10 {
            let newItem = Albums(context: viewContext)
            newItem.value = ""
        }
        do {
            try viewContext.save()
        } catch {
            // Replace this implementation with code to handle the error appropriately.
            // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            let nsError = error as NSError
            fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
        }
        return result
    }()
    
    let container: NSPersistentContainer
    
    
    init(inMemory: Bool = false) {
        /*
        container = NSPersistentContainer(name: "MemeCollector2")
        if inMemory {
            container.persistentStoreDescriptions.first!.url = URL(fileURLWithPath: "/dev/null")
        }
        container.viewContext.automaticallyMergesChangesFromParent = true
        //TODO: Det ska inte vara Fatal error här. Hantera på annat vis.
         */
        
        let storeURL = URL.storeURL(for: "group.coredata.toextention", databaseName: "DataModel")
        let storeDescription = NSPersistentStoreDescription(url: storeURL)
        container = NSPersistentContainer(name: "MemeCollector2")
        container.persistentStoreDescriptions = [storeDescription]
        //container.viewContext.automaticallyMergesChangesFromParent = true
        

        
        
        container.loadPersistentStores { NSPersistentStoreDescription, err in
            if let err = err {
                fatalError(err.localizedDescription)
            }
        }
    }
    
    // MARK: Vår funktion för att spara till CoreData
    func save() throws {
        let context = container.viewContext
        if context.hasChanges {
            try context.save()
        }
    }
    // MARK: Vår funktion för delete. Den avslutar med att spara ändringarna.
        func delete(_ object: NSManagedObject) throws {
            let context = container.viewContext
            context.delete(object)
            try save()
            
        }
        
    }

