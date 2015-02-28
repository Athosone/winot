//
//  WOTWineUser.h
//  Wineot
//
//  Created by Werck Ayrton on 28/01/2015.
//  Copyright (c) 2015 wineot. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class WOTBottle;

@interface WOTWineUser : NSManagedObject

@property (nonatomic, retain) NSString * idUser;
@property (nonatomic, retain) NSString * userName;
@property (nonatomic, retain) NSString * mail;
@property (nonatomic, retain) NSString * password;
@property (nonatomic, retain) NSDate * birthDay;
@property (nonatomic, retain) NSMutableArray *favoriteWinesIds;
@property (nonatomic, retain) NSMutableArray *bottles;
@property (nonatomic, retain) WOTBottle *wotbottle;
@property (nonatomic, retain) NSDate    *createdDate;
@property (nonatomic, retain) NSDate    *lastUpdated;


@end
