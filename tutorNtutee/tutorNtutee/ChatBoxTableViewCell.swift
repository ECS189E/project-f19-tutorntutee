//
//  ChatBoxTableViewCell.swift
//  tutorNtutee
//
//  Created by Junjie Han on 11/24/19.
//  Copyright © 2019 Alessandro Liu. All rights reserved.
//

import UIKit

class ChatBoxTableViewCell: UITableViewCell {
    
    @IBOutlet weak var icon: UIImageView!
    @IBOutlet weak var lastMessage: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
