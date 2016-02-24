//
//  CameraViewController.h
//  Ski-Places
//
//  Created by Paul Nitto on 2/22/16.
//  Copyright © 2016 Paul Nitto. All rights reserved.
//

#import <UIKit/UIKit.h>


@class CameraViewController;

@protocol CameraViewControllerDelegate <NSObject>
- (void)cameraViewControllerIsDone:(CameraViewController *)CameraViewController;
@end

@interface CameraViewController : UIViewController<UIImagePickerControllerDelegate, UINavigationControllerDelegate>

@property(weak, nonatomic) id<CameraViewControllerDelegate> delegate;

@property (strong, nonatomic) IBOutlet UIImageView *imageView;

- (IBAction)takePicture:(id)sender;



@end

