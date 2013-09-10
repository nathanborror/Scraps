//
//  ScrapCell.h
//  Scraps
//
//  Created by Nathan Borror on 7/15/13.
//  Copyright (c) 2013 Nathan Borror. All rights reserved.
//

@import UIKit;
@import QuartzCore;

@protocol ScrapCellDelegate;

@interface ScrapCell : UITableViewCell

@property (nonatomic, weak) id<ScrapCellDelegate> delegate;

@end

@protocol ScrapCellDelegate <NSObject>

- (void)scrapRemoved:(ScrapCell *)cell;

@end
