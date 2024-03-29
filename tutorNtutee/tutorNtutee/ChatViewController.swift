//
//  ChatViewController.swift
//  tutorNtutee
//
//  Created by Junjie Han on 11/18/19.
//  Copyright © 2019 Alessandro Liu. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase
import FirebaseStorage

//this view is show information of recent contact of user,like icon, name and last message. And user can open the chat by tapping cells
class ChatViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {
    
    @IBOutlet weak var tableView: UITableView!
    var userId:String?
    var messageUserArray:[MessageUser]=[]  //array of contacts
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tabBarController?.tabBar.isTranslucent = false
        if let user = Auth.auth().currentUser{
            self.userId = user.uid
        }
        getMessageUser()
        self.tableView.delegate=self
        self.tableView.dataSource=self
        
    }
    
    //get recently contacts information from firebase
    func getMessageUser(){
        if let userId = self.userId{
            let messageRef = Database.database().reference().child("messageUser").child(userId)
            messageRef.observe(.childAdded, with: { [weak self] snapshot in
                if let dictionary = snapshot.value as? [String: Any]{
                    let messageUser = MessageUser(dictionary: dictionary)
                    messageUser.friendId = snapshot.key
                    self?.messageUserArray.append(messageUser)
                    self?.messageUserArray.sort(by: {$0.timestamp?.compare($1.timestamp ?? 0) == .orderedDescending}) //sort contacts array by timestamp. newest contact will be on the top
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
        
        //load icon image of contacts
        let imageName = (messageUser.friendId ?? "error")+".png"
        //let imageName = "\(messageUser.friendId).png"
        cell.icon.image = UIImage(named: "default.png")
        print(messageUser.friendId)
        let imageRef = Storage.storage().reference().child(imageName)
        imageRef.getData(maxSize: 20*1024*1024){ response, error in
            if let err = error{
                return
            }
            if let data = response {
                print(".............")
                print("success")
                cell.icon.image = UIImage(data: data)
            }else{
                print(".............")
                print("fail")
                //cell.icon.image = UIImage(named: "default.png")
            }
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
    //open the chat by tapping tableView cell
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(identifier: "ChatToSomeoneVC")
        let chatToSomeoneVC = vc as! ChatToSomeoneViewController
        chatToSomeoneVC.modalPresentationStyle = .fullScreen
        chatToSomeoneVC.toId = self.messageUserArray[indexPath.row].friendId ?? "error"
        chatToSomeoneVC.signal = 1
        self.present(chatToSomeoneVC,animated: true,completion: nil)
    }
    
}

