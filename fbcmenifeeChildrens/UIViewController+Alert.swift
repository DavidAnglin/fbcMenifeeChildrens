//
//  UIViewController+Alert.swift
//  fbcmenifeeChildrens
//
//  Created by David Anglin on 1/30/17.
//  Copyright © 2017 David Anglin. All rights reserved.
//

import Foundation
import UIKit

extension UIViewController {
    
    /// shows an UIAlertController alert with error title and message
    public func showAlert(_ title: String, message: String? = nil) {
        if !Thread.current.isMainThread {
            DispatchQueue.main.async { [weak self] in
                self?.showAlert(title, message: message)
            }
            return
        }
        
        let controller = UIAlertController(title: title, message: message, preferredStyle: .alert)
        controller.view.tintColor = UIWindow.appearance().tintColor
        controller.addAction(UIAlertAction(title: NSLocalizedString("OK", comment: ""), style: .cancel, handler: nil))
        present(controller, animated: true, completion: nil)
    }
    
}
