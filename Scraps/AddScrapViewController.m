//
//  AddScrapViewController.m
//  Scraps
//
//  Created by Nathan Borror on 7/13/13.
//  Copyright (c) 2013 Nathan Borror. All rights reserved.
//

#import "AddScrapViewController.h"

static const CGFloat kTextMargin = 20.0;

@interface AddScrapViewController ()
{
  UITextField *text;
}
@end

@implementation AddScrapViewController
@synthesize delegate;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
  self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
  if (self) {
    // Custom initialization
  }
  return self;
}

- (void)viewDidLoad
{
  [super viewDidLoad];

  [self setEdgesForExtendedLayout:UIExtendedEdgeNone];
  [self setTitle:@"Add Scrap"];
  [self.view setBackgroundColor:[UIColor whiteColor]];

  UIBarButtonItem *save = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemSave target:self action:@selector(save)];
  [self.navigationItem setRightBarButtonItem:save];

  UIBarButtonItem *cancel = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(cancel)];
  [self.navigationItem setLeftBarButtonItem:cancel];

  text = [[UITextField alloc] initWithFrame:CGRectMake(kTextMargin, kTextMargin, CGRectGetWidth(self.view.bounds)-(kTextMargin*2), CGRectGetHeight(self.view.bounds)-(kTextMargin*2))];
  [text setFont:[UIFont systemFontOfSize:18.0]];
  [text setContentVerticalAlignment:UIControlContentVerticalAlignmentTop];
  [text becomeFirstResponder];
  [self.view addSubview:text];
}

- (void)save
{
  if (self.delegate) {
    [self.delegate addScrapDidFinish:@{@"text": text.text}];
  }
  [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)cancel
{
  [self dismissViewControllerAnimated:YES completion:nil];
}

@end
