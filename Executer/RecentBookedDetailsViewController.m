//
//  RecentBookedDetailsViewController.m
//  Executer
//
//  Created by Johnson Ejezie on 9/11/15.
//  Copyright (c) 2015 Kehesjay. All rights reserved.
//

#import "RecentBookedDetailsViewController.h"

@interface RecentBookedDetailsViewController ()

@end

@implementation RecentBookedDetailsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    NSLog(@"RecentBookedDetailsViewController  %@", self.event);
    // Do any additional setup after loading the view.
    self.summaryLabel.text = self.event[@"summary"];
    self.startLabel.text = self.event[@"startTime"];
    self.pickUpLocationLabel.text = self.event[@"location"][@"address"];
    self.destinationLabel.text = self.event[@"destination"][@"address"];
    self.endLabel.text = self.event[@"endTime"];
    self.productLabel.text = self.event[@"product"][@"type"];
    self.reminderLabel.text = self.event[@"estimates"][@"reminder"];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)segmentCOntrol:(id)sender {
}
- (IBAction)segmentControl:(UISegmentedControl *)sender {
}
@end
