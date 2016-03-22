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
#define comment_url "http://localhost:3000/comments"
#define delete_url "http://localhost:3000/delete/"


@interface SecondViewController()

@end

@implementation SecondViewController

- (IBAction)backButtonPressed:(id)sender {
    [self.delegate secondViewControllerIsDone:self];
    NSLog(@"rating when back button pressed: %f", self.rateView.rating);
}

-(void)viewDidLoad {
    
    [super viewDidLoad];
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
    self.dataArray = [[NSMutableArray alloc] init];
}

-(void)viewWillAppear:(BOOL)animated{
    [self fetchData];
}
-(void)viewDidAppear:(BOOL)animated {
    [self.commentTable reloadData];
}

-(void)fetchData {
    NSString *string = [self.skiPlaceName.text stringByReplacingOccurrencesOfString:@" " withString: @""];

    NSString *url_comments = [NSString stringWithFormat:@"http://localhost:3000/comments/%@",string];

    NSLog(@"place name: %@", url_comments);
  
    
    NSURL *url = [NSURL URLWithString:url_comments];
    
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
        
        /*for(int x=0; x<[commentList count]; x++){
            //[self.commentArray addObject:[commentList[x] objectForKey:@"placeName"]];
            [self.commentArray addObject:[commentList[x] objectForKey:@"comment"]];
            NSLog(@"Comments: %@", self.commentArray);
            //[self.commentTable reloadData];
            }
         */
        //if data is already in the data array, create an empty array and re add the objects, may not be the most efficient way
        //-working for adding and deleting comments to and from the server
        if(self.dataArray.count > 0){
            self.dataArray = [[NSMutableArray alloc]init];
            for(int y=0; y<[commentList count]; y++){
                [self.dataArray addObject:commentList[y]];
                NSLog(@"All Data: %@", self.dataArray);
            }

        }
        else {
            for(int y=0; y<[commentList count]; y++){
                [self.dataArray addObject:commentList[y]];
                NSLog(@"All Data: %@", self.dataArray);
            }

        }
            }];
    [getDataTask resume];

}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSLog(@"Comment Count: %li", [self.dataArray count]);
    return [self.dataArray count];
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
    /*
    UIButton *deleteButton = [UIButton buttonWithType: UIButtonTypeDetailDisclosure];
    [deleteButton setFrame:CGRectMake(300,7,40,40)];
    //[deleteButton addTarget:self action:@selector(deleteAction) forControlEvents:UIControlEventTouchUpInside];
    deleteButton.tintColor = [UIColor redColor];
    -adding a button to the tableviewcell
    [cell.contentView addSubview:deleteButton];
     */
    //NSLog(@"Index Path: %@", indexPath);
    //NSLog(@"Comment List: %@", self.commentArray);
   
    /*
    for(NSString *key in self.dataArray){
        NSLog(@"Values: %@", key);
    }
    */
    NSMutableArray *dataList = [[NSMutableArray alloc] init];
    for(int x=0; x< [self.dataArray count]; x++){
        [dataList addObject:[self.dataArray[x] objectForKey:@"comment"]];
        //NSLog(@"Data Objects %@", dataList);
    }
    for(int x=0; x< [dataList count];x++){
        if([dataList count] > 0 && [dataList count] > indexPath.row){
            cell.textLabel.text = [dataList objectAtIndex:indexPath.row];
        }
        
    }
    //[[[self.commentArray reverseObjectEnumerator]allObjects]mutableCopy], self.commentArray.count - indexPath.row - 1-reverse the order of the array [[[dataList reverseObjectEnumerator]allObjects]mutableCopy]
    return cell;
}
/*
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    UITableViewCell *cell = [[[[self.dataArray reverseObjectEnumerator]allObjects]mutableCopy] objectAtIndex:indexPath.row];
    //NSString *stringValue = cell.textLabel.text;
    
    NSLog(@"Selected Cell: %@",cell);
}
*/
-(void)rateView:(RateVIew *)rateView ratingDidChange:(float)rating {
    self.rateLabel.text = [NSString stringWithFormat:@"Rating:%f",self.rateView.rating];
}
- (IBAction)deleteRow:(id)sender{
    if(self.commentTable.editing == YES){
        [self.commentTable setEditing:NO animated:YES];
    }
    else {
        [self.commentTable setEditing:YES animated:YES];
    }
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath{
    return UITableViewCellEditingStyleDelete;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if(editingStyle==UITableViewCellEditingStyleDelete){
        
        NSString *object = [self.dataArray objectAtIndex:indexPath.row];
        NSString *comment_id = [object valueForKeyPath:@"_id"];
        //NSLog(@"object id: %@", comment_id);
        
        NSMutableDictionary *data = [[NSMutableDictionary alloc] init];
        [data setObject:comment_id forKey:@"_id"];
        NSLog(@"Data:%@", data);
        
        NSError *error = nil;
        NSData *delete_info = [NSJSONSerialization dataWithJSONObject:data options:0 error:&error];
        NSLog(@"JSON Data: %@", delete_info);
        

        
        NSURLSessionConfiguration *config = [NSURLSessionConfiguration defaultSessionConfiguration];
        NSURLSession *session = [NSURLSession sessionWithConfiguration:config];
        
        NSString *url_delete = [NSString stringWithFormat:@"http://localhost:3000/delete/%@",comment_id];
        NSLog(@"Delete Url : %@", url_delete);
        

        NSURL *url = [NSURL URLWithString:url_delete];
        NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:url];
        [request setHTTPMethod:@"DELETE"];
        [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
        
        if(!error) {
            NSURLSessionUploadTask *uploadTask = [session uploadTaskWithRequest:request fromData:delete_info completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
                NSLog(@"Response: %@", response);
                NSLog(@"Error: %@", error);
            }];
            [uploadTask resume];
        }
        
        [self.dataArray removeObjectAtIndex:indexPath.row];
        [self.commentTable beginUpdates];
        [self.commentTable deleteRowsAtIndexPaths:[NSMutableArray arrayWithObject:indexPath] withRowAnimation:
         UITableViewRowAnimationFade];
        [self.commentTable endUpdates];
    }
}

