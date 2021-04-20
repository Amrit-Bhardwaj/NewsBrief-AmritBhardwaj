//
//  ArticleListInteractor.swift
//  NewsBrief
//
//  Created by Amrit Bhardwaj on 20/04/21.
//

import Foundation

final class ArticleListInteractor: PresenterToInteractorProtocol {
    
    var presenter: InteractorToPresenterProtocol?
    var databaseManager: DatabaseManagerProtocol?
    var fileManager: FileManagerProtocol?
    
    //1. Fetch the Article details from news API, map it to ArticleModel and save the details to coredata entity
    //2. Download the image using the image url and save it to Application support directory with name+date as fileName
    
    // TODO: -  We can use an Operation Queue and enqueue the two tasks and set dependency
    // TODO: - using a Dispatch Group to perform concurrent download of images
    
     func fetchArticleDetails() {
        
        //Fetching the last entry in the dB, sorted based on date
        // We can improve the fetch using faulting and memory pruning
//        let dbEntry = databaseManager?.fetch()
//        let currenEffectiveDate = Date().effectiveCurrentDate().convertToLocalTime()
//
//
//        // Case 1: if network is reachable and dB does not have any entry for current Date, We trigger API call
//        if NetworkReachabilityManager.shared.connectedToNetwork() {
//
//            if dbEntry == nil || dbEntry?.0 != currenEffectiveDate {
//                performFetch()
//
//            } else {
//
//                // Case 4: when Internet is available and dB has entry for current Date, we show the image from directory
//                if let dBData = dbEntry, dBData.0 == currenEffectiveDate {
//
//                    let imageData = fileManager?.openFile(fileName: dBData.3!)
//                    self.presenter?.imageFetchedSuccess(imageData: imageData!, title: dBData.1!, explanation: dBData.2!)
//                }
//            }
//
//        } else {
//
//            // Case 2: if network is not reachable and dB has entry for current Date, we show the image from directory
//            if let dBData = dbEntry, dBData.0 == currenEffectiveDate {
//
//                let imageData = fileManager?.openFile(fileName: dBData.3!)
//                self.presenter?.imageFetchedSuccess(imageData: imageData!, title: dBData.1!, explanation: dBData.2!)
//            }
//
//            // Case 3: if network is not reachable and dB does not have an entry for current Date, fetch the last available entry in the dB and show its image from directory
//            if let dBData = dbEntry, dBData.0 != nil && dBData.0 != currenEffectiveDate {
//
//                let imageData = fileManager?.openFile(fileName: dBData.3!)
//                self.presenter?.imageFetchedSuccess(imageData: imageData!, title: dBData.1!, explanation: dBData.2!)
//
//            }
//
//            self.presenter?.imageFetchFailed()
//        }
        performFetch()
        
    }
    
    private func performFetch() {
        
        // fetch 20 Items per page
        
        let articleDetailsTask = GetArticleDetailsTask(apiKey: Api.key, country: "us", category: "business", pageSize: "20", page: "0")
        
        let dispatcher = NetworkDispatcher(environment: Environment(Env.debug.rawValue, host: AppConstants.baseUrl))
        
        articleDetailsTask.execute(in: dispatcher) { [weak self] (json) in
            
            if let jsonData = json as? [String: AnyObject], let articles = jsonData["articles"] as? [AnyObject] {
                
            }
            
//            if let imageUrl = articleModel.url {
//
//                let fileName = imageUrl.components(separatedBy: "//")[1].components(separatedBy: "/").last!
//
//                self?.downloadImage(withUrl: imageUrl, success: { (data) in
//
//                    // 1. Save the data to file system and return the image
//                    // 2. Make an entry to dB with the data
//
//                    if let data = data as? Data {
//                        DispatchQueue.main.async {
//
//                            self?.saveToFileSystem(withFileName: fileName, fileData: data)
//
//                            self?.saveTodB(attachmentData: articleModel)
//
//                            self?.presenter?.imageFetchedSuccess(imageData: data, title: articleModel.title!, explanation: articleModel.description!)
//                        }
//                    }
//
//                }, failure: { (error) in
//                    self?.presenter?.imageFetchFailed()
//                })
//            }
            
        } failure: { (error) in
            self.presenter?.imageFetchFailed()
        }
    }
    
    // Download the Attachment Data
    private func downloadImage(withUrl url: String, success: @escaping ((Any) -> Void), failure: @escaping ((Error?) -> Void)) {
        
        //TODO: - The url should be split into baseurl and relative path
        //TODO: - The constants should be moved to AppConstants
        //        let baseUrl = url.components(separatedBy: "//")[1].components(separatedBy: "/").first
        
        let dispatcher = NetworkDispatcher(environment: Environment(Env.debug.rawValue, host: url))
        let attachmentDownloadTask = DownloadAttachmentDataTask(path: "")
        
        attachmentDownloadTask.execute(in: dispatcher) { (data) in
            success(data)
            
        } failure: { (error) in
            NSLog("Could not download the image")
            failure(error)
        }
        
    }
    
    // Save the downloaded image to file System
    private func saveToFileSystem(withFileName name: String, fileData: Data) {
        fileManager?.save(fileName: name, file: fileData)
    }
    
    // Save the image details to dB
    private func saveTodB(attachmentData data: ArticleModel) {
        
        let fileName = data.url!.components(separatedBy: "//")[1].components(separatedBy: "/").last!
        
        let effectiveDate = (data.publishedAt?.toDateWithFormat(withFormat: "yyyy-MM-dd"))!.convertToLocalTime()
        
        databaseManager?.save(date: effectiveDate, explanation: data.description!, filePath: fileName, title: data.title!)
    }
}
