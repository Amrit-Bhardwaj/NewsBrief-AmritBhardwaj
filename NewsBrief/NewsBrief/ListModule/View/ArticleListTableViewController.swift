//
//  ArticleListTableViewController.swift
//  NewsBrief
//
//  Created by Amrit Bhardwaj on 20/04/21.
//

import UIKit

final class ArticleListTableViewController: UITableViewController {
    
    var presenter: ViewToPresenterProtocol?
    
    // private Model

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
        // #warning Incomplete implementation, return the number of rows
        return 2
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: ArticleListTableViewCell.self), for: indexPath) as? ArticleListTableViewCell {
            cell.configure(image: UIImage(named: "dummy"), description: "This is description dummy Text ", author: "Mark Twain")
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
        //
    }
}

extension ArticleListTableViewController: PresenterToViewProtocol {
    
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
