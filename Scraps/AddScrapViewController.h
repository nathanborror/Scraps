//
//  AddScrapViewController.h
//  Scraps
//
//  Created by Nathan Borror on 7/13/13.
//  Copyright (c) 2013 Nathan Borror. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol AddScrapViewDelegate <NSObject>

- (void)addScrapDidFinish:(NSDictionary *)scrap;

@end

@interface AddScrapViewController : UIViewController <UITextFieldDelegate>

@property (nonatomic, weak) id<AddScrapViewDelegate> delegate;

@end