//
//  ChatController.m
//  Whatsapp
//
//  Created by Rafael Castro on 6/16/15.
//  Copyright (c) 2015 HummingBird. All rights reserved.
//

#import "MessageController.h"
#import "DAKeyboardControl.h"
#import "Inputbar.h"

#import "Message.h"
#import "MessageCell.h"
#import "MessageGateway.h"

@interface MessageController() <UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate, MessageGatewayDelegate, InputbarDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet Inputbar *inputbar;

@property (assign, nonatomic) NSInteger changeSender;
@property (strong, nonatomic) MessageGateway *gateway;

@end




@implementation MessageController

-(void)viewDidLoad
{
    [super viewDidLoad];
    [self setTableView];
    [self setInputbar];
    [self addTest];
}
-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    UIView *toolBar = _inputbar;
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
    
    for (int i = 2; i > 0; i--)
    {
        Message *message = [[Message alloc] init];
        message.text = [NSString stringWithFormat:@"This is a test message."];
        message.sender = ++self.changeSender%2==0?MessageSenderSomeone:MessageSenderMyself;
        message.sent = [[NSDate date] dateByAddingTimeInterval:-i*24*60*60];;
        message.status = MessageStatusRead;
        
        [array addObject:message];
    }
    [self.messageArray addMessages:array];
}
-(void)setInputbar
{
    self.inputbar.placeholder = nil;
    self.inputbar.delegate = self;
    self.inputbar.leftButtonImage = [UIImage imageNamed:@"share"];
    self.inputbar.rightButtonText = @"Send";
    self.inputbar.rightButtonTextColor = [UIColor colorWithRed:0 green:124/255.0 blue:1 alpha:1];
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
   [self.tableView scrollToRowAtIndexPath:[self.messageArray indexPathForLastMessage]
                              atScrollPosition:UITableViewScrollPositionBottom animated:YES];
}

#pragma mark - Actions

- (IBAction)userDidTapScreen:(id)sender
{
    [self.inputbar resignFirstResponder];
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
    if (cell == nil)
    {
        cell = [[MessageCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    Message *message = [self.messageArray messageAtIndexPath:indexPath];
    cell.message = message;

    return cell;
}

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    MessageCell *cell = (MessageCell *) [self tableView:tableView cellForRowAtIndexPath:indexPath];
    return cell?cell.height:22;
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
    return 40.0;
}
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return [self.messageArray titleForSection:section];
}

#pragma mark - MessageGatewayDelegate

-(void)gatewayDidUpdateStatusForMessage:(Message *)message
{
    NSIndexPath *indexPath = [self.messageArray indexPathForMessage:message];
    [self.tableView beginUpdates];
    [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
    [self.tableView endUpdates];
}

#pragma mark - InputbarDelegate

-(void)inputbarDidPressRightButton:(Inputbar *)inputbar
{
    //Add Message to MessageArray
    Message *message = [[Message alloc] init];
    message.text = inputbar.text;
    message.sender = ++self.changeSender%2==0?MessageSenderSomeone:MessageSenderMyself;
    message.sent = [NSDate date];
    
    [self.messageArray addMessage:message];
    NSIndexPath *indexPath = [self.messageArray indexPathForMessage:message];
    
    [self.tableView beginUpdates];
    if ([self.messageArray numberOfMessagesInSection:indexPath.section] == 1)
        [self.tableView insertSections:[NSIndexSet indexSetWithIndex:indexPath.section] withRowAnimation:UITableViewRowAnimationNone];
    [self.tableView insertRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
    [self.tableView endUpdates];
    
    [self.tableView scrollToRowAtIndexPath:[self.messageArray indexPathForLastMessage]
                          atScrollPosition:UITableViewScrollPositionBottom animated:YES];
    
    if (!_gateway)
    {
        _gateway = [[MessageGateway alloc] init];
        _gateway.delegate = self;
    }
    [_gateway sendMessage:message];
}
-(void)inputbarDidPressLeftButton:(Inputbar *)inputbar
{
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Left Button Pressed"
                                                        message:nil
                                                       delegate:nil
                                              cancelButtonTitle:@"Ok"
                                              otherButtonTitles:nil, nil];
    [alertView show];
}
-(void)inputbarDidBecomeFirstResponder:(Inputbar *)inputbar
{
    [self performSelector:@selector(scrollToBottomTableView) withObject:nil afterDelay:.3];
}

@end
