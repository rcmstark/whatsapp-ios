//
//  MessageArray.m
//  Whatsapp
//
//  Created by Rafael Castro on 6/18/15.
//  Copyright (c) 2015 HummingBird. All rights reserved.
//

#import "TableArray.h"

@interface TableArray ()
@property (strong, nonatomic) NSMutableDictionary *mapTitleToMessages;
@property (strong, nonatomic) NSArray *orderedTitles;
@property (assign, nonatomic) NSInteger numberOfSections;
@property (assign, nonatomic) NSInteger numberOfMessages;
@property (strong, nonatomic) NSDateFormatter *formatter;
@end

@implementation TableArray

-(id)init
{
    self = [super init];
    if (self)
    {
        self.orderedTitles = [[NSArray alloc] init];
        self.mapTitleToMessages = [[NSMutableDictionary alloc] init];
    }
    return self;
}
-(void)addObject:(Message *)message
{
    return [self addMessage:message];
}
-(void)addObjectsFromArray:(NSArray *)messages
{
    for (Message *message in messages)
    {
        [self addMessage:message];
    }
}
-(void)removeObject:(Message *)message
{
    [self removeMessage:message];
}
-(void)removeObjectsInArray:(NSArray *)messages
{
    for (Message *message in messages)
    {
        [self removeMessage:message];
    }
}
-(void)removeAllObjects
{
    [self.mapTitleToMessages removeAllObjects];
    self.orderedTitles = nil;
}
-(NSInteger)numberOfMessages
{
    return _numberOfMessages;
}
-(NSInteger)numberOfSections
{
    return _numberOfSections;
}
-(NSInteger)numberOfMessagesInSection:(NSInteger)section
{
    if (self.orderedTitles.count == 0) return 0;
    NSString *key = self.orderedTitles[section];
    NSArray *array = [self.mapTitleToMessages valueForKey:key];
    return array.count;
}
-(NSString *)titleForSection:(NSInteger)section
{
    NSDateFormatter *formatter = [self.formatter copy];
    NSString *key = self.orderedTitles[section];
    NSDate *date = [formatter dateFromString:key];
    
    formatter.doesRelativeDateFormatting = YES;
    return [formatter stringFromDate:date];
}
-(Message *)objectAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *key = self.orderedTitles[indexPath.section];
    NSArray *array = [self.mapTitleToMessages valueForKey:key];
    return array[indexPath.row];
}
-(Message *)lastObject
{
    NSIndexPath *indexPath = [self indexPathForLastMessage];
    return [self objectAtIndexPath:indexPath];
}
-(NSIndexPath *)indexPathForLastMessage
{
    NSInteger lastSection = _numberOfSections-1;
    NSInteger numberOfMessages = [self numberOfMessagesInSection:lastSection];
    return [NSIndexPath indexPathForRow:numberOfMessages-1 inSection:lastSection];
}
-(NSIndexPath *)indexPathForMessage:(Message *)message
{
    NSString *key = [self keyForMessage:message];
    NSInteger section = [self.orderedTitles indexOfObject:key];
    NSInteger row = [[self.mapTitleToMessages valueForKey:key] indexOfObject:message];
    return [NSIndexPath indexPathForRow:row inSection:section];
}

#pragma mark - Helpers

-(void)addMessage:(Message *)message
{
    NSString *key = [self keyForMessage:message];
    NSMutableArray *array = [self.mapTitleToMessages valueForKey:key];
    if (!array)
    {
        _numberOfSections += 1;
        array = [[NSMutableArray alloc] init];
    }
    
    [array addObject:message];
    NSArray *sortedArray = [array sortedArrayUsingComparator:^NSComparisonResult(Message *m1, Message *m2)
                            {
                                return [m1.date compare: m2.date];
                            }];
    NSMutableArray *result = [NSMutableArray arrayWithArray:sortedArray];
    [self.mapTitleToMessages setValue:result forKey:key];
    [self cacheTitles];
    
    _numberOfMessages += 1;
}
-(void)removeMessage:(Message *)message
{
    NSString *key = [self keyForMessage:message];
    NSMutableArray *array = [self.mapTitleToMessages valueForKey:key];
    if (array)
    {
        [array removeObject:message];
        if (array.count == 0)
        {
            _numberOfSections -= 1;
            [self.mapTitleToMessages removeObjectForKey:key];
            [self cacheTitles];
        }
        else
            [self.mapTitleToMessages setValue:array forKey:key];
        
        _numberOfMessages -= 1;
    }
}
-(void)cacheTitles
{
    NSArray *array = [self.mapTitleToMessages allKeys];
    NSArray *orderedArray = [array sortedArrayUsingComparator:^NSComparisonResult(NSString *dateString1, NSString *dateString2)
                             {
                                 NSDate *d1 = [self.formatter dateFromString:dateString1];
                                 NSDate *d2 = [self.formatter dateFromString:dateString2];
                                 return [d1 compare: d2];;
                             }];
    self.orderedTitles  = [[NSArray alloc] initWithArray:orderedArray];
}
-(NSString *)keyForMessage:(Message *)message
{
    return [self.formatter stringFromDate:message.date];
}
-(NSDateFormatter *)formatter
{
    if (!_formatter)
    {
        _formatter = [[NSDateFormatter alloc] init];
        _formatter.timeStyle = NSDateFormatterNoStyle;
        _formatter.dateStyle = NSDateFormatterShortStyle;
        _formatter.doesRelativeDateFormatting = NO;
        
    }
    return _formatter;
}


@end
