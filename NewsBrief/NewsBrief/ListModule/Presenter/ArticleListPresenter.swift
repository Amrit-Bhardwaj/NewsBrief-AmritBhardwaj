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
    
    func imageFetchedSuccess(imageData: Data, title: String, explanation: String) {
        view?.showArticleList(imageData: imageData, title: title, explanation: explanation)
    }
    
    func imageFetchFailed() {
        view?.showError()
    }
    
}
