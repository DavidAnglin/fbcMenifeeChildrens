//
//  MessageComposer.swift
//  fbcmenifeeChildrens
//
//  Created by David Anglin on 1/10/17.
//  Copyright © 2017 David Anglin. All rights reserved.
//

import Foundation
import MessageUI

class MessageComposer: NSObject {
    
    func canSendText() -> Bool {
        return MFMessageComposeViewController.canSendText()
    }
    
    func canSendEmail() -> Bool {
        print(MFMailComposeViewController.canSendMail())
        return MFMailComposeViewController.canSendMail()
    }
    
    func configureMessageComposeViewController(number: [String]?) -> MFMessageComposeViewController {
        let messageComposeVC = MFMessageComposeViewController()
        messageComposeVC.messageComposeDelegate = self
        messageComposeVC.recipients = number
        return messageComposeVC
    }
    
    func configuredMailComposeViewController(email: [String]?) -> MFMailComposeViewController {
        let mailComposerVC = MFMailComposeViewController()
        mailComposerVC.mailComposeDelegate = self
        mailComposerVC.setToRecipients(email)
        
        return mailComposerVC
    }
}

extension MessageComposer: MFMessageComposeViewControllerDelegate {
    
    func messageComposeViewController(_ controller: MFMessageComposeViewController, didFinishWith result: MessageComposeResult) {
        controller.dismiss(animated: true, completion: nil)
    }
}

extension MessageComposer: MFMailComposeViewControllerDelegate {
    
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        controller.dismiss(animated: true, completion: nil)
    }
}
