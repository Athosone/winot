//
//  WOTWineClient.m
//  Wine'ot
//
//  Created by Werck Ayrton on 02/11/2014.
//  Copyright (c) 2014 wineot. All rights reserved.
//

#import <MagicalRecord/MagicalRecord.h>
#import "AFNetworking.h"

#import "WOTWineClient.h"
#import "WOTRequest.h"
#import "WOTManagedObject.h"
#import "WOTHelperConstants.h"

@implementation WOTWineClient

//Mettre dans un opertion queue

//Convert into SINGLETON
//init client especially operationqueue
- (id)init
{
    self = [super init];
    if (self)
    {
        //On peut considérer un operation queue comme un pool de thread
        self.operationQueue = [[NSOperationQueue alloc] init];
        //On definit le maximum de thread par pool (par default j'ai mis le max que apple accepte
        [self.operationQueue setMaxConcurrentOperationCount:NSOperationQueueDefaultMaxConcurrentOperationCount];
    }
    return self;
}

#pragma mark Network+Singleton

+ (id) sharedInstance
{
    static WOTWineClient    *sharedInstance = nil;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[self alloc] init];
    });
    return sharedInstance;
}

+ (void) addOperationToQueue:(NSOperation*) op
{
    WOTWineClient   *client = [WOTWineClient sharedInstance];
    
    [client.operationQueue addOperation:op];
}

#pragma mark Requests

#pragma mark  ->Request Login


/**
 *  The loginWithBlock method allow the user to login by requesting the server asynchronously
 *
 *  @param userName          username registered on the server
 *  @param password          password associated to the username
 *  @param connectionSuccess login successed
 *  @param connectionFailed  login failed
 */
+ (void) loginWithBlock:(NSString*)userName password:(NSString*)password connectionSuccess:(void (^)())connectionSuccess connectionFailed:(void(^)(NSDictionary* dict))connectionFailed
{
    NSMutableDictionary *data = [[NSMutableDictionary alloc]init];
    [data setObject:userName forKey:@"login"];
    [data setObject:password forKey:@"password"];
    WOTRequest  *request = [[WOTRequest alloc] initWithConfiguration:@"/login" token:@"" data:data];
    AFHTTPRequestOperation *afOperation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    
    afOperation.responseSerializer = [AFJSONResponseSerializer serializer];
    [afOperation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject)
     {
         WOTWineUser         *user               = [WOTWineUser MR_findFirstOrderedByAttribute:@"lastUpdated" ascending:NO];
         if (!user || !user.userName.length > 0)
         {
             user = [WOTWineUser MR_createEntity];
             user.createdDate = [NSDate date];
         }
         else
             NSLog(@"USER: %@", user.userName);
         NSDictionary *response = (NSDictionary*)responseObject;
         NSMutableArray *favWine = [response objectForKey:@"favorite_wine_ids"];
         user.userName = userName;
         user.password = password;
         user.favoriteWinesIds = favWine;
         NSLog(@"favWine :%@", favWine);
         user.idUser = [response valueForKey:@"_id"];
         
         [WOTManagedObject saveContext];
         connectionSuccess();
     }failure:^(AFHTTPRequestOperation *operation, NSError *error)
     {
         NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
         
         [dict setValue:[error localizedDescription] forKey:@"errorRequest"];
         [dict setValue:[NSString stringWithFormat:@"%ld", (long)operation.response.statusCode] forKey:@"errorStatusCode"];
         
         connectionFailed(dict);
     }];
    [WOTWineClient addOperationToQueue:afOperation];
}

#pragma mark ->Request Register
/**
 *  The registerAccountWithBlock method allow the registration of a new user. It sends a request to the server asynchronously.
 *
 *
 *  @param userName          username to be used
 *  @param password          password enter by the user
 *  @param connectionSuccess registering of the user success
 *  @param connectionFailed  registering of the user failed
 */
