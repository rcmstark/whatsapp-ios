//
//  MessageCell.h
//  Whatsapp
//
//  Created by Rafael Castro on 7/23/15.
//  Copyright (c) 2015 HummingBird. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Message.h"

//
// This class build bubble message cells
// for Income or Outgoing messages
//
@interface MessageCell : UITableViewCell

@property (strong, nonatomic) Message *message;
@property (strong, nonatomic) UIButton *resendButton;

-(void)updateMessageStatus;

//Estimate BubbleCell Height
-(CGFloat)height;

@end
