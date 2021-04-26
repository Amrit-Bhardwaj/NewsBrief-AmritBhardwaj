//
//  ArticleListRouter.swift
//  NewsBrief
//
//  Created by Amrit Bhardwaj on 20/04/21.
//

import UIKit

/*
 'ArticleListRouter' handles the navigation and wireframing of objects
 */
final class ArticleListRouter: ArticleListPresenterToRouterProtocol {
    
    /// This function is used to create the Article List Module
    static func createModule() -> ArticleListTableViewController {
        
        //TODO: - This can be set using xib too
        let view = mainstoryboard.instantiateViewController(withIdentifier: String(describing: ArticleListTableViewController.self)) as! ArticleListTableViewController
        
        let presenter: ArticleListViewToPresenterProtocol & ArticleListInteractorToPresenterProtocol = ArticleListPresenter()
        let interactor: ArticleListPresenterToInteractorProtocol & ArticleListRemoteOutputProtocol = ArticleListInteractor()
        let router:ArticleListPresenterToRouterProtocol = ArticleListRouter()
        let fileManager: FileManagerProtocol = ArticleFileManager()
        let remoteDataManager: ArticleListRemoteInputProtocol = ArticleListRemoteDataManager()
        
        remoteDataManager.remoteRequestHandler = interactor
        interactor.remoteDataManager = remoteDataManager
        view.presenter = presenter
        presenter.view = view
        presenter.router = router
        presenter.interactor = interactor
        interactor.presenter = presenter
        interactor.fileManager = fileManager
        return view
    }
    
    /// Main Storyboard Instance
    static var mainstoryboard: UIStoryboard{
        return UIStoryboard(name: FileConstants.main, bundle: Bundle.main)
    }
    
    /// This function is used to present Article Detail View
    ///
    /// - Parameters:
    ///   - view: Presenter View
    ///   - article: Article Data for the Presented View
    func presentArticleDetailScreen(fromView view: ArticleListPresenterToViewProtocol, forArticle article: Article) {
        let aritcleDetailViewController = ArticleDetailsRouter.createModule(forArticle: article)
        
        if let sourceView = view as? UIViewController {
            sourceView.navigationController?.pushViewController(aritcleDetailViewController, animated: true)
        }
    }
}


