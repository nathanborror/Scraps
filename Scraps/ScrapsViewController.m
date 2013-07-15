//
//  ScrapsViewController.m
//  Scraps
//
//  Created by Nathan Borror on 7/13/13.
//  Copyright (c) 2013 Nathan Borror. All rights reserved.
//

#import "ScrapsViewController.h"
#import "AddScrapViewController.h"
#import "ScrapCell.h"

@interface ScrapsViewController ()

@property (nonatomic, retain) DBAccount *account;
@property (nonatomic, retain) DBDatastore *store;
@property (nonatomic, retain) DBTable *table;
@property (nonatomic, retain) NSArray *scraps;
@property (nonatomic, retain) UITableView *scrapsTable;

@end

@implementation ScrapsViewController

- (void)viewDidLoad
{
  [super viewDidLoad];

  [self setTitle:@"Scraps"];
  [self setEdgesForExtendedLayout:UIExtendedEdgeNone];
  [self.view setBackgroundColor:[UIColor colorWithWhite:.9 alpha:1]];

  UIBarButtonItem *add = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(add)];
  [self.navigationItem setRightBarButtonItem:add];

  self.scrapsTable = [[UITableView alloc] initWithFrame:self.view.frame style:UITableViewStylePlain];
  [self.scrapsTable setDelegate:self];
  [self.scrapsTable setDataSource:self];
  [self.scrapsTable registerClass:[ScrapCell class] forCellReuseIdentifier:@"ScrapCell"];
  [self.scrapsTable setSeparatorStyle:UITableViewCellSeparatorStyleNone];
  [self.scrapsTable setBackgroundColor:[UIColor clearColor]];
  [self.view addSubview:self.scrapsTable];

  [self linkDropboxAccount];
}

- (void)linkDropboxAccount
{
  self.account = [[DBAccountManager sharedManager] linkedAccount];
  if (self.account) {
    [self showScraps];
  } else {
    [[DBAccountManager sharedManager] linkFromController:self];
  }
}

- (void)showScraps
{
  self.store = [DBDatastore openDefaultStoreForAccount:_account error:nil];

  __weak ScrapsViewController *vc = self;
  [self.store addObserver:self block:^{
    if (vc.store.status & DBDatastoreIncoming) {
      [vc.store sync:nil];
      vc.scraps = [vc.table query:nil error:nil];
      [vc.scrapsTable reloadData];
    }
  }];

  self.table = [self.store getTable:@"Scraps"];
  self.scraps = [self.table query:nil error:nil];
  [self.scrapsTable reloadData];
}

- (void)add
{
  AddScrapViewController *viewController = [[AddScrapViewController alloc] init];
  [viewController setDelegate:self];
  UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:viewController];
  [self presentViewController:navController animated:YES completion:nil];
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
  return self.scraps.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
  ScrapCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ScrapCell"];
  DBRecord *result = [self.scraps objectAtIndex:indexPath.row];
  [cell.textLabel setText:result.fields[@"text"]];
  return cell;
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
  if (editingStyle == UITableViewCellEditingStyleDelete) {
    DBRecord *result = [self.scraps objectAtIndex:indexPath.row];
    [result deleteRecord];
    [self.store sync:nil];
    self.scraps = [self.table query:nil error:nil];

    [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath]
                     withRowAnimation:UITableViewRowAnimationAutomatic];
  }
}

#pragma mark - AddScrapViewDelegate

- (void)addScrapDidFinish:(NSDictionary *)scrap
{
  [self.table insert:scrap];
  [self.store sync:nil];
  self.scraps = [self.table query:nil error:nil];
  [self.scrapsTable reloadData];
}

@end
