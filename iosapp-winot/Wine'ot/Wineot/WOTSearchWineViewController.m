//
//  WOTSearchWineViewController.m
//  Wineot
//
//  Created by Werck Ayrton on 26/01/2015.
//  Copyright (c) 2015 wineot. All rights reserved.
//

#import "WOTSearchWineViewController.h"
#import "WOTManagedObject.h"
#import "WOTDisplayBottleTableTableViewController.h"

@interface WOTCellHistory : UITableViewCell

@property (strong, nonatomic) IBOutlet UILabel *labelNameOfBottle;
@property (strong, nonatomic) IBOutlet UIImageView *imageOfBottle;
@property (strong, nonatomic) IBOutlet UILabel *datePictureTaken;
@end

@implementation WOTCellHistory

@synthesize labelNameOfBottle; @synthesize imageOfBottle; @synthesize datePictureTaken;

@end


@interface WOTSearchWineViewController ()

@property  (strong, nonatomic)  NSArray *bottles;

@end

@implementation WOTSearchWineViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    self.bottles = [WOTBottle MR_findAllSortedBy:@"lastUpdated" ascending:NO];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(newWineTagged) name:@"newWineTagged" object:nil];
}



- (void) newWineTagged
{
    self.bottles = [WOTBottle MR_findAllSortedBy:@"lastUpdated" ascending:NO];
    [self.tableView reloadData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.bottles.count;
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"DisplayWineFromLF"])
    {
        UINavigationController *navController = (UINavigationController*)[segue destinationViewController];
        WOTDisplayBottleTableTableViewController *dispVc = (WOTDisplayBottleTableTableViewController*)[[navController viewControllers] objectAtIndex:0];
        if (dispVc)
            dispVc.idWine = self.idWine;
        else
            NSLog(@"reason of crash?");
    }
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    WOTCellHistory *cell = (WOTCellHistory*)[tableView cellForRowAtIndexPath:indexPath];
    WOTBottle *bottle = [WOTManagedObject getBottleByName:cell.labelNameOfBottle.text];
    NSLog(@"cell label %@", cell.labelNameOfBottle.text);
    if (!bottle || bottle.nameCurrentBottle.length == 0)
    {
        if (!bottle)
            NSLog(@"Error fetching bottle....bottle null");
        else
            NSLog(@"Error fetching bottle....name null");
    }
    else
    {
        self.idWine = bottle.idWine;
        [self performSegueWithIdentifier:@"DisplayWineFromLF" sender:self];
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    WOTCellHistory *cell = [tableView dequeueReusableCellWithIdentifier:@"wine" forIndexPath:indexPath];
    
    WOTBottle *bottleToDispInCell = [self.bottles objectAtIndex:indexPath.row];
    if (self.bottles.count == 0)
        return cell;
    cell.labelNameOfBottle.text = bottleToDispInCell.nameCurrentBottle;
    NSDateFormatter *dateformatter = [NSDateFormatter new];
    [dateformatter setDateFormat:@"dd/MM"];
    NSLog(@"Data bottle:%@, date formater: %@", bottleToDispInCell.createdDate, [dateformatter stringFromDate:bottleToDispInCell.createdDate]);
    cell.datePictureTaken.text = [NSLocalizedString(@"Added on ", @"") stringByAppendingString:[dateformatter stringFromDate:bottleToDispInCell.createdDate]];
    if (bottleToDispInCell.isOwnerFavorite)
        cell.imageOfBottle.image = [UIImage imageWithData:bottleToDispInCell.image];
    else
        cell.imageOfBottle.image = nil;
    return cell;
}

@end
