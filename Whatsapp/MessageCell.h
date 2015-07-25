//
//  MessageCell.h
//  Whatsapp
//
//  Created by Rafael Castro on 7/23/15.
//  Copyright (c) 2015 HummingBird. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Message.h"

@interface MessageCell : UITableViewCell

//Store message
@property (strong, nonatomic) Message *message;

//Estimate BubbleCell Height
-(CGFloat)height;
-(void)updateMessageStatus;

@end
