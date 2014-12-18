//
//  WebServiceManager.m
//  ArcTouchCodeChallenge
//
//  Created by Eric E. van Leeuwen on 12/5/14.
//  Copyright (c) 2014 Eric E. van Leeuwen. All rights reserved.
//

#import "WebServiceManager.h"
#import "../Entities/Departure.h"
#import "../Entities/Route.h"
#import "../Entities/Stop.h"

#pragma mark - WebServiceManager Private typedefs -
typedef void (^WebServiceManagerPrivateQueryForRequestURLCompletionHandler) (id result, NSError *error);

@interface WebServiceManager ()
#pragma mark - WebServiceManager Private Properties -
@property   NSOperationQueue    *queryOperationQueue;

#pragma mark - WebServiceManager Private Instance Methods -
- (void)queryForRequestURL:(NSURL *)requestURL requestHTTPBody:(NSData *)requestHTTPBody completionHandler:(WebServiceManagerPrivateQueryForRequestURLCompletionHandler)completionHandler;

@end

@implementation WebServiceManager

#pragma mark - WebServiceManager Class Variable -
static  WebServiceManager   *_webServiceManagerSingleton = nil;

#pragma mark - WebServiceManager Class Methods -
+ (instancetype)webServiceManager
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _webServiceManagerSingleton = [WebServiceManager new];
        _webServiceManagerSingleton.queryOperationQueue = [NSOperationQueue new];
    });
    
    return _webServiceManagerSingleton;
}

#pragma mark - WebServiceManager Instance Methods -
- (void)allRoutesWithCompletionHandler:(void (^)(NSArray *, NSError *))completionHandler
{
    return [self routesWithStopName:nil completionHandler:completionHandler];
}

- (void)routesWithStopName:(NSString *)stopName completionHandler:(WebServiceManagerRoutesCompletionHandler)completionHandler
{
    NSURL *requestURL = [NSURL URLWithString:@"https://dashboard.appglu.com/v1/queries/findRoutesByStopName/run"];
    NSString *requestBodyStopName = nil;
    if (stopName == nil)
    {
        requestBodyStopName = @"%";
    }
    else
    {
        requestBodyStopName = [NSString stringWithFormat:@"%%%@%%", stopName];
    }
    
    NSDictionary *requestHTTPBodyDictionary = @{@"params":@{@"stopName":requestBodyStopName}};
    NSError *jsonSerializationError;
    NSData *requestHTTPBody = [NSJSONSerialization dataWithJSONObject:requestHTTPBodyDictionary options:NSJSONWritingPrettyPrinted error:&jsonSerializationError];
    
    if (jsonSerializationError == nil)
    {
        NSError *queryError;
        [self queryForRequestURL:requestURL requestHTTPBody:requestHTTPBody completionHandler:^(id result, NSError *error) {
            if (result != nil)
            {
                if (result[@"rows"] != nil)
                {
                    NSMutableArray *workingArray = [NSMutableArray array];
                    [result[@"rows"] enumerateObjectsUsingBlock:^(NSDictionary *aRoute, NSUInteger idx, BOOL *stop) {
                        [workingArray addObject:[Route routeFromJsonObject:aRoute]];
                    }];
                    completionHandler([NSArray arrayWithArray:workingArray], nil);
                }
            }
            else if (queryError != nil)
            {
                completionHandler(nil, queryError);
            }
        }];
    }
    else
    {
        completionHandler(nil, jsonSerializationError);
    }
}

- (void)stopsForRouteId:(NSNumber *)routeId completionHandler:(WebServiceManagerStopsCompletionHandler)completionHandler
{
    if (routeId != nil)
    {
        NSURL *requestURL = [NSURL URLWithString:@"https://dashboard.appglu.com/v1/queries/findStopsByRouteId/run"];
        
        NSDictionary *requestHTTPBodyDictionary = @{@"params":@{@"routeId":routeId}};
        NSError *jsonSerializationError;
        NSData *requestHTTPBody = [NSJSONSerialization dataWithJSONObject:requestHTTPBodyDictionary options:NSJSONWritingPrettyPrinted error:&jsonSerializationError];
        
        if (jsonSerializationError == nil)
        {
            NSError *queryError;
            [self queryForRequestURL:requestURL requestHTTPBody:requestHTTPBody completionHandler:^(id result, NSError *error) {
                
                if (result != nil)
                {
                    if (result[@"rows"] != nil)
                    {
                        NSMutableArray *workingArray = [NSMutableArray array];
                        [result[@"rows"] enumerateObjectsUsingBlock:^(NSDictionary *aStop, NSUInteger idx, BOOL *stop) {
                            [workingArray addObject:[Stop stopFromJsonObject:aStop]];
                        }];
                        [workingArray sortUsingComparator:^NSComparisonResult(Stop *stop1, Stop *stop2) {
                            return [stop1.sequence compare:stop2.sequence];
                        }];
                        completionHandler([NSArray arrayWithArray:workingArray], nil);
                    }
                }
                else if (queryError != nil)
                {
                    completionHandler(nil, queryError);
                }
            }];
        }
        else
        {
            completionHandler(nil, jsonSerializationError);
        }
    }
}

