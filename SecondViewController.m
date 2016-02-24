//
//  SecondViewController.m
//  Ski-Places
//
//  Created by Paul Nitto on 1/28/16.
//  Copyright © 2016 Paul Nitto. All rights reserved.
//

#import "SecondViewController.h"
#import "ViewController.h"
#import "AppDelegate.h"

@interface SecondViewController()

@end

@implementation SecondViewController

- (IBAction)backButtonPressed:(id)sender {
    [self.delegate secondViewControllerIsDone:self];
    NSLog(@"rating when back button pressed: %f", self.rateView.rating);
}

-(void)viewDidLoad {
    
    [super viewDidLoad];
    [self fetchData];
    self.rateView.notSelectedImage = [UIImage imageNamed:@"emptyStar"];
    self.rateView.halfSelectedImage = [UIImage imageNamed:@"halfstar"];
    self.rateView.fullSelectedImage = [UIImage imageNamed:@"filledStar"];
    self.rateView.rating = 0;
    self.rateView.editable = YES;
    self.rateView.maxRating = 5;
    self.rateView.delegate = self;
    self.averageRatingLabel.text = [NSString stringWithFormat:@"%f",self.averageRating];


    self.commentField.textColor = [UIColor colorWithRed:0/256.0 green:84/256.0 blue:129/256.0 alpha:1.0];
    self.commentField.font = [UIFont fontWithName:@"Helvetica-Bold" size:25];
    self.commentField.backgroundColor=[UIColor greenColor];
    self.commentField.placeholder = @"Enter a Comment";
    [self.view addSubview:self.commentField];
    self.commentArray = [[NSMutableArray alloc] init];
}
-(void)viewDidAppear:(BOOL)animated {
    [self.commentTable reloadData];
}

-(void)fetchData {
    NSURL *url = [NSURL URLWithString:@"http://localhost:3000/skiPlaceCollection"];
    
    NSMutableURLRequest* request = [NSMutableURLRequest requestWithURL:url];
    request.HTTPMethod = @"GET";
    [request addValue:@"application/json" forHTTPHeaderField:@"Accept"];
    //NSLog(@"request: %@", request);
    
    NSURLSessionConfiguration *sessionConfig = [NSURLSessionConfiguration defaultSessionConfiguration];
    NSURLSession* session = [NSURLSession sessionWithConfiguration:sessionConfig];
    
    //completion handler
    NSURLSessionDataTask *getDataTask = [session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error){
        NSLog(@"response: %@", response);
        //NSLog(@"error: %@", error);
        NSMutableArray *commentList = [NSJSONSerialization JSONObjectWithData:data options:0 error:NULL];
        for(int x=0; x<[commentList count]; x++){
            [self.commentArray addObject:[commentList[x] objectForKey:@"title"]];
            NSLog(@"Comments: %@", self.commentArray);
            [self.commentTable reloadData];
        }
    }];
    [getDataTask resume];

}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSLog(@"Comment Count: %li", [self.commentArray count]);
    return [self.commentArray count];
}
-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    return @"Comments";
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CommentCell"];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"CommentCell"];
    }
    NSLog(@"Index Path: %@", indexPath);
    NSLog(@"Comment List: %@", self.commentArray);
    for(int x=0; x< [self.commentArray count];x++){
        if([self.commentArray count] > 0 && [self.commentArray count] > indexPath.row){
            cell.textLabel.text = [self.commentArray objectAtIndex:indexPath.row];
        }
    }
    return cell;
}

-(void)rateView:(RateVIew *)rateView ratingDidChange:(float)rating {
    self.rateLabel.text = [NSString stringWithFormat:@"Rating:%f",self.rateView.rating];
}

-(void)submitRating:(id)sender {
    [self.ratingArray addObject:[NSNumber numberWithFloat:self.rateView.rating]];
    NSLog(@"Rating List: %@",self.ratingArray);
    float total = 0;
    for(NSString *x in self.ratingArray) {
        total += [x floatValue];
        self.averageRating = total / self.ratingArray.count;
        NSLog(@"Average: %f", self.averageRating);
        NSLog(@"Ratings: %f",[x floatValue]);
    }
    self.averageRatingLabel.text = [NSString stringWithFormat:@"%f",self.averageRating];
    NSLog(@"List count:%li",self.ratingArray.count);
}

-(void)submitComment:(id)sender {
    NSString *comment = [NSString stringWithFormat:self.commentField.text];
    NSLog(@"Comment: %@", comment);
    NSURL *url = [NSURL URLWithString:@"http://localhost:3000/skiPlaceCollection"];
    
    NSURLSessionConfiguration *config = [NSURLSessionConfiguration defaultSessionConfiguration];
    NSURLSession *session = [NSURLSession sessionWithConfiguration:config];
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:url];
    request.HTTPMethod = @"POST";
    
    //NSDictionary *postDic = @{@"title":@"hello"};
    NSError *error = nil;
    NSData *data = [[NSString stringWithFormat:@"title=%@",comment] dataUsingEncoding:NSUTF8StringEncoding];
    //[NSJSONSerialization dataWithJSONObject:postDic options:0 error:&error];
    NSLog(@"Post Data: %@", data);
    
    if(!error) {
        NSURLSessionUploadTask *uploadTask = [session uploadTaskWithRequest:request fromData:data completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
            NSLog(@"Response: %@", response);
            NSLog(@"Error: %@", error);
        }];
        [uploadTask resume];
    }
}

@end

    