//
//  MapViewController.h
//  ArcTouchCodeChallenge
//
//  Created by Eric E. van Leeuwen on 12/8/14.
//  Copyright (c) 2014 Eric E. van Leeuwen. All rights reserved.
//

#import <UIKit/UIKit.h>

@class MKPointAnnotation;

@interface MapViewController : UIViewController
#pragma mark - MapViewController Properties -
@property   MKPointAnnotation       *selectedStreetPointAnnotation;

@end
