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
    // Do any additional setup after loading the view.
    
    NSLog(@"user profile %@", self.uberProfile);
    self.nameLabel.text = [NSString stringWithFormat:@"%@ %@", self.uberProfile[@"first_name"], self.uberProfile[@"last_name"]];
    

    
    self.tap = [[UITapGestureRecognizer alloc]initWithTarget: self action:@selector(syncCalendar:)];
    [self.syncCalendarView addGestureRecognizer:self.tap];

}

-(void)viewDidLayoutSubviews {
    self.profileImageView.layer.cornerRadius = self.profileImageView.frame.size.height/2;
    self.profileImageView.clipsToBounds = YES;
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

-(void)finishedWithAuth:(GTMOAuth2Authentication *)auth error:(NSError *)error {
    if (error) {
        NSLog(@"%@", error);
    } else {
        NSLog(@"%@", auth);
        NSString* serverCode = [GPPSignIn sharedInstance].homeServerAuthorizationCode;
        NSLog(@"server code%@", serverCode);
        AFHTTPRequestOperationManager* manager = [[AFHTTPRequestOperationManager alloc]init];
        NSString* url = [NSString stringWithFormat:@"@andelahack.herokuapp.com/calendar/callback?code=%@", serverCode];
        [manager GET:url parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
            NSLog(@"%@", responseObject);
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            NSLog(@"%@", error);
        }];
    }
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
