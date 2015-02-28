//
//  WOTComment.h
//  Wineot
//
//  Created by Werck Ayrton on 02/02/2015.
//  Copyright (c) 2015 wineot. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface WOTComment : NSManagedObject

@property (nonatomic, retain) NSString * idComment;
@property (nonatomic, retain) NSString * comment;
@property (nonatomic, retain) NSString * wine_id;
@property (nonatomic, retain) NSString * user_id;
@property (nonatomic, retain) NSString * user_login;
@property (nonatomic, retain) NSNumber * rank;
@property (nonatomic, retain) NSDate * createdDate;


- (void) updateWithDict:(NSDictionary*) dict;
+ (id) initWithDict:(NSDictionary*)dict;

@end
