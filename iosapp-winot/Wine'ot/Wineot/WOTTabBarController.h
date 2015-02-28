//
//  WOTTabBarController.h
//  Wine'ot
//
//  Created by Werck Ayrton on 04/11/2014.
//  Copyright (c) 2014 wineot. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WOTWineClient.h"
#import "WOTSearchWineViewController.h"
#import "WOTCameraViewController.h"
#import "WOTHelperConstants.h"
#import "WOTDisplayBottleTableTableViewController.h"

@interface WOTTabBarController : UITabBarController

@property (strong, nonatomic) WOTWineClient *client;


@end
