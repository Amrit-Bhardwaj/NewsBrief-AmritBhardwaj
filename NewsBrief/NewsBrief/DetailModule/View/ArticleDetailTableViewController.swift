//
//  ArticleDetailTableViewController.swift
//  NewsBrief
//
//  Created by Amrit Bhardwaj on 21/04/21.
//

import UIKit

/*
 'ArticleDetailTableViewController' implements and configurs the Article Details View
 */
final class ArticleDetailTableViewController: UITableViewController {
    
    /// Presenter Instance
    var presenter: ArticleDetailsViewToPresenterProtocol?
    
    /// Article Data
    private var articleData: Article?
    
    /// Article Meta Data
    private var articleMetaData: ArticleMeta?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        LoadingIndicator.sharedInstance.showOnWindow()
        articleData = presenter?.getArticleDetails()
        
        /// Fetching the Article Meta Data
        presenter?.getArticleMetaDetails(forArticleId: articleData?.articleID)
        setUp()
    }
    
    /// This function is used to do tableView related
    private func setUp() {
        
        // TODO: - Title should be fetched from localized file
        title = "News"
        
        // TODO: - Setup cell theme from ThemingManager
        
        /// Registering tableView cells
        registerCells()
        
        /// Setting tableView height
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = tableView.rowHeight
        tableView.tableFooterView = UIView()
    }
    
    /// This function registers all the tableView cells
    private func registerCells() {
        tableView.register(TitleSubTitleTableViewCell.self, cellIdentifier: String(describing: TitleSubTitleTableViewCell.self))
        tableView.register(ImageTableViewCell.self, cellIdentifier: String(describing: ImageTableViewCell.self))
        tableView.register(DetailsTableViewCell.self, cellIdentifier: String(describing: DetailsTableViewCell.self))
        tableView.register(TextTableViewCell.self, cellIdentifier: String(describing: TextTableViewCell.self))
    }
}

extension ArticleDetailTableViewController {
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return presenter?.numberOfSections() ?? 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return presenter?.numberOfRowsInSection(section: section) ?? 0
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let articleRow = ArticleRows.init(rawValue: indexPath.row)
        
        switch articleRow {
        
        case .titleDescription:
            
            if let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: TitleSubTitleTableViewCell.self), for: indexPath) as? TitleSubTitleTableViewCell {
                
                // TODO: - Strings to be read from localizable file
                cell.configure(title: articleData?.title ?? "Title Not Available", subTitle: articleData?.description ?? "News Description Not Available")
                return cell
            }
            
        case .articleImage:
            
            if let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: ImageTableViewCell.self), for: indexPath) as? ImageTableViewCell {
                
                let articleImage = UIImage(data: (articleData?.image) ?? Data()) ?? Image.placeHolderImage
                cell.configure(image: articleImage)
                return cell
            }
            
        case .articleMeta:
            
            if let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: DetailsTableViewCell.self), for: indexPath) as? DetailsTableViewCell {
                
                cell.configure(author: articleData?.author ?? "Author Not Found", publishedDate: articleData?.publishedDate ?? "Published Date Not found", numberOfLikes: articleMetaData?.likes ?? "0", numberOfComments: articleMetaData?.comments ?? "0")
                return cell
            }
            
        case .articleContent:
            
            if let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: TextTableViewCell.self), for: indexPath) as? TextTableViewCell {
                
                cell.configure(withText: articleData?.content ?? "Article Content Not Found")
                return cell
            }
            
        default:
            return UITableViewCell()
        }
        
        return UITableViewCell()
    }
    
}

extension ArticleDetailTableViewController: ArticleDetailsPresenterToViewProtocol {
    
    /// This function sets the Article Meta Details
    ///
    /// - Parameters:
    ///   - metaData: The Article Meta Data
    func metaDetails(withMetaData metaData: ArticleMeta) {
        self.articleMetaData = metaData
        tableView.reloadData()
        LoadingIndicator.sharedInstance.hide()
    }
    
    /// This function is used to present an alert if failed to fetch Meta
    ///
    /// - Parameters:
    ///   - error: Error message
    func showMetaError(withError error: ErrorMessages) {
        
        switch error {
        case .noInternet:
            showNoInterNetAvailabilityMessage()
        default:
            break
        }
    }
    
    /// This function shows connectivity error Alert
    func showNoInterNetAvailabilityMessage() {
        LoadingIndicator.sharedInstance.hide()
        showAlert(title: "No Internet", message: "Could not fetch Article Meta Data. Please Check you internet connection and try again", style: [UIAlertAction.Style.default], actions: [(title: "Okay", event: nil)])
    }
}
