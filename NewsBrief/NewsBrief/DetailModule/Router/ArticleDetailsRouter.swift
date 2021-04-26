//
//  ArticleDetailsRouter.swift
//  NewsBrief
//
//  Created by Amrit Bhardwaj on 21/04/21.
//

import UIKit

/*
 'ArticleDetailsRouter' handles the navigation and wireframing of objects
 */
final class ArticleDetailsRouter: ArticleDetailsPresenterToRouterProtocol {
    
    /// This function is used to create the Article Detail Module
    ///
    /// - Parameters:
    ///   - article: Article Data
    ///
    /// - Returns: Article Details controller
    static func createModule(forArticle article: Article) -> ArticleDetailTableViewController {
        
        let view = ArticleDetailTableViewController(nibName: String(describing: ArticleDetailTableViewController.self),
                                                    bundle: Bundle.main)
        let presenter: ArticleDetailsViewToPresenterProtocol & ArticleDetailsInteractorToPresenterProtocol = ArticleDetailsPresenter()
        let interactor: ArticleDetailsPresenterToInteractorProtocol & ArticleDetailsRemoteOutputProtocol = ArticleDetailsIntereactor()
        let router:ArticleDetailsPresenterToRouterProtocol = ArticleDetailsRouter()
        let remoteDataManager: ArticleDetailsRemoteInputProtocol = ArticleDetailRemoteDataManager()
            
        interactor.remoteDataManager = remoteDataManager
        remoteDataManager.remoteRequestHandler = interactor
        view.presenter = presenter
        presenter.view = view
        presenter.article = article
        presenter.router = router
        presenter.interactor = interactor
        interactor.presenter = presenter
        return view
    }
    
    /// Returns main storyboard instance
    static var mainStoryboard: UIStoryboard {
        return UIStoryboard(name: FileConstants.main, bundle: Bundle.main)
    }
}
