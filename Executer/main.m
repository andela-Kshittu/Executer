//
//  main.m
//  Executer
//
//  Created by Kehinde Shittu on 8/6/15.
//  Copyright (c) 2015 Kehesjay. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"
#import "GooglePlusOverride.h"

int main(int argc, char * argv[]) {
    @autoreleasepool {
        return UIApplicationMain(argc, argv, NSStringFromClass([GooglePlusOverride class]), NSStringFromClass([AppDelegate class]));
    }
}
