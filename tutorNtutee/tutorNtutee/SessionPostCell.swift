//
//  SessionPostCell.swift
//  tutorNtutee
//
//  Created by Adila on 11/13/19.
//  Copyright © 2019 Alessandro Liu. All rights reserved.
//

import UIKit

class SessionPostCell: UITableViewCell {
    
    @IBOutlet weak var avaliable: UILabel!
    @IBOutlet weak var courseName: UILabel!
    
    
    @IBOutlet weak var myimage: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    
}
