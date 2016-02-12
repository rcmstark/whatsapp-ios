//
//  ChatListCell.h
//  Whatsapp
//
//  Created by Rafael Castro on 7/24/15.
//  Copyright (c) 2015 HummingBird. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Chat.h"

//
// This class is the custom cell in
// ChatController
//
@interface ChatCell : UITableViewCell
@property (strong, nonatomic) Chat *chat;
-(UIImageView *)imageView;
@end
