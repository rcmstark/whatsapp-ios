//
//  LocalStorage.h
//  Whatsapp
//
//  Created by Rafael Castro on 7/24/15.
//  Copyright (c) 2015 HummingBird. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Message.h"
#import "Chat.h"

// This class is responsable to store messages
// For now this store in memory only
//
@interface LocalStorage : NSObject
+(id)sharedInstance;
-(void)storeMessage:(Message *)message forChat:(Chat *)chat;
-(void)storeMessages:(NSArray *)messages forChat:(Chat *)chat;
-(void)updateMessage:(Message *)message forChat:(Chat *)chat;
-(NSArray *)queryMessagesForChat:(Chat *)chat;
@end