+ (void) registerAccountWithBlock:(NSString*)userName password:(NSString*)password connectionSuccess:(void (^)())connectionSuccess connectionFailed:(void(^)(NSDictionary* dict))connectionFailed
{
    NSMutableDictionary *data = [[NSMutableDictionary alloc]init];
    [data setObject:userName forKey:@"login"];
    [data setObject:password forKey:@"password"];
    
    WOTRequest  *request = [[WOTRequest alloc] initWithConfiguration:@"/users" token:@"" data:data];
    AFHTTPRequestOperation *afOperation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    afOperation.responseSerializer = [AFJSONResponseSerializer serializer];
    
    [afOperation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject)
     {
         WOTWineUser         *user               = [WOTWineUser MR_findFirstOrderedByAttribute:@"lastUpdated" ascending:NO];
         if (!user)
         {
             user = [WOTWineUser MR_createEntity];
             user.createdDate = [NSDate date];
         }
         user.userName = userName;
         user.password = password;
         user.idUser = [responseObject valueForKey:@"_id"];
         NSDictionary *response = (NSDictionary*)responseObject;
         user.favoriteWinesIds = [response objectForKey:@"favorite_wine_ids"];
         [WOTManagedObject saveContext];
         connectionSuccess();
         
     }failure:^(AFHTTPRequestOperation *operation, NSError *error)
     {
         NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
         
         [dict setValue:[error localizedDescription] forKey:@"errorRequest"];
         [dict setValue:[NSString stringWithFormat:@"%ld", (long)operation.response.statusCode] forKey:@"errorStatusCode"];
         connectionFailed(dict);
     }];
     [WOTWineClient addOperationToQueue:afOperation];
}

#pragma mark ->Send image to server

/**
 *  The sendImageWithBlock method send the image to the server for the recognition asynchronously
 *
 *  @param imageToSend       UIImage to be sent to the server
 *  @param connectionSuccess Block on success
 *  @param connectionFailed  Block on fail
 */
+  (void)  sendImageWithBlock:(UIImage*) imageToSend connectionSuccess:(void (^)())connectionSuccess connectionFailed:(void(^)(NSDictionary* dict))connectionFailed
{
    NSMutableDictionary *data               = [[NSMutableDictionary alloc]init];
    NSData              *imageToSendData    = [[NSData alloc] init];
    WOTWineUser         *user               = [WOTWineUser MR_findFirstOrderedByAttribute:@"lastUpdated" ascending:NO];
    
    //1 means non compressed high quality 0 fully compressed low quality
    imageToSendData                         = UIImageJPEGRepresentation(imageToSend, 0.8);
    NSString            *imageStringify     = [imageToSendData base64EncodedStringWithOptions:NSDataBase64Encoding64CharacterLineLength];
    [data setObject:user.userName forKey:@"login"];
    [data setObject:imageStringify forKey:@"picture"];
    
    WOTRequest  *request = [[WOTRequest alloc] initWithConfiguration:@"/photo/recognition" token:@"" data:data];
    AFHTTPRequestOperation *afOperation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    afOperation.responseSerializer = [AFJSONResponseSerializer serializer];
    [afOperation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject)
     {
         NSDictionary *response = (NSDictionary*)responseObject;
         NSDictionary            *wineData = [response objectForKey:@"wine"];
         
         WOTBottle    *bottle = [WOTBottle MR_findFirstByAttribute:@"idWine" withValue:[wineData objectForKey:@"_id"]];
         if (bottle)
         {
             connectionSuccess(bottle);
         }
         else
         {
             WOTBottle      *bottleToAdd = [WOTBottle MR_createEntity];
             NSData                  *imageData;
             
             for (NSString *key in [wineData allKeys])
                 NSLog(@"KEYYYYY: %@", key);
             imageData = [[NSData alloc] initWithBase64EncodedString:[wineData objectForKey:@"label"] options:NSDataBase64DecodingIgnoreUnknownCharacters];
             bottleToAdd.price = [[wineData objectForKey:@"price"] doubleValue];
             bottleToAdd.image = imageData;
             bottleToAdd.nameCurrentBottle = [wineData objectForKey:@"name"];
             bottleToAdd.idWine = [wineData valueForKey:@"_id"];
             bottleToAdd.createdDate = [NSDate date];
             bottleToAdd.isOwnerFavorite = [WOTManagedObject isBottleOwnerFavorite:bottleToAdd.idWine];
             [WOTManagedObject saveContext];
             NSLog(@"BOTTLE IDWINE:%@ %@", bottleToAdd.idWine, [wineData valueForKey:@"_id"]);
             connectionSuccess(bottleToAdd);
         }
     } failure:^(AFHTTPRequestOperation *operation, NSError *error)
     {
         NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
         
         [dict setValue:[error localizedDescription] forKey:@"errorRequest"];
         [dict setValue:[NSString stringWithFormat:@"%ld", (long)operation.response.statusCode] forKey:@"errorStatusCode"];
         connectionFailed(dict);
     }];
     [WOTWineClient addOperationToQueue:afOperation];
}


