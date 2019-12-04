//
//  HomeViewController.swift
//  tutorNtutee
//
//  Created by Adila on 11/19/19.
//  Copyright © 2019 Alessandro Liu. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase
import FirebaseStorage
class HomeViewController: UIViewController,UITableViewDataSource, UITableViewDelegate  {
    @IBOutlet weak var tableView: UITableView!
    var ref:DatabaseReference!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    let cellSpacingHeight: CGFloat = 200
    var userID : String?
    var postArray = [String]()
    override func viewDidLoad() {
        super.viewDidLoad()
        ref = Database.database().reference()
        loadPosts()
        
        activityIndicator.hidesWhenStopped = true
        self.activityIndicator.startAnimating()
        DispatchQueue.main.asyncAfter(deadline: .now() + 3.0){
            self.tableView.delegate = self
            self.tableView.dataSource = self
            self.tableView.allowsSelection = true
            print(self.postArray.count)
            self.tableView.reloadData()
            self.activityIndicator.isHidden = true
        }
        
        // Do any additional setup after loading the view.
    }
    func loadPosts(){
        Database.database().reference().child("posts").observeSingleEvent(of: .value, with: { (snapshot) in
            let posts = snapshot.value as? NSArray
            for onePost in posts ?? ["error in getting the nsarray elements"] {
                print("----------------------------")
                let po = onePost as! String
                print(po)
                self.postArray.append(po)
            }
//             self.tableView.reloadData()
        }){ (error) in
            print(error.localizedDescription)
        }
//        print(self.postArray.count)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.postArray.count-1
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return CGFloat(cellSpacingHeight)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reusecell", for: indexPath) as! SessionPostCell
        
        cell.myimage.image = UIImage(named: "user.png")
        cell.backgroundImg.layer.masksToBounds = true
        cell.backgroundImg.layer.cornerRadius = 10.0
        print("Generating table view!!",self.postArray.count)
//        for n in 0...self.postArray.count-1 {
//            print(self.postArray[n])
//        }
        
        let fullName : String = self.postArray[indexPath.row+1]
//        print(fullName)
        let fullNameArr : [String] = fullName.components(separatedBy: " ")
        let posterUid :String = fullNameArr[0]
        let className : String = fullNameArr[1]
        let date : String = fullNameArr[2]
        let timeS : String = fullNameArr[3]
        let timeE : String = fullNameArr[4]
        let cost : String = fullNameArr[5]
//        print(posterUid)
        let imageName = "\(posterUid).png"
        let imageRef = Storage.storage().reference().child(imageName)
        imageRef.getData(maxSize: 20*2048*2048){ response, error in
            if let err = error {
                   print("\(err)")
                   return
            }
            if let data = response {
                print("Sucessfully download image.")
                cell.myimage.image = UIImage(data: data)
            }else{
                cell.myimage.image = UIImage(named: "default.png")!
            }
        }
        cell.courseName.text = className
        cell.avaliable.text = "\(date) \(timeS) to \(timeE)"
        cell.textLabel?.text = "\(indexPath.row)"
        cell.backgroundColor = UIColor.white
        cell.layer.borderColor = UIColor.black.cgColor
        cell.layer.borderWidth = 1
        cell.layer.cornerRadius = 30
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(identifier: "DetailVC")
        let dVC = vc as! DetailVC
        dVC.modalPresentationStyle = .fullScreen
        dVC.detailedJson = self.postArray[indexPath.row+1]
        self.present(dVC,animated: true,completion: nil)
    }
}

