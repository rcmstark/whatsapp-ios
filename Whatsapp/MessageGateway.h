//
//  MessageGateway.h
//  Whatsapp
//
//  Created by Rafael Castro on 7/4/15.
//  Copyright (c) 2015 HummingBird. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Message.h"
#import "Chat.h"

@protocol MessageGatewayDelegate;

//
// this class is responsable to send message
// to server and notify status. It's also responsable
// to get messages in local storage.
//
@interface MessageGateway : NSObject
@property (assign, nonatomic) id<MessageGatewayDelegate> delegate;
@property (strong, nonatomic) Chat *chat;
+(id)sharedInstance;
-(void)loadOldMessages;
-(void)sendMessage:(Message *)message;
-(void)news;
-(void)dismiss;
@end


@protocol MessageGatewayDelegate <NSObject>
-(void)gatewayDidUpdateStatusForMessage:(Message *)message;
-(void)gatewayDidReceiveMessages:(NSArray *)array;
@end
