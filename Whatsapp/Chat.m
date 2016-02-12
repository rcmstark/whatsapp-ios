//
//  Chat.m
//  Whatsapp
//
//  Created by Rafael Castro on 7/24/15.
//  Copyright (c) 2015 HummingBird. All rights reserved.
//

#import "Chat.h"
#import "LocalStorage.h"

@implementation Chat

-(NSString *)identifier
{
    return _contact.identifier;
}
-(void)setLast_message:(Message *)last_message
{
    if (!_last_message)
    {
        _last_message = last_message;
    }
    else
    {
        if([_last_message.date earlierDate:last_message.date] == _last_message.date)
            _last_message = last_message;
    }
}
-(void)save
{
    [LocalStorage storeChat:self];
}

@end
