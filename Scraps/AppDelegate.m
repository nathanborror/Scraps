//
//  AppDelegate.m
//  Scraps
//
//  Created by Nathan Borror on 7/13/13.
//  Copyright (c) 2013 Nathan Borror. All rights reserved.
//

#import "AppDelegate.h"
#import "ViewController.h"

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
  self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
  [self.window setBackgroundColor:[UIColor whiteColor]];

  DBAccountManager *accountManager = [[DBAccountManager alloc] initWithAppKey:@"kmhsm1hf4ewgxv2" secret:@"3fpjzuojeoe9cjd"];
  [DBAccountManager setSharedManager:accountManager];

  ViewController *viewController = [[ViewController alloc] init];
  UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:viewController];

  [self.window setRootViewController:navController];
  [self.window makeKeyAndVisible];

  return YES;
}

- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation
{
  DBAccount *account = [[DBAccountManager sharedManager] handleOpenURL:url];
  if (account) {
    NSLog(@"App linked successfully");
    return YES;
  }
  return NO;
}

@end
