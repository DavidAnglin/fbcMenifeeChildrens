//
//  DirectoryTableViewCell.swift
//  fbcmenifeeChildrens
//
//  Created by David Anglin on 1/4/17.
//  Copyright © 2017 David Anglin. All rights reserved.
//

import UIKit

class DirectoryTableViewCell: UITableViewCell {
    
    // MARK: - IBOutlets -
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var phoneLabel: UILabel!
    @IBOutlet weak var emailLabel: UILabel!
    
    // MARK: - IBActions -
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
