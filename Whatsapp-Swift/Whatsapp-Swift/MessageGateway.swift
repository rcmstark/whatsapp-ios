//
//  MessageGateway.swift
//  Whatsapp
//
//  Created by Rafael Castro on 7/4/15. / Swift Version by Breno Oliveira on 02/18/16.
//  Copyright (c) 2015 HummingBird. All rights reserved.
//

protocol MessageGatewayDelegate:NSObjectProtocol {
    func gatewayDidUpdateStatusForMessage(message:Message)
    func gatewayDidReceiveMessages(array:[Message])
}


class MessageGateway:NSObject {
    var delegate:MessageGatewayDelegate!
    var chat:Chat!
    var messagesToSend:NSMutableArray = NSMutableArray()

    func loadOldMessages() {
        let array = LocalStorage.sharedInstance.queryMessagesForChatId(self.chat.identifier)
        if array == nil {
            return
        }

        self.delegate?.gatewayDidReceiveMessages(array!)
 
        let unreadMessages = self.queryUnreadMessagesInArray(array!)
        self.updateStatusToReadInArray(unreadMessages)
    }
    
    func updateStatusToReadInArray(unreadMessages:[Message]) {
        var readIds = [String]()
        for message in unreadMessages {
            message.status = .Read
            readIds.append(message.identifier)
        }
        self.chat.numberOfUnreadMessages = 0
        self.sendReadStatusToMessages(readIds)
    }
    
    func queryUnreadMessagesInArray(array:[Message]) -> [Message] {
        return array.filter({(message:Message) -> Bool in
            return message.status == .Received
        })
    }
    
    func news() {
        
    }
    func dismiss() {
        self.delegate = nil
    }

    func fakeMessageUpdate(message:Message) {
        self.performSelector("updateMessageStatus:", withObject:message, afterDelay:2)
    }
    
    func updateMessageStatus(message:Message) {
        
        switch message.status {
        case .Sending:
            message.status = .Failed
        case .Failed:
            message.status = .Sent
        case .Sent:
            message.status = .Received
        case .Received:
            message.status = .Read
        default: break
        }
        
        if self.delegate != nil && self.delegate.respondsToSelector("gatewayDidUpdateStatusForMessage:") {
            self.delegate!.gatewayDidUpdateStatusForMessage(message)
        }
        
        //
        // Remove this when connect to your server
        // fake update message
        //
        if message.status != .Read {
            self.fakeMessageUpdate(message)
        }
    }

    // MARK - Exchange data with API

    func sendMessage(message:Message) {
        //
        // Add here your code to send message to your server
        // When you receive the response, you should update message status
        // Now I'm just faking update message
        //
        LocalStorage.sharedInstance.storeMessage(message)
        self.fakeMessageUpdate(message)
        //TODO
    }
    func sendReadStatusToMessages(messageIds:[String]) {
        if messageIds.count == 0 {
            return
        }
        //TODO
    }
    func sendReceivedStatusToMessages(messageIds:[String]) {
        if messageIds.count == 0 {
            return
        }
        //TODO
    }
    
    static let sharedInstance = MessageGateway()
    private override init() {}
}