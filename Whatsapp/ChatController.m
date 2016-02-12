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
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
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
    Contact *contact = [[Contact alloc] init];
    contact.name = @"Player 1";
    contact.identifier = @"12345";
    
    Chat *chat = [[Chat alloc] init];
    chat.contact = contact;
    
    NSArray *texts = @[@"Hello!",
                       @"This project try to implement a chat UI similar to Whatsapp app.",
                       @"Is it close enough?"];
    
    Message *last_message = nil;
    for (NSString *text in texts)
    {
        Message *message = [[Message alloc] init];
        message.text = text;
        message.sender = MessageSenderSomeone;
        message.status = MessageStatusReceived;
        message.chat_id = chat.identifier;
        
        [[LocalStorage sharedInstance] storeMessage:message];
        last_message = message;
    }
    
    chat.numberOfUnreadMessages = texts.count;
    chat.last_message = last_message;

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
