//
//  DetailVC.swift
//  tutorNtutee
//
//  Created by Adila on 11/13/19.
//  Copyright © 2019 Alessandro Liu. All rights reserved.
//

import UIKit

class DetailVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func chatWithTutor() {
        let stotyboard = UIStoryboard(name: "Main", bundle: nil)
        let vs = stotyboard.instantiateViewController(identifier: "ChatToSomeoneVC")
        let chatWithSomeoneVC = vs as! UIViewController
        self.present(chatWithSomeoneVC, animated: true, completion: nil)
    }
    
    @IBAction func chatViewinit(_ sender: Any) {
        
    }
}
