//
//  ArticleFileManager.swift
//  NewsBrief
//
//  Created by Amrit Bhardwaj on 20/04/21.
//

import UIKit

/* This class handles all the file system related operations
 */
final class ArticleFileManager: FileManagerProtocol {
    
    private var manager = FileManager.default
    
    /* This function is used to save the data with the fileName into Application support directory
     */
    func save(fileName: String, file: Data) {
        let directoryURL = manager.urls(for: .documentDirectory, in: .userDomainMask).first
        if let fileURL = directoryURL?.appendingPathComponent(fileName) {
            if !manager.fileExists(atPath: fileURL.path) {
                
                do {
                    try file.write(to: fileURL)
                } catch {
                    // Handle Error gracefully
                }
            }
        }
    }
    
    /* This function is used to open the fileName from Application support directory
     */
    func openFile(fileName: String) -> Data? {
        let directoryURL = manager.urls(for: .applicationSupportDirectory, in: .userDomainMask).first
        
        if let fileURL = directoryURL?.appendingPathComponent(fileName) {
            if manager.fileExists(atPath: fileURL.path) {
                let fileData = manager.contents(atPath: fileURL.path)
                return fileData
            }
        }
        
        return nil
    }
}

