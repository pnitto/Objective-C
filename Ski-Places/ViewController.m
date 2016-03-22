//
//  ViewController.m
//  Ski-Places
//
//  Created by Paul Nitto on 1/28/16.
//  Copyright © 2016 Paul Nitto. All rights reserved.
//

#import "ViewController.h"
#import "Pins.h"
#import "SecondViewController.h"
#import "CameraViewController.h"
#import "AppTheme.h"
#define METERS_MILE 1609.344
#define METERS_FEET 3.28084
#define beechLat -81.87767028808594
#define beechLong 36.1961377341364
//#define center -81.87080383300781,36.16305869763924
//#define sugar -81.859130859375,36.1283603994047
//#define sugarmnt -81.85981750488281,36.12743641786611

@interface ViewController ()
<CLLocationManagerDelegate,
 SecondViewControllerDelegate,
CameraViewControllerDelegate>
@end
double (^distanceFromRateAndTime)(double rate, double time);

@implementation ViewController
//void means it returns nothing


- (void)viewDidLoad {
    [super viewDidLoad];
    [self.mapView setDelegate:self];
    
    [self startStandardUpdates];
    
    if ([[self locationManager] respondsToSelector:@selector(requestAlwaysAuthorization)]) {
        [[self locationManager] requestAlwaysAuthorization];
    }
    [[self locationManager] startUpdatingLocation];
    
    [[self mapView] setShowsUserLocation:YES];
    
    self.mapView.mapType = MKMapTypeHybrid;
    
    [self getFences];
    //[self addPins];
    
    //Initial view of the map
    MKCoordinateRegion theRegion;
    
    //Center
    CLLocationCoordinate2D center;
    center.latitude =  36.12743641786611;
    center.longitude = -81.85981750488281;
    
    //Span
    MKCoordinateSpan span;
    span.latitudeDelta = 0.30f;
    span.longitudeDelta   = 0.30f;
    
    theRegion.center = center;
    theRegion.span = span;
    [self.mapView setRegion:theRegion animated:YES];
    
    //Creating an array for ski resort locations
    self.skiPlaces = [[NSMutableArray alloc] init];
    CLLocationCoordinate2D location;
    
    //creating each pin and adding it into the array
    Pins * myPins;
    
    myPins = [[Pins alloc] init];
    location.latitude = 36.1283603994047;
    location.longitude = -81.859130859375;
    myPins.coordinate = location;
    myPins.title = @"Sugar Mountain";
    myPins.subtitle = @"Great Snowboarding";
    myPins.averageRating = [[NSMutableArray alloc]init];
    [self.skiPlaces addObject:myPins];
    
    myPins = [[Pins alloc] init];
    location.latitude = 36.1961377341364;
    location.longitude =  -81.87767028808594;
    myPins.coordinate = location;
    myPins.title = @"Beech Mountain";
    myPins.subtitle = @"Great Snowboarding";
    myPins.averageRating = [[NSMutableArray alloc]init];
    [self.skiPlaces addObject:myPins];
    
    myPins =[[Pins alloc] init];
    location.latitude = 36.1744099;
    location.longitude = -81.664746;
    myPins.coordinate = location;
    myPins.title = @"App Ski Resort";
    myPins.subtitle = @"Cool Terrain Parks";
    myPins.averageRating = [[NSMutableArray alloc]init];
    [self.skiPlaces addObject:myPins];
    
    myPins = [[Pins alloc] init];
    location.latitude = 35.562438;
    location.longitude = -83.0921527;
    myPins.coordinate = location;
    myPins.title = @"Cataloochee Ski Resort";
    myPins.subtitle = @"Cool Rail Section";
    myPins.averageRating = [[NSMutableArray alloc] init];
    [self.skiPlaces addObject:myPins];
    
    //adding all the pins to mapView
    [self.mapView addAnnotations:self.skiPlaces];
}

-(void)viewWillAppear:(BOOL)animated
{
    /*Blocks
    distanceFromRateAndTime = ^double(double rate, double time) {
        return rate * time;
    };
    
    double dx = distanceFromRateAndTime(arc4random(), 1.5);
    
    __block int i = 0;
    int(^count)(void) = ^ {
        i += 1;
        return i;
    };
    NSLog(@"Count:%d",count());

    NSLog(@"Testing Block: %.2f",dx);
     */
}
//initialize CLLocationManager object
-(void)startStandardUpdates {
    self.locationManager = [[CLLocationManager alloc] init];
    [[self locationManager] setDelegate:self];
    [[self locationManager] setDesiredAccuracy:kCLLocationAccuracyBest];
    // minimum distance a device must move horizontally in order to generate an update event
    [[self locationManager] setDistanceFilter: 10];
}

