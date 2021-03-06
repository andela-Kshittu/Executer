//
//  BookRideViewController.m
//  Executer
//
//  Created by Kehinde Shittu on 8/7/15.
//  Copyright (c) 2015 Kehesjay. All rights reserved.
//

#import "BookRideViewController.h"
#import "MenuViewController.h"
#import <AFNetworking.h>


@interface BookRideViewController ()
{
    CGRect executerLogoOldPosition;
    CGRect executerLogoNewPosition;

}
@property (strong, nonatomic) CLLocationManager *locationManager;
@end

@implementation BookRideViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.bookRideActivityIndicator startAnimating];
    [self.activityIndicator startAnimating];
    self.bookRide.layer.cornerRadius = 5;
    // Do any additional setup after loading the view.
    UITapGestureRecognizer *tapAction = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(showUberTypes:)];
    UITapGestureRecognizer *bookTapAction = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(bookingRide:)];
    [self.bookRide addGestureRecognizer:bookTapAction];
    
    self.startTimeTextField.text = self.event[@"start"];
    self.destinationTextField.text = self.event[@"location"];
    self.summaryLabel.text = self.event[@"summary"];
    self.endTimeTextField.text = self.event[@"end"];
    [self.chooseUberType addGestureRecognizer:tapAction];
    self.chooseUberType.layer.borderWidth = 1.0;
    self.chooseUberType.layer.borderColor = [UIColor blackColor].CGColor;
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillShow:)
                                                 name:UIKeyboardWillShowNotification
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillHide:)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];
    
    
    self.locationTextField.delegate = self;
    self.destinationTextField.delegate = self;
    self.startTimeTextField.delegate = self;
    self.endTimeTextField.delegate = self;
    
    self.locationManager = [[CLLocationManager alloc] init];
    self.locationManager.delegate = self;
    self.locationManager.desiredAccuracy = kCLLocationAccuracyBest;
}

-(void)locationManager:(CLLocationManager *)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status {
    switch (status) {
        case kCLAuthorizationStatusNotDetermined:
            [self.locationManager requestWhenInUseAuthorization];
            break;
        case kCLAuthorizationStatusAuthorizedWhenInUse:
            [self.locationManager startUpdatingLocation];
            break;
        case kCLAuthorizationStatusDenied:
            [self.locationManager stopUpdatingLocation];
            break;
        case kCLAuthorizationStatusRestricted:
            [self.locationManager stopUpdatingLocation];
            NSLog(@"The user device has been restricted by their provider");
            break;
        default:
            break;
    }
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    self.navigationController.navigationBarHidden = NO;
    self.navigationController.navigationBar.barTintColor = [UIColor colorWithRed:43.0/255 green:180.0/255 blue:192.0/255 alpha:1];
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    NSDictionary *textAttributes = [NSDictionary dictionaryWithObjectsAndKeys:
                                    [UIColor whiteColor],NSForegroundColorAttributeName,
                                    [UIColor whiteColor],NSBackgroundColorAttributeName,
                                    [UIFont fontWithName:@"System" size:20.0], NSFontAttributeName,
                                    nil];
    self.navigationController.navigationBar.titleTextAttributes = textAttributes;
    self.navigationItem.titleView.tintColor = [UIColor whiteColor];
}

