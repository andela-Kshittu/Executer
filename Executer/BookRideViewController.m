//
//  BookRideViewController.m
//  Executer
//
//  Created by Kehinde Shittu on 8/7/15.
//  Copyright (c) 2015 Kehesjay. All rights reserved.
//

#import "BookRideViewController.h"
#import "MenuViewController.h"

@interface BookRideViewController ()

@end

@implementation BookRideViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    UITapGestureRecognizer *tapAction = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(showUberTypes:)];
    [self.chooseUberType addGestureRecognizer:tapAction];
    self.chooseUberType.layer.borderWidth = 1.0;
    self.chooseUberType.layer.borderColor = [UIColor blackColor].CGColor;
    
}
-(void)showUberTypes:(UITapGestureRecognizer *)sender{
    NSLog(@"show uber types");
    MenuViewController *menuViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"MenuViewController"];
    menuViewController.modalPresentationStyle = UIModalPresentationPopover;
    menuViewController.preferredContentSize = CGSizeMake(self.view.frame.size.height/4, self.view.frame.size.height/3);
    UIPopoverPresentationController * popController = menuViewController.popoverPresentationController;
    popController.permittedArrowDirections = UIPopoverArrowDirectionAny;
    popController.delegate = self;
    popController.sourceView = self.chooseUberType;
    popController.sourceRect = CGRectMake(0,self.chooseUberType.layer.frame.size.height/2,1,1);
    [self presentViewController:menuViewController animated:YES completion:nil];
}

-(UIModalPresentationStyle)adaptivePresentationStyleForPresentationController:(UIPresentationController *)controller{
    return UIModalPresentationNone;
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

@end
