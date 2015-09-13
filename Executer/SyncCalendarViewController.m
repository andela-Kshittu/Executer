//
//  SyncCalendarViewController.m
//  Executer
//
//  Created by Ahmed Onawale on 8/6/15.
//  Copyright (c) 2015 Kehesjay. All rights reserved.
//

#import "SyncCalendarViewController.h"
#import <GoogleOpenSource/GoogleOpenSource.h>
#import <GooglePlus/GooglePlus.h>
#import <AFNetworking.h>
#import "CalendarEventsViewController.h"

@interface SyncCalendarViewController ()<GPPSignInDelegate, GIDSignInDelegate, GIDSignInUIDelegate>

@property(strong, nonatomic)UITapGestureRecognizer* tap;
@property(strong,  nonatomic)NSMutableArray* events;
@end
static NSString *const kServerClientID = @"453264479059-fc56k30fdhl07leahq5n489ct7ifk7md.apps.googleusercontent.com";
static NSString *const kClientID = @"453264479059-emgeqatjuamrrq04e84kn7bk6rc9kckq.apps.googleusercontent.com";
static NSString *const kClientSecret = @"Y4YbG7u_he6WGzKnCiUTsbtI";
static BOOL _isGoogleAuth = nil;
@implementation SyncCalendarViewController

+(BOOL)isGoogleAuth{
    if(_isGoogleAuth == nil){
        _isGoogleAuth = NO;
    }
    return _isGoogleAuth;
}
- (void)viewDidLoad {
    [super viewDidLoad];

    self.shareRideInnerView.layer.cornerRadius = 5;
    // Do any additional setup after loading the view.
    self.events = [[NSArray alloc]init];
    NSLog(@"user profile %@", self.uberProfile);
    self.nameLabel.text = [NSString stringWithFormat:@"%@ %@", self.uberProfile[@"first_name"], self.uberProfile[@"last_name"]];
    NSString* imgURL = self.uberProfile[@"picture"];
    
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    
    dispatch_async(queue, ^{
        NSData* imageData = [NSData dataWithContentsOfURL:[NSURL URLWithString:imgURL]];
                             dispatch_async(dispatch_get_main_queue(), ^{
            self.profileImageView.image = [UIImage imageWithData:imageData];
        });
    });
    
    self.tap = [[UITapGestureRecognizer alloc]initWithTarget: self action:@selector(syncCalendar:)];
    UITapGestureRecognizer *shareRideTap = [[UITapGestureRecognizer alloc]initWithTarget: self action:@selector(shareRide:)];
    
    [self.syncCalendarView addGestureRecognizer:self.tap];
    [self.shareRide addGestureRecognizer:shareRideTap];
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    self.navigationController.navigationBarHidden = YES;
}
-(void)viewDidLayoutSubviews {
    self.shareRide.layer.cornerRadius = 5;
    self.syncCalendarView.layer.cornerRadius = 5;
    self.profileImageView.layer.cornerRadius = self.profileImageView.frame.size.height/2;
    self.profileImageView.clipsToBounds = YES;
}

-(void) syncCalendar:(UITapGestureRecognizer*)sender {
    _isGoogleAuth = YES;
//    isGoogleAuth
    GIDSignIn *signIn = [GIDSignIn sharedInstance];
    [signIn signOut];
    signIn.delegate = self;
    signIn.uiDelegate = self;
    signIn.shouldFetchBasicProfile = NO;
    signIn.clientID = kClientID;
    signIn.serverClientID = kServerClientID;
    [signIn setScopes: [NSArray arrayWithObjects: @"https://www.googleapis.com/auth/calendar", @"https://www.googleapis.com/auth/calendar.readonly", nil]];
    [signIn setAllowsSignInWithBrowser:NO];
    [signIn setAllowsSignInWithWebView:YES];
    [signIn signIn];
}

-(void)signIn:(GIDSignIn *)signIn didSignInForUser:(GIDGoogleUser *)user withError:(NSError *)error {
    if (!error) {
        NSLog(@"google auth response %@", user);
        NSLog(@"server code%@", user.authentication.accessToken);
        NSDictionary *dataDict = @{@"access_token":user.authentication.accessToken};
        [self getGoogleEvents:dataDict completion:^{
            NSLog(@"Fetched google events");
            [self performSegueWithIdentifier:@"EventsList" sender:self.events];
        }];
    }
}

-(void) shareRide:(UITapGestureRecognizer*)sender {
//    [self performSegueWithIdentifier:@"ShareRide" sender:nil];

}

-(void)getGoogleEvents:(NSDictionary *)data completion:(void (^)(void))completionBlock{
    NSString* url = [NSString stringWithFormat:@"https://andelahack.herokuapp.com/%@/calendar",self.uberProfile[@"uuid"]];
    NSLog(@"post %@", data);
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    
    manager.responseSerializer = [AFJSONResponseSerializer serializerWithReadingOptions:NSJSONReadingAllowFragments];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    [manager POST:url parameters:data success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"JSON from sync calendar:  %@", responseObject);
        self.events = responseObject[@"response"];
        completionBlock();
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error from sync calendar: %@", error);
    }];
    
    
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"EventsList"]) {
        CalendarEventsViewController* controller = segue.destinationViewController;
        controller.calenderEvents = self.events;
        controller.uberProfile = self.uberProfile;
    }
}

@end
