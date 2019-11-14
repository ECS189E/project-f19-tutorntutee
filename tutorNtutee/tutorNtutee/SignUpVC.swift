//
//  SignUpVC.swift
//  tutorNtutee
//
//  Created by Alessandro on 11/10/19.
//  Copyright © 2019 Alessandro Liu. All rights reserved.
//

import UIKit
import Firebase

class SignUpVC: UIViewController,UIApplicationDelegate {
    
    @IBOutlet weak var firstNameField: UITextField!
    @IBOutlet weak var lastNameField: UITextField!
    @IBOutlet weak var userNameField: UITextField!
    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var passwordField: UITextField! //
    
    var ref:DatabaseReference!
    override func viewDidLoad() {
        super.viewDidLoad()
        ref=Database.database().reference()
        let viewTapGesture = UITapGestureRecognizer(target: self.view, action:#selector(UIView.endEditing))
        viewTapGesture.cancelsTouchesInView=true
        self.view.addGestureRecognizer(viewTapGesture)
    }
    
    @IBAction func doneButtonPress() {
        if let email=emailField.text,let password=passwordField.text{
            Auth.auth().createUser(withEmail: email, password: password) { authResult, error in
                if let _ = authResult{
                    if let user=Auth.auth().currentUser{
                        self.ref.child("user").child(user.uid).setValue(["username":self.userNameField.text])
                        self.ref.child("user").child(user.uid).setValue(["first_name":self.firstNameField.text])
                        self.ref.child("user").child(user.uid).setValue(["last_name":self.lastNameField.text])
                    }
                    self.performSegue(withIdentifier: "signupVCToSigninVC", sender: self)
                }
                
                if let error = error{
                    let errorMessage=UIAlertController(title: "error", message: "error occurs", preferredStyle: .alert)
                    let close = UIAlertAction(title:"close",style: .cancel,handler: nil)
                    errorMessage.addAction(close)
                    self.present(errorMessage,animated: true,completion: nil)
                }
            }
        }
    }
}