-(void)getFences {
    //Ski Region
    CLLocationCoordinate2D skiCenter = CLLocationCoordinate2DMake(36.16305869763924,-81.87080383300781);
    CLRegion *skiRegion = [[CLCircularRegion alloc] initWithCenter:skiCenter radius:3000 identifier:@"SkiRegion"];
    [self.locationManager startMonitoringForRegion:skiRegion];
    //NSLog(@"Ski Region: %@", skiRegion);
    /*
     //manhattan region
     CLLocationCoordinate2D Mancenter = CLLocationCoordinate2DMake(40.759211, -73.984638);
     CLRegion *manRegion = [[CLCircularRegion alloc]initWithCenter: Mancenter radius:3000 identifier:@"ManRegion"];
     [self.locationManager startMonitoringForRegion:manRegion];
     NSLog(@"Manhattan Region: %@", manRegion);
     
     //South Region
     CLLocationCoordinate2D Southcenter = CLLocationCoordinate2DMake(34.16522710180288, -83.86962890625);
     CLRegion *southRegion = [[CLCircularRegion alloc] initWithCenter:Southcenter radius:3000 identifier:@"SouthRegion"];
     [self.locationManager startMonitoringForRegion:southRegion];
     NSLog(@"South Region %@", southRegion);
     */
}

//tells delegate the location of the user was updated.
-(void)mapView:(MKMapView *)mapView didUpdateUserLocation:(MKUserLocation *)userLocation {
    self.mapView.centerCoordinate = userLocation.location.coordinate;
}

-(void) locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray<CLLocation *> *)locations {
    NSLog(@"location manager: %@", manager.location);
    
    if(manager.location){
        CLLocation *last_location = manager.location;
    
        [[self latLabel] setText:[NSString stringWithFormat:@"%.6f", last_location.coordinate.latitude ]];
        [[self longLabel] setText:[NSString stringWithFormat:@"%.6f", last_location.coordinate.longitude]];

    
    
    /*MKCoordinateRegion viewRegion = MKCoordinateRegionMakeWithDistance(location.coordinate, 10*METERS_MILE, 10*METERS_MILE);
     [[self mapView] setRegion:viewRegion animated:YES];
     */
    
    NSURLSessionConfiguration *config = [NSURLSessionConfiguration defaultSessionConfiguration];
    NSURLSession *session = [NSURLSession sessionWithConfiguration:config];
    
    NSMutableDictionary *loc_input = [[NSMutableDictionary alloc] init];
    
    NSString *lat = [NSString stringWithFormat:@"%f",last_location.coordinate.latitude];
    NSString *longitude = [NSString stringWithFormat:@"%f",last_location.coordinate.longitude];
    
    [loc_input setObject:lat forKey:@"latitude"];
    [loc_input setObject:longitude forKey:@"longitude"];
    
    NSError *error;
    NSData *data = [NSJSONSerialization dataWithJSONObject:loc_input options:0 error:&error];
    
    NSString *loc_length = [NSString stringWithFormat:@"%lu",[data length]];
    NSURL *url = [NSURL URLWithString:@"http://127.0.0.1:5000/location/add_location"];

        NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:url];
    
    [request setHTTPMethod:@"POST"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [request setValue:loc_length forHTTPHeaderField:@"Content-Length"];
    [request setHTTPBody:data];
    
    if(!error) {
        NSURLSessionUploadTask *uploadTask = [session uploadTaskWithRequest:request fromData:data completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
            NSLog(@"Response: %@", response);
            //NSLog(@"Error: %@", error);
        }];
        [uploadTask resume];
     }
  
    }
}

//checking to see if the user granted access to their location (could change)
-(void) locationManager:(CLLocationManager *)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status {
    
    if (status == kCLAuthorizationStatusDenied) {
        NSLog(@"Location Not Found");
    }
    else if (status == kCLAuthorizationStatusAuthorizedAlways) {
        //[[self locationManager] startUpdatingLocation];
        
    }
    
}

