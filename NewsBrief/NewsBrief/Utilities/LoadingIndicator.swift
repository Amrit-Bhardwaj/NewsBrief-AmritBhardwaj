//
//  LoadingIndicator.swift
//  NewsBrief
//
//  Created by Amrit Bhardwaj on 20/04/21.
//

import UIKit

/*
 Present loading indicator across the application
 
 - Example usage:
 LoadingIndicator.sharedInstance.showOnWindow() - Will present loading indicator on Window
 LoadingIndicator.sharedInstance.showOnController(presenter: UIViewController) - Will present loading indicator on viewController passed as presenter
 LoadingIndicator.sharedInstance.showOnView(presenter: UIView) = Will present loading indicator on passed view
 
 */
final class LoadingIndicator: UIView {
    
    /// Singleton Instance
    static let sharedInstance = LoadingIndicator()
    
    /// Activity Indicator Instance
    var activityIndicator = UIActivityIndicatorView()
    
    /// Animation duration
    private let animationDuration = 0.3
    
    private override init(frame: CGRect) {
        super.init(frame: frame)
        activityIndicator.frame = CGRect(x: 0, y: 0, width: 110, height: 110)
        if #available(iOS 13.0, *) {
            activityIndicator.style = .large
        } else {
            activityIndicator.style = .medium
        }
        activityIndicator.color = .brown
        activityIndicator.backgroundColor = .white
        activityIndicator.isOpaque = false
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    /**
     Method to show loading indicator on provided view controller
     */
    func showOnController(presenter: UIViewController) {
        
        DispatchQueue.main.async { [weak self] in
            guard let strongSelf = self else { return }
            presenter.view.addSubview(strongSelf)
            let presenterBounds = presenter.view.bounds
            let frame = CGRect(x: presenterBounds.origin.x,
                               y: presenterBounds.origin.y,
                               width: presenterBounds.width,
                               height: presenterBounds.height )
            strongSelf.frame = frame
            strongSelf.activityIndicator.frame = frame
            let center = CGFloat(presenter.view.bounds.maxY / 2)
            strongSelf.activityIndicator.center = CGPoint(x: presenter.view.bounds.maxX / 2 ,
                                                          y: center)
            strongSelf.addSubview(strongSelf.activityIndicator)
            strongSelf.activityIndicator.startAnimating()
            // Fade in the view
            UIView.animate(withDuration: TimeInterval(strongSelf.animationDuration),
                           delay: 0.5,
                           options: [.curveEaseIn],
                           animations: { () -> Void in
                            strongSelf.alpha = 1.0
            })
        }
    }
    
    /**
     Method to show loading indicator on full application window
     */
    func showOnWindow() {
        DispatchQueue.main.async { [weak self] in
            guard let strongSelf = self else { return }
            guard let currentMainWindow = UIApplication.shared.windows.filter({$0.isKeyWindow}).first else {
                return
            }
            currentMainWindow.addSubview(strongSelf)
            strongSelf.frame = currentMainWindow.frame
            strongSelf.activityIndicator.frame = currentMainWindow.frame
            strongSelf.activityIndicator.center = CGPoint(x: UIScreen.main.bounds.width / 2,
                                                          y: UIScreen.main.bounds.height / 2)
            strongSelf.addSubview(strongSelf.activityIndicator)
            strongSelf.activityIndicator.startAnimating()
            // Fade in the view
            UIView.animate(withDuration: TimeInterval(strongSelf.animationDuration),
                           delay: 0.2,
                           options: [.curveEaseIn],
                           animations: { () -> Void in
                            strongSelf.alpha = 0.5
            })
        }
    }
    
    /**
     Method to show loading indicator on provided view
     */
    func showOnView(presenter: UIView) {
        DispatchQueue.main.async { [weak self] in
            guard let strongSelf = self else { return }
            strongSelf.activityIndicator.frame = presenter.frame
            strongSelf.activityIndicator.center = CGPoint(x: presenter.bounds.width / 2,
                                                          y: presenter.bounds.height / 2)
            presenter.addSubview(strongSelf)
            strongSelf.addSubview(strongSelf.activityIndicator)
            strongSelf.activityIndicator.startAnimating()
            // Fade in the view
            UIView.animate(withDuration: TimeInterval(strongSelf.animationDuration),
                           delay: 0.5,
                           options: [.curveEaseIn],
                           animations: { () -> Void in
                            strongSelf.alpha = 1.0
            })
        }
    }
    
    /**
     Method to hide loading indicator
     */
    func hide() {
        DispatchQueue.main.async { [weak self] in
            guard let strongSelf = self else { return }
            strongSelf.activityIndicator.stopAnimating()
            // Fade out the view
            UIView.animate(withDuration: TimeInterval(strongSelf.animationDuration),
                           delay: 0.5,
                           options: [.curveEaseOut],
                           animations: { () -> Void in
                            strongSelf.alpha = 0.0
                            strongSelf.removeFromSuperview()
            })
        }
    }
}
