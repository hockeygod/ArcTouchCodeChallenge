//
//  WebServiceManager.h
//  ArcTouchCodeChallenge
//
//  Created by Eric E. van Leeuwen on 12/5/14.
//  Copyright (c) 2014 Eric E. van Leeuwen. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WebServiceManager : NSObject
#pragma mark - WebServiceManager Typedefs -
typedef void    (^WebServiceManagerRoutesCompletionHandler)      (NSArray *routes, NSError *error);
typedef void    (^WebServiceManagerStopsCompletionHandler)      (NSArray *stops, NSError *error);
typedef void    (^WebServiceManagerDeparturesCompletionHandler) (NSArray *departures, NSError *error);

#pragma mark - WebServiceManager Class Methods -
+ (instancetype)webServiceManager;

#pragma mark - WebServiceManager Instance Methods -
- (void)allRoutesWithCompletionHandler:(WebServiceManagerRoutesCompletionHandler)completionHandler;
- (void)routesWithStopName:(NSString *)stopName completionHandler:(WebServiceManagerRoutesCompletionHandler)completionHandler;
- (void)stopsForRouteId:(NSNumber *)routeId completionHandler:(WebServiceManagerStopsCompletionHandler)completionHandler;
- (void)departuresForRouteId:(NSNumber *)routeId completionHandler:(WebServiceManagerDeparturesCompletionHandler)completionHandler;

@end
