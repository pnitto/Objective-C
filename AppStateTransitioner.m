//
//  AppStateTransitioner.m
//  Ski-Places
//
//  Created by Paul Nitto on 3/22/16.
//  Copyright © 2016 Paul Nitto. All rights reserved.
//

#import "AppStateTransitioner.h"
#import "CoreLocation/CoreLocation.h"
#import "OnboardingViewController.h"
#import "AppDelegate.h"
#import "ViewController.h"

@implementation AppStateTransitioner

+(void)switchAppContextToViewController:(UIViewController*)controller animated:(BOOL)animated
{
    AppDelegate *appDel = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    BOOL appIsBackgrounded = [[UIApplication sharedApplication] applicationState] ==
    UIApplicationStateBackground;
    
    if(animated && appIsBackgrounded) {
        
        UIView *blackOut = [[UIView alloc] initWithFrame:[appDel.window bounds]];
        blackOut.backgroundColor = [UIColor whiteColor];
        blackOut.alpha = 0.0;
        [blackOut setNeedsDisplay];
        
        [appDel.window addSubview:blackOut];
        
        [UIView animateWithDuration:0.7 animations:^{
            
            blackOut.alpha =1.0;
            
        } completion:^(BOOL finished) {
            
            appDel.window.rootViewController = nil;
            
            for (UIView *myView in appDel.window.subviews) {
                if(myView !=blackOut)
                    [myView removeFromSuperview];
            }
            
            appDel.window.rootViewController = controller;
            
            if (finished) {
                
                [appDel.window bringSubviewToFront:blackOut];
                
                [UIView animateWithDuration:0.7 animations:^{
                    blackOut.alpha = 0.0;
                } completion:^(BOOL finished) {
                    [blackOut removeFromSuperview];
                }];
            }
            else
            {
                [blackOut removeFromSuperview];
            }
        }];
    }
    else
    {
        appDel.window.rootViewController = controller;
    }
}

+(void)transitionToOnBoardingAnimated: (BOOL)animated
{
    OnboardingViewController *onboarding = [[UIStoryboard storyboardWithName:@"Onboarding" bundle:nil] instantiateInitialViewController];
    
    [self  switchAppContextToViewController:onboarding animated:animated];
    
    }

+(void)transitionToMainAppAnimated:(BOOL)animated
{
    UINavigationController *mainApp = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateInitialViewController];
    
    [self switchAppContextToViewController:mainApp animated:animated];
    
    UIUserNotificationSettings *settings = [UIUserNotificationSettings settingsForTypes:(UIUserNotificationTypeAlert
                                                                                         | UIUserNotificationTypeBadge
                                                                                         | UIUserNotificationTypeSound) categories:nil];
    
    [[UIApplication sharedApplication] registerUserNotificationSettings:settings];
}


@end
