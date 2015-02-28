//
//  WOTLoginViewController.m
//  Wine'ot
//
//  Created by Werck Ayrton on 02/11/2014.
//  Copyright (c) 2014 wineot. All rights reserved.
//

#import "Animations.h"
#import "WOTLoginViewController.h"
#import "WOTTabBarController.h"
#import "SWRevealViewController.h"
#import "WOTMenuTableViewController.h"

@interface WOTLoginViewController ()

//ActivityIndicator
@property (strong, nonatomic) MBProgressHUD                              *hud;
//TextField
@property (strong, nonatomic) IBOutlet                  UITextField      *loginTextField;
@property (strong, nonatomic) IBOutlet                  UITextField      *passwordTextField;
@property (strong, nonatomic) IBOutlet                  UITextField      *passwordTextField2;

//TextField init
- (void) initUITextField;

//Button
@property (strong, nonatomic) IBOutlet                  UIButton         *needAccountButton;
@property (strong, nonatomic) IBOutlet                  UIButton         *connectButton;
@property (strong, nonatomic) IBOutlet                  UIButton         *connectButton2;

//IBAction
- (IBAction)connectButtonOnClick:(id)sender;
- (IBAction)needAccountButtonOnClick:(id)sender;
- (IBAction)resignTextField:(id)sender;



@end

@implementation WOTLoginViewController

//To put in NUINSS
- (void) initUITextField
{
    UIImageView *loginImageTextField = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 25, self.loginTextField.frame.size.height - 5)];
    loginImageTextField.image = [UIImage imageNamed:@"accountLogin"];
    UIImageView *passwordImageTextField = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 25, self.loginTextField.frame.size.height - 5)];
    passwordImageTextField.image = [UIImage imageNamed:@"passwordCadenas"];
    UIImageView *passwordImageTextField2 = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 25, self.loginTextField.frame.size.height - 5)];
    passwordImageTextField2.image = [UIImage imageNamed:@"passwordCadenas"];
    
    self.loginTextField.leftView = loginImageTextField;
    self.loginTextField.leftViewMode = UITextFieldViewModeAlways;
    
    self.passwordTextField.leftView = passwordImageTextField;
    self.passwordTextField.leftViewMode = UITextFieldViewModeAlways;
    
    self.passwordTextField2.leftView = passwordImageTextField2;
    self.passwordTextField2.leftViewMode = UITextFieldViewModeAlways;
    
    UIColor *color = [UIColor whiteColor];
    self.loginTextField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:NSLocalizedString(self.loginTextField.placeholder, nil) attributes:@{NSForegroundColorAttributeName: color}];
    self.passwordTextField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:NSLocalizedString(self.passwordTextField.placeholder, nil) attributes:@{NSForegroundColorAttributeName: color}];
    self.passwordTextField2.attributedPlaceholder = [[NSAttributedString alloc] initWithString:NSLocalizedString(self.passwordTextField2.placeholder, nil) attributes:@{NSForegroundColorAttributeName: color}];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    //Init Fields
    self.loginTextField.text = @"tutu";
    self.passwordTextField.text = @"titi";
    self.connectButton2.hidden = TRUE;
    
    //Init ActivityIndicator
    self.hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    self.hud.hidden = TRUE;
    self.hud.labelText = NSLocalizedString(@"Connecting", nil);
    
    [self.loginTextField becomeFirstResponder];
    //Test
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    
    
    NSLog(@"PATH: %@", [paths objectAtIndex:0]);

    [self initUITextField];

}

- (void)didReceiveMemoryWarning {
    //TO delete
    [self performSegueWithIdentifier:@"loginSuccess" sender:self];
    [super didReceiveMemoryWarning];
}

//hide keyboard
- (IBAction)resignTextField:(id)sender
{
    [sender resignFirstResponder];
}


//prepare view changing
- (void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"loginSuccess"])
    {
        // WOTTabBarController *destViewController = segue.destinationViewController;
        WOTTabBarController *frontController = [[WOTTabBarController alloc] init];
        WOTMenuTableViewController *rearController = [[WOTMenuTableViewController alloc] init];
        
        SWRevealViewController *destViewController = segue.destinationViewController;
        destViewController.rearViewController = rearController;
        destViewController.frontViewController = frontController;
    }
}

