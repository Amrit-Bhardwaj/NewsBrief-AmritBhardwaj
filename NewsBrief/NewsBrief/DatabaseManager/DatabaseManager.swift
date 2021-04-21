//
//  DatabaseManager.swift
//  NewsBrief
//
//  Created by Amrit Bhardwaj on 21/04/21.
//

import CoreData

/* This enum describes possible error cases while dB operation
 */
enum PersistenceError: Error {
    case managedObjectContextNotFound
    case couldNotSaveObject
    case objectNotFound
}

/*
 This class handles all the coreData dB related Operations
 */
final class DatabaseManager: DatabaseManagerProtocol {
    
    //TODO: - We need to implement an in-memory caching mechanism(LRU, LFU or sliding window algorithm) to reduce number of
    // dB access and reduce overall latency
    
    // This is the main context used for both read and write operations
    // We can use background context to write heavy data
    
    private var moc = AppDelegate.viewContext
    
    /*
     This function performs fetch operation on dB Entity
     */
    func fetch() -> (Date?, String?, String?, String?) {
        
        let _: NSFetchRequest<NewsArticle> = NewsArticle.fetchRequest()
        return (nil, nil, nil, nil)
    }
    
    /*
     This function performs save operation on dB Entity
     */
    func save(date: Date, explanation: String, filePath: String, title: String) {
        do {
            let _ = NewsArticle(context: moc)
            try moc.save()
        } catch {
            //TODO: Handle error while trying to save entries
        }
    }
    
    /*
     This function performs update operation on dB Entity
     */
    func update() {}
}
