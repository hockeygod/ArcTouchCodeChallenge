//
//  Stop.h
//  ArcTouchCodeChallenge
//
//  Created by Eric E. van Leeuwen on 12/5/14.
//  Copyright (c) 2014 Eric E. van Leeuwen. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Stop : NSObject
#pragma mark - Stop Properties -
@property   NSNumber        *stopId;
@property   NSString        *name;
@property   NSNumber        *sequence;
@property   NSNumber        *routeId;

#pragma mark - Stop Class Methods -
+ (instancetype)stopFromJsonObject:(id)jsonObject;

@end
