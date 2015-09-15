//
//  CalendarEventsViewController.m
//  Executer
//
//  Created by Johnson Ejezie on 9/10/15.
//  Copyright (c) 2015 Kehesjay. All rights reserved.
//

#import "CalendarEventsViewController.h"
#import "BookRideViewController.h"
#import "RecentBookedDetailsViewController.h"
#import <AFNetworking.h>

typedef enum {
    none,
    recentlyBookedView,
    calenderEventsView,
} tableDisplayView;

@interface CalendarEventsViewController ()
@property(nonatomic,assign) tableDisplayView displayedView;


@end

@implementation CalendarEventsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.displayedView = calenderEventsView;
    self.navigationController.navigationBarHidden = NO;
    self.tableView.contentInset = UIEdgeInsetsMake(-20, 0, 0, 0);
    [self getRecentlyBookedEvents:^{
        
    }];
    // Do any additional setup after loading the view.
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (self.displayedView == calenderEventsView) {
        return self.calenderEvents.count;
    }else {
        return self.recentlyBookedEvents.count;
    }
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:@"eventCell" forIndexPath:indexPath];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"eventCell"];
    }
    UILabel* summaryLabel = (UILabel*)[cell viewWithTag:1000];
    UILabel* locationLabel = (UILabel*)[cell viewWithTag:1001];
    UILabel* timeLabel = (UILabel*)[cell viewWithTag:1002];
    NSDictionary* event = [[NSDictionary alloc]init];
    if (self.displayedView == calenderEventsView) {
        event = self.calenderEvents[indexPath.row];
        summaryLabel.text = event[@"summary"];
        locationLabel.text = event[@"location"];
        timeLabel.text = event[@"start"];
    }else {
        event = self.recentlyBookedEvents[indexPath.row];
//        summaryLabel.text = event
    }
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSDictionary* event = [[NSDictionary alloc]init];
    if (self.displayedView == calenderEventsView) {
        event = self.calenderEvents[indexPath.row];
        [self performSegueWithIdentifier:@"BookRide" sender:event];
    }else {
        event = self.recentlyBookedEvents[indexPath.row];
        [self performSegueWithIdentifier:@"RecentlyBookedDetails" sender:event];
    }
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"BookRide"]) {
        BookRideViewController* controller = segue.destinationViewController;
        controller.event = sender;
        controller.uberProfile = self.uberProfile;
    }else if ([segue.identifier isEqualToString:@"RecentlyBookedDetails"]){
        RecentBookedDetailsViewController* controller = segue.destinationViewController;
        controller.event = sender;
    }
}


-(void)getRecentlyBookedEvents:(void (^)(void))completionBlock {
    NSString* url = [NSString stringWithFormat:@"https://andelahack.herokuapp.com/users/%@/requests",self.uberProfile[@"uuid"]];
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer = [AFJSONResponseSerializer serializerWithReadingOptions:NSJSONReadingAllowFragments];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    [manager GET:url parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"JSON from recently:  %@", responseObject);
        self.recentlyBookedEvents = responseObject;
        completionBlock();
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error from sync calendar: %@", error);
    }];
    
}


- (IBAction)segmentControl:(UISegmentedControl *)sender {
    
    if (sender.selectedSegmentIndex == 0) {
        self.displayedView = calenderEventsView;
        [self.tableView reloadData];
    }else {
        self.displayedView = recentlyBookedView;
        [self.tableView reloadData];
    }
}
@end
