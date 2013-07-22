//
//  AppDelegate.m
//  Scraps
//
//  Created by Nathan Borror on 7/13/13.
//  Copyright (c) 2013 Nathan Borror. All rights reserved.
//

#import "AppDelegate.h"
#import "ScrapsViewController.h"

#define DB_APP_KEY @"YOUR APP KEY"
#define DB_APP_SECRET @"YOUR APP SECRET"

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
  self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
  [self.window setBackgroundColor:[UIColor whiteColor]];

  DBAccountManager *accountManager = [[DBAccountManager alloc] initWithAppKey:DB_APP_KEY secret:DB_APP_SECRET];
  [DBAccountManager setSharedManager:accountManager];

  ScrapsViewController *viewController = [[ScrapsViewController alloc] init];
  UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:viewController];

  [self.window setRootViewController:navController];
  [self.window makeKeyAndVisible];

  return YES;
}

- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation
{
  DBAccount *account = [[DBAccountManager sharedManager] handleOpenURL:url];
  if (account) {
    return YES;
  }
  return NO;
}

@end
