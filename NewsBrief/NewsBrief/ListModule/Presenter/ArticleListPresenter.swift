//
//  ArticleListPresenter.swift
//  NewsBrief
//
//  Created by Amrit Bhardwaj on 20/04/21.
//

import UIKit

/*
 'ArticleListPresenter' class handles data flow to and from Article List View
 */
final class ArticleListPresenter: ArticleListViewToPresenterProtocol {
    
    /// View Instance
    var view: ArticleListPresenterToViewProtocol?
    
    /// Interactor Instance
    var interactor: ArticleListPresenterToInteractorProtocol?
    
    /// Router Instance
    var router: ArticleListPresenterToRouterProtocol?
    
    /// This functions triggers the News Article fetch
    func startFetchingArticleDetails() {
        interactor?.fetchArticleDetails()
    }
}

extension ArticleListPresenter: ArticleListInteractorToPresenterProtocol {
    
    /// This function is used to update the UI after Article List data is fetched successfully
    /// - Parameters:
    ///   - newIndexPathsToReload: The new Index path for which data should be loaded
    func onFetchCompleted(with newIndexPathsToReload: [IndexPath]?) {
        view?.onFetchCompleted(with: newIndexPathsToReload)
    }
    
    /// This function is used to update the UI if Article List Data fetch fails
    func onFetchFailed(withError error: ErrorMessages) {
        view?.showError(withError: error)
    }
    
    /// This function is used to get the total article Count
    /// - Returns: The article Count
    func getTotalArticleCount() -> Int? {
        return interactor?.totalArticleCount()
    }
    
    /// This function is used to get the current Article Count
    /// - Returns: The article Count
    func getCurrentArticleCount() -> Int? {
        return interactor?.getCurrentArticleCount()
    }
    
    /// This function is used to get the article details at a given Index
    ///
    /// - Parameters:
    ///   - index: Index
    /// - Returns: The Article at the given index
    func getArticle(at index: Int) -> Article {
        return interactor?.article(at: index) ?? Article()
    }
    
    /// This function is used to show the Article Details page as the user taps on a Article
    ///
    /// - Parameters:
    ///   - article: Article
    func showArticleDetail(forArticle article: Article) {
        router?.presentArticleDetailScreen(fromView: view!, forArticle: article)
    }
}
