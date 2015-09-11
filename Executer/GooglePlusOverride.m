//
//  GooglePlusOverride.m
//  Executer
//
//  Created by Johnson Ejezie on 9/11/15.
//  Copyright (c) 2015 Kehesjay. All rights reserved.
//

#import "GooglePlusOverride.h"

@implementation GooglePlusOverride

- (BOOL)canOpenURL:(NSURL *)url
{
    if ([[url scheme] hasPrefix:@"com-google-gidconsent"] || [[url scheme] hasPrefix:@"com.google.gppconsent"]) {
        return NO;
    }
    return [super canOpenURL:url];
}

@end