- (void)departuresForRouteId:(NSNumber *)routeId completionHandler:(WebServiceManagerDeparturesCompletionHandler)completionHandler
{
    if (routeId != nil)
    {
        NSURL *requestURL = [NSURL URLWithString:@"https://dashboard.appglu.com/v1/queries/findDeparturesByRouteId/run"];
        
        NSDictionary *requestHTTPBodyDictionary = @{@"params":@{@"routeId":routeId}};
        NSError *jsonSerializationError;
        NSData *requestHTTPBody = [NSJSONSerialization dataWithJSONObject:requestHTTPBodyDictionary options:NSJSONWritingPrettyPrinted error:&jsonSerializationError];
        
        if (jsonSerializationError == nil)
        {
            NSError *queryError;
            [self queryForRequestURL:requestURL requestHTTPBody:requestHTTPBody completionHandler:^(id result, NSError *error) {
                if (result != nil)
                {
                    if (result[@"rows"] != nil)
                    {
                        NSMutableArray *workingArray = [NSMutableArray array];
                        [result[@"rows"] enumerateObjectsUsingBlock:^(NSDictionary *aDeparture, NSUInteger idx, BOOL *stop) {
                            [workingArray addObject:[Departure departureFromJsonObject:aDeparture]];
                        }];
                        completionHandler([NSArray arrayWithArray:workingArray], nil);
                    }
                }
                else if (queryError != nil)
                {
                    completionHandler(nil, queryError);
                }
            }];
        }
        else
        {
            completionHandler(nil, jsonSerializationError);
        }
    }
}

#pragma mark - WebServiceManager Private Instance Methods -
- (void)queryForRequestURL:(NSURL *)requestURL requestHTTPBody:(NSData *)requestHTTPBody completionHandler:(WebServiceManagerPrivateQueryForRequestURLCompletionHandler)completionHandler
{
    NSMutableURLRequest *allRoutesRequest = [NSMutableURLRequest requestWithURL:requestURL cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:30.0];
    
    if (allRoutesRequest != nil)
    {
        allRoutesRequest.HTTPMethod = @"POST";
        [allRoutesRequest addValue:@"Basic V0tENE43WU1BMXVpTThWOkR0ZFR0ek1MUWxBMGhrMkMxWWk1cEx5VklsQVE2OA==" forHTTPHeaderField:@"Authorization"];
        [allRoutesRequest addValue:@"staging" forHTTPHeaderField:@"X-AppGlu-Environment"];
        [allRoutesRequest addValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
        
        allRoutesRequest.HTTPBody = requestHTTPBody;
        
        if ([NSURLConnection canHandleRequest:allRoutesRequest])
        {
            [NSURLConnection sendAsynchronousRequest:allRoutesRequest queue:self.queryOperationQueue completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
                if (connectionError != nil)
                {
                    completionHandler(nil, connectionError);
                }
                else if (data != nil)
                {
                    NSError *jsonDeserializationError;
                    id jsonObject = [NSJSONSerialization JSONObjectWithData:data options:0 error:&jsonDeserializationError];
                    if (jsonDeserializationError == nil)
                    {
                        completionHandler(jsonObject, nil);
                    }
                    else
                    {
                        completionHandler(nil, jsonDeserializationError);
                    }
                }
                else
                {
                    completionHandler(nil, [NSError errorWithDomain:@"ArcTouchCodeChallengeDomain" code:-3 userInfo:@{NSLocalizedDescriptionKey: @"Unknown URL Connection issue"}]);
                }
            }];
        }
        else
        {
            completionHandler(nil, [NSError errorWithDomain:@"ArcTouchCodeChallengeDomain" code:-2 userInfo:@{NSLocalizedDescriptionKey : @"URL Connection can't handle URL Request"}]);
        }
    }
    else
    {
        completionHandler(nil, [NSError errorWithDomain:@"ArcTouchCodeChallengeDomain" code:-1 userInfo:@{NSLocalizedDescriptionKey : @"Failed to create URL Request"}]);
    }
}

@end
