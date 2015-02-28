//
//  WOTDisplayBottleTableTableViewController.m
//  Wineot
//
//  Created by Werck Ayrton on 25/01/2015.
//  Copyright (c) 2015 wineot. All rights reserved.
//

#import <RateView.h>
#import <MBProgressHUD/MBProgressHUD.h>
#import <QuartzCore/QuartzCore.h>

#import "CustomModalAnimation.h"
#import "WOTDisplayUserCommentViewController.h"
#import "ParallaxHeaderView.h"
#import "WOTDisplayBottleTableTableViewController.h"
#import "WOTHelperConstants.h"
#import "WOTManagedObject.h"
#import "WOTWineClient.h"
#import "WOTAddCommentViewController.h"

#define CELLCORNER  5.0f;

//Attention dans les ratingVIew desfois j'oublies de les remove de la superview ce qui fait qu'elles se stack... et ça fait pas beau

#define WOTCellListCommentRowHeight     100


#pragma mark - WOTCellListComment
@interface WOTCellListComment : UITableViewCell

@property (strong, nonatomic) IBOutlet UIImageView *imageUserProfile;
@property (strong, nonatomic) IBOutlet UILabel *labelComment;
@property (strong, nonatomic) IBOutlet UILabel *labelUsername;
@property (strong, nonatomic) IBOutlet UIView *ratingView;

- (NSString*) getUserComment;
- (NSString*) getUserName;

@end

@implementation WOTCellListComment


- (void) initWOTCellListComment:(WOTComment*)comment
{
    self.selectionStyle                                   = UITableViewCellSelectionStyleNone;
    self.imageUserProfile.image                           = [UIImage imageNamed:@"defaultAccount"];
    if (comment)
    {
        if (self.ratingView.subviews.count > 0 && [self.ratingView.subviews objectAtIndex:0])
            [[self.ratingView.subviews objectAtIndex:0] removeFromSuperview];
       
        self.labelComment.text                                = comment.comment;
        self.labelUsername.text                               = comment.user_login;
        RateView *rv                                          = [RateView rateViewWithRating:[comment.rank floatValue]];
        rv.canRate                                            = FALSE;
        rv.starNormalColor                                    = [WOTHelperConstants getWhiteColorApp];
        rv.starFillColor                                      = [WOTHelperConstants getRedColorApp];
        rv.starBorderColor                                    = [WOTHelperConstants getRedColorApp];
        rv.starFillMode                                       = StarFillModeVertical;
        rv.center                                             = CGPointMake(self.ratingView.bounds.size.width/2 + rv.frame.size.width/5, self.ratingView.bounds.size.height/2);
        [self.ratingView addSubview:rv];
    }
}

/**
 *  Get the username display on the cell's labelUsername
 *
 *  @return NSString *username
 */
- (NSString*) getUserName
{
    return self.labelUsername.text;
}

/**
 *  Get the comment written by an user on the cell's labelComment
 *
 *  @return return NSString *comment
 */
- (NSString*) getUserComment
{
    return self.labelComment.text;
}


@end

#pragma mark - WOTCellDispComment

@interface WOTCellDispComment : UITableViewCell<UITableViewDataSource, UITableViewDelegate>

@property (strong, nonatomic) IBOutlet UILabel *labelListComment;
@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) NSArray   *comments;
@property (strong, nonatomic) MBProgressHUD *hud;
@property (strong, nonatomic) NSString *idWine;
@property (weak, nonatomic) id <WOTCellDispCommentProtocol>        delegate;

- (void) initWOTCellDispComment:(NSString*)idWine comments:(NSArray*)comments;

@end


@implementation WOTCellDispComment

- (void) initWOTCellDispComment:(NSString *)idWinepar comments:(NSArray*)comments
{
    self.idWine = idWinepar;
    self.comments                                         = comments;
    self.tableView.tableFooterView                        = [[UIView alloc]initWithFrame:CGRectZero];
    self.tableView.scrollEnabled                          = NO;
    [self.tableView reloadData];
#warning useless???
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(commentUpdated) name:@"commentUpdated" object:nil];
}

- (void) commentUpdated
{
    self.comments = [WOTManagedObject getCommentsByWineId:self.idWine];
    [self.tableView reloadData];
}

#pragma mark ->WOTCellDispComment-Data source


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    if (self.comments.count > 0)
        return self.comments.count;
    return 1;
}


