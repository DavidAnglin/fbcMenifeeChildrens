//
//  String+VerifyEmail.swift
//  fbcmenifeeChildrens
//
//  Created by David Anglin on 1/11/17.
//  Copyright © 2017 David Anglin. All rights reserved.
//

import Foundation

extension String {
    func isEmail() -> Bool
    {
        let emailRegex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,6}"
        return NSPredicate(format: "SELF MATCHES %@", emailRegex).evaluate(with: self)
    }
}
