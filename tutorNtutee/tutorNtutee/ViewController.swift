//
//  ViewController.swift
//  tutorNtutee
//
//  Created by Alessandro on 11/10/19.
//  Copyright © 2019 Alessandro Liu. All rights reserved.
//

import UIKit
import Firebase

class ViewController: UIViewController, UITextFieldDelegate{
    var ref:DatabaseReference!
    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    @IBOutlet weak var SignInBt: UIButton!
    //    @IBOutlet weak var signUpBtn: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        passwordField.isSecureTextEntry = true
        signinBordersetup()
        emailField.delegate = self
        passwordField.delegate = self
        ref=Database.database().reference()
        emailField.text = "aadila@ucdavis.edu"
        passwordField.text = "Adila1628"
    }
    @IBAction func resetPasswordBtn(_ sender: Any) {
        guard let emailStr = emailField.text else {
            print("Error in getting the emailField.text")
            return
        }
        Auth.auth().sendPasswordReset(withEmail: emailStr) { error in
            // ...
        }
    }
    
    func signinBordersetup(){
        SignInBt.layer.masksToBounds = true
        SignInBt.layer.cornerRadius = 2.0
        SignInBt.layer.borderColor = UIColor.black.cgColor
        SignInBt.layer.borderWidth = 0.5
    }
    
    @IBAction func signInPress() {
        if let email=emailField.text,let password=passwordField.text{
            Auth.auth().signIn(withEmail: email, password: password) { [weak self] authResult, error in
                guard let strongSelf = self else { return }
                if let _ = authResult{
                    let user=Auth.auth().currentUser
                    if user != nil && !user!.isEmailVerified {
                        user!.sendEmailVerification(completion: { (error) in
                            print("sendEmailVerification sent!")
                            let errorMessage=UIAlertController(title: "Email Not Verified", message: "Verify Your Account and Try Again", preferredStyle: .alert)
                            let close = UIAlertAction(title:"Close",style: .cancel,handler: nil)
                            errorMessage.addAction(close)
                            self?.present(errorMessage,animated: true,completion: nil)
                        })
                    }
                    else {
                        print("Either the user is not available, or the user is already verified.")
                        let storyboard = UIStoryboard(name: "Main", bundle: nil)
                        let vs = storyboard.instantiateViewController(identifier: "MenuInitView")
                        let navControllerVC = vs as! UITabBarController
                        navControllerVC.modalPresentationStyle = .fullScreen
                        self?.present(navControllerVC, animated: true, completion: nil)
                    }
                    
                    /**
                     if let user=user{
                     self?.ref.child("user").child(user.uid).observeSingleEvent(of: .value, with: {(snapshot) in
                     let value=snapshot.value as? NSDictionary
                     let username=value?["username"] as? String ?? ""
                     print("-------------")
                     print(username)
                     })
                     }
                     */
                    //                    let storyboard = UIStoryboard(name: "Main", bundle: nil)
                    //                    let vs = storyboard.instantiateViewController(identifier: "LoggedInNavController")
                    //                    let TapHomeVC = vs as! UINavigationController
                    //                    TapHomeVC.modalPresentationStyle = .fullScreen
                    //                    self?.present(TapHomeVC, animated: true, completion: nil)
                    //
                    
                    
                }
                if let _ = error{
                    let errorMessage=UIAlertController(title: "error", message: "Wrong ID or Password. Please, try again.", preferredStyle: .alert)
                    let close = UIAlertAction(title:"close",style: .cancel,handler: nil)
                    errorMessage.addAction(close)
                    self?.present(errorMessage,animated: true,completion: nil)
                }
            }
        }
    }
    
    @IBAction func clearUfield(_ sender: Any) {
        self.emailField.text = ""
    }
    
    @IBAction func clearEfield(_ sender: Any) {
        self.passwordField.text = ""
    }
    
    //    @IBAction func SignUpClicked(_ sender: Any) {
    //        let storyboard = UIStoryboard(name: "Main", bundle: nil)
    //        let vs = storyboard.instantiateViewController(identifier: "SignUpVC")
    //        let signupview = vs as! SignUpVC
    //        signupview.modalPresentationStyle = .fullScreen
    //        self.present(signupview, animated: true, completion: nil)
    //    }
}

