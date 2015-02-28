//
//  LoginTests.m
//  Wineot
//
//  Created by Werck Ayrton on 07/11/2014.
//  Copyright (c) 2014 wineot. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "WOTWineClient.h"
#import "AFHTTPRequestOperation.h"

@interface LoginTests : XCTestCase

@property (strong, nonatomic) NSMutableDictionary *testValue;
@property (strong, nonatomic) XCTestExpectation   *currentExpectation;
@property (strong, nonatomic) NSString            *currentLogin;
@end
//Testing Login method
@implementation LoginTests

- (void)setUp {
    NSLog(@"Setting up data before test");
    [super setUp];
    
    
    self.testValue = [[NSMutableDictionary alloc] init];
    //Test LOGIN
    //Test fail with email that is not in databases
    [self.testValue setObject:@"unknownmail@gmail.com" forKey:@"fail_unknownmail"];
    [self.testValue setObject:@"unknownmail_password" forKey:@"fail_unknownmail_password"];
    //Test success with email and password correct
    [self.testValue setObject:@"successmail@gmail.com" forKey:@"success_successmail"];
    [self.testValue setObject:@"successmail_password" forKey:@"success_successmail_password"];
    //Test with wrong password
    [self.testValue setObject:@"success@gmail.com" forKey:@"fail_mailpasswordwrong"];
    [self.testValue setObject:@"success_passwordwrong" forKey:@"fail_passwordwrong"];
    /*
    //UITest
    //Test with empty password
    [self.testValue setObject:@"successmail@gmail.com" forKey:@"fail_emptypassword"];
    //Test with empty mail
    [self.testValue setObject:@"emptymail" forKey:@"fail_emptymail"];
    */
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
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown
{
    self.testValue = nil;
    self.currentExpectation = nil;
    self.currentLogin = nil;
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testLoginSuccess
{
    __block XCTestExpectation *completionExpectation = [self expectationWithDescription:@"testLoginSuccess"];
    
    void (^connectionSuccess)() = ^(void)
    {
        NSLog(@"Test successed: %@", [completionExpectation description]);
        [completionExpectation fulfill];
    };
    void (^connectionFailed)(NSDictionary *error) =  ^(NSDictionary *error)
    {
        NSLog(@"Test failed: %@ with statuscode: %@ and reason: %@", [completionExpectation description], [error valueForKey:@"errorStatusCode"], [error valueForKey:@"errorRequest"]);
        [completionExpectation finalize];
    };
    
    [WOTWineClient loginWithBlock:[self.testValue objectForKey:@"success_successmail"] password:[self.testValue objectForKey:@"success_successmail_password"]
     connectionSuccess:connectionSuccess connectionFailed:connectionFailed];
    [self waitForExpectationsWithTimeout:15.0 handler:nil];
}

- (void)testLoginWrongEmail
{
    __block XCTestExpectation *completionExpectation = [self expectationWithDescription:@"testLoginWrongEmail"];
    
    void (^connectionSuccess)() = ^(void)
    {
        
        NSLog(@"Test failed: %@ ", [completionExpectation description]);
        [completionExpectation finalize];
    };
    void (^connectionFailed)(NSDictionary *error) =  ^(NSDictionary *error)
    {
        NSLog(@"Test successed: %@", [completionExpectation description]);
        [completionExpectation fulfill];
    };
    
    [WOTWineClient loginWithBlock:[self.testValue objectForKey:@"fail_unknownmail"] password:[self.testValue objectForKey:@"fail_unknownmail_password"]
     connectionSuccess:connectionSuccess connectionFailed:connectionFailed];
    [self waitForExpectationsWithTimeout:15.0 handler:nil];
}

- (void)testLoginWrongPassword
{
    __block XCTestExpectation *completionExpectation = [self expectationWithDescription:@"testLoginWrongPassword"];
    
    void (^connectionSuccess)() = ^(void)
    {
        XCTFail(@"Test failed: %@ ", [completionExpectation description]);
        [completionExpectation finalize];
    };
    
    void (^connectionFailed)(NSDictionary *error) =  ^(NSDictionary *error)
    {
        NSLog(@"Test successed: %@", [completionExpectation description]);
        [completionExpectation fulfill];
    };
    
    
    [WOTWineClient loginWithBlock:[self.testValue objectForKey:@"fail_mailpasswordwrong"] password:[self.testValue objectForKey:@"fail_passwordwrong"]
     connectionSuccess:connectionSuccess connectionFailed:connectionFailed];
    //For the needs of tests
    [self waitForExpectationsWithTimeout:15.0 handler:nil];
}

- (void) deleteUser:(NSString *)idUser
{
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    [request setURL:[NSURL URLWithString:[@"http://5.135.165.207:8181/user/" stringByAppendingString:idUser]]];
    [request setHTTPMethod:@"DELETE"];
    
    AFHTTPRequestOperation *afOperation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    
    
    afOperation.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    //adjust timeout in request
    [afOperation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject)
     {
         NSLog(@"Response Delete: %ld", [operation.response statusCode]);
     }failure:^(AFHTTPRequestOperation *operation, NSError *error)
     {
         NSLog(@"Response Delete: %ld, Error text: %@", [operation.response statusCode], [error localizedDescription]);
         
     }];
    [afOperation start];
}


- (void)testInscriptionSuccess
{
    __block XCTestExpectation *completionExpectation = [self expectationWithDescription:@"testLoginSuccess"];
    
    void (^connectionSuccess)() = ^(void)
    {
        XCTAssert(true);
        NSLog(@"Test successed: %@", [completionExpectation description]);
        [completionExpectation fulfill];
    };
    
    void (^connectionFailed)(NSDictionary *error) =  ^(NSDictionary *error)
    {
        XCTFail(@"Test failed: %@ with statuscode: %@ and reason: %@", [completionExpectation description], [error valueForKey:@"errorStatusCode"], [error valueForKey:@"errorRequest"]);
        [completionExpectation finalize];
    };
    [WOTWineClient registerAccountWithBlock:[self.testValue objectForKey:@"success_register_mail"] password:@"success_register_password" connectionSuccess:connectionSuccess connectionFailed:connectionFailed];
    [self waitForExpectationsWithTimeout:15.0 handler:nil];
}


/*
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
 }*/

@end
