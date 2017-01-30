//
//  Servants.swift
//  fbcmenifeeChildrens
//
//  Created by David Anglin on 1/29/17.
//  Copyright © 2017 David Anglin. All rights reserved.
//

import Foundation
import Firebase

class Servants: NSObject {
    
    var email: String?
    var phone: String?
    var firstName: String!
    var lastName: String!
    
    init(snapshot: FIRDataSnapshot) {
        let snapshotValue = snapshot.value as! [String: Any]
        self.firstName = snapshotValue[Constants.ServantConstants.firstName] as! String
        self.lastName = snapshotValue[Constants.ServantConstants.lastName] as! String
        self.phone = snapshotValue[Constants.ServantConstants.phone] as? String
        self.email = snapshotValue[Constants.ServantConstants.email] as? String
    }
}
