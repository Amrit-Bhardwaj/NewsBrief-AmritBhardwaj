//
//  ArticleDetailsRouter.swift
//  NewsBrief
//
//  Created by Amrit Bhardwaj on 21/04/21.
//

import UIKit

final class ArticleDetailsRouter: ArticleDetailsPresenterToRouterProtocol {
    
    static func createModule(forArticle article: Article) -> ArticleDetailTableViewController {
        
     let view = ArticleDetailTableViewController(nibName: "ArticleDetailTableViewController", bundle: Bundle.main)
        let presenter: ArticleDetailsViewToPresenterProtocol & ArticleDetailsInteractorToPresenterProtocol = ArticleDetailsPresenter()
        let interactor: ArticleDetailsPresenterToInteractorProtocol = ArticleDetailsIntereactor()
        let router:ArticleDetailsPresenterToRouterProtocol = ArticleDetailsRouter()
//        let databaseManager: DatabaseManagerProtocol = DatabaseManager()
        let fileManager: FileManagerProtocol = ArticleFileManager()
        view.presenter = presenter
        presenter.view = view
        presenter.article = article
        presenter.router = router
        presenter.interactor = interactor
        interactor.presenter = presenter
        //interactor.databaseManager = databaseManager
        //interactor.fileManager = fileManager
        return view
        
        
        //let articleDetailsView = ArticleListTableViewController
//        let viewController = mainStoryboard.instantiateViewController(withIdentifier: "PostDetailController")
//        if let view = viewController as? PostDetailView {
//            let presenter: PostDetailPresenterProtocol = PostDetailPresenter()
//            let wireFrame: PostDetailWireFrameProtocol = PostDetailWireFrame()
//
//            view.presenter = presenter
//            presenter.view = view
//            presenter.post = post
//            presenter.wireFrame = wireFrame
//
//            return viewController
//        }
//        return UIViewController()
        
        // This can be set using xib too
//        let view = mainstoryboard.instantiateViewController(withIdentifier: "ArticleListTableViewController") as! ArticleListTableViewController

//        let presenter: ArticleListViewToPresenterProtocol & ArticleListInteractorToPresenterProtocol = ArticleListPresenter()
//        let interactor: ArticleListPresenterToInteractorProtocol = ArticleListInteractor()
//        let router:ArticleListPresenterToRouterProtocol = ArticleListRouter()
////        let databaseManager: DatabaseManagerProtocol = DatabaseManager()
//        let fileManager: FileManagerProtocol = ArticleFileManager()
//
//        view.presenter = presenter
//        presenter.view = view
//        presenter.router = router
//        presenter.interactor = interactor
//        interactor.presenter = presenter
//        //interactor.databaseManager = databaseManager
//        interactor.fileManager = fileManager
//
//        return view

    //}
    
//    static var mainstoryboard: UIStoryboard{
//        return UIStoryboard(name:"Main",bundle: Bundle.main)
 }
    
    static var mainStoryboard: UIStoryboard {
        return UIStoryboard(name: "Main", bundle: Bundle.main)
    }
}
