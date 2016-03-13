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
#define comment_url "http://localhost:3000/titles"


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
    NSURL *url = [NSURL URLWithString:@comment_url];
    
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
            [self.commentArray addObject:[commentList[x] objectForKey:@"comment"]];
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
//need to do a check when the textfield is blank, so it doesn't add a row to the tableview
-(void)submitComment:(id)sender {
    /*
    NSString *comment = [NSString stringWithFormat:self.commentField.text];
    NSLog(@"Comment: %@", comment);
    */ 
    
    NSURLSessionConfiguration *config = [NSURLSessionConfiguration defaultSessionConfiguration];
    NSURLSession *session = [NSURLSession sessionWithConfiguration:config];
    
    NSMutableDictionary *input = [[NSMutableDictionary alloc] init];
    [input setObject:self.commentField.text forKey:@"comment"];
    [input setObject:self.skiPlaceName.text forKey:@"placeName"];
    
    NSLog(@"dic data: %@", input);
    NSError *error = nil;
    
    NSData *data = [NSJSONSerialization dataWithJSONObject:input options:0 error:&error];
    NSLog(@"Json Data: %@", data);
    
    NSString *datalength = [NSString stringWithFormat:@"%lu", [data length]];
    NSLog(@"Length: %@", datalength);
    
    NSURL *url = [NSURL URLWithString:@comment_url];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:url];
    
    [request setHTTPMethod:@"POST"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [request setValue:datalength forHTTPHeaderField:@"Content-Length"];
    [request setHTTPBody:data];
    
    if(!error) {
        NSURLSessionUploadTask *uploadTask = [session uploadTaskWithRequest:request fromData:data completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
            NSLog(@"Response: %@", response);
            NSLog(@"Error: %@", error);
        }];
        [uploadTask resume];
        }
    //adds the dictionary object comment key to the comment array, then puts the object at the end of the indexpath array, animates the insertion
     [self.commentArray addObject:input[@"comment"]];
     NSIndexPath *newIndexPath = [NSIndexPath indexPathForRow:self.commentArray.count - 1 inSection:0];
     [self.commentTable beginUpdates];
     [self.commentTable insertRowsAtIndexPaths:[NSArray arrayWithObject:newIndexPath] withRowAnimation:UITableViewRowAnimationTop];
     [self.commentTable endUpdates];
     }

@end

    