//
//  WOTSendPhotoToServer.m
//  Wineot
//
//  Created by Werck Ayrton on 05/12/2014.
//  Copyright (c) 2014 wineot. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <XCTest/XCTest.h>
#import "WOTWineClient.h"

@interface WOTSendPhotoToServer : XCTestCase

@property (strong, nonatomic) UIImage *picture;
@property (strong, nonatomic) XCTestExpectation   *currentExpectation;
@property (strong ,nonatomic) WOTWineClient        *client;
@end


@implementation WOTSendPhotoToServer

- (void)setUp
{
    [super setUp];
    self.picture = nil;
    self.client = nil;
    self.client = [[WOTWineClient alloc] init];
    NSLog(@"Setting up data before test SEND PHOTO TO SERVER");
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(responsePhotoRecognition:) name:@"responsePhotoRecognition" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(connectionFailed:) name:@"connectionFailed" object:nil];
}

- (void) responsePhotoRecognition:(NSNotification *)notification
{
    [self.currentExpectation fulfill];
}

- (void) connectionFailed:(NSNotification *)notification
{
    NSLog(@"Connection Fail, reason: %@, Status code: %@", [[notification userInfo] valueForKey:@"errorRequest"], [[notification userInfo] valueForKey:@"errorStatusCode"]);
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testSendPhotoOnServer
{
    self.picture = nil;
    self.client = nil;
    self.client = [[WOTWineClient alloc] init];
    self.client.wotwineuser.userName = @"yoyo";
    self.currentExpectation = [self expectationWithDescription:@"testSendPhotoOnServer"];
    NSString *imagePath = [[NSBundle bundleForClass:[self class]] pathForResource:@"bottleTest.jpg" ofType:nil];
    self.picture = [UIImage imageWithContentsOfFile:imagePath];
    
    if (!self.picture)
    {
        XCTAssert(NO,"Fail picture is nil");
        return;
    }
    //[self.client sendImage:self.picture];
    [self.client.operationQueue waitUntilAllOperationsAreFinished];
    [self waitForExpectationsWithTimeout:15.0 handler:nil];
}



@end
