//
//  DetailVC.swift
//  tutorNtutee
//
//  Created by Adila on 11/13/19.
//  Copyright © 2019 Alessandro Liu. All rights reserved.
//

import UIKit
import Firebase
import FirebaseDatabase
import FirebaseStorage
class DetailVC: UIViewController {
    
    var detailedJson: String?
    @IBOutlet weak var dImage: UIImageView!
    @IBOutlet weak var name: UILabel!

    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var className: UILabel!
    var tutorName: String?
    var tutorUid: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print(detailedJson ?? "NIL")
        parseString()
    }
    
    func parseString(){
        let fullNameArr : [String] = self.detailedJson?.components(separatedBy: " ") ?? ["la la la"]
        let posterUid :String = fullNameArr[0]
        let classs : String = fullNameArr[1]
        let date : String = fullNameArr[2]
        let timeS : String = fullNameArr[3]
        let timeE : String = fullNameArr[4]
        let cost : String = fullNameArr[5]
        self.tutorUid = posterUid
        className.text = classs
        getTutorNamefromUID()
        let imageName = "\(posterUid).png"
        getUserImageFromFB(imageName: imageName)
        name.text = tutorName
        timeLabel.text = "\(date) \(timeS) to \(timeE)"
    }
    func getTutorNamefromUID(){
        Database.database().reference().child("user").child(self.tutorUid ?? "qd1pYL2agYQB7b2TotHc9MbgtXC3").observeSingleEvent(of: .value, with: {(snapshot) in
            let value = snapshot.value as? NSDictionary
            self.tutorName=value?["username"] as? String ?? ""
        })
    }
    func getUserImageFromFB(imageName: String){
        let imageRef = Storage.storage().reference().child(imageName)
        imageRef.getData(maxSize: 20*2048*2048){ response, error in
            if let err = error {
                   print("\(err)")
                   return
            }
            if let data = response {
                print("Sucessfully download image.")
                self.dImage.image = UIImage(data: data)
            }else{
                self.dImage.image = UIImage(named: "default.png")!
            }
        }
    }
    
    
    @IBAction func chatWithTutor() {
        let stotyboard = UIStoryboard(name: "Main", bundle: nil)
        let vs = stotyboard.instantiateViewController(identifier: "ChatToSomeoneVC")
        let chatWithSomeoneVC = vs as! ChatToSomeoneViewController
        chatWithSomeoneVC.modalPresentationStyle = .fullScreen
        chatWithSomeoneVC.toId = self.tutorUid ?? "error"
        chatWithSomeoneVC.post = self.detailedJson ?? "error"
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
