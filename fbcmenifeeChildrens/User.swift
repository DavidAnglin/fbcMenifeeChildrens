//
//  User.swift
//  fbcmenifeeChildrens
//
//  Created by David Anglin on 1/19/17.
//  Copyright © 2017 David Anglin. All rights reserved.
//

import Foundation
import Firebase

struct User {
    
    let uid: String
    let email: String
    
    init(authData: FIRUser) {
        uid = authData.uid
        email = authData.email!
    }
    
    init(uid: String, email: String) {
        self.uid = uid
        self.email = email
    }
}
