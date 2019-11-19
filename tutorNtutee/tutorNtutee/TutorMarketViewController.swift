//
//  TutorMarketViewController.swift
//  tutorNtutee
//
//  Created by Adila on 11/12/19.
//  Copyright © 2019 Alessandro Liu. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase
class TutorMarketViewController: UIViewController,UITableViewDataSource, UITableViewDelegate {
    
    
    @IBOutlet weak var tableView: UITableView!
    let cellSpacingHeight: CGFloat = 200
        override func viewDidLoad() {
            super.viewDidLoad()
            tableView.delegate = self
            tableView.dataSource = self
            tableView.allowsSelection = true
            // Do any additional setup after loading the view.
        }
    
        func loadPosts(){
            Database.database().reference().child("Posts").observe(.childAdded){ (snapshot: DataSnapshot) in
                //print(snapshot.value)
            }
        }
    
        func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            return 5
        }
    
        func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
            return CGFloat(cellSpacingHeight)
        }

        func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
             let cell = tableView.dequeueReusableCell(withIdentifier: "reusecell", for: indexPath) as! SessionPostCell
            cell.courseName.text = "ECS 150"
            cell.avaliable.text = "Nov 25, 3-5pm"
            cell.myimage.image = UIImage(named: "default.png")
            cell.textLabel?.text = "\(indexPath.row)"
            cell.backgroundColor = UIColor.white
            cell.layer.borderColor = UIColor.gray.cgColor
            cell.layer.borderWidth = 2
            cell.layer.cornerRadius = 10
            return cell
        }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(identifier: "DetailVC")
        let dVC = vc as! DetailVC
        self.navigationController?.pushViewController(dVC, animated: true)
    }
    
    }


    
    

  

