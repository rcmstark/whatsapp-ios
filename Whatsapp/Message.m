//
//  Message.m
//  Whatsapp
//
//  Created by Rafael Castro on 6/16/15.
//  Copyright (c) 2015 HummingBird. All rights reserved.
//

#import "Message.h"

@implementation Message

-(id)init
{
    self = [super init];
    if (self)
    {
        self.sender = MessageSenderMyself;
        self.status = MessageStatusSending;
        self.text = @"";
    }
    return self;
}

@end
