//
//  MessageArray.h
//  Whatsapp
//
//  Created by Rafael Castro on 6/18/15.
//  Copyright (c) 2015 HummingBird. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Message.h"

//
// This class teaches tableView how to interact with
// dictionaty. Basically it's mimics the array use in
// a tableView.
//
@interface TableArray : NSObject

-(void)addObject:(Message *)message;
-(void)addObjectsFromArray:(NSArray *)messages;
-(void)removeObject:(Message *)message;
-(void)removeObjectsInArray:(NSArray *)messages;
-(void)removeAllObjects;
-(NSInteger)numberOfMessages;
-(NSInteger)numberOfSections;
-(NSInteger)numberOfMessagesInSection:(NSInteger)section;
-(NSString *)titleForSection:(NSInteger)section;
-(Message *)objectAtIndexPath:(NSIndexPath *)indexPath;
-(Message *)lastObject;
-(NSIndexPath *)indexPathForLastMessage;
-(NSIndexPath *)indexPathForMessage:(Message *)message;

@end
