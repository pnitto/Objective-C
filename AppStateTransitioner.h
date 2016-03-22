//
//  AppStateTransitioner.h
//  Ski-Places
//
//  Created by Paul Nitto on 3/22/16.
//  Copyright © 2016 Paul Nitto. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AppStateTransitioner : NSObject

+(void)transitionToOnBoardingAnimated: (BOOL)animated;

+(void)transitionToMainAppAnimated:(BOOL)animated;

@end
