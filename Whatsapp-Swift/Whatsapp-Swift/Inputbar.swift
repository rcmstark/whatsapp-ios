//
//  Inputbar.swift
//  Whatsapp
//
//  Created by Rafael Castro on 7/11/15. / Swift Version by Breno Oliveira on 02/18/16.
//  Copyright (c) 2015 HummingBird. All rights reserved.
//

import UIKit

let RIGHT_BUTTON_SIZE:CGFloat = 60
let LEFT_BUTTON_SIZE:CGFloat = 45

@objc protocol InputbarDelegate:NSObjectProtocol {
    func inputbarDidPressRightButton(inputbar:Inputbar)
    func inputbarDidPressLeftButton(inputbar:Inputbar)

    optional func inputbarDidChangeHeight(newHeight:CGFloat)
    optional func inputbarDidBecomeFirstResponder(inputbar:Inputbar)
}

class Inputbar: UIToolbar, HPGrowingTextViewDelegate {

    var inputDelegate:InputbarDelegate!
    
    var textView:HPGrowingTextView!
    var rightButton:UIButton!
    var leftButton:UIButton!
    
    var placeholder:String! {
        didSet {
            self.textView.placeholder = self.placeholder
        }
    }
    var leftButtonImage:UIImage! {
        didSet {
            self.leftButton?.setImage(self.leftButtonImage, forState:.Normal)
        }
    }
    var rightButtonTextColor:UIColor! {
        didSet {
            self.rightButton?.setTitleColor(self.rightButtonTextColor, forState:.Normal)
        }
    }
    var rightButtonText:String! {
        didSet {
            self.rightButton?.setTitle(self.rightButtonText, forState:.Normal)
        }
    }
    
    
    var text:String {
        return self.textView.text
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.addContent()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        self.addContent()
    }
    
    func addContent() {
        self.addTextView()
        self.addRightButton()
        self.addLeftButton()
        
        self.autoresizingMask = [.FlexibleWidth, .FlexibleTopMargin]
    }
    
    func addTextView() {
        let size = self.frame.size
        self.textView = HPGrowingTextView(frame:CGRectMake(LEFT_BUTTON_SIZE,
                                                           5,
                                                           size.width - LEFT_BUTTON_SIZE - RIGHT_BUTTON_SIZE,
                                                           size.height))
        self.textView.isScrollable = false
        self.textView.contentInset = UIEdgeInsetsMake(0, 5, 0, 5)
        
        self.textView.minNumberOfLines = 1
        self.textView.maxNumberOfLines = 6
        // you can also set the maximum height in points with maxHeight
        // self.textView.maxHeight = 200;
        self.textView.returnKeyType = .Go
        self.textView.font = UIFont.systemFontOfSize(15)
        self.textView.delegate = self
        self.textView.internalTextView.scrollIndicatorInsets = UIEdgeInsetsMake(5, 0, 5, 0)
        self.textView.backgroundColor = UIColor.whiteColor()
        self.textView.placeholder = self.placeholder
        
        //self.textView.autocapitalizationType = .Sentences
        self.textView.keyboardType = .Default
        self.textView.returnKeyType = .Default
        self.textView.enablesReturnKeyAutomatically = true
        //self.textView.scrollIndicatorInsets = UIEdgeInsetsMake(0, -1, 0, 1)
        //self.textView.textContainerInset = UIEdgeInsetsMake(8, 4, 8, 0)
        self.textView.layer.cornerRadius = 5
        self.textView.layer.borderWidth = 0.5
        self.textView.layer.borderColor =  UIColor(red:200/255 ,green:200/255, blue:205/255, alpha:1).CGColor
        
        self.textView.autoresizingMask = .FlexibleWidth;
        
        // view hierachy
        self.addSubview(self.textView)
    }
    
    func addRightButton() {
        let size = self.frame.size
        
        self.rightButton = UIButton()
        self.rightButton.frame = CGRectMake(size.width - RIGHT_BUTTON_SIZE, 0, RIGHT_BUTTON_SIZE, size.height)
        self.rightButton.autoresizingMask = [.FlexibleTopMargin, .FlexibleLeftMargin]
        self.rightButton.setTitleColor(UIColor.blueColor(), forState:.Normal)
        self.rightButton.setTitleColor(UIColor.lightGrayColor(), forState:.Selected)
        self.rightButton.setTitle("Done", forState:.Normal)
        self.rightButton.titleLabel!.font = UIFont(name:"Helvetica", size:15)
        
        self.rightButton.addTarget(self, action:"didPressRightButton:", forControlEvents:.TouchUpInside)
        
        self.addSubview(self.rightButton)
        
        self.rightButton.selected = true
    }
    
    func addLeftButton() {
        let size = self.frame.size
        
        self.leftButton = UIButton()
        self.leftButton.frame = CGRectMake(0, 0, LEFT_BUTTON_SIZE, size.height)
        self.leftButton.autoresizingMask = [.FlexibleTopMargin, .FlexibleRightMargin]
        self.leftButton.setImage(self.leftButtonImage, forState:.Normal)
        
        self.leftButton.addTarget(self, action:"didPressLeftButton:", forControlEvents:.TouchUpInside)
        
        self.addSubview(self.leftButton)
    }
    
    func inputResignFirstResponder() {
        self.textView.resignFirstResponder()
    }


    // MARK - Delegate

    func didPressRightButton(sender:UIButton) {
        if self.rightButton.selected {
            return
        }
        
        self.inputDelegate?.inputbarDidPressRightButton(self)
        self.textView.text = ""
    }
    
    func didPressLeftButton(sender:UIButton) {
        self.inputDelegate?.inputbarDidPressLeftButton(self)
    }

    // MARK - HPGrowingTextView

    func growingTextView(growingTextView: HPGrowingTextView!, willChangeHeight height: Float) {
        let diff = growingTextView.frame.size.height - CGFloat(height)
        
        var r = self.frame
        r.size.height -= diff
        r.origin.y += diff
        self.frame = r
        
        if self.inputDelegate != nil && self.inputDelegate!.respondsToSelector("inputbarDidChangeHeight:") {
            self.inputDelegate.inputbarDidChangeHeight!(self.frame.size.height)
        }
    }
    
    func growingTextViewDidBeginEditing(growingTextView: HPGrowingTextView!) {
        if self.inputDelegate != nil && self.inputDelegate!.respondsToSelector("inputbarDidBecomeFirstResponder:") {
            self.inputDelegate.inputbarDidBecomeFirstResponder!(self)
        }
    }

    
    func growingTextViewDidChange(growingTextView: HPGrowingTextView!) {
        let text = growingTextView.text.stringByReplacingOccurrencesOfString(" ", withString:"")
        if text.characters.count == 0 {
            self.rightButton.selected = true
        }
        else {
            self.rightButton.selected = false
        }
    }
}