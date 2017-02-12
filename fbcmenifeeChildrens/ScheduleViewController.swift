//
//  ScheduleViewController.swift
//  fbcmenifeeChildrens
//
//  Created by David Anglin on 1/24/17.
//  Copyright © 2017 David Anglin. All rights reserved.
//

import UIKit
import WebKit
import Firebase

class ScheduleViewController: UIViewController {
    
    fileprivate var scheduleView: WKWebView!
    
    override func loadView() {
        let preferences = WKPreferences()
        preferences.javaScriptEnabled = false
        let configuration = WKWebViewConfiguration()
        configuration.preferences = preferences
        
        scheduleView = WKWebView(frame: .zero, configuration: configuration)
        self.scheduleView.navigationDelegate = self
        view = scheduleView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let schedule = Constants.ScheduleConstants.schedulePDF
        let scheduleURL = FIRStorage.storage().reference(forURL: Constants.ScheduleConstants.storageURL).child(schedule)
        
        DispatchQueue.main.async {
            scheduleURL.downloadURL { url, error in
                if let error = error {
                    self.showAlert(error.localizedDescription)
                } else {
                    let request = NSURLRequest(url: url!)
                    self.scheduleView.load(request as URLRequest)
                }
            }
        }
    }
}

extension ScheduleViewController: WKNavigationDelegate {
    
    func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
    }
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        UIApplication.shared.isNetworkActivityIndicatorVisible = false
    }
}
