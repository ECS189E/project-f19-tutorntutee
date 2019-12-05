//
//  SendTableViewCell.swift
//  tutorNtutee
//
//  Created by Junjie Han on 11/24/19.
//  Copyright © 2019 Alessandro Liu. All rights reserved.
//

import UIKit

class SendTableViewCell: UITableViewCell {
    
    @IBOutlet weak var messageLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        //messageLabel.numberOfLines = 0
    }
}
