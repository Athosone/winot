//
//  WOTComment.m
//  Wineot
//
//  Created by Werck Ayrton on 02/02/2015.
//  Copyright (c) 2015 wineot. All rights reserved.
//

#import "WOTComment.h"


@implementation WOTComment

@dynamic idComment;
@dynamic comment;
@dynamic wine_id;
@dynamic user_id;
@dynamic user_login;
@dynamic rank;
@dynamic createdDate;

/**
 *  Init WOTComment class using an NSDictionary as source
 *
 *  @param dict dictionary contain values to init WOTComment
 *
 *  @return return and a fresh new WOTComment object using MAGICAL RECORD
 */
+ (id) initWithDict:(NSDictionary*)dict
{
    WOTComment *lRet = [WOTComment MR_createEntity];
    
    lRet.idComment = [dict objectForKey:@"_id"];
    lRet.comment = [dict objectForKey:@"comment"];
    lRet.rank = [NSNumber numberWithInteger:[(NSString*)[dict objectForKey:@"rank"] integerValue]];
    lRet.user_id = [dict objectForKey:@"user_id"];
    lRet.wine_id = [dict objectForKey:@"wine_id"];
    lRet.user_login = [dict objectForKey:@"user_login"];
    return  lRet;
}

/**
 *  Update the WOTComment object using an NSDictionnary*
 *
 *  @param dict NSDictionary* with new values
 */
- (void) updateWithDict:(NSDictionary*) dict
{
    self.idComment = [dict objectForKey:@"_id"];
    self.comment = [dict objectForKey:@"comment"];
    self.rank = [NSNumber numberWithInteger:[(NSString*)[dict objectForKey:@"rank"] integerValue]];
    self.user_id = [dict objectForKey:@"user_id"];
    self.wine_id = [dict objectForKey:@"wine_id"];
    self.user_login = [dict objectForKey:@"user_login"];
}

@end
