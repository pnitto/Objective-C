//
//  SecondViewController.m
//  Ski-Places
//
//  Created by Paul Nitto on 1/28/16.
//  Copyright © 2016 Paul Nitto. All rights reserved.
//

#import "SecondViewController.h"
#import "ViewController.h"

@interface SecondViewController()

@end

@implementation SecondViewController

- (IBAction)backButtonPressed:(id)sender {
    [self.delegate secondViewControllerIsDone:self];
}

-(void)viewDidLoad {
    [super viewDidLoad];


}


@end

    