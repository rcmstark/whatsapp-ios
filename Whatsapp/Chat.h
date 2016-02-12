//
//  Chat.h
//  Whatsapp
//
//  Created by Rafael Castro on 7/24/15.
//  Copyright (c) 2015 HummingBird. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Message.h"
#import "Contact.h"
//
// This class is responsable to store information
// displayed in ChatController
//

@interface Chat : NSObject
@property (strong, nonatomic) Message *last_message;
@property (strong, nonatomic) Contact *contact;
@property (assign, nonatomic) NSInteger numberOfUnreadMessages;
-(NSString *)identifier;
-(void)save;
@end
