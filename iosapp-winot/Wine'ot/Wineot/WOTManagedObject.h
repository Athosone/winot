//
//  WOTManagedObject.h
//  Wineot
//
//  Created by Werck Ayrton on 28/01/2015.
//  Copyright (c) 2015 wineot. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WOTWineUser.h"
#import "WOTBottle.h"

@interface WOTManagedObject : NSObject

+ (WOTWineUser*) getWineUser;
+ (WOTBottle*) getBottleById:(NSString*) _id;
+ (NSArray*) getBottles;
+ (void) saveContext;
+ (WOTBottle*) getBottleByName:(NSString*) name;
+ (BOOL) isBottleOwnerFavorite:(NSString*) idWine;
+ (NSArray*) getComments;
+ (WOTComment*) getCommentByUserId_WineId:(NSString*) userId idWine:(NSString*)idWine;
+ (NSArray*) getCommentsByWineId:(NSString*)idWine;
+ (NSUInteger) getNumberOfCommentsForWine:(NSString*)idWine;

@end
