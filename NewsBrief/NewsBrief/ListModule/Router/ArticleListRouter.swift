//
//  ArticleListRouter.swift
//  NewsBrief
//
//  Created by Amrit Bhardwaj on 20/04/21.
//

import UIKit

final class ArticleListRouter: ArticleListPresenterToRouterProtocol {
    
    static func createModule() -> ArticleListTableViewController {
        
        // This can be set using xib too
        let view = mainstoryboard.instantiateViewController(withIdentifier: "ArticleListTableViewController") as! ArticleListTableViewController

        let presenter: ArticleListViewToPresenterProtocol & ArticleListInteractorToPresenterProtocol = ArticleListPresenter()
        let interactor: ArticleListPresenterToInteractorProtocol = ArticleListInteractor()
        let router:ArticleListPresenterToRouterProtocol = ArticleListRouter()
//        let databaseManager: DatabaseManagerProtocol = DatabaseManager()
        let fileManager: FileManagerProtocol = ArticleFileManager()
        
        view.presenter = presenter
        presenter.view = view
        presenter.router = router
        presenter.interactor = interactor
        interactor.presenter = presenter
        //interactor.databaseManager = databaseManager
        interactor.fileManager = fileManager
        
        return view

    }
    
    static var mainstoryboard: UIStoryboard{
        return UIStoryboard(name:"Main",bundle: Bundle.main)
    }
}


