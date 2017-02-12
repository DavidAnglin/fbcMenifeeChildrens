//
//  DirectoryTableViewController.swift
//  fbcmenifeeChildrens
//
//  Created by David Anglin on 1/4/17.
//  Copyright © 2017 David Anglin. All rights reserved.
//

import UIKit
import Firebase

class DirectoryTableViewController: UITableViewController {
    
    // MARK: - Private Constants -
    // MARK: - Public Constants -
    fileprivate let messageComposer = MessageComposer()
    fileprivate let usersRef = FIRDatabase.database().reference(withPath: Constants.DirectoryConstants.userRef)
    fileprivate let servantRef = FIRDatabase.database().reference(withPath: Constants.DirectoryConstants.servantRef)
    
    // MARK: - Private Variables -
    // MARK: - Public Variables -
    fileprivate var servantList = [Servants]()
    fileprivate weak var loadingIndicatorView: UIActivityIndicatorView!
    
    // MARK: - IBActions -
    @IBAction func logout(_ sender: UIBarButtonItem) {
        do {
            try FIRAuth.auth()!.signOut()
            self.view.window!.rootViewController?.dismiss(animated: false, completion: nil)
        } catch {
            showAlert(error.localizedDescription)
        }
    }
    
    // Unwinds
    @IBAction func unwindFromSchedule(segue: UIStoryboardSegue) {
    }

    // MARK: - View Controller Lifecycle -
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let loadingIndicatorView = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.gray)
        
        tableView.backgroundView = loadingIndicatorView
        tableView.separatorStyle = UITableViewCellSeparatorStyle.none
        
        self.loadingIndicatorView = loadingIndicatorView
        
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 50
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        loadData()
    }
    
    // MARK: - Table view data source -
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return servantList.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: Constants.DirectoryConstants.directoryCellId, for: indexPath) as! DirectoryTableViewCell
        
        let servant = self.servantList[indexPath.row]
        cell.nameLabel.text = "\(servant.firstName!) \(servant.lastName!)"
        
        if let phoneNumber = servant.phone, phoneNumber != "" {
            cell.phoneLabel?.isHidden = false
            cell.phoneLabel?.text = phoneNumber
        } else {
            cell.phoneLabel?.isHidden = true
        }
        
        if let email = servant.email, email != "" {
            cell.emailLabel?.isHidden = false
            cell.emailLabel?.text = email
        } else {
            cell.emailLabel?.isHidden = true
        }
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if (indexPath.row % 2 == 0) {
            cell.backgroundColor = UIColor(red: 230/255, green: 230/255, blue: 230/255, alpha: 1)
        } else {
            cell.backgroundColor = UIColor(red: 220/255, green: 220/255, blue: 220/255, alpha: 1)
        }
    }
    
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    
    override func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        
        let cell = tableView.cellForRow(at: indexPath) as! DirectoryTableViewCell
        let strippedPhoneNumber = cell.phoneLabel?.text?.components(separatedBy: NSCharacterSet.decimalDigits.inverted).joined(separator: "")
        
        let call = UITableViewRowAction(style: .normal, title: Constants.DirectoryConstants.call) { action, index in
            let confirmCall = UIAlertController(title: Constants.DirectoryConstants.calling, message: cell.phoneLabel?.text, preferredStyle: .alert)
            let call = UIAlertAction(title: Constants.DirectoryConstants.call, style: .default) { action in
                if let url = URL(string: "tel://\(strippedPhoneNumber!)"), UIApplication.shared.canOpenURL(url as URL) {
                    UIApplication.shared.open(url)
                }
            }
            
            let cancel = UIAlertAction(title: Constants.AlertConstants.cancel, style: .cancel) { _ in }
            
            confirmCall.addAction(cancel)
            confirmCall.addAction(call)
            self.present(confirmCall, animated: true, completion: nil)
        }
        
        let message = UITableViewRowAction(style: .normal, title: Constants.DirectoryConstants.message) { action, index in
            if (self.messageComposer.canSendText()) {
                let messageComposeVC = self.messageComposer.configureMessageComposeViewController(number: [strippedPhoneNumber!])
                self.present(messageComposeVC, animated: true, completion: nil)
            } else {
                self.showAlert(Constants.AlertConstants.error, message: Constants.DirectoryConstants.messageError)
            }
        }
        
        let email = UITableViewRowAction(style: .normal, title: "Email") { action, index in
            if (self.messageComposer.canSendEmail()) {
                let mailComposerVC = self.messageComposer.configuredMailComposeViewController(email: [(cell.emailLabel?.text!)!])
                self.present(mailComposerVC, animated: true, completion: nil)
            } else {
                self.showAlert(Constants.DirectoryConstants.mailTitle, message: Constants.DirectoryConstants.mailDisabled)
            }
        }
        
        call.backgroundColor = UIColor.lightGray
        message.backgroundColor = UIColor.orange
        email.backgroundColor = UIColor.gray
        
        if (!(cell.phoneLabel?.isHidden)!) {
            return [email, message, call]
        } else if (cell.phoneLabel?.isHidden)! {
            return [email]
        } else if (!(cell.emailLabel?.isHidden)!) {
            return [email, message, call]
        } else if (cell.emailLabel?.isHidden)! {
            return [message, call]
        }
        return []
    }
    
    // MARK: - Load Data -
    fileprivate func loadData() {
        loadingIndicatorView.startAnimating()
        self.servantRef.queryOrdered(byChild:Constants.ServantConstants.lastName).observe(.value, with: { snapshot in
            
            DispatchQueue.main.async {
                var people: [Servants] = []
                for servant in snapshot.children {
                    let servant = Servants(snapshot: servant as! FIRDataSnapshot)
                    people.append(servant)
                }
                
                self.servantList = people
                self.loadingIndicatorView.stopAnimating()
                self.tableView.separatorStyle = UITableViewCellSeparatorStyle.singleLine
                self.tableView.reloadData()
            }
        })
    }

}
