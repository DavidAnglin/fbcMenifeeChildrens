//
//  DirectoryTableViewController.swift
//  fbcmenifeeChildrens
//
//  Created by David Anglin on 1/4/17.
//  Copyright © 2017 David Anglin. All rights reserved.
//

import UIKit

class DirectoryTableViewController: UITableViewController {
    
    // MARK: - Private Structs -
    fileprivate struct DirectoryConstants {
    }
    
    // MARK: - Private Constants -
    
    // MARK: - Public Constants -
    let messageComposer = MessageComposer()
    
    // MARK: - Private Variables -
    
    // MARK: - Public Variables -
    
    // MARK: - IBOutlets -
    
    
    // MARK: - IBActions -
    
    // MARK: - View Controller Lifecycle -
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
        
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 50
        
        
    
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 1
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)


        return cell
    }
    
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    
    override func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        
        let cell = tableView.cellForRow(at: indexPath) as! DirectoryTableViewCell
        let strippedPhoneNumber = cell.phoneLabel.text?.components(separatedBy: NSCharacterSet.decimalDigits.inverted).joined(separator: "")
        
        let call = UITableViewRowAction(style: .normal, title: "Call") { action, index in
            let confirmCall = UIAlertController(title: "Calling:", message: cell.phoneLabel.text, preferredStyle: .alert)
            let call = UIAlertAction(title: "Call", style: .default) { action in
                if let url = URL(string: "tel://\(strippedPhoneNumber!)"), UIApplication.shared.canOpenURL(url as URL) {
                    UIApplication.shared.open(url)
                }
            }
            
            let cancel = UIAlertAction(title: "Cancel", style: .cancel) { _ in }
            
            confirmCall.addAction(cancel)
            confirmCall.addAction(call)
            self.present(confirmCall, animated: true, completion: nil)
        }
        
        let message = UITableViewRowAction(style: .normal, title: "Mesage") { action, index in
            if (self.messageComposer.canSendText()) {
                let messageComposeVC = self.messageComposer.configureMessageComposeViewController(number: [strippedPhoneNumber!])
                self.present(messageComposeVC, animated: true, completion: nil)
            } else {
                let errorAlert = UIAlertController(title: "Error", message: "Unable to send text message!", preferredStyle: .alert)
                let okAction = UIAlertAction(title: "Ok", style: .default) { _ in }
                
                errorAlert.addAction(okAction)
                self.present(errorAlert, animated: true, completion: nil)
            }
        }
        
        let email = UITableViewRowAction(style: .normal, title: "Email") { action, index in
            if (self.messageComposer.canSendEmail()) {
                let mailComposerVC = self.messageComposer.configuredMailComposeViewController(email: [cell.emailLabel.text!])
                self.present(mailComposerVC, animated: true, completion: nil)
            } else {
                let errorAlert = UIAlertController(title: "iOS Mail Disabled", message: "Please enable iOS Mail to use this feature.", preferredStyle: .alert)
                let okAction = UIAlertAction(title: "Ok", style: .default) { _ in }
                
                errorAlert.addAction(okAction)
                self.present(errorAlert, animated: true, completion: nil)
            }
        }
        
        call.backgroundColor = UIColor.lightGray
        message.backgroundColor = UIColor.orange
        email.backgroundColor = UIColor.gray
        
        return [email, message, call]
        
    }
    

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
