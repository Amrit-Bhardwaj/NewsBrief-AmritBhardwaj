//
//  DownloadAttachmentDataTask.swift
//  NewsBrief
//
//  Created by Amrit Bhardwaj on 20/04/21.
//

import Foundation

/* This class denotes the task of downloading any attachment(media type = .png, .jpeg, .mov)
 */
class DownloadAttachmentDataTask: Task {
    
    var path: String
    
    init(path: String) {
        self.path = path
    }
    
    var request: Request {
        return UserRequests.downloadImage(path: self.path)
    }
    
    func execute(in dispatcher: Dispatcher, success: @escaping ((Any) -> Void), failure: @escaping ((Error?) -> Void)) {
        
        do {
            try dispatcher.execute(request: self.request, success: { (response) in
                
                switch response {
                
                case .data(let data):
                    success(data)
                case .error( _, let errorMessage):
                    failure(errorMessage)
                    
                default:
                    failure(nil)
                }
                
            }, failure: { (error) in
                NSLog("Error while trying to fetch image details")
                failure(error)
            })
        } catch {
            NSLog("Error")
        }
        
    }
}

