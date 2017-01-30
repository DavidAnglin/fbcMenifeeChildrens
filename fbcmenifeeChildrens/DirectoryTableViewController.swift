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
    
    var servantList = [Servants]()
    
    // MARK: - Private Structs -
    fileprivate struct DirectoryConstants {
    }
    
    // MARK: - Private Constants -
    
    // MARK: - Public Constants -
    let messageComposer = MessageComposer()
    let usersRef = FIRDatabase.database().reference(withPath: "users")
    let servantRef = FIRDatabase.database().reference(withPath: "servants")
    
    // MARK: - Private Variables -
    
    // MARK: - Public Variables -
    
    // MARK: - IBOutlets -
    
    
    // MARK: - IBActions -
    
    
    @IBAction func logout(_ sender: UIBarButtonItem) {
        do {
            try FIRAuth.auth()!.signOut()
            dismiss(animated: true, completion: nil)
        } catch {
          print(error.localizedDescription)
        }
    }
    
    @IBAction func unwindFromSchedule(segue: UIStoryboardSegue) {
        
    }

    // MARK: - View Controller Lifecycle -
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 50
        
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "directoryCell")

        
        
//        FIRAuth.auth()!.addStateDidChangeListener { auth, user in
//            guard let user = user else { return }
//            self.user = User(authData: user)
//            let currentUserRef = self.usersRef.child(self.user.uid)
//            currentUserRef.setValue(self.user.email)
//            currentUserRef.onDisconnectRemoveValue()
//        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        loadData()

    }
    
    func loadData() {
//        self.servantList.removeAll()
//        self.servantRef.observeSingleEvent(of: .value, with: { (snapshot) in
//            if let servantDict = snapshot.value as? [String:AnyObject] {
//                for (_,servantElement) in servantDict {
//                    print(servantElement)
//                    let servant = Servants()
//                    servant.firstName = servantElement[Constants.ServantConstants.firstName] as? String
//                    servant.lastName = servantElement[Constants.ServantConstants.lastName] as? String
//                    servant.phone = servantElement[Constants.ServantConstants.phone] as? String
//                    servant.email = servantElement[Constants.ServantConstants.email] as? String
//                    self.servantList.append(servant)
//                }
//            }
//            self.tableView.reloadData()
//        }) { (error) in
//            print(error.localizedDescription)
//        }
        
        
        self.servantRef.queryOrdered(byChild:Constants.ServantConstants.lastName).observe(.value, with: { snapshot in
            var people: [Servants] = []
            for servant in snapshot.children {
                let servant = Servants(snapshot: servant as! FIRDataSnapshot)
                people.append(servant)
            }
            
            self.servantList = people
            self.tableView.reloadData()
    
        })
            
            
//            .value, with: { (snapshot) in
//            if let servantDict = snapshot.value as? [String:AnyObject] {
//                for (_,servantElement) in servantDict {
//                    print(servantElement)
//                    let servant = Servants()
//                    servant.firstName = servantElement[Constants.ServantConstants.firstName] as? String
//                    servant.lastName = servantElement[Constants.ServantConstants.lastName] as? String
//                    servant.phone = servantElement[Constants.ServantConstants.phone] as? String
//                    servant.email = servantElement[Constants.ServantConstants.email] as? String
//                    self.servantList.append(servant)
//                }
//            }
//            self.tableView.reloadData()
//        }) { (error) in
//            print(error.localizedDescription)
//        }

    }
    
    

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print(servantList.count)
        return servantList.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "DirectoryTableViewCell", for: indexPath) as! DirectoryTableViewCell
        
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
    
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    
//    // Override to support editing the table view.
//    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
//        if editingStyle == .delete {
//            // Delete the row from the data source
//            tableView.deleteRows(at: [indexPath], with: .fade)
//        } else if editingStyle == .insert {
//            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
//        }    
//    }
    
    override func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        
        let cell = tableView.cellForRow(at: indexPath) as! DirectoryTableViewCell
        let strippedPhoneNumber = cell.phoneLabel?.text?.components(separatedBy: NSCharacterSet.decimalDigits.inverted).joined(separator: "")
        
        let call = UITableViewRowAction(style: .normal, title: "Call") { action, index in
            let confirmCall = UIAlertController(title: "Calling:", message: cell.phoneLabel?.text, preferredStyle: .alert)
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
                let mailComposerVC = self.messageComposer.configuredMailComposeViewController(email: [(cell.emailLabel?.text!)!])
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
