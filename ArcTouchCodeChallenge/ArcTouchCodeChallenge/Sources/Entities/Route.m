//
//  Route.m
//  ArcTouchCodeChallenge
//
//  Created by Eric E. van Leeuwen on 12/5/14.
//  Copyright (c) 2014 Eric E. van Leeuwen. All rights reserved.
//

#import "Route.h"

@interface Route ()

@end

@implementation Route
#pragma mark - Route Class Methods -
+ (instancetype)routeFromJsonObject:(id)jsonObject
{
    Route *returnRoute = [Route new];
    
    returnRoute.routeId = jsonObject[@"id"];
    returnRoute.shortName = jsonObject[@"shortName"];
    returnRoute.longName = jsonObject[@"longName"];
    returnRoute.lastModifiedDate = jsonObject[@"lastModifiedDate"];
    returnRoute.agencyId = jsonObject[@"agencyId"];
    
    return returnRoute;
}

@end
