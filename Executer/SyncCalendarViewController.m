//
//  SyncCalendarViewController.m
//  Executer
//
//  Created by Ahmed Onawale on 8/6/15.
//  Copyright (c) 2015 Kehesjay. All rights reserved.
//

#import "SyncCalendarViewController.h"

@interface SyncCalendarViewController ()

@property(strong, nonatomic)UITapGestureRecognizer* tap;

@end

@implementation SyncCalendarViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.tap = [[UITapGestureRecognizer alloc]initWithTarget: self action:@selector(syncCalendar:)];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void) syncCalendar:(UITapGestureRecognizer*)sender {
    
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
