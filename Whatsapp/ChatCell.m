//
//  ChatListCell.m
//  Whatsapp
//
//  Created by Rafael Castro on 7/24/15.
//  Copyright (c) 2015 HummingBird. All rights reserved.
//

#import "ChatCell.h"

@interface ChatCell()
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *messageLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UIImageView *picture;
@end



@implementation ChatCell

-(void)awakeFromNib
{
    self.picture.layer.cornerRadius = self.picture.frame.size.width/2;
    self.picture.layer.masksToBounds = YES;
    self.nameLabel.text = @"";
    self.messageLabel.text = @"";
    self.timeLabel.text = @"";
}
-(void)setChat:(Chat *)chat
{
    _chat = chat;
    self.nameLabel.text = chat.sender_name;
    self.messageLabel.text = chat.last_message.text;
    [self updateTimeLabelWithDate:chat.last_message.date];
}
-(void)updateTimeLabelWithDate:(NSDate *)date
{
    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    df.timeStyle = NSDateFormatterShortStyle;
    df.dateStyle = NSDateFormatterNoStyle;
    df.doesRelativeDateFormatting = NO;
    self.timeLabel.text = [df stringFromDate:date];
}

@end
