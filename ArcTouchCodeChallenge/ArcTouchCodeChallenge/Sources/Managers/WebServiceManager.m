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

@interface WebServiceManager ()
#pragma mark - WebServiceManager Private Instance Methods -
- (id)queryForRequestURL:(NSURL *)requestURL requestHTTPBody:(NSData *)requestHTTPBody error:(NSError **)error;

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
    });
    
    return _webServiceManagerSingleton;
}

#pragma mark - WebServiceManager Instance Methods -
- (NSArray *)allRoutes
{
    return [self routesWithStopName:nil];
}

- (NSArray *)routesWithStopName:(NSString *)stopName
{
    NSArray *returnArray = [NSArray array];
    
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
            id queryResults = [self queryForRequestURL:requestURL requestHTTPBody:requestHTTPBody error:&queryError];
            
            if (queryResults != nil)
            {
                if (queryResults[@"rows"] != nil)
                {
                    NSMutableArray *workingArray = [NSMutableArray array];
                    [queryResults[@"rows"] enumerateObjectsUsingBlock:^(NSDictionary *aRoute, NSUInteger idx, BOOL *stop) {
                        [workingArray addObject:[Route routeFromJsonObject:aRoute]];
                    }];
                    returnArray = [NSArray arrayWithArray:workingArray];
                }
            }
            else if (queryError != nil)
            {
                NSLog(@"%s encountered error:\t%@", __PRETTY_FUNCTION__, queryError);
            }
        }
        else
        {
            NSLog(@"%s encountered error:\t%@", __PRETTY_FUNCTION__, jsonSerializationError);
        }
    return returnArray;
}

- (NSArray *)stopsForRouteId:(NSNumber *)routeId
{
    NSArray *returnArray = [NSArray array];
    
    if (routeId != nil)
    {
        NSURL *requestURL = [NSURL URLWithString:@"https://dashboard.appglu.com/v1/queries/findStopsByRouteId/run"];
        
        NSDictionary *requestHTTPBodyDictionary = @{@"params":@{@"routeId":routeId}};
        NSError *jsonSerializationError;
        NSData *requestHTTPBody = [NSJSONSerialization dataWithJSONObject:requestHTTPBodyDictionary options:NSJSONWritingPrettyPrinted error:&jsonSerializationError];
        
        if (jsonSerializationError == nil)
        {
            NSError *queryError;
            id queryResults = [self queryForRequestURL:requestURL requestHTTPBody:requestHTTPBody error:&queryError];
            
            if (queryResults != nil)
            {
                if (queryResults[@"rows"] != nil)
                {
                    NSMutableArray *workingArray = [NSMutableArray array];
                    [queryResults[@"rows"] enumerateObjectsUsingBlock:^(NSDictionary *aStop, NSUInteger idx, BOOL *stop) {
                        [workingArray addObject:[Stop stopFromJsonObject:aStop]];
                    }];
                    [workingArray sortUsingComparator:^NSComparisonResult(Stop *stop1, Stop *stop2) {
                        return [stop1.sequence compare:stop2.sequence];
                    }];
                    returnArray = [NSArray arrayWithArray:workingArray];
                }
            }
            else if (queryError != nil)
            {
                NSLog(@"%s encountered error:\t%@", __PRETTY_FUNCTION__, queryError);
            }
        }
        else
        {
            NSLog(@"%s encountered error:\t%@", __PRETTY_FUNCTION__, jsonSerializationError);
        }
    }
    return returnArray;
}

- (NSArray *)departuresForRouteId:(NSNumber *)routeId
{
    NSArray *returnArray = [NSArray array];
    
    if (routeId != nil)
    {
        NSURL *requestURL = [NSURL URLWithString:@"https://dashboard.appglu.com/v1/queries/findDeparturesByRouteId/run"];
        
        NSDictionary *requestHTTPBodyDictionary = @{@"params":@{@"routeId":routeId}};
        NSError *jsonSerializationError;
        NSData *requestHTTPBody = [NSJSONSerialization dataWithJSONObject:requestHTTPBodyDictionary options:NSJSONWritingPrettyPrinted error:&jsonSerializationError];
        
        if (jsonSerializationError == nil)
        {
            NSError *queryError;
            id queryResults = [self queryForRequestURL:requestURL requestHTTPBody:requestHTTPBody error:&queryError];
            
            if (queryResults != nil)
            {
                if (queryResults[@"rows"] != nil)
                {
                    NSMutableArray *workingArray = [NSMutableArray array];
                    [queryResults[@"rows"] enumerateObjectsUsingBlock:^(NSDictionary *aDeparture, NSUInteger idx, BOOL *stop) {
                        [workingArray addObject:[Departure departureFromJsonObject:aDeparture]];
                    }];
                    returnArray = [NSArray arrayWithArray:workingArray];
                }
            }
            else if (queryError != nil)
            {
                NSLog(@"%s encountered error:\t%@", __PRETTY_FUNCTION__, queryError);
            }
        }
        else
        {
            NSLog(@"%s encountered error:\t%@", __PRETTY_FUNCTION__, jsonSerializationError);
        }
    }
    return returnArray;
}

#pragma mark - WebServiceManager Private Instance Methods -
- (id)queryForRequestURL:(NSURL *)requestURL requestHTTPBody:(NSData *)requestHTTPBody error:(NSError **)error
{
    id returnObject = nil;
    
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
            NSURLResponse *webServiceResponse;
            NSError *webServiceResponseError;
            NSData *webServiceResponseData = [NSURLConnection sendSynchronousRequest:allRoutesRequest returningResponse:&webServiceResponse error:&webServiceResponseError];
            if (webServiceResponseData != nil)
            {
                NSError *jsonDeserializationError;
                id jsonObject = [NSJSONSerialization JSONObjectWithData:webServiceResponseData options:0 error:&jsonDeserializationError];
                if (jsonDeserializationError == nil)
                {
                    returnObject = jsonObject;
                }
                else
                {
                    NSLog(@"%s encountered error:\t%@", __PRETTY_FUNCTION__, jsonDeserializationError);
                }
            }
            else if (webServiceResponseError != nil)
            {
                NSLog(@"%s encountered error:\t%@", __PRETTY_FUNCTION__, webServiceResponseError);
            }
        }
    }
    return returnObject;
}

@end
