//
//  WOTSearchWineViewController.h
//  Wineot
//
//  Created by Werck Ayrton on 26/01/2015.
//  Copyright (c) 2015 wineot. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WOTWineClient.h"

@interface WOTSearchWineViewController : UIViewController<UITableViewDelegate, UITableViewDataSource>

@property (strong, nonatomic) IBOutlet UITableView  *searchBar;

@property (strong, nonatomic) IBOutlet UITableView  *tableView;
@property (strong, nonatomic) WOTWineClient         *client;
@property (strong, nonatomic) NSString              *idWine;
@end
