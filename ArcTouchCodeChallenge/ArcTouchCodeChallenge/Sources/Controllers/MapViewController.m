//
//  MapViewController.m
//  ArcTouchCodeChallenge
//
//  Created by Eric E. van Leeuwen on 12/8/14.
//  Copyright (c) 2014 Eric E. van Leeuwen. All rights reserved.
//

#import <MapKit/MapKit.h>
#import <CoreLocation/CoreLocation.h>

#import "MapViewController.h"

@interface MapViewController ()
#pragma mark - MapViewController Private Methods -
@property                       CLGeocoder              *geocoder;
@property   (weak)  IBOutlet    MKMapView               *mapView;

#pragma mark - MapViewController Private Instance Methods -
- (void)mapViewLongPressGestureMethod:(UITapGestureRecognizer *)gesture;

@end

@implementation MapViewController
#pragma mark - UIViewController Override Methods -
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.geocoder = [CLGeocoder new];
    
    CLLocationCoordinate2D centerCoordinate = CLLocationCoordinate2DMake(-27.592212, -48.53428889999998);
    [self.mapView setRegion:MKCoordinateRegionMake(centerCoordinate, MKCoordinateSpanMake(0.1, 0.1)) animated:NO];
    MKPointAnnotation *centerPointAnnotation = [MKPointAnnotation new];
    centerPointAnnotation.coordinate = centerCoordinate;
    centerPointAnnotation.title = @"Florianópolis, SC, Brazil";
    [self.mapView addAnnotation:centerPointAnnotation];
    
    UILongPressGestureRecognizer *mapViewTap = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(mapViewLongPressGestureMethod:)];
    [self.mapView addGestureRecognizer:mapViewTap];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - MapViewController Private Instance Methods -
- (void)mapViewLongPressGestureMethod:(UITapGestureRecognizer *)gesture
{
    if (gesture.state == UIGestureRecognizerStateEnded)
    {
        if (self.selectedStreetPointAnnotation != nil)
        {
            [self.mapView removeAnnotation:self.selectedStreetPointAnnotation];
        }
        
        CLLocationCoordinate2D longPressCoordinate = [self.mapView convertPoint:[gesture locationInView:self.mapView] toCoordinateFromView:self.mapView];
        self.selectedStreetPointAnnotation = [MKPointAnnotation new];
        self.selectedStreetPointAnnotation.coordinate = longPressCoordinate;
        
        [self.geocoder reverseGeocodeLocation:[[CLLocation alloc] initWithLatitude:longPressCoordinate.latitude longitude:longPressCoordinate.longitude] completionHandler:^(NSArray *placemarks, NSError *error) {
            if (error == nil)
            {
                if (placemarks.count == 1)
                {
                    self.selectedStreetPointAnnotation.title = ((MKPlacemark *)placemarks[0]).thoroughfare;
                }
            }
            else
            {
                NSLog(@"%s error encoutered:\t%@", __PRETTY_FUNCTION__, error);
            }
            [self.mapView addAnnotation:self.selectedStreetPointAnnotation];
            [self.mapView selectAnnotation:self.selectedStreetPointAnnotation animated:YES];
        }];
    }
}

@end
