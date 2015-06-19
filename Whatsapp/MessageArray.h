//
//  MessageArray.h
//  Whatsapp
//
//  Created by Rafael Castro on 6/18/15.
//  Copyright (c) 2015 HummingBird. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Message.h"

@interface MessageArray : NSObject

-(void)addMessage:(Message *)message;
-(void)addMessages:(NSArray *)messages;
-(void)removeMessage:(Message *)message;
-(void)removeMessages:(NSArray *)messages;
-(void)removeAllMessages;
-(NSInteger)numberOfSections;
-(NSInteger)numberOfMessagesInSection:(NSInteger)section;
-(NSString *)titleForSection:(NSInteger)section;
-(Message *)messageAtIndexPath:(NSIndexPath *)indexPath;
-(NSIndexPath *)indexPathForLastMessage;

@end
