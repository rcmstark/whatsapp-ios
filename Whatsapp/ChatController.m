//
//  ChatListController.m
//  Whatsapp
//
//  Created by Rafael Castro on 7/24/15.
//  Copyright (c) 2015 HummingBird. All rights reserved.
//

#import "ChatController.h"
#import "MessageController.h"
#import "ChatCell.h"
#import "Chat.h"
#import "LocalStorage.h"

@interface ChatController() <UITableViewDataSource, UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) NSMutableArray *tableData;
@end


@implementation ChatController

-(void)viewDidLoad
{
    [super viewDidLoad];
    [self setTableView];
    [self setTest];
    
    self.title = @"Chats";
}
-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self.tableView reloadData];
}
-(void)setTableView
{
    self.tableData = [[NSMutableArray alloc] init];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectMake(0.0f, 0.0f,self.view.frame.size.width, 10.0f)];
    self.tableView.backgroundColor = [UIColor clearColor];
}
-(void)setTest
{
    Message *message = [[Message alloc] init];
    message.text = @"This is a test message";
    message.sender = MessageSenderSomeone;
    
    Chat *chat = [[Chat alloc] init];
    chat.last_message = message;
    chat.sender_name = @"Player 1";
    chat.receiver_id = @"12345";
    chat.sender_id = @"54321";
    
    [[LocalStorage sharedInstance] storeMessage:message
                                        forChat:chat];
    
    [self.tableData addObject:chat];
}

#pragma mark - TableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.tableData count];
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"ChatListCell";
    ChatCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (!cell)
    {
        cell = [[ChatCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    cell.chat = [self.tableData objectAtIndex:indexPath.row];
    
    return cell;
}

#pragma mark - UITableViewDelegate

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    MessageController *controller = [self.storyboard instantiateViewControllerWithIdentifier:@"Message"];
    controller.chat = [self.tableData objectAtIndex:indexPath.row];
    [self.navigationController pushViewController:controller animated:YES];
}

@end
