//
//  Message.swift
//  Whatsapp
//
//  Created by Rafael Castro on 6/16/15. / Swift Version by Breno Oliveira on 02/18/16.
//  Copyright (c) 2015 HummingBird. All rights reserved.
//

import UIKit

enum MessageStatus {
    case Sending
    case Sent
    case Received
    case Read
    case Failed
}

enum MessageSender {
    case Myself
    case Someone
}

class Message:NSObject {
    var sender:MessageSender = .Myself
    var status:MessageStatus = .Sending
    var identifier:String = ""
    var chatId:String = ""
    var text:String = ""
    var date:NSDate = NSDate()
    var height:CGFloat = 44

    func messageFromDictionary(dictionary:NSDictionary) -> Message {
        let message = Message()
        message.text = dictionary["text"] as! String
        message.identifier = dictionary["messageId"] as! String
        message.status = dictionary["status"] as! MessageStatus
        
        let dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSSSS"
        
        //Date in UTC
        let inputTimeZone = NSTimeZone(abbreviation: "UTC")
        let inputDateFormatter = NSDateFormatter()
        inputDateFormatter.timeZone = inputTimeZone
        inputDateFormatter.dateFormat = dateFormat
        let date = inputDateFormatter.dateFromString(dictionary["sent"] as! String)
        
        //Convert time in UTC to Local TimeZone
        let outputTimeZone = NSTimeZone.localTimeZone()
        let outputDateFormatter = NSDateFormatter()
        outputDateFormatter.timeZone = outputTimeZone
        outputDateFormatter.dateFormat = dateFormat
        let outputString = outputDateFormatter.stringFromDate(date!)
        
        message.date = outputDateFormatter.dateFromString(outputString)!
        
        return message
    }
}