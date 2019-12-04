//
//  DetailVC.swift
//  tutorNtutee
//
//  Created by Adila on 11/13/19.
//  Copyright © 2019 Alessandro Liu. All rights reserved.
//

import UIKit

class DetailVC: UIViewController {
    
    var detailedJson: String?
    @IBOutlet weak var dImage: UIImageView!
    @IBOutlet weak var name: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print(detailedJson ?? "NIL")
        
    }
    
    func parseString(){
        
    }
    
    @IBAction func chatWithTutor() {
        let stotyboard = UIStoryboard(name: "Main", bundle: nil)
        let vs = stotyboard.instantiateViewController(identifier: "ChatToSomeoneVC")
        let chatWithSomeoneVC = vs as! ChatToSomeoneViewController
        chatWithSomeoneVC.modalPresentationStyle = .fullScreen
        chatWithSomeoneVC.toId = "lalala"
        self.present(chatWithSomeoneVC, animated: true, completion: nil)
    }
    
    @IBAction func backToPost(_ sender: Any) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vs = storyboard.instantiateViewController(identifier: "MenuInitView")
        let navControllerVC = vs as! UITabBarController
        navControllerVC.modalPresentationStyle = .fullScreen
        self.present(navControllerVC, animated: true, completion: nil)
    }
}
