//
//  NewsBriefTests.swift
//  NewsBriefTests
//
//  Created by Amrit Bhardwaj on 19/04/21.
//

import XCTest
@testable import NewsBrief

class ArticleDetailPresenterTests: XCTestCase {
    
    var presenter: ArticleDetailsPresenter!
    var view = ArticleDetailsMockView()
    var interactor = ArticleDetailsIntereactorMock()
    
    override func setUpWithError() throws {
        presenter = ArticleDetailsPresenter()
        presenter.view = view
        presenter.interactor = interactor
        interactor.presenter = presenter
    }
    
    override func tearDownWithError() throws {
        presenter = nil
    }
    
    func testFetchArticleMetaData() throws {
        presenter.getArticleMetaDetails(forArticleId: "ArticleID")
        if !view.isViewMetaDetailsCalled {
            XCTFail("view Meta Details Not called")
        }
    }
    
    func testErrorMessages() {
        let error: ErrorMessages = .noInternet
        presenter.metaFetchFailed(withError: error)
        XCTAssertEqual(view.error, error)
    }
    
    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
}

class ArticleDetailsMockView: ArticleDetailsPresenterToViewProtocol {
    
    var articleMeta: ArticleMeta?
    var isViewMetaDetailsCalled = false
    func metaDetails(withMetaData metaData: ArticleMeta) {
        isViewMetaDetailsCalled = true
    }
    
    var error: ErrorMessages?
    func showMetaError(withError error: ErrorMessages) {
        self.error = error
    }
}

class ArticleDetailsIntereactorMock: ArticleDetailsPresenterToInteractorProtocol {
    
    var remoteDataManager: ArticleDetailsRemoteInputProtocol?
    
    var presenter: ArticleDetailsInteractorToPresenterProtocol?
    func fetchArticleMetaDetails(forArticleID id: String?) {
        let articleMeta = ArticleMeta(likes: "10", comments: "10")
        presenter?.metaFetchSuccess(withMetaData: articleMeta)
    }
}