- (UITableViewCell *)tableView:(UITableView *)mtableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    WOTCellListComment *lRet                              = [mtableView dequeueReusableCellWithIdentifier:@"WOTCellListComment"];
    if (lRet == nil)
    {
        lRet                                                  = [[WOTCellListComment alloc] init];
        [lRet initWOTCellListComment:(WOTComment*)[self.comments objectAtIndex:indexPath.row]];
        return lRet;
    }
    else
    {
        if (self.comments && self.comments.count > 0)
            [lRet initWOTCellListComment:(WOTComment*)[self.comments objectAtIndex:indexPath.row]];
        else
            [lRet initWOTCellListComment:nil];
        
    }
    return lRet;
}

- (void)tableView:(UITableView *)mtableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    WOTCellListComment      *cell = (WOTCellListComment*)[mtableView cellForRowAtIndexPath:indexPath];
    
    [self.delegate didClickOnCellListComment:cell];
}

@end

#pragma mark - WOTCellRatingBottle

@interface WOTCellRatingBottle : UITableViewCell

@property (strong, nonatomic) IBOutlet UIView *ratingView;
@property (strong, nonatomic) IBOutlet UILabel *labelAddComment;
@property (strong, nonatomic) IBOutlet UILabel *labelAddFavorite;
@property (strong, nonatomic) IBOutlet UIView *viewSep2;
@property (strong, nonatomic) IBOutlet UIView *viewSep1;

@property (strong, nonatomic) IBOutlet UIImageView *imageFavIcon;
@property (strong, nonatomic) IBOutlet UIImageView *imageCommentIcon;
@property (readwrite, nonatomic) BOOL                  isFav;
@property (weak, nonatomic)     id <WOTCellRatingBottleProtocol> delegate;


- (void)initCellRatingBottle;

@end

@implementation WOTCellRatingBottle

#pragma mark ->Init Cell RatingBottle

- (void)initCellRatingBottle
{
    self.backgroundColor = [UIColor clearColor];
    self.layer.cornerRadius = CELLCORNER;
    self.clipsToBounds = YES;
    
    RateView *rv                                          = [RateView rateViewWithRating:5.0f];
    rv.canRate                                            = TRUE;
    rv.starNormalColor                                    = [WOTHelperConstants getWhiteColorApp];
    rv.starFillColor                                      = [WOTHelperConstants getRedColorApp];
    rv.starBorderColor                                    = [WOTHelperConstants getRedColorApp];
    rv.starFillMode                                       = StarFillModeAxial;
  //  rv.center                                             = CGPointMake(self.ratingView.bounds.size.width/2 + rv.frame.size.width/5, self.ratingView.bounds.size.height/2);
   
    rv.autoresizingMask = (UIViewAutoresizingFlexibleLeftMargin   |
                           UIViewAutoresizingFlexibleRightMargin  |
                           UIViewAutoresizingFlexibleTopMargin    |
                           UIViewAutoresizingFlexibleBottomMargin);
    
    rv.center = self.ratingView.center;
    [self.ratingView addSubview:rv];
    self.labelAddComment.text                             = NSLocalizedString(@"Add a comment", @"");
    self.labelAddFavorite.text                            = NSLocalizedString(@"Add to favortie", @"");
    self.viewSep1.layer.cornerRadius                      = 5;
    self.viewSep2.layer.cornerRadius                      = 5;
    self.selectionStyle                                   = UITableViewCellSelectionStyleNone;
    UITapGestureRecognizer *favoriteImageTap              = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(favTapGesture)];
    [self.imageFavIcon addGestureRecognizer:favoriteImageTap];
    UITapGestureRecognizer *commentImageTap               = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(commentTapGesture)];
    UITapGestureRecognizer *starTapped                      = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(commentTapGesture)];

    [self.imageCommentIcon addGestureRecognizer:commentImageTap];
    [self.ratingView addGestureRecognizer:starTapped];
}

- (void) commentTapGesture
{
    [self.delegate didClickOnAddCommentImage:self];
}

- (void) favTapGesture
{
    [self.delegate didClickOnAddFavoriteImage:self];
}

@end

#pragma mark - MainViewController

@interface WOTDisplayBottleTableTableViewController ()

@property (strong, nonatomic) MBProgressHUD                              *hud;

