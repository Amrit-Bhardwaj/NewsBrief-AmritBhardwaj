//
//  NewsBriefArticleListPresenterTests.swift
//  NewsBriefTests
//
//  Created by Amrit Bhardwaj on 25/04/21.
//

import XCTest
@testable import NewsBrief

class ArticleListPresenterTests: XCTestCase {
    
    var presenter: ArticleListPresenter!
    var view = ArticleListMockView()
    var interactor = ArticleListIntereactorMock()
    
    override func setUpWithError() throws {
        presenter = ArticleListPresenter()
        presenter.view = view
        presenter.interactor = interactor
        interactor.presenter = presenter
        presenter.startFetchingArticleDetails()
    }
    
    override func tearDownWithError() throws {
        presenter = nil
    }
    
    func testFetchArticleListData() throws {
        if !view.didArticleFetchComplete {
            XCTFail("Article fetch complete not called")
        }
    }
    
    func testTotalArticleCount() throws {
        XCTAssertTrue(presenter.getTotalArticleCount() != 0)
    }
    
    func testErrorMessage() {
        let error: ErrorMessages = .noInternet
        presenter.onFetchFailed(withError: error)
        XCTAssertEqual(view.error, error)
    }
    
    func testArticleAtIndex() {
        let index = 0
        let article = presenter.getArticle(at: index)
        XCTAssertNotNil(article)
        
    }
}

class ArticleListMockView: ArticleListPresenterToViewProtocol {
    
    var didArticleFetchComplete = false
    func onFetchCompleted(with newIndexPathsToReload: [IndexPath]?) {
        didArticleFetchComplete = true
    }
    
    var error: ErrorMessages?
    func showError(withError error: ErrorMessages) {
        self.error = error
    }
}

class ArticleListIntereactorMock: ArticleListPresenterToInteractorProtocol {
    
    var remoteDataManager: ArticleListRemoteInputProtocol?
    
    var presenter: ArticleListInteractorToPresenterProtocol?
    
    var databaseManager: DatabaseManagerProtocol?
    
    var fileManager: FileManagerProtocol?
    
    private var articles: [Article] = []
    private var total = 10
    
    func fetchArticleDetails() {
        let article1 = Article(author: "Author Name1", description: "Article Description1", image: nil, title: "Title1", publishedDate: "Date1", content: "Article Content1", articleID: "ArticleID1")
        let article2 = Article(author: "Author Name2", description: "Article Description2", image: nil, title: "Title2", publishedDate: "Date2", content: "Article Content2", articleID: "ArticleID2")
        articles.append(article1)
        articles.append(article2)
        presenter?.onFetchCompleted(with: [IndexPath(indexes: 0...1)])
    }
    
    func totalArticleCount() -> Int? {
        return articles.count
    }
    
    func getCurrentArticleCount() -> Int? {
        return total
    }
    
    func article(at index: Int) -> Article {
        return articles[index]
    }
}
