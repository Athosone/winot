//
//  WOTDisplayBottleTableTableViewController.h
//  Wineot
//
//  Created by Werck Ayrton on 25/01/2015.
//  Copyright (c) 2015 wineot. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WOTBottle.h"

@class WOTCellRatingBottle;
@protocol WOTCellRatingBottleProtocol <NSObject>

- (void) didClickOnAddCommentImage:(WOTCellRatingBottle*)cell;
- (void) didClickOnAddFavoriteImage:(WOTCellRatingBottle*)cell;

@end

@class WOTCellDispComment;
@class WOTCellListComment;
@protocol WOTCellDispCommentProtocol <NSObject>

- (void) didClickOnCellListComment:(WOTCellListComment*)cell;

@end

@interface WOTDisplayBottleTableTableViewController : UIViewController<UITableViewDataSource, UITableViewDelegate, WOTCellRatingBottleProtocol, WOTCellDispCommentProtocol, UIViewControllerTransitioningDelegate>

@property (strong, nonatomic) NSString          *idWine;

@end