-(NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath
{
    //Set NSString for button display text here.
    NSString *newTitle = @"Remove";
    return newTitle;
    
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
    /*
    NSString *comment = [NSString stringWithFormat:self.commentField.text];
    NSLog(@"Comment: %@", comment);
    */ 
    if(self.commentField.text && self.commentField.text.length > 0){
        
        NSURLSessionConfiguration *config = [NSURLSessionConfiguration defaultSessionConfiguration];
        NSURLSession *session = [NSURLSession sessionWithConfiguration:config];
        
        NSMutableDictionary *input = [[NSMutableDictionary alloc] init];
        [input setObject:self.commentField.text forKey:@"comment"];
        
        NSString *string = [self.skiPlaceName.text stringByReplacingOccurrencesOfString:@" " withString: @""];
        [input setObject:string forKey:@"placeName"];
        
        NSLog(@"dic data: %@", input);
        NSError *error = nil;
        
        NSData *data = [NSJSONSerialization dataWithJSONObject:input options:0 error:&error];
        //NSLog(@"Json Data: %@", data);
        
        NSString *datalength = [NSString stringWithFormat:@"%lu", [data length]];
        //NSLog(@"Length: %@", datalength);
        
        NSURL *url = [NSURL URLWithString:@comment_url];
        NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:url];
        
        [request setHTTPMethod:@"POST"];
        [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
        [request setValue:datalength forHTTPHeaderField:@"Content-Length"];
        [request setHTTPBody:data];
        
        if(!error) {
            NSURLSessionUploadTask *uploadTask = [session uploadTaskWithRequest:request fromData:data completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
                NSLog(@"Response: %@", response);
                //NSLog(@"Error: %@", error);
            }];
            [uploadTask resume];
            }
        //adds the dictionary object comment key to the comment array, then puts the object at the end of the indexpath array, animates the insertion,   [self.commentArray insertObject:input[@"comment"] atIndex:0];
        NSLog(@"Data:%@ ",[[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding]);
        
        [self.dataArray addObject:input];
        [self fetchData];
    
        NSIndexPath *newIndexPath = [NSIndexPath indexPathForRow: self.dataArray.count - 1 inSection:0];
        [self.commentTable beginUpdates];
        [self.commentTable insertRowsAtIndexPaths:[NSArray arrayWithObject:newIndexPath] withRowAnimation:UITableViewRowAnimationTop];
        [self.commentTable endUpdates];
        [self.commentTable reloadData];

        self.commentField.text = @"";
         }
        else {
        NSLog(@"Fill out the textfield");
       }
    }

@end

    