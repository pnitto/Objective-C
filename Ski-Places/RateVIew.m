//
//  RateVIew.m
//  Ski-Places
//
//  Created by Paul Nitto on 2/5/16.
//  Copyright © 2016 Paul Nitto. All rights reserved.
//

#import "RateVIew.h"

@implementation RateVIew


@synthesize notSelectedImage = _notSelectedImage;
@synthesize halfSelectedImage = _halfSelectedImage;
@synthesize fullSelectedImage = _fullSelectedImage;
@synthesize rating = _rating;
@synthesize editable = _editable;
@synthesize imageViews = _imageViews;
@synthesize maxRating = _maxRating;
@synthesize midMargin = _midMargin;
@synthesize leftMargin = _leftMargin;
@synthesize minImageSize = _minImageSize;
@synthesize delegate = _delegate;

//Initializing variables
-(void)baseInit {
    _notSelectedImage = nil;
    _halfSelectedImage = nil;
    _fullSelectedImage = nil;
     _rating = 0;
    _editable = NO;
    _imageViews = [[NSMutableArray alloc] init];
    _maxRating = 5;
    _midMargin = 5;
    _leftMargin = 0;
    _minImageSize = CGSizeMake(5,5);
    _delegate = nil;
}

//initWithFrame and initWithCoder so that the view controller can add us via a XIB or programatically.

-(id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if(self){
        [self baseInit];
    }
    return self;
}
-(id)initWithCoder:(NSCoder *)aDecoder {
    if ((self = [super initWithCoder:aDecoder])){
        [self baseInit];
    }
    return self;
}
//refresh function to show the updated rating

-(void)refresh{
    for (int i = 0; i < self.imageViews.count; ++i) {
        UIImageView *imageView = [self.imageViews objectAtIndex:i];
        if (self.rating >= i+1) {
            imageView.image = self.fullSelectedImage;
        } else if (self.rating > i) {
            imageView.image = self.halfSelectedImage;
        } else {
            imageView.image = self.notSelectedImage;
        }
    }
}

-(void)layoutSubviews {
    [super layoutSubviews];
    
    if (self.notSelectedImage == nil) return;
    //setting frames for each UIImageView
    //So if we know the full size of the frame, we can subtract out the margins and divide by the number of images to figure out how wide to make each of the UIImageViews.
    float desiredImageWidth = (self.frame.size.width - (self.leftMargin*2) -(self.midMargin*self.imageViews.count)) / self.imageViews.count;
    float imageWidth = MAX(self.minImageSize.width, desiredImageWidth);
    float imageHeight = MAX(self.minImageSize.height, self.frame.size.height);
    
    for(int i = 0; i < self.imageViews.count; ++i){
        UIImageView *imageView = [self.imageViews objectAtIndex:i];
        CGRect imageFrame = CGRectMake(self.leftMargin + i*(self.midMargin+imageWidth), 0, imageWidth, imageHeight);
        imageView.frame = imageFrame;
        
    }
}

-(void)setMaxRating:(int)maxRating {
    _maxRating = maxRating;
    
    //Remove old image views
    for(int i = 0; i < self.imageViews.count; ++i) {
        UIImageView *imageView = (UIImageView *) [self.imageViews objectAtIndex:i];
        [imageView removeFromSuperview];
    }
    [self.imageViews removeAllObjects];
  
    //Add new image views
    for(int i = 0; i < maxRating; ++i){
        UIImageView *imageView = [[UIImageView alloc] init];
        imageView.contentMode = UIViewContentModeScaleAspectFill;
        [self.imageViews addObject:imageView];
        [self addSubview:imageView];
    }
  

    //Relayout and Refresh
    [self setNeedsLayout];
    [self refresh];
}
//The most important method is the setMaxRating method – because this determines how many UIImageView subviews we have. So when this changes, we remove any existing image views and create the appropriate amount. Of course, once this happens we need to make sure layoutSubviews and refresh is called, so we call setNeedsLayout and refresh.

-(void)setNotSelectedImage:(UIImage *)notSelectedImage {
    _notSelectedImage = notSelectedImage;
    [self refresh];
}

-(void)setHalfSelectedImage:(UIImage *)image {
    _halfSelectedImage = image;
    [self refresh];
}
-(void)setFullSelectedImage:(UIImage *)image {
    _fullSelectedImage = image;
    [self refresh];
}
-(void)setRating:(float)rating {
    _rating = rating;
    [self refresh];
}

//..we simply loop through our subviews (backwards) and compare the x coordinate to that of our subviews. If the x coordinate is greater than the current subview, we know the rating is the index of the subview+1.

-(void)handleTouchAtLocation: (CGPoint)touchLocation{
    if(!self.editable) return;
    int newRating = 0;
    for(int i = self.imageViews.count - 1; i >= 0; i-- ){
        UIImageView *imageView = [self.imageViews objectAtIndex:i];
        if(touchLocation.x > imageView.frame.origin.x){
            newRating = i +1;
            NSLog(@"Rating: %i", newRating);
            break;
        }
    }
    self.rating = newRating;
}
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    UITouch *touch = [touches anyObject];
    CGPoint touchLocation = [touch locationInView:self];
    [self handleTouchAtLocation:touchLocation];
    
}
-(void)touchesMoved:(NSSet *)touches withevent:(UIEvent *)event {
    UITouch *touch = [touches anyObject];
    CGPoint touchLocation = [touch locationInView:self];
    [self handleTouchAtLocation:touchLocation];
}
-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    [self.delegate rateView:self ratingDidChange:self.rating];
}


@end
