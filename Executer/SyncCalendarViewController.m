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

@interface SyncCalendarViewController ()<GPPSignInDelegate>

@property(strong, nonatomic)UITapGestureRecognizer* tap;

@end
static NSString *const kServerClientID = @"453264479059-fc56k30fdhl07leahq5n489ct7ifk7md.apps.googleusercontent.com";
static NSString *const kClientID = @"453264479059-4dd6ctv0nk3ji2fuadnmt54hu6b0aboj.apps.googleusercontent.com";
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
    self.shareRide.layer.cornerRadius = 5;
    self.syncCalendarView.layer.cornerRadius = 5;
    // Do any additional setup after loading the view.
    self.tap = [[UITapGestureRecognizer alloc]initWithTarget: self action:@selector(syncCalendar:)];
    UITapGestureRecognizer *shareRideTap = [[UITapGestureRecognizer alloc]initWithTarget: self action:@selector(shareRide:)];
    
    [self.syncCalendarView addGestureRecognizer:self.tap];
    [self.shareRide addGestureRecognizer:shareRideTap];
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    self.navigationController.navigationBarHidden = YES;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void) syncCalendar:(UITapGestureRecognizer*)sender {
    _isGoogleAuth = YES;
//    isGoogleAuth
    GPPSignIn *signIn = [GPPSignIn sharedInstance];
    [signIn signOut];
    signIn.delegate = self;
    signIn.shouldFetchGooglePlusUser = YES;
    signIn.clientID = kClientID;
    signIn.homeServerClientID = kServerClientID;
    [signIn setScopes: [NSArray arrayWithObjects: @"https://www.googleapis.com/auth/calendar", @"https://www.googleapis.com/auth/calendar.readonly", nil]];
    [signIn setAttemptSSO:NO];
    [signIn authenticate];
}

-(void) shareRide:(UITapGestureRecognizer*)sender {
    [self performSegueWithIdentifier:@"ShareRide" sender:nil];

}
-(void)finishedWithAuth:(GTMOAuth2Authentication *)auth error:(NSError *)error {
    if (error) {
        NSLog(@" google auth error %@", error);
    } else {
        NSLog(@"google auth response %@", auth);
        NSLog(@"server code%@", auth.accessToken);
        NSDictionary *dataDict = @{@"access_token":auth.accessToken};
        [self getGoogleEvents:dataDict completion:^{
            NSLog(@"Fetched google events");
        }];

    }
}
-(void)getGoogleEvents:(NSDictionary *)data completion:(void (^)(void))completionBlock{
    
    NSLog(@"post %@", data);
    
    
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    
    manager.responseSerializer = [AFJSONResponseSerializer serializerWithReadingOptions:NSJSONReadingAllowFragments];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    [manager POST:@"https://andelahack.herokuapp.com/calendar" parameters:data success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"JSON from sync calendar:  %@", responseObject);
        completionBlock();
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error from sync calendar: %@", error);
    }];
    
    
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
