//
//  WOTRequest.m
//  Wine'ot
//
//  Created by Werck Ayrton on 02/11/2014.
//  Copyright (c) 2014 wineot. All rights reserved.
//

#import "WOTRequest.h"

@implementation WOTRequest

/**
 *  The initWithConfiguration method init a NSMutableUrlRequest preloaded with content-type json and put the NSDictionay provided into json encoding into the body.
 *
 *  @param endpoint endpoint to be passed on the webservice
 *  @param token    token
 *  @param data     data to be json-encoded
 *
*/
- (id) initWithConfiguration:(NSString *)endpoint
                       token:(NSString *)token
                        data:(NSMutableDictionary *)data
{
    if ((self = [super init]))
    {
        [self setURL:[NSURL URLWithString:[URL stringByAppendingString:endpoint]]];
        [self setHTTPMethod:@"POST"];
        [self setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
        //  data[@"req_token"] = [self.class hash:token second:timestamp];
        //TODO Hash timestamp
        NSError *error;
        NSData *encoded = [NSJSONSerialization dataWithJSONObject:data options:0 error:&error];
        [self setHTTPBody: encoded];
        [self setValue:[NSString stringWithFormat:@"%d", (int)encoded.length] forHTTPHeaderField:@"Content-Lenght"];
           }
    return self;
}

/**
 *  The initWithConfiguration method init a NSMutableUrlRequest preloaded with content-type json and put the NSDictionay provided into json encoding into the body.
 *
 *  @param endpoint endpoint to be passed on the webservice
 *  @param token    token
 *  @param data     data to be json-encoded
 *  @param method   type of method to use like POST, PUT, GET, etc.
 *
 *  @return return a new NSMutableUrlRequest
 */
- (id) initWithConfiguration:(NSString *)endpoint
                       token:(NSString *)token
                        data:(NSMutableDictionary *)data method:(NSString *)method
{
    if ((self = [super init]))
    {
        [self setURL:[NSURL URLWithString:[URL stringByAppendingString:endpoint]]];
        [self setHTTPMethod:method];
        //  data[@"req_token"] = [self.class hash:token second:timestamp];
        //TODO Hash timestamp
        NSError *error;
        if (data)
        {
            [self setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
            NSData *encoded = [NSJSONSerialization dataWithJSONObject:data options:0 error:&error];
            [self setHTTPBody: encoded];
            [self setValue:[NSString stringWithFormat:@"%d", (int)encoded.length] forHTTPHeaderField:@"Content-Lenght"];
        }
    }
    return self;
}

+(NSString*)hashMD5:(NSString*)salt
{
    return nil;
}

@end
