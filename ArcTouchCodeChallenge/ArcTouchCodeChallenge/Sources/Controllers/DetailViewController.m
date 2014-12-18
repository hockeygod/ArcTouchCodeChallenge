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
@property   (weak)      IBOutlet    UITableView                 *stopsTableView;
@property                           UIActivityIndicatorView     *stopsActivityIndicatorView;
@property                           NSArray                     *stops;
@property   (weak)      IBOutlet    UITableView                 *departuresTableView;
@property                           UIActivityIndicatorView     *departuresActivityIndicatorView;
@property                           NSArray                     *departures;

- (void)showStopsActivityIndicator;
- (void)hideStopsActivityIndicator;
- (void)showDeparturesActivityIndicator;
- (void)hideDeparturesActivityIndicator;
- (UIView *)departureHeaderViewForSection:(NSInteger)section;
- (NSInteger)numberOfRowsForDepartureSection:(NSInteger)section;
- (Departure *)departureForIndexPath:(NSIndexPath *)indexPath;
- (NSArray *)weekdayDepartures;
- (NSArray *)saturdayDepartures;
- (NSArray *)sundayDepartures;

@end

@implementation DetailViewController
#pragma mark - UIViewController Override Methods -
- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Do any additional setup after loading the view.
    //Query WebService for our Route's stops
    [self showStopsActivityIndicator];
    [[WebServiceManager webServiceManager] stopsForRouteId:self.theRoute.routeId completionHandler:^(NSArray *stops, NSError *error) {
        if (error == nil)
        {
            self.stops = stops;
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.stopsTableView reloadData];
                [self hideStopsActivityIndicator];
            });
        }
        else
        {
            NSLog(@"%s encountered error:\t%@", __PRETTY_FUNCTION__, error);
        }
    }];
    //Query WebService for our Route's departures
    [self showDeparturesActivityIndicator];
    [[WebServiceManager webServiceManager] departuresForRouteId:self.theRoute.routeId completionHandler:^(NSArray *departures, NSError *error) {
        if (error == nil)
        {
            self.departures = departures;
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.departuresTableView reloadData];
                [self hideDeparturesActivityIndicator];
            });
        }
        else
        {
            NSLog(@"%s encountered error:\t%@", __PRETTY_FUNCTION__, error);
        }
    }];
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
    UIView *viewForHeader = nil;
    
    //Stops
    if ([tableView isEqual:self.stopsTableView])
    {
        viewForHeader = nil;
    }
    //Departures
    else if ([tableView isEqual:self.departuresTableView])
    {
        viewForHeader = [self departureHeaderViewForSection:section];
    }
    
    return viewForHeader;
}

#pragma mark - UITableViewDataSource Protocol Methods -
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    NSInteger numberOfSections = 0;
    
    //Stops
    if ([tableView isEqual:self.stopsTableView])
    {
        numberOfSections = 1;
    }
    //Departures
    else if ([tableView isEqual:self.departuresTableView])
    {
        numberOfSections = 3;
    }
    
    return numberOfSections;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSInteger numberOfRows = 0;
    
    //Stops
    if ([tableView isEqual:self.stopsTableView])
    {
        numberOfRows = self.stops.count;
    }
    //Departures
    else if ([tableView isEqual:self.departuresTableView])
    {
        numberOfRows = [self numberOfRowsForDepartureSection:section];
    }
    
    return numberOfRows;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cellForRow = nil;
    
    //Stops
    if ([tableView isEqual:self.stopsTableView])
    {
        cellForRow = [tableView dequeueReusableCellWithIdentifier:@"DetailViewStopCell"];
        
        if (cellForRow == nil)
        {
            cellForRow = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"DetailViewStopCell"];
        }
        
        Stop *stopForIndexPath = self.stops[indexPath.row];
        cellForRow.textLabel.text = stopForIndexPath.name;
    }

    //Departures
    if ([tableView isEqual:self.departuresTableView])
    {
        cellForRow = [tableView dequeueReusableCellWithIdentifier:@"DetailViewDepartureCell"];
        
        if (cellForRow == nil)
        {
            cellForRow = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"DetailViewDepartureCell"];
        }
        
        Departure *departureForIndexPath = [self departureForIndexPath:indexPath];

        NSDateFormatter *dF = [NSDateFormatter new];
        dF.dateFormat = @"HH:mm";
        cellForRow.textLabel.text = [dF stringFromDate:departureForIndexPath.time];
    }

    return cellForRow;
}

