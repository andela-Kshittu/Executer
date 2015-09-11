//
//  RecentBookedDetailsViewController.h
//  Executer
//
//  Created by Johnson Ejezie on 9/11/15.
//  Copyright (c) 2015 Kehesjay. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RecentBookedDetailsViewController : UIViewController

@property (strong, nonatomic) IBOutlet UILabel *summaryLabel;

@property (strong, nonatomic) IBOutlet UILabel *startLabel;

@property (strong, nonatomic) IBOutlet UILabel *endLabel;
@property (strong, nonatomic) IBOutlet UISegmentedControl *segmentControlBtn;
- (IBAction)segmentControl:(UISegmentedControl *)sender;


@property (strong, nonatomic) IBOutlet UILabel *pickUpLocationLabel;

@property (strong, nonatomic) IBOutlet UILabel *destinationLabel;
@property (strong, nonatomic) IBOutlet UILabel *productLabel;
@property (strong, nonatomic) IBOutlet UILabel *reminderLabel;
@property (strong, nonatomic) IBOutlet UIView *cancelRideView;
@property(strong, nonatomic) NSDictionary* event;

@end
