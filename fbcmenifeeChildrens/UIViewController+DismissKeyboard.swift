//
//  UIViewController+DismissKeyboard.swift
//  fbcmenifeeChildrens
//
//  Created by David Anglin on 12/18/16.
//  Copyright © 2016 David Anglin. All rights reserved.
//

import UIKit

extension UIViewController {
    
    func hideKeyboardWhenTappedAround() {
        
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
        view.addGestureRecognizer(tap)
    }
    
    func dismissKeyboard() {
        view.endEditing(true)
    }
    
}
