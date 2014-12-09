//
//  Departure.m
//  ArcTouchCodeChallenge
//
//  Created by Eric E. van Leeuwen on 12/6/14.
//  Copyright (c) 2014 Eric E. van Leeuwen. All rights reserved.
//

#import "Departure.h"

#pragma mark - Departure Constants -
NSString  *CALENDAR_WEEKDAY   =   @"WEEKDAY";
NSString  *CALENDAR_SATURDAY  =   @"SATURDAY";
NSString  *CALENDAR_SUNDAY    =   @"SUNDAY";

@implementation Departure
#pragma mark - Departure Class Methods -
+ (instancetype)departureFromJsonObject:(id)jsonObject
{
    Departure *returnDeparture = [Departure new];
    
    returnDeparture.departureId = jsonObject[@"id"];
    returnDeparture.calendar = jsonObject[@"calendar"];
    
    NSDateFormatter *dF = [NSDateFormatter new];
    dF.dateFormat = @"HH:mm";    
    returnDeparture.time = [dF dateFromString:jsonObject[@"time"]];

    return returnDeparture;
}

@end
