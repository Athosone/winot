//
//  WOTDisplayUserCommentViewController.m
//  Wineot
//
//  Created by Werck Ayrton on 12/02/2015.
//  Copyright (c) 2015 wineot. All rights reserved.
//

#import "WOTDisplayUserCommentViewController.h"

@interface WOTDisplayUserCommentViewController ()

@end

@implementation WOTDisplayUserCommentViewController

@synthesize user; @synthesize com;

- (void)viewDidLoad {
    [super viewDidLoad];
    self.userName.text = self.user;
    self.comment.text = self.com;
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
