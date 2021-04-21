//
//  ArticleDetailTableViewController.swift
//  NewsBrief
//
//  Created by Amrit Bhardwaj on 21/04/21.
//

import UIKit

final class ArticleDetailTableViewController: UITableViewController {
        
    var presenter: ArticleDetailsViewToPresenterProtocol?
    private var articleData: Article?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        articleData = presenter?.getArticleDetails()
        //LoadingIndicator.sharedInstance.showOnWindow()
        //presenter?.startFetchingArticleDetails()
        setUp()
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }
    
    private func setUp() {
        
        // TODO: - title should be fetched from localized file
        title = "News"
        
        // TODO: - Setup cell theme from ThemingManager
        tableView.register(TitleSubTitleTableViewCell.self, cellIdentifier: String(describing: TitleSubTitleTableViewCell.self))
        tableView.register(ImageTableViewCell.self, cellIdentifier: String(describing: ImageTableViewCell.self))
        tableView.register(DetailsTableViewCell.self, cellIdentifier: String(describing: DetailsTableViewCell.self))
        tableView.register(TextTableViewCell.self, cellIdentifier: String(describing: TextTableViewCell.self))
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = tableView.rowHeight
        tableView.tableFooterView = UIView()
    }
}

extension ArticleDetailTableViewController {
    
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 4
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        switch indexPath.row {
        
        case 0:
            if let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: TitleSubTitleTableViewCell.self), for: indexPath) as? TitleSubTitleTableViewCell {
                cell.configure(title: articleData?.title ?? "Title Not available", subTitle: articleData?.description ?? "News Description")
                return cell
            }
        case 1:
            if let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: ImageTableViewCell.self), for: indexPath) as? ImageTableViewCell {
                let articleImage = UIImage(data: (articleData?.image) ?? Data()) ?? UIImage(named: "dummy")
                cell.configure(image: articleImage)
                return cell
            }
        case 2:
            if let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: DetailsTableViewCell.self), for: indexPath) as? DetailsTableViewCell {
                cell.configure(author: articleData?.author ?? "Author not found", publishedDate: articleData?.publishedDate ?? "Today's Date", numberOfLikes: "32", numberOfComments: "45")
                return cell
            }
        case 3:
            if let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: TextTableViewCell.self), for: indexPath) as? TextTableViewCell {
                cell.configure(withText: articleData?.content ?? "Article Content Not found")
                return cell
            }
        default:
            return UITableViewCell()
        }
        
        return UITableViewCell()
    }
    
}

extension ArticleDetailTableViewController: ArticleDetailsPresenterToViewProtocol {
    
}
