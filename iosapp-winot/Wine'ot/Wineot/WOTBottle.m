//
//  WOTBottle.m
//  Wineot
//
//  Created by Werck Ayrton on 28/01/2015.
//  Copyright (c) 2015 wineot. All rights reserved.
//

#import "WOTBottle.h"
#import "WOTWineUser.h"


@implementation WOTBottle

@dynamic idWine;
@dynamic image;
@dynamic price;
@dynamic taste;
@dynamic nameCurrentBottle;
@dynamic color;
@dynamic degrees;
@dynamic isOwnerCommented;
@dynamic isOwnerFavorite;
@dynamic imagePath;
@dynamic wotwineuser;
@dynamic createdDate;
@dynamic lastUpdated;
@dynamic comment;

- (void) willChangeValueForKey:(NSString *)key
{
    [super willChangeValueForKey:key];
    if (![key isEqualToString:@"lastUpdated"])
        self.lastUpdated = [NSDate date];
    NSLog(@"Wine UPDATED for key: %@", key);
}


@end
