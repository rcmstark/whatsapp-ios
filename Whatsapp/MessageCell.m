//
//  MessageCell.m
//  Whatsapp
//
//  Created by Rafael Castro on 7/23/15.
//  Copyright (c) 2015 HummingBird. All rights reserved.
//

#import "MessageCell.h"


@interface MessageCell ()
@property (strong, nonatomic) UILabel *timeLabel;
@property (strong, nonatomic) UITextView *textView;
@property (strong, nonatomic) UIImageView *bubbleImage;
@property (strong, nonatomic) UIImageView *statusIcon;
@end


@implementation MessageCell

-(CGFloat)height
{
    return _bubbleImage.frame.size.height;
}
-(void)updateMessageStatus
{
    [self setStatusIcon];
    //Animate Transition
    _statusIcon.alpha = 0;
    [UIView animateWithDuration:.5 animations:^{
        _statusIcon.alpha = 1;
    }];
    [self setNeedsDisplay];
}

#pragma mark -

-(id)init
{
    self = [super init];
    if (self)
    {
        [self commonInit];
    }
    return self;
}
-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self)
    {
        [self commonInit];
    }
    return self;
}
-(void)layoutSubviews
{
    [self commonInit];
}
-(void)commonInit
{
    self.backgroundColor = [UIColor clearColor];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    self.contentView.backgroundColor = [UIColor clearColor];
}
-(void)prepareForReuse
{
    [self.contentView.subviews makeObjectsPerformSelector: @selector(removeFromSuperview)];
    _textView = nil;
    _bubbleImage = nil;
    _timeLabel = nil;
    _statusIcon = nil;
}
-(void)setMessage:(Message *)message
{
    _message = message;
    [self buildCell];
    
    message.heigh = self.height;
}
-(void)buildCell
{
    [self addTextView];
    [self setTextView];
    
    [self addTimeLabel];
    [self setTimeLabel];
    
    [self addBubble];
    [self setBubble];
    
    [self addStatusIcon];
    [self setStatusIcon];
}

#pragma mark - TextView

-(void)addTextView
{
    CGFloat max_witdh = 0.7*self.contentView.frame.size.width;
    _textView = [[UITextView alloc] initWithFrame:CGRectMake(0, 0, max_witdh, MAXFLOAT)];
    _textView.font = [UIFont fontWithName:@"Helvetica" size:17.0];
    _textView.backgroundColor = [UIColor clearColor];
    _textView.userInteractionEnabled = NO;
    [self.contentView addSubview:_textView];
}
-(void)setTextView
{
    _textView.text = _message.text;
    [_textView sizeToFit];
    
    CGFloat textView_x;
    CGFloat textView_y;
    CGFloat textView_w = _textView.frame.size.width;
    CGFloat textView_h = _textView.frame.size.height;
    UIViewAutoresizing autoresizing;
    
    if (_message.sender == MessageSenderMyself)
    {
        textView_x = self.contentView.frame.size.width - textView_w - 20;
        textView_y = -3;
        autoresizing = UIViewAutoresizingFlexibleLeftMargin;
        textView_x -= [self isSingleLineCase]?65.0:0.0;
    }
    else
    {
        textView_x = 20;
        textView_y = -3;
        autoresizing = UIViewAutoresizingFlexibleRightMargin;
    }
    
    _textView.autoresizingMask = autoresizing;
    _textView.frame = CGRectMake(textView_x, textView_y, textView_w, textView_h);
}

#pragma mark - TimeLabel

