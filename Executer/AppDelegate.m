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

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    return YES;
}
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
