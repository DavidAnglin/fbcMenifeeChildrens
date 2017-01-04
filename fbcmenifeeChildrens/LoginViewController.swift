//
//  LoginViewController.swift
//  fbcmenifeeChildrens
//
//  Created by David Anglin on 12/18/16.
//  Copyright © 2016 David Anglin. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {
    
    fileprivate struct LoginConstants {
        fileprivate static let forgotPasswordTitle = "Forgot Password?"
        fileprivate static let forgotPasswordMessage = " Please enter email to reset password."
        fileprivate static let sendEmail = "Send Email"
        fileprivate static let cancel = "Cancel"
        
        fileprivate static let confirmRegistrationTitle = "Confirm FBC Menifee Servant"
        fileprivate static let confirmRegistrationMessage = "Please enter registration code"
        fileprivate static let submit = "Submit"
    }
    
    // Private Constants
    
    // Public Constants
    
    // Private Variables
    
    // Public Variables
    
    // IBOutlets
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    
    // IBActions
    @IBAction func signInButton(_ sender: UIButton) {
    }
    
    @IBAction func forgotPasswordButton(_ sender: UIButton) {
        let alert = UIAlertController(title: LoginConstants.forgotPasswordTitle, message: LoginConstants.forgotPasswordMessage, preferredStyle: .alert)
        
        let sendEmail = UIAlertAction(title: LoginConstants.sendEmail, style: .default) { action in
            let emailEntry = alert.textFields![0].text
            if (emailEntry!.isEmpty) {
                return
            }
        
        }
        let cancelAction = UIAlertAction(title: LoginConstants.cancel, style: .cancel)
        
        alert.addTextField(configurationHandler: nil)
        alert.addAction(sendEmail)
        alert.addAction(cancelAction)
        present(alert, animated: true, completion: nil)
    }
    
    @IBAction func registerButton(_ sender: UIButton) {
        let alert = UIAlertController(title: LoginConstants.confirmRegistrationTitle, message: LoginConstants.confirmRegistrationMessage, preferredStyle: .alert)
        
        let submit = UIAlertAction(title: LoginConstants.submit, style: .default) { action in
            let confirmationCode = "568925"
            let confirmationCodeEntry = alert.textFields![0].text
            if (confirmationCodeEntry == confirmationCode) {
                self.performSegue(withIdentifier: "registerUser", sender: self)
            } else {
                return
            }
        }
        let cancel = UIAlertAction(title: LoginConstants.cancel, style: .cancel)
        
        alert.addTextField(configurationHandler: nil)
        alert.addAction(submit)
        alert.addAction(cancel)
        present(alert, animated: true, completion: nil)
    }
    
    @IBAction func unwindFromDirectory(segue: UIStoryboardSegue) {
        
    }
    
    @IBAction func unwindFromRegistration(segue: UIStoryboardSegue) {
        
    }
    
    override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
        if (identifier == "registerUser") {
            return false
        }
        return true
    }
    
    // View Controller Life Cycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.hideKeyboardWhenTappedAround()

        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(notification:)), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(notification:)), name: NSNotification.Name.UIKeyboardWillHide, object: nil)

    }


    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    // Notifcation Handling
    
    func keyboardWillShow(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            if self.view.frame.origin.y == 0 {
                self.view.frame.origin.y -= keyboardSize.height
            }
        }
    }
    
    func keyboardWillHide(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            if self.view.frame.origin.y != 0{
                self.view.frame.origin.y += keyboardSize.height
            }
        }
    }
    
    // deInit
    deinit {
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }
    
    
    
    
    
}