-(void)addTimeLabel
{
    _timeLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 52, 14)];
    _timeLabel.textColor = [UIColor lightGrayColor];
    _timeLabel.font = [UIFont fontWithName:@"Helvetica" size:12.0];
    _timeLabel.userInteractionEnabled = NO;
    _timeLabel.alpha = 0.7;
    _timeLabel.textAlignment = NSTextAlignmentRight;
    [self.contentView addSubview:_timeLabel];
}
-(void)setTimeLabel
{
    //Set Text to Label
    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    df.timeStyle = NSDateFormatterShortStyle;
    df.dateStyle = NSDateFormatterNoStyle;
    df.doesRelativeDateFormatting = YES;
    self.timeLabel.text = [df stringFromDate:_message.sent];
    
    //Set position
    CGFloat time_x;
    CGFloat time_y = _textView.frame.size.height - 10;
    
    if (_message.sender == MessageSenderMyself)
    {
        time_x = _textView.frame.origin.x + _textView.frame.size.width - _timeLabel.frame.size.width - 20;
    }
    else
    {
        time_x = MAX(_textView.frame.origin.x + _textView.frame.size.width - _timeLabel.frame.size.width,
                     _textView.frame.origin.x);
    }
    
    if ([self isSingleLineCase])
    {
        time_x = _textView.frame.origin.x + _textView.frame.size.width - 5;
        time_y -= 10;
    }
    
    _timeLabel.frame = CGRectMake(time_x,
                                  time_y,
                                  _timeLabel.frame.size.width,
                                  _timeLabel.frame.size.height);
    
    _timeLabel.autoresizingMask = _textView.autoresizingMask;
}
-(BOOL)isSingleLineCase
{
    CGFloat delta_x = _message.sender == MessageSenderMyself?65.0:44.0;
    
    CGFloat textView_height = _textView.frame.size.height;
    CGFloat textView_width = _textView.frame.size.width;
    CGFloat view_width = self.contentView.frame.size.width;
    
    //Single Line Case
    return (textView_height <= 45 && textView_width + delta_x <= 0.8*view_width)?YES:NO;
}

#pragma mark - Bubble

-(void)addBubble
{
    _bubbleImage = [[UIImageView alloc] init];
    _bubbleImage.userInteractionEnabled = YES;
    [self.contentView insertSubview:_bubbleImage belowSubview:_textView];
}
- (void)setBubble
{
    //Margins to Bubble
    CGFloat marginLeft = 5;
    CGFloat marginRight = 2;
    
    //Bubble positions
    CGFloat bubble_x;
    CGFloat bubble_y = 0;
    CGFloat bubble_width;
    CGFloat bubble_height = MIN(_textView.frame.size.height + 8,
                                _timeLabel.frame.origin.y + _timeLabel.frame.size.height + 6);
    
    if (_message.sender == MessageSenderMyself)
    {
        
        bubble_x = MIN(_textView.frame.origin.x -marginLeft,_timeLabel.frame.origin.x - 2*marginLeft);
        
        _bubbleImage.image = [[UIImage imageNamed:@"bubbleMine"]
                              stretchableImageWithLeftCapWidth:15 topCapHeight:14];
        
        
        bubble_width = self.contentView.frame.size.width - bubble_x - marginRight;
    }
    else
    {
        bubble_x = marginRight;
        
        _bubbleImage.image = [[UIImage imageNamed:@"bubbleSomeone"]
                              stretchableImageWithLeftCapWidth:21 topCapHeight:14];
        
        bubble_width = MAX(_textView.frame.origin.x + _textView.frame.size.width + marginLeft,
                           _timeLabel.frame.origin.x + _timeLabel.frame.size.width + 2*marginLeft);
    }
    
    _bubbleImage.frame = CGRectMake(bubble_x, bubble_y, bubble_width, bubble_height);
    _bubbleImage.autoresizingMask = _textView.autoresizingMask;
}

#pragma mark - StatusIcon

-(void)addStatusIcon
{
    CGRect time_frame = _timeLabel.frame;
    CGRect status_frame = CGRectMake(0, 0, 15, 14);
    status_frame.origin.x = time_frame.origin.x + time_frame.size.width + 5;
    status_frame.origin.y = time_frame.origin.y;
    _statusIcon = [[UIImageView alloc] initWithFrame:status_frame];
    _statusIcon.contentMode = UIViewContentModeLeft;
    _statusIcon.autoresizingMask = _textView.autoresizingMask;
    [self.contentView addSubview:_statusIcon];
}
-(void)setStatusIcon
{
    if (self.message.status == MessageStatusSending)
        _statusIcon.image = [UIImage imageNamed:@"status_sending"];
    else if (self.message.status == MessageStatusSent)
        _statusIcon.image = [UIImage imageNamed:@"status_sent"];
    else if (self.message.status == MessageStatusNotified)
        _statusIcon.image = [UIImage imageNamed:@"status_notified"];
    else if (self.message.status == MessageStatusRead)
        _statusIcon.image = [UIImage imageNamed:@"status_read"];
    
    _statusIcon.hidden = _message.sender == MessageSenderSomeone;
}




@end
