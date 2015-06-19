//
//  ChatController.m
//  Whatsapp
//
//  Created by Rafael Castro on 6/16/15.
//  Copyright (c) 2015 HummingBird. All rights reserved.
//

#import "MessageController.h"
#import "DAKeyboardControl.h"

#import "Message.h"
#import "MessageCell.h"

@interface MessageController() <UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UITextField *textField;
@property (weak, nonatomic) IBOutlet UIView *toolBar;

@property (assign, nonatomic) NSInteger changeSender;

@end




@implementation MessageController

-(void)viewDidLoad
{
    [super viewDidLoad];
    [self setTableView];
    [self addTest];
    self.textField.delegate = self;
}
-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    UIView *toolBar = _toolBar;
    UITableView *tableView = _tableView;
    
    self.view.keyboardTriggerOffset = toolBar.frame.size.height;
    [self.view addKeyboardPanningWithFrameBasedActionHandler:^(CGRect keyboardFrameInView, BOOL opening, BOOL closing) {
        
         /*
         Try not to call "self" inside this block (retain cycle).
         But if you do, make sure to remove DAKeyboardControl
         when you are done with the view controller by calling:
         [self.view removeKeyboardControl];
         */
        
        CGRect toolBarFrame = toolBar.frame;
        toolBarFrame.origin.y = keyboardFrameInView.origin.y - toolBarFrame.size.height;
        toolBar.frame = toolBarFrame;
        
        CGRect tableViewFrame = tableView.frame;
        tableViewFrame.size.height = toolBarFrame.origin.y - 64;
        tableView.frame = tableViewFrame;
        
    }constraintBasedActionHandler:nil];
}
-(void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    [self.view removeKeyboardControl];
}
-(void)addTest
{
    NSMutableArray *array = [NSMutableArray new];
    
    for (int i = 100; i >= 0; i--)
    {
        Message *message = [[Message alloc] init];
        message.text = [NSString stringWithFormat:@"This is a test message."];
        message.sender = ++self.changeSender%2==0?MessageSenderSomeone:MessageSenderMyself;
        message.sent = [[NSDate date] dateByAddingTimeInterval:-i*24*60*60];;
        
        [array addObject:message];
    }
    [self.messageArray addMessages:array];
}
-(void)setTableView
{
    self.messageArray = [[MessageArray alloc] init];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectMake(0.0f, 0.0f,self.view.frame.size.width, 10.0f)];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
}
-(void)scrollToBottomTableView
{
    if (self.tableView.contentOffset.y > self.tableView.frame.size.height)
    {
        [self.tableView scrollToRowAtIndexPath:[self.messageArray indexPathForLastMessage]
                              atScrollPosition:UITableViewScrollPositionBottom animated:YES];
    }
}

#pragma mark - Action

- (IBAction)send:(UIButton *)button
{
    Message *message = [[Message alloc] init];
    message.text = self.textField.text;
    message.sender = ++self.changeSender%2==0?MessageSenderSomeone:MessageSenderMyself;
    message.sent = [NSDate date];
    
    [self.messageArray addMessage:message];
    
    [self.tableView reloadData];
    [self.tableView scrollToRowAtIndexPath:[self.messageArray indexPathForLastMessage]
                          atScrollPosition:UITableViewScrollPositionBottom animated:YES];
    
    self.textField.text = @"";
}
- (IBAction)userDidTapScreen:(id)sender
{
    [self.textField resignFirstResponder];
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [self.messageArray numberOfSections];
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.messageArray numberOfMessagesInSection:section];
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"MessageCell";
    MessageCell *cell = (MessageCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    Message *message = [self.messageArray messageAtIndexPath:indexPath];
    cell.message = message;

    return cell;
}

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    MessageCell *cell = (MessageCell *) [self tableView:tableView cellForRowAtIndexPath:indexPath];
    return cell?cell.height:44;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    CGRect frame = CGRectMake(0, 0, self.view.frame.size.width, 40);
    
    UIView *view = [[UIView alloc] initWithFrame:frame];
    view.backgroundColor = [UIColor clearColor];
    view.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    
    UILabel *label = [[UILabel alloc] init];
    label.text = [self tableView:tableView titleForHeaderInSection:section];
    label.textAlignment = NSTextAlignmentCenter;
    label.font = [UIFont fontWithName:@"Helvetica" size:20.0];
    [label sizeToFit];
    label.center = view.center;
    label.font = [UIFont fontWithName:@"Helvetica" size:13.0];
    label.backgroundColor = [UIColor colorWithRed:207/255.0 green:220/255.0 blue:252.0/255.0 alpha:1];
    label.layer.cornerRadius = 10;
    label.layer.masksToBounds = YES;
    label.autoresizingMask = UIViewAutoresizingNone;
    [view addSubview:label];
    
    return view;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 40;
}
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return [self.messageArray titleForSection:section];
}

#pragma mark - UITextFieldDelegate

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    [self performSelector:@selector(scrollToBottomTableView) withObject:nil afterDelay:.3];
}


@end
