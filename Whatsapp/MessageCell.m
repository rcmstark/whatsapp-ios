//
//  MessageCell.m
//  Whatsapp
//
//  Created by Rafael Castro on 6/16/15.
//  Copyright (c) 2015 HummingBird. All rights reserved.
//

#import "MessageCell.h"

@interface MessageCell ()
@property (strong, nonatomic) UITextView *textView;
@property (strong, nonatomic) UIImageView *bubbleImage;
@property (strong, nonatomic) UILabel *timeLabel;
@end

@implementation MessageCell


-(CGFloat)height
{
    return _bubbleImage.frame.size.height;
}
-(CGFloat)width
{
    return _bubbleImage.frame.size.width;
}
-(void)setMessage:(Message *)message
{
    _message = message;
    
    [self cleanView];
    
    [self addTextView];
    [self setTextView];
    
    [self addBubble];
    [self setBubble];
    
    [self addTimeLabel];
    [self setTimeLabel];
}

#pragma mark - 

-(void)awakeFromNib
{
    self.backgroundColor = [UIColor clearColor];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    self.contentView.backgroundColor = [UIColor clearColor];
}
-(void)cleanView
{
    for (UIView *view in self.contentView.subviews)
        [view removeFromSuperview];
}

#pragma mark - TextView

-(void)addTextView
{
    CGFloat max_witdh = 0.7*self.contentView.frame.size.width;
    _textView = [[UITextView alloc] initWithFrame:CGRectMake(0, 0, max_witdh, MAXFLOAT)];
    _textView.font = [UIFont fontWithName:@"Helvetica" size:14.0];
    _textView.backgroundColor = [UIColor clearColor];
    _textView.userInteractionEnabled = NO;
    [self.contentView addSubview:_textView];
}
-(void)setTextView
{
    _textView.text = _message.text;
    [_textView sizeToFit];
}

#pragma mark - BubbleImage

-(void)addBubble
{
    _bubbleImage = [[UIImageView alloc] init];
    _bubbleImage.userInteractionEnabled = YES;
    [self.contentView insertSubview:_bubbleImage belowSubview:_textView];
}
- (void)setBubble
{
    //Estimation of TextView Size
    CGFloat textView_x;
    CGFloat textView_y;
    CGFloat textView_width = _textView.frame.size.width;
    CGFloat textView_height = _textView.frame.size.height;
    CGFloat textView_marginLeft;
    CGFloat textView_marginRight;
    CGFloat textView_marginBottom = 10;
    
    //Bubble positions
    CGFloat bubble_x;
    CGFloat bubble_y;
    CGFloat bubble_width;
    CGFloat bubble_height;
    
    UIViewAutoresizing autoresizing;
    
    if (self.message.sender == MessageSenderMyself)
    {
        textView_marginLeft = 10;
        textView_marginRight = 20;
        bubble_x = self.contentView.frame.size.width - textView_width - textView_marginLeft - textView_marginRight - 1;
        bubble_y = 0;
        
        self.bubbleImage.image = [[UIImage imageNamed:@"bubbleMine"]
                                  stretchableImageWithLeftCapWidth:15 topCapHeight:14];
        
        textView_x = bubble_x + textView_marginLeft;
        textView_y = 0;
        
        bubble_width = textView_width + 20;
        
        autoresizing = UIViewAutoresizingFlexibleLeftMargin;
    }
    else
    {
        bubble_x = 2;
        bubble_y = 1;
        
        self.bubbleImage.image = [[UIImage imageNamed:@"bubbleSomeone"]
                                  stretchableImageWithLeftCapWidth:21 topCapHeight:14];
        
        textView_marginLeft = 15;
        textView_marginRight = 15;
        textView_x = bubble_x + textView_marginLeft;
        textView_y = 0;
    
        autoresizing = UIViewAutoresizingFlexibleRightMargin;
    }
    
    bubble_width = textView_width + textView_marginLeft + textView_marginRight;
    bubble_height = textView_height + textView_marginBottom;
    
    //Set frame
    self.textView.frame = CGRectMake(textView_x, textView_y, textView_width, textView_height);
    self.bubbleImage.frame = CGRectMake(bubble_x, bubble_y, bubble_width, bubble_height);
    
    //Set textView
    self.textView.autoresizingMask = autoresizing;
    self.bubbleImage.autoresizingMask = autoresizing;
    
    [self addShadowToBubble];
}
-(void)addShadowToBubble
{
    UIImageView *imageView = self.bubbleImage;
    //shadow part
    imageView.layer.shadowColor = [UIColor blackColor].CGColor;
    imageView.layer.shadowOffset = CGSizeMake(0, 1);
    imageView.layer.shadowOpacity = .2;
    imageView.layer.shadowRadius = .5;
    
    //Add performace to shadow creation
    //If you remove this code, scroll in tableView will become slow
    imageView.layer.shouldRasterize = YES;
    imageView.layer.rasterizationScale = UIScreen.mainScreen.scale;
}