@property   (strong, nonatomic) WOTBottle *currentBottle;

@property (strong, nonatomic) IBOutlet UITableView *tableView;

@property (strong, nonatomic) NSString          *userNameComment;
@property (strong, nonatomic) NSString          *userComment;

- (void) initRateWineCell:(WOTCellRatingBottle*)cellRate;

@end

@implementation WOTDisplayBottleTableTableViewController

@synthesize tableView;
@synthesize currentBottle;

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    //Init current bottle
    self.currentBottle                                    = [WOTBottle MR_findFirstByAttribute:@"idWine" withValue:self.idWine];
    
    self.tableView.tableFooterView                        = [[UIView alloc]initWithFrame:CGRectZero];
    NSLog(@"View Frame width: %f, TableView Width: %f", self.view.frame.size.width, self.tableView.frame.size.width);
    
    CGSize sizeOfImage                                    = CGSizeMake(self.view.frame.size.width, 300);
    
    //Init Parallax and setup
    UIImage *image                                        = [UIImage imageWithData:self.currentBottle.image];
    ParallaxHeaderView *headerView                        = [ParallaxHeaderView parallaxHeaderViewWithImage:image forSize:sizeOfImage];
    [headerView setFrame:CGRectMake(self.tableView.bounds.origin.x, self.tableView.bounds.origin.y, self.view.bounds.size.width, 300)];
    [self.tableView setTableHeaderView:headerView];
    
    //Init Activity indicator
    self.hud                                              = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    self.hud.hidden                                       = TRUE;
    self.hud.labelText                                    = NSLocalizedString(@"Loading...", nil);
    
    //Notification to add bottle to LFWineView
    NSNotification* notification                          = [NSNotification notificationWithName:@"newWineTagged" object:self];
    [[NSNotificationCenter defaultCenter] postNotification:notification];
    
    self.navigationController.navigationBar.topItem.title = self.currentBottle.nameCurrentBottle;
    [self.view layoutSubviews];
}

-(void) viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [(ParallaxHeaderView *)self.tableView.tableHeaderView refreshBlurViewForNewImage];
    //Get comments
    void (^success)() = ^()
    {
     //   self.hud.hidden = TRUE;
        NSIndexPath* rowToReload = [NSIndexPath indexPathForRow:1 inSection:0];
        NSArray* rowsToReload = [NSArray arrayWithObjects:rowToReload, nil];
        [self.tableView reloadRowsAtIndexPaths:rowsToReload withRowAnimation:UITableViewRowAnimationFade];
       // WOTCellDispComment *cell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]]
    };
    void (^fail)(NSDictionary* dict)                      = ^(NSDictionary *dict)
    {
        NSLog(@"Error when trying to loadComments wine: %@ Status code %@", [dict objectForKey:@"errorRequest"], [dict objectForKey:@"errorStatusCode"]);
    };
    
    [WOTWineClient getCommentWine:self.idWine success:success fail:fail];
}


- (void) dealloc
{
    self.tableView.delegate                               = nil;
}

#pragma mark ->MainTable view delegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (scrollView == self.tableView)
    {
        [(ParallaxHeaderView*)self.tableView.tableHeaderView layoutHeaderViewForScrollViewOffset:scrollView.contentOffset];
    }
}


#pragma mark ->MainTable view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return 2;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    float lRet = 145.0f;
    if (indexPath.row == 1)
    {
        lRet = [WOTManagedObject getNumberOfCommentsForWine:self.idWine] * 100.0f + 30.0f;
        return lRet;
    }
    return lRet;
}

#pragma mark ->Cells Delegate

