//
//  ChatViewController.swift
//  tutorNtutee
//
//  Created by Junjie Han on 11/18/19.
//  Copyright © 2019 Alessandro Liu. All rights reserved.
//

import UIKit
import Firebase

class ChatViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {
    
    @IBOutlet weak var tableView: UITableView!
    var userId:String?
    var messageUserArray:[MessageUser]=[]

    override func viewDidLoad() {
        super.viewDidLoad()
        if let user = Auth.auth().currentUser{
            self.userId = user.uid
        }
    
        getMessageUser()
        
        messageUserArray.sort(by: {$0.timestamp?.compare($1.timestamp ?? 0) == .orderedDescending}) //most recent contacts should be show on the top
        
        self.tableView.delegate=self
        self.tableView.dataSource=self
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let chatToSomeoneVC : ChatToSomeoneViewController = segue.destination as! ChatToSomeoneViewController
        if let rowIndex = tableView.indexPathForSelectedRow?.row{
            chatToSomeoneVC.toId = self.messageUserArray[rowIndex].friendId ?? "error"
        }
    }
    
    func getMessageUser(){
        if let userId = self.userId{
            let messageRef = Database.database().reference().child("messageUser").child(userId)
            messageRef.observe(.childAdded, with: { [weak self] snapshot in
                if let dictionary = snapshot.value as? [String: Any]{
                    let messageUser = MessageUser(dictionary: dictionary)
                    messageUser.friendId = snapshot.key
                    self?.messageUserArray.append(messageUser)
                    self?.tableView.reloadData()
                }
            })
        }
    }
    
    //MARK: tableView statement
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messageUserArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let messageUser = messageUserArray[indexPath.row]
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "cell") as? ChatBoxTableViewCell else{
            return UITableViewCell()
        }
        cell.lastMessage.text = messageUser.lastMessage
        Database.database().reference().child("user").child(messageUser.friendId ?? "error").observeSingleEvent(of: .value, with: {(snapshot) in
            let value = snapshot.value as? NSDictionary
            cell.nameLabel.text = value?["username"] as? String
        })
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.performSegue(withIdentifier: "chatBoxVCToChatWithSomeoneVC", sender: self)
    }
    
}
    
