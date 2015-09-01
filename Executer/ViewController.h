//
//  ViewController.h
//  Executer
//
//  Created by Kehinde Shittu on 8/6/15.
//  Copyright (c) 2015 Kehesjay. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UberKit.h"
@interface ViewController : UIViewController  <UberKitDelegate>
@property (strong, nonatomic) IBOutlet UIView *loginWithUber;
@property (weak, nonatomic) IBOutlet UIView *activityIndicatorView;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;


@end

