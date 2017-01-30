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
    let toDirectory = "fromRegister"
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
        guard let email = emailTextField.text?.trimmingCharacters(in: NSCharacterSet.whitespaces), !email.isEmpty, verifyInput(input: email) else {
            presentAlert(title: "Invalid Input", message: "Please enter email.")
            return
        }
        
        guard let confirmEmail = confirmEmailTextField.text?.trimmingCharacters(in: NSCharacterSet.whitespaces), !confirmEmail.isEmpty, verifyInput(input: confirmEmail) else {
            presentAlert(title: "Invalid Input", message: "Please confirm email")
            return
        }
        
        guard let password = passwordTextField.text?.trimmingCharacters(in: NSCharacterSet.whitespaces), !password.isEmpty, verifyInput(input: password) else {
            presentAlert(title: "Invalid Input", message: "Please enter password")
            return
        }
        
        guard let confirmPassword = confirmPasswordTextField.text?.trimmingCharacters(in: NSCharacterSet.whitespaces), !confirmPassword.isEmpty, verifyInput(input: confirmPassword) else {
            presentAlert(title: "Invalid Input", message: "Please confirm password!")
            return
        }
        
        if (verifyEmail(email: email, confirmEmail: confirmEmail) && verifyPassword(password: password, confirmPassword: confirmPassword)) {
            FIRAuth.auth()?.createUser(withEmail: email, password: password) { (user, error) in
                if (error == nil) {
                    let successAlert = UIAlertController(title: "Success", message: "You successfully created an account", preferredStyle: .alert)
                    let okAction = UIAlertAction(title: "Ok", style: .default) { action in
                        if error == nil {
                            FIRAuth.auth()!.signIn(withEmail: email,
                                                   password: password)
                        }
                        self.performSegue(withIdentifier: "fromRegister", sender: self)
                    }
                    
                    successAlert.addAction(okAction)
                    self.present(successAlert, animated: true, completion: nil)
                } else {
                    self.presentAlert(title: "Error", message: (error?.localizedDescription)!)
                }
            }
        }
    }
    
    // MARK: - View Controller Lifecycle -
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    func verifyInput(input: String) -> Bool {
        if (!input.isEmpty) {
            return true
        } else {
            return false
        }
    }
    
    func verifyEmail(email: String, confirmEmail: String) -> Bool {
        if (email.isEmail() && confirmEmail.isEmail()) {
            if (email == confirmEmail) {
                return true
            } else {
                presentAlert(title: "Emails don't match", message: "Emails need to match")
                return false
            }
        } else {
            presentAlert(title: "Incorrect Email", message: "Please enter valid email!")
            return false
        }
    }
    
    func verifyPassword(password: String, confirmPassword: String) -> Bool {
        if (passwordLength(password: password, confirmPassword: confirmPassword)) {
            if (password == confirmPassword) {
                return true
            } else {
                presentAlert(title: "Passwords do not match", message: "Passwords must match!")
                return false
            }
        } else {
            presentAlert(title: "Password Length too short", message: "Password must be atleast 6 characters long")
            return false
        }
    }
    
    func passwordLength(password: String, confirmPassword: String) -> Bool {
        if (password.characters.count >= 6 && confirmPassword.characters.count >= 6) {
            return true
        } else {
            return false
        }
    }
    
    func presentAlert(title: String, message: String) {
        DispatchQueue.main.async {
            let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
            let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
            alert.addAction(cancelAction)
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
        if (identifier == toDirectory) {
            return false
        }
        return true
    }
}
