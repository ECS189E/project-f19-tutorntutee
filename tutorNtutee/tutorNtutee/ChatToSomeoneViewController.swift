//
//  ChatToSomeoneViewController.swift
//  tutorNtutee
//
//  Created by Junjie Han on 11/21/19.
//  Copyright © 2019 Alessandro Liu. All rights reserved.
//

import UIKit
import Firebase

class ChatToSomeoneViewController: UIViewController,UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate {
    
    @IBOutlet weak var messageTextField: UITextField!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var nameField: UILabel!
    
    var fromId:String? // = "0000"
    var toId:String="error"
    var messageArray:[Message]=[]
    var post:String = ""
    var signal = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        messageTextField.placeholder="Enter message..."
        
        if let sender=Auth.auth().currentUser{
            self.fromId=sender.uid
        }
        let tap = UITapGestureRecognizer(target: self, action: #selector(ChatToSomeoneViewController.handleTap))
               view.addGestureRecognizer(tap)
        
        tableView.separatorStyle = .none
        
        Database.database().reference().child("user").child(toId).observeSingleEvent(of: .value, with: {(snapshot) in
            let value = snapshot.value as? NSDictionary
            self.nameField.text=value?["username"] as? String ?? ""
        })
        
        observeMessage()
        
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 50
    
        self.tableView.delegate=self
        self.tableView.dataSource=self
    }
    @objc func handleTap() {
        messageTextField.resignFirstResponder()
        view.endEditing(true)
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
                        if(self?.messageArray.count ?? 0>0){
                            let indexPath = IndexPath(row: (self?.messageArray.count ?? 0)-1, section: 0)
                            self?.tableView.scrollToRow(at: indexPath, at: UITableView.ScrollPosition.bottom, animated: true)
                        }
                    })
                }
            }
        })
    }
    
    func isBlank(_ string: String) -> Bool {
      for character in string {
        if !character.isWhitespace {
            return false
        }
      }
      return true
    }
    
    @IBAction func sendMessage() {
        if let text =  messageTextField.text{
            if(isBlank(text)){
                let errorMessage = UIAlertController(title: "error", message: "message cannot be empty", preferredStyle: .alert)
                let close = UIAlertAction(title: "close", style: .cancel, handler: nil)
                errorMessage.addAction(close)
                self.present(errorMessage,animated: true,completion: nil)
            }else{
                let ref = Database.database().reference().child("messages")
                let childRef = ref.childByAutoId()
                let timestamp:NSNumber = NSNumber(value: NSDate().timeIntervalSince1970)
                let values=["text":text,"fromId":fromId,"toId":toId,"timestamp":timestamp] as [String : Any]
                childRef.updateChildValues(values)
                messageTextField.text=""
            }
        }
    }
    
    @IBAction func back() {
        
        if(self.signal == 1){
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let vc = storyboard.instantiateViewController(identifier: "MenuInitView")
            let navControllerVC = vc as! UITabBarController
            navControllerVC.modalPresentationStyle = .fullScreen
            self.present(navControllerVC,animated: true, completion: nil)
            navControllerVC.selectedIndex=1
        }else{
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let vc = storyboard.instantiateViewController(identifier: "DetailVC")
            let dVC = vc as! DetailVC
            dVC.detailedJson=self.post
            dVC.modalPresentationStyle = .fullScreen
            self.present(dVC,animated: true, completion: nil)
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
            if let text = message.text{
                sendCell.messageLabel.text=text+"  "
                sendCell.messageLabel.numberOfLines=0
                sendCell.messageLabel.sizeToFit()
                sendCell.messageLabel.clipsToBounds=true
                sendCell.messageLabel.layer.cornerRadius=10
                sendCell.messageLabel.widthAnchor.constraint(lessThanOrEqualToConstant: 180).isActive = true
            return sendCell
            }
        }
        
        guard let receiveCell = tableView.dequeueReusableCell(withIdentifier: "receiveCell") as? ReceiveTableViewCell else{
            return UITableViewCell()
        }
        if let text = message.text{
            receiveCell.messageLabel.text=text+"  "
            receiveCell.messageLabel.numberOfLines=0
            receiveCell.messageLabel.sizeToFit()
            receiveCell.messageLabel.clipsToBounds = true
            receiveCell.messageLabel.layer.cornerRadius=10
            receiveCell.messageLabel.widthAnchor.constraint(lessThanOrEqualToConstant: 180).isActive = true
        }
        return receiveCell
    }
    
    
    /***
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        if let text = messageArray[indexPath.row].text{
            if(text.count <= 15){
                return 40
            }
            
            return CGFloat(30*(text.count/17-1)+40)
        }
        return 40
    }
    */
}
