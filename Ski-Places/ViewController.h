//
//  ViewController.h
//  Ski-Places
//
//  Created by Paul Nitto on 1/28/16.
//  Copyright © 2016 Paul Nitto. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import <CoreLocation/CoreLocation.h>

@interface ViewController : UIViewController <UITableViewDataSource, UITableViewDelegate, MKMapViewDelegate>
@property (nonatomic, strong) CLLocationManager *locationManager;
@property(assign, nonatomic) CLLocationDistance distanceFiler;
@property (nonatomic, retain) CLRegion *region;
@property(assign, nonatomic) CLLocationDistance radius;
@property (weak, nonatomic) IBOutlet MKMapView *mapView;
@property (weak, nonatomic) IBOutlet UILabel *longLabel;
@property (weak, nonatomic) IBOutlet UILabel *latLabel;
@property (nonatomic, strong) NSMutableArray *skiPlaces;
@property (weak, nonatomic) IBOutlet UITableView *randomTable;

@end



