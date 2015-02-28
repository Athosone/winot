//
//  WOTDisplayUserCommentViewController.h
//  Wineot
//
//  Created by Werck Ayrton on 12/02/2015.
//  Copyright (c) 2015 wineot. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WOTDisplayUserCommentViewController : UIViewController
@property (strong, nonatomic) IBOutlet UILabel *userName;
@property (strong, nonatomic) IBOutlet UITextView *comment;
@property (strong, nonatomic) NSString *user;
@property (strong, nonatomic) NSString *com;


@end
