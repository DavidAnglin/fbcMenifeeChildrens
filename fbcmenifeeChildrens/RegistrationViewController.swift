//
//  RegistrationViewController.swift
//  fbcmenifeeChildrens
//
//  Created by David Anglin on 12/18/16.
//  Copyright © 2016 David Anglin. All rights reserved.
//

import UIKit
import Firebase

class RegistrationViewController: UIViewController {
    
    // MARK: - Private Constants -
    // MARK: - Public Constants -
    let usersRef = FIRDatabase.database().reference(withPath: "users")
    
    // MARK: - Private Variables -
    // MARK: - Public Variables -
    
    // MARK: - IBOutlets -
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var confirmEmailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var confirmPasswordTextField: UITextField!
    
    // MARK: - IBActions -
    @IBAction func registerButton(_ sender: UIButton) {
        registerUser()
    }
    
    // MARK: - View Controller Lifecycle -
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    // MARK: - Segue Functions -
    override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
        if (identifier == Constants.SegueConstants.registerToDirectory) {
            return false
        }
        return true
    }
    
    // MARK: - Register User -
    func registerUser() {
        guard let email = emailTextField.text?.trimmingCharacters(in: NSCharacterSet.whitespaces), !email.isEmpty, VerificationHelpers.verifyInput(input: email) else {
            showAlert(Constants.AlertConstants.invalidInput, message: Constants.AlertConstants.enterEmail)
            return
        }
        
        guard let confirmEmail = confirmEmailTextField.text?.trimmingCharacters(in: NSCharacterSet.whitespaces), !confirmEmail.isEmpty, VerificationHelpers.verifyInput(input: confirmEmail) else {
            showAlert(Constants.AlertConstants.invalidInput, message: Constants.AlertConstants.confirmEmail)
            return
        }
        
        guard let password = passwordTextField.text?.trimmingCharacters(in: NSCharacterSet.whitespaces), !password.isEmpty, VerificationHelpers.verifyInput(input: password) else {
            showAlert(Constants.AlertConstants.invalidInput, message: Constants.AlertConstants.enterPassword)
            return
        }
        
        guard let confirmPassword = confirmPasswordTextField.text?.trimmingCharacters(in: NSCharacterSet.whitespaces), !confirmPassword.isEmpty, VerificationHelpers.verifyInput(input: confirmPassword) else {
            showAlert(Constants.AlertConstants.invalidInput, message: Constants.AlertConstants.confirmPassword)
            return
        }
        
        if (VerificationHelpers.verifyEmail(email: email, confirmEmail: confirmEmail)) {
            if (VerificationHelpers.verifyPassword(password: password, confirmPassword: confirmPassword)) {
                FIRAuth.auth()?.createUser(withEmail: email, password: password) { (user, error) in
                    if (error == nil) {
                        let successAlert = UIAlertController(title: Constants.AlertConstants.success, message: Constants.AlertConstants.createdAccount, preferredStyle: .alert)
                        let okAction = UIAlertAction(title: Constants.AlertConstants.ok, style: .default) { action in
                            if error == nil {
                                FIRAuth.auth()!.signIn(withEmail: email,
                                                       password: password)
                            }
                            self.performSegue(withIdentifier: Constants.SegueConstants.registerToDirectory, sender: self)
                        }
                        
                        successAlert.addAction(okAction)
                        self.present(successAlert, animated: true, completion: nil)
                    } else {
                        self.showAlert(Constants.AlertConstants.error, message: error?.localizedDescription)
                    }
                }
            } else {
                showAlert(Constants.AlertConstants.passwordMismatch, message: Constants.AlertConstants.passwordRule)
            }
        } else {
            showAlert(Constants.AlertConstants.emailMismatch, message: Constants.AlertConstants.emailRule)
        }
    }
}
