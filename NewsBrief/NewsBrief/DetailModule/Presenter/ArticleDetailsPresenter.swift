//
//  ArticleDetailsPresenter.swift
//  NewsBrief
//
//  Created by Amrit Bhardwaj on 21/04/21.
//

import UIKit

final class ArticleDetailsPresenter: ArticleDetailsViewToPresenterProtocol {
    
    var view: ArticleDetailsPresenterToViewProtocol?
    
    var interactor: ArticleDetailsPresenterToInteractorProtocol?
    
    var router: ArticleDetailsPresenterToRouterProtocol?
    
    var article: Article?
    
    func getArticleDetails() -> Article? {
        return article
    }
    
    func showArticleDetailController(navigationController: UINavigationController) {
        
    }
}

extension ArticleDetailsPresenter: ArticleDetailsInteractorToPresenterProtocol {
    func onFetchCompleted(with newIndexPathsToReload: [IndexPath]?) {
       // view?.onFetchCompleted(with: newIndexPathsToReload)
    }
    
    
    func imageFetchedSuccess(imageData: Data, title: String, explanation: String) {
        //view?.showArticleList(imageData: imageData, title: title, explanation: explanation)
    }
    
    func imageFetchFailed() {
        //view?.showError()
    }
    
//    func getTotalArticleCount() -> Int? {
//        //return interactor?.totalArticleCount()
//    }
//
//    func getCurrentArticleCount() -> Int? {
//        //return interactor?.getCurrentArticleCount()
//    }
//
//    func getArticle(at index: Int) -> Article {
//        //return interactor?.article(at: index) ?? Article()
//    }
}

