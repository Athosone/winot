//
//  WOTManagedObject.m
//  Wineot
//
//  Created by Werck Ayrton on 28/01/2015.
//  Copyright (c) 2015 wineot. All rights reserved.
//

#import "WOTManagedObject.h"

@implementation WOTManagedObject

#pragma mark -> WOTWineUser

+ (WOTWineUser*) getWineUser
{
    WOTWineUser *lRet = nil;
    
    lRet = [WOTWineUser MR_findFirstOrderedByAttribute:@"lastUpdated" ascending:NO];
    return  lRet;
}

#pragma mark -> WOTBottle
/**
 *  getBottles returns all the bottles sorted by last update in descending order
 *
 *  @return NSArray containing all bottles
 */
+ (NSArray*) getBottles
{
    return [WOTBottle MR_findAllSortedBy:@"lastUpdated" ascending:NO];
}

+ (WOTBottle*) getBottleByName:(NSString*) name
{
    return ([WOTBottle MR_findFirstByAttribute:@"nameCurrentBottle" withValue:name]);
}

+ (BOOL) isBottleOwnerFavorite:(NSString*) idWine
{
    WOTWineUser *user = [WOTManagedObject getWineUser];
    
    if ([user.favoriteWinesIds containsObject:idWine])
        return YES;
    else
        return NO;
    
}

/**
 *  Get the specific bottle identify by its id
 *
 *  @param _id idWine of the bottle to be retreive
 *
 *  @return WOTBottle
 */
+ (WOTBottle*) getBottleById:(NSString*) _id
{
    return [WOTBottle MR_findFirstByAttribute:@"idWine" withValue:_id];
}


#pragma mark -> WOTComment

+ (WOTComment*) getCommentByUserId_WineId:(NSString*) userId idWine:(NSString*)idWine
{
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"(wine_id == %@) AND (user_id == %@)", idWine, userId];
    return (WOTComment*)[WOTComment MR_findFirstWithPredicate:predicate];
}

+ (NSArray*)getComments
{
    return [WOTComment MR_findAllSortedBy:@"createdDate" ascending:NO];
}


+ (NSArray*) getCommentsByWineId:(NSString*)idWine
{
    return [WOTComment MR_findByAttribute:@"wine_id" withValue:idWine andOrderBy:@"createdDate" ascending:NO];
}

+ (NSUInteger) getNumberOfCommentsForWine:(NSString*)idWine
{
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"(wine_id == %@)", idWine];

    NSArray *comments = [WOTComment MR_findAllWithPredicate:predicate];
    if (comments)
        return comments.count;
    else
        return 0;
}

#pragma mark ->Save context

/**
 *  Try to save the context
 */
+ (void) saveContext
{
    [MagicalRecord saveWithBlock:^(NSManagedObjectContext *localContext)
    {
        [[NSManagedObjectContext MR_defaultContext] MR_saveToPersistentStoreAndWait];
    } completion:^(BOOL success, NSError *error)
     {
        if (success)
            NSLog(@"Data saved");
        else
            NSLog(@"Data failed to be saved error: %@, suggestions:%@", [error localizedFailureReason], [error localizedRecoverySuggestion]);
    }];
}
@end
