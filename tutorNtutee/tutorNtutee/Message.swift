//
//  Message.swift
//  tutorNtutee
//
//  Created by Junjie Han on 11/22/19.
//  Copyright © 2019 Alessandro Liu. All rights reserved.
//

import UIKit

//this class is about message informations. including text, fromId,toId and timestamp
class Message: NSObject {
    var text:String?
    var fromId:String?
    var toId:String?
    var timestamp: NSNumber?
    
    init(dictionary: [String: Any]){
        self.fromId = dictionary["fromId"] as? String
        self.toId = dictionary["toId"] as? String
        self.text = dictionary["text"] as? String
        self.timestamp = dictionary["timestamp"] as? NSNumber
    }
}
