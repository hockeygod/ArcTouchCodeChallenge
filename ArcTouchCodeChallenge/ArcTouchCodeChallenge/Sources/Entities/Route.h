//
//  Route.h
//  ArcTouchCodeChallenge
//
//  Created by Eric E. van Leeuwen on 12/5/14.
//  Copyright (c) 2014 Eric E. van Leeuwen. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Route : NSObject
#pragma mark - Route Properties -
@property   NSNumber    *routeId;
@property   NSString    *shortName;
@property   NSString    *longName;
@property   NSDate      *lastModifiedDate;
@property   NSNumber    *agencyId;

#pragma mark - Route Class Methods -
+ (instancetype)routeFromJsonObject:(id)jsonObject;

@end
