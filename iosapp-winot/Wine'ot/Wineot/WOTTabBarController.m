//
//  WOTTabBarController.m
//  Wine'ot
//
//  Created by Werck Ayrton on 04/11/2014.
//  Copyright (c) 2014 wineot. All rights reserved.
//

#import "WOTTabBarController.h"
#import "SWRevealViewController.h"
#define LFWINE      0
#define CAMERAVIEW  1
#define DISPBOTTLE  2

@interface WOTTabBarController ()

@end

@implementation WOTTabBarController

- (id) init
{
    self = [[UIStoryboard storyboardWithName:@"Main" bundle:nil]
            instantiateViewControllerWithIdentifier:@"tabBarController"];
    if (self)
        return self;
    else
        return nil;
}

//Init each viewcontrollers linked to the WOTTabBarController
- (void)viewDidLoad {
    [super viewDidLoad];
    self.tabBar.barTintColor = [WOTHelperConstants getWhiteColorApp];
    self.tabBar.tintColor =    [WOTHelperConstants getRedColorApp];


     //Init NavController
    UINavigationController *navCamera = [self.viewControllers objectAtIndex:CAMERAVIEW];
    UINavigationController *navWine = [self.viewControllers objectAtIndex:LFWINE];
    navCamera.navigationBar.barTintColor = [WOTHelperConstants getRedColorApp];
    navWine.navigationBar.barTintColor = [WOTHelperConstants getRedColorApp];

    
    //Init variables each viewcontroller that compose the tab bar with data needed
    WOTCameraViewController *cameraVC = (WOTCameraViewController*)[[navCamera viewControllers] objectAtIndex:0];
    cameraVC.client = self.client;
    WOTSearchWineViewController *searchWine = (WOTSearchWineViewController*)[[navWine viewControllers] objectAtIndex:0];
    searchWine.client = self.client;
    
    // Do any additional setup after loading the view.
    // Set the gesture
    [self.view addGestureRecognizer:self.revealViewController.panGestureRecognizer];
}

-(void) viewDidLayoutSubviews
{
    //Init graphics effect
    //[self addCenterButtonWithImage:[UIImage imageNamed:@"cameraTabBarItem.png"] highlightImage:nil];
     //  NSLog(@"tabBar : %lf, %lf", self.view.frame.size.height, self.view.frame.size.width);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
