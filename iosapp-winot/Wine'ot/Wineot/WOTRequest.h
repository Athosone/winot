//
//  WOTRequest.h
//  Wine'ot
//
//  Created by Werck Ayrton on 02/11/2014.
//  Copyright (c) 2014 wineot. All rights reserved.
//

#import <Foundation/Foundation.h>
#define URL @"http://5.135.165.207:8181"

@interface WOTRequest : NSMutableURLRequest

- (id)initWithConfiguration:(NSString *)endpoint
                      token:(NSString *)token
                       data:(NSMutableDictionary *)data;
- (id)initWithConfiguration:(NSString *)endpoint
                      token:(NSString *)token
                       data:(NSMutableDictionary *)data
                     method:(NSString*)method;

+(NSString*)hashMD5:(NSString*)salt;


@end
