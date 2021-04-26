//
//  ArticleDetailInteractorTests.swift
//  NewsBriefTests
//
//  Created by Amrit Bhardwaj on 26/04/21.
//

import XCTest
@testable import NewsBrief

class ArticleDetailInteractorTests: XCTestCase {
    var presenter = ArticleDetailsPresenterMock()
    var interactor: ArticleDetailsIntereactor!
    
    override func setUpWithError() throws {
        interactor = ArticleDetailsIntereactor()
        interactor.presenter = self.presenter
    }
    
    func testFetchArticleListData() throws {
        interactor.fetchArticleMetaDetails(forArticleID: "ArticleID")
    }
    
    override func tearDownWithError() throws {
        interactor = nil
    }
}

class ArticleDetailsPresenterMock: ArticleDetailsInteractorToPresenterProtocol {
    
    func metaFetchSuccess(withMetaData metaData: ArticleMeta) {
    }
    
    func metaFetchFailed(withError error: ErrorMessages) {
    }
    
}
