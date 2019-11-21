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
class HomeViewController: UIViewController,UITableViewDataSource, UITableViewDelegate  {
    

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
            cell.myimage.image = UIImage(named: "user.png")
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
        dVC.modalPresentationStyle = .fullScreen
        //self.tabBarController?.pushViewController(dVC, animated: true)
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
