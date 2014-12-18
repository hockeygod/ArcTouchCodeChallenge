//
//  ViewController.m
//  ArcTouchCodeChallenge
//
//  Created by Eric E. van Leeuwen on 12/5/14.
//  Copyright (c) 2014 Eric E. van Leeuwen. All rights reserved.
//

#import <MapKit/MapKit.h>

#import "ListViewController.h"
#import "DetailViewController.h"
#import "MapViewController.h"
#import "../Entities/Route.h"
#import "../Managers/WebServiceManager.h"

@interface ListViewController ()
#pragma mark - ListViewController Private Methods -
@property   (weak)  IBOutlet    UISearchBar                 *searchBar;
@property                       UIActivityIndicatorView     *activityIndicatorView;
@property                       NSArray                     *routes;

#pragma mark - ListViewController Private Instance Methods -
- (void)showActivityIndicator;
- (void)hideActivityIndicator;
- (IBAction)unwindToListViewController:(UIStoryboardSegue *)sender;

@end

@implementation ListViewController
#pragma mark - UIViewController Override Methods -
- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    //Query WebService for all routes as default
    [self showActivityIndicator];
    [[WebServiceManager webServiceManager] allRoutesWithCompletionHandler:^(NSArray *routes, NSError *error) {
        if (error == nil)
        {
            self.routes = routes;
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.tableView reloadData];
                [self hideActivityIndicator];
            });
        }
        else
        {
            NSLog(@"%s encountered error:\t%@", __PRETTY_FUNCTION__, error);
        }
    }];
    
    
    
    
    //Override the bookmarks search bar button image and set text to "Map"
    [self.searchBar setImage:nil forSearchBarIcon:UISearchBarIconBookmark state:UIControlStateNormal];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    //Transitioning to DetailViewController, set it's route to user selected route
    if ([segue.identifier isEqualToString:@"ShowDetailViewController"])
    {
        ((DetailViewController *)[segue destinationViewController]).theRoute = [self.routes objectAtIndex:[self.tableView indexPathForCell:sender].row];
    }
}

#pragma mark - UITableViewDataSource Protocol Methods -
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.routes.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *returnCell = [tableView dequeueReusableCellWithIdentifier:@"ListViewCell"];
    
    if (returnCell == nil)
    {
        returnCell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"ListViewCell"];
    }
    
    Route *routeForIndexPath = self.routes[indexPath.row];
    returnCell.textLabel.text = routeForIndexPath.longName;
    
    return returnCell;
}

#pragma mark - UISearchBarDelegate Protocol Methods -
- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
    /*
     * WebService calls can be heavy-weight, but if we wanted we could do routeByStopName
     * query on every keystroke here. What we will do here is on cancel/deletion of all text
     * refresh UITableView to default (which is the list of all routes)
     */
    if ([searchText isEqualToString:@""])
    {
        [searchBar resignFirstResponder];
        [self showActivityIndicator];
        [[WebServiceManager webServiceManager] allRoutesWithCompletionHandler:^(NSArray *routes, NSError *error) {
            if (error == nil)
            {
                self.routes = routes;
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self.tableView reloadData];
                    [self hideActivityIndicator];
                });
            }
            else
            {
                NSLog(@"%s encountered error:\t%@", __PRETTY_FUNCTION__, error);
            }
        }];
    }
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    //User enter stop name to query WebService for routes, query and reload UITableView
    [searchBar resignFirstResponder];
    [self showActivityIndicator];
    [[WebServiceManager webServiceManager] routesWithStopName:searchBar.text completionHandler:^(NSArray *routes, NSError *error) {
        if (error == nil)
        {
            self.routes = routes;
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.tableView reloadData];
                [self hideActivityIndicator];
            });
        }
        else
        {
            NSLog(@"%s encountered error:\t%@", __PRETTY_FUNCTION__, error);
        }
    }];
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar
{
    //Make sure UITableView is fresh and resign search bar as first responder
    [self.tableView reloadData];
    [searchBar resignFirstResponder];
}

#pragma mark - ListViewController Private Instance Methods -
- (void)showActivityIndicator
{
    if (self.activityIndicatorView == nil)
    {
        self.activityIndicatorView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        self.activityIndicatorView.color = [UIColor blackColor];
    }
    self.activityIndicatorView.center = self.tableView.tableHeaderView.center;
    [self.tableView.tableHeaderView addSubview:self.activityIndicatorView];
    [self.activityIndicatorView startAnimating];
}

- (void)hideActivityIndicator
{
    [self.activityIndicatorView stopAnimating];
    [self.activityIndicatorView removeFromSuperview];
}

- (IBAction)unwindToListViewController:(UIStoryboardSegue *)sender
{
    // As of now, we only handle unwinding from MapViewController but we could handle others by adding else if expressions
    if ([sender.sourceViewController isKindOfClass:[MapViewController class]])
    {
        //User selected stop name from Map View to query WebService for routes, query and reload UITableView
        self.searchBar.text = ((MapViewController *)sender.sourceViewController).selectedStreetPointAnnotation.title;
        [self showActivityIndicator];
        [[WebServiceManager webServiceManager] routesWithStopName:self.searchBar.text completionHandler:^(NSArray *routes, NSError *error) {
            if (error == nil)
            {
                self.routes = routes;
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self.tableView reloadData];
                    [self hideActivityIndicator];
                });
            }
            else
            {
                NSLog(@"%s encountered error:\t%@", __PRETTY_FUNCTION__, error);
            }
        }];
    }
}

@end