#pragma mark - TimeLabel

-(void)addTimeLabel
{
    _timeLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 70, 21)];
    _timeLabel.textColor = [UIColor lightGrayColor];
    _timeLabel.font = [UIFont fontWithName:@"Helvetica" size:12.0];
    _timeLabel.userInteractionEnabled = NO;
    [self.contentView addSubview:_timeLabel];
}
-(void)setTimeLabel
{
    //Set Text to Label
    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    df.timeStyle = NSDateFormatterShortStyle;
    df.dateStyle = NSDateFormatterNoStyle;
    df.doesRelativeDateFormatting = YES;
    self.timeLabel.text = [df stringFromDate:self.message.sent];
    [self.timeLabel sizeToFit];
    
    //Set position
    CGFloat time_x = _bubbleImage.frame.origin.x + _bubbleImage.frame.size.width - _timeLabel.frame.size.width;
    CGFloat time_y = self.height - _timeLabel.frame.size.height - 2;
    UIViewAutoresizing autoresizing;

    if (self.message.sender == MessageSenderMyself)
    {
        time_x = time_x - 20;
        autoresizing = UIViewAutoresizingFlexibleLeftMargin;
    }
    else
    {
        time_x = time_x - 15;
        time_y = time_y - 2;
        autoresizing = UIViewAutoresizingFlexibleRightMargin;
    }
    
    self.timeLabel.frame = CGRectMake(time_x,
                                      time_y,
                                      self.timeLabel.frame.size.width,
                                      self.timeLabel.frame.size.height);
    
    self.timeLabel.autoresizingMask = autoresizing;
    
    [self addSingleLineCase];
}
-(void)addSingleLineCase
{
    CGFloat delta_t = 13;
    CGFloat delta_x = self.timeLabel.frame.size.width + 2 + delta_t;
    CGRect time_frame = self.timeLabel.frame;
    
    CGFloat bubble_width = self.bubbleImage.frame.size.width;
    CGFloat view_width = self.contentView.frame.size.width;
    
    //Single Line Case
    if (self.height <= 45 && bubble_width + delta_x <= 0.8*view_width)
    {
        if (self.message.sender == MessageSenderMyself)
        {
            
            [self view:_textView shiftOriginX:-delta_x];
            [self increaseBubble:delta_x shiftOriginX:-delta_x];
        }
        else
        {
            time_frame.origin.x += delta_x;
            [self increaseBubble:delta_x shiftOriginX:0];
        }
        
        time_frame.origin.x -= delta_t;
        time_frame.origin.y = 10;
        self.timeLabel.frame = time_frame;
    }
}

#pragma mark - Helpers

-(void)increaseBubble:(CGFloat)deltaWidth shiftOriginX:(CGFloat)deltaX
{
    CGRect frame = _bubbleImage.frame;
    frame.size.width += deltaWidth;
    frame.origin.x += deltaX;
    _bubbleImage.frame = frame;
}
-(void)view:(UIView *)view shiftOriginX:(CGFloat)deltaX
{
    CGRect frame = view.frame;
    frame.origin.x += deltaX;
    view.frame = frame;
}
-(CGSize)measureSizeOfUITextView
{
    CGFloat max_width = 0.7*self.contentView.frame.size.width;
    UITextView *textView = [[UITextView alloc] initWithFrame:CGRectMake(0, 0, max_width, MAXFLOAT)];
    textView.font = _textView.font;
    textView.text = _textView.text;
    [textView sizeToFit];
    return textView.frame.size;
}


@end
