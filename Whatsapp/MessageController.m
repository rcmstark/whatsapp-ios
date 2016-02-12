//
//  MessageController.m
//  Whatsapp
//
//  Created by Rafael Castro on 7/23/15.
//  Copyright (c) 2015 HummingBird. All rights reserved.
//

#import "MessageController.h"
#import "MessageCell.h"
#import "TableArray.h"
#import "MessageGateway.h"

#import "Inputbar.h"
#import "DAKeyboardControl.h"

@interface MessageController() <InputbarDelegate,MessageGatewayDelegate,
                                    UITableViewDataSource,UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet Inputbar *inputbar;
@property (strong, nonatomic) TableArray *tableArray;
@property (strong, nonatomic) MessageGateway *gateway;

@end




@implementation MessageController

-(void)viewDidLoad
{
    [super viewDidLoad];
    [self setInputbar];
    [self setTableView];
    [self setGateway];
}
-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    __weak Inputbar *inputbar = _inputbar;
    __weak UITableView *tableView = _tableView;
    __weak MessageController *controller = self;
    
    self.view.keyboardTriggerOffset = inputbar.frame.size.height;
    [self.view addKeyboardPanningWithActionHandler:^(CGRect keyboardFrameInView, BOOL opening, BOOL closing) {
        /*
         Try not to call "self" inside this block (retain cycle).
         But if you do, make sure to remove DAKeyboardControl
         when you are done with the view controller by calling:
         [self.view removeKeyboardControl];
         */
        
        CGRect toolBarFrame = inputbar.frame;
        toolBarFrame.origin.y = keyboardFrameInView.origin.y - toolBarFrame.size.height;
        inputbar.frame = toolBarFrame;
        
        CGRect tableViewFrame = tableView.frame;
        tableViewFrame.size.height = toolBarFrame.origin.y - 64;
        tableView.frame = tableViewFrame;
        
        [controller tableViewScrollToBottomAnimated:NO];
    }];
}
-(void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    [self.view endEditing:YES];
    [self.view removeKeyboardControl];
    [self.gateway dismiss];
}
-(void)viewWillDisappear:(BOOL)animated
{
    self.chat.last_message = [self.tableArray lastObject];
}

#pragma mark -

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
    self.tableArray = [[TableArray alloc] init];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectMake(0.0f, 0.0f,self.view.frame.size.width, 10.0f)];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.backgroundColor = [UIColor clearColor];
    [self.tableView registerClass:[MessageCell class] forCellReuseIdentifier: @"MessageCell"];
}
-(void)setGateway
{
    self.gateway = [MessageGateway sharedInstance];
    self.gateway.delegate = self;
    self.gateway.chat = self.chat;
    [self.gateway loadOldMessages];
}
-(void)setChat:(Chat *)chat
{
    _chat = chat;
    self.title = chat.contact.name;
}

#pragma mark - Actions

- (IBAction)userDidTapScreen:(id)sender
{
    [_inputbar resignFirstResponder];
}

#pragma mark - TableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [self.tableArray numberOfSections];
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.tableArray numberOfMessagesInSection:section];
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"MessageCell";
    MessageCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (!cell)
    {
        cell = [[MessageCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    cell.message = [self.tableArray objectAtIndexPath:indexPath];
    return cell;
}

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    Message *message = [self.tableArray objectAtIndexPath:indexPath];
    return message.heigh;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 40.0;
}
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return [self.tableArray titleForSection:section];
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    CGRect frame = CGRectMake(0, 0, tableView.frame.size.width, 40);
    
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
- (void)tableViewScrollToBottomAnimated:(BOOL)animated
{
    NSInteger numberOfSections = [self.tableArray numberOfSections];
    NSInteger numberOfRows = [self.tableArray numberOfMessagesInSection:numberOfSections-1];
    if (numberOfRows)
    {
        [_tableView scrollToRowAtIndexPath:[self.tableArray indexPathForLastMessage]
                                         atScrollPosition:UITableViewScrollPositionBottom animated:animated];
    }
}

#pragma mark - InputbarDelegate

-(void)inputbarDidPressRightButton:(Inputbar *)inputbar
{
    Message *message = [[Message alloc] init];
    message.text = inputbar.text;
    message.date = [NSDate date];
    message.chat_id = _chat.identifier;
    
    //Store Message in memory
    [self.tableArray addObject:message];
    
    //Insert Message in UI
    NSIndexPath *indexPath = [self.tableArray indexPathForMessage:message];
    [self.tableView beginUpdates];
    if ([self.tableArray numberOfMessagesInSection:indexPath.section] == 1)
        [self.tableView insertSections:[NSIndexSet indexSetWithIndex:indexPath.section]
                      withRowAnimation:UITableViewRowAnimationNone];
    [self.tableView insertRowsAtIndexPaths:@[indexPath]
                          withRowAnimation:UITableViewRowAnimationBottom];
    [self.tableView endUpdates];
    
    [self.tableView scrollToRowAtIndexPath:[self.tableArray indexPathForLastMessage]
                          atScrollPosition:UITableViewScrollPositionBottom animated:YES];
    
    //Send message to server
    [self.gateway sendMessage:message];
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
-(void)inputbarDidChangeHeight:(CGFloat)new_height
{
    //Update DAKeyboardControl
    self.view.keyboardTriggerOffset = new_height;
}

#pragma mark - MessageGatewayDelegate

-(void)gatewayDidUpdateStatusForMessage:(Message *)message
{
    NSIndexPath *indexPath = [self.tableArray indexPathForMessage:message];
    MessageCell *cell = (MessageCell *)[self.tableView cellForRowAtIndexPath:indexPath];
    [cell updateMessageStatus];
}
-(void)gatewayDidReceiveMessages:(NSArray *)array
{
    [self.tableArray addObjectsFromArray:array];
    [self.tableView reloadData];
}



@end
