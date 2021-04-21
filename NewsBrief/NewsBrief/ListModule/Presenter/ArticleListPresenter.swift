//
//  ArticleListPresenter.swift
//  NewsBrief
//
//  Created by Amrit Bhardwaj on 20/04/21.
//

import UIKit

final class ArticleListPresenter: ViewToPresenterProtocol {
    
    var view: PresenterToViewProtocol?
    
    var interactor: PresenterToInteractorProtocol?
    
    var router: PresenterToRouterProtocol?
    
    func startFetchingArticleDetails() {
        interactor?.fetchArticleDetails()
    }
    
    func showArticleListController(navigationController: UINavigationController) {
        
    }
}

extension ArticleListPresenter: InteractorToPresenterProtocol {
    func onFetchCompleted(with newIndexPathsToReload: [IndexPath]?) {
        view?.onFetchCompleted(with: newIndexPathsToReload)
    }
    
    
    func imageFetchedSuccess(imageData: Data, title: String, explanation: String) {
        view?.showArticleList(imageData: imageData, title: title, explanation: explanation)
    }
    
    func imageFetchFailed() {
        view?.showError()
    }
    
    func getTotalArticleCount() -> Int? {
        return interactor?.totalArticleCount()
    }
    
    func getCurrentArticleCount() -> Int? {
        return interactor?.getCurrentArticleCount()
    }
    
    func getArticle(at index: Int) -> Article {
        return interactor?.article(at: index) ?? Article()
    }
}
