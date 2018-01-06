//
//  MessageController.swift
//  Whatsapp
//
//  Created by Rafael Castro on 7/23/15. / Swift Version by Breno Oliveira on 02/18/16.
//  Copyright (c) 2015 HummingBird. All rights reserved.
//

class MessageController:UIViewController, InputbarDelegate, MessageGatewayDelegate, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var tableView:UITableView!
    @IBOutlet weak var inputbar:Inputbar!
    
    var chat:Chat! {
        didSet {
             self.title = self.chat.contact.name
        }
    }
    
    private var tableArray:TableArray!
    private var gateway:MessageGateway!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setInputbar()
        self.setTableView()
        self.setGateway()
    }
    
    override func viewDidAppear(animated:Bool) {
        super.viewDidAppear(animated)

        self.view.keyboardTriggerOffset = inputbar.frame.size.height
        self.view.addKeyboardPanningWithActionHandler() {[unowned self](keyboardFrameInView:CGRect, opening:Bool, closing:Bool) in
            /*
             self.view.removeKeyboardControl()
             */
            
            var toolBarFrame = self.inputbar.frame
            toolBarFrame.origin.y = keyboardFrameInView.origin.y - toolBarFrame.size.height
            self.inputbar.frame = toolBarFrame
            
            var tableViewFrame = self.tableView.frame
            tableViewFrame.size.height = toolBarFrame.origin.y - 64
            self.tableView.frame = tableViewFrame
            
            self.tableViewScrollToBottomAnimated(false)
        }
    }
    
    override func viewDidDisappear(animated:Bool) {
        super.viewDidDisappear(animated)
        self.view.endEditing(true)
        self.view.removeKeyboardControl()
        self.gateway.dismiss()
    }
    
    override func viewWillDisappear(animated:Bool) {
        self.chat.lastMessage = self.tableArray!.lastObject()
    }

    // MARK -

    func setInputbar() {
        self.inputbar.placeholder = nil
        self.inputbar.inputDelegate = self
        self.inputbar.leftButtonImage = UIImage(named:"share")
        self.inputbar.rightButtonText = "Send"
        self.inputbar.rightButtonTextColor = UIColor(red:0, green:124/255, blue:1, alpha:1)
    }
    
    func setTableView() {
        self.tableArray = TableArray()
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.tableFooterView = UIView(frame:CGRectMake(0, 0, self.view.frame.size.width, 10))
        self.tableView.separatorStyle = .None
        self.tableView.backgroundColor = UIColor.clearColor()
        
        self.tableView.registerClass(MessageCell.self, forCellReuseIdentifier:"MessageCell")
    }
    
    func setGateway() {
        self.gateway = MessageGateway.sharedInstance
        self.gateway.delegate = self
        self.gateway.chat = self.chat
        self.gateway.loadOldMessages()
    }

    // MARK - Actions

    @IBAction func userDidTapScreen(sender:AnyObject) {
        self.inputbar.inputResignFirstResponder()
    }

    // MARK - TableViewDataSource
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return self.tableArray.numberOfSections
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.tableArray.numberOfMessagesInSection(section)
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("MessageCell") as! MessageCell
        cell.message = self.tableArray.objectAtIndexPath(indexPath)
        return cell;
    }

    // MARK - UITableViewDelegate
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        let message = self.tableArray.objectAtIndexPath(indexPath)
        return message.height
    }
    
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 40
    }
    
    func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return self.tableArray.titleForSection(section)
    }
    
    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let frame = CGRectMake(0, 0, tableView.frame.size.width, 40)
        
        let view = UIView(frame:frame)
        view.backgroundColor = UIColor.clearColor()
        view.autoresizingMask = .FlexibleWidth
        
        let label = UILabel()
        label.text = self.tableView(tableView, titleForHeaderInSection: section)
        label.textAlignment = .Center
        label.font = UIFont(name:"Helvetica", size:20)
        label.sizeToFit()
        label.center = view.center
        label.font = UIFont(name:"Helvetica", size:13)
        label.backgroundColor = UIColor(red:207/255, green:220/255, blue:252/255, alpha:1)
        label.layer.cornerRadius = 10
        label.layer.masksToBounds = true
        label.autoresizingMask = .None
        view.addSubview(label)
        
        return view
    }

    func tableViewScrollToBottomAnimated(animated:Bool) {
        let numberOfSections = self.tableArray.numberOfSections
        let numberOfRows = self.tableArray.numberOfMessagesInSection(numberOfSections-1)
        if numberOfRows > 0 {
            self.tableView.scrollToRowAtIndexPath(self.tableArray.indexPathForLastMessage(), atScrollPosition:.Bottom, animated:animated)
        }
    }

    // MARK - InputbarDelegate

    func inputbarDidPressRightButton(inputbar:Inputbar) {
        let message = Message()
        message.text = inputbar.text
        message.date = NSDate()
        message.chatId = self.chat.identifier
        
        //Store Message in memory
        self.tableArray.addObject(message)
        
        //Insert Message in UI
        let indexPath = self.tableArray.indexPathForMessage(message)
        self.tableView.beginUpdates()
        if self.tableArray.numberOfMessagesInSection(indexPath.section) == 1 {
            self.tableView.insertSections(NSIndexSet(index:indexPath.section), withRowAnimation:.None)
        }
        self.tableView.insertRowsAtIndexPaths([indexPath], withRowAnimation:.Bottom)
        self.tableView.endUpdates()
        
        self.tableView.scrollToRowAtIndexPath(self.tableArray.indexPathForLastMessage(), atScrollPosition:.Bottom, animated:true)
        
        //Send message to server
        self.gateway.sendMessage(message)
    }
    func inputbarDidPressLeftButton(inputbar:Inputbar) {
        let alertView = UIAlertView(title: "Left Button Pressed", message: nil, delegate: nil, cancelButtonTitle: "OK")
        alertView.show()
    }
    func inputbarDidChangeHeight(newHeight:CGFloat) {
        //Update DAKeyboardControl
        self.view.keyboardTriggerOffset = newHeight
    }

    // MARK - MessageGatewayDelegate

    func gatewayDidUpdateStatusForMessage(message:Message) {
        let indexPath = self.tableArray.indexPathForMessage(message)
        let cell = self.tableView.cellForRowAtIndexPath(indexPath) as! MessageCell
        cell.updateMessageStatus()
    }
    
    func gatewayDidReceiveMessages(array:[Message]) {
        self.tableArray.addObjectsFromArray(array)
        self.tableView.reloadData()
    }
}