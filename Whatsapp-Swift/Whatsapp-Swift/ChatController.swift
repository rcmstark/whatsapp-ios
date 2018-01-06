//
//  ChatListController.swift
//  Whatsapp
//
//  Created by Rafael Castro on 7/24/15. / Swift Version by Breno Oliveira on 02/18/16.
//  Copyright (c) 2015 HummingBird. All rights reserved.
//

import UIKit

class ChatController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var  tableView:UITableView!
    var tableData:[Chat] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        self.setTableView()
        self.setTest()
        
        self.title = "Chats"
    }
    
    override func viewWillAppear(animated:Bool) {
        super.viewWillAppear(animated)
        self.tableView.reloadData()
    }
    
    func setTableView() {
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.tableFooterView = UIView(frame:CGRectMake(0, 0,self.view.frame.size.width, 10))
        self.tableView.backgroundColor = UIColor.clearColor()
    }
    
    func setTest() {
        let contact = Contact()
        contact.name = "Player 1"
        contact.identifier = "12345"
        
        let chat = Chat()
        chat.contact = contact
        
        let texts = ["Hello!",
                     "This project try to implement a chat UI similar to Whatsapp app.",
                     "Is it close enough?"]
        
        var lastMessage:Message!
        for text in texts {
            let message = Message()
            message.text = text
            message.sender = .Someone
            message.status = .Received
            message.chatId = chat.identifier
            
            LocalStorage.sharedInstance.storeMessage(message)
            lastMessage = message
        }
        
        chat.numberOfUnreadMessages = texts.count
        chat.lastMessage = lastMessage

        self.tableData.append(chat)
    }

    // MARK - TableViewDataSource

    func tableView(tableView:UITableView, numberOfRowsInSection section:NSInteger) -> Int
    {
        return self.tableData.count
    }
    
    func tableView(tableView:UITableView, cellForRowAtIndexPath indexPath:NSIndexPath) -> UITableViewCell
    {
        let cellIdentifier = "ChatListCell"
        let cell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier) as! ChatCell
        cell.chat = self.tableData[indexPath.row]
        
        return cell
    }

    // MARK - UITableViewDelegate

    func tableView(tableView:UITableView, didSelectRowAtIndexPath indexPath:NSIndexPath) {
        self.tableView.deselectRowAtIndexPath(indexPath, animated:true)
        
        let controller = self.storyboard!.instantiateViewControllerWithIdentifier("Message") as! MessageController
        controller.chat = self.tableData[indexPath.row]
        self.navigationController!.pushViewController(controller, animated:true)
    }
}
