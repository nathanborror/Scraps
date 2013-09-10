//
//  AppDelegate.m
//  Scraps
//
//  Created by Nathan Borror on 7/13/13.
//  Copyright (c) 2013 Nathan Borror. All rights reserved.
//

#import "AppDelegate.h"
#import "ScrapsViewController.h"

#define PARSE_APP_ID @"YOUR APP ID"
#define PARSE_CLIENT_KEY @"YOUR CLIENT KEY"

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
  self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
  [self.window setBackgroundColor:[UIColor whiteColor]];

  [Parse setApplicationId:PARSE_APP_ID clientKey:PARSE_CLIENT_KEY];
  [PFAnalytics trackAppOpenedWithLaunchOptions:launchOptions];

  ScrapsViewController *viewController = [[ScrapsViewController alloc] init];
  UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:viewController];

  [self.window setRootViewController:navController];
  [self.window makeKeyAndVisible];

  return YES;
}

@end
