//
//  MessageUser.swift
//  tutorNtutee
//
//  Created by Junjie Han on 11/26/19.
//  Copyright © 2019 Alessandro Liu. All rights reserved.
//

import UIKit

class MessageUser: NSObject {
    var lastMessage:String?
    var friendId:String?
    var timestamp:NSNumber?
    
    override init() {
        self.lastMessage=""
        self.friendId=""
        self.timestamp=0
    }
    
    init(dictionary: [String: Any]){
        self.lastMessage = dictionary["lastMessage"] as? String
        self.timestamp = dictionary["timestamp"] as? NSNumber
    }
}
