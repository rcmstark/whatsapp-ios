//
//  MessageCell.m
//  Whatsapp
//
//  Created by Rafael Castro on 6/16/15.
//  Copyright (c) 2015 HummingBird. All rights reserved.
//

#import "MessageCell.h"

@interface MessageCell ()
@property (weak, nonatomic) IBOutlet UITextView *textView;
@property (weak, nonatomic) IBOutlet UIImageView *bubbleImage;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
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
    _textView.text = message.text;
    _message = message;
    
    [self addBubble];
    [self addTimeLabel];
}

#pragma mark - 

-(void)awakeFromNib
{
    self.backgroundColor = [UIColor clearColor];
}
- (void)addBubble
{
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    
    //Estimation of TextView Size
    CGFloat textView_x;
    CGFloat textView_y;
    CGFloat textView_width = [self measureSizeOfUITextView].width;
    CGFloat textView_height = [self measureSizeOfUITextView].height;
    CGFloat textView_marginLeft;
    CGFloat textView_marginRight;
    CGFloat textView_marginBotton = 10;
    
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
        bubble_x = self.contentView.frame.size.width - textView_width - 2 - textView_marginLeft - textView_marginRight;
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
    bubble_height = textView_height + textView_marginBotton;
    
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
-(void)addTimeLabel
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

#pragma mark - iOS7 correction

-(CGFloat)measureHeightOfUITextView:(UITextView *)textView
{
    if ([textView respondsToSelector:@selector(snapshotViewAfterScreenUpdates:)])
    {
        // This is the code for iOS 7. contentSize no longer returns the correct value, so
        // we have to calculate it.
        //
        // This is partly borrowed from HPGrowingTextView, but I've replaced the
        // magic fudge factors with the calculated values (having worked out where
        // they came from)
        
        CGRect frame = textView.bounds;
        
        // Take account of the padding added around the text.
        
        UIEdgeInsets textContainerInsets = textView.textContainerInset;
        UIEdgeInsets contentInsets = textView.contentInset;
        
        CGFloat leftRightPadding = textContainerInsets.left + textContainerInsets.right + textView.textContainer.lineFragmentPadding * 2 + contentInsets.left + contentInsets.right;
        CGFloat topBottomPadding = textContainerInsets.top + textContainerInsets.bottom + contentInsets.top + contentInsets.bottom;
        
        frame.size.width -= leftRightPadding;
        frame.size.height -= topBottomPadding;
        
        NSString *textToMeasure = textView.text;
        if ([textToMeasure hasSuffix:@"\n"])
        {
            textToMeasure = [NSString stringWithFormat:@"%@-", textView.text];
        }
        
        // NSString class method: boundingRectWithSize:options:attributes:context is
        // available only on ios7.0 sdk.
        
        NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
        [paragraphStyle setLineBreakMode:NSLineBreakByWordWrapping];
        
        NSDictionary *attributes = @{ NSFontAttributeName: textView.font, NSParagraphStyleAttributeName : paragraphStyle };
        
        CGRect size = [textToMeasure boundingRectWithSize:CGSizeMake(CGRectGetWidth(frame), MAXFLOAT)
                                                  options:NSStringDrawingUsesLineFragmentOrigin
                                               attributes:attributes
                                                  context:nil];
        
        CGFloat measuredHeight = ceilf(CGRectGetHeight(size) + topBottomPadding);
        return measuredHeight+8.0f;
    }
    else
    {
        return textView.contentSize.height;
    }
}

@end
