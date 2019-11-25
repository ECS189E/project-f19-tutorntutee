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
    
    @IBOutlet weak var messageTextField: UITextField!
    @IBOutlet weak var tableView: UITableView!
    
    var fromId:String? // = "0000"
    var toId:String="qd1pYL2agYQB7b2TotHc9MbgtXC3"
    var messageArray:[Message]=[]
    //var ref:DatabaseReference!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        messageTextField.placeholder="Enter message..."
        
        if let sender=Auth.auth().currentUser{
            self.fromId=sender.uid
        }
        
        observeMessage()
        
        self.tableView.delegate=self
        self.tableView.dataSource=self
    }
    
    func observeMessage(){
        let ref = Database.database().reference().child("messages")
        ref.observe(.childAdded, with: { [weak self] snapshot in
            if let dictionary = snapshot.value as? [String: Any]{
                let message = Message(dictionary: dictionary)
                if((message.fromId == self?.fromId && message.toId == self?.toId) || (message.toId == self?.fromId && message.fromId == self?.toId)){
                    self?.messageArray.append(message)
                    
                    DispatchQueue.main.async(execute: {
                        self?.tableView.reloadData()
                    })
                }
            }
        })
    }
    
    @IBAction func sendMessage() {
        if let text =  messageTextField.text{
            let ref = Database.database().reference().child("messages")
            let childRef = ref.childByAutoId()
            let timestamp:NSNumber = NSNumber(value: NSDate().timeIntervalSince1970)
            let values=["text":text,"fromId":fromId,"toId":toId,"timestamp":timestamp] as [String : Any]
            childRef.updateChildValues(values)
            messageTextField.text=""
        }
    }
    
    //MARK: tableView Statement
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messageArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let message = messageArray[indexPath.row]
        var cell = tableView.dequeueReusableCell(withIdentifier: "receiveCell") ?? UITableViewCell(style: .default, reuseIdentifier: "receiveCell")
        if(message.fromId == fromId){
            cell = tableView.dequeueReusableCell(withIdentifier: "sendCell") ?? UITableViewCell(style: .default, reuseIdentifier: "sendCell")
        }
        cell.textLabel?.text=message.text
        
        return cell
    }
    
}
