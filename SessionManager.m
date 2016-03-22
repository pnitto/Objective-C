//
//  SessionManager.m
//  Ski-Places
//
//  Created by Paul Nitto on 3/22/16.
//  Copyright © 2016 Paul Nitto. All rights reserved.
//

#import "SessionManager.h"




static NSString * const BaseURL = @"http://localhost:3000/";
static NSString * const kDeviceTokenKey = @"kDeviceTokenKey";
static NSString * const kDeviceSecretKey = @"kDeviceSecretKey";
static NSString * const kKeychainService = @"kKeychainService";

static NSString * const kLastKnownLocationsKey = @"kLastKnownLocationsKey";

@interface SessionManager ()<CLLocationManagerDelegate>

@property(nonatomic,strong) NSString *deviceSecret;

@property(nonatomic,strong,readonly) NSURL *baseURL;

@property(nonatomic,strong) NSString *pendingNonce;

@end

static SessionManager *sharedSession;

@implementation SessionManager

+ (instancetype)sharedSession
{
    if (!sharedSession) {
        static dispatch_once_t onceToken;
        dispatch_once(&onceToken, ^{
            sharedSession = [[self alloc] init];
        });
    }
    
    return sharedSession;
}
-(BOOL)isLoggedIn
{
    return (self.deviceSecret && self.deviceToken);
}


@end