#pragma mark - DetailViewController Private Instance Methods -
- (void)showStopsActivityIndicator;
{
    if (self.stopsActivityIndicatorView == nil)
    {
        self.stopsActivityIndicatorView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        self.stopsActivityIndicatorView.color = [UIColor blackColor];
    }
    self.stopsActivityIndicatorView.center = self.stopsTableView.tableHeaderView.center;
    self.stopsTableView.tableHeaderView = self.stopsActivityIndicatorView;
    [self.stopsActivityIndicatorView startAnimating];
}

- (void)hideStopsActivityIndicator;
{
    [self.stopsActivityIndicatorView stopAnimating];
    self.stopsTableView.tableHeaderView = nil;
}

- (void)showDeparturesActivityIndicator;
{
    if (self.departuresActivityIndicatorView == nil)
    {
        self.departuresActivityIndicatorView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        self.departuresActivityIndicatorView.color = [UIColor blackColor];
    }
    self.departuresActivityIndicatorView.center = self.departuresTableView.tableHeaderView.center;
    self.departuresTableView.tableHeaderView = self.departuresActivityIndicatorView;
    [self.departuresActivityIndicatorView startAnimating];
}

- (void)hideDeparturesActivityIndicator;
{
    [self.departuresActivityIndicatorView stopAnimating];
    self.departuresTableView.tableHeaderView = nil;
}

- (UIView *)departureHeaderViewForSection:(NSInteger)section
{
    UIView *departureHeaderView = nil;
    
    NSString *departureDayString = nil;

    switch (section) {
        case 0: //Weekdays
        {
            departureDayString = @"Weekdays";
            break;
        }
        case 1: //Saturday
        {
            departureDayString = @"Saturday";
            break;
        }
        case 2:  //Sunday
        {
            departureDayString = @"Sunday";
            break;
        }
    }
    
    if (departureDayString != nil)
    {
        UILabel *workingView = [[UILabel alloc] initWithFrame:CGRectZero];
        workingView.text = departureDayString;
        [workingView sizeToFit];
        departureHeaderView = workingView;
    }

    return departureHeaderView;
}

- (NSInteger)numberOfRowsForDepartureSection:(NSInteger)section
{
    NSInteger numberOfRows = 0;
    
    switch (section) {
        case 0: //Weekdays
        {
            numberOfRows = [self weekdayDepartures].count;
            break;
        }
        case 1: //Saturday
        {
            numberOfRows = [self saturdayDepartures].count;
            break;
        }
        case 2:  //Sunday
        {
            numberOfRows = [self sundayDepartures].count;
            break;
        }
    }
    
    return numberOfRows;
}

- (Departure *)departureForIndexPath:(NSIndexPath *)indexPath
{
    Departure *departure = nil;
    
    switch (indexPath.section) {
        case 0: //Weekdays
        {
            departure = [self weekdayDepartures][indexPath.row];
            break;
        }
        case 1: //Saturday
        {
            departure = [self saturdayDepartures][indexPath.row];
            break;
        }
        case 2:  //Sunday
        {
            departure = [self sundayDepartures][indexPath.row];
            break;
        }
    }
    
    return departure;
}

- (NSArray *)weekdayDepartures
{
    return [self.departures filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"%K like %@", @"calendar", CALENDAR_WEEKDAY]];
}

- (NSArray *)saturdayDepartures
{
    return [self.departures filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"%K like %@", @"calendar", CALENDAR_SATURDAY]];
}

- (NSArray *)sundayDepartures
{
    return [self.departures filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"%K like %@", @"calendar", CALENDAR_SUNDAY]];
}


@end
