//
//  BookRideViewController.h
//  Executer
//
//  Created by Kehinde Shittu on 8/7/15.
//  Copyright (c) 2015 Kehesjay. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BookRideViewController : UIViewController <UIPopoverPresentationControllerDelegate>
@property (nonatomic, strong) UIPopoverPresentationController *popController;
@property (strong, nonatomic) IBOutlet UIView *chooseUberType;
@end
