//
//  ViewController.m
//  ArcTouchCodeChallenge
//
//  Created by Eric E. van Leeuwen on 12/5/14.
//  Copyright (c) 2014 Eric E. van Leeuwen. All rights reserved.
//

#import "ListViewController.h"
#import "DetailViewController.h"
#import "../Entities/Route.h"
#import "../Managers/WebServiceManager.h"

@interface ListViewController ()
#pragma mark - ListViewController Private Methods -
@property   NSArray     *routes;

@end

@implementation ListViewController
#pragma mark - UIViewController Override Methods -
- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    //Query WebService for all routes as default
    self.routes = [[WebServiceManager webServiceManager] allRoutes];
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
        self.routes = [[WebServiceManager webServiceManager] allRoutes];
        [self.tableView reloadData];
        [searchBar resignFirstResponder];
    }
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    //User enter stop name to query WebService for routes, query and reload UITableView
    self.routes = [[WebServiceManager webServiceManager] routesWithStopName:[searchBar text]];
    [self.tableView reloadData];
    [searchBar resignFirstResponder];
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar
{
    //Make sure UITableView is fresh and resign search bar as first responder
    [self.tableView reloadData];
    [searchBar resignFirstResponder];
}

@end
