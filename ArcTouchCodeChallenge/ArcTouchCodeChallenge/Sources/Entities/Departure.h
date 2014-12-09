//
//  Departure.h
//  ArcTouchCodeChallenge
//
//  Created by Eric E. van Leeuwen on 12/6/14.
//  Copyright (c) 2014 Eric E. van Leeuwen. All rights reserved.
//

#import <Foundation/Foundation.h>

#pragma mark - Departure Constants -
extern  NSString    *CALENDAR_WEEKDAY;
extern  NSString    *CALENDAR_SATURDAY;
extern  NSString    *CALENDAR_SUNDAY;

@interface Departure : NSObject
#pragma mark - Departure Properties -
@property   NSNumber    *departureId;
@property   NSString    *calendar;
@property   NSDate      *time;

#pragma mark - Departure Class Methods -
+ (instancetype)departureFromJsonObject:(id)jsonObject;

@end
