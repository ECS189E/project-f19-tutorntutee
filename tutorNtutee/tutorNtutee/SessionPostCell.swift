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
    @IBOutlet weak var backgroundImg: UIImageView!
    
    
    @IBOutlet weak var myimage: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        backgroundImg.layer.masksToBounds = true
        backgroundImg.layer.cornerRadius = 10.0
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    
}
