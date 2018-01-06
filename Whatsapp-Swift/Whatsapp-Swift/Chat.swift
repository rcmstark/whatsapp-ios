//
//  Chat.swift
//  Whatsapp
//
//  Created by Rafael Castro on 7/24/15. / Swift Version by Breno Oliveira on 02/18/16.
//  Copyright (c) 2015 HummingBird. All rights reserved.
//

import UIKit
import Foundation

class Chat {
    var contact:Contact!
    var numberOfUnreadMessages:Int = 0
    
    var lastMessage:Message! {
        willSet (val) {
            if self.lastMessage != nil {
                if self.lastMessage.date.earlierDate(val.date) != self.lastMessage.date {
                    self.lastMessage = val
                }
            }
        }
    }

    var identifier:String {
        get {
            return self.contact.identifier
        }
    }

    func save() {
        LocalStorage.sharedInstance.storeChat(self)
    }
}