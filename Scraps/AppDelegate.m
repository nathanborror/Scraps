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

  [Parse setApplicationId:@"YOUR_PARSE_APP_ID"
                clientKey:@"YOUR_PARSE_CLIENT_KEY"];
  [PFAnalytics trackAppOpenedWithLaunchOptions:launchOptions];

  ScrapsViewController *viewController = [[ScrapsViewController alloc] init];
  UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:viewController];

  [self.window setRootViewController:navController];
  [self.window makeKeyAndVisible];

  return YES;
}

@end
