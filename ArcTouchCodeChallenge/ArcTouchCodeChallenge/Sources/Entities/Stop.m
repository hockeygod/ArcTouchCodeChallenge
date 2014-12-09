//
//  Stop.m
//  ArcTouchCodeChallenge
//
//  Created by Eric E. van Leeuwen on 12/5/14.
//  Copyright (c) 2014 Eric E. van Leeuwen. All rights reserved.
//

#import "Stop.h"

@implementation Stop
#pragma mark - Stop Class Methods -
+ (instancetype)stopFromJsonObject:(id)jsonObject
{
    Stop *returnStop = [Stop new];
    
    returnStop.stopId = jsonObject[@"id"];
    returnStop.name = jsonObject[@"name"];
    returnStop.sequence = jsonObject[@"sequence"];
    returnStop.routeId = jsonObject[@"route_id"];
    
    return returnStop;
}

@end
