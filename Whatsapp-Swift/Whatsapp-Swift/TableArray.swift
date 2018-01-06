//
//  MessageArray.swift
//  Whatsapp
//
//  Created by Rafael Castro on 6/18/15. / Swift Version by Breno Oliveira on 02/18/16.
//  Copyright (c) 2015 HummingBird. All rights reserved.
//

import UIKit

class TableArray {
    
    var mapTitleToMessages:[String:[Message]] = [String:[Message]]()
    var orderedTitles:[String] = [String]()
    var numberOfSections = 0
    var numberOfMessages = 0
    var formatter:NSDateFormatter!
    
    init() {
        self.formatter = NSDateFormatter()
        self.formatter.timeStyle = .NoStyle
        self.formatter.dateStyle = .ShortStyle
        self.formatter.doesRelativeDateFormatting = false
    }

    func addObject(message:Message) {
        return self.addMessage(message)
    }
    
    func addObjectsFromArray(messages:[Message]) {
        for message in messages {
            self.addMessage(message)
        }
    }
    func removeObject(message:Message) {
        self.removeMessage(message)
    }
    func removeObjectsInArray(messages:[Message]) {
        for message in messages {
            self.removeMessage(message)
        }
    }
    func removeAllObjects() {
        self.mapTitleToMessages.removeAll()
        self.orderedTitles.removeAll()
    }

    func numberOfMessagesInSection(section:Int) -> Int {
        if self.orderedTitles.count == 0 {
            return 0
        }
        let key = self.orderedTitles[section]
        let array = self.mapTitleToMessages[key]
            
        return array!.count
    }
    
    func titleForSection(section:Int) -> String {
        let formatter = self.formatter.copy() as! NSDateFormatter
        let key = self.orderedTitles[section]
        let date = formatter.dateFromString(key)
        
        formatter.doesRelativeDateFormatting = true
        return formatter.stringFromDate(date!)
    }
    
    func objectAtIndexPath(indexPath:NSIndexPath) -> Message {
        let key = self.orderedTitles[indexPath.section]
        let array = self.mapTitleToMessages[key]
        
        return array![indexPath.row]
    }
    
    func lastObject() -> Message {
        let indexPath = self.indexPathForLastMessage()
        
        return self.objectAtIndexPath(indexPath)
    }
    
    func indexPathForLastMessage() -> NSIndexPath {
        let lastSection = self.numberOfSections-1
        let numberOfMessages = self.numberOfMessagesInSection(lastSection)
        
        return NSIndexPath(forRow:numberOfMessages-1, inSection:lastSection)
    }
    
    func indexPathForMessage(message:Message) -> NSIndexPath {
        let key = self.keyForMessage(message)
        let section = self.orderedTitles.indexOf(key)
        let row = self.mapTitleToMessages[key]!.indexOf({ (el) -> Bool in
            return el == message
        })
        
        return NSIndexPath(forRow:row!, inSection:section!)
    }

    // MARK - Helpers

    func addMessage(message:Message) {
        let key = self.keyForMessage(message)
        var array = self.mapTitleToMessages[key]
        
        if array == nil {
            self.numberOfSections += 1;
            array = [Message]()
        }
        
        array?.append(message)
        
        
        let sortedArray = array?.sort({ (m1, m2) -> Bool in
           return m1.date == m2.date
        })
        
        self.mapTitleToMessages[key] = sortedArray
        self.cacheTitles()

        self.numberOfMessages += 1
    }
    func removeMessage(message:Message) {
        let key = self.keyForMessage(message)
        var array = self.mapTitleToMessages[key]
        if array != nil {
            
            for (index, msg) in array!.enumerate() {
                if msg == message {
                    array!.removeAtIndex(index)
                    return
                }
            }
            
            if array!.count == 0 {
                self.numberOfSections -= 1
                self.mapTitleToMessages.removeValueForKey(key)
                self.cacheTitles()
            }
            else {
                self.mapTitleToMessages[key] = array
            }
            
            self.numberOfMessages -= 1
        }
    }
    
    func cacheTitles() {
        let array = self.mapTitleToMessages.keys
        
        
        let orderedArray = array.sort { (dateString1, dateString2) -> Bool in
            let d1 = self.formatter.dateFromString(dateString1)
            let d2 = self.formatter.dateFromString(dateString2)
            
            return d1 == d2
        }
        
        self.orderedTitles = orderedArray
    }
    
    func keyForMessage(message:Message) -> String {
        return self.formatter.stringFromDate(message.date)
    }
}