-(void)locationManager:(CLLocationManager *)manager didStartMonitoringForRegion:(CLRegion *)region {
    NSLog(@"%@ is being monitored",region);
    [self.locationManager requestStateForRegion:region];
}
-(void)locationManager:(CLLocationManager *)manager monitoringDidFailForRegion:(CLRegion *)region withError:(NSError *)error{
    NSLog(@"Error: %@", error);
}

-(void)locationManager:(CLLocationManager *)manager didEnterRegion:(CLRegion *)region {
    NSLog(@"Entered %@ region", region);
}
-(void)locationManager:(CLLocationManager *)manager didExitRegion:(CLRegion *)region {
    NSLog(@"Did exit region");
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.skiPlaces count];
}
//populating the table from the ski Places array, does a check to make sure the array has objects in it.
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ThisCell"];
    NSMutableArray *names = [[NSMutableArray alloc] init];
    for( Pins *loc in self.skiPlaces) {
        [names addObject:loc.title];
        //NSLog(@"Name: %@",names);
        if([names count] > 0 && [names count] > indexPath.row){
            cell.textLabel.text = [names objectAtIndex:indexPath.row];
        }
        else {
            //NSLog(@"This is an empty array");
        }
    }
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    return cell;
}
//when a cell is clicked in the table a callout appears above the pin with that objects info
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    NSLog(@"Clicked %@", cell.textLabel.text);
    [self.mapView selectAnnotation:[self.skiPlaces objectAtIndex:indexPath.row] animated:YES];
}

// checks to see if the class is a user's location object, adds an image to the leftcalloutaccessory, changed pin color to green
-(MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation {
    
    if ([annotation isKindOfClass:[MKUserLocation class]])
        return nil;
    
    MKPinAnnotationView *aView =(MKPinAnnotationView*) [self.mapView dequeueReusableAnnotationViewWithIdentifier:@"imageView"];
    aView = [[MKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:@"imageView"];
    aView.canShowCallout = YES;
    aView.pinTintColor = [UIColor WoozleGreyColor];
    aView.leftCalloutAccessoryView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 30, 30)];
    [(UIImageView *)aView.leftCalloutAccessoryView setImage:[UIImage imageNamed:@"boarding"]];
    
    UIButton *rightButton = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
    //[rightButton addTarget:self action:@selector(showDetail:) forControlEvents:UIControlEventTouchUpInside];
    
    rightButton.tintColor = UIColor.redColor;
    aView.rightCalloutAccessoryView = rightButton;
    aView.enabled = YES;
    aView.annotation = annotation;
    return aView;
}

-(void)mapView:(MKMapView *)mapView annotationView:(MKAnnotationView *)view calloutAccessoryControlTapped:(UIControl *)control {

    SecondViewController *detailViewController = [[SecondViewController alloc] initWithNibName:@"SecondViewController" bundle:nil];

    detailViewController.delegate = self;

    //[self.navigationController pushViewController:detailViewController animated:YES];

    [self presentViewController:detailViewController animated:YES completion:nil];

    NSLog(@"details: %@", view.annotation.title);
    Pins *details = view.annotation;
    
    
    detailViewController.skiPlaceName.text = details.title;
    detailViewController.placeDescription.text = details.subtitle;
    detailViewController.ratingArray = details.averageRating;
    detailViewController.averageRating = details.rating;

    NSLog(@"Name: %@, Average: %f",details.title, details.rating);
    NSLog(@"Rating List: %@", details.averageRating);
}
-(void)secondViewControllerIsDone:(SecondViewController *)SecondViewController {
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(void)cameraViewControllerIsDone:(CameraViewController *)CameraViewController {
    NSLog(@"Tapped Back button for camera");
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)centerOnUser:(id)sender {
    
    MKCoordinateRegion theRegion;
    
    //Center
    CLLocationCoordinate2D center;
    center.latitude =  36.12743641786611;
    center.longitude = -81.85981750488281;
    
    //Span
    MKCoordinateSpan span;
    span.latitudeDelta = 0.30f;
    span.longitudeDelta   = 0.30f;
    
    theRegion.center = center;
    theRegion.span = span;

    [self.mapView setRegion:theRegion animated:YES];
}
@end
