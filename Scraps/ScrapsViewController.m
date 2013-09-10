//
//  ScrapsViewController.m
//  Scraps
//
//  Created by Nathan Borror on 7/13/13.
//  Copyright (c) 2013 Nathan Borror. All rights reserved.
//

#import "ScrapsViewController.h"
#import "ScrapCell.h"

@interface ScrapsViewController () <UITableViewDataSource, UITableViewDelegate, UIScrollViewDelegate, UITextFieldDelegate, ScrapCellDelegate>

@property (nonatomic, retain) NSMutableArray *scraps;
@property (nonatomic, retain) UITableView *scrapsTable;

@end

@implementation ScrapsViewController {
  BOOL _pullDownInProgress;
  ScrapCell *_placeholderCell;
  UITextField *_newInputText;
  UIView *_newInput;
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
  _newInput = [[UIView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.view.bounds), 50)];
  [_newInput setBackgroundColor:[UIColor colorWithWhite:1 alpha:1]];

  _newInputText = [[UITextField alloc] initWithFrame:CGRectMake(15, 10, CGRectGetWidth(_newInput.bounds)-30, CGRectGetHeight(_newInput.bounds)-20)];
  [_newInputText setPlaceholder:@"New Scrap"];
  [_newInputText setReturnKeyType:UIReturnKeyDone];
  [_newInputText setDelegate:self];
  [_newInput addSubview:_newInputText];
  [self.view addSubview:_newInput];

  [self refresh];
}

- (void)refresh
{
  PFQuery *query = [PFQuery queryWithClassName:@"Scrap"];
  [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
    _scraps = objects;
    [_scrapsTable reloadData];
  }];
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
  return _scraps.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
  ScrapCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ScrapCell"];
  PFObject *result = [_scraps objectAtIndex:indexPath.row];
  [cell.textLabel setText:[result objectForKey:@"text"]];
  [cell setDelegate:self];
  return cell;
}

#pragma mark - UIScrollViewDelegate

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
  [_newInputText resignFirstResponder];
}

#pragma mark - UITextFieldDelegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
  [textField resignFirstResponder];

  if ([textField.text isEqualToString:@""]) {
    return YES;
  }

  PFObject *scrap = [PFObject objectWithClassName:@"Scrap"];
  [scrap setObject:textField.text forKey:@"text"];
  [scrap save];

  [self refresh];
  [textField setText:nil];

  return YES;
}

#pragma mark - ScrapCellDelegate

- (void)scrapRemoved:(ScrapCell *)cell
{
  NSIndexPath *indexPath = [_scrapsTable indexPathForCell:cell];

  PFObject *scrap = [_scraps objectAtIndex:indexPath.row];
  [scrap deleteInBackground];
  [_scraps removeObjectIdenticalTo:scrap];

  [_scrapsTable deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationNone];
}

@end
