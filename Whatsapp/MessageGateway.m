//
//  MessageGateway.m
//  Whatsapp
//
//  Created by Rafael Castro on 7/4/15.
//  Copyright (c) 2015 HummingBird. All rights reserved.
//

#import "MessageGateway.h"
#import "LocalStorage.h"

@interface MessageGateway()
@property (strong, nonatomic) NSMutableArray *messages_to_send;
@end


@implementation MessageGateway

+(id)sharedInstance
{
    static MessageGateway *sharedInstance = nil;
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
        self.messages_to_send = [[NSMutableArray alloc] init];
    }
    return self;
}
-(void)loadOldMessages
{
    NSArray *array = [[LocalStorage sharedInstance] queryMessagesForChat:self.chat];
    if (self.delegate)
    {
        [self.delegate gatewayDidReceiveMessages:array];
    }
}
-(void)news
{
    
}
-(void)dismiss
{
    self.delegate = nil;
}
-(void)sendMessage:(Message *)message
{
    //
    // Add here your code to send message to your server
    // When you receive the response, you should update message status
    // Now I'm just faking update message
    //
    [[LocalStorage sharedInstance] storeMessage:message forChat:self.chat];
    [self fakeMessageUpdate:message];
}
-(void)fakeMessageUpdate:(Message *)message
{
    [self performSelector:@selector(updateMessageStatus:) withObject:message afterDelay:2.0];
}
-(void)updateMessageStatus:(Message *)message
{
    if (message.status == MessageStatusSending)
        message.status = MessageStatusSent;
    else if (message.status == MessageStatusSent)
        message.status = MessageStatusNotified;
    else if (message.status == MessageStatusNotified)
        message.status = MessageStatusRead;
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(gatewayDidUpdateStatusForMessage:)])
    {
        [self.delegate gatewayDidUpdateStatusForMessage:message];
    }
    
    //
    // Remove this when connect to your server
    // fake update message
    //
    if (message.status != MessageStatusRead)
        [self fakeMessageUpdate:message];
}

@end
