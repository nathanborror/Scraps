//
//  ScrapCell.m
//  Scraps
//
//  Created by Nathan Borror on 7/15/13.
//  Copyright (c) 2013 Nathan Borror. All rights reserved.
//

#import "ScrapCell.h"

#define PINK [UIColor colorWithRed:.99 green:.29 blue:.40 alpha:1]
#define BLUE [UIColor colorWithRed:.06 green:.64 blue:.88 alpha:1]

static const CGFloat kSearchThreshold = 80.0;
static const CGFloat kFeelinLuckyThreshold = 140.0;
static const CGFloat kTrashThreshold = -80.0;
static const CGFloat kDividerHeight = .5;

@interface ScrapCell () <UIGestureRecognizerDelegate>
@end

@implementation ScrapCell {
  UIView *_divider;
  UIImageView *_spyglass;
  UIImageView *_trash;
  CGPoint _beginSwipePosition;
  UIDynamicAnimator *_animator;
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
  if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
    [self setBackgroundColor:BLUE];
    [self.textLabel setTextColor:[UIColor whiteColor]];

    _spyglass = [[UIImageView alloc] initWithFrame:CGRectMake(-CGRectGetHeight(self.bounds), 0, CGRectGetHeight(self.bounds), CGRectGetHeight(self.bounds))];
    [_spyglass setImage:[UIImage imageNamed:@"Spyglass"]];
    [_spyglass setContentMode:UIViewContentModeCenter];
    [self addSubview:_spyglass];

    _trash = [[UIImageView alloc] initWithFrame:CGRectMake(CGRectGetWidth(self.bounds), 0, CGRectGetHeight(self.bounds), CGRectGetHeight(self.bounds))];
    [_trash setImage:[UIImage imageNamed:@"Remove"]];
    [_trash setContentMode:UIViewContentModeCenter];
    [self addSubview:_trash];

    _divider = [[UIView alloc] initWithFrame:CGRectMake(1, CGRectGetMaxY(self.bounds)-kDividerHeight, CGRectGetWidth(self.bounds), kDividerHeight)];
    [_divider setBackgroundColor:[UIColor colorWithWhite:1 alpha:.2]];
    [_divider setAutoresizingMask:UIViewAutoresizingFlexibleWidth];
    [self addSubview:_divider];

    UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(swipe:)];
    [pan setDelegate:self];
    [pan setMaximumNumberOfTouches:1];
    [self addGestureRecognizer:pan];

    _animator = [[UIDynamicAnimator alloc] initWithReferenceView:self];
  }
  return self;
}

- (void)layoutSubviews
{
  [super layoutSubviews];
  [_divider setFrame:CGRectOffset(_divider.bounds, 1, CGRectGetMaxY(self.bounds)-kDividerHeight)];
  [_spyglass setFrame:CGRectMake(-CGRectGetHeight(self.bounds), 0, CGRectGetHeight(self.bounds), CGRectGetHeight(self.bounds))];
  [_trash setFrame:CGRectMake(CGRectGetWidth(self.bounds), 0, CGRectGetHeight(self.bounds), CGRectGetHeight(self.bounds))];
}

- (void)setHighlighted:(BOOL)highlighted animated:(BOOL)animated
{
  // Do nothing for now
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
  // Do nothing for now
}

#pragma mark - UIPanGestureRecognizer

- (void)swipe:(UIGestureRecognizer *)recognizer
{
  CGPoint current = [recognizer locationInView:self.superview];
  
  if (recognizer.state == UIGestureRecognizerStateBegan) {
    _beginSwipePosition = current;
  }

  if (recognizer.state == UIGestureRecognizerStateChanged) {
    CGFloat xPosition = current.x - _beginSwipePosition.x;
    [self setFrame:CGRectOffset(self.bounds, xPosition, self.frame.origin.y)];

    // Search gesture
    if (xPosition > kFeelinLuckyThreshold) {
      [_spyglass setImage:[UIImage imageNamed:@"SpyglassStarHighlighted"]];
    } else if (xPosition > kSearchThreshold) {
      [_spyglass setImage:[UIImage imageNamed:@"SpyglassHighlighted"]];
    } else {
      [_spyglass setImage:[UIImage imageNamed:@"Spyglass"]];
    }

    // Trash gesture
    if (xPosition < kTrashThreshold) {
      [_trash setImage:[UIImage imageNamed:@"RemoveHighlighted"]];
    } else {
      [_trash setImage:[UIImage imageNamed:@"Remove"]];
    }
  }

  if (recognizer.state == UIGestureRecognizerStateEnded) {
    CGFloat xPosition = current.x - _beginSwipePosition.x;

    if (xPosition > kSearchThreshold) {
      // Perform search with cell contents
      NSString *urlString = [NSString stringWithFormat:@"http://www.google.com/search?q=%@", self.textLabel.text];
      urlString = [urlString stringByReplacingOccurrencesOfString:@" " withString:@"+"];
      if (xPosition > kFeelinLuckyThreshold) {
        urlString = [NSString stringWithFormat:@"%@+site:wikipedia.org", urlString];
      }
      [[UIApplication sharedApplication] openURL:[NSURL URLWithString:urlString]];

      [UIView animateWithDuration:.8 delay:0 usingSpringWithDamping:.6 initialSpringVelocity:.2 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        [self setFrame:CGRectOffset(self.bounds, 0, self.frame.origin.y)];
      } completion:nil];
    } else if (xPosition < kTrashThreshold) {
      // Trash cell
      [UIView animateWithDuration:.3 animations:^{
        [self setFrame:CGRectOffset(self.bounds, -(CGRectGetWidth(self.bounds)), self.frame.origin.y)];
        [self setAlpha:0];
      } completion:^(BOOL finished) {
        [self setHidden:YES];
        if (_delegate) {
          [_delegate scrapRemoved:self];
        }
      }];
    } else {
      // Return to resting place
      [UIView animateWithDuration:.8 delay:0 usingSpringWithDamping:.6 initialSpringVelocity:.2 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        [self setFrame:CGRectOffset(self.bounds, 0, self.frame.origin.y)];
      } completion:nil];
    }
  }
}

#pragma mark - UIGestureRecognizer

- (BOOL)gestureRecognizerShouldBegin:(UIPanGestureRecognizer *)recognizer
{
  if ([recognizer isKindOfClass:[UIPanGestureRecognizer class]]) {
    UIView *cell = recognizer.view;
    CGPoint translation = [recognizer translationInView:cell.superview];

    // Check for horizontal gesture
    if ([recognizer velocityInView:cell].x < 600 && sqrt(translation.x * translation.x)) {
      return YES;
    }
  }
  return NO;
}

@end
