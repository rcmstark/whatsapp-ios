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
@end

@implementation MessageCell

-(CGFloat)height
{
    return [self measureHeightOfUITextView:self.textView];
}
-(CGFloat)width
{
    return [self contentSize:self.textView].width + 25;
}
-(void)setMessage:(Message *)message
{
    _textView.text = message.text;
    _message = message;
    
    [self addBubble];
}
- (void)addBubble
{
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    
    //TextView contentSize
    CGFloat width = self.width;
    CGFloat height = self.height;
    
    //Bubble positions
    CGFloat x;
    CGFloat y;
    
    if (self.message.sender == MessageSenderMyself)
    {
        x = self.contentView.frame.size.width - width - 2;
        y = 0;
        
        self.bubbleImage.image = [[UIImage imageNamed:@"bubbleMine"]
                                  stretchableImageWithLeftCapWidth:15 topCapHeight:14];
        
        self.textView.textAlignment = NSTextAlignmentRight;
        self.textView.frame = CGRectMake(self.contentView.frame.size.width - self.textView.frame.size.width - 20,
                                         0,
                                         self.textView.frame.size.width,
                                         self.textView.frame.size.height);
    }
    else
    {
        x = 2;
        y = 0;
        
        
        self.bubbleImage.image = [[UIImage imageNamed:@"bubbleSomeone"]
                                  stretchableImageWithLeftCapWidth:21 topCapHeight:14];
        
        self.textView.textAlignment = NSTextAlignmentLeft;
        self.textView.frame = CGRectMake(x+15, 0, self.textView.frame.size.width, self.textView.frame.size.height);
    }
    
    self.bubbleImage.frame = CGRectMake(x, y, width,height);
    
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

#pragma mark - Helpers

-(CGSize)contentSize:(UITextView*) textView
{
    return [textView sizeThatFits:CGSizeMake(textView.frame.size.width, FLT_MAX)];
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
