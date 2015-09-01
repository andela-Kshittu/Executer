//
//  ViewController.m
//  Executer
//
//  Created by Kehinde Shittu on 8/6/15.
//  Copyright (c) 2015 Kehesjay. All rights reserved.
//

#import "ViewController.h"
#import "SyncCalendarViewController.h"
#import <AFNetworking.h>

@interface ViewController ()

@property(nonatomic,strong)NSDictionary* uberProfile;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.loginWithUber.layer.cornerRadius = 5;
    // Do any additional setup after loading the view, typically from a nib.
    self.uberProfile = [[NSDictionary alloc]init];
    UITapGestureRecognizer *tapAction = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(login:)];
    [self.loginWithUber addGestureRecognizer:tapAction];
//    [self callCientAuthenticationMethods];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(exchangeAccesstoken:) name:@"tokenRecieved" object:nil];
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    self.navigationController.navigationBarHidden = YES;
}
-(void)exchangeAccesstoken:(NSNotification *)notification{
    self.activityIndicatorView.hidden = YES;
    NSLog(@"exchange access token called %@",notification.userInfo[@"accessToken"]);
    [self sendAccessToken:notification.userInfo completion:^{
    
        NSLog(@"finished Auth process");
        [self performSegueWithIdentifier:@"mainPage" sender:self.uberProfile];
        
    }];

}


-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier  isEqual: @"mainPage"]) {
        SyncCalendarViewController* controller = segue.destinationViewController;
        controller.uberProfile = sender;
        NSLog(@"sender %@", sender);
        NSLog(@"controller %@", controller.uberProfile);
    }
}



- (void) callCientAuthenticationMethods
{
    UberKit *uberKit = [[UberKit alloc] initWithServerToken:@"WaxCkdTlaVFmB9Vf76q_buaTGqVad5ODrYX5S5h2"]; //Add your server token
    //[[UberKit sharedInstance] setServerToken:@"YOUR_SERVER_TOKEN"]; //Alternate initialization
    
    CLLocation *location = [[CLLocation alloc] initWithLatitude:37.7833 longitude:-122.4167];
    CLLocation *endLocation = [[CLLocation alloc] initWithLatitude:37.9 longitude:-122.43];
    
    [uberKit getProductsForLocation:location withCompletionHandler:^(NSArray *products, NSURLResponse *response, NSError *error)
     {
         if(!error)
         {
             UberProduct *product = [products objectAtIndex:0];
             NSLog(@"Product name of first %@", product.product_description);
         }
         else
         {
             NSLog(@"Error %@", error);
         }
     }];
    
    [uberKit getTimeForProductArrivalWithLocation:location withCompletionHandler:^(NSArray *times, NSURLResponse *response, NSError *error)
     {
         if(!error)
         {
             UberTime *time = [times objectAtIndex:0];
             NSLog(@"Time for first %f", time.estimate);
         }
         else
         {
             NSLog(@"Error %@", error);
         }
     }];
    
    [uberKit getPriceForTripWithStartLocation:location endLocation:endLocation  withCompletionHandler:^(NSArray *prices, NSURLResponse *response, NSError *error)
     {
         if(!error)
         {
             UberPrice *price = [prices objectAtIndex:0];
             NSLog(@"Price for first %i", price.lowEstimate);
         }
         else
         {
             NSLog(@"Error %@", error);
         }
     }];
    
    [uberKit getPromotionForLocation:location endLocation:endLocation withCompletionHandler:^(UberPromotion *promotion, NSURLResponse *response, NSError *error)
     {
         if(!error)
         {
             NSLog(@"Promotion - %@", promotion.localized_value);
         }
         else
         {
             NSLog(@"Error %@", error);
         }
     }];
}

- (void)login:(UITapGestureRecognizer *)sender
{
    self.loginWithUber.hidden = YES;
    self.activityIndicatorView.hidden = NO;
    
    [[UberKit sharedInstance] setClientID:@"rr2NzvHi69QJalUHz0ImU1KidoE1KGc5"];
    [[UberKit sharedInstance] setClientSecret:@"57am6kbYes-z2AP09g2IiQExJsZeracb0WIiu1Js"];
    [[UberKit sharedInstance] setRedirectURL:@"ExecuterV2://uber/callback"];
    [[UberKit sharedInstance] setApplicationName:@"andelahack"];
    //UberKit *uberKit = [[UberKit alloc] initWithClientID:@"YOUR_CLIENTID" ClientSecret:@"YOUR_CLIENT_SECRET" RedirectURL:@"YOUR_REDIRECT_URI" ApplicationName:@"YOUR_APPLICATION_NAME"]; // Alternate initialization
    UberKit *uberKit = [UberKit sharedInstance];
    uberKit.delegate = self;
    [uberKit startLogin];
}
-(void)sendAccessToken:(NSDictionary *)data completion:(void (^)(void))completionBlock{
    
    NSLog(@"post %@", data);
    
    
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
 
    manager.responseSerializer = [AFJSONResponseSerializer serializerWithReadingOptions:NSJSONReadingAllowFragments];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    [manager POST:@"https://andelahack.herokuapp.com/login" parameters:data success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"JSON from view controller:  %@", responseObject);
        self.uberProfile = responseObject[@"response"];
        completionBlock();
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error from view controller: %@", error);
        self.loginWithUber.hidden = NO;
        self.activityIndicatorView.hidden = YES;
    }];
    
    
}

- (void) uberKit:(UberKit *)uberKit didReceiveAccessToken:(NSString *)accessToken
{
    
    NSLog(@"Received access token %@", accessToken);
    if(accessToken)
    {
        [uberKit getUserActivityWithCompletionHandler:^(NSArray *activities, NSURLResponse *response, NSError *error)
         {
             if(!error)
             {
                 NSLog(@"User activity %@", activities);
                 UberActivity *activity = [activities objectAtIndex:0];
                 NSLog(@"Last trip distance %f", activity.distance);
             }
             else
             {
                 NSLog(@"Error %@", error);
             }
         }];
        
        [uberKit getUserProfileWithCompletionHandler:^(UberProfile *profile, NSURLResponse *response, NSError *error)
         {
             if(!error)
             {
                 NSLog(@"User's full name %@ %@", profile.first_name, profile.last_name);
             }
             else
             {
                 NSLog(@"Error %@", error);
             }
         }];
    }
    else
    {
        NSLog(@"No auth token, try again");
    }
}

- (void) uberKit:(UberKit *)uberKit loginFailedWithError:(NSError *)error
{
    NSLog(@"Error in login %@", error);
}





- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
