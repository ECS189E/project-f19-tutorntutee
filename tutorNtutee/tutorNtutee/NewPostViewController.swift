//
//  NewPostViewController.swift
//  tutorNtutee
//
//  Created by Adila on 11/19/19.
//  Copyright © 2019 Alessandro Liu. All rights reserved.
//

import UIKit

class NewPostViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func newPost(_ sender: Any) {
                            let storyboard = UIStoryboard(name: "Main", bundle: nil)
                            let vs = storyboard.instantiateViewController(identifier: "LoggedInNavController")
                            let TapHomeVC = vs as! UINavigationController
                            TapHomeVC.modalPresentationStyle = .fullScreen
                            self.present(TapHomeVC, animated: true, completion: nil)
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
