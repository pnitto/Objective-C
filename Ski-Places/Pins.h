//
//  Pins.h
//  Ski-Places
//
//  Created by Paul Nitto on 1/28/16.
//  Copyright © 2016 Paul Nitto. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>

@interface Pins : NSObject <MKAnnotation>
@property(nonatomic, assign) CLLocationCoordinate2D coordinate;
@property(nonatomic, copy) NSString *title;
@property(nonatomic, copy) NSString *subtitle;

@end