//Onclick button method for login button
- (IBAction)connectButtonOnClick:(id)sender
{
    //Block success/fail login
    void (^connectionSuccess)() = ^(void)
    {
        [self performSegueWithIdentifier:@"loginSuccess" sender:self];
    };
    void (^connectionFailed)(NSDictionary *error) = ^(NSDictionary *error)
    {
        self.connectButton.hidden = FALSE;
        self.hud.hidden = TRUE;
        UIAlertController *alertController = [UIAlertController
                                              alertControllerWithTitle:NSLocalizedString(@"Oops !", nil)
                                              message:@""
                                              preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *okAction = [UIAlertAction
                                   actionWithTitle:NSLocalizedString(@"Ok", nil)
                                   style:UIAlertActionStyleCancel
                                   handler:^(UIAlertAction *action)
                                   {
                                       self.passwordTextField.text = @"";
                                   }];
        [alertController addAction:okAction];
        
        NSLog(@"Connection Fail, reason: %@, Status code: %@", [error valueForKey:@"errorRequest"], [error valueForKey:@"errorStatusCode"]);
        if ([[error valueForKey:@"errorStatusCode"] isEqualToString:@"403"])
            [Animations addShakingAnimation:self.passwordTextField];
        else if ([[error valueForKey:@"errorStatusCode"] isEqualToString:@"404"])
            [Animations addShakingAnimation:self.loginTextField];
        else if ([[error valueForKey:@"errorStatusCode"] isEqualToString:@"0"] ||
                 [[error valueForKey:@"errorStatusCode"] isEqualToString:@"500"])
        {
            [alertController setMessage:NSLocalizedString(@"Could not connect to the server", nil)];
            [self presentViewController:alertController animated:YES completion:nil];
        }
    };
    
    if ([self.passwordTextField.text isEqualToString:@""])
        [Animations addShakingAnimation:self.passwordTextField];
    else
    {
        self.connectButton.hidden = TRUE;
        [WOTWineClient loginWithBlock:self.loginTextField.text password:self.passwordTextField.text connectionSuccess:connectionSuccess connectionFailed:connectionFailed];
        self.hud.hidden = FALSE;
    }
}

//Onclick button method for need an account button
- (IBAction)needAccountButtonOnClick:(id)sender
{
    if ([[self.needAccountButton titleLabel].text isEqualToString:NSLocalizedString(@"Need an Account ?", nil)])
    {
        [self.needAccountButton setTitle:NSLocalizedString(@"Create and GO!", nil) forState:UIControlStateNormal];
        self.passwordTextField2.hidden = FALSE;
        self.connectButton2.hidden = FALSE;
        self.connectButton.hidden = TRUE;
    }
    else
    {
        UIAlertController   *alertController = [UIAlertController
                                                alertControllerWithTitle:NSLocalizedString(@"Oops !", nil)
                                                message:NSLocalizedString(@"You forget to type your email", nil)
                                                preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *okAction = [UIAlertAction
                                   actionWithTitle:NSLocalizedString(@"Ok", nil)
                                   style:UIAlertActionStyleCancel
                                   handler:^(UIAlertAction *action)
                                   {
                                       self.loginTextField.text = @"";
                                       self.passwordTextField.text = @"";
                                       self.passwordTextField2.text = @"";
                                   }];
        [alertController addAction:okAction];
        //Checking if something is missing before sending it to the server
        if ([self.passwordTextField.text isEqualToString:self.passwordTextField2.text] && ![self.passwordTextField.text isEqualToString:@""])
        {
            if ([self.loginTextField.text isEqualToString:@""])
                [Animations addShakingAnimation:self.loginTextField];
            else
            {
                void (^connectionSuccess)() = ^(void)
                {
                    [self performSegueWithIdentifier:@"loginSuccess" sender:self];
                };
                void (^connectionFailed)(NSDictionary *error) = ^(NSDictionary *error)
                {
                    self.connectButton2.hidden = FALSE;
                    self.hud.hidden = TRUE;
                    UIAlertController *alertController = [UIAlertController
                                                          alertControllerWithTitle:NSLocalizedString(@"Oops !", nil)
                                                          message:@""
                                                          preferredStyle:UIAlertControllerStyleAlert];
                    UIAlertAction *okAction = [UIAlertAction
                                               actionWithTitle:NSLocalizedString(@"Ok", nil)
                                               style:UIAlertActionStyleCancel
                                               handler:^(UIAlertAction *action)
                                               {
                                                   self.passwordTextField.text = @"";
                                               }];
                    [alertController addAction:okAction];
                    
                    NSLog(@"Connection Fail, reason: %@, Status code: %@", [error valueForKey:@"errorRequest"], [error valueForKey:@"errorStatusCode"]);
                    if ([[error valueForKey:@"errorStatusCode"] isEqualToString:@"404"])
                    {
                        [alertController setMessage:NSLocalizedString(@"Account already exist", nil)];
                        [self presentViewController:alertController animated:YES completion:nil];
                    }
                    else if ([[error valueForKey:@"errorStatusCode"] isEqualToString:@"0"])
                    {
                        [alertController setMessage:NSLocalizedString(@"Could not connect to the server", nil)];
                        [self presentViewController:alertController animated:YES completion:nil];
                    }
                };
                self.hud.hidden = FALSE;
                [WOTWineClient registerAccountWithBlock:self.loginTextField.text  password:self.passwordTextField.text connectionSuccess:connectionSuccess connectionFailed:connectionFailed];
            }
        }
        else
        {
            [alertController setMessage:NSLocalizedString(@"Your password aren't the same", nil)];
            [self presentViewController:alertController animated:YES completion:nil];
        }
    }
}

@end
