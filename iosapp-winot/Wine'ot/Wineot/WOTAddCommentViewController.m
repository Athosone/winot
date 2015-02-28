//
//  WOTAddCommentViewController.m
//  Wineot
//
//  Created by Werck Ayrton on 02/02/2015.
//  Copyright (c) 2015 wineot. All rights reserved.
//

#import <MBProgressHUD/MBProgressHUD.h>
#import "WOTAddCommentViewController.h"
#import "ParallaxHeaderView.h"
#import "WOTBottle.h"
#import <RateView/RateView.h>
#import "WOTHelperConstants.h"
#import "WOTWineClient.h"
#import "WOTManagedObject.h"

#pragma mark -> Cells

@interface WOTAddCommentCell : UITableViewCell

@property (strong, nonatomic) IBOutlet UIView *ratingView;
@property (strong, nonatomic) IBOutlet UITextView *textViewComment;
@property (weak, nonatomic)     id <WOTAddCommentCellProtocol> delegate;
@property (strong, nonatomic) IBOutlet UIButton *buttonValidate;
@property (strong, nonatomic) UITextView                               *activeField;
@property (weak, nonatomic)   UITableView                               *tableView;

- (IBAction)validateCommentRatingOnClick:(id)sender;
- (void) initDesign;

@end

@implementation WOTAddCommentCell

@synthesize tableView;

- (void) initDesign
{
    self.textViewComment.layer.cornerRadius = 2.0f;
    self.textViewComment.layer.borderWidth = 3.0f;
    self.textViewComment.layer.borderColor = [WOTHelperConstants getRedColorApp].CGColor;
    
}

- (void) initAddCommentCell
{
    [self initDesign];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    
    RateView *rv = [RateView rateViewWithRating:5.0f];
    rv.canRate = TRUE;
    rv.starNormalColor = [WOTHelperConstants getWhiteColorApp];
    rv.starFillColor = [WOTHelperConstants getRedColorApp];
    rv.starBorderColor = [WOTHelperConstants getRedColorApp];
    rv.starFillMode = StarFillModeHorizontal;
    rv.autoresizingMask = (UIViewAutoresizingFlexibleLeftMargin   |
                           UIViewAutoresizingFlexibleRightMargin  |
                           UIViewAutoresizingFlexibleTopMargin    |
                           UIViewAutoresizingFlexibleBottomMargin);
    [self.ratingView addSubview:rv];
    
    rv.center = self.ratingView.center;
    //Adjust Keyboard
    [self registerForKeyboardNotifications];
    self.activeField = self.textViewComment;
}

-(BOOL)textFieldShouldReturn:(UITextView *)textView
{
    [textView resignFirstResponder];
    return YES;
}

- (IBAction)validateCommentRatingOnClick:(id)sender
{
    RateView *rv = (RateView*)[self.ratingView.subviews objectAtIndex:0];
    
    [self.delegate didClickOnValidateButton:self.textViewComment.text rank:rv.rating];
}


#pragma mark ->Adjust Keyboard

- (void)registerForKeyboardNotifications
{
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWasShown:)
                                                 name:UIKeyboardDidShowNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillBeHidden:)
                                                 name:UIKeyboardWillHideNotification object:nil];
    
}


// Called when the UIKeyboardDidShowNotification is sent.
- (void)keyboardWasShown:(NSNotification*)aNotification
{
    NSDictionary* info = [aNotification userInfo];
    CGSize kbSize = [[info objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue].size;
    
    UIEdgeInsets contentInsets = UIEdgeInsetsMake(0.0, 0.0, kbSize.height, 0.0);
    self.tableView.contentInset = contentInsets;
    self.tableView.scrollIndicatorInsets = contentInsets;
    
    // If active text field is hidden by keyboard, scroll it so it's visible
    // Your app might not need or want this behavior.
    CGRect aRect = self.tableView.superview.frame;
    aRect.size.height -= kbSize.height;
    if (!CGRectContainsPoint(aRect, self.activeField.frame.origin) ) {
        [self.tableView scrollRectToVisible:self.activeField.frame animated:YES];
    }
}

// Called when the UIKeyboardWillHideNotification is sent
- (void)keyboardWillBeHidden:(NSNotification*)aNotification
{
    UIEdgeInsets contentInsets = UIEdgeInsetsZero;
    self.tableView.contentInset = contentInsets;
    self.tableView.scrollIndicatorInsets = contentInsets;
}




@end

#pragma mark ->ViewController

@interface WOTAddCommentViewController ()

@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) MBProgressHUD                              *hud;
- (IBAction)closeVc:(id)sender;
@property (strong, nonatomic) WOTBottle *currentBottle;
@end

