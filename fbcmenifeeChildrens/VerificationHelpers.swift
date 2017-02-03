//
//  VerificationHelpers.swift
//  fbcmenifeeChildrens
//
//  Created by David Anglin on 1/30/17.
//  Copyright © 2017 David Anglin. All rights reserved.
//

import Foundation
import UIKit

class VerificationHelpers {
    
    static func verifyInput(input: String) -> Bool {
        if (!input.isEmpty) {
            return true
        } else {
            return false
        }
    }
    
    static func verifyEmail(email: String) -> Bool {
        if (email.isEmail()) {
            return true
        } else {
            return false
        }
    }
        
    static func verifyPassword(password: String, confirmPassword: String) -> Bool {
        if (password == confirmPassword) {
            return true
        } else {
            return false
        }
    }
    
    static func verifyEmail(email: String, confirmEmail: String) -> Bool {
        if (email.isEmail() && confirmEmail.isEmail()) {
            if (email == confirmEmail) {
                return true
            } else {
                return false
            }
        } else {
            return false
        }
    }
}
