//
//  NewsBriefTests.swift
//  NewsBriefTests
//
//  Created by Amrit Bhardwaj on 19/04/21.
//

import XCTest
@testable import NewsBrief

class NewsBriefArticleDetailPresenterTests: XCTestCase {
    
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
        
        if let likes = view.articleMeta?.likes {
            XCTAssert(likes != "-1")
        } else {
            XCTFail("Could not fetch Article Likes count")
        }
        
        if let comments = view.articleMeta?.comments {
            XCTAssert(comments != "-1")
        } else {
            XCTFail("Could not fetch Article Comments count")
        }
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
    
    func metaDetails(withMetaData metaData: ArticleMeta) {
        self.articleMeta = metaData
    }
}

class ArticleDetailsIntereactorMock: ArticleDetailsPresenterToInteractorProtocol {
    
    // TDOD: - Create a Network Dispatcher Mock Object to fetch the Article meta Data
    
    var presenter: ArticleDetailsInteractorToPresenterProtocol?
    
    func fetchArticleMetaDetails(forArticleID id: String?) {
        let articleMeta = ArticleMeta(likes: "10", comments: "10")
        presenter?.metaFetchSuccess(withMetaData: articleMeta)
    }
}
