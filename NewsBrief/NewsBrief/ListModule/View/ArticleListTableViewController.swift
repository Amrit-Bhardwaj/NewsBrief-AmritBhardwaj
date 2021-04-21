//
//  ArticleListTableViewController.swift
//  NewsBrief
//
//  Created by Amrit Bhardwaj on 20/04/21.
//

import UIKit

final class ArticleListTableViewController: UITableViewController {
    
    var presenter: ArticleListViewToPresenterProtocol?

    // MARK: - ViewController life cycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        //LoadingIndicator.sharedInstance.showOnWindow()
        presenter?.startFetchingArticleDetails()
        setUp()
    }
    
    private func setUp() {
        // TODO: - title should be fetched from localized file
        title = "News Briefing"
        
        // TODO: - Setup cell theme from ThemingManager
        tableView.prefetchDataSource = self
        tableView.register(ArticleListTableViewCell.self, cellIdentifier: String(describing: ArticleListTableViewCell.self))
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = tableView.rowHeight
    }
}

extension ArticleListTableViewController {
    
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if let totalCount = presenter?.getTotalArticleCount() {
            return totalCount
        } else {
            return 0
        }
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: ArticleListTableViewCell.self), for: indexPath) as? ArticleListTableViewCell {
            let article = presenter?.getArticle(at: indexPath.row)
            let articleImage = UIImage(data: (article?.image) ?? Data()) ?? UIImage(named: "dummy")
            cell.configure(image: articleImage, description: article?.description ?? "", author: article?.author ?? "")
            return cell
        }
        
        return UITableViewCell()
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // TODO: - Open the article Detail Page on cell tap
        
    }
}

extension ArticleListTableViewController: UITableViewDataSourcePrefetching {
    
    func tableView(_ tableView: UITableView, prefetchRowsAt indexPaths: [IndexPath]) {
        if indexPaths.contains(where: isLoadingCell) {
            presenter?.startFetchingArticleDetails()
        }
    }
}

extension ArticleListTableViewController: ArticleListPresenterToViewProtocol {
    func onFetchCompleted(with newIndexPathsToReload: [IndexPath]?) {
        guard let newIndexPathsToReload = newIndexPathsToReload else {
          //indicatorView.stopAnimating()
          tableView.isHidden = false
          tableView.reloadData()
          return
        }
        
        let indexPathsToReload = visibleIndexPathsToReload(intersecting: newIndexPathsToReload)
        tableView.reloadRows(at: indexPathsToReload, with: .automatic)
    }
    
    
    func showArticleList(imageData: Data, title: String, explanation: String) {
        //self.astroDetails = (imageData, title, explanation)
        self.tableView.reloadData()
        LoadingIndicator.sharedInstance.hide()
    }
    
    func showError() {
        LoadingIndicator.sharedInstance.hide()
        let errorActionHandler: ((UIAlertAction) -> Void) = {[weak self] (action) in
            self?.tableView.reloadData()
        }
        
        //TODO: - The strings should be added to localizable string file
        showAlert(title: "Alert",
                  message: "We are not connected to the internet, showing you the last news Articles we have.",
                  style: [.default],
                  actions: [(title: "Ok",
                             event: errorActionHandler)])
    }
}

private extension ArticleListTableViewController {
  func isLoadingCell(for indexPath: IndexPath) -> Bool {
    if let currentArticleCount = presenter?.getCurrentArticleCount() {
        return indexPath.row >= currentArticleCount
    } else {
        return false
    }
  }
  
  func visibleIndexPathsToReload(intersecting indexPaths: [IndexPath]) -> [IndexPath] {
    let indexPathsForVisibleRows = tableView.indexPathsForVisibleRows ?? []
    let indexPathsIntersection = Set(indexPathsForVisibleRows).intersection(indexPaths)
    return Array(indexPathsIntersection)
  }
}