-(void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error {
    self.activityIndicatorView.hidden = YES;
}

-(void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations {
    [self.locationManager stopUpdatingLocation];
    CLGeocoder *geocoder = [[CLGeocoder alloc] init];
    [geocoder reverseGeocodeLocation:manager.location completionHandler:^(NSArray *placemarks, NSError *error) {
        if (error != nil) {
            NSLog(@"%@", error.localizedDescription);
        }
        if (placemarks.count > 0) {
            CLPlacemark *placemark = placemarks.firstObject;
            NSArray *address = placemark.addressDictionary[@"FormattedAddressLines"];
            NSString *addressString = @"";
            for (NSString *name in address) {
                addressString = [addressString stringByAppendingString: [NSString stringWithFormat:@"%@, ", name]];
            }
            addressString = [addressString substringToIndex:[addressString length] - 2];
            self.locationTextField.text = addressString;
        }
        self.activityIndicatorView.hidden = YES;
    }];
}

-(void)bookingRide:(UITapGestureRecognizer*)sender{
    self.bookRide.hidden = YES;
    self.bookRideActivityIndicatorView.hidden = NO;
    NSLog(@"called");
    NSDictionary *dataDict = @{@"startTime":self.startTimeTextField.text,
                               @"location":self.locationTextField.text,
                               @"productType":@"uberX",
                               @"destination": @"314 herbert macaulay way, yaba, lagos",
                               @"summary": self.summaryLabel.text,
                               @"endTime": self.endTimeTextField.text
                            };
    [self bookRideApi:dataDict completion:^{
        NSLog(@"done");
        [self performSegueWithIdentifier:@"unwindSegue" sender:self];
    }];

}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
}

-(void)bookRideApi:(NSDictionary*)dict completion:(void (^)(void))completionBlock {
        NSString* url = [NSString stringWithFormat:@"https://andelahack.herokuapp.com/users/%@/requests",self.uberProfile[@"uuid"]];
        NSLog(@"datadict %@", dict);
        NSLog(@"datadict url %@", url);
        AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
        manager.responseSerializer = [AFJSONResponseSerializer serializerWithReadingOptions:NSJSONReadingAllowFragments];
        manager.requestSerializer = [AFJSONRequestSerializer serializer];
        [manager POST:url parameters:dict success:^(AFHTTPRequestOperation *operation, id responseObject) {
            NSLog(@"JSON from sync calendar 5565656565656:  %@", responseObject);
            
            UILocalNotification *localNotification = [[UILocalNotification alloc] init];
            localNotification.userInfo = @{@"message":@"Executer is about to schedule an uber ride for you"};
            localNotification.soundName = UILocalNotificationDefaultSoundName;
            localNotification.alertBody = [NSString stringWithFormat:@"We're about to schedule an %@ cab for your meeting at %@",responseObject[@"response"][@"product"][@"type"],responseObject[@"response"][@"destination"][@"address"]];
            localNotification.userInfo = @{@"user_id":responseObject[@"response"][@"uid"],
                                           @"request_id":responseObject[@"response"][@"id"]
                                           };
            NSDate *currDate = [NSDate date];
            NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
            NSLocale *enUSPOSIXLocale = [NSLocale localeWithLocaleIdentifier:@"en_US_POSIX"];
            [dateFormatter setLocale:enUSPOSIXLocale];
            [dateFormatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ssZZZZZ"];
            NSDate *now = [NSDate date];
            NSString *testDate = [dateFormatter stringFromDate:now];
//            responseObject[@"response"][@"estimates"][@"reminder"]
//            NSDate *fireDate = [dateFormatter dateFromString:testDate];
            localNotification.fireDate = [NSDate dateWithTimeIntervalSinceNow:10.0];
//            localNotification.fireDate = fireDate;
            [[UIApplication sharedApplication] scheduleLocalNotification:localNotification];
           

            completionBlock();
            
            
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            NSLog(@"Error from sync calendar: %@", error);
            self.bookRide.hidden = NO;
            self.bookRideActivityIndicatorView.hidden = YES;
        }];
    
}


-(void)showUberTypes:(UITapGestureRecognizer *)sender{
    NSLog(@"show uber types");
    MenuViewController *menuViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"MenuViewController"];
    menuViewController.delegate = self;
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

-(void)menuViewResponse:(MenuViewController *)controller didSelectOptions:(NSMutableArray*)options{
    NSLog(@"this cells were selected %@",options);
    NSString *labelText = @"";
    int i = 0;
    for (NSString *text in options){
        NSString *formatedText = text;
        if(i > 0){
            formatedText = [NSString stringWithFormat:@" -> %@",formatedText];
        }
      labelText =   [labelText stringByAppendingString:formatedText];
        i++;
    }
    self.selectedUberTypesLabel.text = [labelText  isEqual: @""] ? @"None":labelText;
    self.selectedUberTypesView.hidden = NO;
}


// text field delegates.
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    NSLog(@"about to call delegate");

    return YES;
}


-(void)textFieldDidEndEditing:(UITextField *)textField{
    
}


- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    
    return YES;
}

-(BOOL)textField:(UITextField *)textField
shouldChangeCharactersInRange:(NSRange)range
replacementString:(NSString *)string
{
    return YES;
}



#pragma mark - Keyboard Notifications

- (void)keyboardWillShow:(NSNotification *)notification
{
    
    executerLogoOldPosition = CGRectMake(self.view.layer.frame.origin.x , self.view.layer.frame.origin.y, self.view.layer.frame.size.width, self.view.layer.frame.size.height);
    executerLogoNewPosition = CGRectMake(self.view.layer.frame.origin.x , self.view.layer.frame.origin.y -self.executerLogo.layer.frame.size.height, self.view.layer.frame.size.width, self.view.layer.frame.size.height);
    [UIView animateWithDuration:1.0 delay:0.0 options:UIViewAnimationOptionCurveEaseIn animations:^{
        self.view.frame = executerLogoNewPosition;
    } completion:nil];

}

- (void)keyboardWillHide:(NSNotification *)notification
{
    [UIView animateWithDuration:1.0 delay:0.0 options:UIViewAnimationOptionCurveEaseIn animations:^{
          self.view.frame = executerLogoOldPosition;
    } completion:nil];
    
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
