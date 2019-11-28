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
    @IBOutlet weak var nameField: UILabel!
    
    var fromId:String? // = "0000"
    var toId:String="V45TFWp0ahU0OfX8Kp5FPwxpvQA3"
    var messageArray:[Message]=[]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        messageTextField.placeholder="Enter message..."
        
        if let sender=Auth.auth().currentUser{
            self.fromId=sender.uid
        }
        
        
        Database.database().reference().child("user").child(toId).observeSingleEvent(of: .value, with: {(snapshot) in
            let value = snapshot.value as? NSDictionary
            self.nameField.text=value?["username"] as? String ?? ""
        })
        
        observeMessage()
        
        self.tableView.delegate=self
        self.tableView.dataSource=self
    }
    
    func observeMessage(){
        let ref = Database.database().reference().child("messages")
        let messageRef = Database.database().reference().child("messageUser")
        
        ref.observe(.childAdded, with: { [weak self] snapshot in
            if let dictionary = snapshot.value as? [String: Any]{
                let message = Message(dictionary: dictionary)
                if((message.fromId == self?.fromId && message.toId == self?.toId) || (message.toId == self?.fromId && message.fromId == self?.toId)){
                    self?.messageArray.append(message)
                    let values = ["lastMessage":message.text,"timestamp":message.timestamp] as [String : Any]
                    
                    messageRef.child(message.fromId ?? "error").child(message.toId ?? "error").updateChildValues(values)
                    messageRef.child(message.toId ?? "error").child(message.fromId ?? "error").updateChildValues(values)
                    
                    /*
                    if(message.fromId == self?.fromId){
                        messageRef.child(message.fromId ?? "error").child(message.toId ?? "error").updateChildValues(values)
                    }else{
                        messageRef.child(message.toId ?? "error").child(message.fromId ?? "error").updateChildValues(values)
                    }*/
                    
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
        if(message.fromId == fromId){
            guard let sendCell = tableView.dequeueReusableCell(withIdentifier: "sendCell") as? SendTableViewCell else{
                return UITableViewCell()
            }
            sendCell.messageLabel.text=message.text
            return sendCell
        }
        
        guard let receiveCell = tableView.dequeueReusableCell(withIdentifier: "receiveCell") as? ReceiveTableViewCell else{
            return UITableViewCell()
        }
        receiveCell.messageLabel.text=message.text
        return receiveCell
    }
}
