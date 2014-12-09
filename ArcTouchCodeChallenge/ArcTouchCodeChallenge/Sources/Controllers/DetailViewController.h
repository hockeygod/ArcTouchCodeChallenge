//
//  DetailViewController.h
//  ArcTouchCodeChallenge
//
//  Created by Eric E. van Leeuwen on 12/5/14.
//  Copyright (c) 2014 Eric E. van Leeuwen. All rights reserved.
//

#import <UIKit/UIKit.h>

@class Route;

@interface DetailViewController : UIViewController <UITableViewDataSource, UITableViewDelegate>
#pragma mark - DetailViewController Properties -
@property   Route       *theRoute;

@end
