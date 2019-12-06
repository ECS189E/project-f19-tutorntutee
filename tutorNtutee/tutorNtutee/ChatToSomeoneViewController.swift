//
//  ChatToSomeoneViewController.swift
//  tutorNtutee
//
//  Created by Junjie Han on 11/21/19.
//  Copyright © 2019 Alessandro Liu. All rights reserved.
//

import UIKit
import Firebase

//view that user chat someone personally
//user who send message write message information in firebase. User who receive message read fata from firebase. That's the way how we build chat part
class ChatToSomeoneViewController: UIViewController,UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate {
    
    @IBOutlet weak var messageTextField: UITextField!   //field that user edit and send new message
    @IBOutlet weak var tableView: UITableView!  //tableView shows conversation
    @IBOutlet weak var nameField: UILabel!   //show who user talk with
    
    var fromId:String?
    var toId:String="error"
    var messageArray:[Message]=[]  //array of message
    var post:String = ""
    var signal = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        messageTextField.placeholder="Enter message..."
        
        if let sender=Auth.auth().currentUser{
            self.fromId=sender.uid   //get user
        }
        let tap = UITapGestureRecognizer(target: self, action: #selector(ChatToSomeoneViewController.handleTap))
        view.addGestureRecognizer(tap)
        
        tableView.separatorStyle = .none
        
        Database.database().reference().child("user").child(toId).observeSingleEvent(of: .value, with: {(snapshot) in  //get the username who user talk with
            let value = snapshot.value as? NSDictionary
            self.nameField.text=value?["username"] as? String ?? ""
        })
        
        observeMessage()
        
        tableView.rowHeight = UITableView.automaticDimension  //dynamic cell height to fit short or long message
        tableView.estimatedRowHeight = 50
        
        self.tableView.delegate=self
        self.tableView.dataSource=self
    }
    @objc func handleTap() {
        messageTextField.resignFirstResponder()
        view.endEditing(true)
    }
    
    //read message from firebase
    func observeMessage(){
        let ref = Database.database().reference().child("messages")
        let messageRef = Database.database().reference().child("messageUser")
        
        ref.observe(.childAdded, with: { [weak self] snapshot in
            if let dictionary = snapshot.value as? [String: Any]{
                let message = Message(dictionary: dictionary)
                if((message.fromId == self?.fromId && message.toId == self?.toId) || (message.toId == self?.fromId && message.fromId == self?.toId)){ //only message sent or received by currentUser will be observed and show
                    self?.messageArray.append(message)
                    let values = ["lastMessage":message.text,"timestamp":message.timestamp] as [String : Any]
                    
                    messageRef.child(message.fromId ?? "error").child(message.toId ?? "error").updateChildValues(values)
                    messageRef.child(message.toId ?? "error").child(message.fromId ?? "error").updateChildValues(values)
                    
                    DispatchQueue.main.async(execute: {
                        self?.tableView.reloadData()
                        if(self?.messageArray.count ?? 0>0){
                            let indexPath = IndexPath(row: (self?.messageArray.count ?? 0)-1, section: 0)
                            self?.tableView.scrollToRow(at: indexPath, at: UITableView.ScrollPosition.bottom, animated: true)  //scroll to button of tableView automatically when open the chat
                        }
                    })
                }
            }
        })
    }
    
    //the function test whether the new message is empty or only have whitespace. If new message is blank, this message cannot be sent
    func isBlank(_ string: String) -> Bool {
        for character in string {
            if !character.isWhitespace {
                return false
            }
        }
        return true
    }
    
    //send message and write in firebase
    //when user send a message, he update node in message database and messageUser database.
    //message database stores message information that will be used in this ViewController, like fromId, toId, text and timestamp
    //messageUser database will be used in chatBox ViewController. this part of database is about recently contacts
    @IBAction func sendMessage() {
        if let text =  messageTextField.text{
            if(isBlank(text)){                      //if text is blank, show alert instead of sending
                let errorMessage = UIAlertController(title: "error", message: "message cannot be empty", preferredStyle: .alert)
                let close = UIAlertAction(title: "close", style: .cancel, handler: nil)
                errorMessage.addAction(close)
                self.present(errorMessage,animated: true,completion: nil)
            }else{
                //if text is not empty, write message into firebase
                let ref = Database.database().reference().child("messages")
                let childRef = ref.childByAutoId()
                let timestamp:NSNumber = NSNumber(value: NSDate().timeIntervalSince1970)
                let values=["text":text,"fromId":fromId,"toId":toId,"timestamp":timestamp] as [String : Any]
                childRef.updateChildValues(values)
                messageTextField.text=""
            }
        }
    }
    
    //back button. If user open the chat in detailVC, back to detailVC. If user open a chat in chatBox, back to chat box
    @IBAction func back() {
        
        //back to chatBox
        if(self.signal == 1){
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let vc = storyboard.instantiateViewController(identifier: "MenuInitView")
            let navControllerVC = vc as! UITabBarController
            navControllerVC.modalPresentationStyle = .fullScreen
            self.present(navControllerVC,animated: true, completion: nil)
            navControllerVC.selectedIndex = 1
        }
        //back to detailVC
        else{
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
    
    //use two reusableCells. one show message sent and one show message receive.
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let message = messageArray[indexPath.row]
        if(message.fromId == toId){
            guard let sendCell = tableView.dequeueReusableCell(withIdentifier: "sendCell") as? SendTableViewCell else{
                return UITableViewCell()
            }
            if let text = message.text{
                sendCell.messageLabel.text=text+"  "
                sendCell.messageLabel.numberOfLines=0   //label can show multible lines of message
                sendCell.messageLabel.sizeToFit()       //let label fit message cell
                sendCell.messageLabel.clipsToBounds=true
                sendCell.messageLabel.layer.cornerRadius=10
                sendCell.messageLabel.widthAnchor.constraint(lessThanOrEqualToConstant: 180).isActive = true //the width of label cannot be too large
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
    
}
