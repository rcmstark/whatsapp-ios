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
-(void)storeMessage:(Message *)message forChat:(Chat *)chat
{
    [self storeMessages:@[message] forChat:chat];
}
-(void)storeMessages:(NSArray *)messages forChat:(Chat *)chat
{
    NSMutableArray *array = (NSMutableArray *)[self queryMessagesForChat:chat];
    if (array)
    {
        [array addObjectsFromArray:messages];
    }
    else
    {
        array = [[NSMutableArray alloc] initWithArray:messages];
    }
    [self.mapChatToMessages setValue:array forKey:chat.receiver_id];
}
-(NSArray *)queryMessagesForChat:(Chat *)chat
{
    return [self.mapChatToMessages valueForKey:chat.receiver_id];
}
-(void)updateMessage:(Message *)message forChat:(Chat *)chat
{
    
}

@end
