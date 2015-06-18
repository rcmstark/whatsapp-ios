//
//  MessageArray.m
//  Whatsapp
//
//  Created by Rafael Castro on 6/18/15.
//  Copyright (c) 2015 HummingBird. All rights reserved.
//

#import "MessageArray.h"

@interface MessageArray ()
@property (strong, nonatomic) NSMutableDictionary *dictionary;
@property (strong, nonatomic) NSArray *orderedKeys;
@end

@implementation MessageArray

-(id)init
{
    self = [super init];
    if (self)
    {
        self.dictionary = [[NSMutableDictionary alloc] init];
    }
    return self;
}
-(void)addMessage:(Message *)message
{
    return [self addMessage:message refreshCahe:YES];
}
-(void)addMessages:(NSArray *)messages
{
    for (Message *message in messages)
    {
        [self addMessage:message refreshCahe:NO];
    }
    [self cacheKeys];
}
-(void)removeMessage:(Message *)message
{
    [self removeMessage:message refreshCache:YES];
}
-(void)removeMessages:(NSArray *)messages
{
    for (Message *message in messages)
    {
        [self removeMessage:message refreshCache:NO];
    }
    [self cacheKeys];
}
-(void)removeAllMessages
{
    [self.dictionary removeAllObjects];
    self.orderedKeys = nil;
}
-(NSInteger)numberOfSections
{
    return [self.dictionary allKeys].count;
}
-(NSInteger)numberOfMessagesInSection:(NSInteger)section
{
    NSString *key = [self orderedKeys][section];
    NSArray *array = [self.dictionary valueForKey:key];
    return array.count;
}
-(NSString *)titleForSection:(NSInteger)section
{
    NSDateFormatter *formatter = [self formatter];
    NSString *key = [self orderedKeys][section];
    NSDate *date = [formatter dateFromString:key];
    
    formatter.doesRelativeDateFormatting = YES;
    return [formatter stringFromDate:date];
}
-(Message *)messageAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *key = [self orderedKeys][indexPath.section];
    NSArray *array = [self.dictionary valueForKey:key];
    return array[indexPath.row];
}
#pragma mark - Helpers

-(void)addMessage:(Message *)message refreshCahe:(BOOL)refresh
{
    NSString *key = [self keyForMessage:message];
    NSMutableArray *array = [self.dictionary valueForKey:key];
    if (!array)
    {
        array = [[NSMutableArray alloc] init];
    }
    [array addObject:message];
    [array sortedArrayUsingComparator:^NSComparisonResult(Message *m1, Message *m2)
     {
         return [m1.sent compare: m2.sent];
     }];
    [self.dictionary setValue:array forKey:key];
    if (refresh)
        [self cacheKeys];
}
-(void)removeMessage:(Message *)message refreshCache:(BOOL)refresh
{
    NSString *key = [self keyForMessage:message];
    NSMutableArray *array = [self.dictionary valueForKey:key];
    if (array)
    {
        [array removeObject:message];
        [self.dictionary setValue:array forKey:key];
    }
    if (refresh)
        [self cacheKeys];
}
-(void)cacheKeys
{
    NSArray *array = [self.dictionary allKeys];
    NSArray *orderedArray = [array sortedArrayUsingComparator:^NSComparisonResult(NSString *dateString1, NSString *dateString2)
                             {
                                 NSDateFormatter *formatter = [self formatter];
                                 NSDate *d1 = [formatter dateFromString:dateString1];
                                 NSDate *d2 = [formatter dateFromString:dateString2];
                                 return [d1 compare: d2];;
                             }];
    
    self.orderedKeys  = [[NSArray alloc] initWithArray:orderedArray];
}
-(NSString *)keyForMessage:(Message *)message
{
    NSDateFormatter *df = [self formatter];
    return [df stringFromDate:message.sent];
}
-(NSDateFormatter *)formatter
{
    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    df.timeStyle = NSDateFormatterNoStyle;
    df.dateStyle = NSDateFormatterShortStyle;
    df.doesRelativeDateFormatting = NO;
    return df;
}


@end