#pragma mark ->Mark as favorite
/**
 *  the setFavorite methods fav or unfav a bottle. It sends a request on the server asynchronously
 *
 *  @param idWine         nsstring id of the wine to fav
 *  @param isFav          bool that indicate whether or not the wine is fav
 *  @param successRequest block on success
 *  @param fail           block on fail
 */
+ (void) setFavorite:(NSString*)idWine isFavorite:(BOOL)isFav success:(void(^)())successRequest fail:(void(^)(NSDictionary *dict))fail
{
    
    NSMutableDictionary *data = [[NSMutableDictionary alloc]init];
    WOTWineUser         *user               = [WOTWineUser MR_findFirstOrderedByAttribute:@"lastUpdated" ascending:NO];
    NSMutableArray             *favWinesFromUser = [NSMutableArray arrayWithArray:user.favoriteWinesIds];
   if (favWinesFromUser.count == 0)
       favWinesFromUser = [[NSMutableArray alloc] init];
    NSString *endPoint = [@"/user/" stringByAppendingString:user.idUser];
    
    NSLog(@"Fav wines: %@", favWinesFromUser);
    if (isFav)
    {
        if (![favWinesFromUser containsObject:idWine])
            [favWinesFromUser addObject:idWine];
    }
    else
        [favWinesFromUser removeObject:idWine];
    NSLog(@"Fav wines: %@", favWinesFromUser);
    
    [data setObject:favWinesFromUser forKey:@"favorite_wine_ids"];

    WOTRequest  *request = [[WOTRequest alloc] initWithConfiguration:endPoint token:@"" data:data method:@"PUT"];
    AFHTTPRequestOperation *afOperation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    afOperation.responseSerializer = [AFJSONResponseSerializer serializer];
    [afOperation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject)
     {
         NSDictionary *response = (NSDictionary*)responseObject;
         NSLog(@"KEY FAV: %@", [response allKeys]);
         user.favoriteWinesIds = favWinesFromUser;
         successRequest();
     }failure:^(AFHTTPRequestOperation *operation, NSError *error)
     {
         NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
         
         [dict setValue:[error localizedDescription] forKey:@"errorRequest"];
         [dict setValue:[NSString stringWithFormat:@"%ld", (long)operation.response.statusCode] forKey:@"errorStatusCode"];
         fail(dict);
     }];
     [WOTWineClient addOperationToQueue:afOperation];
}


#pragma mark ->Add comment
/**
 *  Add a comment concerning a certain wine
 *
 *  @param dict           NSDictionary* containing the comment which has for key "comment", the id of the wine with key "idWine", the rank with key "rank"
 *  @param successRequest success completion block
 *  @param fail            fail block completion which a dictionary to describe the reason of the fail
 */
