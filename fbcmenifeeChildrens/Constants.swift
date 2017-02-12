//
//  Constants.swift
//  fbcmenifeeChildrens
//
//  Created by David Anglin on 1/15/17.
//  Copyright © 2017 David Anglin. All rights reserved.
//

import Foundation

struct Constants {
    static let base_url = "https://fbcmenifeekids-eebb7.firebaseio.com"
    
    struct ServantConstants {
        static let firstName = "first_name"
        static let lastName = "last_name"
        static let phone = "phone"
        static let email = "email"
    }
    
    struct SegueConstants {
        static let toDirectory = "toDirectory"
        static let registerUser = "registerUser"
        static let registerToDirectory = "fromRegister"
    }
    
    struct AlertConstants {
        static let invalidInput = "Invalid Input"
        static let enterEmail = "Please enter valid email"
        static let enterPassword = "Please enter password"
        static let error = "Error"
        static let incorrectEmail = "Incorrect Email"
        static let confirmEmail = "Please Confirm Email"
        static let confirmPassword = "Please Confirm Password"
        static let passwordMismatch = "Passwords do not match"
        static let passwordRule = "Passwords must match!"
        static let emailMismatch = "Emails don't match"
        static let emailRule = "Emails need to match"
        static let success = "Success"
        static let ok = "Ok"
        static let cancel = "Cancel"
        static let createdAccount = "You successfully created an account"
        static let passwordLength = "Password Length too Short"
        static let passwordRequirement = "Password must be more than 3 characters long"
    }
    
    struct LoginViewControllerConstants {
        static let forgotPasswordTitle = "Forgot Password?"
        static let forgotPasswordMessage = " Please enter email to reset password."
        static let sendEmail = "Send Email"
        static let cancel = "Cancel"
        
        static let confirmRegistrationTitle = "Confirm FBC Menifee Servant"
        static let confirmRegistrationMessage = "Please enter registration code"
        static let submit = "Submit"
        
        static let registrationCode = "registerCode"
    }
    
    struct ScheduleConstants {
        static let schedulePDF = "schedule.pdf"
        static let storageURL = "gs://fbcmenifeekids-eebb7.appspot.com"
    }
    
    struct DirectoryConstants {
        static let userRef = "users"
        static let servantRef = "servants"
        static let directoryCellId = "DirectoryTableViewCell"
        static let call = "Call"
        static let calling = "Calling:"
        static let message = "Message"
        static let messageError = "Unable to send text message!"
        static let mailTitle = "iOS Mail Disabled"
        static let mailDisabled = "Please enable iOS Mail to use this feature."
    }
}

