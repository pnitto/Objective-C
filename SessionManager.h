//
//  SessionManager.h
//  Ski-Places
//
//  Created by Paul Nitto on 3/22/16.
//  Copyright © 2016 Paul Nitto. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>

static NSString * const kLocationServicesAuthorizationStatusDidChange = @"kLocationServicesAuthorizationStatusDidChange";

typedef void (^SessionManagerCompletionBlock)(BOOL success, NSString *errorMessage, id resultObject);



@interface SessionManager : NSObject

@property(nonatomic,strong,readonly) CLLocationManager *locationManager;
@property(nonatomic,strong,readonly) CLLocation *lastKnownLocation;
@property(nonatomic,strong) NSString *pushToken;
@property(nonatomic,strong,readonly) NSString *deviceToken;

+(instancetype)sharedSession;
-(BOOL)isLoggedIn;
/*
- (void)registerNewDeviceWithCompletion:(SessionManagerCompletionBlock)completionBlock;

- (void)validateCurrentDeviceWithNonce:(NSString*)nonce withCompletion:(SessionManagerCompletionBlock)completion;

- (void)getPlacesForMarket:(NSString*)market withCompletion:(SessionManagerCompletionBlock)completion;

- (void)getDetailForPlaceID:(NSString*)placeID withCompletion:(SessionManagerCompletionBlock)completion;

*/
@end
