//
//  Inputbar.h
//  Whatsapp
//
//  Created by Rafael Castro on 7/11/15.
//  Copyright (c) 2015 HummingBird. All rights reserved.
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

@protocol InputbarDelegate;

@interface Inputbar : UIToolbar

@property (nonatomic, assign) id<InputbarDelegate>delegate;
@property (nonatomic) NSString *placeholder;
@property (nonatomic) UIImage *leftButtonImage;
@property (nonatomic) NSString *rightButtonText;
@property (nonatomic) UIColor  *rightButtonTextColor;

-(void)resignFirstResponder;
-(NSString *)text;

@end



@protocol InputbarDelegate <NSObject>
-(void)inputbarDidPressRightButton:(Inputbar *)inputbar;
-(void)inputbarDidPressLeftButton:(Inputbar *)inputbar;
@optional
-(void)inputbarDidChangeHeight:(CGFloat)new_height;
-(void)inputbarDidBecomeFirstResponder:(Inputbar *)inputbar;
@end
