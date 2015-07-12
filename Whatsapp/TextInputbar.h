//
//  TextInputbar.h
//  GrowingTextViewExample
//
//  Created by Rafael Castro on 7/11/15.
//
//

#import <UIKit/UIKit.h>


//
// Thanks for HansPinckaers for creating an amazing
// Growing UITextView. This class just add design and
// notifications to uitoobar be similar to whatsapp
// inputbar.
//
// https://github.com/HansPinckaers/GrowingTextView
//

@protocol TextInputbarDelegate;

@interface TextInputbar : UIToolbar

@property (nonatomic) id<TextInputbarDelegate>delegate;
@property (nonatomic) NSString *placeholder;
@property (nonatomic) UIImage *leftButtonImage;
@property (nonatomic) NSString *rightButtonText;
@property (nonatomic) UIColor  *rightButtonTextColor;

-(void)resignFirstResponder;
-(NSString *)text;

@end



@protocol TextInputbarDelegate <NSObject>
-(void)inputbar:(TextInputbar *)inputbar didPressRightButton:(UIButton *)button;
-(void)inputbar:(TextInputbar *)inputbar didPressLeftButton:(UIButton *)button;
@end
