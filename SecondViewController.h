//
//  SecondViewController.h
//  Ski-Places
//
//  Created by Paul Nitto on 1/28/16.
//  Copyright © 2016 Paul Nitto. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MessageUI/MessageUI.h>

//Forward Declaration
@class SecondViewController;

@protocol SecondViewControllerDelegate <NSObject>
- (void)secondViewControllerIsDone:(SecondViewController *)SecondViewController;

@end

@interface SecondViewController : UIViewController
@property (weak, nonatomic) NSString *strPlaceName;
@property (strong,nonatomic) NSMutableArray *dataArray;
@property (weak, nonatomic) id<SecondViewControllerDelegate> delegate;
@property (weak, nonatomic) IBOutlet UILabel *skiPlaceName;
@property (weak, nonatomic) IBOutlet UILabel *placeDescription;

@end
