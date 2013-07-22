//
//  ScrapsViewController.m
//  Scraps
//
//  Created by Nathan Borror on 7/13/13.
//  Copyright (c) 2013 Nathan Borror. All rights reserved.
//

#import "ScrapsViewController.h"
#import "ScrapCell.h"

@interface ScrapsViewController () {
  BOOL pullDownInProgress;
  ScrapCell *placeholderCell;

  UITextField *newInputText;
  UIView *newInput;
}

@property (nonatomic, retain) DBAccount *account;
@property (nonatomic, retain) DBDatastore *store;
@property (nonatomic, retain) DBTable *table;
@property (nonatomic, retain) NSArray *scraps;
@property (nonatomic, retain) UITableView *scrapsTable;

@end

@implementation ScrapsViewController

- (id)init
{
  if (self = [super init]) {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(receiveTrashNotification:) name:@"TrashNotification" object:nil];
  }
  return self;
}

- (void)viewDidLoad
{
  [super viewDidLoad];

  [self.navigationController setNavigationBarHidden:YES];
  [self.view setBackgroundColor:[UIColor colorWithWhite:.85 alpha:1]];

  // Scraps Table
  _scrapsTable = [[UITableView alloc] initWithFrame:self.view.frame style:UITableViewStylePlain];
  [_scrapsTable setDelegate:self];
  [_scrapsTable setDataSource:self];
  [_scrapsTable registerClass:[ScrapCell class] forCellReuseIdentifier:@"ScrapCell"];
  [_scrapsTable setSeparatorStyle:UITableViewCellSeparatorStyleNone];
  [_scrapsTable setBackgroundColor:[UIColor clearColor]];
  [_scrapsTable setRowHeight:50];
  [_scrapsTable setContentInset:UIEdgeInsetsMake(50, 0, 0, 0)];
  [self.view addSubview:_scrapsTable];

  // New Input
  newInput = [[UIView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.view.bounds), 50)];
  [newInput setBackgroundColor:[UIColor colorWithWhite:1 alpha:1]];

  newInputText = [[UITextField alloc] initWithFrame:CGRectMake(15, 10, CGRectGetWidth(newInput.bounds)-30, CGRectGetHeight(newInput.bounds)-20)];
  [newInputText setPlaceholder:@"New Scrap"];
  [newInputText setReturnKeyType:UIReturnKeyDone];
  [newInputText setDelegate:self];
  [newInput addSubview:newInputText];
  [self.view addSubview:newInput];

  [self linkDropboxAccount];
}

- (void)linkDropboxAccount
{
  _account = [[DBAccountManager sharedManager] linkedAccount];
  if (_account) {
    [self showScraps];
  } else {
    [[DBAccountManager sharedManager] linkFromController:self];
  }
}

- (void)showScraps
{
  _store = [DBDatastore openDefaultStoreForAccount:_account error:nil];

  __weak ScrapsViewController *vc = self;
  [_store addObserver:self block:^{
    if (vc.store.status & DBDatastoreIncoming) {
      [vc refresh];
    }
  }];

  _table = [_store getTable:@"Scraps"];
  _scraps = [_table query:nil error:nil];
  [_scrapsTable reloadData];
}

- (void)refresh
{
  [_store sync:nil];
  _scraps = [_table query:nil error:nil];
  [_scrapsTable reloadData];
}

- (void)receiveTrashNotification:(NSNotification *)notification
{
  NSIndexPath *indexPath = notification.object;

  DBRecord *result = [_scraps objectAtIndex:indexPath.row];
  [result deleteRecord];
  [_store sync:nil];
  _scraps = [_table query:nil error:nil];

  [_scrapsTable deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationNone];
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
  return _scraps.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
  ScrapCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ScrapCell"];
  DBRecord *result = [_scraps objectAtIndex:indexPath.row];
  [cell.textLabel setText:result.fields[@"text"]];
  return cell;
}

#pragma mark - UIScrollViewDelegate

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
  [newInputText resignFirstResponder];
}

#pragma mark - UITextFieldDelegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
  [textField resignFirstResponder];

  if ([textField.text isEqualToString:@""]) {
    return YES;
  }

  [_table insert:@{@"text": textField.text}];
  [self refresh];
  [textField setText:nil];

  return YES;
}

@end
