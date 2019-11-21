//
//  ChatToSomeoneViewController.swift
//  tutorNtutee
//
//  Created by Junjie Han on 11/21/19.
//  Copyright © 2019 Alessandro Liu. All rights reserved.
//

import UIKit
import Firebase

class ChatToSomeoneViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var messageTextField: UITextField!
    
    var sendId:String="0000"
    var receiveId:String="1111"
    var messageSendArray:[String]=[]
    var messageReceiveArray:[String]=[]
    var ref:DatabaseReference!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let sender=Auth.auth().currentUser{
            self.sendId=sender.uid
        }
        
        self.ref=Database.database().reference()
        let query=ref.child("chat").child(sendId).child(receiveId).queryLimited(toLast: 10)
        _ = query.observe(.childAdded, with: { [weak self] snapshot in
            if let data=snapshot.value as? [String:String],
                let text=data["text"],
                !text.isEmpty{
                self?.messageReceiveArray.append(text)
            }
        })
        
        
        self.tableView.delegate=self
        self.tableView.dataSource=self
    }
    
    @IBAction func sendMessage() {
        if let text =  messageTextField.text{
            messageSendArray.append(text)
            tableView.reloadData()
            messageTextField.text=""
            self.ref.child("chat").child(sendId).child(receiveId).child("text").child(text)
        }
    }
    
    //MARK: tableView Statement
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messageSendArray.count+messageReceiveArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell1=UITableViewCell(style: .default, reuseIdentifier: "sendCell")
        cell1.textLabel?.text=messageSendArray[indexPath.row]
        return cell1
    }
    
}
