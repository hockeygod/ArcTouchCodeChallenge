//
//  DetailViewController.m
//  ArcTouchCodeChallenge
//
//  Created by Eric E. van Leeuwen on 12/5/14.
//  Copyright (c) 2014 Eric E. van Leeuwen. All rights reserved.
//

#import "DetailViewController.h"
#import "../Entities/Departure.h"
#import "../Entities/Route.h"
#import "../Entities/Stop.h"
#import "../Managers/WebServiceManager.h"

@interface DetailViewController ()
#pragma mark - DetailViewController Private Properties -
@property   (weak)      IBOutlet    UITableView     *stopsTableView;
@property                           NSArray         *stops;
@property   (weak)      IBOutlet    UITableView     *departuresTableView;
@property                           NSArray         *departures;
@end

@implementation DetailViewController
#pragma mark - UIViewController Override Methods -
- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Do any additional setup after loading the view.
    //Query WebService for our Route's stops
    self.stops = [[WebServiceManager webServiceManager] stopsForRouteId:self.theRoute.routeId];
    //Query WebService for our Route's stops
    self.departures = [[WebServiceManager webServiceManager] departuresForRouteId:self.theRoute.routeId];
    /*
     * As of iOS7, Apple does some "automatic" layout stuff that doesn't look good, which creates a 
     * large gap at top of UITableViews. Undo this "automatic" layout stuff.
     */
    self.automaticallyAdjustsScrollViewInsets = NO;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    //Set Navigation title to our Route's name
    self.navigationItem.title = self.theRoute.longName;
}

#pragma mark - UITableViewDelegate Protocol Methods -
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *returnView = nil;
    
    //Stops
    if ([tableView isEqual:self.stopsTableView])
    {
        returnView = nil;
    }
    //Departures
    else if ([tableView isEqual:self.departuresTableView])
    {
        switch (section) {
            case 0: //Weekdays
            {
                UILabel *workingView = [[UILabel alloc] initWithFrame:CGRectZero];
                workingView.text = @"Weekdays";
                [workingView sizeToFit];
                returnView = workingView;
                break;
            }
            case 1: //Saturday
            {
                UILabel *workingView = [[UILabel alloc] initWithFrame:CGRectZero];
                workingView.text = @"Saturday";
                [workingView sizeToFit];
                returnView = workingView;
                break;
            }
            case 2:  //Sunday
            {
                UILabel *workingView = [[UILabel alloc] initWithFrame:CGRectZero];
                workingView.text = @"Sunday";
                [workingView sizeToFit];
                returnView = workingView;
                break;
            }
        }
    }
    
    return returnView;
}

#pragma mark - UITableViewDataSource Protocol Methods -
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    NSInteger returnInteger = 0;
    
    //Stops
    if ([tableView isEqual:self.stopsTableView])
    {
        returnInteger = 1;
    }
    //Departures
    else if ([tableView isEqual:self.departuresTableView])
    {
        returnInteger = 3;
    }
    
    return returnInteger;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSInteger returnInteger = 0;
    
    //Stops
    if ([tableView isEqual:self.stopsTableView])
    {
        returnInteger = self.stops.count;
    }
    //Departures
    else if ([tableView isEqual:self.departuresTableView])
    {
        switch (section) {
            case 0: //Weekdays
            {
                returnInteger = [self.departures filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"%K like %@", @"calendar", CALENDAR_WEEKDAY]].count;
                break;
            }
            case 1: //Saturday
            {
                returnInteger = [self.departures filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"%K like %@", @"calendar", CALENDAR_SATURDAY]].count;
                break;
            }
            case 2:  //Sunday
            {
                returnInteger = [self.departures filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"%K like %@", @"calendar", CALENDAR_SUNDAY]].count;
                break;
            }
        }
    }
    
    return returnInteger;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *returnCell = nil;
    
    //Stops
    if ([tableView isEqual:self.stopsTableView])
    {
        UITableViewCell *returnCell = [tableView dequeueReusableCellWithIdentifier:@"DetailViewStopCell"];
        
        if (returnCell == nil)
        {
            returnCell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"DetailViewStopCell"];
        }
        
        Stop *stopForIndexPath = self.stops[indexPath.row];
        returnCell.textLabel.text = stopForIndexPath.name;
        
        return returnCell;
    }
    //Departures
    if ([tableView isEqual:self.departuresTableView])
    {
        UITableViewCell *returnCell = [tableView dequeueReusableCellWithIdentifier:@"DetailViewDepartureCell"];
        
        if (returnCell == nil)
        {
            returnCell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"DetailViewDepartureCell"];
        }
        
        Departure *departureForIndexPath = nil;
        switch (indexPath.section) {
            case 0: //Weekdays
            {
                departureForIndexPath = [self.departures filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"%K like %@", @"calendar", CALENDAR_WEEKDAY]][indexPath.row];
                break;
            }
            case 1: //Saturday
            {
                departureForIndexPath = [self.departures filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"%K like %@", @"calendar", CALENDAR_SATURDAY]][indexPath.row];
                break;
            }
            case 2:  //Sunday
            {
                departureForIndexPath = [self.departures filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"%K like %@", @"calendar", CALENDAR_SUNDAY]][indexPath.row];
                break;
            }
        }
        NSDateFormatter *dF = [NSDateFormatter new];
        dF.dateFormat = @"HH:mm";
        returnCell.textLabel.text = [dF stringFromDate:departureForIndexPath.time];
        
        return returnCell;
    }

    return returnCell;
}

@end
