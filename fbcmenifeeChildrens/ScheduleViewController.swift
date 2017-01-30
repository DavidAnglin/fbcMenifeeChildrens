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
    
    var scheduleView: WKWebView!
    
    override func loadView() {
        let preferences = WKPreferences()
        preferences.javaScriptEnabled = false
        let configuration = WKWebViewConfiguration()
        configuration.preferences = preferences
        
        scheduleView = WKWebView(frame: .zero, configuration: configuration)
        view = scheduleView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
            
        let schedule = "schedule.pdf"
        let scheduleURL = FIRStorage.storage().reference(forURL: "gs://fbcmenifee-kids.appspot.com").child(schedule)
        
        scheduleURL.downloadURL { url, error in
            if let error = error {
                print(error.localizedDescription)
            } else {
                let request = NSURLRequest(url: url!)
                self.scheduleView.load(request as URLRequest)
            }
        }
    }
}
