//
//  WOTWineClient.h
//  Wine'ot
//
//  Created by Werck Ayrton on 02/11/2014.
//  Copyright (c) 2014 wineot. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "WOTBottle.h"
#import "WOTWineUser.h"

@interface WOTWineClient : NSObject

@property (strong, nonatomic) NSOperationQueue  *operationQueue;

//Basics info
@property (strong, nonatomic) WOTWineUser       *wotwineuser;

//Bottle
@property (strong, nonatomic) WOTBottle         *currentBottle;
@property (strong, nonatomic) NSMutableArray    *bottles;


+  (void)  sendImageWithBlock:(UIImage*) imageToSend connectionSuccess:(void (^)())connectionSuccess connectionFailed:(void(^)(NSDictionary* dict))connectionFailed;
+   (void) loginWithBlock:(NSString*)userName password:(NSString*)password connectionSuccess:(void (^)())connectionSuccess connectionFailed:(void(^)(NSDictionary* dict))connectionFailed;
+   (void) registerAccountWithBlock:(NSString*)userName password:(NSString*)password connectionSuccess:(void (^)())connectionSuccess connectionFailed:(void(^)(NSDictionary* dict))connectionFailed;
+ (void) setFavorite:(NSString*)idWine isFavorite:(BOOL)isFav success:(void(^)())successRequest fail:(void(^)(NSDictionary *dict))fail;
+ (void) addComment:(NSDictionary*) dict success:(void(^)())successRequest fail:(void(^)(NSDictionary *dict))fail;
+ (void) getCommentWine:(NSString*)idWine success:(void(^)())successRequest fail:(void(^)(NSDictionary *dict))fail;
//Singleton purpose
+ (id) sharedInstance;

@end
