//
//  SecondViewController.h
//  Ski-Places
//
//  Created by Paul Nitto on 1/28/16.
//  Copyright © 2016 Paul Nitto. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RateVIew.h"
#import "ViewController.h"

//Forward Declaration
@class SecondViewController;

@protocol SecondViewControllerDelegate <NSObject>
- (void)secondViewControllerIsDone:(SecondViewController *)SecondViewController;
@end

@interface SecondViewController : UIViewController<RateViewDelegate, UITableViewDataSource>
@property (weak, nonatomic) NSString *strPlaceName;
@property (weak, nonatomic) id<SecondViewControllerDelegate> delegate;
@property (weak, nonatomic) IBOutlet UILabel *skiPlaceName;
@property (weak, nonatomic) IBOutlet UILabel *placeDescription;
@property (weak, nonatomic) IBOutlet UILabel *rateLabel;
@property (weak, nonatomic) IBOutlet RateVIew *rateView;
@property (weak, nonatomic) ViewController *mainVC;
@property (weak, nonatomic) IBOutlet UITextField *commentField;
@property (nonatomic,strong) NSMutableArray *ratingArray;
@property float averageRating;
@property (nonatomic, strong) NSMutableArray *commentArray;
@property (nonatomic, strong) NSMutableArray *dataArray;
@property (weak, nonatomic) IBOutlet UILabel *averageRatingLabel;
@property (strong, nonatomic) IBOutlet UITableView *commentTable;


- (IBAction)deleteRow:(id)sender;
- (IBAction)submitRating:(id)sender;
- (IBAction)submitComment:(id)sender;

@end

