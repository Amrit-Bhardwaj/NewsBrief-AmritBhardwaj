//
//  ArticleListTableViewController.swift
//  NewsBrief
//
//  Created by Amrit Bhardwaj on 20/04/21.
//

import UIKit

/*
 'ArticleListTableViewController' represents the News List View
 */
final class ArticleListTableViewController: UITableViewController {
    
    /// Presenter
    var presenter: ArticleListViewToPresenterProtocol?
    
    // MARK: - ViewController life cycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        LoadingIndicator.sharedInstance.showOnWindow()
        presenter?.startFetchingArticleDetails()
        setUp()
    }
    
    /// This function sets up the tableview
    private func setUp() {
        // TODO: - title should be fetched from localized file
        title = "News Briefing"
        
        // TODO: - Setup cell theme from ThemingManager
        
        /// Setting the Prefetching delegate
        tableView.prefetchDataSource = self
        
        /// Registering tableView cells
        tableView.register(ArticleListTableViewCell.self, cellIdentifier: String(describing: ArticleListTableViewCell.self))
        
        /// Setting the table cell heigt to automatic dimension
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = tableView.rowHeight
        tableView.separatorStyle = .none
    }
}

extension ArticleListTableViewController {
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
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
            
            if isLoadingCell(for: indexPath) {
                cell.configure(image: .none, description: .none, author: .none)
            } else {
                
                let article = presenter?.getArticle(at: indexPath.row)
                let articleImage = UIImage(data: (article?.image) ?? Data()) ?? Image.placeHolderImage
                
                /// Configuring the cell
                cell.configure(image: articleImage, description: article?.description ?? "Description not available", author: article?.author ?? "Author Details not Available")
            }
            
            return cell
        }
        
        return UITableViewCell()
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        /// Open the article Detail Page on cell tap
        if let articleDetails = presenter?.getArticle(at: indexPath.row) {
            presenter?.showArticleDetail(forArticle: articleDetails)
        }
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
    
    /// Reloading the table view after fetch is completed
    func onFetchCompleted(with newIndexPathsToReload: [IndexPath]?) {
        guard let newIndexPathsToReload = newIndexPathsToReload else {
            LoadingIndicator.sharedInstance.hide()
            tableView.isHidden = false
            tableView.separatorStyle = .singleLine
            tableView.reloadData()
            return
        }
        
        let indexPathsToReload = visibleIndexPathsToReload(intersecting: newIndexPathsToReload)
        tableView.reloadRows(at: indexPathsToReload, with: .automatic)
        tableView.separatorStyle = .singleLine
        LoadingIndicator.sharedInstance.hide()
    }
    
    func showError() {
        tableView.separatorStyle = .singleLine
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
    
    /// This function is used to check if the cell at current Index is loading
    ///
    /// - Parameters:
    ///   - indexPath: indexPath
    /// - Returns: Boolean value with the loading status
    func isLoadingCell(for indexPath: IndexPath) -> Bool {
        
        if let currentArticleCount = presenter?.getCurrentArticleCount() {
            return indexPath.row >= currentArticleCount
        } else {
            return false
        }
    }
    
    /// This function is used to get the list of visible index paths that should be reloaded
    ///
    /// - Parameters:
    ///   - indexPaths: Index path
    /// - Returns: Visible Index Paths to load
    func visibleIndexPathsToReload(intersecting indexPaths: [IndexPath]) -> [IndexPath] {
        
        let indexPathsForVisibleRows = tableView.indexPathsForVisibleRows ?? []
        let indexPathsIntersection = Set(indexPathsForVisibleRows).intersection(indexPaths)
        
        return Array(indexPathsIntersection)
    }
}