+ (void) addComment:(NSMutableDictionary*)dict success:(void(^)())successRequest fail:(void(^)(NSDictionary *dict))fail
{
    NSMutableDictionary *data = [[NSMutableDictionary alloc]init];
    WOTWineUser         *user = [WOTWineUser MR_findFirstOrderedByAttribute:@"lastUpdated" ascending:NO];
    NSString            *idWine = [dict objectForKey:@"idWine"];
    NSString *endPoint = @"/comments";
    NSString *method;

    WOTComment *com = [WOTManagedObject getCommentByUserId_WineId:user.idUser idWine:idWine];
    if (com)
    {
        com.comment = (NSString*)[dict objectForKey:@"comment"];
        com.rank    = (NSNumber*)[dict objectForKey:@"rank"];
        method = @"PUT";
        endPoint = [@"/comment/" stringByAppendingString:com.idComment];
    }
    else
    {
        com = [WOTComment MR_createEntity];
        com.user_id = user.idUser;
        com.wine_id = idWine;
        com.comment = [dict objectForKey:@"comment"];
        com.rank    = [dict objectForKey:@"rank"];
        com.createdDate = [NSDate date];
        com.user_login = user.userName;
        method = @"POST";
    }
    data = [WOTHelperConstants toDictionary:com];
    NSDateFormatter *dateformatter = [NSDateFormatter new];
    [dateformatter setDateFormat:@"dd/MM"];
    [data setValue:[dateformatter stringFromDate:com.createdDate] forKey:@"createdDate"];
    //Process to post
    WOTRequest  *request = [[WOTRequest alloc] initWithConfiguration:endPoint token:@"" data:data method:method];
    AFHTTPRequestOperation *afOperation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    afOperation.responseSerializer = [AFJSONResponseSerializer serializer];
    [afOperation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject)
     {
         NSDictionary *response = (NSDictionary*)responseObject;
         NSLog(@"KEY COMMENT: %@", [response allKeys]);
         successRequest();
     }failure:^(AFHTTPRequestOperation *operation, NSError *error)
     {
         NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
         [dict setValue:[error localizedDescription] forKey:@"errorRequest"];
         [dict setValue:[NSString stringWithFormat:@"%ld", (long)operation.response.statusCode] forKey:@"errorStatusCode"];
         fail(dict);
     }];
     [WOTWineClient addOperationToQueue:afOperation];
}

#pragma mark ->Get comment Wine
/**
 *  Get all the comment concerning a certain wine
 *
 *  @param idWine         id of the wine
 *  @param successRequest success block completion
 *  @param fail           fail block completion which a dictionary to describe the reason of the fail
 */
+ (void) getCommentWine:(NSString*)idWine success:(void(^)())successRequest fail:(void(^)(NSDictionary *dict))fail
{
    NSString *endPoint = [@"/wine_comments/" stringByAppendingString:idWine];
    
    //Process to post
    WOTRequest  *request = [[WOTRequest alloc] initWithConfiguration:endPoint token:@"" data:nil method:@"GET"];
    AFHTTPRequestOperation *afOperation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    afOperation.responseSerializer = [AFJSONResponseSerializer serializer];
    [afOperation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject)
     {
         NSDictionary *response = (NSDictionary*)responseObject;
         NSLog(@"KEY COMMENT: %@", [response allKeys]);
         NSArray *comments = [response objectForKey:@"comments"];
         NSLog(@"KEY COMMENT: %@", comments);

         for (int i = 0; i < comments.count; ++i)
         {
             NSDictionary *commentObject = [comments objectAtIndex:i];
             NSString     *idCurrentWine = [commentObject objectForKey:@"wine_id"];
             NSString     *idCurrentUser = [commentObject objectForKey:@"user_id"];
             WOTComment *comment = [WOTManagedObject getCommentByUserId_WineId:idCurrentUser idWine:idCurrentWine];
             if (!comment)
                 comment = [WOTComment initWithDict:commentObject];
             else
                 [comment updateWithDict:commentObject];
             [WOTManagedObject saveContext];
        }
       successRequest();
     }failure:^(AFHTTPRequestOperation *operation, NSError *error)
     {
         NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
         [dict setValue:[error localizedDescription] forKey:@"errorRequest"];
         [dict setValue:[NSString stringWithFormat:@"%ld", (long)operation.response.statusCode] forKey:@"errorStatusCode"];
         fail(dict);
     }];
     [WOTWineClient addOperationToQueue:afOperation];
}

@end
