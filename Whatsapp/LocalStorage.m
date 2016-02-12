//
//  LocalStorage.m
//  Whatsapp
//
//  Created by Rafael Castro on 7/24/15.
//  Copyright (c) 2015 HummingBird. All rights reserved.
//

#import "LocalStorage.h"

@interface LocalStorage ()
@property (strong, nonatomic) NSMutableDictionary *mapChatToMessages;
@end


@implementation LocalStorage

+(id)sharedInstance
{
    static LocalStorage *sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[self alloc] init];
    });
    return sharedInstance;
}
-(id)init
{
    self = [super init];
    if (self)
    {
        self.mapChatToMessages = [[NSMutableDictionary alloc] init];
    }
    return self;
}
-(void)storeMessage:(Message *)message
{
    [self storeMessages:@[message]];
}
-(void)storeMessages:(NSArray *)messages
{
    if (messages.count == 0) return;
    Message *message = messages[0];
    NSString *chat_id = message.chat_id;
    NSMutableArray *array = (NSMutableArray *)[self queryMessagesForChatID:chat_id];
    if (array)
    {
        [array addObjectsFromArray:messages];
    }
    else
    {
        array = [[NSMutableArray alloc] initWithArray:messages];
    }
    [self.mapChatToMessages setValue:array forKey:chat_id];
}
-(NSArray *)queryMessagesForChatID:(NSString *)chat_id
{
    return [self.mapChatToMessages valueForKey:chat_id];
}

+(void)storeChat:(Chat *)chat
{
    //TODO
}
+(void)storeChats:(NSArray *)chats
{
    //TODO
}
+(void)storeContact:(Contact *)contact
{
    //TODO
}
+(void)storeContacts:(NSArray *)contacts
{
    //TODO
}

@end
