//
//  SyncCalendarViewController.h
//  Executer
//
//  Created by Ahmed Onawale on 8/6/15.
//  Copyright (c) 2015 Kehesjay. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SyncCalendarViewController : UIViewController
@property (strong, nonatomic) IBOutlet UIView *shareRide;

@property (weak, nonatomic) IBOutlet UIView *syncCalendarView;
+(BOOL)isGoogleAuth;
@end
