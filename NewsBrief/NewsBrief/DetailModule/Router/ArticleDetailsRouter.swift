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
        view.presenter = presenter
        presenter.view = view
        presenter.article = article
        presenter.router = router
        presenter.interactor = interactor
        interactor.presenter = presenter
        
        return view
 }
    
    static var mainStoryboard: UIStoryboard {
        return UIStoryboard(name: "Main", bundle: Bundle.main)
    }
}
