//
//  AppDelegate.m
//  Executer
//
//  Created by Kehinde Shittu on 8/6/15.
//  Copyright (c) 2015 Kehesjay. All rights reserved.
//

#import "AppDelegate.h"
#import "UberKit.h"
#import "SyncCalendarViewController.h"
#import <AFNetworking.h>
@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    UIUserNotificationType types = UIUserNotificationTypeBadge |
    UIUserNotificationTypeSound | UIUserNotificationTypeAlert;
    
    UIUserNotificationSettings *mySettings =
    [UIUserNotificationSettings settingsForTypes:types categories:nil];
    
    [[UIApplication sharedApplication] registerUserNotificationSettings:mySettings];
    
    [[UIApplication sharedApplication]registerForRemoteNotifications ];
    

    
//    NSDictionary *pushDic = [launchOptions objectForKey:@"UIApplicationLaunchOptionsLocalNotificationKey"];
//    if (pushDic != nil) {
//           NSLog(@" launched from Notification");
//    }
//    else {
//        NSLog(@"not launched from Notification");
//    }
    // Handle launching from a notification
    UILocalNotification *locationNotification = [launchOptions objectForKey:UIApplicationLaunchOptionsLocalNotificationKey];
    if (locationNotification) {
        // Set icon badge number to zero
           NSLog(@" launched from Notification");
    [[NSUserDefaults standardUserDefaults] setObject:locationNotification.userInfo forKey:@"eventData"];
    [[NSUserDefaults standardUserDefaults] synchronize];
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Reminder"
                                                        message:locationNotification.alertBody
                                                       delegate:self cancelButtonTitle:@"Cancel"
                                                  otherButtonTitles:@"OK", nil];
        [alert show];
       
            UIStoryboard *storyboard = self.window.rootViewController.storyboard;
            UIViewController *rootViewController = [storyboard instantiateViewControllerWithIdentifier:@"confirmationView"];
            self.window.rootViewController = rootViewController;
            [self.window makeKeyAndVisible];
        
        
    }else{
          NSLog(@"not launched from Notification");
        
    }
    return YES;
}
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if(buttonIndex == 0){
        NSDictionary* data = [[NSUserDefaults standardUserDefaults] objectForKey:@"eventData"];
        NSLog(@"firing reject with id %@",data);
        
       
        
        NSString* url = [NSString stringWithFormat:@"https://andelahack.herokuapp.com/users/%@/requests/%@",data[@"user_id"],data[@"request_id"]];
        
        AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
        manager.responseSerializer = [AFJSONResponseSerializer serializerWithReadingOptions:NSJSONReadingAllowFragments];
        manager.requestSerializer = [AFJSONRequestSerializer serializer];
        [manager DELETE:url parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
            NSLog(@"finished event booking cancellation %@", responseObject);
            
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            NSLog(@"Error finihing event booking cancellation: %@", error);
        }];
        
    }else{
    NSDictionary* data = [[NSUserDefaults standardUserDefaults] objectForKey:@"eventID"];
        NSLog(@"firing accept with id %@",data);
        NSDictionary * dict = @{@"request_id":data[@"request_id"]};
        
        NSString* url = [NSString stringWithFormat:@"https://andelahack.herokuapp.com/trips/%@",data[@"user_id"]];
  
        AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
        manager.responseSerializer = [AFJSONResponseSerializer serializerWithReadingOptions:NSJSONReadingAllowFragments];
        manager.requestSerializer = [AFJSONRequestSerializer serializer];
        [manager POST:url parameters:dict success:^(AFHTTPRequestOperation *operation, id responseObject) {
            NSLog(@"finished event booking confirmation %@", responseObject);

        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            NSLog(@"Error finihing event booking confirmation: %@", error);
        }];
    }
}

- (void)application:(UIApplication*)application
didReceiveLocalNotification:(UILocalNotification *)notification{
//    notification.userInfo
    NSLog(@"did receive local notification");
     NSLog(@"user info object %@", notification.userInfo);
    [[NSUserDefaults standardUserDefaults] setObject:notification.userInfo forKey:@"eventID"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Reminder"
                                                    message:notification.alertBody
                                                   delegate:self
                                          cancelButtonTitle:@"CANCEL"
                                          otherButtonTitles:@"OK", nil];
    [alert show];
    
};
- (BOOL) application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation
{
//    SyncCalendarViewController *controller = [[SyncCalendarViewController alloc]init];
    NSLog(@"is google :%d",[SyncCalendarViewController isGoogleAuth]);
    
    if([[UberKit sharedInstance] handleLoginRedirectFromUrl:url sourceApplication:sourceApplication] && ![SyncCalendarViewController isGoogleAuth])
    {
        NSLog(@"redirect url query is %@", url.query);
         NSLog(@"redirect url path is %@", url.path);
        NSLog(@"redirect url is %@", url.relativeString);
        [self getAuthTokenForCode:url.query];
        return YES;
    }
    else
    {
        return [GPPURLHandler handleURL:url sourceApplication:sourceApplication annotation:annotation];
    }
}
- (void) getAuthTokenForCode: (NSString *) code
{
     NSLog(@"this is old code: %@",code);
  NSRange range = NSMakeRange(0,5);
  code = [code stringByReplacingCharactersInRange:range withString:@""];
    NSLog(@"this is new code: %@",code);
  NSString *clientID =@"rr2NzvHi69QJalUHz0ImU1KidoE1KGc5";
  NSString *clientSecret = @"57am6kbYes-z2AP09g2IiQExJsZeracb0WIiu1Js";
  NSString *redirectURL = @"ExecuterV2://uber/callback";
    
    NSString *data = [NSString stringWithFormat:@"code=%@&client_id=%@&client_secret=%@&redirect_uri=%@&grant_type=authorization_code", code, clientID, clientSecret, redirectURL];
    NSString *url = [NSString stringWithFormat:@"https://login.uber.com/oauth/token"];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:url]];
    [request setHTTPMethod:@"POST"];
    [request setHTTPBody:[data dataUsingEncoding:NSUTF8StringEncoding]];
    
    NSURLResponse *response = nil;
    NSError *error = nil;
    NSData *authData = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
    if(!error)
    {
        NSError *jsonError = nil;
        NSDictionary *authDictionary = [NSJSONSerialization JSONObjectWithData:authData options:0 error:&jsonError];
        if(!jsonError)
        {
            NSString *accessToken = [authDictionary objectForKey:@"access_token"];
            if(accessToken)
            {
                NSLog(@"this is access token %@", authDictionary);
                [[NSNotificationCenter defaultCenter] postNotificationName:@"tokenRecieved" object:nil userInfo:@{@"access_token":accessToken}];
            }
        }
        else
        {
            NSLog(@"Error retrieving access token %@", jsonError);
        }
    }
    else
    {
        NSLog(@"Error in sending request for access token %@", error);
    }
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}
//-(BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation {
//    return [GPPURLHandler handleURL:url sourceApplication:sourceApplication annotation:annotation];
//}
@end