@implementation WOTAddCommentViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.tableView.tableFooterView = [[UIView alloc]initWithFrame:CGRectZero];
    CGSize sizeOfImage = CGSizeMake(self.tableView.frame.size.width, 100);
    
    //Init Activity indicator
    self.hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    self.hud.hidden = TRUE;
    self.hud.labelText = NSLocalizedString(@"Loading...", nil);
    //InitNavController
    self.navigationController.navigationBar.barTintColor = [WOTHelperConstants getRedColorApp];
    UIBarButtonItem     *cancel = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"Cancel", nil)
                                                                   style:UIBarButtonItemStyleDone target:self action:@selector(closeVC)];
    
    self.navigationItem.leftBarButtonItem = cancel;
    //Init current bottle
    self.currentBottle = [WOTBottle MR_findFirstByAttribute:@"idWine" withValue:self.idWine];
    //Init Parallax and setup
    UIImage *image = [UIImage imageWithData:self.currentBottle.image];
    ParallaxHeaderView *headerView = [ParallaxHeaderView parallaxHeaderViewWithImage:image forSize:sizeOfImage];
    [self.tableView setTableHeaderView:headerView];
   
    //The View
    //self.view.layer.cornerRadius = 8.f;
    //self.view.layer.borderWidth = 2.0f;
    //self.view.layer.borderColor = [WOTHelperConstants getRedColorApp].CGColor;
   // self.tableView.layer.cornerRadius = 8.0f;
    [self.view layoutSubviews];
}

- (void) closeVC
{
    [self dismissViewControllerAnimated:YES completion:^{ NSLog(@"controller dismissed"); }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void) viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [(ParallaxHeaderView *)self.tableView.tableHeaderView refreshBlurViewForNewImage];
}

#pragma mark -> Table view delegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (scrollView == self.tableView)
    {
        [(ParallaxHeaderView*)self.tableView.tableHeaderView layoutHeaderViewForScrollViewOffset:scrollView.contentOffset];
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return 1;
}

-(UITableViewCell *)tableView:(UITableView *)mtableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0)
    {
        WOTAddCommentCell *lRet = [mtableView dequeueReusableCellWithIdentifier:@"WOTAddCommentCell" forIndexPath:indexPath];
        [lRet initAddCommentCell];
        [lRet setDelegate:self];
        lRet.tableView = self.tableView;
        return lRet;
    }
    return nil;
}

#pragma mark Cell AddComment protocol

- (void) didClickOnValidateButton:(NSString *)comment rank:(float)rank
{
    self.hud.hidden = FALSE;
    void (^success)() = ^()
    {
        self.hud.hidden = TRUE;
        self.currentBottle.isOwnerCommented = TRUE;
        [WOTManagedObject saveContext];
        NSNotification *notfication = [[NSNotification alloc] initWithName:@"commentUpdated" object:nil userInfo:nil];
        [[NSNotificationCenter defaultCenter] postNotification:notfication];
        [self closeVC];
    };
    void (^fail)(NSDictionary* dict) = ^(NSDictionary *dict)
    {
        self.hud.hidden = TRUE;
        NSLog(@"Error when trying to comment wine: %@ Status code %@", [dict objectForKey:@"errorRequest"], [dict objectForKey:@"errorStatusCode"]);
    };
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] initWithCapacity:3];
    
    [dict setValue:comment forKey:@"comment"];
    [dict setValue:[NSNumber numberWithFloat:rank] forKey:@"rank"];
    [dict setValue:self.currentBottle.idWine forKey:@"idWine"];
    [WOTWineClient addComment:dict success:success fail:fail];
}

- (IBAction)closeVc:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:^{ NSLog(@"controller dismissed"); }];
}

@end
