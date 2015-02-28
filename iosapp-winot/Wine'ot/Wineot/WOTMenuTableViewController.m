//
//  WOTMenuTableViewController.m
//  Wineot
//
//  Created by Werck Ayrton on 28/12/2014.
//  Copyright (c) 2014 wineot. All rights reserved.
//

#import "WOTMenuTableViewController.h"

@interface WOTMenuTableViewController ()

@end

@implementation WOTMenuTableViewController

- (id) init
{
    self                  = [[UIStoryboard storyboardWithName:@"Main" bundle:nil]
            instantiateViewControllerWithIdentifier:@"menuTableViewController"];
    if (self)
        return self;
    else
        return nil;
}


- (void)viewDidLoad {
    [super viewDidLoad];

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;

    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 3;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];

    // Configure the cell...

    return cell;
}


@end