- (void) didClickOnAddFavoriteImage:(WOTCellRatingBottle*)cell
{
    BOOL isFavorite                                       = self.currentBottle.isOwnerFavorite;
    self.hud.hidden                                       = FALSE;
    void (^successRequest)()                              = ^()
    {
        self.hud.hidden                                       = TRUE;
        NSLog (@"saved");
        if (isFavorite)
            self.currentBottle.isOwnerFavorite                    = NO;
        else
            self.currentBottle.isOwnerFavorite                    = YES;
        
        if (self.currentBottle.isOwnerFavorite)
            cell.imageFavIcon.image                               = [UIImage imageNamed:@"favIcon"];
        else
            cell.imageFavIcon.image                               = [UIImage imageNamed:@"emptyFavIcon"];
        
        [WOTManagedObject saveContext];
        NSNotification* notification                          = [NSNotification notificationWithName:@"newWineTagged" object:self];
        [[NSNotificationCenter defaultCenter] postNotification:notification];
    };
    void (^fail)(NSDictionary* dict)                      = ^(NSDictionary *dict)
    {
        NSLog(@"Error when trying to fav wine: %@ Status code %@", [dict objectForKey:@"errorRequest"], [dict objectForKey:@"errorStatusCode"]);
    };
    if (isFavorite)
        [WOTWineClient setFavorite:self.currentBottle.idWine isFavorite:NO success:successRequest fail:fail];
    else
        [WOTWineClient setFavorite:self.currentBottle.idWine isFavorite:YES success:successRequest fail:fail];
}

- (void) didClickOnAddCommentImage:(WOTCellRatingBottle*)cell
{
    WOTAddCommentViewController *addComVC = [[self storyboard] instantiateViewControllerWithIdentifier:@"addCommentViewController"];
    
    addComVC.transitioningDelegate = self;
    addComVC.modalPresentationStyle = UIModalPresentationCustom;
    addComVC.idWine = self.currentBottle.idWine;

    [self.navigationController presentViewController:addComVC animated:YES completion:nil];

    
    //[self performSegueWithIdentifier:@"addComment" sender:self];
}

- (void) didClickOnCellListComment:(WOTCellListComment*)cell
{
    self.userNameComment = [cell getUserName];
    self.userComment = [cell getUserComment];
    [self performSegueWithIdentifier:@"WOTDisplayUserCommentViewController" sender:self];
}


#pragma mark ->UIViewControllerTransitionDelegate

- (id <UIViewControllerAnimatedTransitioning>)animationControllerForPresentedController:(UIViewController *)presented presentingController:(UIViewController *)presenting sourceController:(UIViewController *)source
{
    return [[PresentingAnimationController alloc] init];
}

- (id <UIViewControllerAnimatedTransitioning>)animationControllerForDismissedController:(UIViewController *)dismissed
{
    return [[DismissingAnimationController alloc] init];
}

#pragma mark ->Main TableView

- (void) initRateWineCell:(WOTCellRatingBottle*)lRet
{
    [lRet initCellRatingBottle];
    [lRet setDelegate:self];
    
    if (self.currentBottle.isOwnerFavorite)
        lRet.imageFavIcon.image                               = [UIImage imageNamed:@"favIcon"];
}


- (UITableViewCell *)tableView:(UITableView *)mtableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0)
    {
        WOTCellRatingBottle *lRet                             = [mtableView dequeueReusableCellWithIdentifier:@"WOTCellRatingBottle"];
        if (lRet == nil)
            lRet                                                  = [[WOTCellRatingBottle alloc] init];
        //A finir
        [self initRateWineCell:lRet];
        
        return lRet;
    }
    else if (indexPath.row == 1)
    {
        WOTCellDispComment *lRet                              = [mtableView dequeueReusableCellWithIdentifier:@"WOTCellDispComment"];
        if (lRet == nil)
            lRet                                                  = [[WOTCellDispComment alloc] init];
        //A finir
        [lRet initWOTCellDispComment:self.idWine comments:[WOTManagedObject getCommentsByWineId:self.idWine]];
        [lRet setDelegate:self];
        return lRet;
    }
    return nil;
}

- (void)tableView:(UITableView *)mtableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0)
    {
        if (self.currentBottle.isOwnerFavorite)
            NSLog(@"UnFav action");
        else
            NSLog(@"Fav action");
    }
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqual:@"addComment"])
    {
        UINavigationController *navC                          = [segue destinationViewController];
        WOTAddCommentViewController *dest                     = [[navC viewControllers] objectAtIndex:0];
        dest.idWine                                           = self.currentBottle.idWine;
    }
    else if ([[segue identifier] isEqual:@"WOTDisplayUserCommentViewController"])
    {
        UINavigationController *navC                          = [segue destinationViewController];
        WOTDisplayUserCommentViewController *dest                     = [[navC viewControllers] objectAtIndex:0];
        dest.user = self.userNameComment;
        dest.com = self.userComment;
        self.userComment = nil;
        self.userNameComment = nil;
    }
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
