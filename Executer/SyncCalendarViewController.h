//
//  SyncCalendarViewController.h
//  Executer
//
//  Created by Ahmed Onawale on 8/6/15.
//  Copyright (c) 2015 Kehesjay. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <GoogleSignIn.h>

@interface SyncCalendarViewController : UIViewController
@property (strong, nonatomic) IBOutlet UIView *shareRide;

@property (strong, nonatomic) IBOutlet UILabel *nameLabel;
@property (strong, nonatomic) IBOutlet UIImageView *profileImageView;
@property (strong, nonatomic) IBOutlet UIView *shareRideInnerView;


@property(strong, nonatomic)  NSDictionary* uberProfile;
@property (weak, nonatomic) IBOutlet UIView *syncCalendarView;
+(BOOL)isGoogleAuth;
@end
