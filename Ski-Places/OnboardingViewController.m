//
//  LaunchViewController.m
//  Ski-Places
//
//  Created by Paul Nitto on 3/22/16.
//  Copyright © 2016 Paul Nitto. All rights reserved.
//

#import "OnboardingViewController.h"
#import "CoreLocation/CoreLocation.h"
#import "AppTheme.h"

@interface OnboardingViewController()
@property (strong, nonatomic) IBOutlet UILabel *onBoardingLabel;

@end

@implementation OnboardingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.onBoardingLabel.textColor = [UIColor WoozlePurpleColor];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
