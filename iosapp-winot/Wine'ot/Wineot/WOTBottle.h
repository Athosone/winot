//
//  WOTBottle.h
//  Wineot
//
//  Created by Werck Ayrton on 28/01/2015.
//  Copyright (c) 2015 wineot. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "WOTComment.h"

@class WOTWineUser;

@interface WOTBottle : NSManagedObject

@property (nonatomic, retain) NSString * idWine;
@property (nonatomic, retain) NSData * image;
@property (nonatomic, readwrite) double  price;
@property (nonatomic, retain) NSString * taste;
@property (nonatomic, retain) NSString * nameCurrentBottle;
@property (nonatomic, retain) NSString * color;
@property (nonatomic, retain) NSNumber * degrees;
@property (nonatomic, readwrite) BOOL   isOwnerCommented;
@property (nonatomic, readwrite) BOOL   isOwnerFavorite;
@property (nonatomic, retain) NSString * imagePath;
@property (nonatomic, retain) WOTWineUser *wotwineuser;
@property (nonatomic, retain) NSDate    *createdDate;
@property (nonatomic, retain) NSDate    *lastUpdated;
@property (nonatomic, retain) WOTComment    *comment;

@end
