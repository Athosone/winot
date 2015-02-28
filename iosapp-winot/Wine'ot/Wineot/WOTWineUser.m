//
//  WOTWineUser.m
//  Wineot
//
//  Created by Werck Ayrton on 28/01/2015.
//  Copyright (c) 2015 wineot. All rights reserved.
//

#import "WOTWineUser.h"
#import "WOTBottle.h"


@implementation WOTWineUser

@dynamic idUser;
@dynamic userName;
@dynamic mail;
@dynamic password;
@dynamic birthDay;
@dynamic favoriteWinesIds;
@dynamic bottles;
@dynamic wotbottle;
@dynamic createdDate;
@dynamic lastUpdated;

- (void) willChangeValueForKey:(NSString *)key
{
    [super willChangeValueForKey:key];
    if (![key isEqualToString:@"lastUpdated"])
        self.lastUpdated = [NSDate date];
    NSLog(@"WineUser UPDATED for key: %@", key);
}

@end
