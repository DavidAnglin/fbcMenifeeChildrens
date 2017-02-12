//
//  LoginViewController.swift
//  fbcmenifeeChildrens
//
//  Created by David Anglin on 12/18/16.
//  Copyright © 2016 David Anglin. All rights reserved.
//

import UIKit
import Firebase

class LoginViewController: UIViewController {
    
    // MARK: - Public Variables -
    fileprivate var codeRef: FIRDatabaseReference!
    fileprivate var servantRef: FIRDatabaseReference!
    fileprivate var registrationCode: String! = ""
    
    // MARK: - IBOutlets -
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    // MARK: - IBActions -
    @IBAction func signInButton(_ sender: UIButton) {
        guard let email = emailTextField.text?.trimmingCharacters(in: NSCharacterSet.whitespaces), !email.isEmpty, VerificationHelpers.verifyInput(input: email) else {
            showAlert(Constants.AlertConstants.invalidInput, message: Constants.AlertConstants.enterEmail)
            return
        }
        
        guard let password = passwordTextField.text?.trimmingCharacters(in: NSCharacterSet.whitespaces), !password.isEmpty, VerificationHelpers.verifyInput(input: password) else {
            showAlert(Constants.AlertConstants.invalidInput, message: Constants.AlertConstants.enterPassword)
            return
        }
        
        if (VerificationHelpers.verifyEmail(email: email)) {
            FIRAuth.auth()!.signIn(withEmail: email, password: password) { (user, error) in
                
                if (error == nil) {
                    self.emailTextField.text = ""
                    self.passwordTextField.text = ""
                    self.performSegue(withIdentifier: Constants.SegueConstants.toDirectory, sender: nil)
                } else if let error = error {
                    self.showAlert(Constants.AlertConstants.error, message: error.localizedDescription)
                }
            }
        } else {
            showAlert(Constants.AlertConstants.incorrectEmail, message: Constants.AlertConstants.enterEmail)
        }
    }
    
    @IBAction func forgotPasswordButton(_ sender: UIButton) {
        let alert = UIAlertController(title: Constants.LoginViewControllerConstants.forgotPasswordTitle, message: Constants.LoginViewControllerConstants.forgotPasswordMessage, preferredStyle: .alert)
        
        let sendEmail = UIAlertAction(title: Constants.LoginViewControllerConstants.sendEmail, style: .default) { action in
            let emailEntry = alert.textFields![0].text
            if (emailEntry!.isEmpty) {
                return
            }
            
            FIRAuth.auth()?.sendPasswordReset(withEmail: emailEntry!) { (error) in
                if let error = error {
                    self.showAlert(Constants.AlertConstants.error, message: error.localizedDescription)
                    return
                }
            }
        }
        let cancelAction = UIAlertAction(title: Constants.LoginViewControllerConstants.cancel, style: .cancel)
        
        alert.addTextField(configurationHandler: nil)
        alert.addAction(sendEmail)
        alert.addAction(cancelAction)
        present(alert, animated: true, completion: nil)
    }
    
    @IBAction func registerButton(_ sender: UIButton) {
        let alert = UIAlertController(title: Constants.LoginViewControllerConstants.confirmRegistrationTitle, message: Constants.LoginViewControllerConstants.confirmRegistrationMessage, preferredStyle: .alert)
        
        let submit = UIAlertAction(title: Constants.LoginViewControllerConstants.submit, style: .default) { action in
            let confirmationCodeEntry = alert.textFields![0].text
            if (confirmationCodeEntry == self.registrationCode) {
                self.performSegue(withIdentifier: Constants.SegueConstants.registerUser, sender: self)
            } else {
                return
            }
        }
        
        let cancel = UIAlertAction(title: Constants.LoginViewControllerConstants.cancel, style: .cancel)
        
        alert.addTextField(configurationHandler: nil)
        alert.addAction(submit)
        alert.addAction(cancel)
        present(alert, animated: true, completion: nil)
    }
    
    @IBAction func unwindFromRegistration(segue: UIStoryboardSegue) {
        
    }
    
    // MARK: - View Controller Life Cycle Methods -
    override func viewDidLoad() {
        super.viewDidLoad()
        
        codeRef = FIRDatabase.database().reference(withPath: Constants.LoginViewControllerConstants.registrationCode)
        servantRef = FIRDatabase.database().reference(withPath: Constants.DirectoryConstants.servantRef)

        self.hideKeyboardWhenTappedAround()

        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(notification:)), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(notification:)), name: NSNotification.Name.UIKeyboardWillHide, object: nil)        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        getCode()
    }
    
    // MARK: - deinit -
    deinit {
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }

    // MARK: - Segue Functions -
    override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
        if (identifier == Constants.SegueConstants.registerUser) {
            return false
        } else if (identifier == Constants.SegueConstants.toDirectory) {
            return false
        }
        return true
    }
    
    // MARK: - Notifcation Handling -
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
    
    fileprivate func getCode() {
        codeRef.observeSingleEvent(of: .value, with: { (snapshot) in
            // Get user value
            let value = snapshot.value as? NSDictionary
            self.registrationCode = value?["code"] as? String ?? ""
        }) { (error) in
            self.showAlert(error.localizedDescription)
        }
    }
}
