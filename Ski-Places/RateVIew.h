//
//  RateVIew.h
//  Ski-Places
//
//  Created by Paul Nitto on 2/5/16.
//  Copyright © 2016 Paul Nitto. All rights reserved.
//

#import <UIKit/UIKit.h>

@class RateVIew;

@protocol RateViewDelegate
- (void)rateView:(RateVIew *)rateView ratingDidChange:(float)rating;
@end

@interface RateVIew:UIView<NSCoding>

@property (strong, nonatomic) UIImage *notSelectedImage;
@property (strong, nonatomic) UIImage *halfSelectedImage;
@property (strong, nonatomic) UIImage *fullSelectedImage;
@property (assign, nonatomic) float rating;
@property (assign) BOOL editable;
@property (strong) NSMutableArray * imageViews;
@property (assign, nonatomic) int maxRating;
@property (assign) int midMargin;
@property (assign) int leftMargin;
@property (assign) CGSize minImageSize;
@property (assign) id <RateViewDelegate> delegate;


@end

