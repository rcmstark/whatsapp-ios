//
//  ChatListCell.m
//  Whatsapp
//
//  Created by Rafael Castro on 7/24/15.
//  Copyright (c) 2015 HummingBird. All rights reserved.
//

#import "ChatCell.h"
#import "LocalStorage.h"

@interface ChatCell()
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *messageLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UIImageView *picture;
@property (weak, nonatomic) IBOutlet UILabel *notificationLabel;
@end



@implementation ChatCell

-(void)awakeFromNib
{
    self.picture.layer.cornerRadius = self.picture.frame.size.width/2;
    self.picture.layer.masksToBounds = YES;
    self.notificationLabel.layer.cornerRadius = self.notificationLabel.frame.size.width/2;
    self.notificationLabel.layer.masksToBounds = YES;
    self.nameLabel.text = @"";
    self.messageLabel.text = @"";
    self.timeLabel.text = @"";
}
-(void)setChat:(Chat *)chat
{
    _chat = chat;
    self.nameLabel.text = chat.contact.name;
    self.messageLabel.text = chat.last_message.text;
    [self updateTimeLabelWithDate:chat.last_message.date];
    [self updateUnreadMessagesIcon:chat.numberOfUnreadMessages];
}
-(void)updateTimeLabelWithDate:(NSDate *)date
{
    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    df.timeStyle = NSDateFormatterShortStyle;
    df.dateStyle = NSDateFormatterNoStyle;
    df.doesRelativeDateFormatting = NO;
    self.timeLabel.text = [df stringFromDate:date];
}
-(void)updateUnreadMessagesIcon:(NSInteger)numberOfUnreadMessages
{
    self.notificationLabel.hidden = numberOfUnreadMessages == 0;
    self.notificationLabel.text = [NSString stringWithFormat:@"%ld", (long)numberOfUnreadMessages];
}
-(UIImageView *)imageView
{
    return _picture;
}

@end
