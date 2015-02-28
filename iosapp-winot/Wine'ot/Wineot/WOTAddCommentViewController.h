//
//  WOTAddCommentViewController.h
//  Wineot
//
//  Created by Werck Ayrton on 02/02/2015.
//  Copyright (c) 2015 wineot. All rights reserved.
//

#import <UIKit/UIKit.h>

@class WOTAddCommentCell;
@protocol WOTAddCommentCellProtocol <NSObject>
- (void) didClickOnValidateButton:(NSString*)comment rank:(float)rank;
@end


@interface WOTAddCommentViewController : UIViewController<UITableViewDataSource, UITableViewDelegate, WOTAddCommentCellProtocol>
@property (strong, nonatomic) NSString      *idWine;

@end
