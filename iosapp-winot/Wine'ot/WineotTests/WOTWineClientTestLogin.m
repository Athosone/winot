//
//  WOTWineClientTestLogin.m
//  Wine'ot
//
//  Created by Werck Ayrton on 07/11/2014.
//  Copyright (c) 2014 wineot. All rights reserved.
//
/*
#import <GHAsyncTestCase.h>
#import <XCTest/XCTest.h>
#import "WOTWineClient.h"

@interface WOTWineClientTestLogin : GHAsyncTestCase

@property (strong, nonatomic) WOTWineClient *client;
@property (strong, nonatomic) NSMutableDictionary *testValue;

@end

@implementation WOTWineClientTestLogin

- (void)setUp {
    GHTestLog(@"Setting up data before test");
    NSLog(@"Setting up data before test");
    [super setUp];
    
    self.client = [[WOTWineClient alloc]init];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(connectionSuccess:) name:@"connectionSuccess" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(connectionFailed:) name:@"connectionFailed" object:nil];
    
    self.testValue = [[NSMutableDictionary alloc] init];
    //Test LOGIN
    //Test fail with email that is not in databases
    [self.testValue setObject:@"unknownmail@gmail.com" forKey:@"fail_unknownmail"];
    [self.testValue setObject:@"unknownmail_password" forKey:@"fail_unknownmail_password"];
    //Test success with email and password correct
    [self.testValue setObject:@"successmail@gmail.com" forKey:@"success_successmail"];
    [self.testValue setObject:@"successmail_password" forKey:@"success_successmail_password"];
    //Test with empty password
    [self.testValue setObject:@"successmail@gmail.com" forKey:@"fail_emptypassword"];
    //Test with empty mail
    [self.testValue setObject:@"emptymail" forKey:@"fail_emptymail"];
    //Test with wrong password
    [self.testValue setObject:@"successmail@gmail.com" forKey:@"fail_mailpasswordwrong"];
    [self.testValue setObject:@"successmail_passwordwrong" forKey:@"fail_passwordwrong"];
    
    //Test Inscription
    //Test Inscription successed
    [self.testValue setObject:@"register_success@gmail.com" forKey:@"success_register_mail"];
    [self.testValue setObject:@"register_success_password" forKey:@"success_register_password"];
    //Test mail deja used
    [self.testValue setObject:@"already_registered@gmail.com" forKey:@"fail_already_registered_mail"];
    [self.testValue setObject:@"already_registered_password" forKey:@"fail_already_registered_password"];
    //Test mail malformed
    [self.testValue setObject:@"emailmalformed@gmail" forKey:@"fail_emailmalformed_registered_mail"];
    [self.testValue setObject:@"emailmalformedpassword" forKey:@"fail_emailmalformed_registered_password"];
    //Test the two password aren't the same
    
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
    self.client = nil;
    self.testValue = nil;
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testExample {
    // This is an example of a functional test case.
}

- (void)connectionSuccess:(NSNotification *)notification {
    NSDictionary *response = [notification userInfo];
    
    GHTestLog(@"Response: %@", response);
    NSString *login = [response objectForKey:@"login"];
    if ([login isEqualToString:@"successmail@gmail.com"])
    {
        [self notify:kGHUnitWaitStatusSuccess forSelector:@selector(testLoginSuccess)];
    }
    
}

- (void)connectionFailed:(NSNotification *)notification {
    NSDictionary *response = [notification userInfo];
    
    GHTestLog(@"Response: %@", [response valueForKey:@"errorRequest"]);
    [self notify:kGHUnitWaitStatusFailure forSelector:@selector(testLoginWrongEmail)];
    [self notify:kGHUnitWaitStatusFailure forSelector:@selector(testLoginWrongPassword)];
    
}

- (void)testLoginSuccess
{
    NSLog(@"OYYO");
    GHTestLog(@"Testing testLoginSuccess");
    [self.client login:[self.testValue objectForKey:@"success_successmail"]
              password:[self.testValue objectForKey:@"success_successmail_password"]];
    [self waitForStatus:kGHUnitWaitStatusSuccess timeout:10.0];
}

- (void)testLoginWrongEmail
{
    GHTestLog(@"Testing testLoginWrongEmail");
    [self.client login:[self.testValue objectForKey:@"fail_unknownmail"] password:[self.testValue objectForKey:@"fail_unknownmail_password"]];
    [self waitForStatus:kGHUnitWaitStatusFailure timeout:10.0];
}

- (void)testLoginWrongPassword
{
    GHTestLog(@"Testing testLoginWrongPassword");
    [self.client login:[self.testValue objectForKey:@"fail_mailpasswordwrong"] password:[self.testValue objectForKey:@"fail_passwordwrong"]];
    [self waitForStatus:kGHUnitWaitStatusFailure timeout:10.0];
}

 - (void)testInscriptionSuccess
 {
 [self.client registerAccount:[self.testValue objectForKey:@"success_register_mail"]
 password:@"success_register_password"];
 }
 
 - (void)testInscriptionMailAlreadyUsed
 {
 [self.client registerAccount:[self.testValue objectForKey:@"fail_already_registered_mail"]
 password:@"fail_already_registered_password"];
 }
 
 - (void)testInscriptionMailMalFormed
 {
 [self.client registerAccount:[self.testValue objectForKey:@"fail_emailmalformed_registered_mail"]
 password:@"fail_emailmalformed_registered_password"];
 }
 

 - (void)testPerformanceExample {
 // This is an example of a performance test case.
 [self measureBlock:^{
 // Put the code you want to measure the time of here.
 }];
 }


@end
*/