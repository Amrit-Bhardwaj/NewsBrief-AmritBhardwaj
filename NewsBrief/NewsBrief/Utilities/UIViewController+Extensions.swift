//
//  UIViewController+Extensions.swift
//  NewsBrief
//
//  Created by Amrit Bhardwaj on 20/04/21.
//

import UIKit

extension UIViewController {
    
    /**
     Example usage:
     Just make sure actionTitles and actions array the same count.
     1. Pass nil if you don't need any action handler closure.
     showAlert(title: "Title", message: "message", style: [.deafult], actions: [])
     2. Alert view with one action
     showAlert(title: "Title", message: "message", style: [.cancel, .deafult], actions: [(title: "OK", event: {action1 in}])
     */
    func showAlert(title: String?,
                   message: String?,
                   style: [UIAlertAction.Style],
                   actions: [(title: String, event: ((UIAlertAction) -> Void)?)],
                   preferredActionIndex: Int? = nil,
                   titleColor: UIColor? = nil) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        for (index, action) in actions.enumerated() {
            let action = UIAlertAction(title: action.title, style: style[index], handler: action.event)
            if let titleColor = titleColor,
                index == preferredActionIndex {
                action.setValue(titleColor, forKey: "titleTextColor")
            }
            alert.addAction(action)
        }
        if let preferredActionIndex = preferredActionIndex { alert.preferredAction = alert.actions[preferredActionIndex] }
        present(alert, animated: true, completion: nil)
    }
}

