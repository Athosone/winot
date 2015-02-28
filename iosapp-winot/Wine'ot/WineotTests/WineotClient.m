//
//  WineotClient.m
//  Wine'ot
//
//  Created by pluche aurélien on 02/11/2014.
//  Copyright (c) 2014 wineot. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <XCTest/XCTest.h>
#import "WOTwineClient.h"

@interface WineotClient : XCTestCase

@end

@implementation WineotClient

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testExample {
    // This is an example of a functional test case.
    XCTAssert(YES, @"Pass");
}

- (void)testLoginSuccess {
    
    NSString *mail = @"alain.robert@yahoo.com";
    NSString *password = @"shsh31";
    
    WineotClient *testClientLogin = new WineotClient();
    
    testClientLogin.login(mail, password);
    
}

- (void)testLoginEmptyMailPassword {
    
    NSString *mail = nil;
    NSString *password = nil;
    
    WineotClient *testClientLogin = new WineotClient();
    
    testClientLogin.login(mail, password);
}

- (void)testLoginEmptyMail {
    
    NSString *mail = nil;
    NSString *password = @"bonjour23";
    
    WineotClient *testClientLogin = new WineotClient();
    
    testClientLogin.login(mail, password);
}

- (void)testLoginEmptyPassword {
    
    NSString *mail = @"alain.robert@yahoo.com";
    NSString *password = nil;
    
    WineotClient *testClientLogin = new WineotClient();
    
    testClientLogin.login(mail, password);
}

- (void)testLoginWrongMail {
    
    NSString *mail = @"alain.robert@yahoo.co";
    NSString *password = @"shsh31";
    
    WineotClient *testClientLogin = new WineotClient();
    
    testClientLogin.login(mail, password);
}

- (void)testLoginWrongPassword {

    NSString *mail = @"alain.robert@yahoo.com";
    NSString *password = @"shsh3";
    
    WineotClient *testClientLogin = new WineotClient();
    
    testClientLogin.login(mail, password);
}

- (void)testLoginMailNotConfirmed {
    
    NSString *mail = @"alain.robert@yahoo.com";
    NSString *password = @"shsh31";
    
    WineotClient *testClientLogin = new WineotClient();
    
    testClientLogin.login(mail, password);
}

- (void)testInscriptionSuccess {
    
    NSString *mail = @"bertrand.robert@yahoo.com";
    NSString *password_1 = @"Bonjour29";
    NSString *password_2 = @"Bonjour29";
    
}

- (void)testInscriptionMailAlreadyUsed {
    
    NSString *mail = @"alain.robert@yahoo.com";
    NSString *password_1 = @"Bonjour29";
    NSString *password_2 = @"Bonjour29";
    
}

- (void)testInscriptionWrongPassword {
    
    NSString *mail = @"jose.robert@yahoo.com";
    NSString *password_1 = @"Bonjour29";
    NSString *password_2 = @"Bonjour25";
}

- (void)testPerformanceExample {
    // This is an example of a performance test case.
    [self measureBlock:^{
        // Put the code you want to measure the time of here.
    }];
}

@end
